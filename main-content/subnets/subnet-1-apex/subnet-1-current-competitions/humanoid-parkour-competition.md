---
description: Physics-simulated legged locomotion and obstacle traversal
---

# Humanoid Parkour Competition

**Legged locomotion over rough terrain** is one of the hardest open problems in robotics: a biped has to stay upright while climbing, dropping, leaping and balancing, on surfaces whose grip it cannot see and against disturbances it cannot predict. Traditional controllers are hand-tuned per obstacle; learned policies have to generalise.

The Humanoid Parkour competition challenges miners to drive a **Unitree G1** humanoid through a 51 m obstacle course in simulation. Miners submit a trained ONNX locomotion policy that outputs joint targets at 50 Hz. The course geometry is fixed and public, but every evaluation instance draws its own surface friction and wind from a per-round seed — and **neither is observable**. A policy has to feel the slip or the push and adapt, which is why the interface carries recurrent state.

#### Evaluation Overview <a href="#evaluation" id="evaluation"></a>

Each evaluation runs the miner's policy across **24 course instances**. The course is identical in every instance; what changes is the conditions:

| Condition        | Range, drawn per instance                          |
| ---------------- | -------------------------------------------------- |
| Surface friction | µ ∈ \[0.35, 0.50] course-wide, ±8% per-slab jitter |
| Slick patch      | µ ∈ \[0.08, 0.14] (near-ice → wet tile)            |
| Wind speed       | 0–14 m/s, steady for the episode                   |
| Wind direction   | Uniform over the full circle, horizontal           |

* Friction is drawn **once per instance** and applied to the whole course, so a run happens on one surface family rather than a patchwork.
* Wind acts through MuJoCo's fluid model at air density 1.204 kg/m³, so drag scales with the robot's velocity relative to the air — a headwind costs more than a tailwind.
* 14 m/s is Beaufort 7 measured _at the robot_, worth 35.1 N of drag against the G1's 315 N weight (11.1% of body weight).
* Each round's evaluation set is seeded to ensure determinism.
  * This seed changes from round to round, so a memorised suite is worthless.

**The Course**

51.14 m, one fixed layout, 1.68 m of vertical range:

| Obstacle     | Detail                                                          |
| ------------ | --------------------------------------------------------------- |
| On-ramp      | 15.38° incline, then a sheer 0.55 m drop                        |
| Stairs up    | 5 steps, 0.20 m rise                                            |
| Void leap    | 1.0 m gap — a real hole in the deck, so a missed leap is a fall |
| Drop-down    | 0.6 m                                                           |
| Hurdle       | 0.62 m barrier to step over (the robot has no usable arms)      |
| Step-up      | 0.55 m platform, then back down                                 |
| Duck-under   | Bar at 1.05 m, forcing a \~0.2 m squat-walk on a 1.26 m robot   |
| Balance beam | 3.5 m long, 0.32 m wide                                         |
| Slick patch  | 3.0 m of the lowest-friction surface in the round               |
| Stairs down  | 6 steps, 0.18 m drop                                            |

**Step by Step**

At each of the 50 Hz control steps, the miner's policy receives a **104-float observation**, in the robot's yaw frame:

* Proprioception: projected gravity, base angular and linear velocity, 12 joint angles and velocities, previous action.
* Task: gait clock (sin/cos of a 0.8 s cycle), heading error, lateral offset, distance to the finish line, pelvis height above the surface below.
* Terrain: a 9 × 5 height scan (45 rays) of walkable surface height relative to the pelvis, plus 7 overhead-clearance samples ahead.
  * Downward channels report **walkable surfaces only** — the duck bar appears in the overhead channels and nowhere else.
* The policy returns **12 floats**: joint position targets as offsets from the default pose, driven by a PD loop. This is a position target, **not** a torque.
* The policy also threads an opaque **256-float recurrent state**, zeroed on reset. Friction and wind are not in the observation, so remembering that you just slipped is the only way to adapt.

**Constraints**

* Termination gates, each surfaced to the miner as a `terminal_reason`:
  * `completed` — pelvis past the finish line.
  * `fell` — pelvis drops below 0.45 m of clearance above the surface below it, or the torso tilts past \~66°.
  * `out_of_bounds` — lateral offset |y| > 1.2 m. No walking around the course.
  * `physics_glitch` — NaN/Inf state or |qvel| > 100. Glitch-surfing scores 0.
  * `timeout` — the step budget elapsed.
* Episode length: up to **3000 control steps** per instance (60 s of simulated time).
* Timeouts:
  * Per-`/act` deadline = 500 ms.
  * Referee (scorer) timeout = 900 seconds for the whole 24-instance suite.
  * Player timeout = 1200 seconds, deliberately longer so the policy server outlives the referee.

**Scoring**

Per instance, higher is better:

```
  completed                         1.0 + (max_steps - steps) / max_steps   -> (1.0, 2.0]
  fell / timeout / out_of_bounds    progress (fraction of course covered)   -> [0.0, 1.0)
  physics_glitch / invalid action   0.0

  Where progress is the furthest distance reached, as a fraction of 51.14 m.
```

* Any completion outranks any non-completion, and faster completions outrank slower ones.
* Partial progress scores, so a policy that does not finish still gets a training gradient and a meaningful ranking.
* The miner's `raw_score` is the **mean across all 24 instances**.
* To surpass the current winner, a miner must earn a raw score > 1% higher than the current top raw score.
  * If there is no current winner, the miner must beat the baseline raw score by at least 1%. `baseline_raw_score` is **0.0** by design, so round 1 goes to anything scoring above zero.
* At the start of each round the incumbent is automatically re-submitted and re-scored on the new round's conditions, so the comparison is always like-for-like.
* The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.

**Miner Submissions**

* Miners submit a single **ONNX graph** with this exact tensor signature:
  * inputs — `obs [batch, 104]`, `state_in [batch, 256]`
  * outputs — `action [batch, 12]`, `state_out [batch, 256]`
  * all `float32`
* The **architecture is not constrained**; only the signature is. A feed-forward policy can ignore `state_in` and return zeros, but will struggle to adapt to unobservable conditions.
* Maximum submission size: **15 MB**. This is a compute limit as well as a storage one — inference cost is linear in artifact size, and the cap pairs with the 3000-step episode to keep the worst case inside the referee's 900 s timeout.
* Default round length: **2 days**.
* Submission Fee: $20 USD.
* 1% `raw_score` threshold to beat current top scorer.
* Miners' models are revealed **1 day** after evaluation.
* Logs are opened after the current round is completed. Each instance also produces a replayable history file, delivered to the miner post-round.
* The submission rate limit is 4 submissions per hotkey within 24 hours, across all competitions.
* The full environment — course, physics, scoring, and a reference baseline policy — is public at [apex-competition-humanoid-parkour](https://github.com/macrocosm-os/apex-competition-humanoid-parkour). Train against the real referee, not a reimplementation.
* Local tools in that repo: `tools/local_eval.py` scores a policy against the course in-process, `tools/preview.py` renders the layout, and `tools/replay.py` films a recorded run.
