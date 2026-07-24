---
description: Reinforcement Learning with TRON
---

# RL Tron Competition

In this head-to-head reinforcement learning competition for Apex, miners train RL agents to play Tron on their own machines and submit their models in TorchScript (`.pt` files) for evaluation. All miners face off in a duels in a single elimination bracket-style tournament, where the winner takes emissions.&#x20;

### Tron Settings

* Be sure the model loads with `torch.jit.load()` before submitting.
* Submissions must be in `.pt` files to be accepted.
* Max submission size is 100 MB.
* The model must accept an input tensor of shape `(1, 5, H, W)` and output Q-values / logits of shape `(4,)` over the action space `[UP, RIGHT, DOWN, LEFT]`.

### Round Structure

A round is run as a **single-elimination bracket**. Miners can make submissions while the round is `OPEN`. Miners get one submission per hotkey - if multiple submissions are made under the same hotkey, the most recent submission is used during the evaluation phase.

During the evaluation phase:

* Miners are seeded into a single elimination bracket.
* Every match is a head-to-head duel between two miners.
* The winner advances to the next round of the bracket.&#x20;
* The last surviving miner is the round winner and receives all competition emissions, annealing with the burn.

### Match Structure

A single match is a **duel between two miners**, consisting of several Tron games played head-to-head. The miner with the higher win rate across the games wins the match and advances in the bracket.

* The default is **3 games per match**. Player spawn slots alternate every game to minimize positional advantages.
* Each game is played on a **30×30 playable grid** (default) bordered 1-block walls.
* Miners spawn in **opposite corners** (top-left and bottom-right) for maximum separation.
* Each game runs for at most **500 ticks**.
* A game ends when:
  * one player is alive (that player wins),
  * both players die on the same tick (draw),
  * the tick limit is reached with both still alive (draw).
* Trails are permanent - riding into your own trail, the opponent's trail, or a wall kills you.
* A miner that does not respond in time on a given tick is defaulted to "continue straight" - there is no per-tick penalty, but continuing straight may run the miner into a wall or trail.

#### Per-Tick Miner I/O

The miner runs as a long-running HTTP server inside its sandbox. The orchestrator calls the miner **every game tick** (not just at the start) with the current state.

Each tick, the miner receives:

* The full **grid** as a 2D array (`0`=empty, `1`=wall, `2+`=trail cells)
* Its own **position** `[y, x]`, **direction** (`0`=UP, `1`=RIGHT, `2`=DOWN, `3`=LEFT), and **alive** status
* The opponent's **position(s)** and **alive** status
* The pre-filtered list of **valid actions** (excludes reversing direction)

The miner returns a single integer action `0–3`.&#x20;

#### Timing

* **Per-tick move timeout**: 0.1 seconds. Exceeding this defaults the miner to its current direction.
* **Per-game wall-clock timeout**: 120 real-time second maximum per simulated game.

### Evaluation

#### Game Score

Every game produces a per-game score for each miner based on a **death-cause cascade**. Rules apply in order; the first rule that matches your situation becomes your score.

<table><thead><tr><th>#</th><th width="204">Your situation</th><th>Score</th></tr></thead><tbody><tr><td>1</td><td>You killed your opponent (their <code>killed_by</code> is you) and you're still alive</td><td><code>1.00</code></td></tr><tr><td>2</td><td>You're still alive and your opponent self-destructed (hit a wall or their own trail)</td><td><code>0.80</code></td></tr><tr><td>3</td><td>You killed your opponent but also died on the same step (head-on, mutual trail-kill, or you wall-died while your trail killed them)</td><td><code>0.40</code></td></tr><tr><td>4</td><td>Both players alive at <code>max_steps</code> (timeout draw)</td><td><code>0.25</code></td></tr><tr><td>5</td><td>Your opponent killed you and you did not kill them</td><td><code>0.10</code></td></tr><tr><td>6</td><td>You died alone (wall or your own trail), no kill credit</td><td><code>0.00</code></td></tr></tbody></table>

* If a game fails to start due to model load failures, both miners receive 0.0 for that game.
* The scoring rewards aggression: a clean kill (`1.00`) is worth more than waiting for your opponent to crash (`0.80`).

#### Match Score

A match's score for each miner is the **average** of per-game scores across all games in the match:

```
match_score = sum(per_game_scores) / num_games
```

So a match win rate is bounded in `[0.0, 1.0]`.

#### Match Outcome

The miner with the higher match score **wins the match** and advances in the bracket.&#x20;

A losing miner is eliminated from the bracket. Surviving miners are paired up for the next round of the bracket and play another match. This continues until one miner remains.

* Information on game stats and outcomes can be found in the eval metadata.&#x20;

#### Aggregate Stats

* **`eval_raw_score`** = the number of rounds this submission has survived.
* **`eval_score = rounds_survived / total_rounds`**

These numbers do not determine the bracket winner - they are tracking stats. The round winner is the **last surviving miner in the bracket**.

### Additional Details

* View results on the website's [competition dashboard.](https://apex.macrocosmos.ai/competitions/8)
* Miner code is revealed 2 days after evaluation.
* Round length: 2 days.
* 1% `raw_score` threshold to beat current top scorer.
* Submission fee: $1.40 USD, converted to the current TAO price.
* Logs are opened after the current round is completed.
* Multiple submissions:
  * The rate limit is 4 submissions per hotkey within 24 hours, across all competitions.
* A guide on training a baseline model can be found in the [`train` folder](https://github.com/macrocosm-os/apex/tree/main/shared/competition/src/competition/tron/train).
* Information on the RL Tron Player API can be found in [launch\_tron\_rl.py](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/tron/launch_tron_rl.py).
* See `requirements.txt` for information on allowed packages.
* All matches produce a replay file (per-game grid history and tick-by-tick actions).
