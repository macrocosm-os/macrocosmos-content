---
description: API endpoints available for Subnet 1
---

# Subnet 1 API

### Table of Contents

* [Getting Started](subnet-1-api.md#getting-started)
* [API Management](subnet-1-api.md#api-management)
  * [Create API Key](subnet-1-api.md#create-api-key)
  * [Modify API Key](subnet-1-api.md#modify-api-key)
  * [Delete API Key](subnet-1-api.md#delete-api-key)
* [Miner Availabilities](subnet-1-api.md#miner-availabilities)
  * [Get Miner Availabilities](subnet-1-api.md#get-miner-availabilities)
  * [Get Available Miners](subnet-1-api.md#get-available-miners)
* [Chat Endpoints](subnet-1-api.md#chat-endpoints)
  * [Proxy Chat Completions](subnet-1-api.md#proxy-chat-completions)
* [Health](subnet-1-api.md#health)

***

### Getting Started

SN1 can run either in validator mode or in API mode. Both modes will require the validator hotkey.

API Documentation is available at the [here](https://sn1.api.macrocosmos.ai/redoc).

As a validator, you MUST be running one instance in validator mode and be able to launch an arbitrary number of API instances. These will proxy the responses from miners to the validator for scoring.

To set up and run the API server:

1. **Install dependencies**: Ensure all required dependencies are installed using Poetry.
2. **Set up the .env.api file**: Copy the .env.api.example file to .env.api and fill in the validator hotkey.
3. **Run the API server**: Start the server to access the API endpoints.

Use the following command:

```
# Run the API server
bash run_api.sh
```

***

### API Management

#### Create API Key



**Endpoint:** `POST /api_management/create-api-key/`

**Description:** Creates a new API key with a specified rate limit.

**Parameters:**

* **rate\_limit** (query, required): The rate limit for the API key (integer).
* **admin-key** (header, required): Admin key for authorization (string) defined by validator in `.env.validator`.

***

#### Modify API Key



**Endpoint:** `PUT /api_management/modify-api-key/{api_key}`

**Description:** Modifies the rate limit of an existing API key.

**Parameters:**

* **api\_key** (path, required): The API key to modify (string).
* **rate\_limit** (query, required): The new rate limit for the API key (integer).
* **admin-key** (header, required): Admin key for authorization (string) defined by validator in `.env.validator`.

***

#### Delete API Key



**Endpoint:** `DELETE /api_management/delete-api-key/{api_key}`

**Description:** Deletes an existing API key.

**Parameters:**

* **api\_key** (path, required): The API key to delete (string).
* **admin-key** (header, required): Admin key for authorization (string) defined by validator in `.env.validator`.

***

### Miner Availabilities



#### Get Miner Availabilities



**Endpoint:** `POST /miner_availabilities/miner_availabilities`

**Description:** Fetches miner availabilities based on provided UIDs.

**Request Body:**

* JSON array of integers or null (optional).

***

#### Get Available Miners



**Endpoint:** `GET /miner_availabilities/get_available_miners`

**Description:** Retrieves a list of available miners for a specific task and/or model.

**Parameters:**

* **task** (query, optional): The type of task (e.g., `QuestionAnsweringTask`, `Programming`, etc.).
* **model** (query, optional): The specific model (string).
* **k** (query, optional): The maximum number of results to return (integer, default: 10).

***

### Chat Endpoints



#### Proxy Chat Completions



**Endpoint:** `POST /v1/chat/completions`

**Description:** Proxies chat completions to an underlying GPT model.

**Parameters:**

* **api-key** (header, required): API key for authorization (string).

Example call using the OpenAI client:

```
def make_header(api_key: str):
    return {
        "api-key": f"{api_key}",
        "Content-Type": "application/json",
    }

client = openai.AsyncOpenAI(
        base_url=f"http://213.173.105.104:11198/v1",
        max_retries=0,
        timeout=Timeout(30, connect=10, read=20),
        http_client=openai.DefaultAsyncHttpxClient(
            headers=make_header(API_KEY)  # Pass the headers here
        ),
        api_key=API_KEY
)

result = await client.chat.completions.create(
    model="hugging-quants/Meta-Llama-3.1-70B-Instruct-AWQ-INT4",
    messages=[
            {"role": "user", "content": """How are you?"""},
        ],
    stream=True,
    temperature=0.7,
    extra_body={
        "task": "InferenceTask",
        "sampling_parameters": {
            "mixture": False,
            "max_new_tokens": 256,
            "do_sample": True,
        },
    },
    seed=42,
    extra_headers=make_header(API_KEY),
)
```

You can pass `"mixture": True` in the extra\_body to use SN1's mixture of miners mode.

***

Web Retrieval

**Endpoint:** `GET /web_retrieval`

**Description:** Retrieves a list of websites about a search query

**Parameters:**

* **search\_query** (str): The search term you'd like to look up
* **n\_miners** (int, optional): How many miners to query
* **uids**: (list\[int], optional): which specific uids to query (Deprecated)

***

### Health



**Endpoint:** `GET /health`

**Description:** Health check endpoint.

