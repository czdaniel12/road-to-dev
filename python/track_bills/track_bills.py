# Track bill totals and calculate remaining money

# Import modules
import json
import os
from pathlib import Path

# Set environment config
find_key = 'track_bills'
cwd = Path(__file__).parents[0]
config_path = Path(__file__).parents[2]
config_file = os.path.join(config_path, 'config.json')

# Load/parse JSON config
def load_json():

    with open(config_file, 'r') as f:
        data = json.load(f)

    for item in data:   
        find_dict = item[find_key]
        input = find_dict['input']
        output = find_dict['output']

    return input, output

# Prompt user for net income or monthly allowance
def get_income():

    while True:
        try:
            income = eval(input("\nEnter your monthly net pay or allowance: "))
            if isinstance(income, (int|float)):
                return income
        except (TypeError, ValueError, NameError):
            print("Invalid value. Re-enter income.")
        except KeyboardInterrupt:
            print("Goodbye.")
            break
    
# Prompt user if they want to add more bills
def add_more():

    while True:
        try:
            add = str(input("Add another? (y/n) ")).strip().lower()
            if add in ['y', 'yes']:
                return True
            elif add in ['n', 'no']:
                return False
            else:
                print("Bad answer.")
        except KeyboardInterrupt:
            print("No bills will be added.")
            break

# Input bill name and amount
def input_bills():

    print("Enter your bill name and cost. Cost amounts may be entered as whole numbers or decimals.")
    bills = {}
    while True:
        try:
            name = input("\nEnter bill name: ") 
            amount = eval(input("Enter bill amount: "))
            if isinstance(amount, (int|float)):
                bills[name] = amount  
                if add_more(): 
                    continue
                else:
                    break
        except (TypeError, ValueError, NameError):
            print("Invalid value(s). Re-enter bill.")
        except KeyboardInterrupt:
            print("Goodbye.")
            break
    
    num = len(bills)
    return bills, num

# Calculate cost of all bills
def calc_expenses(all_bills):
    
    values = []
    for k, v in all_bills.items():
        values.append(v)
    
    total = sum(values)
    return total


def main():

    input_file, output_file = load_json()
    net_income = get_income()
    all_bills, num_of_bills = input_bills()
    total_cost = calc_expenses(all_bills)
    
    report = os.path.join(cwd, output_file)
    with open(report, 'w+') as o:
        o.write(f"""Total number of bills: {num_of_bills}
                \nYour total monthly income is: ${net_income}
                \nThe total cost of your bills is: ${total_cost}
                \nYour remainder after bills is: ${round(net_income - total_cost)}
            """)

if __name__ == "__main__":
    main()