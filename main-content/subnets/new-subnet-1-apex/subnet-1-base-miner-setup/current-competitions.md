---
description: Registry of competitions currently active on SN1 APEX.
---

# Subnet 1 Current Competitions

<table data-view="cards"><thead><tr><th align="center"></th><th></th><th data-hidden data-card-cover data-type="image">Cover image</th></tr></thead><tbody><tr><td align="center"><a href="https://docs.macrocosmos.ai/subnets/subnet-1-apex/current-competitions#compression-of-activations-challenge">Matrix Compression</a></td><td></td><td><a href="../../../.gitbook/assets/Matix-icon.png">Matix-icon.png</a></td></tr><tr><td align="center"><a href="https://docs.macrocosmos.ai/subnets/subnet-1-apex/subnet-1-current-competitions#compression-of-activations-challenge-1">Matrix Compression v2</a></td><td></td><td><a href="../../../.gitbook/assets/Lossy-Matrix-picture.png">Lossy-Matrix-picture.png</a></td></tr><tr><td align="center"><a href="https://docs.macrocosmos.ai/subnets/subnet-1-apex/subnet-1-current-competitions#id-3.-reinforcement-learning-battleship">RL Battleship</a></td><td></td><td><a href="../../../.gitbook/assets/ChatGPT Image Feb 2, 2026, 05_01_28 PM.png">ChatGPT Image Feb 2, 2026, 05_01_28 PM.png</a></td></tr></tbody></table>

## 1. Matrix Compression <a href="#compression-of-activations-challenge" id="compression-of-activations-challenge"></a>

The first competition - Matrix Compression - explores how small neural activations - both forward and backward - can be compressed while still retaining all their original information. Reducing activation size enables faster data transfer across the internet, a crucial step toward making distributed training more efficient, as it’s often constrained by network bandwidth. The top-performing algorithms from this competition will be integrated to enhance training on **subnet 9** **IOTA**.

[Competition Dashboard ](https://apex.macrocosmos.ai/competitions/1)

#### Evaluation

Miners aim to optimize the following:

* Compression Ratio - How small the compressed solution is on disk versus the starting matrix.
* Time - How fast the compression/decompression algorithm runs.

To surpass the current winner of the competition, a miner must earn a **score** of at least 1% higher than the current top score. If there is no current winner, then a miner must earn a score of at least 1% higher than the baseline score.&#x20;

* The `score_to_beat` is displayed in the Apex CLI dashboard, under competition information.&#x20;

**Score is calculated by:**

```
score = np.clip((1 - compression) * (1 - task_time / (1 + 0.012)), 0.0, 1.0)
```

* Where `task_time` includes both compression and decompression.
* Compression is calculated by `compressed_file_size / original_file_size`.
* If compression is not **lossless**, the submission will receive a score of 0.&#x20;
* Only top evaluated submission is re-evaluated the next round.
* Previous top score is not counting towards the neww top score.

#### Matrix Compression Settings

* The submitted code remains hidden for 24 hours to everyone but the submission owner, after which it becomes accessible to all miners.&#x20;
* Round length: **2 days**
* Burn rate: **90%**&#x20;
  * The top scorer receives the remaining incentive pool (10%), decreasing linearly over a **10 day period**, provided no other submissions surpass the current top score.&#x20;
    * If a new submission exceeds the top score, the incentive decay resets from 10%.&#x20;
* Evaluation: each round uses 400 randomly sampled matrices from the total pool; the sample refreshes every round.
* Submission Constraints: Your submission must be less than 20KB.
* Multiple submissions:
  * The rate limit is 4 submissions in 24 hours per miner across all the competitions - Matrix Compression and Battleship. The period is individual for each user and starts to count from the first submission.

#### For Miners

View the matrix compression [**baseline miner solution**](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/matrix_compression/baseline.py) provided as an example.

To view samples from the previous round to test your solution:

`uv run python shared/competition/scripts/get_previous_round_input_files.py -c <competition_number>`

Then, continue to the [**Apex CLI guide**](https://docs.macrocosmos.ai/subnets/subnet-1-apex/subnet-1-base-miner-setup/apex-cli) to submit a solution.

The information about enabled packages is in [requirements.txt](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/battleship/dockerfiles/requirements.txt).

## 2. Matrix Compression v2 - Lossy Compression <a href="#compression-of-activations-challenge" id="compression-of-activations-challenge"></a>

The first competition - Matrix Compression - explored how small neural activations - both forward and backward - can be compressed while still retaining all their original information. Now we're seeing how small we can make bfloat16 matrices while still keeping enough information for training, while allowing minor information loss. The top-performing algorithms from this competition will be integrated to enhance training on **subnet 9** **IOTA**.

[Competition Dashboard](https://apex.macrocosmos.ai/competitions/4)&#x20;

#### Evaluation

Miners aim to optimize the following:

* Compression Ratio - How small the compressed solution is on disk versus the starting matrix.
* Similarity - Percent similarity of the norm multiplied by cosine similarity
  * `similarity(x,y)=( dot(x,y) / (norm(x)*norm(y)) ) * (1-norm(x-y) / norm(x))`&#x20;

To surpass the current winner of the competition, a miner must earn a **score** of at least 1% higher than the current top score. If there is no current winner, then a miner must earn a score of at least 1% higher than the baseline score.&#x20;

* The `score_to_beat` is displayed in the Apex CLI dashboard, under competition information.&#x20;

**Score is calculated by:**

```
if similarity > similarity_threshold: #similarity threshold is at 0.99
    score = np.clip(1 - compression, 0.0, 1.0)
else:
    score = 0
```

* Compression is calculated by `compressed_file_size / original_file_size`.
* If compression does not meet the similarity threshold, the submission will receive a score of 0.&#x20;
* Only top evaluated submission is re-evaluated the next round.

#### Matrix Compression Settings

* The submitted code remains hidden for 24 hours to everyone but the submission owner, after which it becomes accessible to all miners.&#x20;
* Round length: **2 days**
* Burn rate: **90%**&#x20;
  * The top scorer receives the remaining incentive pool (10%), decreasing linearly over a **10 day period**, provided no other submissions surpass the current top score.&#x20;
    * If a new submission exceeds the top score, the incentive decay resets from 10%.&#x20;
* Evaluation: each round uses 400 randomly sampled matrices from the total pool; the sample refreshes every round.
* Submission Constraints: Your submission must be less than 20KB.
* Multiple submissions:
  * The rate limit is 4 submissions in 24 hours per miner across all the competitions - Matrix Compression and Battleship. The period is individual for each user and starts to count from the first submission.

#### For Miners

View the matrix compression [**baseline miner solution**](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/matrix_compression/baseline.py) provided as an example.

To view samples from the previous round to test your solution:

`uv run python shared/competition/scripts/get_previous_round_input_files.py -c <competition_number>`

Then, continue to the [**Apex CLI guide**](https://docs.macrocosmos.ai/subnets/subnet-1-apex/subnet-1-base-miner-setup/apex-cli) to submit a solution.

The information about enabled packages is in [requirements.txt](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/battleship/dockerfiles/requirements.txt).

## 3. Reinforcement Learning: Battleship

This is the first reinforcement learning competition for Apex. Miners train RL models on their own machines and submit their models in **TorchScript** (`.pt` files) for evaluation.&#x20;

### **Battleship Settings** <a href="#battleship-settings" id="battleship-settings"></a>

[Competition Dashboard](https://apex.macrocosmos.ai/competitions/5)

* Be sure the model loads with `torch.jit.load()` before submitting.&#x20;
  * Submissions must be in `.pt` files to be accepted.
* Max submission size is 100 MB.

#### Match Structure <a href="#match-structure" id="match-structure"></a>

* A single match consists of several Battleship games played by 1 miner.
* In each game, the miner receives a hidden ship board - a unique configuration of ships that is known only to the orchestrator.
* Their task is to determine an optimal strategy to locate and hit the opponent’s ships as efficiently as possible, while working under an unknown turn constraint
* The miner that solves the most boards the fastest wins and receives all competition emissions, annealing with the burn.
* Shots may not be repeated!

### Evaluation <a href="#evaluation" id="evaluation"></a>

#### **Game Score** <a href="#game-score" id="game-score"></a>

Every game produces a score based on two components:

**1. Win Score**

* Winning a game grants **1000 points**.

**2. Speed Bonus**

* A speed bonus is added based on how quickly the miner wins:\
  &#xNAN;**(100 − number\_of\_turns\_to\_win) × 0.1**
* This rewards faster solutions.
* One turn is equivalent to one shot made to the ship board.

**Final Competition Score**

* The miner’s **final score** is the **average of all their game scores** across the round.

#### Additional details: <a href="#additional-details" id="additional-details"></a>

* Standard [Incentive mechanism](https://docs.macrocosmos.ai/subnets/subnet-1-apex/incentive-mechanism#incentive-challenges) Subnet 1.
  * Miners code is revealed 1 day after evaluation.
  * Logs are opened after the current round is completed.
* Multiple submissions:
  * The rate limit is 4 submissions per hotkey within 24 hours, across all competitions.&#x20;
* An example of model training can be found in the [train folder](https://github.com/macrocosm-os/apex/tree/main/shared/competition/src/competition/rl_battleship/train).&#x20;
* The information about enabled packages is in [requirements.txt](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/rl_battleship/dockerfiles/requirements.txt).
* All matches produce a replay file, with View only access.

