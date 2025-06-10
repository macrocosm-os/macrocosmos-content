---
description: >-
  Apex (SN1) enables developers to interact with decentralized LLMs and access
  web-retrieved responses.
---

# Subnet 1 Apex API

## Quickstart

Use `ApexClient` to send prompts to open-source language models like LLaMA and Mistral, or perform web-augmented completions using subnet-based retrieval.

{% tabs %}
{% tab title="Python" %}
```python
pip install macrocosmos
```
{% endtab %}

{% tab title="Typescript" %}
```javascript
npm install macrocosmos
```
{% endtab %}
{% endtabs %}

Macrocosmos SDK should be version 1.0.4+

### Chat Completions&#x20;

Send a prompt to an LLM on the Apex subnet.

{% tabs %}
{% tab title="Typescript" %}
```typescript
import { ApexClient } from 'macrocosmos';

// Initialize the client
const client = new ApexClient({ apiKey: 'your-api-key' });

// Chat completions
const response = await client.chat.completions.create({
  messages: [
    { role: 'user', content: 'Write a short story about a cosmonaut learning to paint.' }
    ],
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.ApexClient(api_key="your-api-key")
response = client.chat.completions.create(
    messages=[{"role": "user", "content": "Write a short story about a cosmonaut learning to paint."}
    ]
)

print(response)
```
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {
        "role": "user",
        "content": "Write a short story about a cosmonaut learning to paint."
      }
    ],
    "sampling_parameters": {
      "temperature": 0.7,
      "top_p": 0.95,
      "max_new_tokens": 256,
      "do_sample": true
    }
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/apex.v1.ApexService/ChatCompletion
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{
    "messages": [
      {
        "role": "user",
        "content": "Write a short story about a cosmonaut learning to paint."
      }
    ],
    "sampling_parameters": {
      "temperature": 0.7,
      "top_p": 0.95,
      "max_new_tokens": 256,
      "do_sample": true
    }
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  apex.v1.ApexService/ChatCompletion
```
{% endtab %}
{% endtabs %}



**Body**

| Name       | Type   | Description                                            |
| ---------- | ------ | ------------------------------------------------------ |
| `messages` | string | A list of messages in chat format (`role`, `content`). |

**Response**

{% tabs %}
{% tab title="200" %}
```json
{
  "id": "e1e94d9d-xxxx-xxxx-xxxx-c25d44b22e8a",
  "choices": [
    {
      "finishReason": "stop",
      "message": {
        "content": "In the quiet hum of the Mir space station, cosmonaut Ivan Kovalenko floated through the modules, his mind a million miles away from the routine tasks he had completed for the day. He had always been a man of science, of precision and logic, but lately, he found himself yearning for something more—something creative.\n\nBack on Earth, Ivan had seen an exhibition of space-themed art. The vibrant colors and sweeping brushstrokes had stirred something within him. He wanted to capture the beauty he saw every day from his unique vantage point, but he had no idea where to start.\n\nIvan decided to write a letter to his old friend, Marina, an artist who lived in Moscow. He described his newfound interest and asked if she could send him some art supplies and perhaps some guidance. Marina, always eager to support her friends, quickly assembled a package of paints, brushes, and a small canvas board, along with a detailed letter on how to begin.\n\nA few weeks later, a resupply mission delivered the package to Ivan. He eagerly opened it, his heart pounding with a mix of excitement and nervousness. He had never held a paintbrush before, let alone tried to create something with it.\n\nIvan started with the basics",
        "role": "assistant"
      }
    }
  ],
  "created": "1749034638",
  "model": "mrfakename/mistral-small-3.1-24b-instruct-2503-hf",
  "object": "chat.completion"
}
```
{% endtab %}

{% tab title="400" %}
```json
{
  "error": "Invalid request"
}
```
{% endtab %}
{% endtabs %}



### Web Search

Use Apex's integrated web retriever to fetch relevant content.

{% tabs %}
{% tab title="Typescript" %}
```javascript
import { ApexClient } from 'macrocosmos';

// Initialize the client
const client = new ApexClient({ apiKey: 'your-api-key' });

// Web retrieval
const webResults = await client.webRetrieval({
    searchQuery: "What is Bittensor?",
    nMiners: 3,
    nResults: 2,
    maxResponseTime: 30,
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.ApexClient(api_key="your-api-key")
response = client.web_search.search(
    search_query="What is Bittensor?",
    n_miners=3,
    max_results_per_miner=2,
    max_response_time=30
)

print(response)
```
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "search_query": "What is Bittensor?",
    "n_miners": 3,
    "max_results_per_miner": 2,
    "max_response_time": 30
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/apex.v1.ApexService/WebRetrieval
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{
    "search_query": "What is Bittensor?",
    "n_miners": 3,
    "max_results_per_miner": 2,
    "max_response_time": 30
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  apex.v1.ApexService/WebRetrieval
```
{% endtab %}
{% endtabs %}

**Body**

| Name              | Type   | Description                                                                                                                                                                                    |
| ----------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `searchQuery`     | string | The search term or natural language query.                                                                                                                                                     |
| `nMiners`         | int    | <p><code>[Optional]</code><br><br>Default: <code>3</code> </p><p></p><p>Number of miners to use for the search query</p>                                                                       |
| `nResults`        | int    | <p><code>[Optional]</code></p><p></p><p>Default: <code>1</code><br><br>Maximum number of results to return per miner (maximum possible response results = <code>nMiners x nResults</code>)</p> |
| `maxResponseTime` | int    | <p><code>[Optional]</code></p><p></p><p>Default: <code>20</code><br><br>Maximum time (in seconds) to wait for subnet miner responses. .</p>                                                    |

**Response**

{% tabs %}
{% tab title="200" %}
```json
{
  "results": [
    {
      "url": "https://docs.bittensor.com/",
      "content": "Bittensor Documentation\nBittensor is an open source platform where participants produce best-in-class digital commodities, including compute power, storage space, artificial intelligence (AI) inference and training, protein folding, financial markets prediction, and many more.\nBittensor is composed of distinct subnets . Each subnet is an independent community of miners (who produce the commodity), and validators (who evaluate the miners' work).\nThe Bittensor network constantly emits liquidity, in the form of its token, TAO (τ \\tau τ ), to participants in proportion to the value of their contributions. Participants include:\nMiners —Work to produce digital commodities. See mining in Bittensor .\nValidators —Evaluate the quality of miners' work. See validating in Bittensor\nSubnet Creators —Manage the incentive mechanisms that specify the work miners and validate must perform and evaluate, respectively. See Create a Subnet\nStakers —TAO holders can support specific validators by staking TAO to them. See Staking .\nBrowse the subnets and explore links to their code repositories on TAO.app 's subnets listings.\nBittensor frequently asked questions (FAQ)\nEverything you were afraid to ask about Bittensor.\nREAD MORE Subnet Listings on TAO.app\nDiscover the subnets that power Bittensor and browse real-time tokenomic data and analytics.\nREAD MORE BTCLI Live Coding Playground\nTry out some BTCLI functionality right in the browser.\nREAD MORE Introduction to Bittensor\nLearn fundamental Bittensor concepts\nREAD MORE Guide to Bittensor tools\nOpentensor Foundation maintains open source tools for the Bittensor ecosystem, including the Python SDK and `btcli`.\nREAD MORE Bittensor media assets\nMedia assets\nParticipate\nYou can participate in an existing subnet as either a subnet validator or a subnet miner, or by staking your TAO to running validators.\nStaking and Delegation\nGet to know how staking and delegating in the Bittensor network.\nREAD MORE Mining in Bittensor\nGet ready to mine on Bittensor subnets\nREAD MORE Mining in Bittensor\nGet ready to validate on Bittensor subnets\nREAD MORE Emissions\nLearn how emissions are calculated.\nREAD MORE Governance\nLearn how the Bittensor governance works as it transitions into full community-ownership over time.\nREAD MORE Senate\nUnderstand what Senate is, requirements to participate in a Senate and how voting works.\nREAD MORE\nRunning a subnet\nReady to run your own subnet? Follow the below links.\nBasic subnet tutorials\nLearn how to run a simple subnet locally or on testchain or mainchain.\nREAD MORE Create a subnet\nStep-by-step instructions for creating a local subnet or a subnet on testchain or mainchain.\nREAD MORE OCR subnet tutorial\nShows how to convert your Python notebook containing validated code for an incentive mechanism into a working subnet.\nREAD MORE Subnet hyperparameters\nGet to know subnet hyperparameters and how to use them effectively. As a subnet creator, your success depends on this knowledge.\nREAD MORE\nBittensor CLI, SDK, Wallet SDK\nUse the Bittensor CLI and SDK and Wallet SDK to develop and participate in the Bittensor network.\nlooking for legacy bittensor 7.4.0 docs?",
      "relevant": "Bittensor Documentation\nBittensor is an open source platform where participants produce best-in-class digital commodities, including compute power, storage space, artificial intelligence (AI) inference and training, protein folding, financial markets prediction, and many more.\nBittensor is composed of distinct subnets . Each subnet is an independent community of miners (who produce the commodity), and validators (who evaluate the miners' work).\nThe Bittensor network constantly emits liquidity, in the form of its token, TAO (τ \\tau τ ), to participants in proportion to the value of their contributions. Participants include:\nMiners —Work to produce digital commodities. See mining in Bittensor .\nValidators —Evaluate the quality of miners' work. See validating in Bittensor\nSubnet Creators —Manage the incentive mechanisms that specify the work miners and validate must perform and evaluate, respectively. See Create a Subnet\nStakers —TAO holders can support specific validators by staking TAO to them. See Staking .\nBrowse the subnets and explore links to their code repositories on TAO.app 's subnets listings.\nBittensor frequently asked questions (FAQ)\nEverything you were afraid to ask about Bittensor.\nREAD MORE Subnet Listings on TAO.app\nDiscover the subnets that power Bittensor and browse real-time tokenomic data and analytics.\nREAD MORE BTCLI Live Coding Playground\nTry out some BTCLI functionality right in the browser.\nREAD MORE Introduction to Bittensor\nLearn fundamental Bittensor concepts\nREAD MORE Guide to Bittensor tools\nOpentensor Foundation maintains open source tools for the Bittensor ecosystem, including the Python SDK and `btcli`.\nREAD MORE Bittensor media assets\nMedia assets\nParticipate\nYou can participate in an existing subnet as either a subnet validator or a subnet miner, or by staking your TAO to running validators.\nStaking and Delegation\nGet to know how staking and delegating in the Bittensor network.\nREAD MORE Mining in Bittensor\nGet ready to mine on Bittensor subnets\nREAD MORE Mining in Bittensor\nGet ready to validate on Bittensor subnets\nREAD MORE Emissions\nLearn how emissions are calculated.\nREAD MORE Governance\nLearn how the Bittensor governance works as it transitions into full community-ownership over time.\nREAD MORE Senate\nUnderstand what Senate is, requirements to participate in a Senate and how voting works.\nREAD MORE\nRunning a subnet\nReady to run your own subnet? Follow the below links.\nBasic subnet tutorials\nLearn how to run a simple subnet locally or on testchain or mainchain.\nREAD MORE Create a subnet\nStep-by-step instructions for creating a local subnet or a subnet on testchain or mainchain.\nREAD MORE OCR subnet tutorial\nShows how to convert your Python notebook containing validated code for an incentive mechanism into a working subnet.\nREAD MORE Subnet hyperparameters\nGet to know subnet hyperparameters and how to use them effectively. As a subnet creator, your success depends on this knowledge.\nREAD MORE\nBittensor CLI, SDK, Wallet SDK\nUse the Bittensor CLI and SDK and Wallet SDK to develop and participate in the Bittensor network.\nlooking for legacy bittensor 7.4.0 docs?"
    },
    {
      "url": "https://www.bittensor.ai/what-is-bittensor",
      "content": "What is Bittensor?\nWe understand that Bittensor can seem complex, so we’re here to make it simple and help you unlock its potential.\nAt its core, Bittensor is a decentralized network where AI models compete, collaborate and improve. Bittensor provides pathways for these models to be commercialized as AI services. Bittensor allows anyone to invest in and contribute to the network and earn TAO based on their financial or technical contributions.\nBlockchain\nA secure, digital record of transactions across many computers.\nDecentralized\nA system where control is shared, not owned by one entity.\nMiners\nA participant who provides computing power to train AI and earns rewards.\nValidators\nSomeone who checks and verifies network work for accuracy.\nSubnets\nSpecialized sections of the network that handle specific AI tasks.\nTao\nDigital currency you earn for contributing to the Bittensor network.\nHow Does Bittensor Work?\nBittensor is a decentralized, blockchain-powered network that enables open participation in artificial intelligence (AI) development. Unlike traditional AI platforms controlled by large companies, Bittensor allows individuals and organizations to contribute computational power to train, validate, and improve AI models while earning rewards through TAO, the network’s native cryptocurrency.\nThe network operates through a collaborative infrastructure where miners provide computational resources, and validators ensure the accuracy of AI outputs. This decentralized model fosters global innovation and makes AI development more accessible, removing control from a few big companies and allowing anyone to contribute and benefit.\nBy using blockchain technology, Bittensor guarantees transparency and trust, as all contributions and transactions are recorded on-chain. For newcomers, Bittensor represents a shift in how AI is built, offering opportunities for anyone with resources to participate in a scalable, transparent, and open AI ecosystem.\nBitcoin vs Bittensor (TAO)\nUnlike traditional AI models managed by giants like Google and OpenAI, Bittensor’s decentralized approach ensures that the AI ecosystem remains unbiased, transparent, and driven by the community.\nJoin Bittensor.ai to experience a model where freedom of speech and innovation are prioritized, providing a platform where everyone can contribute and benefit equally.\nDigital currency and store of value\nProof of Work (PoW)\nFinancial Transactions\nBlockchain\nEnergy Intensive\nDecentralized Network for AI\nProof of Intelligence (POI)\nCreation and Management of AI\nBlockchain + Variety of AI Models\nEnergy Efficient\nBittensor uses Blockchain technology to create Artificial intelligence\nThe tokenomics of Bittensor (TAO) are very similar to Bitcoin, with the additional benefit of being coupled to intelligence and AI.\nDecentralized AI\nTraditional AI development is dominated by a few large corporations, but Bittensor is changing the game by creating a decentralized AI network. In this open ecosystem, anyone can contribute to training, validating, and utilizing AI models. This shift puts power into the hands of individuals and communities, driving innovation and collaboration while ensuring transparency and fairness.\nBittensor decentralizes AI by distributing the development and training of models across a global network. Instead of one entity controlling the process, contributors like validators and miners help verify and power AI models. Validators ensure data integrity, miners provide computational power, and all participants are rewarded with TAO tokens for their efforts.\nCentralized\nDecentralized\nDecentralized also means security-Bittensor's decentralized nature ensures that your data and contributions are safe.\nJoin a cutting-edge decentralized network powered by secure technology, offering unparalleled security and transparency by eliminating single points of failure and protecting your contributions.\nWhy Decentralized AI Matters\n1. Breaking Centralized Control\nBittensor democratizes AI by allowing anyone to contribute, breaking the monopoly of large corporations.\n2. Fostering Innovation\nOpen collaboration across a diverse network of contributors drives faster, broader AI advancements.\n3. Incentives\nParticipants are rewarded with TAO tokens, creating a fair ecosystem where contributions are recognized and compensated.\n4. Transparency\nBuilt on blockchain, Bittensor ensures transparent and verifiable AI development, fostering trust in the process.\n5. Scalable Intelligence\nDecentralized AI allows for infinite scaling, with contributions from around the world forming a continuously improving system.\nBittensor makes AI development open, transparent, and accessible. By decentralizing the process, Bittensor accelerates AI innovation and ensures everyone has a chance to contribute—and be rewarded. Join the Bittensor network and shape the future of decentralized AI.",
      "relevant": "What is Bittensor?\nWe understand that Bittensor can seem complex, so we’re here to make it simple and help you unlock its potential.\nAt its core, Bittensor is a decentralized network where AI models compete, collaborate and improve. Bittensor provides pathways for these models to be commercialized as AI services. Bittensor allows anyone to invest in and contribute to the network and earn TAO based on their financial or technical contributions.\nBlockchain\nA secure, digital record of transactions across many computers.\nDecentralized\nA system where control is shared, not owned by one entity.\nMiners\nA participant who provides computing power to train AI and earns rewards.\nValidators\nSomeone who checks and verifies network work for accuracy.\nSubnets\nSpecialized sections of the network that handle specific AI tasks.\nTao\nDigital currency you earn for contributing to the Bittensor network.\nHow Does Bittensor Work?\nBittensor is a decentralized, blockchain-powered network that enables open participation in artificial intelligence (AI) development. Unlike traditional AI platforms controlled by large companies, Bittensor allows individuals and organizations to contribute computational power to train, validate, and improve AI models while earning rewards through TAO, the network’s native cryptocurrency.\nThe network operates through a collaborative infrastructure where miners provide computational resources, and validators ensure the accuracy of AI outputs. This decentralized model fosters global innovation and makes AI development more accessible, removing control from a few big companies and allowing anyone to contribute and benefit.\nBy using blockchain technology, Bittensor guarantees transparency and trust, as all contributions and transactions are recorded on-chain. For newcomers, Bittensor represents a shift in how AI is built, offering opportunities for anyone with resources to participate in a scalable, transparent, and open AI ecosystem.\nBitcoin vs Bittensor (TAO)\nUnlike traditional AI models managed by giants like Google and OpenAI, Bittensor’s decentralized approach ensures that the AI ecosystem remains unbiased, transparent, and driven by the community.\nJoin Bittensor.ai to experience a model where freedom of speech and innovation are prioritized, providing a platform where everyone can contribute and benefit equally.\nDigital currency and store of value\nProof of Work (PoW)\nFinancial Transactions\nBlockchain\nEnergy Intensive\nDecentralized Network for AI\nProof of Intelligence (POI)\nCreation and Management of AI\nBlockchain + Variety of AI Models\nEnergy Efficient\nBittensor uses Blockchain technology to create Artificial intelligence\nThe tokenomics of Bittensor (TAO) are very similar to Bitcoin, with the additional benefit of being coupled to intelligence and AI.\nDecentralized AI\nTraditional AI development is dominated by a few large corporations, but Bittensor is changing the game by creating a decentralized AI network. In this open ecosystem, anyone can contribute to training, validating, and utilizing AI models. This shift puts power into the hands of individuals and communities, driving innovation and collaboration while ensuring transparency and fairness.\nBittensor decentralizes AI by distributing the development and training of models across a global network. Instead of one entity controlling the process, contributors like validators and miners help verify and power AI models. Validators ensure data integrity, miners provide computational power, and all participants are rewarded with TAO tokens for their efforts.\nCentralized\nDecentralized\nDecentralized also means security-Bittensor's decentralized nature ensures that your data and contributions are safe.\nJoin a cutting-edge decentralized network powered by secure technology, offering unparalleled security and transparency by eliminating single points of failure and protecting your contributions.\nWhy Decentralized AI Matters\n1. Breaking Centralized Control\nBittensor democratizes AI by allowing anyone to contribute, breaking the monopoly of large corporations.\n2. Fostering Innovation\nOpen collaboration across a diverse network of contributors drives faster, broader AI advancements.\n3. Incentives\nParticipants are rewarded with TAO tokens, creating a fair ecosystem where contributions are recognized and compensated.\n4. Transparency\nBuilt on blockchain, Bittensor ensures transparent and verifiable AI development, fostering trust in the process.\n5. Scalable Intelligence\nDecentralized AI allows for infinite scaling, with contributions from around the world forming a continuously improving system.\nBittensor makes AI development open, transparent, and accessible. By decentralizing the process, Bittensor accelerates AI innovation and ensures everyone has a chance to contribute—and be rewarded. Join the Bittensor network and shape the future of decentralized AI."
    }
  ]
}
```
{% endtab %}

{% tab title="400" %}
```json
{
  "error": "Invalid request"
}
```
{% endtab %}
{% endtabs %}

### Deep Research

Apex’s Deep Researcher leverages advanced reasoning to synthesize vast volumes of online information, executing complex, multi-step research tasks to deliver insightful and well-considered responses to user prompts.

#### Deep Research example script

This example demonstrates how to use the Apex DeepResearch API asynchronously with the Macrocosmos SDK, by supplying your Macrocosmos API-key and deep research messages. The script:

1. Submits a deep research job using `create_job`, returning metadata such as `job_id` and `created_at`.
2. Polls for job progress by periodically calling `get_job_results(job_id)` until the job completes.
3. Prints new results as they are generated by the DeepResearch backend, filtering updates based on when the job was last updated (`last_updated`) and tracking new arrivals using the sequence ID (`seq_id`).
4. Displays the final result once the job is marked as "completed".

```python
"""
Example of using the Apex DeepResearch API asynchronously with Macrocosmos SDK.
Demonstrates how a deep researcher job can be polled at regular intervals
to check its current status and retrieve the latest results generated.
"""

import asyncio
import os
import json
from typing import Optional, Any, List

import macrocosmos as mc


def extract_content_from_chunk(chunk_str: str) -> Optional[str]:
    """Extract content from a JSON chunk string if available."""
    try:
        chunk_list = json.loads(chunk_str)
        if chunk_list and len(chunk_list) > 0 and "content" in chunk_list[0]:
            return chunk_list[0]["content"]
    except (json.JSONDecodeError, IndexError, KeyError) as e:
        print(f"Failed to parse chunk: {e}")
    return None


async def process_result_chunks(results: List[Any], last_seq_id: int) -> int:
    """Process result chunks and return the new last sequence ID."""
    for item in results:
        try:
            seq_id = int(item.seq_id)
            if seq_id > last_seq_id:
                if content := extract_content_from_chunk(item.chunk):
                    print(f"\nseq_id {seq_id}:\n{content}")
                    last_seq_id = seq_id
        except (ValueError, AttributeError) as e:
            print(f"Error processing sequence: {e}")
    return last_seq_id


async def demo_deep_research_polling():
    """Demo asynchronous deep research job creation and update polling."""
    print("\nRunning asynchronous Deep Research example...")

    api_key = "your-api-key"

    client = mc.AsyncApexClient(
        api_key=api_key, app_name="examples/apex_deep_research_polling.py"
    )

    # Create a deep research job with create_job
    submitted_response = await client.deep_research.create_job(
        messages=[
            {
                "role": "user",
                "content": """Can you propose a mechanism by which a decentralized network 
                of AI agents could achieve provable alignment on abstract ethical principles 
                without relying on human-defined ontologies or centralized arbitration?""",
            }
        ]
    )

    print("\nCreated deep research job.\n")
    print(f"Initial status: {submitted_response.status}")
    print(f"Job ID: {submitted_response.job_id}")
    print(f"Created at: {submitted_response.created_at}\n")

    # Poll for job status with get_job_results based on the job_id
    print("Polling the results...")
    last_seq_id = -1  # Track the highest sequence ID we've seen
    last_updated = None  # Track the last update time
    while True:
        try:
            polled_response = await client.deep_research.get_job_results(
                submitted_response.job_id
            )
            current_status = polled_response.status
            current_updated = polled_response.updated_at

            # On completion, print the final answer and its sequence ID
            if current_status == "completed":
                print("\nJob completed successfully!")
                print(f"\nLast update at: {current_updated}")
                if polled_response.result:
                    if content := extract_content_from_chunk(
                        polled_response.result[-1].chunk
                    ):
                        print(
                            f"\nFinal answer (seq_id {polled_response.result[-1].seq_id}):\n{content}"
                        )
                break

            elif current_status == "failed":
                print(
                    f"\nJob failed: {polled_response.error if hasattr(polled_response, 'error') else 'Unknown error'}"
                )
                print(f"\nLast update at: {current_updated}")
                break

            # Check if we have new content by comparing update times
            if current_updated != last_updated:
                print(f"\nNew update at {current_updated}")
                print(f"Status: {current_status}")

                # Process new content
                if polled_response.result:
                    last_seq_id = await process_result_chunks(
                        polled_response.result, last_seq_id
                    )
                else:
                    print(
                        "No results available yet. Waiting for Deep Researcher to generate data..."
                    )
                last_updated = current_updated

        except Exception as e:
            print(f"Error during polling: {e}")

        await asyncio.sleep(20)  # Poll in 20 second intervals


if __name__ == "__main__":
    asyncio.run(demo_deep_research_polling())

```

### Deep Research Endpoints

#### Submit a deep researcher Job

{% tabs %}
{% tab title="Typescript" %}
```typescript
import { ApexClient } from 'macrocosmos';

// Initialize the client
const client = new ApexClient({ apiKey: 'your-api-key' });

// Submit a deep research job
const submittedResponse = await client.submitDeepResearcherJob({
      messages: [
      { role: "user",
        content: `Can you propose a mechanism by which a decentralized network 
        of AI agents could achieve provable alignment on abstract ethical principles 
        without relying on human-defined ontologies or centralized arbitration?`},
    ],
      seed: 42,
      model: "Default",
      samplingParameters: {
        temperature: 0.7,
        topP: 0.95,
        maxNewTokens: 8192,
        doSample: false,
      },
    }); // produces a unique jobId
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.ApexClient(api_key="your-api-key")

submitted_response = client.deep_research.create_job(
    messages=[
        {
            "role": "user",
            "content": """Can you propose a mechanism by which a decentralized network 
            of AI agents could achieve provable alignment on abstract ethical principles 
            without relying on human-defined ontologies or centralized arbitration?""",
        }
    ],
    seed=42,
    model="Default",
    sampling_parameters={
        "temperature": 0.7,
        "top_p": 0.95,
        "max_new_tokens": 8192,
        "do_sample": False
    },
) # produces a unique job_id

print(submitted_response)
```
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {
        "role": "user",
        "content": "Can you propose a mechanism by which a decentralized network of AI agents could achieve provable alignment on abstract ethical principles without relying on human-defined ontologies or centralized arbitration?"
      }
    ],
    "seed": 42,
    "model": "Default",
    "sampling_parameters": {
      "temperature": 0.7,
      "top_p": 0.95,
      "max_new_tokens": 8192,
      "do_sample": false
    },
    "stream": true,
    "task": "InferenceTask",
    "mixture": false,
    "inference_mode": "Chain-of-Thought"
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/apex.v1.ApexService/SubmitDeepResearcherJob
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{
    "messages": [
      {
        "role": "user",
        "content": "Can you propose a mechanism by which a decentralized network of AI agents could achieve provable alignment on abstract ethical principles without relying on human-defined ontologies or centralized arbitration?"
      }
    ],
    "seed": 42,
    "model": "Default",
    "sampling_parameters": {
      "temperature": 0.7,
      "top_p": 0.95,
      "max_new_tokens": 8192,
      "do_sample": false
    },
    "stream": true,
    "task": "InferenceTask",
    "mixture": false,
    "inference_mode": "Chain-of-Thought"
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  apex.v1.ApexService/SubmitDeepResearcherJob
```
{% endtab %}
{% endtabs %}

#### Body

| Name                 | Type                         | Description                                                                                                                                                                                             |
| -------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `messages`           | Array of `Messages` objects  | List of message objects with 'role' and 'content' keys. Roles can be 'system', 'user', or 'assistant'.                                                                                                  |
| `seed`               | int                          | <p><code>[Optional]</code> </p><p></p><p>Default: <code>Random int between [0, 1000000]</code></p><p></p><p>Random seed for reproducible results. If not provided, a random seed will be generated.</p> |
| `model`              | string                       | <p><code>[Optional]</code> </p><p></p><p>Default: <code>"Default"</code> </p><p></p><p>Model identifier to filter available miners.</p>                                                                 |
| `samplingParameters` | `SamplingParameters` object  | <p>Example: <code>{"temperature":0.7,"top_p":0.95,"top_k":50,"max_new_tokens":1024,"do_sample":true}</code> </p><p></p><p>Parameters to control text generation, such as temperature, top_p, etc.</p>   |

#### Response

{% tabs %}
{% tab title="200" %}
```json
{
  "jobId": "6eb69148-xxxx-xxxx-xxxx-b6dd81120377",
  "status": "pending",
  "createdAt": "2025-05-30T14:32:05.758727Z",
  "updatedAt": "2025-05-30T14:32:05.758727Z"
}
```
{% endtab %}

{% tab title="400" %}
```json
{
  "error": "Invalid request"
}
```
{% endtab %}
{% endtabs %}

#### Retrieve the results of a deep researcher job

{% tabs %}
{% tab title="Typescript" %}
```typescript
import { ApexClient } from 'macrocosmos';

// Initialize the client
const client = new ApexClient({ apiKey: 'your-api-key' });

// Get the results of a deep research job using a job_id from submittedResponse
const polledResponse = await client.getDeepResearcherJob({jobId: 'your-job-id'});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.ApexClient(api_key="your-api-key")
    
# Get the results of a deep research job using a job_id from submitted_response
polled_response = client.deep_research.get_job_results(job_id="your-job-id")

print(polled_response)
```
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "job_id": "your-job-id"
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/apex.v1.ApexService/GetDeepResearcherJob
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{
    "job_id": "your_job_id"
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  apex.v1.ApexService/GetDeepResearcherJob
```
{% endtab %}
{% endtabs %}

#### Body

| Name    | Type   | Description                                                               |
| ------- | ------ | ------------------------------------------------------------------------- |
| `jobId` | string | The unique Deep Researcher `jobId` , produced by `deepResearch.createJob` |

#### Response

{% tabs %}
{% tab title="200" %}
```json
{
  "jobId": "6eb69148-xxx-xxx-xxx-b6dd81120377",
  "status": "running",
  "createdAt": "2025-05-30T14:32:05.758727Z",
  "updatedAt": "2025-05-30T14:35:33.985242Z",
  "result": [
    {
      "seqId": "1",
      "chunk": "[{\"content\": \"## Generating Research Plan\\n\"}]"
    }
  ]
}
```
{% endtab %}

{% tab title="400" %}
```json
{
  "error": "Invalid request"
}
```
{% endtab %}
{% endtabs %}

### Get Stored Chat Completions (Coming Soon)

Get the stored chat completions for the given chat. The input to this endpoint is a unique chat id.

{% tabs %}
{% tab title="Typescript" %}
```typescript
import { ApexClient } from 'macrocosmos';

// Initialize the client
const client = new ApexClient({ apiKey: 'your-api-key' });

// Get Stored chat completions
const result = await client.getStoredChatCompletions({ chatId });
```
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "chat_id": "a-unique-chat-id"
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/apex.v1.ApexService/GetStoredChatCompletions
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{"chat_id": "a-unique-chat-id"}' \
  constellation.api.cloud.macrocosmos.ai:443 \
  apex.v1.ApexService/GetStoredChatCompletions
```
{% endtab %}
{% endtabs %}



**Body**

| Name      | Type   | Description                                   |
| --------- | ------ | --------------------------------------------- |
| `chat_id` | string | The id of the chat this completion belongs to |

**Response**

{% tabs %}
{% tab title="200" %}
```json
{
  "chatCompletions": [
    {
      "id": "000f172b-479e-4272-aff5-8f87d5bfe5af",
      "chatId": "d90a4724-2dc4-4058-82d1-c95120eee777",
      "completionType": "chain-of-thought",
      "createdAt": "2025-05-22T11:09:33.153507Z",
      "completedAt": "2025-05-22T11:09:33.153507Z",
      "userPromptText": "tell me a neural networks",
      "completionText": "Researching",
      "metadata": {
        "deep-researcher": {
          "createdAt": "2025-05-22T11:09:34.179781Z",
          "jobId": "ee724a2b-70c8-4f95-8147-62b3512cc614",
          "status": "completed"
        },
        "status": {
          "content": "Done.",
          "status": "in-progress"
        },
        "thoughts": [
          "undefined Neural networks are a series of algorithms modeled after the human brain that are designed to recognize patterns. They interpret sensory data through a kind of machine perception, labeling or clustering raw input. The patterns they recognize are numerical, contained in vectors, into which all real-world data, be it images, sound, text or time series, must be translated. Neural networks can adapt to changing input so that they learn to perform tasks better over time. They are used in a wide variety of applications, including image and speech recognition, natural language processing, and predictive analytics."
        ]
      }
    }
```
{% endtab %}
{% endtabs %}
