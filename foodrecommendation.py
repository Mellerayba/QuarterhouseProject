import mysql.connector
from datetime import datetime, timedelta

def get_recommended_recipes(food_recipe_id):
    # Connect to MySQL database
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Eireann32-",
        database="stocktest"
    )
    cursor = conn.cursor()

    # Function to fetch recommended recipes from the database
    def fetch_recommended_recipes_from_db(cursor, food_recipe_id):
        query = "SELECT Pair1ID, Pair2ID, Pair3ID, Pair4ID, Pair5ID, Pair6ID FROM Recipe_Recipe_Link WHERE Food_RecipeID = %s"
        cursor.execute(query, (food_recipe_id,))
        row = cursor.fetchone()
        return [row[i] for i in range(6) if row[i] is not None]

    # Function to fetch ingredients for a given recipe
    def fetch_ingredients_for_recipe(cursor, recipe_id):
        query = "SELECT FoodID FROM Food_Recipe_Link WHERE Food_RecipeID = %s"
        cursor.execute(query, (recipe_id,))
        return [row[0] for row in cursor.fetchall()]

    # Function to fetch stock information for an ingredient
    def fetch_stock_info(cursor, ingredient_id):
        query = "SELECT Food_Count, Food_Base_Size, Food_Expiratory_Date FROM Food_Stock JOIN Food_List ON Food_Stock.FoodId = Food_List.FoodId WHERE Food_Stock.FoodId = %s"
        cursor.execute(query, (ingredient_id,))
        return cursor.fetchone()

    # Function to calculate the number of days until an ingredient expires
    def calculate_days_until_expiry(expiration_date):
        today = datetime.now().date()
        delta = expiration_date - today
        return delta.days

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

    # Step 1: Fetch initial recommended recipes
    recommended_recipes = fetch_recommended_recipes_from_db(cursor, food_recipe_id)
    
    # Step 2: Initialize scores based on position in initial database
    initial_scores = {}
    for i in range(len(recommended_recipes)):
        initial_scores[recommended_recipes[i]] = 6 - i

    # Step 3: Fetch ingredients and calculate stock and expiration scores
    stock_scores = {}
    expiration_scores = {}
    
    for rec_id in recommended_recipes:
        ingredients = fetch_ingredients_for_recipe(cursor, rec_id)
        stock_values = []
        expiration_values = []

        for ingredient_id in ingredients:
            stock_info = fetch_stock_info(cursor, ingredient_id)
            if stock_info:
                food_count, base_size, expiration_date = stock_info
                stock_value = food_count * base_size
                days_until_expiry = calculate_days_until_expiry(expiration_date)
                stock_values.append(stock_value)
                expiration_values.append(days_until_expiry)

        # Calculate the average score for stock and expiration
        if stock_values:
            avg_stock_score = sum(stock_values) / len(stock_values)
        else:
            avg_stock_score = 0
        
        if expiration_values:
            avg_expiration_score = sum(expiration_values) / len(expiration_values)
        else:
            avg_expiration_score = 0

        # Calculate stock score where higher stock levels result in higher scores
        stock_scores[rec_id] = avg_stock_score
        expiration_scores[rec_id] = avg_expiration_score

    # Step 4: Sort and assign scores for stock values
    stock_scores_list = list(stock_scores.items())
    sorted_stock_scores = merge_sort(stock_scores_list)
    
    for i in range(len(sorted_stock_scores)):
        rec_id = sorted_stock_scores[i][0]
        stock_scores[rec_id] = i + 1

    # Step 5: Sort and assign scores for expiration values
    expiration_scores_list = list(expiration_scores.items())
    sorted_expiration_scores = merge_sort(expiration_scores_list)
    
    for i in range(len(sorted_expiration_scores)):
        rec_id = sorted_expiration_scores[i][0]
        expiration_scores[rec_id] = i + 1

    # Step 6: Calculate final scores
    final_scores = {}
    for rec_id in recommended_recipes:
        final_score = initial_scores[rec_id] + stock_scores[rec_id] + expiration_scores[rec_id]
        final_scores[rec_id] = final_score

    # Step 7: Sort final scores
    final_scores_list = list(final_scores.items())
    sorted_final_scores = merge_sort(final_scores_list)

    recommended_recipes = []
    for recipe_id, score in sorted_final_scores:
        cursor.execute('SELECT Food_RecipeName FROM Food_Recipe WHERE Food_RecipeID = %s', (recipe_id,))
        recipename = cursor.fetchone()[0]  # Fetch the first result - the recipe name
        recommended_recipes.append((recipename, score))

    cursor.close()
    conn.close()

    return recommended_recipes

# Example usage
food_recipe_id = 9
recommended_recipes = get_recommended_recipes(food_recipe_id)

for recipe_name, score in recommended_recipes:
    print(f"Recipe Name: {recipe_name}, Score: {score}")
