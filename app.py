from flask import Flask, render_template, request
from flask_mysqldb import MySQL

app = Flask(__name__)

app.config['MYSQL_HOST'] = "localhost"
app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = "Eireann32-"
app.config['MYSQL_DB'] = "stocktest"

mysql = MySQL(app)

@app.route('/', methods=['GET', 'POST'])
def index():
    print("Index route triggered")
    if request.method == 'POST':
        Drink_Name = request.form['Drink_Name']
        Drink_Type = request.form['Drink_Type']
        Drink_Serving_Size = request.form['Drink_Serving_Size']
        Bottle_Size = request.form['Bottle_Size']
        Drink_Price = request.form['Drink_Price']

        # Create a new database connection and cursor within the request context
        db_connection = mysql.connect()
        cursor = db_connection.cursor()

        # Execute the query
        cursor.execute("INSERT INTO Drink_List (Drink_Name, Drink_Type, Drink_Serving_Size, Bottle_Size, Drink_Price) VALUES (%s, %s, %s, %s, %s)", (Drink_Name, Drink_Type, Drink_Serving_Size, Bottle_Size, Drink_Price))

        # Commit the changes to the database
        db_connection.commit()

        # Close the cursor and connection
        cursor.close()
        db_connection.close()
        print(f"Recieved data: Drink_Name={Drink_Name}")
        return "success"

    return render_template("index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)