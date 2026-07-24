# Text Clustering

The Text Clustering competition challenges miners to build fast, CPU-only clustering algorithms that approximate industry-standard NLP pipelines (sentence embeddings + UMAP + HDBSCAN) on real social media data from Bittensor Subnet 13's data scraping product, Gravity. Clustering messy real-world text by topic is the engine behind every trend-detection and feedback-analysis pipeline — this competition crowdsources the best version of it.

Each round, miners receive fresh slices of real X and Reddit posts collected through SN13 and must return cluster assignments. Submissions are scored against pre-computed embedding-based ground truth using Adjusted Rand Index and Normalized Mutual Information.

### Settings

* Competition Dashboard
* Submissions must be a single `.py` file implementing a FastAPI server.
* Maximum submission size: 50,000 characters.
* CPU-only sandbox — no GPU, no internet at runtime.

### Round Structure

* A round consists of **three clustering tasks (subsets)**, each on a fresh batch of real social media posts; the round score is the mean across the three.
* Each round, the platform collects texts from X and Reddit through Gravity (SN13 batch collection) and pre-computes ground-truth cluster labels using a sentence-transformer + UMAP + HDBSCAN pipeline. Ground truth is baked in an isolated sandbox — miners never see it, and it never leaves the platform.
* The miner's task is to receive raw texts via HTTP and return integer cluster assignments — without seeing the ground truth, knowing the number of clusters (it varies per subset), or having internet access at runtime.
* The miner that produces the clustering closest to ground truth wins and receives all competition emissions, annealing with the burn.

### Evaluation

Miners implement an HTTP server with two endpoints — `/health` and `/cluster` — that receive raw texts and return cluster assignments.

* `/health` is polled during sandbox startup until the miner returns 200 OK.
* `/cluster` is called once per subset with the full text batch — typically **\~5,000 texts** (batch size may vary between rounds) — with a **90-second** clustering time budget per call.

An example of a baseline implementation using TF-IDF + MiniBatchKMeans can be found in the `text_clustering` folder.

### Data Source

Texts are real social media posts collected by Bittensor Subnet 13 miners through the Gravity decentralized data network.

* Platforms: X (Twitter) and Reddit.
* Topics vary each round: AI, crypto, politics, sports, science, etc.
* Volume: \~5,000 texts per subset, three subsets per round.
* Collection: Gravity Tasks run for up to 7 days, crawling specified topics across the SN13 miner network.

You can explore the kind of data your algorithm will cluster using the Macrocosmos Dataverse CLI:

```
cargo install dataverse-cli
dv auth                              # key from https://app.macrocosmos.ai/account?tab=api-keys
dv -o json search x -k AI -l 100     # 100 X posts about AI
dv -o json search reddit -k MachineLearning -l 50
```

### API Interface

Health check:

```
GET /health
Response: {"status": "healthy"}
```

Clustering endpoint:

```
POST /cluster
Request:  {"texts": ["text1", "text2", ...]}
Response: {"cluster_ids": [0, 1, 0, 2, ...]}
```

### Scoring

Each subset is scored by comparing the miner's cluster assignments to the pre-computed ground-truth labels using two metrics:

* **Adjusted Rand Index (ARI)**, range −1 to 1: similarity between the two clusterings, adjusted for chance.
* **Normalized Mutual Information (NMI)**, range 0 to 1: how much information the miner's assignments and the ground truth share, normalized.

The per-subset score clamps ARI at 0 and averages it with NMI:

```
ari_normalized = max(0.0, ari)   # negative ARI (random/degenerate) -> 0
combined = (ari_normalized + nmi) / 2
```

A round runs 3 subsets; the miner's round score is the mean of the 3 per-subset combined scores (range 0 to 1).

To surpass the current winner, a miner must earn a raw score at least 1% higher than the current top raw score. If there is no current winner, the miner must beat the baseline raw score by at least 1%. The `score_to_beat` is displayed in the Apex CLI dashboard, under competition information.

### Constraints

* **CPU only** — no GPU available in the sandbox.
* **No internet** — cannot download models, embeddings, or external data at runtime. Bake everything into your submission or `requirements.txt`.
* **Sandbox time limit** — 90 seconds per `/cluster` response (plus 30 seconds for server startup).
* **Restricted environment** — submissions run in a locked-down sandbox. Anything that reaches outside it (network access, escaping the workspace, spawning external processes, or executing code dynamically) is rejected by the screener at submission time. Keep your solution to self-contained, in-sandbox computation.

### Miner Submissions

* Miners submit a single `.py` file implementing the FastAPI server above.
* Maximum submission size: 50,000 characters.
* Submission fee: $20.00 USD.
* Default round length: 1 day.
* Miner code is revealed 1 day after evaluation.
* Logs are opened after the current round is completed.
* Multiple submissions: the rate limit is 4 submissions per hotkey within 24 hours, across all competitions.
* The information about enabled packages is in `requirements.txt`.
