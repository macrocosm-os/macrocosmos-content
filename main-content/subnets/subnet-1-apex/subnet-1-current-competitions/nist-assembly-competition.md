# NIST Assembly Competition

### NIST Assembly Competition

**Reaching a hole is not the same as filling it.** An assembly policy is scored on whether each part ended up seated, upright and let go of. The last millimetre is the whole problem: a peg has a few tenths of a millimetre of clearance in its hole, so the contact that completes an insertion is also the contact that jams it. And a policy that holds a perfectly inserted peg forever has not assembled anything, because the gripper is still in the way of the next part.

The NIST Assembly competition challenges miners to drive a **parallel 2-finger gripper on a Cartesian stage** (x, y, z, yaw) through **multi-peg sequential assembly** on a NIST Assembly Task Board #1–style board, in MuJoCo. Miners submit a trained ONNX controller that outputs stage and gripper targets at 25 Hz. Every episode puts **3 to 6 pegs** on the board, each with its own slot, and the policy chooses the order. Credit is **per peg**: every peg that ends the episode seated in its own slot earns credit, so a policy that seats two pegs out of five scores more than one that seats none.

{% hint style="warning" %}
**v0.5.0 (from round 8, 23 October 2026): the board layout is drawn per episode.** Slot positions, orientations, sizes and cross-sections change every episode, and peg-table features 8–11 changed meaning. Input and output shapes are unchanged, so older policies still load, but policies tuned to the fixed board of v0.2.0–v0.4.0 will score much lower.
{% endhint %}

**Evaluation Overview**

Each evaluation runs the miner's policy across **128 episodes**: 8 strata (K = 3, 4, 5 or 6 active pegs × low or high clutter) × 16 episodes each. Every round mixes about 25% easy, 35% medium and 40% hard episodes.

| Condition | Range, and whether it moves |
| --- | --- |
| Board layout | 8 slots per board; positions, yaw, cross-section family and size **re-drawn every episode** |
| Cross-sections | round, rectangle / square, regular 5-, 6- and 8-gon, D-flat; inscribed size 4–16 mm |
| Active pegs | 3–6 per episode, by stratum |
| Clutter | 0–3 free blocks (low: 0–1, high: 2–3); sometimes blocking a slot approach |
| Radial clearance | 0.25–0.8 mm, with a variable entry chamfer. **Drawn per episode.** |
| Hidden dynamics | friction, part mass, controller gain, mild backlash. **Drawn per episode.** |
| Pose estimates | per-slot, per-peg and per-clutter-block offsets of several mm and degrees, plus drift, noise and dropout. **Drawn per episode.** |
| Disturbances | rare action delay, mid-episode shove or gripper drop |
| Board pose | jittered per episode |
| Strata, control rate, physics rate | 8 × 16 episodes, 25 Hz, 1 kHz. **Fixed.** |

* **There is no fixed board to memorise.** Every episode draws its own layout and its own shapes, so a controller hard-coded to slot positions or a shape list cannot work.
* **The observation is deliberately imperfect.** Peg and slot poses carry independent estimate offsets, so the relative position you observe is off by several millimetres against a clearance of under one. Insertion has to be finished by contact (the wrist force/torque channel is there for that), not by trusting the reported pose.
* Within a round, **every submission faces identical episodes**. The seed is the round's, not the submission's, and the incumbent is re-scored on it alongside the challengers.
* **The round seed never enters the player sandbox.** Every episode is derived inside the referee from the platform-injected seed, mixed with private build entropy, so a round cannot be reproduced offline from the public simulator. After the round you are given each episode's layout and coarse conditions.
* Because the episodes change every round, **absolute scores are only comparable within a round.**

**The Board and the Parts**

| Property | Value |
| --- | --- |
| Slots per board | 8 (3–6 active per episode; inactive rows are zeros in the observation) |
| Cross-section families | round, rectangle (aspect 1.0–1.7, square included), regular 5/6/8-gon, D-flat (circle with a flat) |
| Inscribed size | 4–16 mm |
| Radial clearance | 0.25–0.8 mm |
| Gripper | parallel 2-finger |
| Stage travel | x, y ±280 mm · yaw ±3.2 rad |

* **Yaw is load-bearing for every non-round peg.** A peg seats only when its yaw matches its slot's, modulo the symmetry of its cross-section, and the hole walls enforce it.
* **Each peg has exactly one home.** A peg seated in another peg's slot earns nothing.

**Start States**

| Start type | Part begins |
| --- | --- |
| `loose` | standing upright on the board |
| `lying` | toppled on its side |
| `tray` | in a cluster with other parts |
| `near_hole` | close to its slot |
| `grasped` | already in the gripper (at most one peg per episode) |

**Step by Step**

At each 25 Hz control step, the policy receives a **184-float observation**:

| Block | Contents |
| --- | --- |
| Proprio (16) | hand (x, y, z) relative to the board origin ×10; sin/cos of hand yaw; hand velocity (3); finger gap ×50; wrist force (3), wrist torque (3), pad force (1) |
| Last action (5) | the previous action |
| Peg table (8 × 17) | per slot row: presence; biased, noisy peg pose relative to the biased slot estimate ×10 (3) and quaternion (4); biased slot-yaw estimate as sin, cos (2); outer (circumscribed) size ×50; a zero; inscribed size ×50; biased slot position relative to the board ×10 (3); seated flag |
| Clutter table (3 × 9) | per block: presence; biased pose relative to the board ×10 (3) and quaternion (4); size ×50 |

* The policy returns **5 floats in \[−1, 1]**: `dx, dy, dz` (±4 mm per step), `dyaw` (±0.08 rad per step) and gripper (+1 open, −1 close).
* **There is no shape label** and no exact hole or peg pose. Clearance, friction, mass and gains are not in the observation.
* There is **no recurrent state channel.** The previous action is in the observation and nothing else carries across steps.
* Physics runs at 1 kHz, 40 substeps per control action.

**Constraints**

* Termination, surfaced per episode as a `terminal_reason`:
  * `assembled`: every active peg seated and the gripper clear. The episode ends early.
  * `time_limit`: the budget ran out. Pegs still seated at that point score.
  * `part_lost`, `unstable`: a part left the work area, or the simulation became unstable.
  * `invalid_action`: the action was not a finite 5-vector. Ends **that** episode.
  * `player_fault`: the `/act` call errored, missed its deadline, or returned a batch of the wrong shape. Ends **every** episode still running.
* Episode budget: **280 control steps (11.2 s) per active peg**, so 840–1,680 steps per episode. One batched `/act` call covers every episode still running.
* Timeouts:
  * Per-`/act` deadline: 500 ms for the whole batch.
  * Referee (scorer) timeout: 1,800 seconds.
  * Player timeout: 1,800 seconds.
* Evaluation runs on **2 CPU / 2 GiB / no GPU**, for both the player and the referee sandbox.

**Scoring**

A peg counts as **seated** when, for **5 consecutive control steps**, all of the following hold, and it is still seated when the episode ends:

```
  own slot    the peg is in its own slot, inside the hole
  seated      peg bottom within 1 mm of fully inserted
  upright     peg tilt within 10 deg of vertical
  released    no gripper contact, and the fingers clear above the peg
```

Each seated peg earns **0.75**, plus up to **0.25** for seating it early and moving smoothly:

```
s_k = 0                                                if peg k is not seated at the end
s_k = 0.75 + 0.25 * (0.85 * (1 - t_k / T) + 0.15 * effort)   otherwise

S_e       = mean of s_k over the episode's K pegs
raw_score = mean of S_e over all 128 episodes         -> [0.0, 1.0]
```

`t_k` is the step when peg `k` first seated, `T` the episode budget, and `effort` falls from 1 towards 0 as the mean squared action grows.

* **Letting go is part of the task.** A peg driven home and still held never counts.
* **A knocked-out peg loses its credit.** Only pegs still seated at the end of the episode score.
* **The denominator is fixed.** Every one of the 128 episodes counts, including those lost to `player_fault`.
* To take the lead, a challenger must beat the current top raw score by more than **1%**. In a round with no current winner, the first scored submission takes the lead. `baseline_raw_score` is **0.0**.
* At the start of each round the incumbent is automatically re-submitted and re-scored on that round's episodes, so the comparison is always like-for-like. Results that finish before the incumbent's re-score are re-judged against the new bar once it lands.
* The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.

**Miner Submissions**

* Miners submit a single **ONNX graph** with this exact tensor signature:
  * input: `obs [batch, 184]`
  * output: `action [batch, 5]`
  * both `float32`, with a **dynamic batch dimension**.
* Opset **13–21**, standard operators only, a single self-contained file. The **architecture is not constrained**.
* Maximum submission size: **50 MB**.
* Submission fee: $10.00 USD.
* Default round length: **1 day**.
* Miners' models are revealed **1 day** after evaluation.
* 1% `raw_score` threshold to beat the current top scorer.
* Logs and records open after the round completes. Every evaluation writes a per-episode record (outcome, terminal reason, per-peg results, the episode's board layout and coarse conditions) plus a full replayable trajectory for every 16th episode. Replays are viewable on the competition page.
* The submission rate limit is 4 submissions per hotkey within 24 hours, across all competitions.
* The environment, the condition sampler, physics, scoring and record format are public at [apex-competition-nist-assembly](https://github.com/unarbos/apex-competition-nist-assembly). `tools/local_run.py` scores a policy locally, `tools/read_records.py` prints the breakdown, and the README gives the exact two-container Docker loop the platform runs. Local runs use the public development build: a local seed has the same distribution as a live round but does not reproduce it.
* Reference scores on v0.5.0 (64-episode live mix, from the repo's `CALIBRATION.md`): zero policy 0.017, the shipped `baselines/baseline.onnx` 0.043, the Python reference baseline 0.090, the strongest scripted controller 0.210, and a privileged true-state solver (not available to policies) 0.697.
