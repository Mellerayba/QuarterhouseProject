import mysql.connector

class PriceAdjustment:
    def __init__(self, connect, cursor):
        self.connect = connect
        self.cursor = cursor

    def adjust_price(self, DrinkID):
        Drink_Price, Drink_Count = self.get_count_price(DrinkID)
        Drink_Count = int(Drink_Count)
        Drink_Price = int(Drink_Price)

        if Drink_Count < 5:
            NewPrice = Drink_Price * 8 / 10 # current function for changing drink price 
            NewPrice = str(NewPrice)

            query = f"UPDATE Drink_List SET Drink_Price={NewPrice} WHERE DrinkID={DrinkID}"
            self.cursor.execute(query)

    def get_count_price(self, DrinkID):
        DrinkID = str(DrinkID)
        query1 = f"SELECT Drink_Price FROM Drink_List WHERE DrinkID={DrinkID}"
        self.cursor.execute(query1)
        result1 = self.cursor.fetchone()
        Drink_Price = result1[0]

        query2 = f"SELECT Drink_Count FROM Drink_Stock WHERE DrinkID={DrinkID}"
        self.cursor.execute(query2)
        result2 = self.cursor.fetchone()
        Drink_Stock = result2[0]

        return Drink_Price, Drink_Stock

def main(DrinkID):
    db_config = {
        "host": "localhost",
        "user": "root",
        "password": "Eireann32-",
        "database": "stocktest"
    }

    connect = mysql.connector.connect(**db_config) 
    cursor = connect.cursor()

    price_adjuster = PriceAdjustment(connect, cursor)

    price_adjuster.adjust_price(DrinkID)

    connect.commit()

if __name__ == "__main__":     #ensures i can use as a module
    main(54)
            


        
        
