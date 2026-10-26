# NIST Assembly Competition

### NIST Assembly Competition

**Getting a peg to the hole is not the same as seating it.** The last millimetre is the hard part: with 0.25 to 0.8 mm of radial clearance, the contact that completes an insertion is the same contact that jams it. A peg still held in the gripper has not been assembled, and on a full board each seated peg is one more thing the gripper can knock out on the way to the next.

The NIST Assembly competition asks miners to drive a **parallel 2-finger gripper on a Cartesian stage** (x, y, z, yaw) through **multi-peg sequential assembly** on a board modelled on the **NIST Assembly Task Board #1**, simulated in MuJoCo on CPU. Miners submit an ONNX policy that outputs incremental stage and gripper commands at 25 Hz. The setup borrows from AlphaNIST (Zhang et al., arXiv 2610.13354): the ATB-1 board, the 1 mm success criterion, 25 Hz control, diverse start states and free-order multi-part episodes. It is much smaller: pegs only, primitive geometry, a 4-DoF stage instead of a 7-DoF arm, and noisy state estimates instead of point clouds. Scoring gives partial credit per peg so that a ranked competition has a gradient.

**What changed in v0.5.0**

* **Every episode draws its own board.** Hole positions, hole yaw, peg size and peg cross-section are drawn per episode from continuous ranges. There is no fixed slot table to memorise.
* **More cross-sections, no shape label.** Live families are round, rectangle/square, regular 5/6/8-sided polygons, and D-flat, with inscribed sizes from 4 to 16 mm. The observation gives sizes and an estimated hole yaw but never says which family a peg is.
* **Some families and condition ranges are held out.** They never appear in live rounds; the competition authors use them offline to check that leading policies generalise.
* **The interface is unchanged** (`[B, 184]` in, `[B, 5]` out), but observation features 8 to 11 of each peg row changed meaning (see below). Policies tuned to v0.4.0 will score much lower.

The point of these changes is to reward policies that generalise. A controller tuned to the fixed v0.4.0 layout could score up to 0.79 there; on v0.5.0 such controllers score about 0.01 to 0.02.

**Evaluation Overview**

Each live evaluation runs **128 episodes**: 8 strata (number of pegs K ∈ {3, 4, 5, 6} × clutter low/high) with 16 episodes each. Inside each stratum, the physical conditions are drawn by Latin hypercube, and each episode is assigned a difficulty tier, so every round has the same mix: about **25% easy, 35% medium, 40% hard**.

| Condition | Live range |
| --- | --- |
| Pegs per episode (K) | 3 – 6 (mean 4.5), one stratum each, crossed with clutter |
| Clutter blocks | 0 – 1 (low) or 2 – 3 (high); often placed near a hole approach |
| Board layout | 8 holes per board; positions, yaw, family and size drawn per episode |
| Board pose | ±30 mm in x and y, ±0.15 rad yaw, per episode |
| Radial clearance | 0.25 – 0.8 mm, with a variable entry chamfer |
| Friction | 0.3 – 1.3 |
| Peg mass | 5 – 50 g |
| Controller gain | × 0.6 – 1.4 |
| Pose-estimate noise | 0.4 – 2.0 mm, 0.015 – 0.06 rad |
| Observation dropout | 3 – 18% per row per step (the row repeats its last value) |
| Hole-estimate bias | 4 – 10 mm and roughly 7 – 16° per episode, independent per hole (smaller on easy and medium tiers) |
| Extra peg-vs-hole bias | 1.5 – 5 mm, independent per peg, so the reported peg-minus-hole offset does not cancel |
| Other | slow bias drift, Cartesian backlash, a rare one-step action delay, and on some episodes one mid-episode disturbance (a peg shove, a gripper slip, or a hand shift) |
| Control / physics | 25 Hz control, 1 kHz physics (40 substeps per action). **Fixed.** |
| Horizon | 280 control steps (11.2 s) per active peg: 840 – 1680 steps. **Fixed.** |

* **The difficulty does not drift between rounds.** Strata, tier mix and ranges are fixed; only the draw inside them changes.
* Within a round, **every submission faces the same episodes**, and the incumbent is re-scored on them.
* **The round seed never enters the player sandbox.** Every episode is derived inside the referee from the platform seed plus private build entropy. Local runs use the same distribution but cannot reproduce a live round.

**Start States**

Each peg gets its own start type. Easy-tier episodes use grasped and near-hole starts; medium and hard tiers mix all five.

| Start type | Peg begins |
| --- | --- |
| `grasped` | already in the gripper, 10 – 40 mm above and within 10 mm of its hole (at most one per episode) |
| `near_hole` | standing on the board just beside its hole |
| `loose` | standing upright on the board, 40 – 70 mm from its hole |
| `lying` | toppled on its side, 50 – 70 mm away |
| `tray` | standing in a ring with the other tray pegs, in a tray area near one edge of the board |

**Step by Step**

At each control step the policy receives a **184-float observation**:

| Block | Size | Contents |
| --- | --- | --- |
| Proprioception | 16 | hand position relative to the board (×10, m); sin/cos of hand yaw; hand velocity (3); finger gap (×50); wrist force (3); wrist torque (3); finger-pad force (1) |
| Last action | 5 | the previous action |
| Peg table | 8 × 17 | one row per active peg, paired with its target hole; unused rows are zero. Per row: presence (1); estimated peg position relative to the estimated hole (×10, 3); estimated peg quaternion (4); estimated hole yaw as sin, cos (2); peg outer (circumscribed) size (×50, 1); a zero (1); peg inscribed size (×50, 1); estimated hole position relative to the board (×10, 3); seated flag (1) |
| Clutter table | 3 × 9 | presence; estimated position relative to the board (×10, 3); quaternion (4); size (×50) |

* Row features 8 – 11 (hole yaw sin/cos, outer size, zero) replaced the v0.4.0 shape one-hot.
* **Exact peg and hole poses are never given.** Every pose in the table is an estimate with the biases and noise listed above. A peg is aligned when its yaw matches the hole yaw, up to the cross-section's own symmetry, which the policy has to work out from the sizes and from contact.
* **Clearance, friction, mass, gain and the bias values are not observed.** The wrist force/torque and pad force channels are what a policy can use to find a hole it cannot see precisely.
* **There is no recurrent state.** The policy is called once per step on the current observation; only the previous action is fed back.

The policy returns **5 floats in [−1, 1]**: `dx, dy, dz` (±4 mm per step), `dyaw` (±0.08 rad per step), and gripper (+1 open, −1 close). These are incremental position targets tracked by a PD loop. Stage travel is ±250 mm in x and y, −3 to 250 mm in z, and ±3.1 rad in yaw.

**Constraints**

* Terminal reasons, reported per episode:
  * `assembled`: every peg is seated and released. The episode ends early.
  * `time_limit`: the horizon ran out.
  * `unstable`: non-finite state, or a part moving faster than 4 m/s.
  * `part_lost`: a part left the board area (|x| or |y| beyond 300 mm) or fell below the surface.
  * `invalid_action`: that episode's action was not a finite 5-vector. Ends that episode.
  * `player_fault`: the `/act` call errored, missed its deadline, or returned a batch of the wrong shape. Ends every episode still running.
* In every case, pegs that are seated when the episode stops keep their credit; unseated pegs score 0.
* One batched `/act` call per control step covers every episode still running, with a **500 ms deadline per call**.
* Timeouts: **1800 s** for the referee and for the player.
* Player and referee each run on **2 CPU / 2 GiB / no GPU**.

**Scoring**

A peg counts as **seated** when, for 5 consecutive control steps, it is in its own hole with its bottom within 1 mm of fully inserted, its centre within the hole radius, its tilt within 10° of vertical, and the gripper is not touching it and its pads are clear above the peg's top.

For an episode with K pegs, each peg k scores:

```
s_k = 0                                         if peg k is not seated at episode end
s_k = 0.75 + 0.25 * (0.85 * time + 0.15 * effort)   otherwise

time   = 1 - t_k / T          t_k = step when peg k was first seated, T = episode horizon
effort = max(0, 1 - a2 / 5)   a2  = the episode's mean squared action (sum over the 5 outputs)
```

```
S_e       = (1 / K) * sum_k s_k
raw_score = mean of S_e over all episodes      -> [0.0, 1.0]
```

* **Seating dominates.** A seated peg is worth at least 0.75; speed and smooth actions only move the last 0.25.
* **Wrong hole, knocked out, or still held scores 0.** Each peg has to go into its own row's hole, and it has to stay there until the end.
* **Order is free.** The policy chooses which peg to do next.
* The denominator is fixed: every episode counts, including ones ended by a fault.
* To take the lead, a challenger must beat the current top raw score by more than 1%. The incumbent is re-scored at the start of each round on the same episodes, so the comparison is like-for-like; results that finish before the incumbent's re-score are re-judged against the new bar once it lands. `baseline_raw_score` is 0.0.
* The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.

**Reference numbers (v0.5.0)**

Measured on the public dev build, live mix, 64 episodes per seed, 5 seeds (see `CALIBRATION.md` in the repo):

| Policy | Score |
| --- | --- |
| zero (no-op) | 0.017 |
| shipped `baselines/baseline.onnx` | 0.043 |
| hand-coded observation-only controllers | 0.08 – 0.21 |
| privileged solver (reads the true state; not available to policies) | 0.697 |

**Miner Submissions**

* A single **ONNX graph** with one input and one output:
  * input `[batch, 184]` float32
  * output `[batch, 5]` float32
  * the batch dimension must be **dynamic**.
* Opset **13 – 21**, standard operators only, one self-contained file (no external data).
* Maximum size **50 MB**. The architecture is not constrained.
* Submission fee: **$10.00 USD**.
* Default round length: **1 day**. Submissions are revealed **1 day** after evaluation.
* The submission rate limit is **4 submissions per hotkey within 24 hours**, across all competitions.
* After each round, every evaluation's records are available: a per-episode record (`nist_lite_record/2`) with the score, per-peg outcomes, terminal reason, the exact board layout (`conditions.slots`) and peg sizes, and coarse condition labels (clearance class, difficulty tier, clutter), plus a full trajectory for every 16th episode. The website replay viewer draws each episode's own layout.

**Tips for Miners**

* **Expect to need RL.** The task is built so that scripting against the observation does not work: hole and peg estimates are biased by several millimetres against sub-millimetre clearances, and v0.5.0 removed the fixed layout that scripts used to hard-code. Our best hand-coded controller, which is the privileged solver's insertion logic run on the observation, scores about 0.21. CI also checks that our scripted controllers stay at or below 0.30.
* **The headroom is real but not cheap.** The privileged solver scores about 0.70 on the same episodes. Our own quick residual-PPO runs (up to 1M steps on CPU) did not beat the scripted controllers they started from. Plan for longer training, many parallel environments, and ways to use the force/torque signal; a privileged teacher distilled into an observation-only student is a reasonable route.
* **Train against the real simulator.** `referee/nist_sim` imports directly: `nist_sim.conditions.sample_episodes(seed, per_stratum)` draws a round's episodes and `Episode(cond, rng).step(action)` is the exact simulator used for scoring.
* **Use the repo tools.** `tools/local_run.py` scores a policy on any seed, `tools/read_records.py` breaks results down by K, family and size, `tools/train_ppo.py` is a residual-PPO starting point, and the README has the exact two-container Docker loop the platform runs.
* **Release and keep clear.** Credit needs the gripper off the peg at the end, and a seated peg that is knocked out later scores 0. Leave seated pegs alone.
* **Don't overfit the dev seeds.** Live rounds add private build entropy, and some families and condition ranges are held out entirely.
* The full environment is public at [apex-competition-nist-assembly](https://github.com/unarbos/apex-competition-nist-assembly).
