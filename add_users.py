import mysql.connector
from werkzeug.security import generate_password_hash


config = {
    'user': 'root',
    'password': 'Eireann32-',
    'host': 'localhost',
    'database': 'stocktest'
}

def add_user(username, password):
    hashed_password = generate_password_hash(password, method='pbkdf2:sha256', salt_length=8)
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor()
    cursor.execute("INSERT INTO Users (UserName, UserPassword) VALUES (%s, %s)", (username, hashed_password))
    connection.commit()
    print(f"User {username} added successfully!")
    cursor.close()
    connection.close()

if __name__ == '__main__':
    add_user('darragh', 'darragh07')
    add_user('ben', 'ben07')

