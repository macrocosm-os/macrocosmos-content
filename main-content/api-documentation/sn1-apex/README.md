---
description: Getting started -  LLM Prompting on Macrocosmos
---

# SN1 - APEX

Welcome to **APEX** , the first live Large Language Model application on the [Bittensor network](https://bittensor.com/)  and the heart of the Macrocosmos Constellation platform.&#x20;

### ✨How does it work?

APEX is a specialized LLM app focused on high-quality language model inference. Powered by validators and a constantly evolving pool of miners, it allows users:

* &#x20;Generate LLM completions using top open-source models
* Retrieve real-time web results&#x20;
* Leverage advanced inference modes like multi-step reasoning or test-time thinking



Try the visual interface at [**Mission Command**](https://app.macrocosmos.ai/mission-command) — a control center for LLM testing and prompting.&#x20;

***

### 🧭 How the APEX API Works

At its core, the APEX API has two main endpoints:

* `POST /v1/chat/completions` – Send chat-style messages to receive a generated response
* `POST /web_retrieval` – Perform decentralized web search via multiple miners

Each request is routed to miners across the subnet based on task requirements, model filters, and optional parameters you provide. Validators coordinate execution, verify quality, and return reliable completions.

***

### 🧠 Models Available

SN1 currently supports the following open-source models:

* &#x20;`Meta-Llama-3.1-70B-Instruct-AWQ-INT4`
* `Mistral-Small-3.1-24B-Instruct`

...with [Google's Gemma 3 27B](https://huggingface.co/google/gemma-3-27b-it) on the roadmap.

For more details, see our [supported-models.md](supported-models.md "mention")page.

***

### 🤝 Need Help?

If you have any questions or require support, please message us in our official [**Macrocosmos Discord**](https://discord.gg/sXJPmGTnVR) server . You can drop a message in the `#apex-sn1` channel.
