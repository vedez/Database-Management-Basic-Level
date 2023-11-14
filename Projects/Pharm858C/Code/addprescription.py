#
# Project: Pharm858C 
# This code is an extension for Pharm858C DB > python file to add prescription
# 
# File: Adding Prescription via Python 
# Description: Using the addprescription() function via python
# 
# Author: Lovely Fernandez (LF)
# Date: 25/10/2023 
#
 
import psycopg2, getpass, pandas as pd
import json
from psycopg2 import Error
try:
    # Connecting to Database 
    connection = psycopg2.connect(
        host="localhost",
        user = "pUser1",
        password = "1resUp",
        port="54321",
        database="DB001")
    
    # Create a cursor to perform database operations
    cursor = connection.cursor()

    # Set the search path to the specific schema you want to use
    cursor.execute('SET search_path TO "Pharm858C"')
    # Execute a query to get the current schema
    cursor.execute('SELECT current_schema()')

    # Fetch the schema name
    schema_name = cursor.fetchone()[0]
    print(f"The current schema is: {schema_name}")
    
    # Populating the Customer Name, Address, Doctor Name and address.
    cName = input('Customer Name: ')
    cAdd = input('Customer Address: ')
    dName = input('Doctor Name: ')
    dAdd = input('Doctor Address: ')
    
    # Adding the drugs in list
    # User can add as much drugs on prescription and press yes when done
    drugs = []
    while True:
        drug_brand = input('Enter brand type: ')
        drug_type = input('Enter drug type: ')
        dosage = int(input('Enter dosage: '))
        days = int(input('Enter number of days: '))

        # Formatting the drug details into one and appending the drugs list 
        entry = {"drug_brand": drug_brand, "drug_type": drug_type, "dosage": dosage, "days": days}
        drugs.append(entry)

        more = input('Would you like to add another drug? y/n: ').lower()
        if more != 'y':
            break
            
    medcard = input('Medical Card ID: ')

    """ 
    # Testing
    # Debug prints to display input values before calling the stored procedure
    print('Debug: cName:', cName)
    print('Debug: cAdd:', cAdd)
    print('Debug: dName:', dName)
    print('Debug: dAdd:', dAdd)
    print('Debug: drugs:', json.dumps(drugs))
    print('Debug: medcard:', medcard)"""
    
    # Add the prescription | Calling the addprescription procedure
    cursor.execute("Call addprescription(%s, %s, %s, %s, %s, %s)", (cName, cAdd, dName, dAdd, json.dumps(drugs), medcard))
    connection.commit()
    print('\nPrescription is added!\n\n')

    # Printing the Prescription including Customer and Doctor Details, Drug Details and Medical Card if Customer has one
    postgreSQL_select_Query = 'select presc_id, cust_name, cust_add, doc_name, doc_add, brand_name, drug_type, dosage, duration, med_card from prescription p join customer c using (cust_id) join doctor d using (doc_id) join drug_type dt on (dt.drug_name = p.drug_type) join brand using (brand_id);'
    cursor.execute(postgreSQL_select_Query)

    # Fetch the data into a Pandas dataframe and print the dataframe.
    df = pd.DataFrame(
        cursor.fetchall(), 
        columns=['presc_id', 'cust_name', 'cust_add', 'doc_name', 'doc_add', 'brand_name', 'drug_type', 'dosage', 'duration', 'med_card'])
    print(df)
 
except (Exception, Error) as error:
    print("Error while connecting to PostgreSQL", error)
finally:
    if (connection):
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
    else:
        print("Terminating")