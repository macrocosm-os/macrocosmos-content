# NIST Assembly Competition

### NIST Assembly Competition

**Getting a peg to the hole is not the same as seating it.** The last millimetre is the hard part: with 0.18 to 0.55 mm of radial clearance, the contact that completes an insertion is the same contact that jams it. A peg still held in the gripper has not been assembled, and on a full board each seated peg is one more thing the gripper can knock out on the way to the next.

The NIST Assembly competition asks miners to drive a **parallel 2-finger gripper on a Cartesian stage** (x, y, z, yaw) through **compound assembly tasks** on a board modelled on the **NIST Assembly Task Board #1**, simulated in MuJoCo on CPU. Miners submit an ONNX policy that outputs incremental stage and gripper commands at 25 Hz. The setup borrows from AlphaNIST (Zhang et al., arXiv 2610.13354): the ATB-1 board, the 1 mm success criterion, 25 Hz control, diverse start states and free-order multi-part episodes. It is much smaller: primitive geometry, a 4-DoF stage instead of a 7-DoF arm, and noisy state estimates instead of point clouds.

Since v0.8 ("Assembly IV"), every episode is a freshly generated blueprint of up to 20 steps of seven kinds, linked by random precedence and arriving in waves. **Every step weighs the same**, and a step only counts if its end state is still physically there after a small kick at the end of the episode. Small partial credit for real physical progress keeps a gradient. An evaluation's cost is bounded by the simulation horizon only, so the same policy and seed always score the same, however busy the machine is.

**What changed in v0.8 (Assembly IV, breaking)**

v0.8.0 – v0.8.3 were released but never went live. v0.8.4 replaces them, so this list is relative to v0.7.5.

* **New observation: 320 floats.** The first 288 keep the v0.7 layout and the last 32 describe the blueprint (see Step by Step). The player rejects any policy whose input is not statically 320 wide, so **every v0.7.x (288-wide) policy fails to load and scores 0**. Miners have to retrain.
* **Generated blueprints.** Each episode has 4 – 8 pegs and up to 20 steps: up to 3 keys, more stacks, screws and rework, up to 4 waves and denser precedence (see the tier table).
* **Equal weights.** The episode score is the mean of its step credits.
* **End-state credit.** When the episode ends, pegs in holes and loose rings get a random sideways kick, the jaws open and the board settles. A completed step scores only if it still checks out afterwards (see Scoring for what is exempt). Inserts no longer latch for scoring: a peg pulled back out scores nothing.
* **Small, physical partial credit.** An unfinished insert, rework, collar or stack step can earn at most about 0.31, from a real grasp, lift, transport, insertion, alignment and stable release. Unfinished keys, twists and screws earn nothing; re-grasping their peg is not progress on them.
* **Keys without cues.** The closeness cue, the retarget pulse, the tolerance in task channel 5 and the wrist-torque detent are gone, and the absolute key yaw is still hidden. Windows are narrower (tolerance 0.045 – 0.080 → 0.035 – 0.055 rad) and sit at least 0.22 rad from wrist yaw 0 and from the hole's symmetric orientations. Every key has to be armed by leaving the window after the probe; D-flat pegs no longer skip this.
* **Key credit is kept from completion.** A finished key keeps its credit, scaled by how close to the window centre the wrist was when it finished, as long as its peg is still in its hole at the end with the gripper off it. The wrist is free to move on to the next key.
* **Harder starts and dynamics.** No peg starts in the gripper or near its hole. Friction, mass, gain and delay get an extra per-episode stretch, clearance is tighter, pose-estimate biases are about twice v0.7's, and events lean towards physics changes.
* **Horizon 920 steps** (36.8 s), up from 870.
* **Failures are contained.** If an episode can't be built, or a referee worker process dies or stalls, the affected episodes score a deterministic 0 (`reset_failure` / `worker_failure`) and stay in the 64-episode denominator; the rest of the evaluation continues.
* **Records** no longer publish `key_yaw` or `key_tol`; step results add precision, stability and milestones.

**Earlier versions.** v0.7 ("Assembly III") added rework, screw, stack and key steps, adaptive mid-episode events, touch-gated reveals and weights that put most of the score on keys. v0.6 introduced compound tasks and the 288-float observation; v0.5, per-episode board layouts and held-out families.

**Evaluation Overview**

Each live evaluation runs **64 episodes**: 8 strata (number of pegs K ∈ {3, 4, 5, 6} × clutter low/high) with 8 episodes each. Inside each stratum, the physical conditions are drawn by Latin hypercube. Each stratum gets **2 easy, 3 medium and 3 hard** sensing episodes (the tier scales noise, bias and clearance, not starts) and **2 each of c1, c2, c3 and c4**, which is 16 / 16 / 16 / 16 per evaluation.

**The seven step kinds**

Every kind weighs the same.

| Kind | What it takes |
| --- | --- |
| `insert` | Seat a peg in its own hole. |
| `collar` | Drop a ring over a peg that is already seated, so it rests on the slot block. |
| `twist` | Turn a seated round peg 1.2 – 2.0 rad in a given direction. |
| `screw` | A twist that only counts while the gripper presses down on the peg; done at 80% of a target of 0.30 – 0.55 rad. |
| `rework` | A peg starts seated 5.0 mm deep in the wrong empty slot. Pull it out, then seat it in its own hole. |
| `stack` | A ring that must end up on the top of a seated peg, not on the block. Bring the ring, still gripped, to within 3.0 mm sideways of the hole centre and 2.8 mm of the peg top for at least 2 control steps. Then release it (open the jaws or lift clear) and let it stay there for 5 more steps. |
| `key` | Seat the peg, press-probe it and arm it, then hold the hand (wrist) yaw inside a hidden window (tolerance 0.035 – 0.055 rad) for 4 control steps without touching the peg. The window can move mid-episode. The full rule is under Scoring. |

| Per tier | c1 | c2 | c3 | c4 |
| --- | --- | --- | --- | --- |
| Extra pegs (at most 8 in total) | +1 | +1 | +2 | +2 |
| Keys per episode (fewer if not enough pegs qualify) | 2 | 2 | 3 | 3 |
| Rework share of pegs | 22% | 26% | 30% | 34% |
| Collar / stack share of ring-sized pegs | 20% / 45% | 22% / 50% | 25% / 55% | 28% / 60% |
| Screw / twist chance per round peg | 25% / 15% | 30% / 18% | 35% / 20% | 40% / 22% |
| Waves | 1 – 2 | 2 | 2 – 3 | 3 – 4 |
| Extra precedence edges | 22% | 26% | 30% | 34% |
| Between-step event chance | 28% | 34% | 40% | 48% |
| Key retarget after its peg is inserted | 45% | 55% | 65% | 75% |
| Key retarget after the stack on its peg is done | 40% | 48% | 55% | 65% |
| Time slack | × 1.55 | × 1.40 | × 1.25 | × 1.10 |

A key never shares a peg with a twist, screw or rework. 40% of key pegs also get a stack ring, and that stack often has to come first. There are at most 4 rings per episode, and at least one stack whenever a peg is small enough.

| Condition | Live range |
| --- | --- |
| Between-step events | after a completed step, with the per-tier chance above. Physics, most likely first: friction × 0.25 – 2.6, gain × 0.30 – 2.0, part mass × 0.40 – 3.0, actuation delay 0 – 5 steps, estimate re-bias 2.5 – 10 mm, or a shove. Adaptive: `swap_bias` (estimate residuals reshuffled), `retarget` (a key's window moves), `misseat` (a seated peg is lifted 7 – 16 mm), `reorder` (a new edge between unfinished steps), `regraph` (some such edges dropped, 1 – 3 added), `flip_twist` (a twist or screw reverses and loses its progress), `activate` (rotates the active key) |
| Clutter blocks | 0 – 1 (low) or 2 – 3 (high); often placed near a hole approach |
| Board layout | 8 holes per board; positions, yaw, family and size drawn per episode |
| Board pose | ±30 mm in x and y, ±0.15 rad yaw, per episode |
| Radial clearance | 0.18 – 0.55 mm, with a variable entry chamfer |
| Friction / peg mass / controller gain | drawn 0.25 – 1.6 / 4 – 65 g / × 0.45 – 1.6, then stretched per episode by × 0.55 – 1.85 / × 0.55 – 2.2 / × 0.45 – 1.65, within 0.15 – 2.5 / 3 – 120 g / × 0.25 – 2.2 |
| Actuation delay | 0 – 1 step (0 on easy), plus 0 – 3 more per episode, at most 4 |
| Pose estimates | Same structure as v0.6 (per-hole and per-peg biases, noise, drift, dropout, glitch bursts). On the hard tier: hole-estimate bias 4.3 – 10.2 mm, extra peg-vs-hole bias 4.8 – 10.4 mm, drift up to 0.05 mm/step; smaller on easy and medium |
| Control / physics | 25 Hz control, 500 Hz physics (20 substeps per action). **Fixed.** |
| Horizon | Sum of per-step budgets (insert 90, collar 70, twist 55, screw 110, stack 110, key 120, rework 160; +140 for a lying start) × the tier's time slack, + 40 per extra wave, capped at **920 steps (36.8 s)**. Nearly every live blueprint sums to more than the cap, so in practice the horizon is 920 steps. |

* **The difficulty does not drift between rounds.** Strata, tier mix and ranges are fixed; only the draw inside them changes.
* Within a round, **every submission faces the same episodes**, and the incumbent is re-scored on them.
* **The round seed never enters the player sandbox.** Every episode is derived inside the referee from the platform seed plus private build entropy. Local runs use the same distribution but cannot reproduce a live round.

**Start States**

No peg starts in the gripper, beside its hole or in its own hole: every free peg starts `loose`, `lying` or in the `tray` (former grasped and near-hole starts are redrawn: 68% loose, 24% lying, 8% tray). Pegs in a later wave arrive as `loose` or `lying` at a free spot. Rework pegs start seated in a wrong empty slot. Collars and stack rings start lying flat on the board, away from the holes.

| Start type | Peg begins |
| --- | --- |
| `loose` | standing upright on the board, 40 – 70 mm from its hole |
| `lying` | toppled on its side, 50 – 70 mm away. Seating it takes a re-orienting regrasp. |
| `tray` | standing in a tray area near one edge of the board |

**Step by Step**

At each control step the policy receives a **320-float observation**: the 288-float v0.7 layout followed by 32 blueprint floats.

| Block | Size | Contents |
| --- | --- | --- |
| Proprioception | 16 | hand position relative to the board (×10, m); sin/cos of hand yaw; hand velocity (3); finger gap (×50); wrist force (3); wrist torque (3); finger-pad force (1) |
| Last action | 5 | the previous action |
| Peg table | 8 × 17 | one row per active peg, paired with its target hole; unused rows are zero. Per row: presence (1); estimated peg position relative to the estimated hole (×10, 3); estimated peg quaternion (4); estimated hole yaw as sin, cos (2); peg outer (circumscribed) size (×50, 1); a zero (1); peg inscribed size (×50, 1); estimated hole position relative to the board (×10, 3); seated flag (1) |
| Clutter table | 3 × 9 | presence; estimated position relative to the board (×10, 3); quaternion (4); size (×50) |
| Task table | 8 × 6 | per peg row, six channels (see below) |
| Collar table | 4 × 13 | presence (0 until it arrives; 2 for a stack ring); estimated ring position relative to the estimated target hole (×10, 3); quaternion (4); inner and outer radius (×100, 2); target peg row / 8; done; blocked |
| Globals | 4 | elapsed fraction of the horizon; fraction of steps done; fraction of waves arrived; number of steps / 16 |
| Blueprint | 32 | see below |

| Task channel | Meaning |
| --- | --- |
| 0, 1 | step done, step blocked (insert or rework) |
| 2 | twist direction ±1 or screw direction ±2; for a key, 0.5 once it is revealed and active (a presence mark only); 0 if none or not yet revealed |
| 3 | twist or screw progress (0 – 1), or the "extracted" flag for a rework peg; always 0 for a key |
| 4 | twist / screw / key blocked (a key also reads blocked while it is not the active key) |
| 5 | 1 = has a collar, 2 = has a stack ring (key pegs included) |

| Blueprint float | Meaning |
| --- | --- |
| 0 – 3 | number of steps / 40; complexity tier (0.25 c1, 0.50 c2, 0.75 c3, 1.0 c4); number of waves / 4; fraction of steps done |
| 4 – 27 | the first 12 steps, two floats each: kind code / 10 (insert 0.1, collar 0.2, twist 0.3, rework 0.4, screw 0.5, stack 0.6, key 0.7), then its peg row + 0.5 if blocked + 0.25 if done; zero for missing steps |
| 28 – 31 | mean number of prerequisites per step / 4; (active key's step index + 1) / number of steps, 0 if none; elapsed fraction of the horizon; parts lost / number of pegs |

* **Step order is fixed:** each peg's insert or rework followed by its key, then twists, screws, collars and stacks. Steps past the 12th are not in the blueprint, but their state still shows in the task and collar tables.
* **Hidden parameters read as 0 until revealed.** A twist or screw direction only appears once its gating prerequisite is done, and half the time only after the gripper has touched that peg. A key's 0.5 mark always needs both.
* **No key cues.** Nothing in the observation encodes a key's window, its tolerance or how close the wrist is. The only feedback is completion itself: the done fractions and, for the first 12 steps, the blueprint's done flag. The wrist yaw-torque detent is gone, so the wrist torque is the real contact torque.
* **Exact peg and hole poses are never given.** Every pose in the table is an estimate with the biases and noise listed above. A peg is aligned when its yaw matches the hole yaw, up to the cross-section's own symmetry, which the policy has to work out from the sizes and from contact.
* **Clearance, friction, mass, gain, delay and the bias values are not observed.**
* **There is no recurrent state.** The policy is called once per step on the current observation; only the previous action is fed back. Rows for parts that haven't arrived yet are zero.

The exact encoding is `AssemblyIVEpisode.observe` in `referee/nist_sim/compound_v08.py`.

The policy returns **5 floats in [−1, 1]**: `dx, dy, dz` (±4 mm per step), `dyaw` (±0.08 rad per step), and gripper (+1 open, −1 close). These are incremental position targets tracked by a PD loop. Stage travel is ±250 mm in x and y, −3 to 250 mm in z, and ±3.1 rad in yaw.

**Constraints**

* Terminal reasons, reported per episode:
  * `assembled`: every step is done and every wave has arrived. The episode ends early.
  * `time_limit`: the horizon ran out.
  * `unstable`: non-finite state, or a part moving faster than 4 m/s.
  * A part that leaves the board area (|x| or |y| beyond 300 mm) or falls below the surface is removed; its unfinished steps score what they have, and the episode continues.
  * `invalid_action`: that episode's action was not a finite 5-vector. Ends that episode.
  * `player_fault`: the `/act` call errored, timed out, or returned a batch of the wrong shape. Ends every episode still running.
  * `reset_failure` / `worker_failure`: the referee could not build the episode, or the worker simulating it failed. Scores 0.
* Every other ended episode, whatever the reason, goes through the end check below.
* One batched `/act` call per control step covers every episode still running. The round's deadline is **500 ms per call**; the referee enforces it as an HTTP timeout of the deadline plus 1 s.
* Timeouts: **1800 s** for the referee and for the player. A full live evaluation (64 episodes × 920 steps) takes about **5 – 6 minutes** plus the policy's own time for its 920 calls.
* Player and referee each run on **2 CPU / 2 GiB / no GPU**. The player runs ONNX Runtime on CPU with one thread.

**Scoring**

A peg is **inserted** when, for 5 consecutive control steps, it is in its own hole with its bottom within 1 mm of fully inserted, its centre within the hole radius, its tilt within 10° of vertical, and the gripper is clear of it.

A **key** is done when, for 4 control steps in a row, all of these hold:

* its peg is in its hole (seated, or its bottom within 3 mm of fully inserted with its centre inside the hole radius);
* every prerequisite is done (its insert or rework, sometimes the stack on its peg, plus any edge an event adds), and the key is the active one;
* the peg has been **press-probed**: on 10 control steps in total, not necessarily in a row, the gripper touched the peg with its pad centre at least about 1 mm below the peg top;
* the key is **armed**: after the probe, the hand yaw has been outside the window at least once while the peg was in its hole. No peg family is exempt;
* the hand (wrist) yaw is inside the window: |hand yaw − window centre| ≤ tol;
* the gripper is not touching the peg.

The window is in world-frame hand yaw (the yaw in the proprioception block), not peg yaw. For a round peg, its centre can be anywhere within ±2.95 rad that is at least 0.22 rad from 0 and from the hole's yaw. For other pegs, it sits midway between two neighbouring symmetric orientations of the hole (± 0.04 rad), also away from 0. A retarget moves the window (by at least max(0.15 rad, 2.5 × tol) when it can), redraws the tolerance 75% of the time, resets the hold and disarms the key. Probe steps are kept. With several unfinished keys only one is active (blueprint float 29): a key becomes active when its prerequisites finish, the next one takes over after a key completes, and `activate` and `regraph` events can rotate it.

The other kinds are done as described in the step table. During play, an insert, rework, screw, stack or key stays done; a collar or twist is undone if its part is knocked out, and `misseat` undoes an insert or rework. What scores is the **end check**. When an episode ends, the referee checks every completed step, kicks every peg that sits in a hole sideways (random direction, 0.9 m/s) and every ring (0.63 m/s), opens the jaws, lets the board settle for 12 control steps and checks again. Mated stack rings are not kicked, and neither is the carrier peg of a completed stack if it is fully seated; a carrier that is in its hole but not seated still is. A step that fails either check counts as unfinished. The end-state checks are:

* insert or rework: peg in its hole (as for keys), gripper off it;
* collar: ring upright on the block within 3 mm of the hole centre, peg seated, gripper off it;
* stack: ring mated in play, still upright within 3 mm of the hole centre and of the peg top, peg in its hole, gripper off it;
* twist or screw: at least 80% of the target turned, peg in its hole;
* key: peg in its hole, probe and arming done, gripper off the peg. The final wrist yaw doesn't matter.

Each step k gets a precision `p_k`: 1 − (peg centre offset / hole radius) for inserts and rework, 1 − (ring offset / 3 mm) for collars and stacks, the fraction turned for twists and screws, and 1 − |hand yaw − window centre| / tol at the moment a key completed. The lower of the values before and after the kick counts. The credit `c_k` is:

```
c_k = (0.80 + 0.20 * (1 - t_k / T)) * (0.70 + 0.30 * p_k)   done in order, passes the end check (t_k = step when done, T = horizon)
c_k = 0.03                                                 done while one of its prerequisites was still open
c_k = up to 0.312                                          not done: insert, rework, collar, stack (milestones below)
c_k = 0                                                    not done: key, twist, screw
```

```
S_e       = mean of c_k over the episode's steps
raw_score = mean of S_e over all episodes      -> [0.0, 1.0]
```

Milestones only count for an unfinished step whose prerequisites are all done, are earned by the policy's actions (never by the reset state), and keep their best value:

| Milestone | Credit | What it takes |
| --- | --- | --- |
| lift | 0.12 | jaws closed on the part, which is at least 8 mm above where it rested and rising, for 2 steps in a row. Short of that, both fingers holding it 4 – 8 mm up for 8 steps earns up to 0.024 |
| transport | up to 0.036 | after a lift, the held part is carried toward its own hole; full at 25 mm from it |
| held insertion | up to 0.036 | after transport, the held part is upright with its centre inside the hole radius; more for deeper and more central |
| alignment | 0.06 | after a lift, the held part is upright near its target pose (within about twice the seat tolerance) |
| stable release | 0.06 | after alignment, the part rests near its target pose, untouched, through the last 8 settle steps of the end check |

* **Every step counts the same.** A finished, precise, early step is worth up to 1.0; the most an unfinished one can earn is 0.312 (the code caps it at 0.36).
* **Order matters.** A step done before its prerequisites earns 0.03; the blocked flags say what is open. A key can't finish with a prerequisite open.
* An episode in which the policy never acted scores 0. The denominator is fixed: every episode counts, including ones ended by a fault or a failure.
* To take the lead, a challenger must beat the current top raw score by more than 1%. The incumbent is re-scored at the start of each round on the same episodes, so the comparison is like-for-like; results that finish before the incumbent's re-score are re-judged against the new bar once it lands. `baseline_raw_score` is 0.0.
* The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.
* Per-step `step_results[].credit` in the records is the credit used in the score, and `precision`, `stable`, `partial` and the `*_fraction` fields show how it was earned.

**Reference numbers (v0.8.4)**

| Policy | Score |
| --- | --- |
| zero (no-op) | exactly 0 |
| uniform random | exactly 0 |
| a strong observation-only scripted controller | about 0.008 |
| a CEM-tuned controller | about 0.013 |
| the author's assisted privileged reference (reads true state and uses simulator assists, so no policy can reach it) | about 0.15 (0.149 – 0.163 on three seeds) |

These are the author's measurements on public seeds 7, 19 and 31 (64 episodes each) with the v0.8.2 scorer. v0.8.3 and v0.8.4 change only failure handling, one stack-carrier edge case and the removal of the key detent, which shifts each seed's event draws. Our preview of the released v0.8.4 images: zero and random 320-wide policies score exactly 0, repeat runs give byte-identical records, and 64 episodes take about 5 – 6 minutes.

A perfect 1.0 needs every step done early, in order, precisely and stably, and is not reachable in practice.

**Miner Submissions**

* A single **ONNX graph** with exactly one input; its first output is the action:
  * input `[batch, 320]` float32. The width must be a static 320; any other width (including the old 288 and 184) is rejected at load and the evaluation scores 0.
  * output `[batch, 5]` float32
  * the batch dimension must be **dynamic**.
* Opset **13 – 21**, standard operators only, one self-contained file (no external data).
* Maximum size **50 MB**. The architecture is not constrained.
* Submission fee: **$10.00 USD**.
* Default round length: **1 day**. Submissions are revealed **1 day** after evaluation.
* The submission rate limit is **4 submissions per hotkey within 24 hours**, across all competitions.
* After each round, every evaluation's records are available. Each episode has a record (`nist_lite_record/4`, `nist_profile: v08`) with:
  * the score, terminal reason (`failure_reason` too for a reset or worker failure) and per-peg outcomes;
  * the full task graph (`task.steps`, wave times). Rework steps add `wrong_slot` and some steps carry `reveal_after`. Key windows (`key_yaw`, `key_tol`) are never published, before or after the round;
  * `conditions.collars`, where stack rings are marked `"kind": "stack"`;
  * per-step `step_results` (credit, precision, stability and milestones), events, credit by step kind and parts lost;
  * the board layout (`conditions.slots`), board pose, and each peg's shape, size and start type.

  Every 8th episode also has a full trajectory, including ring poses and parked flags. The website replay viewer draws each episode's own layout.

**Tips for Miners**

* **Breadth and reliability beat one hard step.** Every step weighs the same and partial credit is small, so finishing many steps early, in order and cleanly is the score.
* **Leave things in place.** Seat pegs fully, release parts properly, and don't be touching a finished part when the episode ends: the end check kicks the board and re-checks everything.
* **Read the blueprint**, and re-read it after every event: `reorder` and `regraph` change the edges, and `activate` changes the active key.
* **Keys are a blind search.** Press-probe the peg, move the wrist out of the window to arm it, let go, then try wrist yaws and hold each for 4 steps; a rise in the done fraction is the only sign of success. A retarget disarms the key: arm and search again.
* **Identify the system online.** Mass, friction, gain and latency differ every episode and can change after any step; force/torque and the effect of your own actions are the only signals.
* **Train against the real simulator.** `referee/nist_sim` imports directly; with `NIST_PROFILE=v08`, `nist_sim.compound_v08.sample_compound_v08(seed, per_stratum)` draws a round's episodes, and `AssemblyIVEpisode` in the same module is the exact simulator used for scoring.
* **Don't overfit the dev seeds.** Live rounds add private build entropy, and some families and condition ranges are held out entirely.
* The full environment is public at [apex-competition-nist-assembly](https://github.com/unarbos/apex-competition-nist-assembly).
