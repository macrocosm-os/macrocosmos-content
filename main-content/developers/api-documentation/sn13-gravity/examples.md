# Examples

## On Demand API&#x20;

```python

# function to get data:
import requests
import json


MAINNET_API_URL = "https://sn13.api.macrocosmos.ai"

MAINNET_API_KEY = "" #input api key

# Create a headers for API access 

headers = {
    'Content-Type': 'application/json',
    # The server uses `verify_api_key` Depends, so we should pass it as a header
    'X-API-KEY': MAINNET_API_KEY  
}


# function to get data:
import requests

# API endpoint for on demand requests
url = f'{MAINNET_API_URL}/api/v1/on_demand_data_request'


def get_data(data: dict):
    try:
        response = requests.post(url, headers=headers, json=data)
    
        # Check if request was successful
        response.raise_for_status()
    
        # Parse and print the response
        result = response.json()
        print("Success!")
        #print("Data:", result.get("data"))
        #print("Meta:", result.get("meta"))
        return result
    
    except requests.exceptions.HTTPError as e:
        print(f"HTTP Error: {e}")
        print(f"Response content: {e.response.text}")
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")


# Get data 
data = {
    "source": "x",  # Based on DataSource enum in the code
    "usernames": ["@DecentralDev_"], #input username
    "keywords": ["Macrocosmos"],
    "limit": 1000,  # Default is 100, max is 1000
    "start_date": "2025-01-10T00:00:00Z" # Datetime should be in ISO format ( maybe I need to change it)
}

result = get_data(data)

# Print response:
data = result.get('data') # get data

print(f"You made: {len(data)} tweet posts since 10th of March")
# print first tweet
data[0]


```





## List Hugging Face Repositories

```python

import requests

# Config
MAINNET_API_URL = "https://sn13.api.macrocosmos.ai"
MAINNET_API_KEY = "" #input api key

# Headers
headers = {
    'Content-Type': 'application/json',
    'X-API-KEY': MAINNET_API_KEY
}

# Endpoint
url = f"{MAINNET_API_URL}/api/v1/list_repo_names"

# Function to fetch repo names
def list_repo_names():
    try:
        response = requests.get(url, headers=headers, timeout=30)
        response.raise_for_status()
        result = response.json()

        # Expecting a dictionary with 'count' and 'repo_names'
        count = result.get("count", 0)
        repos = result.get("repo_names", [])

        print(f"✅ Retrieved {count} repositories.\n")

        for name in repos:
            print("-", name)

        return result

    except requests.exceptions.HTTPError as e:
        print(f"❌ HTTP Error: {e}")
        print(f"Response content: {e.response.text}")
    except requests.exceptions.RequestException as e:
        print(f"❌ Request Error: {e}")

# Run it
list_repo_names()
```

