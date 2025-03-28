---
hidden: true
---

# API Key management



{% openapi src="../../.gitbook/assets/openapi.sn13.json" path="/api/v1/keys" method="post" %}
[openapi.sn13.json](../../.gitbook/assets/openapi.sn13.json)
{% endopenapi %}

## **The base URL for Gravity's API:**

```
https://sn13.api.macrocosmos.ai
```



## 🔑 Creating a New API Key

To create a new API key, you must include your **master key** in the request headers. This grants permission to generate subordinate keys .

```python
import requests
import json

# === Configuration ===
MAINNET_API_URL = "https://sn13.api.macrocosmos.ai"
MAINNET_API_KEY = "" #pass in master api key 

# === Headers for authentication ===
headers = {
    'Content-Type': 'application/json',
    'X-API-KEY': MAINNET_API_KEY
}

# === Payload to create a new named API key ===
payload = {
    "name": "Milo" #input name
}

# === Request to create the key ===
try:
    response = requests.post(
        f"{MAINNET_API_URL}/api/v1/keys",
        headers=headers,
        json=payload,
        timeout=30
    )
    response.raise_for_status()
    result = response.json()

    print("✅ New API key created successfully:")
    print(json.dumps(result, indent=2))

except requests.exceptions.HTTPError as e:
    print(f"❌ HTTP Error: {e}")
    print(f"Response content: {e.response.text}")
except requests.exceptions.RequestException as e:
    print(f"❌ Request Error: {e}")
except Exception as e:
    print(f"❌ Unexpected Error: {e}")
```





### 💬 Need Help?

If you have any questions or run into issues, you can reach out in:

* The [**Macrocosmos Discord**](https://discord.gg/sXJPmGTnVR) and drop a message in the #SN13 channel



