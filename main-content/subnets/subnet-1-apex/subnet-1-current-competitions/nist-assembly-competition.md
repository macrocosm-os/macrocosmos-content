# NIST Assembly Competition

### NIST Assembly Competition

**Getting a peg to the hole is not the same as seating it.** The last millimetre is the hard part: with 0.20 to 0.68 mm of radial clearance, the contact that completes an insertion is the same contact that jams it. A peg still held in the gripper has not been assembled, and on a full board each seated peg is one more thing the gripper can knock out on the way to the next.

The NIST Assembly competition asks miners to drive a **parallel 2-finger gripper on a Cartesian stage** (x, y, z, yaw) through **compound assembly tasks** on a board modelled on the **NIST Assembly Task Board #1**, simulated in MuJoCo on CPU. Miners submit an ONNX policy that outputs incremental stage and gripper commands at 25 Hz. The setup borrows from AlphaNIST (Zhang et al., arXiv 2610.13354): the ATB-1 board, the 1 mm success criterion, 25 Hz control, diverse start states and free-order multi-part episodes. It is much smaller: primitive geometry, a 4-DoF stage instead of a 7-DoF arm, and noisy state estimates instead of point clouds.

Since v0.7 ("Assembly III"), every episode is a random assembly graph of seven kinds of step. Most of the score sits in three hard kinds: **keys, stacks and rework**, and a key weighs more than any other step. Scoring gives weighted credit per step so that a ranked competition has a gradient. An evaluation's cost is bounded by the simulation horizon only, so the same policy and seed always score the same, however busy the machine is.

**What changed in v0.7.5**

v0.7.4 was released but never went live. v0.7.5 replaces it, so this list is relative to v0.7.3 and includes the v0.7.4 changes that carry over.

* **Keys follow the hand, not the peg.** A key now checks the wrist yaw (the stage's yaw joint) against a hidden window, with a tolerance of 0.045 – 0.080 rad. The peg's own yaw no longer matters.
* **The key yaw is no longer published.** The sin/cos key channels are gone. Instead, once the peg has been press-probed, task channel 3 carries a noisy closeness cue, channel 2 pulses when the key is retargeted, and the wrist yaw torque gets a detent while the gripper presses inside the window (see Step by Step).
* **Press-probe and arming.** A key's cues and its completion need 10 steps of the gripper pressing on its peg. After that, the wrist has to leave the window once and come back; D-flat pegs skip this. Then the wrist has to stay in the window for 4 steps (was 5) without touching the peg. A retarget disarms the key again.
* **Keys only wait on their own peg.** At the start, a key's only prerequisite is its peg's insert or rework. The stack-before-key edge is gone. `reorder` and `regraph` events can still add a prerequisite mid-episode.
* **Keys earn partial credit.** An unfinished key can earn up to 0.30, but only with the wrist inside the window after the probe and arming. A key done in order earns at least 0.95. Stacks and rework stay all-or-nothing.
* **One key per episode** in every tier (was up to 2).
* **Single-active keys.** When several keys are unfinished, only one is active at a time, and the new `activate` event rotates it. With one key per episode, this never applies in v0.7.5.
* **New events.** `regraph` drops some precedence edges between unfinished steps and adds 1 – 3 new ones. A key is also often retargeted after the stack on its peg is done. `misseat` is rarer (4% of events, was 14%).
* **Inserts latch.** Once an insert is done, it stays done even if the peg is pulled out. Only a `misseat` event undoes it.
* **New weights.** Key 6.00, stack 1.20, rework 1.10, screw 0.10; insert, collar and twist 0.04.
* **Shorter horizon.** Smaller per-step budgets and a cap of 870 steps (34.8 s), down from 1,400.
* **Retuned tiers.** More time slack, fewer between-step events and retargets, sparser precedence, c1 always has one wave and c3 one or two (see the tier table). The stack mate zone is tighter (3.0 mm sideways, 2.8 mm in height), and rework pegs start 5.0 mm deep (was 4.5 mm).
* **Same interface.** The observation is still 288 floats with the same blocks; only the key channels changed meaning. Scores aren't comparable with v0.7.3.

**What changed in v0.7.3**

* **Adaptive mid-episode events.** New between-step events can move an unfinished key's window (`retarget`), add a precedence edge between unfinished steps (`reorder`), or reverse an unfinished twist or screw and reset its progress (`flip_twist`). After a peg is inserted, its key is often retargeted too. A fixed plan no longer works; the policy has to keep re-reading the observation.
* **Touch-gated reveals.** Many key and twist parameters stay hidden until the gripper has touched that peg, and almost every hard step now has a late reveal.
* **Keys need their prerequisites.** A key can't count, or even earn partial progress, until every step it depends on is done, so an out-of-order key scores 0. Stacks often have to be finished before the key on the same peg.
* **New weights.** Stack 5.00, key 2.60, rework 1.60; every other kind 0.06 or less.
* **Retuned tiers.** Denser precedence, more events and more time slack (see the tier table). The stack mate zone is slightly wider (3.4 mm across, 3.2 mm in height).

**What changed in v0.7.2**

* **Stacks can be completed.** Stack rings are now a slight interference fit, so a ring placed on a peg top can rest there. A stack completes through a place-and-release latch (see the step table). In v0.7.1, no policy could complete a stack through its own actions.
* **Twist and screw steps now appear.** Each eligible round peg gets a twist or screw with the tier's probability. In v0.7.1 their counts rounded to zero.
* **Harder weights and tolerances.** The weights move further to the hard steps (key 5.20, rework 3.60, stack 1.70; every other kind 0.10 or less). The key tolerance is tighter (0.05 – 0.09 rad), as is the stack mate zone (3 mm), and rework pegs sit deeper.
* **Retuned tiers.** There are more rework, stack and key steps, fewer collars, denser precedence, more events and reveals, and less time slack (see the tier table).

**What changed in v0.7.1**

* **Fixes to v0.7.0**, which never went live: the referee image now runs the v0.7 task (`nist_profile: v07` in every result and record), and there are no wall-clock cuts inside the referee. Stack hold counting, key yaw sampling and the completion latch were also fixed, so a completed hard step stays completed.

**What changed in v0.7.0 (Assembly III, breaking)**

* **Four new step kinds:** `rework`, `screw`, `stack` and `key` (see below).
* **Denser graphs and late reveals.** More precedence edges, and some step parameters stay hidden until a prerequisite is done.
* **Stronger between-step events,** plus two new kinds: `swap_bias` and `misseat`.
* **Different weights.** Keys, stacks and rework carry most of the score, so a policy that only inserts pegs and drops collars scores about 0.2.
* **Same interface.** The observation is still 288 floats with the v0.6 layout, and the first 184 are still the v0.5 layout. Policies built for v0.6 load and run, but scores aren't comparable with v0.6.x.

**Evaluation Overview**

Each live evaluation runs **64 episodes**: 8 strata (number of pegs K ∈ {3, 4, 5, 6} × clutter low/high) with 8 episodes each. Inside each stratum, the physical conditions are drawn by Latin hypercube. Each episode gets a sensing difficulty tier (about **25% easy, 35% medium, 40% hard**). Each stratum gets **3 c1, 3 c2, 1 c3 and 1 c4** episodes, which is 24 / 24 / 8 / 8 per evaluation.

**The seven step kinds**

| Kind | What it takes | Weight |
| --- | --- | --- |
| `insert` | Seat a peg in its own hole. | 0.04 |
| `collar` | Drop a ring over a peg that is already seated, so it rests on the slot block. | 0.04 |
| `twist` | Turn a seated round peg past a target angle in a given direction. | 0.04 |
| `screw` | A twist that only counts while the gripper presses down on the peg; done at 80% of a target of 0.30 – 0.55 rad. | 0.10 |
| `rework` | A peg starts seated 5.0 mm deep in the wrong empty slot. Pull it out, then seat it in its own hole. | 1.10 |
| `stack` | A second-level ring that must end up on the top of a seated peg, not on the block. Bring the ring, still gripped, to within 3.0 mm sideways of the hole centre and 2.8 mm of the peg top for at least 2 control steps. Then release it (open the jaws or lift clear) and let it stay there for 5 more steps. | 1.20 |
| `key` | Seat the peg and press-probe it, then hold the hand (wrist) yaw inside a hidden key window (tolerance 0.045 – 0.080 rad) for 4 control steps without touching the peg. The window can move mid-episode. The full rule is under Scoring. | 6.00 |

| Per tier | c1 | c2 | c3 | c4 |
| --- | --- | --- | --- | --- |
| Extra pegs | 0 | 0 | +1 | +1 |
| Rework / stack share | 16% / 34% | 18% / 36% | 20% / 38% | 22% / 40% |
| Keys per episode | 1 | 1 | 1 | 1 |
| Collar share | 5% | 5% | 4% | 4% |
| Screw / twist chance per round peg | 5% / 3% | 6% / 3% | 6% / 2% | 5% / 2% |
| Waves | 1 | 1 – 2 | 1 – 2 | 2 |
| Extra precedence edges | 16% | 18% | 22% | 24% |
| Between-step event chance | 22% | 26% | 30% | 34% |
| Hidden-parameter reveals (after a prerequisite / after touching the peg) | 100% / 100% | 100% / 100% | 100% / 100% | 100% / 100% |
| Key retarget after its peg is inserted | 28% | 32% | 36% | 40% |
| Key retarget after the stack on its peg is done | 22% | 26% | 30% | 34% |
| Time slack | × 2.10 | × 1.95 | × 1.80 | × 1.70 |

A key never shares a peg with a twist or screw. Twists and screws are touch-gated at half the rate shown.

| Condition | Live range |
| --- | --- |
| Between-step events | after a completed step, with the per-tier chance above. Mostly adaptive, most likely first: `retarget` (an unfinished key's window moves), `swap_bias` (peg-vs-slot residuals reshuffled), `regraph` (some precedence edges between unfinished steps are dropped and 1 – 3 new ones added), `reorder` (a new precedence edge between unfinished steps), `flip_twist` (an unfinished twist or screw reverses and loses its progress), `activate` (rotates the active key; no effect with one key). Less often: friction × 0.30 – 2.2, gain × 0.35 – 1.75, part mass × 0.45 – 2.6, actuation delay 0 – 4 steps, estimate re-bias 2 – 8 mm, a shove, or `misseat` (a seated peg is lifted 6 – 14 mm and has to be re-seated) |
| Clutter blocks | 0 – 1 (low) or 2 – 3 (high); often placed near a hole approach |
| Board layout | 8 holes per board; positions, yaw, family and size drawn per episode |
| Board pose | ±30 mm in x and y, ±0.15 rad yaw, per episode |
| Radial clearance | 0.20 – 0.68 mm, with a variable entry chamfer |
| Friction / peg mass / controller gain | 0.3 – 1.3 / 5 – 50 g / × 0.6 – 1.4 |
| Pose estimates | Same structure as v0.6 (per-hole and per-peg biases, noise, drift, dropout, glitch bursts), with the biases, glitch rate and drift scaled to about 0.40 – 0.45× the v0.6 values |
| Control / physics | 25 Hz control, 500 Hz physics (20 substeps per action). **Fixed.** |
| Horizon | Sum of per-step budgets (insert 120, collar 90, twist 70, screw 140, stack 140, key 140, rework 210; +140 for a lying start) × the tier's time slack, + 40 per extra wave, capped at **870 steps (34.8 s)**. Every live task graph sums to more than the cap, so in practice the horizon is always 870 steps. |

* **The difficulty does not drift between rounds.** Strata, tier mix and ranges are fixed; only the draw inside them changes.
* Within a round, **every submission faces the same episodes**, and the incumbent is re-scored on them.
* **The round seed never enters the player sandbox.** Every episode is derived inside the referee from the platform seed plus private build entropy. Local runs use the same distribution but cannot reproduce a live round.

**Start States**

Each peg gets its own start type. Easy-tier episodes use grasped and near-hole starts; medium and hard tiers mix all five. Pegs in a later wave arrive as `loose` or `lying` at a free spot. Rework pegs start seated in a wrong empty slot. Collars and stack rings start lying flat on the board, away from the holes.

| Start type | Peg begins |
| --- | --- |
| `grasped` | already in the gripper, 10 – 40 mm above and within 10 mm of its hole (at most one per episode) |
| `near_hole` | standing on the board just beside its hole |
| `loose` | standing upright on the board, 40 – 70 mm from its hole |
| `lying` | toppled on its side, 50 – 70 mm away. Seating it takes a re-orienting regrasp, and a lying seat has not been demonstrated on the multi-peg board. |
| `tray` | standing in a ring with the other tray pegs, in a tray area near one edge of the board |

**Step by Step**

At each control step the policy receives a **288-float observation**, with the same blocks as v0.6:

| Block | Size | Contents |
| --- | --- | --- |
| Proprioception | 16 | hand position relative to the board (×10, m); sin/cos of hand yaw; hand velocity (3); finger gap (×50); wrist force (3); wrist torque (3); finger-pad force (1) |
| Last action | 5 | the previous action |
| Peg table | 8 × 17 | one row per active peg, paired with its target hole; unused rows are zero. Per row: presence (1); estimated peg position relative to the estimated hole (×10, 3); estimated peg quaternion (4); estimated hole yaw as sin, cos (2); peg outer (circumscribed) size (×50, 1); a zero (1); peg inscribed size (×50, 1); estimated hole position relative to the board (×10, 3); seated flag (1) |
| Clutter table | 3 × 9 | presence; estimated position relative to the board (×10, 3); quaternion (4); size (×50) |
| Task table | 8 × 6 | per peg row, six channels (see below) |
| Collar table | 4 × 13 | presence (0 until it arrives; 2 for a stack ring); estimated ring position relative to the estimated target hole (×10, 3); quaternion (4); inner and outer radius (×100, 2); target peg row / 8; done; blocked |
| Globals | 4 | elapsed fraction of the horizon; fraction of steps done; fraction of waves arrived; number of steps / 16 |

v0.7 reuses the six task-table channels per peg row:

| Channel | Meaning |
| --- | --- |
| 0, 1 | step done, step blocked (insert or rework) |
| 2 | twist direction ±1 or screw direction ±2; for a key, 1 for 20 steps after a retarget (retarget pulse); 0 if none or not yet revealed |
| 3 | twist or screw progress (0 – 1), a noisy closeness cue (0 – 1) for a key, or the "extracted" flag for a rework peg |
| 4 | twist / screw / key blocked (a key also reads blocked while it is not the active key) |
| 5 | 1 = has a collar, 2 = has a stack ring; on a key peg with neither, the key tolerance × 10 once the key cues are on |

* **Hidden parameters read as 0 until revealed.** A twist or screw direction only appears once one of its prerequisite steps is done, and half the time only after the gripper has touched that peg.
* **Key cues.** The absolute key yaw is never published. For a key, channels 2 and 3 and the tolerance in channel 5 read 0 until the peg's insert (or rework) is done, the gripper has touched the peg, the peg has been press-probed (see Scoring) and the key is active. After that, channel 3 is clip(1 − |hand yaw − window centre| / (2.8 × tol), 0, 1) plus Gaussian noise (σ 0.08), clipped to [0, 1]. Before noise, it is 1 at the window centre and 0 beyond 2.8 × tol. It says how close the wrist is, not which way to turn.
* **Key detent.** While the gripper presses on a probed, active key peg that sits in its hole, with the hand yaw inside the window, each step adds 0.22 N·m (σ 0.05) to the wrist yaw torque, before the ×0.5 observation scale. The torque channel is smoothed, so the bump builds up while the press lasts.
* **Exact peg and hole poses are never given.** Every pose in the table is an estimate with the biases and noise listed above. A peg is aligned when its yaw matches the hole yaw, up to the cross-section's own symmetry, which the policy has to work out from the sizes and from contact.
* **Clearance, friction, mass, gain and the bias values are not observed.** The wrist force/torque and pad force channels are what a policy can use to find a hole it cannot see precisely.
* **There is no recurrent state.** The policy is called once per step on the current observation; only the previous action is fed back.
* Rows for parts that haven't arrived yet are zero.

The exact encoding is `AssemblyIIIEpisode.observe` in `referee/nist_sim/compound_v07.py`.

The policy returns **5 floats in [−1, 1]**: `dx, dy, dz` (±4 mm per step), `dyaw` (±0.08 rad per step), and gripper (+1 open, −1 close). These are incremental position targets tracked by a PD loop. Stage travel is ±250 mm in x and y, −3 to 250 mm in z, and ±3.1 rad in yaw.

**Constraints**

* Terminal reasons, reported per episode:
  * `assembled`: every step is done and the gripper is clear. The episode ends early.
  * `time_limit`: the horizon ran out.
  * `unstable`: non-finite state, or a part moving faster than 4 m/s.
  * A part that leaves the board area (|x| or |y| beyond 300 mm) or falls below the surface is removed; its unfinished steps score what they have, and the episode continues.
  * `invalid_action`: that episode's action was not a finite 5-vector. Ends that episode.
  * `player_fault`: the `/act` call errored, missed its deadline, or returned a batch of the wrong shape. Ends every episode still running.
* One batched `/act` call per control step covers every episode still running, with a **500 ms deadline per call**.
* Timeouts: **1800 s** for the referee and for the player. A full live evaluation (64 episodes) takes about **8 – 20 minutes**, depending on the policy and on how many evaluations run at once.
* Player and referee each run on **2 CPU / 2 GiB / no GPU**.

**Scoring**

A peg is **inserted** when, for 5 consecutive control steps, it is in its own hole with its bottom within 1 mm of fully inserted, its centre within the hole radius, its tilt within 10° of vertical, and the gripper is not touching it.

A **key** is done when, for 4 control steps in a row, all of these hold:

* its peg is in its hole (seated, or its bottom within 3 mm of fully inserted with its centre inside the hole radius);
* every prerequisite is done, and the key is the active one (always true with one key per episode);
* the peg has been **press-probed**: on 10 control steps in total, not necessarily in a row, the gripper touched the peg with its pad centre at least about 1 mm below the peg top. A grasp counts if the fingers reach far enough down the peg; a touch on top of the peg does not;
* the key is **armed**: after the probe, the hand yaw has been outside the window at least once while the peg was in its hole. Pegs with no rotational symmetry (D-flat) arm as soon as the probe is done;
* the hand (wrist) yaw is inside the window: |hand yaw − window centre| ≤ tol;
* the gripper is not touching the peg.

The window is in world-frame hand yaw (the yaw in the proprioception block), not peg yaw. For a round peg, its centre can be anywhere within ±2.95 rad but never within 0.35 rad of 0. For other pegs, it sits on one of the slot's symmetric orientations (± 0.03 rad). A retarget moves the window (on a D-flat peg it keeps the centre and redraws the tolerance), resets the hold and disarms the key. Probe steps are kept.

The other kinds are done as described in the step table above. Once done, an insert, rework, screw, stack or key step stays done, even if its part is moved later. A collar or twist is undone if its part is knocked out. A `misseat` event lifts a seated peg and undoes its insert or rework step, which then has to be earned again.

Each step k has a weight `w_k` (table above) and a credit `c_k`:

```
c_k = 0.70 + 0.30 * (1 - t_k / T)    done in order (t_k = step when done, T = horizon); a key gets at least 0.95
c_k = 0.30                           done while one of its prerequisites was still open (keys can't: they need every prerequisite)
c_k = up to 0.30                     not done: partial progress (insert, collar, twist, screw)
c_k = 0.30 * f                       not done, key: f = 1 - |hand yaw - window centre| / tol, best value reached
c_k = 0                              not done: stack and rework are all-or-nothing
```

```
S_e       = sum_k w_k c_k / sum_k w_k
raw_score = mean of S_e over all episodes      -> [0.0, 1.0]
```

* **Keys are most of the score.** A key is worth 6.00, a stack 1.20 and a rework 1.10; every other kind weighs 0.10 or less.
* **Key partial credit is gated.** `f` only counts while the peg is in its hole, the probe and arming are done, the key is active and its prerequisites are done. It is 0 outside the window, and a `misseat` on the key's peg resets it. A key finished out of order would score 0, but a key can't finish with a prerequisite open.
* **Order matters.** Doing a step early earns 0.30; the blocked flags say what is open.
* The denominator is fixed: every episode counts, including ones ended by a fault.
* To take the lead, a challenger must beat the current top raw score by more than 1%. The incumbent is re-scored at the start of each round on the same episodes, so the comparison is like-for-like; results that finish before the incumbent's re-score are re-judged against the new bar once it lands. `baseline_raw_score` is 0.0.
* The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.
* Per-step `step_results[].credit` in the records is the plain `c_k` formula: it shows raw partial progress for stack and rework steps, which score 0 unless done, and it leaves out the 0.95 floor for keys. Use `score` for the episode's actual result.

**Reference numbers (v0.7.5)**

| Policy | Score |
| --- | --- |
| zero (no-op), live images | about 0.0003 |
| leading v0.7.3 policies (rounds 26 and 29), run on v0.7.5 | about 0.21 – 0.23 |
| the author's privileged reference (reads true state and nudges poses, so no policy can match it exactly) | about 0.53 – 0.57 |

On the live v0.7.5 images, the top round-29 policy (0.656 on v0.7.3) scored **0.231**. It completed:
* 177 of 249 inserts and 25 of 55 rework steps;
* 6 of 64 keys and 57 of 95 stacks;
* 3 of 6 screws and 2 of 2 twists.

The mid-episode events fired: 36 key retargets, 7 regraphs, 8 reorders, 5 misseats and 6 twist flips across the 64 episodes. Policies trained on v0.7.3 still seat pegs, build stacks and rework well, but they rarely finish a key, and keys are now most of the score.

**Miner Submissions**

* A single **ONNX graph** with one input and one output:
  * input `[batch, 288]` float32 (a static `[batch, 184]` input gets the v0.5 prefix)
  * output `[batch, 5]` float32
  * the batch dimension must be **dynamic**.
* Opset **13 – 21**, standard operators only, one self-contained file (no external data).
* Maximum size **50 MB**. The architecture is not constrained.
* Submission fee: **$10.00 USD**.
* Default round length: **1 day**. Submissions are revealed **1 day** after evaluation.
* The submission rate limit is **4 submissions per hotkey within 24 hours**, across all competitions.
* After each round, every evaluation's records are available. Each episode has a record (`nist_lite_record/4`) with:
  * the score, terminal reason and per-peg outcomes;
  * the full task graph (`task.steps`, wave times). Key steps add `key_yaw` (the hand-yaw window centre at the end of the episode) and `key_tol`, rework steps add `wrong_slot`, and some steps carry `reveal_after`.
  * `conditions.collars`, where stack rings are marked `"kind": "stack"`;
  * per-step `step_results`, events, credit by step kind and parts lost;
  * `nist_profile`;
  * the exact conditions drawn, including the board layout (`conditions.slots`) and peg sizes.

  Every 8th episode also has a full trajectory, including ring poses and parked flags. The website replay viewer draws each episode's own layout.

**Tips for Miners**

* **The hard steps are where the score is.** An insert is worth 0.04; a key is worth 6.00. Inserts are only a few percent of an episode's weight, so a policy that only inserts pegs scores little.
* **Every kind is reachable, but plans have to adapt.** For a key: grasp or press the peg to probe it, find the window with the closeness cue and the torque detent, let go of the peg, and hold the wrist yaw there for 4 steps. After the probe, the wrist has to leave the window once before it counts (D-flat pegs excepted). Touch a peg to reveal its hidden parameters, re-check the key cues after every insert, stack and event, and for a stack, hold the ring on the peg top before letting go.
* **Watch for reveals, retargets and misseats.** A 0 in the twist/key channels can mean "not revealed yet", and for a key also "not probed yet". A 1 in key channel 2 means the key was just retargeted: search again and re-arm. A peg you seated can be lifted by a `misseat` event and needs re-seating.
* **Expect the physics to change mid-episode.** After a step completes, friction, gain, mass, latency or the estimate bias may shift. Force/torque and the effect of your own actions are the only signals.
* **Train against the real simulator.** `referee/nist_sim` imports directly; with `NIST_PROFILE=v07`, `nist_sim.compound_v07.sample_compound_v07(seed, per_stratum)` draws a round's episodes, and the episode class in the same module is the exact simulator used for scoring.
* **Don't overfit the dev seeds.** Live rounds add private build entropy, and some families and condition ranges are held out entirely.
* The full environment is public at [apex-competition-nist-assembly](https://github.com/unarbos/apex-competition-nist-assembly).
