---
description: Subnet 1 Apex competitions registry
---

# Current Competitions

### 1. Matrix Compression <a href="#compression-of-activations-challenge" id="compression-of-activations-challenge"></a>

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

#### Other Matrix Compression settings

* The submitted code remains hidden for 24 hours, after that it is open-sourced to the community to ensure fast innovation cycle.
* The round time is 2 days. This means that the task pool is renewed and the logs for the competition are published every two days.
* The emission Burn Rate currently is 90%.
* "The winner takes it all" format means that the winning miner receives all the remaining 10% of miners emission as a first reward. If the same solution continues to stay on top, each **subsequent reward** for that solution will **decrease linearly over 10 days**, in accordance with the emission burning mechanism.

#### For Miners

View the matrix compression [**baseline miner solution**](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/matrix_compression/baseline.py) provided as an example.

View the matrix compression [**general miner solution**](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/matrix_compression/miner_solution.py) template.

**Note:** The R2 bucket does not list files directly. Use the manifest to find and download samples.

1. Download the [manifest file](https://pub-77097c3387c340de9ff1bd5e5b443d8d.r2.dev/manifest.csv). This file contains the full list of available sample filenames.
2. Open the manifest and copy the name of any file you want to download. For example: `example_001.txt`.
3. In your browser (or with `curl`/`wget`), go to:\
   `https://pub-77097c3387c340de9ff1bd5e5b443d8d.r2.dev/<file_name>` replacing `<file_name>` with the name you copied from the manifest.\
   \
   For example:\
   `https://pub-77097c3387c340de9ff1bd5e5b443d8d.r2.dev/example_001.txt.`&#x20;

Then, continue to the [**Apex CLI guide**](https://docs.macrocosmos.ai/subnets/subnet-1-apex/subnet-1-base-miner-setup/apex-cli) to submit a solution.&#x20;





