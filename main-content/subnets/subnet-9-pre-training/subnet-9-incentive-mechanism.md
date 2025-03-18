---
description: Subnet 9 incentive overview
---

# Subnet 9: Incentive Mechanism

Subnet 9 encourages miners to develop the best-performing pre-trained models at a given maximum parameter size for each competition on the subnet. Each model generates a probability distribution over possible responses to a given prompt \[see [code](https://github.com/macrocosm-os/pretraining/blob/52962cf006952b9df42488194165225bc1b8d667/pretrain/validation.py#L142)], for example predicting the next word in a sentence. The quality of the model is measured by perplexity, a loss function based on cross-entropy.

Cross entropy measures the difference between the ground truth distribution P and the predicted distribution _Q_, and is defined as:

<figure><img src="../../.gitbook/assets/Screenshot 2025-03-05 at 16.35.16.png" alt="" width="375"><figcaption></figcaption></figure>

_P_ is the true probability of class _x_, and _Q_ is the predicted probability of class _x_.

Perplexity, derived from the cross-entropy, measures the model's confidence in its predictions and is given by:

<figure><img src="../../.gitbook/assets/Screenshot 2025-03-05 at 16.35.21.png" alt="" width="288"><figcaption></figcaption></figure>

As the model becomes more accurate, its probability distribution _Q_ predicts the correct response with high confidence, reducing the cross-entropy _H(P, Q)_ and, consequently, the perplexity. Lower perplexity indicates higher confidence and accuracy in the model’s predictions, with perplexity approaching 1 as the model's predictions become perfect.

On subnet 9 we run multiple competitions, each focusing on pre-training models with different total parameter sizes - since launch we’ve expanded the competition to 14b parameters. This multi-competition support was announced in our [Q3, 2024 roadmap on discord](https://discord.com/channels/799672011265015819/1162768567821930597/1263909939978698773), and is based on the multi-competition implementation we introduced in the [taoverse library.](https://github.com/macrocosm-os/taoverse/tree/main/src/taoverse/model/competition)

The main contribution introduced by multi-competitions on July 30 2024, was to split the incentive landscape between multiple competitions, allowing for the training of not only the largest competitive models, e.g. 14B, but also simultaneous smaller models, such as the current 3B-parameter competition, to allow for broader groups of miners, e.g. to train smaller models with a proportionally smaller piece of the reward associated with this job.



In December 2024 we enabled multi-dataset evaluation, more commonly known as “data-mixing”. We demonstrated that mixing multiple data domains (such as science, code and math in addition to general knowledge curated from the web) helps push the performance closer to state-of-the-art (SOTA) models. On January 16, 2025, we introduced multi-dataset evaluation-support across SN9, meaning it operated on both our 14B and 3B competitions. This is expected to accelerate model convergence toward SOTA performance.

We also implemented native support for a more diverse set of evaluation tasks. As mentioned, until now, we've been using next-word prediction, which is the standard task for pre-training text-LLMs. However, soon, we'll be using EvalTasks to expand our subnet's functionality to more types of tasks such as vision and industry-specific ones.

For each competition, only the top model will receive emissions.&#x20;

The reward mechanism works as follows:

1. Miners upload individual models to HuggingFace before providing their UID and commit hashes.
2. Validators independently evaluate the performance of each miner. You can find the [code implementation of a single validation step here](https://github.com/macrocosm-os/pretraining/blob/52962cf006952b9df42488194165225bc1b8d667/neurons/validator.py#L497).
3. The evaluations from the validators are entered as a collective input to the on-chain Yuma Consensus.
4. Validators and miners are rewarded, based on their performance.

Note that competitions will be specified independently with a defined split of emissions from the subnet. Competitions each have unique parameters that define which model(s), tokenizer(s), size(s), and sequence length(s) that miners will be evaluated against.

Future competitions will be drawn from various other well-vetted data sources like other subnets (e.g. subnet 1) or high quality HuggingFace datasets of sufficient size, including a soon to be released dataset from subnet 13.&#x20;

[Reward model in GitHub](https://github.com/macrocosm-os/pretraining/blob/52962cf006952b9df42488194165225bc1b8d667/pretrain/validation.py#L47)\
