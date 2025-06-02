---
description: Subnet 9 incentive overview
---

# Subnet 9: Incentive Mechanism

### System Architecture

IOTA is structured around three core roles: the Orchestrator, Miners, and Validators. The simplified design of the system is illustrated in Figure 1. Rather than adopting a fully peer-to-peer topology, IOTA follows a hub-and-spoke architecture centred around the Orchestrator. This design choice ensures global visibility and enables comprehensive monitoring of all interactions between participants, which is critical for enforcing incentives, auditing behavior, and maintaining system integrity.

<img src="../../.gitbook/assets/file.excalidraw.svg" alt="Figure 1: Overall system architecture" class="gitbook-drawing">

Overall system architecture. The orchestrator facilitates the training process by triggering miners to work on specific layers of the model, further triggering when validation should occur based on the progress of the miners.

This architecture allows a system-level orchestrator to manage how participants on the network will operate at different stages of the training process. All data that is created and handled by these three entities is pushed to a globally accessible database, making it easy to trace the movement of information.

### Incentivisation

The design of the incentive landscape for the network participants should consider the trade-offs between optimisation and reproducibility, and has significant impact on the dynamics of the system. As discussed above, validation hinges on the validator’s ability to reproduce sections of training to a chosen threshold. Given this condition, the design does not give power to the miner to innovate algorithmically at this time.

Validators continuously monitor randomly assigned miners throughout full sync stages to ensure comprehensive oversight. To maximise validation coverage, the initial implementation of IOTA employs the shortest possible monitoring period (utilizing 0 compressed sharing stages), enabling each validator to oversee the maximum number of miners within the network. Importantly, miners are not aware of when they are being monitored, preventing them from selectively behaving correctly only during observed intervals. Upon completion of a validation stage, the mining rewards are calculated based on the total number of backward passes successfully processed, $$S~$$$$S^n_m$$, where _m_ indexes the\
miner and _n_ indexes the validation epoch.

The system implements a temporal decay mechanism governed by hyperparameter γ, which determines the decay time. The weight decay for miner _m_ in epoch follows a step function – concretely this means that a miner is assigned a fixed amount of "score" for a time period γ, after which the score drops to 0:

$$
w(t)^n_m=
\begin{cases}
  1 & \text{if } t \le t_{\text{decay}} \\
  0 & \text{if } t >  t_{\text{decay}}
\end{cases}
$$

where t is the time since the score was initially assigned. Therefore, the raw incentive I is the sum over all scores multiplied by their time weighting factor $$w(t)^n_m$$

$$
I_{m} \;=\; \sum_{n=0}^{N} S_{m}^{n}\,\cdot\, w(t)_{m}^{n}
$$

where N is the total number of full synchronisation steps at that point of time. This simple linear reward structure ensures miners receive fixed compensation per processed activation, eliminating incentives for throughput manipulation or other gaming strategies during non-validation periods. The exact recomputation requirement during validation stages provides additional security against system exploitation.

## System Architecture

Diagram of architecture. Introduce all the parts; orchestrator, S3 bucket, mongoDB , validators, miners.



## Subnet Operation

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
