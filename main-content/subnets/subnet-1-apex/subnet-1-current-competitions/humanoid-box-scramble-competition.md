# Humanoid Box Scramble Competition

## Humanoid Box Scramble Competition

**Getting past an obstacle is not the same as clearing one.** Parkour asks a robot to run a course it can read off the terrain ahead; a cluttered room asks it to _change_ the course — shove what is in the way, pick something up, put it somewhere useful, and climb what it has built. That needs arms as well as legs, and it needs a policy that remembers what it just did to the world, because a crate it already moved does not look any different from one it has not touched.

The Humanoid Box Scramble competition challenges miners to drive a **Unitree G1** humanoid across a 48 m × 6 m room strewn with 199 loose boxes, to a finish platform raised **1.6 m above the floor**. Miners submit a trained ONNX controller that outputs joint targets at 50 Hz. Unlike Humanoid Parkour, this robot has **full arm control — 22 actuated joints**, 12 in the legs and 10 in the arms — because pushing, lifting and climbing are the task rather than a side effect of locomotion. The room's shape is fixed and public, but **the entire box field is re-sampled every round** from a seed you never see, and wind is drawn per instance. Neither the field's parameters nor the wind is observable as a number: a policy has to perceive the clutter in front of it and decide what to do about it.

#### Evaluation Overview <a href="#evaluation" id="evaluation"></a>

Each evaluation runs the miner's policy across **12 instances** of the room, up to **2,000 control steps** each. Every instance in a round faces the **identical box field**; what changes between instances is the wind.

| Condition                                        | Range, and whether it moves between rounds                                                   |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------- |
| Box sizes, densities and positions               | Drawn per box from zone-conditioned distributions. **Re-drawn every round.**                 |
| Box surface grip                                 | µ ∈ \[0.40, 0.85], drawn per box **independently of its density**. **Re-drawn every round.** |
| Wind speed                                       | 0–8 m/s, steady for the instance. **Drawn per instance.**                                    |
| Wind direction                                   | Uniform over the full circle, horizontal. **Drawn per instance.**                            |
| Room geometry, zone lengths, box count and roles | **Fixed forever.**                                                                           |
| Floor grip                                       | µ 0.90. **Fixed.**                                                                           |

* **The obstacle itself is the random variable.** Parkour and Olympics keep their geometry fixed forever and randomise only friction and wind. Here the geometry _is_ what rotates: every round redraws all 196 sampled boxes — size, height, density, grip, yaw and position. What is stable is the _shape_ of the room — 48 m long, 6 m wide, the same zones, the same 100/60/36 role split — not a single box's location.
* **Grip is drawn independently of mass.** A light crate is not reliably the grippy one and a heavy one is not reliably the slippery one, so a policy cannot infer how well it can hold something from how hard it was to move. The floor is µ 0.90, so a crate is always the worse surface to stand on.
* Wind acts through MuJoCo's fluid model at air density 1.204 kg/m³, so drag scales with velocity relative to the air — and it acts on every box in flight or in the robot's grip, not only on the robot.
* Within a round, **every submission faces identical conditions**. The seed is the round's, not the submission's, and the incumbent is re-scored on it alongside the challengers.
* **The round seed is never published.** It is not in your observations, not in your reset call, not in your result, and not in your history files. Post-round you are given the field you actually ran against — every box's position, size, density, grip and zone — because you need to know what you were scored on. You are not given the value that generated it, and you cannot derive the next round's field from the one you were shown.
* Because the field moves, **absolute scores are only comparable within a round.**

**The Room**

48 m long, 6 m wide, on a deck 0.8 m above the floor. West to east:

| Zone            | Extent      | Boxes                 | Skill tested                                                              |
| --------------- | ----------- | --------------------- | ------------------------------------------------------------------------- |
| Start apron     | 0 – 8 m     | none                  | settle into gait                                                          |
| Mixed field     | 8 – 45 m    | 100 scramble, 60 push | weaving through clutter, shoving crates aside, and carrying them          |
| Climb zone      | 24 – 45 m   | 36, in 1–2 tier piles | mounting footing too tall for a single step-up                            |
| Leap chain      | 42.7 – 47 m | 3 fixed beams         | an optional route: three 0.90 m beams, 1.05 m apart edge to edge          |
| Finish platform | 47 – 48 m   | —                     | **1.6 m above the deck** — reaching x = 48 m on the floor is not a finish |

**199 boxes every round**: 196 sampled by role, plus the 3 fixed leap beams. The count and the role split are deterministic so a round's difficulty shape is stable; only each box's properties are drawn. A rejection-sampling placement pass keeps boxes from spawning interpenetrating.

Boxes are **free bodies**, not welded scenery. MuJoCo derives each one's mass from its sampled density and volume, so pushing, lifting, stacking and climbing are contact-solver outcomes rather than scripted animations. The robot masses 38.2 kg. Measured across 20 round seeds:

| Role                          | Side              | Height                 | Density           | Mass            |
| ----------------------------- | ----------------- | ---------------------- | ----------------- | --------------- |
| Scramble (clutter)            | 0.28 – 0.85 m     | 0.22 – 0.60 m          | 60 – 390 kg/m³    | 1.1 – 102 kg    |
| **Push (the building block)** | **0.55 – 0.95 m** | **0.30 – 0.45 m**      | **18 – 45 kg/m³** | **1.7 – 18 kg** |
| Climb (footing)               | 0.60 – 1.95 m     | 0.39 – 0.79 m per tier | 526 – 2097 kg/m³  | 141 – 2730 kg   |
| Leap beam (fixed, ×3)         | 0.84 × 0.50 m     | 0.90 m top             | 1313 kg/m³        | 496 kg each     |

* **There are two routes up, and both are meant to be hard.** Stack push crates against the platform edge — they are roughly 0.40 m tall, so four of them make the 1.6 m — or take the leap chain, three beams at 0.90 m with 1.05 m gaps, which is a committing standing jump rather than a free pass.
* Climb piles are deliberately immovable: at 141–2730 kg against a 38 kg robot they are footing, not cargo. Push crates are the only thing in the room light enough to carry.
* The robot has **no fingers** — a five-joint arm ending in a fused hand — so a crate is held by pinching it between two palms and relying on friction. The µ 0.40 floor of the grip band is set by what that pinch needs to hold a median crate at arm's length.

**Step by Step**

At each of the 50 Hz control steps, the miner's policy receives a **136-float observation**, in the robot's yaw frame:

* Proprioception: projected gravity, base angular and linear velocity, 22 joint angles and velocities, previous action.
* Task: gait clock (sin/cos of a 0.8 s cycle), heading, cross-track offset, distance to the finish, pelvis height above the surface below.
* Terrain: a 9 × 5 height scan (45 rays) from 0.4 m behind to 1.6 m ahead, 7 overhead-clearance samples out to 1.8 m, and **one proximity ray per hand** out to 1 m.
  * The scan reports whatever is directly below each ray — floor or box top, whichever is higher. There is **no "this is a box" channel, no zone identity, and no box manifest.** A pile reads as a tall step; a scramble cluster reads as broken, closely-spaced bumps.
  * The hand rays return plain distance to the nearest surface, not a labelled contact flag, for the same reason.
* The policy returns **22 floats**: joint position targets as offsets from the default pose, driven by a PD loop. This is a position target, **not** a torque.
* The policy also threads an opaque **256-float recurrent state**, zeroed at the start of every instance. Wind is unobservable, and so is box _history_ — whether a crate has already been shoved clear, or whether the robot is mid-climb on a stack it built — so remembering what you just did to the world is the only way to act on it.

Physics runs at 500 Hz (2 ms), ten substeps per control action.

**Constraints**

* Termination gates, each surfaced to the miner as a `terminal_reason`:
  * `completed` — the pelvis passes x = 48 m **and** is at platform height. Distance alone is not a finish.
  * `fell` — pelvis drops below 0.45 m of clearance above the surface below it, or the torso tilts past \~66°.
  * `out_of_bounds` — |y| exceeds 3 m, the room's half-width. No walking around the room through a wall.
  * `physics_glitch` — NaN/Inf state or |qvel| > 100. Glitch-surfing scores 0.
  * `timeout` — the 2,000-step budget elapsed.
  * `time_limit` — the evaluation's wall-clock budget, shared equally across the instances still to run, reached this instance first.
* Episode length: **2,000** control steps per instance, at most 24,000 control calls for a full suite.
* Timeouts:
  * Per-`/act` deadline = 500 ms.
  * Referee (scorer) timeout = 900 seconds for the whole 12-instance suite, with an internal 700-second scheduling budget so a result is always persisted.
  * Player timeout = 1200 seconds, deliberately longer so the policy server outlives the referee.

**Scoring**

Every instance returns a bounded score. Reaching the platform scores above 1.0; everything else scores the fraction of the room crossed.

```
  completed                                      1.0 + (max_steps - steps) / max_steps  -> (1.0, 2.0]
  fell / timeout / out_of_bounds / time_limit    progress                               -> [0.0, 1.0)
  physics glitch / invalid action / player fault 0.0

  Where progress is the furthest point reached, as a fraction of the start line to the finish.
```

* **Progress is continuous along the room**, regardless of which zone the robot is in. A policy that gets 2 m further into the clutter scores 2 m better even without clearing it, so the climb toward a first completion is measurable the whole way.
* **`time_limit` is scored on progress, not zeroed.** It is the one terminal reason a submission does not cause — the referee's clock ran out, which depends on what else was sharing the machine. Zeroing it would let contention decide the score, and would hit the best runs hardest, since a policy that survives longer is the one that consumes the clock.
* A foul the submission _does_ cause — an invalid action, a policy that stops answering, a run that leaves the physical regime — earns exactly nothing.
* The round result is the mean over the 12 instances:

```
raw_score = mean(instance_score[0..11])
```

* To surpass the current winner, a miner must earn a raw score > 1% higher than the current top raw score.
  * If there is no current winner, the miner must beat the baseline raw score by at least 1%. `baseline_raw_score` is **0.0** by design, so round 1 goes to anything scoring above zero.
* At the start of each round the incumbent is automatically re-submitted and re-scored, so the comparison is always like-for-like. **This is what makes a per-round box field safe.** The incumbent's stored score from an easier field is never what a challenger has to beat: both are scored on the same round seed, so the draw is common-mode in the comparison.
* The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.

#### **Miner Submissions**

* Miners submit a single **ONNX graph** with this exact tensor signature:
  * inputs — `obs [batch, 136]`, `state_in [batch, 256]`
  * outputs — `action [batch, 22]`, `state_out [batch, 256]`
  * all `float32`
* The **architecture is not constrained**; only the signature is. A feed-forward policy can ignore `state_in` and return zeros, but will struggle with unobservable wind and with a world it is changing as it goes.
* Maximum submission size: **15 MB**.
* Evaluation runs on **2 CPU / 1.5 GiB / no GPU**.
* Default round length: **2 days**.
* Submission fee: **$20 USD**.
* Miners' models are revealed **2 days** after evaluation.
* 1% `raw_score` threshold to beat the current top scorer.
* Logs are opened after the current round is completed. Every one of the 12 instances also produces a replayable history file, delivered to the miner post-round — the robot's full trajectory plus the pose of every box that moved, so a run can be replayed exactly.
* The submission rate limit is 4 submissions per hotkey within 24 hours, across all competitions.
* The full environment — the room, the box sampler, physics, scoring, and the history format — is public at [apex-competition-humanoid-scramble](https://github.com/macrocosm-os/apex-competition-humanoid-scramble). Train against the real referee, not a reimplementation.
* Local tools in that repo: `tools/local_eval.py` scores a policy in-process, `tools/preview.py` renders or films a round's field from a seed, and `tools/replay.py` films a recorded run. `python -m env.course --seed N` prints any round's box layout.
