# Digimon Database
# Description:
# Manipulating data:
# Write insert, update and delete statements for your collection (Look this up yourselves).
#
# I have added these options into a function and created a menu.
# 
# Author: L Fernandez C20305696
# Date: 19/11/2023

import pandas as pd
import json
from pymongo import MongoClient

# Connection to MDB
client = MongoClient('mongodb://admin:Sp00ky!@localhost:27017/?AuthSource=admin')

db = client['Digimon'] 
collection = db['Attributes']

# FUNCTIONS START
# Insert a Document into the collection
def insert():
    print("\nInsert the information of the new document")

    profiles = []  # Profile Array
    att = input('\nAttribute: ')

    while True:
        name = input('\nDigimon Name: ')
        stage = input('Stage: ')
        type = input('Type: ')

        # Add each profile to the list
        profiles.append({"Name": name, "Stage": stage, "Type": type})

        more = input('\nAdd another profile to this attribute? y/n: ').lower()
        if more != 'y':
            break

    new_digimon = {"Attribute": att, "Profile": profiles}
    collection.insert_one(new_digimon)
    
    print("Document inserted successfully.")


# Updates a Documet 
def update():
    print("\nUpdating Document")

    att = input('\nAttribute: ')
    digimon = input("\nWhat is the name of the Digimon you would like to update? ")
    col = input('\nWhat would you like to change? Name, Stage or Type\n')
    change = input('Insert change: ')

    # Setting the changes into variables for easier management
    new_values = {"$set": {f"Profile.$[elem].{col}": change}}
    query = {"Attribute": att, "Profile.Name": digimon}
    array_filters = [{"elem.Name": digimon}]

    # Update documents base on information above
    result = collection.update_many(query, new_values, array_filters=array_filters)

    # ERROR CHECK
    if result.modified_count == 0:
        print("\nDigimon not found or no changes made.")
    else:
        print("\nDocuments updated successfully.")


def delete():
    attribute_to_delete = input('\nEnter the attribute of the documents you would like to delete: ')
    
    query = {"Attribute": attribute_to_delete}  # Define what attribute to delete aka document
    collection.delete_many(query)
    print("\nDocuments with attribute '{}' deleted successfully.".format(attribute_to_delete))
    
# All functions in a menu display
def options():
    print("\nChoose a function:")
    print("1. Insert")
    print("2. Update")
    print("3. Delete")
    print("4. Exit")
# FUNCTIONS END

# MAIN MENU
def main():
    # List of menue options
    functions = {
        "1": insert,
        "2": update,
        "3": delete
    }

    while True: # Loop until user ends
        options() # Display

        choice = input("\nEnter your choice (1-4): ")
        if choice == "4":
            break # Exit
        elif choice in functions:
            functions[choice]() # choice is the input of the user 1-3
        else:
            print("\nInvalid choice. Please enter a number between 1-4.")

    # Close the MongoDB connection
    client.close()

if __name__ == "__main__":
    main()
# END MENU
