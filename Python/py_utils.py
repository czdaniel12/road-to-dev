# Python Environment

import os
import re
import json
import mariadb
from pathlib import Path

# Set current and config directories
current_dir = os.path.dirname(__file__)
config_dir = os.path.join(current_dir, 'Config')

# Path to configuration files
sql_config = 'sql_config.json'
json_config = 'script_config.json'
xml_config_path = 'script_config.xml'
user_config = 'users.json'
vehicle_config = 'vehicles.json'

class LoadConfig():
    def __init__(self, use_sql, config_type, key_name, database_type) -> None:
        self.sql = use_sql
        self.config = config_type
        self.key = key_name
        self.db = database_type

        def load_json(self):
            pass


# Load JSON config file(s)
def load_json(use_key, email=''):
    json_file = os.path.join(config_dir, json_config)
    with open(json_file) as j:
        data = json.load(j)
    
    for items in data:
        input_file = items[use_key]['input']
        output_file = items[use_key]['output']

    return input_file, output_file

# Get input/output files based on config type
def file_input_output(config_type, use_key):
    if config_type == 'json':
        return load_json(use_key)

# Return remote SQL credentials
def load_sql_auth(db):
    pass

def get_user():
    while True:
        try:
            regex = r'^[a-z0-9]+[\._]?[a-z0-9]+[@]\w+[.]\w+$'
            email = input('Enter your email: ').lower().strip()
            if re.match(regex, email):
                print(f'Welcome back, {email}!')
                return email
            else:
                print('Email is not a valid format or does not exist. Pleaes re-enter.')
        except KeyboardInterrupt:
            exit

class Users():
    def __init__(self) -> None:
        self.user = get_user()

        def get_name(self):
            pass




def create_user():
    first_name = input('First name: ').title().strip()
    last_name = input('Last name: ').title().strip()
    if str(first_name and last_name).isalpha():
        print('The name is alpha.')
    else:
        print('Name is NOT alpha.')

def verify_user():
    pass


