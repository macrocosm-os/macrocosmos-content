---
description: >-
  A walkthrough for setting up and running the SN1 base miner from the
  macrocosm-os/prompting repository. It is intended for educational purposes and
  should not be used on mainnnet
---

# Subnet 1: Base Miner Setup

### ⚠️ Disclaimer

> **Do not run this miner on mainnet.**
>
> The base miner is solely for educational and testing purposes. Running this miner on mainnet will not yield any rewards. Any expenses incurred during registration or infrastructure setup will not be reimbursed

#### 🖥️ Compute Requirements

* **VRAM:** None
* **vCPU:** 8 cores
* **RAM:** 8 GB
* **Storage:** 80 GB



#### Installation&#x20;

1. **Clone the Repository:**

```bash
git clone https://github.com/macrocosm-os/prompting.git
cd prompting
```



2. **Run the Installation Script:**

```bash
scripts/install.sh
```

Before running the miner, you need to set up miner environment variables



#### Configure \`.env.miner\` file&#x20;

1. **Create a `.env.miner` File:**

```bash
cp .env.miner.example .env.miner
```



2. **Edit `.env.miner` with Appropriate Values:**

```ini
# Network UID (e.g., 61 for testnet)
NETUID=61

# Network name: test, main, or local
SUBTENSOR_NETWORK=test

# Chain endpoint (set to None for testnet)
SUBTENSOR_CHAIN_ENDPOINT=None

# Wallet (coldkey) name
WALLET_NAME=your_wallet_name

# Hotkey name associated with the wallet
HOTKEY=your_hotkey_name

# Open port for network connections
AXON_PORT=12345

# OpenAI API key (required for OpenAI test miner)
OPENAI_API_KEY=your_openai_api_key
```

Fill in the appropriate details e.g wallet name , hot key and port (so that validators can connect) _Ensure that the wallet and hotkey are properly registered on the testnet._



#### ⚙️ Running the Miner

After configuring your environment variables, start the miner using the following command:​

```bash
python neurons/miners/epistula_miner/miner.py
```



### Base Miner Functionalities

The SN1 base miner is designed to handle two primary tasks: Web Retrieval and Inference.

**1. Web Retrieval (`stream_web_retrieval`)**

The miner receives a query from validators, such as "What is the biggest event in 2025?" The miner's responsibility is to search the web for relevant information that answers this query.​

The process involves:​

* Searching for websites that contain information pertinent to the query.
* Extracting the content and identifying the most relevant section that answers the question.
* Formatting the results into a structured response.​

The implementation is located in `neurons/miners/epistula_miner/web_retrieval.py`. The function returns a list of dictionaries containing:​

* `url`: The website URL.
* `content`: The full text content of the page.
* `relevant`: A concise excerpt that directly answers the query.​

```python
return [
    {
        "url": result["website"],
        "content": result["text"],
        "relevant": result["best_chunk"],
    }
    for result in top_k
]
```



**2. Inference Task (`run_inference`)**

The Inference task involves utilizing a smaller version of the LLaMA model (`casperhansen/llama-3.2-3b-instruct-awq`) to perform language model inference.​

The process includes:​

* Receiving tasks directed to the `/v1/chat/completions` endpoint.
* Determining the task type (e.g., inference or web retrieval).
*   Invoking the appropriate method based on the task:​

    ```python
    if task == "inference":
        self.create_inference_completion(request)
    elif task == "web_retrieval":
        self.web_retrieval_method(request)
    ```

The implementation is located in `neurons/miners/epistula_miner/miner.py`. The `self.llm` attribute loads the LLaMA 3B model.​

_Note:_ The 3B model is suitable only for testnet but not for mainnet, where state-of-the-art models are prevalent, like: `mrfakename/mistral-small-3.1-24b-instruct-2503-hf`  and `hugging-quants/Meta-Llama-3.1-70B-Instruct-AWQ-INT4`&#x20;

To check for the latest required models, go to:  [https://github.com/macrocosm-os/prompting/blob/main/shared/settings.py#L141](https://github.com/macrocosm-os/prompting/blob/main/shared/settings.py#L141)



### Miner Availability Check

Validators also assess miner availability for tasks. Miners indicate how suited they are by setting task availability flags:​

```python
task_response = {key: True for key in task_availabilities}
```

If a miner determines it is unsuitable for a task, it sets the corresponding flag to `False`. This ensures that tasks are assigned to miners best equipped to handle them.



Relevant repository: [https://github.com/macrocosm-os/prompting](https://github.com/macrocosm-os/prompting)



