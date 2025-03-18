---
description: Subnet 25 incentive overview
---

# Subnet 25: Incentive Mechanism

Physical systems such as proteins tend to minimize their energy and so this provides a succinct, exploit-resistant and highly sensitive measure of quality. For this reason, miners compete to provide protein configurations that coincide with the lowest energy (analogous to loss). The benefit is twofold; the metric the network is optimizing for is highly aligned with the desired outcome (biologically stable structures) and it is transparent and deterministic (both miners and validators can quickly calculate the energy of a configuration).&#x20;

There are two important synapses that currently exist:&#x20;

1. PingSynapse
2. JobSubmissionSynapse

Validators ping the entire network to see what miners are able to do work using the PingSynapse, and the JobSubmissionSynapse will submit either synthetic or organic jobs to random miners that replied when initially pinged.&#x20;

The validators select proteins at random from a large public database ([RCSB](https://www.rcsb.org) and [pdbe](https://www.ebi.ac.uk/pdbe/) data banks) and download the input files for preprocessing and simulation to create a Job. Validators will periodically check on the miner performances on a per-job basis using the JobSubmissionSynapse to calculate the energy while performing additional verification steps to ensure the files match the exact protein configuration, eliminating the remote-code attack surface of the incentive mechanism. Each validator currently maintains a queue of 10 concurrently running protein folding jobs, each of which is assigned to 10 hotkeys ([code](https://github.com/macrocosm-os/folding/blob/1edf6acce7fe9e8d64688494aac3944639ee63cb/folding/utils/config.py#L320)). With 11 non-weight copying validators active on the subnet, there are roughly 1100 simultaneous simulations running.

**Maintaining opportunity**: The miners are oversubscribed to jobs by design, which means there is an effectively unbounded opportunity for those that can handle the enormous computational workload.

**Ensuring innovation**: Each miner uses a separate random seed for their simulations, which ensures that each simulation suitably explores the folding space and utilizes the parallelism opportunity of batching jobs. On job evaluation, if miners are submitting identical results, we enforce that their reward is zero, which continues to incentivize unique solutions ([code](https://github.com/macrocosm-os/folding/blob/3bdcc27da5816c144ee5ceccfcfa23ea769dd72a/folding/validators/reward.py#L12)).

\
We have opted for an exponential incentive curve design to encourage highly motivated miners to innovate and provide more value to the subnet by procuring more compute and developing algorithmic optimizations. At present, the winning miner gains 80% of the possible rewards in each step ([code](https://github.com/macrocosm-os/folding/blob/main/folding/rewards/reward_pipeline.py)), but we will modify this to winner-takes-all in the near future. The weights are calculated based on the average EMA across the jobs assigned to the miners, which means they must perform well across all of them. We utilize early stopping to prevent wasted computational efforts. Currently, if no improvements are made to a given proteins’ configuration for an hour, the job is terminated. Also, we use an epsilon-bounded scoring ([code](https://github.com/macrocosm-os/folding/blob/1edf6acce7fe9e8d64688494aac3944639ee63cb/folding/store.py#L181)) to ensure configurations meaningfully improve over time. We have developed heuristics which allow us to predict optimal epsilon values ([code](https://github.com/macrocosm-os/folding/pull/136)) as a function of protein complexity, ensuring that the reward landscape is well-calibrated.
