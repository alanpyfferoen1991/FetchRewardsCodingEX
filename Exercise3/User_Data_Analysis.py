# %%
import pandas as pd
import json

# read json file
def read():
     with open('users.json', 'r', encoding='utf-8') as f:
         data = [json.loads(line) for line in f]
         # Normalize semi-structured JSON data into a flat table.
         df = pd.json_normalize(data)
         # Convert unix timestamp into date format
         df['createdDate.$date'] = pd.to_datetime(df['createdDate.$date'], unit='ms')
         df['lastLogin.$date'] = pd.to_datetime(df['lastLogin.$date'], unit='ms')
     return df
# create dataframe
users = read()


# %%
