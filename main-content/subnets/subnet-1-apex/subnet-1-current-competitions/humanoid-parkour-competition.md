---
description: Physics-simulated legged locomotion and obstacle traversal
---

# Humanoid Parkour Competition

### Humanoid Parkour Overview

Legged locomotion over irregular terrain is one of the hardest open problems in robotics. A wheeled robot needs a surface; a legged one needs a _policy_ — a controller that decides, fifty times a second, what every joint should do next, on ground it cannot fully see and under conditions it was never told about.

The Humanoid Parkour competition challenges miners to train a neural control policy that drives a simulated Unitree G1 humanoid down a 51 m obstacle course in MuJoCo. Miners train on their own hardware and submit the trained policy as an ONNX graph. The evaluator runs it in a sealed sandbox and measures how far down the course it gets — and, if it finishes, how fast. Every obstacle is a leg maneuver: the robot has 12 actuated leg joints and no arms, so there is no vaulting, no grabbing, and nothing to push out of the way.

### The Robot

|              |                                                                           |
| ------------ | ------------------------------------------------------------------------- |
| Platform     | Unitree G1, 32.1 kg, standing 1.26 m                                      |
| Actuated DoF | 12 — per leg: hip pitch, hip roll, hip yaw, knee, ankle pitch, ankle roll |
| Upper body   | Welded — **no arms**                                                      |
| Control rate | 50 Hz (one control step = 20 ms of simulated time)                        |
| Physics      | MuJoCo, 2 ms timestep, 10 substeps per control step                       |

### Evaluation Overview

Each evaluation runs the miner's policy across **24 course instances**. Every instance is the same course geometry under different physical conditions, drawn from the round seed:

| Property                       | Range                                         | Observable? |
| ------------------------------ | --------------------------------------------- | ----------- |
| Sliding friction (course-wide) | µ ∈ \[0.50, 1.25], smooth tile → dry concrete | **No**      |
| Per-slab friction jitter       | ±8% of the band, independently per slab       | **No**      |
| Slick-patch friction           | µ ∈ \[0.12, 0.30], wet tile → near-ice        | **No**      |
| Wind speed                     | 0 – 8 m/s, steady for the whole episode       | **No**      |
| Wind direction                 | any horizontal bearing                        | **No**      |
| Episode length cap             | 3,000 control steps (60 s of simulated time)  | —           |

Conditions are drawn **at random per instance from the round seed**, not from a fixed stratified sweep. The course geometry is static and public, so a fixed suite would be reproducible offline bit-for-bit and the cheapest route to the top would be memorizing 24 known instances. A per-round draw makes that worthless. The cost is score noise, and that noise is what sets the takeover margin.

Instance `i` gets the same conditions whatever the suite size, so raising the instance count extends the suite rather than reshuffling it.

**Nothing about friction or wind appears in the observation.** A policy has to infer the surface and the crosswind from how the robot responds and adapt online — which is what the 256-float recurrent state is for.

### The Course

51.1 m, linear, traversed in one direction. Heights are the walking surface above the world floor.

| #  | Segment              | Length | Detail                                               |
| -- | -------------------- | ------ | ---------------------------------------------------- |
| 1  | Run-up               | 6.0 m  | flat, at 0.80 m — lets a walker settle into gait     |
| 2  | On-ramp              | 2.0 m  | climbs 0.55 m (15.4°)                                |
| 3  | Landing              | 1.6 m  | flat, at 1.35 m                                      |
| 4  | **Drop-down**        | —      | sheer 0.55 m edge, no ramp down                      |
| 5  | Flat                 | 6.4 m  | recovery and approach                                |
| 6  | **Stairs up**        | 1.6 m  | 5 steps, 0.20 m rise × 0.32 m run                    |
| 7  | Flat                 | 1.6 m  | approach                                             |
| 8  | **Leap**             | 1.0 m  | a real void — no slab at all                         |
| 9  | Flat                 | 2.2 m  | at 1.80 m                                            |
| 10 | **Drop-down**        | —      | sheer 0.60 m edge                                    |
| 11 | Flat                 | 2.4 m  | at 1.20 m                                            |
| 12 | **Hurdle**           | 1.0 m  | 0.62 m barrier — must be stepped over, not vaulted   |
| 13 | Flat                 | 2.0 m  | approach                                             |
| 14 | **Step-up**          | 2.2 m  | 0.55 m single-leg press onto a platform              |
| 15 | Platform + step-down | 1.2 m  | and back down 0.55 m                                 |
| 16 | Flat                 | 2.0 m  | approach                                             |
| 17 | **Duck-under**       | 2.0 m  | overhead bar at 1.05 m — forces a \~0.2 m squat-walk |
| 18 | Flat                 | 1.6 m  | approach                                             |
| 19 | **Balance beam**     | 3.5 m  | 0.32 m wide (vs. a 2.4 m wide track)                 |
| 20 | Flat                 | 1.8 m  | approach                                             |
| 21 | **Slick patch**      | 3.0 m  | same geometry, µ ∈ \[0.12, 0.30]                     |
| 22 | **Stairs down**      | 2.04 m | 6 steps, 0.18 m rise × 0.34 m run                    |
| 23 | Final sprint         | 4.0 m  | flat, at 0.12 m, to the line                         |

Both tall obstacles are sized against measured leg capability, not against a robot with hands. The hurdle is 79% of hip height, inside the leg's 1.30 m kinematic reach. The step-up needs roughly 31–63 N·m at the knee against a 139 N·m limit, so it is a torque-feasible press.

The on-ramp is deliberately the easy tier: the stock G1 walker climbs 15.4° but stalls at 20.1°, so a naive walking policy should clear the ramp and nothing beyond it. Because the course is linear and scored on progress, that gradient replaces separate difficulty tiers.

### Step by Step

Each control step, the policy receives a **104-float observation** and a **256-float recurrent state**, and returns 12 joint targets plus the next state.

The observation, in order:

| Indices | Channel                                                                                                             | Count |
| ------- | ------------------------------------------------------------------------------------------------------------------- | ----- |
| 0–2     | Projected gravity in the pelvis frame (which way is down)                                                           | 3     |
| 3–5     | Base angular velocity, body frame, ×0.25                                                                            | 3     |
| 6–8     | Base linear velocity, body frame, ×2.0                                                                              | 3     |
| 9–20    | Joint angles, as offsets from the default pose                                                                      | 12    |
| 21–32   | Joint velocities, ×0.05                                                                                             | 12    |
| 33–44   | The policy's own previous action                                                                                    | 12    |
| 45–46   | Gait clock, sin/cos of an 0.8 s phase                                                                               | 2     |
| 47–48   | Base heading, sin/cos of yaw                                                                                        | 2     |
| 49      | Lateral offset from the track centreline (m)                                                                        | 1     |
| 50      | Distance remaining to the finish, ÷10                                                                               | 1     |
| 51      | Pelvis height above the surface directly below                                                                      | 1     |
| 52–96   | Height scan: 9 × 5 downward rays, −0.4 to +1.6 m ahead, ±0.5 m across, relative to the pelvis, saturating at ±1.0 m | 45    |
| 97–103  | Overhead clearance: 7 upward rays, 0 to 1.8 m ahead, saturating at 1.0 m                                            | 7     |

The action is 12 joint position targets, expressed as offsets from the default pose, scaled by 0.25 and clipped to the joint limits.

**There is no obstacle oracle.** No channel announces "a leap starts in 1.2 m" and no segment identifier is exposed. The height scan and the overhead rays are the only forward-looking perception — a policy must read the terrain the way the robot does.

`state_in` / `state_out` are your own opaque per-episode memory: zeroed on reset, fed back each step. A feed-forward policy ignores `state_in` and returns zeros.

### Constraints

An episode ends the moment any of these fires:

| Terminal         | Condition                                                                             |
| ---------------- | ------------------------------------------------------------------------------------- |
| `completed`      | pelvis crosses the 51.1 m finish line                                                 |
| `fell`           | pelvis drops within 0.45 m of the surface below it, **or** the torso tilts past \~66° |
| `out_of_bounds`  | lateral offset exceeds ±1.2 m — off the side of the track                             |
| `timeout`        | the 3,000-step cap is reached                                                         |
| `physics_glitch` | any non-finite state, or any joint velocity above 100 rad/s                           |
| `invalid_action` | the returned action is the wrong shape, or non-finite                                 |

Timeouts:

* **Per-step deadline: 500 ms** per `/act` call.
* **Total evaluation timeout: 900 seconds** for all 24 instances.

Resource limits per sandbox: **2 CPU, 1.5 GiB memory**, no GPU and no network.

### Scoring

Each instance is scored on how far the robot got, with a speed bonus reserved for finishers:

| Outcome                                            | Instance score                                                  |
| -------------------------------------------------- | --------------------------------------------------------------- |
| `completed`                                        | `1.0 + (max_steps − steps) / max_steps` → in (1.0, 2.0]         |
| `fell` / `timeout` / `out_of_bounds`               | `progress`, the fraction of the course covered → in \[0.0, 1.0) |
| `physics_glitch` / `invalid_action` / player error | `0.0`                                                           |

The banding is deliberate: **any** completion outranks **any** non-completion, faster completions outrank slower ones, and partial progress still gives a non-completing policy a usable gradient to train against.

The submission's `eval_raw_score` is the **mean instance score across all 24 instances**.

For reference, the reference walking baseline scores a raw score of about **0.215** — it clears the run-up and the on-ramp and goes down at the drop, covering roughly a fifth of the course. Because conditions are redrawn every round, that figure is itself a mean over seeds rather than a constant.

To surpass the current winner, a miner must earn a raw score more than 1% higher than the current top raw score. If there is no current winner, the miner must beat the baseline raw score by at least 1%. The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.

### Miner Submissions

Miners submit a single **ONNX graph** — the trained policy, exported from whatever framework they trained in.

|                         |                                                                 |
| ----------------------- | --------------------------------------------------------------- |
| Format                  | ONNX (`.onnx`), float32                                         |
| Interface               | `obs[104]` + `state_in[256]` → `action[12]` + `state_out[256]`  |
| Maximum submission size | **15 MB**                                                       |
| Protocol                | `gym_v1` HTTP — the evaluator calls `/health`, `/reset`, `/act` |
| Default round length    | 2 days                                                          |
| Code revealed after     | 5 days                                                          |
| Takeover threshold      | 1% above the current top raw score                              |
| Submission fee          | _$20 USD_                                                       |

* Submissions are screened at submit time: the graph must parse as ONNX, sit inside the size cap, and carry at least 10 KB of weights — which rejects near-empty graphs and constant policies.
* The rate limit is 4 submissions per hotkey within 24 hours, across all competitions.
* Logs are opened after the current round is completed.
* Trained policies carry real R\&D, so the reveal window is longer than most competitions'.

### Artifacts

Every evaluation produces two kinds of artifact, both attached to the submission and downloadable once the round completes:

| Artifact                                  | Contents                                                                                                                                                        |
| ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **24 history files** — `instance_NN.json` | the robot's full pose (`qpos`) and the policy's action at every recorded step, plus the friction and wind that instance was drawn with, and the terminal reason |
| **1 log file**                            | every API call between the player sandbox and the evaluator — one `apex.api` line per `reset` / `act`, with step index, deadline, latency and status            |

History files record every second control step by default, which is 25 Hz — above the \~30 fps a video is rendered at after stride selection, so replay quality is unaffected.

Poses are stored, not actions: replaying stored poses reproduces the graded run exactly, whereas re-simulating from an action log would drift. The actions are kept as diagnostics.

### Replay

`tools/replay.py` turns a history file back into something you can watch:

* **`film`** renders an offline MP4 from a fixed chase camera — works headless, no display needed.
* **`live`** opens an interactive MuJoCo viewer you can orbit and scrub (needs `mjpython` on macOS).

Both read either a single `instance_NN.json` or a whole directory of them, and print the conditions each instance was drawn under so a failure can be read against the surface and wind that caused it.

### Additional Details

* Course geometry, the observation layout, and the scoring bands all live in `env/` — `course.py`, `sim.py`, `scoring.py` — and are the same code the referee runs.
* `tools/local_eval.py` runs the full 24-instance suite locally against your own policy.
* `tools/make_baseline.py` and `tools/make_test_policy.py` produce reference submissions.
* `tools/preview.py` renders the course itself, with no policy attached.
* Design rationale — why these obstacles, why randomized conditions, why these bands — is in `docs/design.md`.
* The player sandbox runs Python 3.12 with `numpy==2.3.4` and `onnxruntime==1.28.0`, pinned in `player/Dockerfile`. Export your graph at an IR version onnxruntime 1.28 accepts. The sandbox has no network access and no GPU.
* The evaluator runs `mujoco==3.11.0`. Train against that version — physics behaviour is not guaranteed identical across MuJoCo releases.
