# User utilities for Python scripts

# Import Modules
import re
import sys
import Python.cfg_loader as cfg_loader
from sql_loader import LoadSQL

# Config
config_file = 'users.json'
config_data = cfg_loader.load_json(config_file)

# General prompts
invalid = 'Invalid response.'
yn = '(Y/N): '

# Email prompts
email_enter = 'Enter your email: '
email_confirm = 'Confirm your email as '
email_invalid = 'Email is not a valid format. Please re-enter.'

# Name prompts
name_enter = 'Please enter your name.'
name_confirm = 'Confirm your name: '
name_invalid = 'Name is invalid. May not contain numbers or special characters.'
first = 'First Name: '
last = 'Last Name: '

# Account prompts
account_invalid = 'There is no account matching '
account_create = 'Would you like to create an account?'

# User functions
def yes_no_prompt():
    while True:
        try:
            choice = str(input(yn)).strip().lower()
            if choice in ['y', 'yes']:
                return True
            elif choice in ['n', 'no']:
                return False
            else:
                print(invalid)
        except KeyboardInterrupt:
            exit

def get_email():
    while True:
        try:
            regex = r'^[a-z0-9]+[\._]?[a-z0-9]+[@]\w+[.]\w+$'
            email = input(email_enter).lower().strip()
            if re.match(regex, email):
                print(email_confirm + f'\'{email}\'?')
                if yes_no_prompt():
                    return email
            else:
                print(email_invalid)
        except KeyboardInterrupt:
            sys.exit(1)

def get_name():
    while True:
        try:
            print(name_enter)
            first_name = input(first).title().strip()
            last_name = input(last).title().strip()

            if str(first_name and last_name).isalpha():
                print(name_confirm + f'{first_name} {last_name}')
                if yes_no_prompt():
                    return first_name, last_name
                else:
                    continue
            else:
                print(name_invalid)
        except KeyboardInterrupt:
            print('Goodbye')
            exit

def verify_user(email):
    for data in config_data:
        for v in data.values():
            if email in v['email']:
                uid = v['uid']
                return uid     

def create_account(email):
    print(account_invalid + f'\'{email}\'')
    print(account_create)
    while True:
        try:
            if yes_no_prompt():
                fname, lname = get_name()
                return fname, lname
            else:
                sys.exit()
        except KeyboardInterrupt():
            sys.exit()

def add_profile(email, fname, lname, script_key):
    for data in config_data:
        uid = len(data) + 1

    new_user = {
        uid: {
            "uid": uid,
            "email": email
        }
    }

    cfg_loader.append_user(new_user)

'''
    new_user_old = f'{uid}: {
    "uid": {uid},
    "email": {email},
    "fname": {fname},
    "lname": {lname},
    "status": "Active"}'
'''


def main(script_key=''):
    email = get_email()
    uid = verify_user(email)

    if not uid:
        fname, lname = create_account(email)
        add_profile(fname, lname, email, script_key)

    return uid

if __name__ == '__main__':
    main()