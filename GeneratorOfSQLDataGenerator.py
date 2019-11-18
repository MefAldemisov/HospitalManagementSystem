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

# open file
file = open("tablesUpdate.sql", "r")
full_text = file.read()

# data preparation
commands = full_text.split(";")
tables = {}

primary_key_expr = re.compile("PRIMARY KEY")
partial_key_expr = re.compile("FOREIGN KEY")
reference_expr = re.compile("REFERENCES")
        
# for all commands (instructions, separated by ;)
for command in commands:
    try:
        table_name = command.split("CREATE TABLE")[1].split()[0]
    except:
        continue
        
    comma_sep = command.split("NOT NULL,")
    last = comma_sep[-1]
    comma_sep = comma_sep[:-1]
    comma_sep += last.split("),")

    first_sub_expr = comma_sep[0].split(table_name)[1]
    comma_sep[0] = re.sub(r"^\s+", "", first_sub_expr)[1:] # first brace removed

    table_col = []
    prim_keys = []
    partial_keys = []
    ref = {}          # column_name: TABLE_before
    
    for cs in comma_sep:
        cs = re.sub(r"^\s+", "", cs) # break by space
        splited = cs.split()[:2]
        
        
        if primary_key_expr.search(cs):
            prim_keys_str = cs.split("(")[1].split(")")[0]
            prim_keys = prim_keys_str.split(",")
    
            prim_keys = [re.sub(r"\s+", "", pk) for pk in prim_keys]
        
        elif reference_expr.search(cs):
              
            arr = cs.split("REFERENCES")[1].split("(")
            ref_table = re.sub(r"\s+", "", arr[0])        # the name of table to search in
            ref_columns = arr[1].split(")")[0].split(",") # column(s) name(s) to search for
            ref_columns = [re.sub(r"\s+", "", rc) for rc in ref_columns]
            
            # add to dictionary
            for ref_column in ref_columns:
                ref[ref_column] = ref_table
                
            # add to array of exclusions
            if partial_key_expr.search(cs):
                partial_keys = ref_columns
        else:
            table_col += [splited]
        
    tables[table_name] = {"columns":table_col, 
                          "keys":prim_keys, 
                          "partial_keys": partial_keys, 
                          "ref": ref}

# parameters of random generation
MIN_YEAR = 1950

MIN_DOB = "1950-01-01"
MAX_DOB = "1995-01-01"

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
    return random_date.isoformat(" ", "seconds")
    
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

def getListOfRooms():
    '''
    Returns string 
    "ARRAY [{list}]", where list - sequence of numbers 
    from MIN_ROOM to MAX_ROOM of length from 1 to 6
    '''
    amount = np.random.randint(1, 6)
    result = [str(np.random.randint(MIN_ROOM, MAX_ROOM)) for x in range(amount)]
    result = ", ".join(result)
    result = "ARRAY [" + result + "]"
    return result

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
                 "phone":    lambda: getRandomPhone(),
                 "SSN":      lambda: np.random.randint(10**9, 10**10),                  # 8 digits long
                 "medical_insurence_number": lambda: np.random.randint(10**16, 10**17), # 16 digits long
                 "year":     lambda: np.random.randint(MIN_YEAR, 2019), 
                 "season":   lambda: np.random.randint(1, 5), 
                 "month":    lambda: np.random.randint(1, 13),
                 "room":     lambda: np.random.randint(MIN_ROOM, MAX_ROOM),
                 "quantity": lambda: np.random.randint(0, 100),
                 "priority": lambda: np.random.randint(0, 10),
                 "login":    lambda: getRandomStringNoSpace(16), 
                 "password": lambda: getRandomStringNoSpace(16),
                 "list_of_rooms": lambda: getListOfRooms()
                }

# dictionary for includes

include_types = {"DATE":     lambda: getRandomDate(), 
                 "BOOLEAN":  lambda: getRandomBool(), 
                 "MONEY":    lambda: getRandomMoney()
                }

MAIN_STR = ""
BD = {} # yes, it's possible to create even worse

def appendInsert(tableName, columns, values):
    '''
    Appends one more insert instruction to the global const
    MAIN_STR. Format of appending:
    (+) Updates local copy of bd
    
    "INSERT INTO {}({})\nVALUES ({});\n\n"
    '''
    global MAIN_STR
    str_columns, str_rows = ", ".join(columns[:-1]), ", ".join(values[:-1])
    MAIN_STR += 'INSERT INTO {}({})\nVALUES ({});\n\n'.format(tableName, str_columns, str_rows)
    
    global BD
    for col, val in zip(columns, values):
        if tableName not in BD.keys():
            BD[tableName] = {}
        if col not in BD[tableName].keys():
            BD[tableName][col] = [val]
        BD[tableName][col].append(val)

def getValueToInsert(column):
    
    varchar = re.compile("VARCHAR")
    timestamp = re.compile("timestamp")
    integer = re.compile("INTEGER")
    
    val = "__" # default value

    global special_types
    global include_types
    # if special column name
    if column[0] in special_types.keys():  
        val = special_types[column[0]]()

        
    # if special dt
    elif column[1] in include_types.keys():
        val = include_types[column[1]]()

    # if TIMESTAMP
    elif timestamp.search(column[0]):
        val = getRandomDateTime()

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
    return str(val)

# introduction to KOSTILI:
# in any table ther is a column FULL_KEY (reserved column name), with stucked key values
def generateKey(table, column_names, keys):
    '''
    Returns the array of possible 
    values of the key attribures
    
    Warning: not garanteed to be unique
    '''
    key_val = []
    for k in keys:
        val = getValueToInsert([k, table[column_names.index(k)][1]])
        key_val.append(val)
    return key_val

#  main generation loop
for table_name in tables.keys():
    # data for table     
    
    table = tables[table_name]["columns"]
    column_names = [column[0] for column in table] # names of usuall columns
    
    refs = tables[table_name]["ref"]
    keys = tables[table_name]["keys"]
    part_k = tables[table_name]["partial_keys"]
    
    for row in range(100):
        
        # fill connected columns
        ref_col, ref_val = [], []
        if len(refs) > 0:
            for k in refs.keys():
                col, val = k, np.random.choice(BD[refs[k]][k])
                ref_col.append(col)
                ref_val.append(val)
        
        # fill (partial) keys
        
        # arbitrary key
        if len(keys) > 0:
            key_val = generateKey(table, column_names, keys)
            should_be_unique = "".join(key_val)
#         else:
#             print("WTF", table_name) #it is strainge to have no key
            
        # partial key
        par_val_str = ""
        par_val = []
        if len(part_k) > 0:
            for k in part_k:
                val = ref_val[ref_col.index(k)]
                par_val.append(val)
            par_val_str = "".join(par_val)
        
        # check uniquety
        
        if len(keys) > 0 and table_name in BD.keys():
            while should_be_unique + par_val_str in BD[table_name]["FULL_KEY"]:
                should_be_unique = "".join(generateKey(table, column_names, keys))
                
        # fill secondary columns
        functions = []
        k_counter = 0
        for column in table: # TODO: drop if key
            if column[0] not in keys:
                val = getValueToInsert(column)
                functions.append(str(val))
            else:
                functions.append(key_val[k_counter])
                k_counter += 1
            
        # create one more insertion instruction      
        appendInsert(table_name, 
                     column_names+ref_col+part_k+["FULL_KEY"], 
                     functions+ref_val+par_val+[should_be_unique+par_val_str])

# Printing the output to a file
out_file = open("fill.sql", "w")
out_file.write(MAIN_STR)
out_file.close()
