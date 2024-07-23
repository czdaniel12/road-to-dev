# Vehicle Maintenance Records

# Import Modules
import os
import sys

root_dir = os.path.abspath('..')
sys.path.append(root_dir)
import cfg_loader
import sql_loader
import user_utils as u

# Config identifiers
script_key = 'maintenance'
use_database = True

# Get SQL db name, establish connection and set cursor
if use_database:
    db_name = cfg_loader.get_db(script_key)
    sql = sql_loader.LoadSQL(db_name)

# Evaluate if this needs a function or just call from main()
def check_user():
    uid, fname, lname = u.main(db_name)

    result = sql.query('SELECT FirstName, LastName FROM users WHERE Id=?', (uid,))
    for fname, lname in result:
        print(f'Welcome back, {fname} {lname}!')
    

def new_record(uid):
    pass

def find_record(uid):
    print('Find existing records:')


def main():
    pass
    
if __name__ == "__main__":
    main()


'''
    result = sql.query('select FirstName, LastName from users where Id=?', (uid,))
    for fname, lname in result:
        print(f'It\'s {fname} {lname}')
'''