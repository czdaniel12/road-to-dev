# Maintenance Records

# Import Modules
import os
import sys
import mariadb
from pathlib import Path

root_dir = os.path.abspath('..')
sys.path.append(root_dir)
import py_utils

# Static parameters
use_sql = True
config_type = 'json'

# Variable parameters
key_name = 'maintenance'
database_type = 'mariadb'

# Load input/output files from config
input_file, output_file = py_utils.file_input_output(config_type, key_name)

# Get SQL connection if uses db
if use_sql:
    py_utils.load_sql_auth(database_type)


class Maintenance():
    def __init__(self, first_name, last_name) -> None:
        self.fname = first_name
        self.lname = last_name
        
        def check_id(self):
            pass


def select():
    print("Add a new vehicle or update an existing one?")
    choice = 0
    while True:
        try:
            print("1) New vehicle \n2) Existing vehicle")
            prompt = int(input("\nEnter: "))
            if prompt == 1:
                choice += prompt
                return choice
            elif prompt == 2:
                choice += prompt
                return choice
            else:
                print("Please select (1) or (2).")
        except (TypeError, ValueError, NameError):
            print("Please select (1) or (2).")
        except KeyboardInterrupt:
            quit






def main():
    u = py_utils.Users()

    
if __name__ == "__main__":
    main()