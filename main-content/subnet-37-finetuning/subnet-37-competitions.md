---
description: Subnet 37's competition system
---

# Subnet 37: Competitions

## Competition B7\_MULTICHOICE

### Goal

The purpose of this competition is to finetune the top models from our [pretraining subnet](https://www.macrocosmos.ai/sn9) to produce a chatbot.

### Evaluation

Models submitted here are evaluated on a set of tasks, where each is worth a sub-portion of the overall score. The current evaluations are:

1. **SYNTHENTIC\_MMLU:** In this task, the model is evaluated on a synthetic MMLU-like dataset from [subnet 1.](../constellation/apex/subnet-1-apex/) This is a multiple choice dataset with a large array of questions, spanning a domain of topics and difficulty levels, akin to MMLU. Currently, the dataset is generated using Wikipedia as the source-of-truth, though this will be expanded over time to include more domain-focused sources.
2. **WORD\_SORTING**: In this task, the model is given a list of words and are required to sort them alphabetically. [See the code here](https://github.com/macrocosm-os/finetuning/blob/main/finetune/datasets/generated/dyck_loader.py).
3. **FINEWEB**: In this task, the model's cross entropy loss is computed on a small sample of the fineweb dataset. [See here for details.](https://hf.rst.im/datasets/HuggingFaceFW/fineweb-edu-score-2)
4. **IF\_EVAL:** In this task, the model is evaluated on a sythentic version of the [IFEval dataset](https://hf.rst.im/datasets/google/IFEval). The prompt contains a list of rules the response must follow. The full list of possible rules is listed in [rule.py](https://github.com/macrocosm-os/finetuning/blob/main/finetune/eval/if_eval/rule.py)

### Definitions

[See here for more information on definitions](https://github.com/macrocosm-os/finetuning/blob/94e8fd92ab4158e1e4a425a9562695eebafa27b1/constants/__init__.py#L128).

## Competition INSTRUCT\_8B

The goal of this competition is to train a SOTA instruct 8B model. This competition provides more freedom to miners than others: there are no restrictions on the tokenizer used and miners are allowed to use a wider range of architectures.

The evaluation tasks are the same as the B7\_MULTICHOICE competition

[See the code for more information.](https://github.com/macrocosm-os/finetuning/blob/c6dce9d27d1317b9c543071913ae34df09faddc7/constants/__init__.py#L114)

## Deprecated Competitions

### Competition 1: SN9\_MODEL

This was the competition for the finetuning subnet.

Its purpose was to finetune the top models from [subnet 9](../constellation/subnet-9-pre-training/) to produce a chatbot.

Models submitted to this competition were evaluated using a synthetic Q\&A dataset from the [cortex subnet](https://github.com/Datura-ai/cortex.t). Specifically, models were evaluated based on their average loss of their generated answers.
