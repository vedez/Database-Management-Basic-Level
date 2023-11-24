# Digimon Database
# Description:
# To represent my collection, I will filter all the Digimon characters under the attributes they fall into. 
# There are 9 types of attributes; dark, earth, electric, fire, light, neutral, plant, water, and wind. 
# In addition, I will also include a profile information with the name, stage, and type of each Digimon under that attribute.
# 
# Author: L Fernandez C20305696
# Date: 19/11/2023

import pandas as pd
from pymongo import MongoClient

# Connection to MDB
client = MongoClient('mongodb://admin:Sp00ky!@localhost:27017/?AuthSource=admin')

mydb = client["Digimon"] # Making DB for Digimon
Attributes = mydb["Attributes"]  # Character Collection for Digimon

# Reading CSV and inserting into a dataframe
df = pd.read_csv('DigiDB_digimonlist.csv', encoding='latin-1')

# Convert ' ' to '_' - Consistent DB, less errors
df.columns = df.columns.str.replace(' ', '_')

# Printing all Unique types of values
print('Unique values')
print(df.nunique())

# Adds the stat information into its own stat column
profile_info = ['Digimon', 'Stage', 'Type']
df['Profile'] = df[profile_info].values.tolist()
# df.drop(columns=profile_info, inplace=True) # Drop IF Exists (ERROR CHECK)

# Making the Document per Digimon Character
for attribute in df['Attribute'].unique():

    attribute_df = df[df['Attribute'] == attribute]
    profile = attribute_df[[
        'Digimon', 
        'Stage', 
        'Type',  
    ]].to_dict('records')

    att_doc = {
        "Attribute": attribute, # attribute
        "Profile": profile # profile (array)
    }

    # Add the doc into Attributes collection in Digimon DB
    Attributes.insert_one(att_doc)

# Connection ends
client.close()
