# URNetwork Latency Competition

### URnetwork Latency Competition

**Latency is a selection problem.** URnetwork is a user-space network: your traffic leaves through someone else's device — a **provider** — and how quickly the stack finds, trusts and uses the right one is most of what separates a page that loads from a page that stalls. The code doing that work runs in production today, carrying live traffic.

The URnetwork Latency competition asks miners to make it faster. A submission is a **unified Git diff** against URnetwork's source on the measured connect path, scored by `sim-latency`: a fixed instrument that stands up the whole URnetwork stack — API, exchange, matchmaking, reliability pipeline, accounting, a deterministic fleet of impaired providers and a fake origin site — then drives seeded client traffic through the tunnel and times every request. Your patch changes the product code. It never changes the instrument or its scorer.

#### Evaluation Overview <a href="#evaluation" id="evaluation"></a>

Every submission is applied to the source commits frozen for its epoch, built offline into its own content-addressed image, and run against the same workload as every other submission that epoch.

| Item                | Value                                                                          |
| ------------------- | ------------------------------------------------------------------------------ |
| Evaluation host     | One 128 GiB-class Ubuntu machine, 12 isolated CPUs                             |
| Toolchain           | Go 1.27.3 — the compiler and runtime every submission is built and measured on |
| CPU boundary        | 10 evaluation CPUs; 2 reserved for management and cleanup                      |
| Provider fleet      | 3,600 providers, network impairment enabled                                    |
| Client load         | 200 client identities, 80 arrivals per minute                                  |
| Selection           | Quality window 2; 4 exchange hosts; 4 fleet shards                             |
| Measured window     | 180 seconds                                                                    |
| Aggregation         | 9 independently reset runs per candidate, median                               |
| Control sample      | One immutable 9-run control per epoch, shared by every submission              |
| Evaluation deadline | 3 hours end to end, including retries, scoring and cleanup                     |

The live evaluator publishes its frozen policy at [`/competition/info`](https://api.bringyour.com/competition/info): the fleet, load and margin under `evaluation_policy`, the editable paths under `patch_policy`, and the current epoch under `active_round`. If this page and that endpoint ever disagree, the endpoint is what scores your submission.

* The **hardware is deliberately modest, and everything shares it.** Services, the provider fleet, the client driver and your code all draw on the same 10 evaluation CPUs, so an algorithm that buys latency with heavy compute degrades its own measurement. CPU efficiency is priced into the metric rather than bolted on as a penalty.
* Iterating on a modern laptop will give you better absolute numbers than the evaluator reports. Only **relative** improvement transfers.
* The workload is seeded, so two runs of the same fleet file replay the same scenario. But sockets and timing behave the way they do on any busy machine, so runs are never bit-identical — which is why nine replicates and a statistical test both exist.
* The 3,600-provider point is the competition target. Larger configurations are development stress tests, not an alternative production scale.

**One Control Per Epoch**

Before the first submitted build of an epoch, the evaluator measures **one authenticated sample of nine control runs** on the unmodified code, freezes those exact bytes with their SHA-256, and compares every candidate that epoch against them.

This is a fairness property worth understanding. Measuring a fresh control alongside each submission would give every miner a different denominator, and with normal run-to-run variation two miners could end up ordered by whose control happened to be slower rather than whose patch was faster. One frozen control per epoch makes that variation common to everyone.

It also means an ordinary submission runs nine replicates rather than eighteen, which roughly halves evaluation time.

**The Measured Path**

Measurement does not start immediately. Warm-up connects the fleet, pre-establishes deterministic performance and reliability evidence, propagates selection state through the pipeline, and proves every client exit and parallel HTTP lane. Only then does the measured window open.

* Reliability gating in production takes roughly 8.4 hours of provider uptime before a provider becomes selectable. Warm-up short-circuits that history, so the competition measures **selection and egress among an established fleet**, not onboarding.
* Seeded churn and impairment schedules begin at the authenticated measurement boundary, so a slow warm-up cannot shift the workload.
* Each request produces one CSV row:

```
t_start_ms,client,path,depth,status,bytes,ttfb_ms,total_ms,bytes_per_s
```

* `status = 0` means the request did not complete correctly. A `200` is emitted only after the declared body arrives exactly — a truncated or mismatched body counts as a failure, not a fast success.

#### Scoring

For each replicate, the raw score is **p95 `total_ms`** over requests starting inside the measured window. Every failure and incomplete body is charged at the frozen request-timeout ceiling before the percentile is taken, so dropping hard requests can never shorten your tail. **Lower is better.**

**Ranking is by absolute median raw score, ascending**, then submission time, then job id. A normalized score is also published:

```
normalized_score = 100 * control_median / candidate_median   (clamped to 1–200)
```

so the control shows as 100 — but this is a display value and does **not** affect ranking.

A score is **placeable** only when all six gates pass:

| Gate | Checks                                                                                    |
| ---- | ----------------------------------------------------------------------------------------- |
| G1   | Correctness — request success rate and complete bodies                                    |
| G2   | Traffic volume — request count and received bytes each within 0.95–1.05× the control's    |
| G3   | Path integrity — provider egress accounting matches client bytes; no bypassing the tunnel |
| G4   | Matchmaking — selection samples present and matchmaking cost within budget                |
| G5   | Stability — no panics, restarts or unclean teardown in any replicate                      |
| G6   | Resources — the run stayed inside the CPU, memory and PID boundary                        |

A placeable submission is **takeover-eligible** only when all three of these also hold:

1. its median raw score sits at or below the epoch's improvement threshold relative to the control;
2. a **one-sided Welch test** over the run-level raw scores returns `p ≤ 0.05`; and
3. the winning variance supports a next-epoch threshold inside `(0%, 50%]`.

The highest-ranked takeover-eligible submission is named the epoch's winner automatically when results are published, and then reviewed. See Winner Selection and Review.

Every score records the control SHA-256, control and candidate means, sample variances, observed improvement, the current margin, the minimum statistically significant improvement, the Welch statistic, degrees of freedom and p-value, and the recommended next-epoch margin.

The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.

#### Epochs and the Moving Threshold

The season runs **six sequential epochs, each accepting submissions for seven days**. Epochs open and close automatically, and the next one opens on its own once the previous epoch's backlog has drained and the next source and control are prepared — so expect the season to run somewhat longer than six calendar weeks.

* Submissions are evaluated as they arrive, one at a time, and evaluation continues past an epoch's close until every accepted submission finishes.
* Accepting submissions and grading them are separate switches, shown under `runtime_status` in `/competition/info`. An epoch can accept submissions (`intake_ready: true`) before grading starts (`grading_ready: false`). Accepted submissions keep their place in the queue and are graded in arrival order once grading starts; there is no need to resubmit.
* **Epoch 1 requires a 26.9% improvement** (`takeover_margin: 0.269`). That number is calibrated rather than chosen: run-to-run noise on this workload is large enough that a smaller margin would let luck win. Nine replicates plus the Welch test are what bring the detectable improvement down that far.
* When URnetwork approves a winning patch for its codebase, the patch is promoted into the source commits for the following epoch and its measured variance sets that epoch's percentage — never weakening the incumbent margin. Improvements compound, and each epoch is measured against the previous winner's code.
* Approval for the codebase is a separate decision from winning (see below). Until a winning patch is approved, the following epoch runs on the same source and the same threshold.
* If nothing is takeover-eligible, or every eligible submission is disqualified in review, the epoch has **no winner** and both the source commits and the threshold carry forward unchanged.

**Winner Selection and Review**

**The winner is selected automatically.** When an epoch's results are published, URnetwork's evaluator names the highest-ranked takeover-eligible submission as the winner, and Apex promotes it to top scorer straight away. Nobody has to approve it first.

**Every winner is then reviewed by hand.** URnetwork, which sponsors and judges this competition, inspects the winning patch against six criteria — is this a genuine routing improvement, or an exploit of the measuring instrument? A winning patch must have:

1. no changes to `server/connect/sim-latency` or any trusted scoring or evaluator input;
2. no fabricated measurements, disabled checks, special-cased workload data, hidden-seed inference, input gaming or benchmark detection;
3. no filesystem, network, namespace, Docker-socket, host or secret escape;
4. no credential access or exfiltration path;
5. no unsafe behavior, persistence, denial of service or unrelated product change; and
6. a plausible causal connection between the allowed Go change and the measured improvement.

**A winner that fails any criterion has its winning position revoked.** The win passes to the next eligible submission in the original ranking, and if none remain, the epoch has no winner. Scores, ranks and eligibility never change in review — it only decides who holds the win. Because the review follows publication, a revocation can land after the winner has already been promoted.

Separately, URnetwork decides whether to merge the winning patch into its codebase. Winning, and passing review, do not by themselves promote a patch into the next epoch's source; that is its own approval.

The criteria are URnetwork's own, published in [RUN-MAIN.md](https://github.com/urnetwork/server/blob/main/connect/sim-latency/RUN-MAIN.md). Apex runs submission, fees, evaluation and publication, promotes whoever currently holds the win and reflects any revocation. It does not choose the winner and cannot overturn a review.

Scores, ranks, gates and diagnostics stay private until the epoch's results are published. While an epoch is open the Apex CLI will show that your submission has been accepted and is being evaluated, but not how it did — and an evaluation that finishes has only produced a private score, which is not the same as passing the gates or qualifying to win.

Closing an epoch stops new submissions; it does not publish results. Results are published once every accepted submission has finished evaluating, the evaluation is sealed and the reveal time has passed — not after review. At that point the leaderboard, detailed results, revealed seed and authenticated provider workload become public, so any run can be reproduced.

#### Constraints

* **Editable paths.** A patch may change existing regular files anywhere in the ten repositories of the epoch's source lock — `server`, `connect`, `sdk`, `proxy`, `glog`, `goidenticons`, `userwireguard`, `sn`, `warp` and `gvisor` — at any depth. The one exception is the competition runner, `server/connect/sim-latency/**`. The live list is `patch_policy` in `/competition/info`.
* **Paths start at the monorepo root** (`path_base: mono_root_v1`): every path begins with its repository's name. The resident-side active-contract manager, for example, is `server/connect/resident_contract_manager.go`; `connect/resident_contract_manager.go` would mean a file in the separate `connect` repository, which does not exist. From a checkout of one repository, `git diff --src-prefix=a/<repo>/ --dst-prefix=b/<repo>/ > submission.patch` writes these paths. To change more than one repository, concatenate each repository's diff in alphabetical order of repository name.
* **Structural rules.** New files, deletions, renames, copies, mode changes, build constraints, binary patches, symlinks and submodules are rejected before a build begins.
* **Canonical format.** Your patch is hashed exactly as submitted, with no normalization. It must be nonempty valid UTF-8 with no NUL bytes, **LF-only line endings**, no control characters other than newline and tab, file sections in sorted path order (one per file), and **exactly one trailing newline** with no extra blank line. Write the diff to a file and submit the file with the current Apex CLI. Shell command substitution (`patch=$(git diff ...)`) strips the trailing newline, and so do Apex CLI versions from before 27 October 2026.
* **No new dependencies.** Builds run offline against the frozen module set, on **Go 1.27.3**. Standard library and existing dependencies only — and anything that depends on a different compiler or runtime version will not behave the way it did on your machine.
* **The instrument is off-limits.** Beyond the forbidden runner path, a winning patch is reviewed against the criteria above: changing trusted scoring or evaluator inputs, or making unrelated product changes, costs the win.
* **No network.** Builds run offline, and at runtime your code reaches only the evaluator's own isolated service network — no external egress. It gets read-only configuration and credentials for the simulated environment, and nothing else: no host control material, no control-plane secrets, no Docker socket.
* Missing, malformed, OOM-killed or incomplete results fail closed: you get an error rather than a score.

#### Licensing

[`urnetwork/server`](https://github.com/urnetwork/server) is published under the **Mozilla Public License 2.0**, and a winning patch that URnetwork approves for its codebase is merged into it. By submitting, you license your patch under MPL-2.0 and confirm it is yours to contribute on those terms.

A merged patch becomes part of the public URnetwork codebase, keeps your authorship, and is redistributed under the same license as the file it changes. MPL-2.0 is file-level copyleft — it covers that file, not anything else you write. Only an approved winning patch is promoted into the source for the next epoch.

#### Miner Submissions

* Miners submit a single **unified Git diff** against the source commits frozen for the **current epoch**. The base commit moves whenever an approved winning patch is promoted, and stays put when it isn't — so check the base published for the current epoch before you start, rather than assuming either the previous epoch's or the season's opening commit still applies.
* Maximum submission size: **262,144 bytes**.
* Submission fee: **$20.00 USD**. Within the same epoch, resubmitting identical patch bytes reuses the existing evaluation and is not charged again. The same bytes in a _later_ epoch are a new submission — different source, different workload — and are charged.
* There is no cap on how many submissions an epoch will accept, but Apex rate-limits admissions to 4 submissions per hotkey in any 24-hour window, across all competitions.
* Epoch length: **7 days**, six epochs in the season. Each epoch opens automatically.
* Full scores, ranks and error detail are revealed when the epoch's results are published, not when it closes.
* The highest-ranked eligible submission is named winner automatically when results are published. URnetwork then reviews it by hand, and a winner found to have failed the competition criteria has its winning position revoked.

**Iterating Locally**

`sim-latency` is public and runs on a developer machine. It needs two terminals: the backing services stay in the foreground streaming logs, so they cannot share a shell with the simulator.

**Terminal 1** — leave this running:

```bash
cd server/local
./run-local.sh
```

**Terminal 2** — from a checkout matching a configured source epoch:

```bash
cd connect/sim-latency
./run-local.sh init \
  --count 500 --clients 100 --rate 40 --quality-window 2 \
  --seed 1 --out providers.yml
./run-local.sh run \
  --epoch 0 --reset --providers providers.yml \
  --meta results.run.json > results.csv
./run-local.sh analyze --run results.csv
```

Measured `run`, `fleet` and fresh `baseline` commands need a configured source epoch — use a clean epoch checkout rather than bypassing the identity check.

Size the local fleet to your machine; the 500-provider example above is a development workload, well below the official 3,600. A single local run is a diagnostic, not a score: only the official evaluator's frozen workload, nine-run candidate sample and shared epoch control produce a competition result.

The instrument, its scorer and the preserved calibration evidence are all public at [urnetwork/server](https://github.com/urnetwork/server/tree/main/connect/sim-latency). Start with the [README](https://github.com/urnetwork/server/blob/main/connect/sim-latency/README.md) for the scoring contract and [evaluator/PATCH-SURFACE.md](https://github.com/urnetwork/server/blob/main/connect/sim-latency/evaluator/PATCH-SURFACE.md) for the canonical patch format. Its single-file editable surface predates the season; the live `patch_policy` above is what applies.

**Where to Start Looking**

URnetwork has published a [research seed](https://github.com/urnetwork/server/blob/main/connect/sim-latency/2026-10-13-seed.md) mapping the architecture, performance and correctness work on the measured latency path over the two months to 13 October 2026 — which approaches paid off, which were tried and rejected, and what each one cost.

It is a reading order, not a ranking of score gains. Read it for the mechanisms and their remaining costs rather than for patches to resubmit: a frozen epoch already contains this work, so re-proposing it measures nothing. The sections on contract allocation and resident authorization cover `server/connect/resident_contract_manager.go`, the file URnetwork's own reference patches change.
