#!/usr/bin/env python
# coding: utf-8

# # Generation of SQL code to fill BD

import re
import names
import string 
import random 
import exrex
import random
from datetime import datetime, timedelta
import numpy as np

file = open("postgreSqlFiles/tablesCreation.sql", "r")
full_text = file.read()

def getOutOfBraces(string):
    words = string.split("(")[1].split(")")[0]
    words = words.split(",")
    words = [re.sub(r"\s+", "", w) for w in words]
    return words

commands = full_text.split(";")
tables = {}

create_expr = re.compile("CREATE TABLE")
primary_key_expr = re.compile("PRIMARY KEY")
foreign_key_expr = re.compile("FOREIGN KEY")
reference_expr = re.compile("REFERENCES")
usual_expr = re.compile("NOT NULL")
        
for command in commands:
    if not create_expr.search(command):
        continue
        
    table_name = command.split("CREATE TABLE")[1].split()[0]        
    lines = command.split("\n")[1:-1] # remove CREATE( and ); lines

    table_col = []
    prim_keys = []
    ref = {}          # column_name: TABLE_before, column name in it
    
    for cs in lines:
        cs = cs.strip() # remove tabs and spaces around
        if len(cs) < 3 or create_expr.search(cs):
            continue
        if primary_key_expr.search(cs):                                # key
            prim_keys = getOutOfBraces(cs)
            
        elif reference_expr.search(cs):                                # reference
            ref_spl = cs.split("REFERENCES") 
            ref_column_base  = ref_spl[1].split()[0].split("(")[0]
            ref_columns = getOutOfBraces(ref_spl[1])
            
            ref_to = []
            if foreign_key_expr.search(cs):
                ref_to = getOutOfBraces(ref_spl[0])
            else:
                ref_to.append(cs.split()[0])
                table_col += [cs.split()[:2]]
            
            for i in range(len(ref_columns)):
                ref[ref_to[i]] = [ref_column_base, ref_columns[i]]
                
        else:                                                         # usual
            table_col += [cs.split()[:2]]
    tables[table_name] = {"columns":table_col.copy(), 
                          "keys":prim_keys.copy(), 
                          "ref": ref.copy()}
    

# parameters of random generation
MIN_YEAR = 1990

MIN_DOB = "2008-11-28"
MAX_DOB = "2019-11-28"

MIN_ROOM = 100
MAX_ROOM = 450

# random generators

def getRandomName():
    '''
    Returns random first name
    '''
    return names.get_first_name()

def getRandomSurname():
    '''
    Returns random surname
    '''
    return names.get_last_name()

def getRandomStringNoSpace(length):
    '''
    Returns randome string without spaces 
    (can be used for login-assword generation)
    '''
    return exrex.getone('[a-zA-Z][0-9a-zA-Z]{'+str(length-1)+'}')

def getRandomEmail():
    '''
    Random e-mail generation:
    - starts with small letter, 
    - then 7 small letter/numbers 
    - @
    - some small letter
    - .com or .ru
    
    Example of output: yfo5gtxf@u.com
    '''
    return exrex.getone('[a-z][a-z0-9]{7}@[a-z]\.(com|ru)$')

def getRandomDate(start=MIN_DOB, end=MAX_DOB):
    '''
    Returns date in format
    2018-08-21
    '''
    start, end = datetime.fromisoformat(start), datetime.fromisoformat(end)
    random_date = start + (end - start) * random.random()
    return random_date.date().__str__()

def getRandomDateTime(start=MIN_DOB+" 00:00:00", end=MAX_DOB+" 00:00:00"):
    '''
    Returns timestamp in format:
    2016-06-22 19:10:25
    '''
    start, end = datetime.fromisoformat(start), datetime.fromisoformat(end)
    random_date = start + (end - start) * random.random()
    random_date = random_date - timedelta(hours=random_date.hour, minutes=random_date.minute%30, seconds=random_date.second) + timedelta(hours=int(random.random()*10+8))
    return random_date.isoformat(" ", "seconds")
    
def getDOB():
    '''
    Returns DOB in format
    2018-08-21
    '''
    return getRandomDate("1950-01-01", "2002-01-01")

def getRandomString(length=64):
    '''
    Returns random string with multiple words 
    which can start from capital/small leters
    the length of the string is at max 'length'
    
    Can be used for long sentencies generation
    '''
    return exrex.getone('([a-zA-Z][a-z]* )*')[:length]

def getRandomPhone():
    '''
    Returns 11 numerical chars a row
    '''
    return exrex.getone('[0-9]{11}')

def getRandomBool():
    '''
    Returs "true" or "false"
    '''
    if random.randint(0, 1): return "true"
    return "false"


def getRandomMoney():
    '''
    Reurns float in format:
    xxxx.xx
    '''
    return np.random.randint(0, 10**6)/100


# dictionary of predefined fucions for some freuent column names


special_types = {"name":     lambda: getRandomName(), 
                 "surname":  lambda: getRandomSurname(), 
                 "email":    lambda: getRandomEmail(), 
                 "phone":    lambda: str(getRandomPhone()),
                 "SSN":      lambda: str(np.random.randint(10**8, 10**9)),                  # 8 digits long
                 "medical_insurence_number": lambda: np.random.randint(10**15, 10**16),      # 16 digits long
                 "year":     lambda: str(np.random.randint(MIN_YEAR, 2019)), 
                 "season":   lambda: np.random.randint(1, 5), 
                 "month":    lambda: np.random.randint(1, 13),
                 "room":     lambda: np.random.randint(MIN_ROOM, MAX_ROOM),
                 "quantity": lambda: np.random.randint(0, 100),
                 "priority": lambda: np.random.randint(0, 10),
                 "login":    lambda: getRandomStringNoSpace(16), 
                 "password": lambda: getRandomStringNoSpace(16),
                 "add_fire_flag": lambda: np.random.randint(0, 1),
                 "date_of_birth": lambda: getDOB()
                }

# dictionary for includes

include_types = {"DATE":     lambda: str(getRandomDate()), 
                 "BOOLEAN":  lambda: str(getRandomBool()), 
                 "MONEY":    lambda: getRandomMoney()
                }

amounts = {
    "EmployeeAccount": 1000,
    "HeadOfDepartment": 10,
    "Department": 8,
    "ManageDepartment": 100,
    "PatientAccount": 1000,
    "TaskOfToDoList": 2000,
    "ManageTask": 11000,
    "Security": 10,
    "SendMessage": 2000,
    "HR": 5,
    "AddFire": 500,
    "Cleaning": 20,
    "Noticeboard": 100,
    "Notice": 100,
    "EditNotice": 200,
    "StaffsTimetable": 100,
    "EditStaffsTimetable": 150,
    "SendRequest": 50,
    "WarehouseManager": 2,
    "Inventory": 300,
    "ManageInventory": 400,
    "Feedback": 40,
    "Nurse": 200,
    "Doctor": 200,
    "MedicalReport": 10000,
    "ITSpecialist": 5,
    "ManageEmployeeAccount": 400,
    "Contacts": 300,
    "CreateRecipe": 2000,
    "PatientTimetable": 100,
    "EditPatientTimetable": 100, 
    "CreateAppointment": 40000,
    "Pharmacist": 5,
    "Medicine": 100,
    "ManageMedicine": 300,
    "ChangePrice": 10,
    "Financial": 10,
    "Bill": 100,
    "ManageBill": 120,
    "RequestForMeds": 50
}


MAIN_STR = ""
BD = {} # yes, it's possible to create even worse
mentioned_tables = {}

def appendInsert(tableName, columns, values):
    '''
    Appends one more insert instruction to the global const
    MAIN_STR. Format of appending:
    (+) Updates local copy of bd
    
    "INSERT INTO {}({})\nVALUES ({});\n\n"
    '''
    global BD
    for col, val in zip(columns, values):
        if tableName not in BD.keys():
            BD[tableName] = {}
        if col not in BD[tableName].keys():
            BD[tableName][col] = [val]
        BD[tableName][col].append(val)
        
    global MAIN_STR
    values = ["\'" + val +"\'" if type(val) == str else str(val) for val in values]
    
    str_columns, str_rows = ", ".join(columns[:-1]), ", ".join(values[:-1])
    MAIN_STR += 'INSERT INTO {}({})\nVALUES ({});\n\n'.format(tableName, str_columns, str_rows)
    

def getValueToInsert(column):
    
    varchar = re.compile("VARCHAR")
    timestamp = re.compile("timestamp")
    integer = re.compile("INTEGER")
    ssn = re.compile("SSN")
    
    val = "__" # default value

    global special_types
    global include_types
    # if special column name
    if column[0] in special_types.keys():  
        val = special_types[column[0]]()
    elif ssn.search(column[0]):
        val = special_types["SSN"]()
        
    # if special dt
    elif column[1] in include_types.keys():
        val = include_types[column[1]]()

    # if TIMESTAMP
    elif timestamp.search(column[0]):
        val = str(getRandomDateTime())

    # if VARCHAR(n)
    elif varchar.search(column[1]):
        amount = int(column[1].split("(")[1][:-1])
        val = getRandomString(amount)

    # if INTEGER dt    
    elif integer.search(column[1]):
        val = np.random.randint(0, 10**6)

    # check if everything is filled
    if val=='__':
        print ("Alert!", column, key)
    return val

def getRefVal(refs_k):
    '''
    k - referene column name
    '''
    ref_table_name, ref_column_name  = refs_k
    
    global BD
    global mentioned_tables
    
    bd_column = BD[ref_table_name][ref_column_name]
    if ref_table_name not in mentioned_tables.keys():
        row_index = np.random.randint(0, len(bd_column)-1)
        mentioned_tables[ref_table_name] = row_index

    return bd_column[mentioned_tables[ref_table_name]]


# introduction to KOSTILI:
# in any table ther is a column FULL_KEY (reserved column name), with stucked key values
def generateKey(table, column_names, k, refs):
    '''
    Return a key
    
    Warning: not garanteed to be unique
    '''
    if k in refs.keys(): # if the geven key was referenced
        return getRefVal(refs[k])
    else:
        return getValueToInsert([k, table[column_names.index(k)][1]])

def generateKeys(table, column_names, keys, refs):
    '''
    Genereats array of all keys
    '''
    return [generateKey(table, column_names, k, refs) for k in keys]


for table_name in tables.keys():
    # data for table     
    
    table = tables[table_name]["columns"]
    column_names = [column[0] for column in table] # names of usuall columns + partial_keys
    keys = tables[table_name]["keys"]

    refs = tables[table_name]["ref"]
    ref_col = [ rk for rk in refs.keys() if rk not in keys]
    
    for row in range(amounts[table_name]):
        mentioned_tables = {}
        
        # fill connected columns
        ref_val = [getRefVal(refs[k]) for k in ref_col]
        # keys
        key_val = generateKeys(table, column_names, keys, refs)
        str_key_val = [str(k) for k in key_val]
        should_be_unique = "".join(str_key_val)
        
        # check uniquety
        is_uinque = (table_name in BD.keys()) 
        is_uinque = is_uinque and (should_be_unique in BD[table_name]["FULL_KEY"])
        if is_uinque:
            continue # enough values are generated to skip some of them
        
        # fill secondary columns
        functions = []
        col_n = []

        for column in table: 
            if column[0] in keys+ref_col:
                continue    
            functions.append(getValueToInsert(column))
            col_n.append(column[0])
              
        # create one more insertion instruction      
        appendInsert(table_name, 
                     keys+col_n+ref_col+["FULL_KEY"], 
                     key_val+functions+ref_val+[should_be_unique])

# Printing the output to a file
out_file = open("easy_fill.sql", "w")
out_file.write(MAIN_STR)
out_file.close()


# ## References
# 
# - [names generator](https://treyhunner.com/2013/02/random-name-generator/)
# - [lib for regexp generator](https://github.com/asciimoo/exrex)
# - [datetime](https://docs.python.org/3/library/datetime.html)
# - [random date generation](https://cmsdk.com/python/generate-a-random-date-between-two-other-dates.html)




