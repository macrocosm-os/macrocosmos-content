---
description: Registry of competitions currently active on SN1 APEX.
---

# Current Competitions

## 1. Matrix Compression <a href="#compression-of-activations-challenge" id="compression-of-activations-challenge"></a>

The first competition - Matrix Compression - explores how small neural activations - both forward and backward - can be compressed while still retaining all their original information. Reducing activation size enables faster data transfer across the internet, a crucial step toward making distributed training more efficient, as it’s often constrained by network bandwidth. The top-performing algorithms from this competition will be integrated to enhance training on subnet 9 **IOTA**.&#x20;

#### Evaluation

Miners aim to optimize the following:

* Compression Ratio - How small the compressed solution is on disk versus the starting matrix.
* Time - How fast the compression/decompression algorithm runs.

To surpass the current winner of the competition, a miner must earn a **score** of at least 1% higher than the current top score. If there is no current winner, then a miner must earn a score of at least 1% higher than the baseline score.&#x20;

* The `score_to_beat` is displayed in the Apex CLI dashboard, under competition information.&#x20;

**Score is calculated by:**

```
score = np.clip((1 - compression) * (1 - task_time / (1 + 0.012)), 0.0, 1.0)
```

* Where `task_time` includes both compression and decompression.
* Compression is calculated by `compressed_file_size / original_file_size`.
* If compression is not **lossless**, the submission will receive a score of 0.&#x20;



#### Matrix Compression Settings

* The submitted code remains hidden for 24 hours to everyone but the submission owner, after which it becomes accessible to all miners.&#x20;
* Round length: **2 days**
* Burn rate: **90%**&#x20;
  * The top scorer receives the remaining incentive pool (10%), decreasing linearly over a **10 day period**, provided no other submissions surpass the current top score.&#x20;
    * If a new submission exceeds the top score, the incentive decay resets from 10%.&#x20;
* Evaluation: each round uses 30 randomly sampled matrices from the total pool; the sample refreshes every round.
* Submission Constraints: Your submission must be less than 20KB.



#### For Miners

View the matrix compression [**baseline miner solution**](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/matrix_compression/baseline.py) provided as an example.

The manifest.json file contains a sample of 1000 matrices of a large matrix pool, including both matrices that have already been used for evaluation and matrices that have not been evaluated.

**Note:** The R2 bucket does not list files directly. Use the manifest to find and download samples.

1. Download the [manifest file](https://pub-77097c3387c340de9ff1bd5e5b443d8d.r2.dev/manifest.csv). This file contains the full list of available sample filenames.
2. Open the manifest and copy the name of any file you want to download. For example: `example_001.txt`.
3. In your browser (or with `curl`/`wget`), go to:\
   `https://pub-77097c3387c340de9ff1bd5e5b443d8d.r2.dev/<file_name>` replacing `<file_name>` with the name you copied from the manifest.\
   \
   For example:\
   `https://pub-77097c3387c340de9ff1bd5e5b443d8d.r2.dev/example_001.txt.`&#x20;

Then, continue to the [**Apex CLI guide**](https://docs.macrocosmos.ai/subnets/subnet-1-apex/subnet-1-base-miner-setup/apex-cli) to submit a solution.



