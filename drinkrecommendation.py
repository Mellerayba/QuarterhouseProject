import mysql.connector
from datetime import datetime

def get_recommended_drinks(food_recipe_id):
    # Connect to MySQL database
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Eireann32-",
        database="stocktest"
    )
    cursor = conn.cursor()

    # Function to fetch recommended drinks from the database for a given food recipe ID
    def fetch_recommended_drinks_from_db(cursor, food_recipe_id):
        query = """
            SELECT DrinkPair1ID, DrinkPair2ID, DrinkPair3ID, DrinkPair4ID, DrinkPair5ID, DrinkPair6ID, DrinkPair7ID, DrinkPair8ID, DrinkPair9ID 
            FROM Drink_Reccomend WHERE Food_RecipeID = %s
        """
        cursor.execute(query, (food_recipe_id,))
        row = cursor.fetchone()
        return [row[i] for i in range(9) if row[i] is not None]

    # Function to fetch stock information for a drink
    def fetch_stock_info(cursor, drink_id):
        query = "SELECT Drink_Count, Bottle_Size, Drink_Serving_Size FROM Drink_Stock JOIN Drink_List ON Drink_Stock.DrinkID = Drink_List.DrinkID WHERE Drink_Stock.DrinkID = %s"
        cursor.execute(query, (drink_id,))
        return cursor.fetchone()

    # Function to check if a drink is a cocktail and fetch its ingredients' stock levels
    def fetch_cocktail_ingredients_stock(cursor, drink_id):
        query = "SELECT dl.DrinkID, ds.Drink_Count, dl.Bottle_Size, dl.Drink_Serving_Size FROM Drink_Recipe_Link drl JOIN Drink_List dl ON drl.DrinkID = dl.DrinkID JOIN Drink_Stock ds ON dl.DrinkID = ds.DrinkID WHERE drl.Drink_RecipeID = %s"
        cursor.execute(query, (drink_id,))
        return cursor.fetchall()

    # Function to calculate average stock for cocktail ingredients
    def calculate_average_stock(ingredients_stock):
        if not ingredients_stock:
            return 0
        total_stock = 0
        for ingredient in ingredients_stock:
            drink_count, bottle_size, serving_size = ingredient[1], ingredient[2], ingredient[3]
            stock_value = drink_count * bottle_size // serving_size
            total_stock += stock_value
        return total_stock / len(ingredients_stock)

    # Merge sort algorithm to sort items based on scores
    def merge_sort(items):
        if len(items) > 1:
            mid = len(items) // 2
            left_half = items[:mid]
            right_half = items[mid:]

            merge_sort(left_half)
            merge_sort(right_half)

            i = j = k = 0

            while i < len(left_half) and j < len(right_half):
                if left_half[i][1] > right_half[j][1]:
                    items[k] = left_half[i]
                    i += 1
                else:
                    items[k] = right_half[j]
                    j += 1
                k += 1

            while i < len(left_half):
                items[k] = left_half[i]
                i += 1
                k += 1

            while j < len(right_half):
                items[k] = right_half[j]
                j += 1
                k += 1

        return items

    # Function to reverse the order of items using a stack
    def reverse_with_stack(items):
        stack = []
        for item in items:
            stack.append(item)  # Push item onto stack

        reversed_items = []
        while stack:
            reversed_items.append(stack.pop())  # Pop item from stack and append to reversed_items

        return reversed_items

    # Step 1: Fetch initial recommended drinks
    recommended_drinks = fetch_recommended_drinks_from_db(cursor, food_recipe_id)
    
    # Step 2: Initialize scores based on position in initial database
    initial_scores = [(recommended_drinks[i], 9 - i) for i in range(len(recommended_drinks))]

    # Step 3: Fetch stock information and calculate stock scores
    stock_scores = []
    for drink_id in recommended_drinks:
        # Check if the drink is a cocktail
        query = "SELECT COUNT(*) FROM Drink_Recipe WHERE Drink_RecipeID = %s"
        cursor.execute(query, (drink_id,))
        is_cocktail = cursor.fetchone()[0] > 0

        if is_cocktail:
            # Fetch the ingredients' stock levels and calculate the average
            ingredients_stock = fetch_cocktail_ingredients_stock(cursor, drink_id)
            avg_stock_score = calculate_average_stock(ingredients_stock)
        else:
            # Fetch the stock information for non-cocktails
            stock_info = fetch_stock_info(cursor, drink_id)
            if stock_info:
                drink_count, bottle_size, serving_size = stock_info
                avg_stock_score = drink_count * (bottle_size // serving_size)
            else:
                avg_stock_score = 0
        
        stock_scores.append((drink_id, avg_stock_score))

    # Step 4: Sort and assign scores for stock values
    sorted_stock_scores = merge_sort(stock_scores)
    reversed_stock_scores = reverse_with_stack(sorted_stock_scores)
    stock_scores = [(reversed_stock_scores[i][0], 9 - i) for i in range(len(reversed_stock_scores))]

    # Step 5: Calculate final scores
    final_scores = []
    for drink_id, _ in initial_scores:
        score_position = 0
        score_stock = 0

        for score in initial_scores:
            if score[0] == drink_id:
                score_position = score[1]
                break

        for score in stock_scores:
            if score[0] == drink_id:
                score_stock = score[1]
                break

        final_score = score_position + score_stock

        # Fetch drink type
        query = "SELECT Drink_Type FROM Drink_List WHERE DrinkID = %s"
        cursor.execute(query, (drink_id,))
        drink_type = cursor.fetchone()[0]

        # Additional adjustments based on time of day and season
        current_time = datetime.now()
        current_month = current_time.month
        current_hour = current_time.hour

        if current_month in [12, 1, 2]:  # Winter
            current_season = 'Winter'
        elif current_month in [3, 4, 5]:  # Spring
            current_season = 'Spring'
        elif current_month in [6, 7, 8]:  # Summer
            current_season = 'Summer'
        else:  # Autumn
            current_season = 'Autumn'
        print(current_season)
        print(current_hour)
        # Adjustments for Cocktails
        if drink_type in ['A', 'NA']:  # Cocktails
            if current_season in ['Spring', 'Summer']:
                final_score += 1
            elif current_season in ['Autumn', 'Winter']:
                final_score -= 1
            if 12 <= current_hour < 18:  # Afternoon
                final_score += 2
            elif 18 <= current_hour < 24:  # Evening
                final_score -= 2

        # Adjustments for Red and White Wines
        if drink_type == 'Red':  # Red Wines
            if current_season in ['Spring', 'Summer']:
                final_score -= 1
            elif current_season in ['Autumn', 'Winter']:
                final_score += 1
            if 18 <= current_hour < 24:  # Evening
                final_score += 2
            elif 12 <= current_hour < 18:  # Afternoon
                final_score -= 2

        if drink_type == 'White':  # White Wines
            if current_season in ['Spring', 'Summer']:
                final_score += 1
            elif current_season in ['Autumn', 'Winter']:
                final_score -= 1
            if 18 <= current_hour < 24:  # Evening
                final_score -= 2
            elif 12 <= current_hour < 18:  # Afternoon
                final_score += 2

        final_scores.append((drink_id, final_score))

    # Step 7: Sort final scores
    sorted_final_scores = merge_sort(final_scores)

    recommended_drinks = []
    for drink_id, score in sorted_final_scores:
        cursor.execute('SELECT Drink_Name FROM Drink_List WHERE DrinkID = %s', (drink_id,))
        drink_name = cursor.fetchone()[0]  # Fetch the first result - the drink name
        recommended_drinks.append((drink_name, score))

    cursor.close()
    conn.close()

    return recommended_drinks

if __name__ == '__main__':
    print(get_recommended_drinks(9))