---
description: >-
  Simply copy and paste any of the following scripts in your coding environments
  to interact with SN1 - Please ensure you have an API Key.
---

# Example Usage

## **Chat Completions Script**&#x20;

```python
import asyncio
import openai

STREAM = True
API_KEY = "..."

async def main():
    try:
        client = openai.AsyncOpenAI(
            base_url="https://sn1.api.macrocosmos.ai/v1",
            max_retries=0,
            timeout=openai.Timeout(120, connect=10, read=110),
            api_key=API_KEY
        )

        payload = {
            "messages": [
                {"role": "user", "content": "List 5 popular places in Hawaii"}
            ],
            "seed": 42,
            "sampling_parameters": {
                "do_sample": True,
                "max_new_tokens": 512,
                "temperature": 0.7,
                "top_k": 50,
                "top_p": 0.95
            },
            "inference_mode": "Reasoning-Fast",
        }

        result = await client.chat.completions.create(
            model="Default",
            messages=payload["messages"],
            stream=STREAM,
            extra_body=payload,
        )

        if not STREAM:
            print(result)
        else:
            chunks = []
            async for chunk in result:
                if chunk.choices[0].delta.content:
                    chunks.append(chunk.choices[0].delta.content)
            print("".join(chunks))

    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    asyncio.run(main())
```



## Web Retrieval Script

```python
import requests
import time
import pandas as pd

# Set your API keys
API_KEY = ""
VALIDATOR_KEY = ""

# Endpoint URL
url = "https://sn1.api.macrocosmos.ai/web_retrieval"

# Headers
headers = {
    "api-key": API_KEY,
    "validator-key": VALIDATOR_KEY,
    "Content-Type": "application/json"
}

# Payload for web retrieval
payload = {
    "search_query": "latest advancements in software engineering in the last 3 years",
    "n_miners": 5,
    "n_results": 1,
    "max_response_time": 30
}

# Execute request
try:
    start_time = time.time()
    response = requests.post(url, headers=headers, json=payload, timeout=60)
    response.raise_for_status()
    duration = time.time() - start_time

    results = response.json()["results"]
    df = pd.DataFrame(results)
    print("✅ Web Retrieval Successful")
    print(df)
    print(f"\n⏱️ Response Time: {duration:.2f} seconds")

except requests.exceptions.HTTPError as errh:
    print(f"❌ HTTP Error: {errh}")
except requests.exceptions.ConnectionError as errc:
    print(f"❌ Connection Error: {errc}")
except requests.exceptions.Timeout as errt:
    print(f"❌ Timeout Error: {errt}")
except requests.exceptions.RequestException as err:
    print(f"❌ Unexpected Error: {err}")


```



