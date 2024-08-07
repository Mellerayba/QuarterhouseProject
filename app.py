from datetime import datetime, timedelta
from MySQLdb import Error, connect
import MySQLdb
from flask import Flask, redirect, render_template, request, session, url_for, flash
from flask_mysqldb import MySQL
from flask_login import UserMixin, login_user, LoginManager, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from foodrecommendation import get_recommended_recipes
from drinkrecommendation import get_recommended_drinks
from predict_ingredient_needs import predict_ingredient_needs


app = Flask(__name__, static_folder='static')
app.secret_key = 'secretive key'


app.config['MYSQL_HOST'] = "localhost"
app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = "Eireann32-"
app.config['MYSQL_DB'] = "stocktest"

mysql = MySQL(app)



# Home page code


@app.route('/')

def home():
    return render_template('home.html')
@app.route('/menu')
def menu():
    return render_template('menu.html')
@app.route('/eveningmenu')
def eveningmenu():
    return render_template('eveningmenu.html')
@app.route('/winemenu')
def winemenu():
    return render_template('winemenu.html')

@app.route('/drinksmenu')
def drinksmenu():
    return render_template('drinksmenu.html')
#sub page code - test with database for now
@app.route('/userhome')
def userhome():
    return render_template('userhome.html')

@app.route('/managerhome')
def managerhome():
    return render_template('managerhome.html')


@app.route('/submit', methods=['GET', 'POST'])
def submit():

    if request.method == 'POST':
       
 


        Drink_Name = request.form['Drink_Name']
        Drink_Type = request.form['Drink_Type']
        Drink_Serving_Size = request.form['Drink_Serving_Size']
        Bottle_Size = request.form['Bottle_Size']
        Drink_Price = request.form['Drink_Price']

       

        # Create a cursor 
        
        cursor = mysql.connection.cursor()

        # Execute the query
        cursor.execute("INSERT INTO Drink_List (Drink_Name, Drink_Type, Drink_Serving_Size, Bottle_Size, Drink_Price) VALUES (%s, %s, %s, %s, %s)", (Drink_Name, Drink_Type, Drink_Serving_Size, Bottle_Size, Drink_Price))

        # Commit the changes to the database
        mysql.connection.commit()

        
        cursor.close()
        
        
        return "success"

    return render_template("submit.html")







@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        UserName = request.form.get('UserName')
        UserPassword = request.form.get('UserPassword')

        cursor = mysql.connection.cursor()
        
        try:
            cursor.execute("SELECT * FROM Users WHERE UserName = %s", (UserName,))
            result1 = cursor.fetchone()
            if result1:
                stored_password = result1[2]  
                if check_password_hash(stored_password, UserPassword):
                    cursor.execute("SELECT * FROM Managers WHERE UserName = %s", (UserName,))
                    result2 = cursor.fetchone()
                    if result2:  # If there is a result, user is a manager
                        session['manager_id'] = result2[0]
                        return redirect(url_for('managerhome'))
                    else:  # User is not a manager
                        return redirect(url_for('userhome'))
                else:
                    flash('Invalid password, try again', 'danger')
            else:
                flash('Invalid username, try again', 'danger')
        except (AttributeError, TypeError) as e:
            flash(f'An error occurred: {e}', 'danger')
        finally:
            cursor.close()
    return render_template('login.html')








@app.route('/manageusers', methods=['GET', 'POST'])
def manageusers():
    if request.method == 'POST':
        action = request.form.get('action')
        username = request.form.get('username')
        password = request.form.get('password')

        cursor = mysql.connection.cursor()
        if action == 'add':
            if username and password:
                hashed_password = generate_password_hash(password, method='pbkdf2:sha256')
                try:
                    cursor.execute("INSERT INTO Users (UserName, UserPassword) VALUES (%s, %s)", (username, hashed_password))
                    mysql.connection.commit()
                    flash('User added successfully!')
                except Exception as e:
                    mysql.connection.rollback()
                    flash('Error adding user')
            else:
                flash('Please provide both username and password.')
        elif action == 'remove':
            cursor.execute("DELETE FROM Users WHERE UserName = %s", [username])
            if cursor.rowcount > 0:
                mysql.connection.commit()
                flash('User removed successfully!')
            else:
                flash('User not found.')
        cursor.close()

    cursor = mysql.connection.cursor()
    cursor.execute("SELECT UserName FROM Users")
    users = cursor.fetchall() # logic for displaying the list of current users
    cursor.close()

    return render_template('manageusers.html', users=users)









class Dish:
    def __init__(self, dish_id, name, price):
        self.dish_id = dish_id  # Initializes the dish_id attribute
        self.name = name        # Initializes the name attribute
        self.price = price      # Initializes the price attribute

def fetch_dishes():
    try:
        cursor = mysql.connection.cursor()  # Creates a cursor object to interact with the database
        cursor.execute("SELECT Food_RecipeID, Food_RecipeName, Food_RecipePrice FROM Food_Recipe WHERE Food_RecipeType = 'Small Plate'") # Ensures we only take the main dishes as recommendations
        dishes = cursor.fetchall()  # Fetches all rows from the result of the query
        dish_objects = {dish[0]: Dish(dish[0], dish[1], dish[2]) for dish in dishes}  # Creates Dish objects and stores them in a dictionary
        cursor.close()
        return dish_objects  # Returns the dictionary of Dish objects
    except mysql.connection.Error as err:
        print(f"Error: {err}")
        return {}

@app.route('/recommendations', methods=['GET', 'POST'])
def recommendations():
    dishes = fetch_dishes()  # Fetches the dishes from the database

    if request.method == 'POST':  # Checks if the request method is POST
        selected_dish_id = int(request.form['dish_id'])  # Retrieves the selected dish ID from the form
        selected_dish = dishes.get(selected_dish_id)  # Retrieves the selected Dish object
        if not selected_dish:
            return "Dish not found", 404

        recommended_recipes = get_recommended_recipes(selected_dish_id)
        recommended_drinks = get_recommended_drinks(selected_dish_id)

        return render_template('recommendations.html', dish=selected_dish, recipes=recommended_recipes, drinks=recommended_drinks)  # Renders the recommendations template with the selected dish, recipe, and drink recommendations

    return render_template('select_dish.html', dishes=dishes.values())  # Renders the select_dish template with all dishes


























@app.route('/book', methods=['GET', 'POST'])
def book_table():
    if request.method == 'POST':
        # Collect data from the HTML form
        customer_surname = request.form['surname']
        booking_date = request.form['date']
        booking_time = request.form['time']
        duration = int(request.form['duration'])
        num_guests = int(request.form['guests'])
        
        # Store the data in a dictionary
        booking_info = {
            'surname': customer_surname,
            'booking_date': booking_date,
            'booking_time': booking_time,
            'duration': duration,
            'num_guests': num_guests
        }
        
        # Check availability and proceed with the booking
        available_tables, conflicting_bookings = check_availability(booking_info)
        if len(available_tables) > 0:
            table_id = available_tables[0][0]  # Get the first available table ID
            table_id, table_number = create_booking(booking_info, table_id)
            if table_id and table_number:
                return redirect(url_for('booking_success'))
            else:
                return render_template('booking_form.html', error='An error occurred while creating the booking.')
        else:
            return render_template('booking_form.html', error='No available tables for the selected time.', conflicting_bookings=conflicting_bookings)
    
    # Render the booking form if the request method is GET
    return render_template('booking_form.html')



def check_availability(booking_info):
    booking_date = booking_info['booking_date']
    booking_time = booking_info['booking_time']
    num_guests = booking_info['num_guests']
    duration = booking_info['duration']

    booking_datetime = f"{booking_date} {booking_time}"

    # Query to find available tables that meet the criteria
    query_available = """
        SELECT t.TableID, t.Capacity, t.TableNumber
        FROM Tables t
        WHERE t.Capacity >= %s
        AND t.TableID NOT IN (
            SELECT b.TableID
            FROM Bookings b
            WHERE b.BookingDateTime < DATE_ADD(%s, INTERVAL %s HOUR)
            AND DATE_ADD(b.BookingDateTime, INTERVAL b.Duration HOUR) > %s
            AND b.Status = 'Confirmed'
        )
        ORDER BY t.Capacity ASC
    """

    # Query to find conflicting bookings
    query_conflicting = """
        SELECT t.TableNumber, b.BookingDateTime, b.Duration
        FROM Bookings b
        JOIN Tables t ON b.TableID = t.TableID
        WHERE b.TableID IN (
            SELECT b.TableID
            FROM Bookings b
            WHERE b.BookingDateTime < DATE_ADD(%s, INTERVAL %s HOUR)
            AND DATE_ADD(b.BookingDateTime, INTERVAL b.Duration HOUR) > %s
            AND b.Status = 'Confirmed'
        )
    """

    try:
        cursor = mysql.connection.cursor()
        
        # Execute query to get available tables
        cursor.execute(query_available, (num_guests, booking_datetime, duration, booking_datetime))
        available_tables = cursor.fetchall()
        
        # Execute query to get conflicting bookings
        cursor.execute(query_conflicting, (booking_datetime, duration, booking_datetime))
        conflicting_bookings = cursor.fetchall()
        
        cursor.close()
        return available_tables, conflicting_bookings
    except MySQLdb.Error as e:
        print(f"Error while connecting to MySQL: {e}")
        return [], []



def create_booking(booking_info, table_id):
    customer_surname = booking_info['surname']
    booking_date = booking_info['booking_date']
    booking_time = booking_info['booking_time']
    duration = booking_info['duration']

    booking_datetime = f"{booking_date} {booking_time}"

    try:
        cursor = mysql.connection.cursor()

        # Check if the customer already exists
        query = "SELECT CustomerID FROM Customers WHERE Surname = %s"
        cursor.execute(query, (customer_surname,))
        result = cursor.fetchone()

        if result:
            customer_id = result[0]
        else:
            # Insert a new customer record if the customer does not exist
            insert_query = "INSERT INTO Customers (Surname) VALUES (%s)"
            cursor.execute(insert_query, (customer_surname,))
            mysql.connection.commit()
            # Get the ID of the newly inserted customer
            customer_id = cursor.lastrowid

        # Get the table number for the given table ID
        cursor.execute("SELECT TableNumber FROM Tables WHERE TableID = %s", (table_id,))
        result = cursor.fetchone()
        if result:
            table_number = result[0]
        else:
            raise Exception("Table ID not found.")

        # Insert the booking into the database using a parameterized query
        insert_query = """
            INSERT INTO Bookings (CustomerID, TableID, BookingDateTime, Duration, Status)
            VALUES (%s, %s, %s, %s, 'Confirmed')
        """
        cursor.execute(insert_query, (customer_id, table_id, booking_datetime, duration))
        mysql.connection.commit()  # Commit the transaction

        # Close the cursor
        cursor.close()

        return table_id, table_number

    except MySQLdb.Error as e:
        # Print any MySQL errors encountered
        print(f"Error while connecting to MySQL: {e}")
        return None, None
    except Exception as e:
        # Print any other exceptions
        print(e)
        return None, None

@app.route('/booking_success')
def booking_success():
    return "Booking Successful!"  # Display a success message






@app.route('/manage_bookings', methods=['GET', 'POST'])
def manage_bookings():
    if request.method == 'POST':
        # Get the selected date from the form
        selected_date = request.form['date']
        
        # Retrieve all bookings for the selected date
        bookings = get_bookings_by_date(selected_date)
        
        # Render the manage bookings template with the bookings
        return render_template('managebookings.html', bookings=bookings, selected_date=selected_date)
    
    # If GET request, render the manage bookings template without bookings
    return render_template('managebookings.html')

def get_bookings_by_date(date):
    query = """
        SELECT b.BookingID, c.Surname, t.TableNumber, b.BookingDateTime, b.Duration, b.Status
        FROM Bookings b
        JOIN Customers c ON b.CustomerID = c.CustomerID
        JOIN Tables t ON b.TableID = t.TableID
        WHERE DATE(b.BookingDateTime) = %s
    """
    try:
        cursor = mysql.connection.cursor()
        cursor.execute(query, (date,))
        bookings = cursor.fetchall()
        cursor.close()
        return bookings
    except MySQLdb.Error as e:
        print(f"Error while connecting to MySQL: {e}")
        return []

@app.route('/add_booking', methods=['POST'])
def add_booking():
    # Collect data from the form
    customer_surname = request.form['surname']
    booking_date = request.form['date']
    booking_time = request.form['time']
    duration = int(request.form['duration'])
    num_guests = int(request.form['guests'])
    
    # Store the data in a dictionary
    booking_info = {
        'surname': customer_surname,
        'booking_date': booking_date,
        'booking_time': booking_time,
        'duration': duration,
        'num_guests': num_guests
    }
    
    # Check availability and proceed with the booking
    available_tables = check_availability(booking_info)[0]
    if len(available_tables) > 0:
        table_id = available_tables[0][0]  # Get the first available table ID
        table_id, table_number = create_booking(booking_info, table_id)
        if table_id and table_number:
            # Retrieve updated bookings for the same date to display
            bookings = get_bookings_by_date(booking_info['booking_date'])
            return render_template('managebookings.html', bookings=bookings, selected_date=booking_info['booking_date'], success=f"Booking added successfully to Table {table_number}")
        else:
            return render_template('managebookings.html', error='An error occurred while creating the booking.')
    else:
        return render_template('managebookings.html', error='No available tables for the selected time.')



@app.route('/delete_booking/<int:booking_id>', methods=['POST'])
def delete_booking(booking_id):
    try:
        cursor = mysql.connection.cursor()
        delete_query = "DELETE FROM Bookings WHERE BookingID = %s"
        cursor.execute(delete_query, (booking_id,))
        mysql.connection.commit()
        cursor.close()
        return redirect(url_for('manage_bookings', success='Booking deleted successfully.'))
    except MySQLdb.Error as e:
        print(f"Error while connecting to MySQL: {e}")
        return redirect(url_for('manage_bookings', error='An error occurred while deleting the booking.'))



@app.route('/send_message', methods=['GET', 'POST'])
def send_message():
    if request.method == 'POST':
  
        title = request.form['title']
        body = request.form['body']
    
        cursor = mysql.connection.cursor()
        
        query = "INSERT INTO Messages (Title, Body) VALUES (%s, %s)"
        cursor.execute(query, (title, body))
        mysql.connection.commit()
        
        cursor.close()
        
    
    return render_template('send_message.html')

# Route to view messages for staff
@app.route('/staffmessages')
def staffmessages():
    cursor = mysql.connection.cursor()
    
    query = """
    SELECT m.Title, m.Body, m.CreatedAt
    FROM Messages m
    ORDER BY m.CreatedAt DESC
    """
    cursor.execute(query)
    messages = cursor.fetchall()
    
    cursor.close()
    
    return render_template('staffmessages.html', messages=messages)



@app.route('/new_order', methods=['GET', 'POST'])
def new_order():
    cursor = mysql.connection.cursor()
    
    if request.method == 'POST':
        table_id = request.form['table_id']
        food_items = request.form.getlist('food_items[]')
        food_quantities = request.form.getlist('food_quantities[]')
        drink_items = request.form.getlist('drink_items[]')
        drink_quantities = request.form.getlist('drink_quantities[]')
        
        # Insert into Orders table
        cursor.execute("INSERT INTO Orders (TableID, OrderDateTime) VALUES (%s, %s)", 
                       (table_id, datetime.now()))
        order_id = cursor.lastrowid
        
        # Insert food items into OrderItems table
        for i in range(len(food_items)):
            food_id = food_items[i]
            quantity = food_quantities[i]
            if quantity:  # Only insert if quantity is provided
                cursor.execute("INSERT INTO OrderItems (OrderID, FoodRecipeID, DrinkID, Quantity) VALUES (%s, %s, %s, %s)", 
                               (order_id, food_id, None, quantity))
        
        # Insert drink items into OrderItems table
        for i in range(len(drink_items)):
            drink_id = drink_items[i]
            quantity = drink_quantities[i]
            if quantity:  # Only insert if quantity is provided
                cursor.execute("INSERT INTO OrderItems (OrderID, FoodRecipeID, DrinkID, Quantity) VALUES (%s, %s, %s, %s)", 
                               (order_id, None, drink_id, quantity))
        
        mysql.connection.commit()
        cursor.close()
        update_ingredient_usage(order_id)
        predict_ingredient_needs(order_id)
        return redirect(url_for('new_order'))
    
    # Fetch tables, foods, and drinks
    cursor.execute("SELECT TableID, TableNumber FROM Tables")
    tables = cursor.fetchall()
    
    cursor.execute("SELECT Food_RecipeID, Food_RecipeName FROM Food_Recipe")
    foods = cursor.fetchall()
    
    cursor.execute("SELECT DrinkID, Drink_Name FROM Drink_List")
    drinks = cursor.fetchall()
    
    cursor.close()
    
    return render_template('new_order.html', tables=tables, foods=foods, drinks=drinks)




@app.route('/view_orders', methods=['GET', 'POST'])
def view_orders():
    current_date = datetime.now().date() # Get all bookings from current date
    query = """
        SELECT o.OrderID, o.OrderDateTime, o.TableID
        FROM Orders o
        WHERE DATE(o.OrderDateTime) = %s
    """
    try:
        cursor = mysql.connection.cursor()
        cursor.execute(query, (current_date,))
        orders = cursor.fetchall()

        detailed_orders = []
        for order in orders:
            order_id, order_datetime, table_id = order
            cursor.execute("""
                SELECT c.Surname, b.BookingDateTime, b.Duration
                FROM Bookings b
                JOIN Customers c ON b.CustomerID = c.CustomerID
                WHERE b.TableID = %s
                AND b.BookingDateTime <= %s
                AND DATE_ADD(b.BookingDateTime, INTERVAL b.Duration HOUR) > %s
            """, (table_id, order_datetime, order_datetime))
            customer_result = cursor.fetchone()
            customer_surname = customer_result[0] if customer_result else 'Unknown' # Catch error of no surname provided

            detailed_orders.append({
                'order_id': order_id,
                'order_datetime': order_datetime,
                'table_id': table_id,
                'customer_surname': customer_surname
            })

        cursor.close()
        return render_template('view_orders.html', orders=detailed_orders)
    except MySQLdb.Error as e:
        print(f"Error while connecting to MySQL: {e}")
        return render_template('view_orders.html', orders=[])

@app.route('/delete_order/<int:order_id>', methods=['POST'])
def delete_order(order_id):
    try:
        cursor = mysql.connection.cursor()
        delete_orderitems_query = "DELETE FROM OrderItems WHERE OrderID = %s"
        delete_order_query = "DELETE FROM Orders WHERE OrderID = %s"
        cursor.execute(delete_orderitems_query, (order_id,))
        cursor.execute(delete_order_query, (order_id,))
        mysql.connection.commit()
        cursor.close()
        return redirect(url_for('view_orders'))
    except MySQLdb.Error as e:
        print(f"Error while connecting to MySQL: {e}")
        return redirect(url_for('view_orders'))


@app.route('/view_order_details/<int:order_id>', methods=['GET'])
def view_order_details(order_id):
    query = """
        SELECT COALESCE(f.Food_RecipeName, ''), COALESCE(d.Drink_Name, ''), oi.Quantity
        FROM OrderItems oi
        LEFT JOIN Food_Recipe f ON oi.FoodRecipeID = f.Food_RecipeID
        LEFT JOIN Drink_List d ON oi.DrinkID = d.DrinkID
        WHERE oi.OrderID = %s
    """
    try:
        cursor = mysql.connection.cursor()
        cursor.execute(query, (order_id,))
        order_details = cursor.fetchall()
        cursor.close()
        return render_template('order_details.html', order_details=order_details)
    except MySQLdb.Error as e:
        print(f"Error while connecting to MySQL: {e}")
        return render_template('order_details.html', order_details=[])





def update_ingredient_usage(order_id):
    cursor = mysql.connection.cursor()

    # Fetch all food and drink items in the order
    query = """
        SELECT f.Food_RecipeID, d.DrinkID, oi.Quantity
        FROM OrderItems oi
        LEFT JOIN Food_Recipe f ON oi.FoodRecipeID = f.Food_RecipeID
        LEFT JOIN Drink_List d ON oi.DrinkID = d.DrinkID
        WHERE oi.OrderID = %s
    """
    cursor.execute(query, (order_id,))
    items = cursor.fetchall()

    for item in items:
        food_recipeid, drink_id, quantity = item



        # If it's a food item
        if food_recipeid:
            cursor.execute("SELECT FoodID FROM Food_Recipe_Link WHERE Food_RecipeID = %s", (food_recipeid,))

            foodlist = cursor.fetchall()
            for win in foodlist:
                cursor.execute("SELECT Food_Base_Size, Food_Serving_Size FROM Food_List WHERE FoodId = %s", (win,))
                base_size, serving_size = cursor.fetchone()

                if base_size != serving_size:
                    for _ in range(quantity):
                        cursor.execute("SELECT UsageCount FROM FoodIngredientUsage WHERE FoodIngredientID = %s", (win,))
                        result = cursor.fetchone()
                        if result:
                            usage_count = result[0] + 1
                            cursor.execute("UPDATE FoodIngredientUsage SET UsageCount = %s WHERE FoodIngredientID = %s", (usage_count, win))

                        cursor.execute("SELECT UsageCount FROM FoodIngredientUsage WHERE FoodIngredientID = %s", (win,))
                        updated_count = cursor.fetchone()[0]

                        if updated_count >= base_size:
                            cursor.execute("UPDATE Food_Stock SET Food_Count = Food_Count - 1 WHERE FoodId = %s", (win,))
                            cursor.execute("UPDATE FoodIngredientUsage SET UsageCount = 0 WHERE FoodIngredientID = %s", (win,))
                else:
                    cursor.execute("UPDATE Food_Stock SET Food_Count = Food_Count - %s WHERE FoodId = %s", (quantity, win))

        # If it's a drink item
        if drink_id:
            cursor.execute("SELECT Bottle_Size, Drink_Serving_Size, Drink_Type FROM Drink_List WHERE DrinkID = %s", (drink_id,))
            base_size, serving_size, drink_type = cursor.fetchone()

            if base_size != serving_size:
                for _ in range(quantity):
                    cursor.execute("SELECT UsageCount FROM DrinkIngredientUsage WHERE DrinkIngredientID = %s", (drink_id,))
                    result = cursor.fetchone()
                    if result:
                        usage_count = result[0] + serving_size
                        cursor.execute("UPDATE DrinkIngredientUsage SET UsageCount = %s WHERE DrinkIngredientID = %s", (usage_count, drink_id))
                    cursor.execute("SELECT UsageCount FROM DrinkIngredientUsage WHERE DrinkIngredientID = %s", (drink_id,))
                    updated_count = cursor.fetchone()[0]

                    if updated_count >= base_size:
                        cursor.execute("UPDATE Drink_Stock SET Drink_Count = Drink_Count - 1 WHERE DrinkID = %s", (drink_id,))
                        cursor.execute("UPDATE DrinkIngredientUsage SET UsageCount = 0 WHERE DrinkIngredientID = %s", (drink_id,))
            else:
                cursor.execute("UPDATE Drink_Stock SET Drink_Count = Drink_Count - %s WHERE DrinkID = %s", (quantity, drink_id))

            # Check if the drink is a cocktail based on its type
            if drink_type in ['A', 'NA']:
                cursor.execute("SELECT DrinkID, Drink_Ingredient_Quantity FROM Drink_Recipe_Link WHERE Drink_RecipeID = %s", (drink_id,))
                ingredients = cursor.fetchall()
                for ingredient in ingredients:
                    ingredient_id, ingredient_quantity = ingredient
                    cursor.execute("SELECT Drink_Base_Size, Drink_Serving_Size FROM Drink_List WHERE DrinkID = %s", (ingredient_id,))
                    base_size, serving_size = cursor.fetchone()
                    
                    if base_size == serving_size:
                        # Directly decrease stock if base size equals serving size
                        cursor.execute("UPDATE Drink_Stock SET Drink_Count = Drink_Count - 1 WHERE DrinkID = %s", 
                                       (ingredient_id))
                    else:
                        # Increment usage count
                        for _ in range(quantity * ingredient_quantity):
                            cursor.execute("SELECT UsageCount FROM DrinkIngredientUsage WHERE DrinkIngredientID = %s", (ingredient_id,))
                            result = cursor.fetchone()
                            if result:
                                usage_count = result[0] + serving_size
                                cursor.execute("UPDATE DrinkIngredientUsage SET UsageCount = %s WHERE DrinkIngredientID = %s", (usage_count, ingredient_id))

                            cursor.execute("SELECT UsageCount FROM DrinkIngredientUsage WHERE DrinkIngredientID = %s", (ingredient_id,))
                            updated_count = cursor.fetchone()[0]

                            if updated_count >= base_size:
                                cursor.execute("UPDATE Drink_Stock SET Drink_Count = Drink_Count - 1 WHERE DrinkID = %s", (ingredient_id,))
                                cursor.execute("UPDATE DrinkIngredientUsage SET UsageCount = 0 WHERE DrinkIngredientID = %s", (ingredient_id,))

    mysql.connection.commit()
    cursor.close()




@app.route('/manager_messages')
def manager_messages():
    cursor = mysql.connection.cursor()
    
    # Fetch manager messages from the database
    query = """
        SELECT MessageID, Title, Body, CreatedAt
        FROM ManagerMessages
        ORDER BY CreatedAt DESC
    """
    cursor.execute(query)
    messages = cursor.fetchall()
    if request.method == 'POST':
        # Delete the selected message
        message_id = request.form['message_id']
        delete_query = "DELETE FROM ManagerMessages WHERE MessageID = %s"
        cursor.execute(delete_query, (message_id,))
        mysql.connection.commit()
    cursor.close()
    
    # Render the template with the fetched messages
    return render_template('manager_messages.html', messages=messages)

@app.route('/manage_messages', methods=['GET', 'POST'])
def manage_messages():
    cursor = mysql.connection.cursor()
    
    if request.method == 'POST':
        # Delete the selected message
        message_id = request.form['message_id']
        delete_query = "DELETE FROM Messages WHERE MessageID = %s"
        cursor.execute(delete_query, (message_id,))
        mysql.connection.commit()
    
    # Fetch updated list messages
    query = """
        SELECT MessageID, Title, Body, CreatedAt
        FROM Messages
        ORDER BY CreatedAt DESC
    """
    cursor.execute(query)
    messages = cursor.fetchall()
    
    cursor.close()
    
    # Render the template with the fetched messages
    return render_template('manage_messages.html', messages=messages)



@app.route('/manage_stock', methods=['GET', 'POST'])
def manage_stock():
    cursor = mysql.connection.cursor()
    
    if request.method == 'POST':
        # Update stock levels based on form input
        item_id = request.form['item_id']
        new_count = request.form['new_count']
        item_type = request.form['item_type']
        
        if item_type == 'food':
            cursor.execute("UPDATE Food_Stock SET Food_Count = %s WHERE FoodId = %s", (new_count, item_id))
        elif item_type == 'drink':
            cursor.execute("UPDATE Drink_Stock SET Drink_Count = %s WHERE DrinkID = %s", (new_count, item_id))
        mysql.connection.commit()
    
    # Fetch food stock information
    food_query = """
        SELECT fs.FoodId, fl.Food_Name, fs.Food_Count, fl.Food_Base_Size, fl.Food_Serving_Size
        FROM Food_Stock fs
        JOIN Food_List fl ON fs.FoodId = fl.FoodId
    """
    cursor.execute(food_query)
    food_stock_info = cursor.fetchall()
    
    food_stock_details = []
    for item in food_stock_info:
        food_id, food_name, food_count, food_base_size, food_serving_size = item
        dishes_can_be_made = (food_count * food_base_size) // food_serving_size
        food_stock_details.append((food_id, food_name, food_count, food_base_size, food_serving_size, dishes_can_be_made))
    
    # Fetch drink stock information
    drink_query = """
        SELECT ds.DrinkID, dl.Drink_Name, ds.Drink_Count, dl.Bottle_Size, dl.Drink_Serving_Size
        FROM Drink_Stock ds
        JOIN Drink_List dl ON ds.DrinkID = dl.DrinkID
    """
    cursor.execute(drink_query)
    drink_stock_info = cursor.fetchall()
    
    drink_stock_details = []
    for item in drink_stock_info:
        drink_id, drink_name, drink_count, bottle_size, serving_size = item
        servings_can_be_made = (drink_count * bottle_size) // serving_size
        drink_stock_details.append((drink_id, drink_name, drink_count, bottle_size, serving_size, servings_can_be_made))
    
    cursor.close()
    
    return render_template('manage_stock.html', food_stock_details=food_stock_details, drink_stock_details=drink_stock_details)



if __name__ == "__main__":
    
    app.run(host="0.0.0.0", port=5000)






