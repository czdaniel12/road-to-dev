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
script_config = 'script_config.json'
user_config = 'users.json'

vehicle_config = 'vehicles.json'
pw_gen_config = 'pw_gen_users.json'

class LoadConfig():
    def __init__(self, use_sql, config_type, key_name, database_type) -> None:
        self.sql = use_sql
        self.config = config_type
        self.key = key_name
        self.db = database_type

        def load_json(self):
            pass


# Return input/output files per script
def load_json(key_name='', has_sql=False, database_type=''):
    get_input_output = os.path.join(config_dir, script_config)
    get_sql_auth = os.path.join(config_dir, sql_config)
    
    with open(get_input_output) as f:
        file_io = json.load(f)
    for items in file_io:
        input_file = items[key_name]['input']
        output_file = items[key_name]['output']

    if has_sql:
        with open(get_sql_auth) as s:
            sql_auth = json.load(s)
    for items in sql_auth:
        sql_data = items[database_type]


    return input_file, output_file



# Get input/output files based on config type
def file_input_output(config_type, use_key):
    if config_type == 'json':
        return load_json(use_key)
    elif config_type == 'xml':
        pass

# Return remote SQL credentials
def load_sql_auth(db):
    find_sql = os.path.join(config_dir, sql_config)
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

def create_user():
    first_name = input('First name: ').title().strip()
    last_name = input('Last name: ').title().strip()
    if str(first_name and last_name).isalpha():
        print('The name is alpha.')
    else:
        print('Name is NOT alpha.')

def verify_user():
    pass


