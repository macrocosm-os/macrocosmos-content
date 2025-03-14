---
description: Subnet 1 incentive system overview
---

# Subnet 1: Incentive Mechanism

Subnet 1 has pioneered several foundational methods in incentive design. We have innovated a robust meta-incentive mechanism which has made it possible to provide an objective and precise measure of intelligence across a diverse array of natural language tasks, which is a requirement for a multi-task agentic system. Validation is based on synthetic and organic data, and so is an inexhaustible resource.

Subnet 1 supports an ever-improving suite of challenging tasks. Today, these are:

1. **Web retrieval** - miners search the web for pages which match any user query.
2. **Web question answering** - RAG-style task where miners must use webpages to answer questions.
3. **Deterministic inference** - fully configurable inference of leading open-source models.
4. **Multi-step reasoning** - enhanced inference tasks which requires miners to match o1-style reasoning behaviour by either fine-tuning or using agentic workflows.
5. **Programming** - code completion using SOTA coding models.
6. **Benchmarking** - MMLU-style synthetic benchmarking data based on RAG.

By combining these complementary tasks into a single incentive mechanism, subnet 1 delivers the vital components of a modern agentic API which optimises for high-quality responses with low latency.

Our incentive mechanism is based on the similarity between miner completions and the validators’ own reference answers. High-quality reference answers are therefore of the most importance, as they set the target for the miners. The validators currently use Llama3 70B [\[Code Reference\]](https://github.com/macrocosm-os/prompting/blob/00d67a40732b831ac26c3bfc644b5ace7655f22b/prompting/utils/config.py#L287), which is of comparable quality to GPT-3.5 Turbo. To push miners to create models that outperform even Llama 70B, we use RAG generation to create the reference answers, which miners need to match. This produces a power imbalance, where miners have to continue innovating in order to match the validator’s references.

For brevity, let's break down the incentive mechanism for one of our tasks: web question answering. For further information, see our [SN1 Validation](https://github.com/macrocosm-os/prompting/blob/main/docs/SN1_validation.md) document. The process is:

* The validator pulls a random webpage indexed by DDG [\[Code Reference\]](https://github.com/macrocosm-os/prompting/blob/6ac1e78690af8ee1d895bc6f317cc8df6ed4fbc5/prompting/datasets/random_website.py#L24-L38).
* The validator LLM generates a “query” that can be objectively answered using the article contents [\[Code Reference\]](https://github.com/macrocosm-os/prompting/blob/6ac1e78690af8ee1d895bc6f317cc8df6ed4fbc5/prompting/tasks/qa.py#L21-L28).
* The validator LLM generates a “reference” answer to the query with the benefit of the article, ensuring a high quality answer [\[Code Reference\]](https://github.com/macrocosm-os/prompting/blob/6ac1e78690af8ee1d895bc6f317cc8df6ed4fbc5/prompting/tasks/qa.py#L31-L39).
* The validator sends the “challenge” to miners and collects streamed responses [\[Code Reference\]](https://github.com/macrocosm-os/prompting/blob/6ac1e78690af8ee1d895bc6f317cc8df6ed4fbc5/prompting/tasks/task_sending.py#L42-L87).
* The validator rewards completions based on how similar their completions are to the reference answer, using a combination of semantic similarity and ROUGE, and assesses how dissimilar they are to the challenge to avoid miners simply repeating the challenge [\[Code Reference\]](https://github.com/macrocosm-os/prompting/blob/6ac1e78690af8ee1d895bc6f317cc8df6ed4fbc5/prompting/tasks/qa.py#L42-L47).
* Validator updates scores and periodically sets weights based on the 8 hour moving average of previous miner rewards for a stable yet steep reward landscape [\[Code Reference\]](https://github.com/macrocosm-os/prompting/blob/6ac1e78690af8ee1d895bc6f317cc8df6ed4fbc5/prompting/weight_setting/weight_setter.py#L24-L36).

The use of RAG, in this example against the whole internet, introduces an important asymmetry between the validators and miners, and drives miners to develop efficient workflows which combine the base SOTA LLM with context recall against all information on the internet. Secondly, we incentivise fast responses by applying a strict time-limit. As a result, miners significantly outperform baseline methods and benefit from up-to-date information from the web, while providing a responsive user-experience.

Additionally, subnet 1 overcomes the limitations of most subnets when it comes to organic queries. Reference answers which define the target quality for miner completions are improved considerably by means of increased test-time compute. Validators use thousands of tokens and complex reasoning processes to create high-quality reference answers, which miners must match within very stringent time constraints.

For more context, check out our [reward model in GitHub](https://github.com/macrocosm-os/prompting/tree/main/prompting/rewards).

\
