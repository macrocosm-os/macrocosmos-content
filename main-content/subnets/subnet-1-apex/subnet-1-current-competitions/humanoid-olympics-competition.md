# Humanoid Olympics Competition

## Humanoid Olympics Competition

**Athletics is a breadth test.** A sprinter that cannot corner, a hurdler that cannot jump, or a jumper that cannot run are all narrow controllers; a real athlete is one body under one policy across every discipline. Learned locomotion is usually trained per skill, and the specialisation shows the moment the task changes.

The Humanoid Olympics competition challenges miners to enter a **Unitree G1** humanoid into a six-discipline meet in simulation — sprints, hurdles, and jumps — with **one** submitted policy. Miners submit a trained ONNX controller that outputs joint targets at 50 Hz. The robot has twelve actuated leg joints; its arms and upper body are mass and collision geometry, but are **not actuated**, so every event is solved with the legs. The event geometry is fixed and public, but each attempt runs under its own surface friction and wind, and **neither is observable**. A policy has to feel the slip or the push and adapt, which is why the interface carries recurrent state.

### Evaluation Overview <a href="#evaluation" id="evaluation"></a>

Each evaluation runs the miner's policy through a full meet: **four attempts of each of the six events, 24 attempts in total**. Every attempt draws a different point on the same public condition lattice:

| Condition        | Range across the meet                                              |
| ---------------- | ------------------------------------------------------------------ |
| Surface friction | µ ∈ \[0.30, 1.25], one stratum per attempt, ±0.076 per-slab jitter |
| Wind speed       | 0.1–7.4 m/s, steady for the attempt                                |
| Wind direction   | Uniform over the full circle, horizontal                           |
| High-jump bar    | 1.00, 1.10, 1.20, 1.30 m above the deck — one per attempt          |

* Every event samples **four friction strata** spanning the band, so a policy sees near-full grip and a genuinely slippery track within the same meet. Friction is drawn once per attempt and applied to the whole route, with a small per-slab jitter.
* Wind acts through MuJoCo's fluid model at air density 1.204 kg/m³, so drag scales with the robot's velocity relative to the air — a headwind costs more than a tailwind, and it costs disproportionately more at the top of the wind band.
* The four strata are paired with **opposing wind directions**, so a lap or a runway is not systematically favoured.
* The launch meet is **fixed and public**: the same 24 conditions repeat every round, for every submission. The platform round seed is part of the request contract but is deliberately score-neutral in v0.1, which is what makes the absolute score comparable across rounds.

### **The Events**

Six disciplines, equally weighted. All routes are a **1.7 m lane** on a raised deck 0.8 m above the floor — the floor is visible to the terrain scan and to the renderer, but is never a support, so a gap is a real fall.

| Event                 | Layout                                                                               | Skill tested                               |
| --------------------- | ------------------------------------------------------------------------------------ | ------------------------------------------ |
| 100 m sprint          | Straight lane, finish at 100 m, 24 s cap (≈4.25 m/s average)                         | acceleration and top speed                 |
| 400 m circular sprint | A true 400 m circle, radius ≈63.66 m, 72 s cap (≈5.56 m/s average)                   | sustained pace, route following, cornering |
| 100 m hurdles         | 10 barriers 8.5 m apart from 12 m to 88.5 m, rising 0.55 → 1.15 m, 38 s cap          | repeated clearance at speed                |
| High jump             | Runway, then a physical bar at 12 m, 1.00–1.30 m above the deck, 18 s cap            | one clean vertical clearance and crossing  |
| Long jump             | Runway, 0.40 m take-off board at 15 m, a **6 m real void**, sand from 21 m, 20 s cap | approach, take-off, flight, safe landing   |
| Triple jump           | Board at 12 m, hop pad 14.0–15.5 m, step pad 18.0–19.5 m, sand from 25 m, 28 s cap   | an ordered hop, step, and final landing    |

* The 400 m is a **genuine 400 m route**, not a scaled lap. Progress is accumulated forward route distance around the circle, and the lap only completes after 400 m travelled inside the lane, so cornering is part of the task rather than something to be cut.
* The hurdles form a within-run curriculum: the first barrier is a step, the last is at the frontier of what a legs-only G1 should clear at speed. Each hurdle overhangs the lane, so it cannot be skimmed around the end.
* The triple jump's gaps are real: 1.95 m from the board to the hop pad, 2.5 m from hop to step, and 5.5 m from step to sand.
* Throwing events and the pole vault intentionally belong to a future competition — they need arms.

### **Step by Step**

At each of the 50 Hz control steps, the miner's policy receives a **104-float observation**, in the robot's yaw frame:

* Proprioception: projected gravity, base angular and linear velocity, 12 joint angles and velocities, previous action.
* Task: gait clock (sin/cos of a 0.8 s cycle), heading error against the **route tangent**, signed cross-track offset, distance remaining, pelvis height above the surface below.
* Terrain: a 9 × 5 height scan (45 rays) reaching **6 m ahead**, plus 7 overhead-clearance samples out to 4 m.
  * Downward channels report **walkable surfaces only** — the high-jump bar and the hurdles appear in the overhead channels and nowhere else.
  * The 6 m horizon is deliberate: at 6 m/s the inherited 1.6 m scan was only a quarter of a second of warning, which is not enough to set up a hurdle or a take-off.
* The policy returns **12 floats**: joint position targets as offsets from the default pose, driven by a PD loop. This is a position target, **not** a torque.
* The policy also threads an opaque **256-float recurrent state**, zeroed at the start of every attempt. Friction and wind are not in the observation, so remembering that you just slipped is the only way to adapt.

Physics runs at 500 Hz (2 ms), ten substeps per control action. Every legality gate — lane boundary, hurdle and bar contact, take-off, flight, and landing — is sampled at **each physics substep**, not once per action, so a fast scrape cannot slip between control frames.

### **Constraints**

* Termination gates shared by all events, each surfaced to the miner as a `terminal_reason`:
  * `fell` — pelvis drops below 0.45 m of clearance above the surface below it, or the torso tilts past \~66°.
  * `out_of_bounds` — cross-track offset from the route centreline exceeds **0.85 m**, half the lane width. No running around the obstacles.
  * `physics_glitch` — NaN/Inf state or |qvel| > 100. Glitch-surfing scores 0.
  * `timeout` — the event's step budget elapsed.
* Event-specific outcomes:
  * Races: `completed` at the finish line; `hurdle_hit` if the robot touches any barrier.
  * High jump: `cleared` requires the pelvis to cross the bar plane at least 0.08 m above the bar after both feet have been unsupported for 40 ms, without touching the bar, followed by a supported landing 0.75 m past it. Otherwise `bar_hit`, `bar_missed`, or `high_foul`.
  * Long and triple jump: `landed` requires a one-foot take-off from the 0.40 m board (0.35 m before the line to 0.05 m after), a real flight, and sustained first foot support on sand. Triple jump additionally requires a same-foot hop landing and an opposite-foot step landing, in order, each with its own flight. Anything else — a side scrape, a non-foot contact, a premature pad contact, a body-first landing, overrunning the board — is a `jump_foul`.
  * Only **top-face foot contacts** count as support, classified by contact normal and impulse. Landing distance is latched from the first legal sand contact point, not from a later pose.
* Episode length, per attempt: **1,200** control steps for the 100 m, **3,600** for the 400 m, **1,900** for the hurdles, **900** for the high jump, **1,000** for the long jump, and **1,400** for the triple jump — at most 40,000 control calls for a full meet.
* Timeouts:
  * Per-`/act` deadline = 500 ms.
  * Referee (scorer) timeout = 900 seconds for the whole 24-attempt meet, with an internal 840-second scheduling budget so a result is always persisted. Any attempt that the budget does not reach is retained as a zero-scored row in the fixed denominator.
  * Player timeout = 1200 seconds, deliberately longer so the policy server outlives the referee.

### **Scoring**

Every attempt returns a bounded score in `[0, 1]`. A completed attempt scores from **0.25** upward; an incomplete attempt stays **below 0.25**, so no amount of partial progress can outrank a legal finish.

```
  races (100 m, 400 m, hurdles)
    completed                      0.25 + 0.75 * (1 - steps / max_steps)   -> (0.25, 1.0]
    fell / timeout / hurdle hit    0.24 * progress                         -> [0.0, 0.24]

  high jump
    cleared                        0.25 + 0.75 * (bar - 1.00) / 0.30       -> [0.25, 1.0]
    bar hit / missed / fell        0.24 * best_clearance / bar             -> [0.0, 0.24]

  long jump / triple jump
    landed                         0.25 + 0.75 * (distance - min) / (target - min)
                                     long jump    min  6 m, target 12 m
                                     triple jump  min 13 m, target 18 m
    no legal landing               0.20 * progress                         -> [0.0, 0.20]

  foul, out of bounds, physics glitch, invalid action, player fault    0.0

  Where progress is the furthest route distance reached, as a fraction of the event's finish.
```

* Quality within a legal result is **pace** for races, **selected bar height** for the high jump, and **legal distance** for the horizontal jumps.
* Partial progress still scores, so a policy that does not finish an event gets a training gradient and a meaningful ranking — but a foul does not. Invalid contacts earn exactly nothing.
* The round result is the **mean of the six event means**, each event mean taken over its four attempts:

```
raw_score = mean(event_mean[100m, 400m, hurdles, high jump, long jump, triple jump])
```

* Macro-averaging is what keeps the meet balanced: the 400 m has three times the steps of the high jump but exactly the same weight, so a policy cannot buy a rank with one long event.
* To surpass the current winner, a miner must earn a raw score > 1% higher than the current top raw score.
  * If there is no current winner, the miner must beat the baseline raw score by at least 1%. `baseline_raw_score` is **0.0** by design, so round 1 goes to anything scoring above zero.
* At the start of each round the incumbent is automatically re-submitted and re-scored, so the comparison is always like-for-like.
* The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.

The launch preset is deliberately severe — a 24 s 100 m, a 72 s circular 400 m, hurdles to 1.15 m, bars to 1.30 m, a 6 m long-jump void. **A first complete all-round performance is intended to be a meaningful breakthrough**, and partial credit exists so that the climb toward it is measurable.

### **Miner Submissions**

* Miners submit a single **ONNX graph** with this exact tensor signature:
  * inputs — `obs [batch, 104]`, `state_in [batch, 256]`
  * outputs — `action [batch, 12]`, `state_out [batch, 256]`
  * all `float32`
* The **architecture is not constrained**; only the signature is. A feed-forward policy can ignore `state_in` and return zeros, but will struggle to adapt to unobservable friction and wind.
* Maximum submission size: **15 MB**. This is a compute limit as well as a storage one — inference cost is linear in artifact size, and the cap pairs with the 40,000-call meet to keep the worst case inside the referee's 900 s timeout.
* Evaluation runs on **2 CPU / 2 GiB / no GPU**.
* Default round length: **2 days**.
* 1% `raw_score` threshold to beat the current top scorer.
* Miners' models are revealed **5 days** after evaluation — longer than a round, so a copy cannot be turned around inside the window it was learned in.
* Logs are opened after the current round is completed. Every one of the 24 attempts also produces a replayable history file, delivered to the miner post-round.
* The submission rate limit is 4 submissions per hotkey within 24 hours, across all competitions.
* The full environment — all six events, physics, scoring, and a reference baseline policy — is public at [apex-competition-humanoid-olympics](https://github.com/macrocosm-os/apex-competition-humanoid-olympics). Train against the real referee, not a reimplementation.
* Local tools in that repo: `tools/local_eval.py` scores a policy across the meet in-process, `tools/preview.py` renders or films a single event, and `tools/replay.py` films a recorded run. A complete seed-1 baseline meet is committed under `docs/example-histories/` as a worked example.
