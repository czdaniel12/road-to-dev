# Vehicle Maintenance Records

# Import Modules
import os
import sys

root_dir = os.path.abspath('..')
sys.path.append(root_dir)
import Python.cfg_loader as cfg_loader
import user_utils as u
from sql_loader import LoadSQL

# Config identifiers
script_key = 'maintenance'
use_database = True

# Get SQL db name, establish connection and set cursor
if use_database:
    db_name = cfg_loader.get_db(script_key)
    sql = LoadSQL(db_name)



def main():
    uid = u.main(script_key)
    
if __name__ == "__main__":
    main()


'''
    result = sql.query('select FirstName, LastName from users where id=?', (uid,))
    for fname, lname in result:
        print(f'It\'s {fname} {lname}')
'''