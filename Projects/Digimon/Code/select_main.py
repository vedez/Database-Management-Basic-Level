# Digimon Database
# Description:
# Write MongoDB queries to query your collections.  Your queries should be run from a Python program and show:
# - Selection of all documents in a collection, in JSON format.
# - Selection of embedded array data, based on selection criteria.
# - Selection showing Projection
# - Selection with sorted output
# - Selection using Aggregation pipelines (e.g. $match)
#
# I have added these select queries into a function and created a menu for users to choose which function to use.
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
# Selecting all Documents (1)
def all_doc():
    print("\nPrinting all documents")

    documents = collection.find({}) # Retrieve Documents from Collection(Attributes)
    for index, document in enumerate(documents, start=1):
        print(f"Document {index}:\n")
        print(json.dumps(document, indent=4, default=str))
        print("\n----------------------------------------\n")

    print("\nAll documents have been printed")

# Prints Digimons that are under the given attribute (2)
def select_array():
    print("\nOptions: Dark, Earth, Electric, Fire, Light, Neutral, Plant, Water, and Wind.")
    find = input("\nEnter Attribute: ")

    print(f"\nPrinting documents with '{find}' Attribute\n")
    
    digimons = collection.find({"Attribute": find})
    for document in digimons:
        print(f"Attribute: {document['Attribute']}")
        print("Profile:")
        print(json.dumps(document['Profile'], indent=4, default=str))
        print("\n----------------------------------------\n")
    
    print(f"\nAll documents under '{find}' Attribute have been printed")

# Only prints the given field (3)
def projection():
    print("\nWhat field would you like to print? Options: 'Attribute' or 'Profile'")
    option = input("\nEnter field: ")

    if option in ['Attribute', 'Profile']:
        print(f"\nPrinting '{option}' field of all documents:")
        projected_docs = collection.find({}, {option: 1, "_id": 0})
        for doc in projected_docs:
            print(json.dumps(doc, indent=4, default=str))
    else:
        print("Invalid option. Please enter either 'Attribute' or 'Profile'.")

# Sorts documents by a-z (4)
def sort_output():
    # Commenting sorted documents by attribute and only printing attribute to show the sorting
    # print("\nSorted Documents by Attribute (a-z):")
    # sorted_docs = collection.find({}).sort("Attribute", 1)
    # for doc in sorted_docs:
    #     print(json.dumps(doc, indent=4, default=str))

    print("\nSorted by Attribute:")
    sorted_docs = collection.find({}, {"Attribute": 1, "_id": 0}).sort("Attribute", 1)
    for doc in sorted_docs:
        print(json.dumps(doc, indent=4, default=str))


# Grouping by Type from multiple documents (Attributes) (5)
# ref. link: https://www.mongodb.com/docs/manual/aggregation/
def aggregation():
    print("\nOptions: Data, Free, Vaccine, Virus")
    find = input("\nEnter Type: ")

    # Processing Documents
    pipeline = [
        {"$unwind": "$Profile"}, # Deconstructs Array
        {"$match": {"Profile.Type": find}}, # Matching Type
        {"$project": {"Attribute": 1, "Profile": 1, "_id": 0}} # Show attribute and profile only
    ]

    type = collection.aggregate(pipeline)
    for documents in type:
        print(f"Attribute: {documents['Attribute']}")
        print("Profile:")
        print(json.dumps(documents['Profile'], indent=4, default=str))
        print("\n----------------------------------------\n")

    print(f"All Digimons with Type '{find}' have been printed")

# All functions in a menu display
def options():
    print("\nChoose a function:")
    print("1. Select All Documents")
    print("2. Select Array Data")
    print("3. Show Projection of Profile or Attribute")
    print("4. Sort by attribute")
    print("5. Aggregation by Type")
    print("6. Exit")
# FUNCTIONS END

# MAIN MENU
def main():
    # List of menue options
    functions = {
        "1": all_doc,
        "2": select_array,
        "3": projection,
        "4": sort_output,
        "5": aggregation
    }

    while True: # Loop until user ends
        options() # Display

        choice = input("\nEnter your choice (1-6): ")
        if choice == "6":
            break # Exit
        elif choice in functions:
            functions[choice]() # choice is the input of the user 1-5
        else:
            print("\nInvalid choice. Please enter a number between 1-6.")

    # Close the MongoDB connection
    client.close()

if __name__ == "__main__":
    main()
# END MENU
