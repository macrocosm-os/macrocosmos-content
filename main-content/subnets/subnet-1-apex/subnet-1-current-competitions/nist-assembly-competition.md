# NIST Assembly Competition

### NIST Assembly Competition

**Reaching a hole is not the same as filling it.** A locomotion policy is scored on where it got to; an assembly policy is scored on whether the part ended up seated, upright, and let go of. The last millimetre is the whole problem — a 16 mm peg in a 16 mm hole has a few tenths of a millimetre of radial clearance, so the contact that completes the insertion is also the contact that jams it. And a policy that holds a perfectly inserted peg forever has not assembled anything, because the gripper is still in the way of whatever comes next.

The NIST Assembly competition challenges miners to drive a **parallel 2-finger gripper on a Cartesian stage** (x, y, z, yaw) through peg-in-hole assembly on the **NIST Assembly Task Board #1** pattern, in MuJoCo. Miners submit a trained ONNX controller that outputs stage and gripper targets at 25 Hz. Credit is **binary and given only for a completed assembly** — the setup popularised by AlphaNIST, where a bare task reward and diverse start states are enough to produce real manipulation skill. There is no partial credit for getting close, no shaping term, and no reward for a tidy approach. Either the part is in the hole and released, or the episode scored zero.

**Evaluation Overview**

Each evaluation runs the miner's policy across **640 episodes** — 40 strata (2 shapes × 4 sizes × 5 start types) × 16 episodes each — up to **250 control steps (10 seconds)** per episode. The stratum split is identical every round; what rotates is the draw inside each stratum.

| Condition                                  | Range, and whether it moves between rounds                  |
| ------------------------------------------ | ----------------------------------------------------------- |
| Radial clearance                           | 0.15 – 0.60 mm. **Re-drawn every round.**                   |
| Friction                                   | µ ∈ \[0.5, 1.2]. **Re-drawn every round.**                  |
| Part mass                                  | 5 – 50 g. **Re-drawn every round.**                         |
| Controller stiffness                       | gain × \[0.7, 1.3]. **Re-drawn every round.**               |
| Observation noise                          | 0 – 0.5 mm std on part position. **Re-drawn every round.**  |
| Hole placement                             | ±80 mm in x and y on the board. **Re-drawn every episode.** |
| Start offsets, heights and yaw error       | Per start type (see below). **Re-drawn every episode.**     |
| Shape × size × start-type split            | 2 × 4 × 5, 16 episodes each. **Fixed forever.**             |
| Control rate, physics rate, episode budget | 25 Hz, 1 kHz, 250 steps. **Fixed.**                         |

* **The conditions rotate, the difficulty does not.** Each round draws its five physical conditions by Latin hypercube _within every stratum_, so each range is covered evenly in each of the 40 strata every round. A round cannot come out accidentally easy by drawing all-loose clearances, and a policy cannot wait for a soft round.
* **Clearance is drawn independently of size.** The 4 mm peg is not reliably the tight one and the 16 mm peg is not reliably the forgiving one, so a policy cannot infer how much slack it has from the part width it is told.
* **Stiffness and sensor noise rotate too.** The stage you are commanding is not the same stage every round, and the part position you observe carries up to 0.5 mm of noise — against a clearance that can be 0.15 mm. Insertion has to be achieved by contact, not by trusting the reported pose.
* Within a round, **every submission faces identical conditions**. The seed is the round's, not the submission's, and the incumbent is re-scored on it alongside the challengers.
* **The round seed never enters the player sandbox.** Every episode — task, start state, and physical conditions — is derived inside the referee from the platform-injected seed. It is not in your observations, not in your round input, and not in your result. Post-round you are given the conditions you actually ran against, per episode, because you need to know what you were scored on.
* Because the conditions move, **absolute scores are only comparable within a round.**

**The Board and the Parts**

Round and square pegs in the four NIST ATB-1 sizes, each with its matching 20 mm-deep hole:

| Property         | Value                                       |
| ---------------- | ------------------------------------------- |
| Shapes           | round, square                               |
| Nominal widths   | 4, 8, 12, 16 mm                             |
| Peg length       | 50 mm                                       |
| Hole depth       | 20 mm                                       |
| Radial clearance | 0.15 – 0.60 mm, drawn per episode           |
| Part mass        | 5 – 50 g, drawn per episode                 |
| Gripper          | parallel 2-finger, 12 mm opening per finger |
| Stage travel     | x, y ±200 mm · z 0 – 250 mm · yaw ±3.1 rad  |

* **Square pegs make yaw load-bearing.** A round peg only has to be over the hole; a square peg has to be over it _and_ aligned to it, and the start states give square parts a yaw error to clear.
* The peg is end-symmetric, so either end may go in — but it has to go in roughly upright. A part fully inside a 20 mm hole can only tilt about 3.4° at the widest clearance, so a part lying across the mouth is nowhere near seated.

**Start States**

Five start types, an equal share of every round. Two of them do not begin with the part in the gripper at all:

| Start type      | Part begins                                         | Skill tested                                     |
| --------------- | --------------------------------------------------- | ------------------------------------------------ |
| `grasped_above` | grasped, 5 – 25 mm above the hole, ≤5 mm off-centre | the insertion itself                             |
| `grasped_far`   | grasped, 20 – 50 mm up, 10 – 30 mm off              | transport, then insertion                        |
| `near_hole`     | resting on the hole rim, 0.8 – 2.5 mm off-centre    | regrasp and re-align a part already placed badly |
| `loose`         | standing on the board, 30 – 60 mm away              | approach, grasp, transport, insert               |
| `lying`         | toppled on its side, 30 – 60 mm away                | reorient a fallen part, then everything else     |

* **Two fifths of every round starts with nothing in the gripper.** `loose` and `lying` require a policy to find and pick up the part before any of the insertion skill matters, and `lying` additionally requires standing a toppled peg up. The reference baseline never attempts either, which is most of why it tops out near 0.34.
* `near_hole` is the recovery case: the part is already on the rim and slightly wrong, which is the state a failed insertion leaves behind.

**Step by Step**

At each of the 25 Hz control steps, the policy receives a **26-float observation**:

| Slice     | Contents                                                          |
| --------- | ----------------------------------------------------------------- |
| `[0:3]`   | gripper position − hole (×10, m)                                  |
| `[3:5]`   | sin/cos of gripper yaw                                            |
| `[5:8]`   | gripper velocity                                                  |
| `[8]`     | finger gap (×50)                                                  |
| `[9:12]`  | part position − hole top centre (×10), **plus observation noise** |
| `[12:16]` | part quaternion (w, x, y, z)                                      |
| `[16:19]` | part velocity                                                     |
| `[19]`    | part width (×50, m)                                               |
| `[20]`    | 1 if square, 0 if round                                           |
| `[21:26]` | previous action                                                   |

* The policy returns **5 floats in \[−1, 1]**: `dx, dy, dz` (±4 mm per step), `dyaw` (±0.08 rad per step), and gripper (+1 open, −1 close). These are **incremental position targets** driven by a PD loop, not torques — and the increment cap means an insertion is many small commitments rather than one.
* **Clearance, friction, mass, stiffness and the noise level are not in the observation.** The part's width and shape are given; nothing about how tightly it fits, how heavy it is, or how hard the stage will push is. The only way to learn a round's conditions is to feel them through contact.
* There is **no recurrent state channel.** The previous action is in the observation and nothing else carries across steps, so any memory a policy needs must be inferred from what it can see now.
* Physics runs at 1 kHz, 40 substeps per control action.

**Constraints**

* Termination gates, each surfaced to the miner as a `terminal_reason`:
  * `assembled` — the success condition below. The only outcome that scores.
  * `time_limit` — the 250-step (10 s) budget elapsed with the part not assembled.
  * `unstable` — NaN/Inf state, or part speed above 2 m/s. Flinging the part scores 0.
  * `part_lost` — the part left the board: |x| or |y| past 280 mm, or it fell below the surface.
  * `invalid_action` — that episode's action was not a finite 5-vector. Ends **that** episode unsuccessfully.
  * `player_fault` — the `/act` call errored, missed its deadline, or returned a batch of the wrong shape. Ends **every** episode still running.
* Episode length: **250** control steps. One batched `/act` call covers every episode still running, so a full evaluation is at most **250 calls**, not 250 × 640.
* Timeouts:
  * Per-`/act` deadline = 500 ms for the whole batch.
  * Referee (scorer) timeout = 900 seconds for all 640 episodes.
  * Player timeout = 900 seconds.
* Evaluation runs on **2 CPU / 2 GiB / no GPU**, for both the player and the referee sandbox.

**Scoring**

Every episode is pass/fail. A run counts as **assembled** when, within the 10-second budget, all of the following hold for **5 consecutive control steps**:

```
  seated      part bottom within 1 mm of fully inserted
  centred     part centre within the hole radius
  upright     part tilt within 10 deg of vertical
  released    no gripper contact, and the fingertips are clear above the part's top face
```

* **Letting go is part of the task.** A policy that drives a peg perfectly home and keeps holding it never scores. The release-and-clear requirement is what makes the result an assembly rather than a pose.
* **The hold is what stops a fly-through counting.** A part that passes through the seated pose on its way to bouncing out was never assembled; five consecutive steps means it settled there.
* The round result is the fraction of episodes assembled, over a **fixed denominator** — every one of the 640 episodes counts, including those lost to `player_fault`:

```
raw_score = assembled_episodes / 640      -> [0.0, 1.0]
```

* **There is no partial credit.** Unlike the locomotion competitions, there is no progress term: a policy that gets the part to the rim every time and never seats it scores exactly the same as one that drops it immediately. The climb is visible only in the per-stratum breakdown, not in the score.
* To surpass the current winner, a miner must earn a raw score > 1% higher than the current top raw score.
  * To take the lead, a challenger must beat the current top raw score by more than 1%. In a round with no current winner, the first scored submission takes the lead. The incumbent is re-scored on each round's conditions alongside challengers. `baseline_raw_score` is **0.0.**  — **a verbatim resubmission of the shipped baseline does not clear the round-one bar.**
* At the start of each round the incumbent is automatically re-submitted and re-scored, so the comparison is always like-for-like. **This is what makes per-round conditions safe**: the incumbent's score from a different draw is never what a challenger has to beat.
* The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.

**Miner Submissions**

* Miners submit a single **ONNX graph** with this exact tensor signature:
  * input — `obs [batch, 26]`
  * output — `action [batch, 5]`
  * both `float32`, with a **dynamic batch dimension** — one call covers every episode still running.
* Opset **13–21**, standard operators only, a single self-contained file.
* The **architecture is not constrained**; only the signature is.
* Maximum submission size: **50 MB**.
* Submission Fee: $10.00 USD
* Default round length: 1 **day**.
* Miners' models are revealed **4 days** after evaluation.
* 1% `raw_score` threshold to beat the current top scorer.
* Logs are opened after the current round is completed. Every evaluation also writes a per-episode record — outcome, terminal reason, step count and the exact conditions drawn — plus a full replayable trajectory for every 16th episode, delivered to the miner post-round.
* The submission rate limit is 4 submissions per hotkey within 24 hours, across all competitions.
* The full environment — the board, the condition sampler, physics, scoring, and the record format — is public at [apex-competition-nist-assembly](https://github.com/macrocosm-os/apex-competition-nist-assembly). Train against the real referee, not a reimplementation: `referee/nist_sim` imports directly, `Episode(cond).step(action)` is the exact simulator used for scoring, and `nist_sim.conditions.sample_episodes(seed, k)` draws a round's start states and conditions.
* Local tools in that repo: `tools/make_policies.py` builds the reference baseline, `tools/local_run.py` scores a policy against any seed, and `tools/read_records.py` prints the per-task and per-start-type breakdown. The README also gives the exact two-container Docker loop the platform runs, so a submission can be validated against the real player/referee contract before it is sent.
* The shipped reference baseline (`baselines/baseline.onnx`, a hand-written servo) scores **\~0.34**. It handles parts that start in the gripper and never grasps a loose or lying one — the two start types it ignores are two fifths of every round, which caps it at 0.6 before any insertion failure is counted.
