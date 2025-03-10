---
description: Subnet 9 incentive system overview
---

# Subnet 9: Incentive Mechanism

The pre-training subnet encourages miners to develop the best-performing pre-trained models at a given maximum parameter size for each competition on the subnet. Each model generates a probability distribution over possible responses to a given prompt (see [code](https://github.com/macrocosm-os/pretraining/blob/52962cf006952b9df42488194165225bc1b8d667/pretrain/validation.py#L142)), such as predicting the next word in a sentence. The quality of the model is measured by perplexity, a loss function based on cross-entropy.

Cross entropy measures the difference between the ground truth distribution P and the predicted distribution Q, and is defined as:

<figure><img src="../../.gitbook/assets/Screenshot 2025-03-05 at 16.35.16.png" alt="" width="375"><figcaption></figcaption></figure>

Where _P_ is the true probability of class _x_, and _Q_ is the predicted probability of class _x_.

Perplexity, derived from the cross-entropy, measures the model's confidence in its predictions and is given by:

<figure><img src="../../.gitbook/assets/Screenshot 2025-03-05 at 16.35.21.png" alt="" width="288"><figcaption></figcaption></figure>

As the model becomes more accurate, its probability distribution Q predicts the correct response with high confidence, reducing the cross-entropy H(P, Q) and, consequently, the perplexity. Lower perplexity indicates higher confidence and accuracy in the model’s predictions, with perplexity approaching 1 as the model's predictions become perfect.

On subnet 9, we:&#x20;

* Run multiple competitions each focusing on pre-training models with different total parameter size - since launch we’ve expanded the competition to 14bn parameters. This multi-competition support was announced in our [Q3, 2024 roadmap on discord](https://discord.com/channels/799672011265015819/1162768567821930597/1263909939978698773), and is based on the multi-competition implementation we introduced in the [taoverse library.](https://github.com/macrocosm-os/taoverse/tree/main/src/taoverse/model/competition)
* The main contribution introduced by multi-competitions on 30th, July was to split the incentive landscape between multiple competitions, allowing for the training of not just the largest competitive models, e.g. 14Bn, but also simultaneous smaller models, such as the current 3B-parameters competition, to allow for broader groups of miners, e.g. to train smaller models with a proportionally smaller piece of the reward associated with this job.
* The latest innovation in December 2024 we introduced in our subnet, was to enable multi-dataset evaluation which is usually called “data-mixing” in LLM literature. We have demonstrated that mixing multiple data domains such as science, code and math in addition to general knowledge datasets curated from the web helps push the performance closer to state-of-the-art. On January 16th, we introduced multi-dataset evaluation support in all of our competitions - 14Bn and 3Bn-parameter models. This is expected to accelerate model convergence toward state-of-the-art performance.
* We have also implemented native support for a more diverse set of evaluation tasks. As mentioned above, until now, we have been using next-word prediction, which is the standard task used to pre-train text-LLMs. In the coming weeks, we will be using EvalTasks to expand the functionality of our subnet to more types of tasks such as vision and industry-specific ones.

For each competition, only the top model will receive emissions.&#x20;

The reward mechanism works as follows:

1. Miners upload individual models to Hugging Face before providing their UID and commit hashes.
2. Validators independently evaluate the performance of each miner. (Here is the [code implementation](https://github.com/macrocosm-os/pretraining/blob/52962cf006952b9df42488194165225bc1b8d667/neurons/validator.py#L497) of a single validation step)
3. The evaluations from the validators are entered as a collective input to the on-chain Yuma Consensus.
4. Validators and miners are rewarded with Tao, based on their performance.

Note that competitions will be specified independently with a defined split of emissions from the subnet. Competitions each have unique parameters that define which model(s), tokenizer(s), size(s), and sequence length(s) that miners will be evaluated against.

Future competitions will be drawn from various other well-vetted data sources like other subnets (e.g. subnet 1) or high quality Hugging Face datasets of sufficient size, including a soon to be released dataset from subnet 13.&#x20;

[Reward model in GitHub](https://github.com/macrocosm-os/pretraining/blob/52962cf006952b9df42488194165225bc1b8d667/pretrain/validation.py#L47)\
