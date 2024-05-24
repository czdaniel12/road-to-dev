# Python random password generator.

# Import modules
import os
import random
import string
import json
import mysql.connector
from time import sleep

# Input/output files
input_file1 = 'users.txt'
input_file2 = 'user_config.json'

# Get working dir
current_dir = os.path.dirname(__file__)
u_config1 = os.path.join(current_dir, input_file1)
u_config2 = os.path.join(current_dir, input_file2)

# Prompts
greeting = "\nWelcome to the Python Password Generator!"
ask_length = "\nPlease select your password length by entering a value from 12 and 30."
invalid_int = "\nValue not a number, please enter a number from 12 and 30."
invalid_length = "\nLength not in specified range. Please choose from 12 and 30."

# Password config
pw_range = range(12, 31)
special_char = string.punctuation
alpha_upper = string.ascii_uppercase
alpha_lower = string.ascii_lowercase
numbers = string.digits

# Load JSON config
def load_json():
    with open(u_config2, 'r') as f:
        data = json.load(f)

    return data

# Connect to DB and verify if user exists already
def verify_user():

    while True:
        try:
            id = str(input("What is your name?: "))
            if any(char in id for char in special_char):
                print("Your name cannot include special characters. Please re-enter your name.")
            else:
                break
        except KeyboardInterrupt:
            print("Goodbye.")
            break

    try:
        db_connection = mysql.connector.connect(
            host="localhost",
            user="pw_admin",
            password=""
        )

        select_db = "use pw_manager;"
        query = "select * from users;"
        cursor = db_connection.cursor()
        cursor.execute(select_db)
        cursor.execute(query)
        records = cursor.fetchall()

        for row in records:
            if (id == row[0]):
                print(f"You already have an account that was created on " + row[2])
            else:
                print("It does not look like you exist yet.")

    except mysql.connector.Error as error:
        print("There was an issue.\n", error)

# Create new user
def register_user(file_path):

    flag1 = "No"
    flag2 = "blacklisted"
    user_exists = f"Created: {flag1}"
    status = "Status: blacklisted"

    with open(file_path, 'r') as file:
        content = file.read()
        if (status in content):
            print("You are banned from this system. Goodbye.")
            #exit()
        else:
            print(f"Welcome, {id}")

# Get valid length of password and confirm with user
def get_length():

    while True:
        try:
            length = int(input("Enter length: "))
            if (length not in pw_range):
                sleep(.4)
                print(invalid_length)
            else:
                answer = input("Confirm length of " + str(length) + " (y/n): ").lower().strip()
                if answer in ['y', 'yes']:
                    break
                elif answer in ['n', 'no']:
                    print("Please select a new length.")
                else: 
                    print("Invalid response.")
        except (TypeError, ValueError):
            sleep(.4)
            print(invalid_int)
        except KeyboardInterrupt:
            sleep(.4)
            print("\nGoodbye.")
            break
         
    return length

# Generate password
def pw_generator(pw_length):

    password = ""
    all = special_char + alpha_lower + alpha_upper + numbers

    while len(password) != pw_length:
        rand = random.sample(all, 1)
        password += ''.join(rand)

    return password


def main():

    print(greeting)
    verify_user()
    register_user(u_config1)

    print(ask_length)
    pw_length = get_length()

    password = pw_generator(pw_length)
    print(f"Your new password is: {password}")

if __name__ == "__main__":
    main()
