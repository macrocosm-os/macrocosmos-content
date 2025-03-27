# Examples

## **Chat Completions Script**&#x20;

```python
import asyncio
import time

import openai
start = time.time()

STREAM = True
# PUT YOUR API KEY HERE.
API_KEY = ""
VALIDATOR_KEY = ""


def make_header(api_key: str, validator_key: str):
    return {
        "api-key": f"{api_key}",
        "validator-key": f"{validator_key}",
        "Content-Type": "application/json",
    }

async def call(year):
    try:
        client = openai.AsyncOpenAI(
            base_url="https://sn1.api.macrocosmos.ai/v1",
            max_retries=0,
            timeout=openai.Timeout(120, connect=10, read=110),
            api_key=API_KEY
        )

        payload = {
            "uids": [1, 2, 3],
            "messages": [
                {"role": "user", "content": "List 5 popular places in London"}
            ],
            "seed": 42,
            "task": "InferenceTask",
            "model": "hugging-quants/Meta-Llama-3.1-70B-Instruct-AWQ-INT4",
            "test_time_inference": False,
            "mixture": False,
            "sampling_parameters": {
                "do_sample": True,
                "max_new_tokens": 512,
                "temperature": 0.7,
                "top_k": 50,
                "top_p": 0.95
            },
            "inference_mode": "Reasoning-Fast",
            "json_format": True,
            "stream": STREAM
        }

        result = await client.chat.completions.create(
            model="hugging-quants/Meta-Llama-3.1-70B-Instruct-AWQ-INT4",
            messages=payload["messages"],
            stream=STREAM,
            extra_body=payload,
            extra_headers=make_header(API_KEY, VALIDATOR_KEY)
        )

        if not STREAM:
            print(result)
        else:
            chunks = []
            async for chunk in result:
                if chunk.choices[0].delta.content:
                    chunks.append(chunk.choices[0].delta.content)
            print("".join(chunks))
        print(time.time() - start)

    except openai.NotFoundError as e:
        print(f"API endpoint not found: {e}")
    except openai.AuthenticationError as e:
        print(f"Authentication failed: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    """Call API and get response."""
    timer_s = time.perf_counter()
    asyncio.run(call(0))  # The year parameter isn't used anymore, so we can pass any value
    timer = time.perf_counter() - timer_s
    print(f"Response time: {timer:.2f} seconds")
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



