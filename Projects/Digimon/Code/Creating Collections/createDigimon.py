# 
# Digimon Database
# Description:
# The main collection will represent the variety of Digimons including their name, stage, type, attributes, memory, 
# equip slots and stat abilities such as health, SP, attack, defence, INT and speed.
# 
# Author: L Fernandez C20305696
# Date: 19/11/2023
#

##!/usr/bin/env python
## coding: utf-8

import pandas as pd
from pymongo import MongoClient

# Connection to MDB
client = MongoClient('mongodb://admin:Sp00ky!@localhost:27017/?AuthSource=admin')

mydb = client["Digimon"] # Making DB for Digimon
Characters = mydb["Characters"]  # Character Collection for Digimon
Characters.drop()  # Drop IF Exists (ERROR CHECK)

# Reading CSV and inserting into a dataframe
df = pd.read_csv('DigiDB_digimonlist.csv', encoding='latin-1')

# Convert ' ' to '_' - Consistent DB, less errors
df.columns = df.columns.str.replace(' ', '_')

# Printing all Unique types of values
print('Unique values')
print(df.nunique())

# Adds the stat information into its on stat column
stats_info = ['Lv_50_HP', 'Lv50_SP', 'Lv50_Atk', 'Lv50_Def', 'Lv50_Int', 'Lv50_Spd']
df['Stats'] = df[stats_info].values.tolist()
df.drop(columns=stats_info, inplace=True) # Drop IF Exists (ERROR CHECK)

# Making the Document per Digimon Character
for digimon in df.itertuples():
    digi_doc = {
        "Digimon": digimon.Digimon, # name
        "Stage": digimon.Stage, # stage
        "Type": digimon.Type, # type
        "Attribute": digimon.Attribute, # attribute
        "Memory": digimon.Memory, # memory
        "Equip_Slots": digimon.Equip_Slots, # equip slots
        "Stats": digimon.Stats # stats (array)
    }

    # Add the doc into Characters collection in Digimon DB
    Characters.insert_one(digi_doc)

# Connection ends
client.close()
