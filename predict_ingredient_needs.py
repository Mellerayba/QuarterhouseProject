import mysql.connector
from datetime import datetime, timedelta

def predict_ingredient_needs(order_id):
    from app import send_message
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Eireann32-",
        database="stocktest"
    )
    cursor = conn.cursor()

    # Fetch all food items in the order
    query = """
        SELECT f.Food_RecipeID
        FROM OrderItems oi
        LEFT JOIN Food_Recipe f ON oi.FoodRecipeID = f.Food_RecipeID
        WHERE oi.OrderID = %s
    """
    cursor.execute(query, (order_id,))
    items = cursor.fetchall()


    for item in items:
        food_recipe_id = item[0]
        cursor.execute("SELECT FoodID FROM Food_Recipe_Link WHERE Food_RecipeID = %s", (food_recipe_id,))
        ingredients = cursor.fetchall()
        for ingredient in ingredients:
            ingredient_id = ingredient[0]
            cursor.execute("SELECT Probability FROM Food_Recipe WHERE Food_RecipeID = %s", (food_recipe_id,))
            probability = cursor.fetchone()[0]

            cursor.execute("SELECT Food_Expiratory_Date FROM Food_Stock WHERE FoodId = %s", (ingredient_id,))
            expiration_date_result = cursor.fetchone()

            if expiration_date_result and expiration_date_result[0]:
                expiration_date = expiration_date_result[0]
                days_until_expiry = (expiration_date - datetime.now().date()).days
                if days_until_expiry > 0:
                    expected_customers = 1000 * days_until_expiry // 7
                    expected_orders = expected_customers * probability

                    # Calculate total needed
                    total_needed = expected_orders

                    # Fetch current stock information
                    cursor.execute("""
                        SELECT fl.FoodId, fl.Food_Name, fs.Food_Count, fl.Food_Base_Size
                        FROM Food_List fl
                        JOIN Food_Stock fs ON fl.FoodId = fs.FoodId
                        WHERE fl.FoodId = %s
                    """, (ingredient_id,))
                    ingredient_stock = cursor.fetchone()

                    if ingredient_stock:
                        food_id, food_name, food_count, food_base_size = ingredient_stock
                        in_stock = food_count * food_base_size
                        query = """
                                    SELECT fr.Food_RecipeName
                                    FROM Food_Recipe fr
                                    JOIN Food_Recipe_Link frl ON fr.Food_RecipeID = frl.Food_RecipeID
                                    WHERE frl.FoodID = %s
                                """
                        cursor.execute(query, (food_id,))
                        dish = cursor.fetchall()
                        dishlist = []
                        for dish in dish:
                            dishlist.append(dish[0])
                        if total_needed > (in_stock + 50):
                            title = "Stock Alert: Too Little"
                            body = f"Expected not enough of {food_name}. Expected: {total_needed}, In stock: {in_stock}, Consider raising the price of {dishlist}"
                            cursor.execute("INSERT INTO ManagerMessages (Title, Body) VALUES (%s, %s)", (title, body))
                        elif total_needed < (in_stock - 50):
                            title = "Stock Alert: Too Much"
                            body = f"Expected excess of {food_name}. Expected: {total_needed}, In stock: {in_stock}, Consider lowering the price of {dishlist}"
                            cursor.execute("INSERT INTO ManagerMessages (Title, Body) VALUES (%s, %s)", (title, body))

                    conn.commit()                            


    cursor.close()
    conn.close()

if __name__ == "__main__":
    predict_ingredient_needs(order_id=16)

