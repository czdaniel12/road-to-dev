# Python Environment and Utilities

# Import Modules
import sys
import os
import json
import yaml

# Set current and config directories
current_dir = os.path.dirname(__file__)
config_dir = os.path.join(current_dir, 'Config')

# Configuration files
script_configs = 'py_scripts.yml'
script_configs_old = 'py_scripts.json'
users_config = 'users.json'

def load_json(file):
    json_file = os.path.join(config_dir, file)
    with open(json_file) as f:
        data = json.load(f)
        return data

def append_user(new_user):
    json_file = os.path.join(config_dir, users_config)
    data = []
    with open(json_file) as j:
        data = json.load(j)
        data.append(new_user)

    with open(json_file, 'w') as f:
        json.dump(data, f, indent=4, separators=(',',': '))
        
        
def load_yaml(file):
    config_file = os.path.join(config_dir, file)
    with open(config_file) as f:
        data = yaml.safe_load(f)
        return data

def get_db(script_key):
    data = load_yaml(script_configs)
    scripts = data['scripts']
    for s in scripts:
        if s.get('id') == script_key:
            try:
                db_name = s.get('database', {}).get('name')
                return db_name
            except yaml.error as e:
                print(f'Error: {e}')
                sys.exit(1)
  
def get_file_names(script_key):
    data = load_yaml(script_configs)
    for items in data:
        input_file = items[script_key]['input']
        output_file = items[script_key]['output']

        return input_file, output_file



