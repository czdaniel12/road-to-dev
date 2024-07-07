# SQL utilities for Python scripts

# Import Modules
import sys
import mariadb
import cfg_loader

# Fetch data from SQL config file
config_file = 'sql_config.json'
config_data = cfg_loader.load_json(config_file)

class LoadSQL():
    def __init__(self, db_name, uid=0) -> None:
        self.db = db_name
    
    def connect(self):
        for data in config_data:
            if self.db in data:
                auth = data[self.db]
                try:
                    conn = mariadb.connect(
                        user = auth['user'],
                        password = auth['password'],
                        host = auth['host'],
                        port = auth['port'],
                        database = auth['database']
                    )
                    cursor = conn.cursor()

                except mariadb.Error as e:
                    print(f'Error: {e}')
                    sys.exit(1)
            else:
                print(f'{self.db} name not found in {config_file}.')
                exit

        return cursor

    def query(self, query, var=None):
        cur = self.connect()
        if var:
            cur.execute(query, var)
        else:
            cur.execute(query)

        return cur
    
    def add_row(self):
        pass
