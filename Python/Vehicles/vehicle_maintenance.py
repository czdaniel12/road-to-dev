# Track vehicle maintenance

class Maintenance:
    def __init__(self, first_name, last_name) -> None:
        self.fname = first_name
        self.lname = last_name
        #self.vehicle = vehicle


def getName():
    first = input('First name: ').title().strip()
    last = input('Last name: ').title().strip()           
    
    return first, last

def getVehicle():
    pass


def main():
    first_name, last_name = getName()
    mt = Maintenance(first_name, last_name)
    print(mt.fname)


if __name__ == "__main__":
    main()



