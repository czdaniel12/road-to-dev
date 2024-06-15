# Put or create all associated files in same dir

# Import modules
import os
import json
import datetime as dt
from datetime import datetime

# Set time
time = datetime.now()
cur_day = time.strftime("%Y-%m-%d")
cur_hour = time.strftime("%H:%M:%S")
cur_time = cur_day + ":" + cur_hour

# Input/Output files
input_file = 'input.json'
output_file_pass = 'output_pass.json'
output_file_fail = 'output_fail.json'
error_log = 'error.log'

# Read current directory and set file variables
current_dir = os.path.dirname(__file__)
input = os.path.join(current_dir, input_file)
output_p = os.path.join(current_dir, output_file_pass)
output_f = os.path.join(current_dir, output_file_fail)
output_e = os.path.join(current_dir, error_log)

# Set desired parameters for comparison with JSON
only_use_types = ['memorial', 'landscape', "lakes"]
max_lat = 50.53
min_lat = 30.67
max_lon = 115.90
min_lon = 5.59
min_cap = 4.00
max_cap = 14.99
after_date = dt.datetime(2017, 6, 20)
before_date = dt.datetime(2021, 5, 12)
expected_key_num = 5

# Load and parse JSON file
def load_json():
    with open(input, 'r') as f:
        data_list = json.load(f)

    return data_list

# Filter JSON data based on criteria
def filter_json(data):

    filtered_data_pass = []
    filtered_data_fail = []

    desired_values = {
        'type': only_use_types,
        'latitude': (min_lat, max_lat),
        'longitude': (min_lon, max_lon),
        'capacity': (min_cap, max_cap),
        'date': (after_date, before_date)
    }
    
    for item in data:
        key_type = item.get('type')
        key_lat = item.get('latitude')
        key_long = item.get('longitude')
        key_cap = item.get('capacity')
        key_date = item.get('date')

        try:
            item_date = dt.datetime.strptime(key_date, '%Y-%m-%d')
        except ValueError:
            continue

        if (key_type in desired_values['type'] and
            min_lat <= key_lat <= max_lat and
            min_lon <= key_long <= max_lon and
            min_cap <= key_cap <= max_cap and
            desired_values['date'][0] <= item_date <= desired_values['date'][1]
            ):
            filtered_data_pass.append(item)
        else:
            filtered_data_fail.append(item)

    return filtered_data_pass, filtered_data_fail, item, data

# Write to error log
def error_handling(item, data):
    
    try:
        filtered_unexpected = []

        with open(output_e, 'a') as e:
            if (value is None or value != item[key] for key, value in data):
                filtered_unexpected.append(item)
                e.write(f"\nError {cur_time}: Expected dictionary data is missing or value does not match. Please review {input} for issues.")
                json.dump(filtered_unexpected, e)
            elif len(item) != expected_key_num:
                e.write(f"\nError {cur_time}: One or more dictionaries is missing the expected key count of {expected_key_num}. Please review {input} for issues.")

    except (ValueError, TypeError) as err:
        e.write(f"\nError {cur_time}: A ValueError or TypeError has been detected in {input}. \n{err} \nPlease review.")

# Take failed output values from previous run and compare against new parameters
def recycle_data(j_fail):
    pass

def main():
    data_list = load_json()
    j_pass, j_fail, get_item, get_data = filter_json(data_list)

    with (
        open(output_p, 'w') as p,
        open(output_f, 'w') as f,
        ):
        json.dump(j_pass, p, indent=4)
        json.dump(j_fail, f, indent=4)
        error_handling(get_item, get_data)

    if (j_fail):
        recycle_data(j_fail)

if __name__ == "__main__":
    main()

