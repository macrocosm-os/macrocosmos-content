---
description: Subnet 1 Apex competitions registry
---

# Current Competitions

### Matrix Compression <a href="#compression-of-activations-challenge" id="compression-of-activations-challenge"></a>

The first competition - Matrix Compression - explores how small neural activations - both forward and backward - can be compressed while still retaining all their original information. Reducing activation size enables faster data transfer across the internet, a crucial step toward making distributed training more efficient, as it’s often constrained by network bandwidth. The top-performing algorithms from this competition will be integrated to enhance training on subnet 9 **IOTA**.&#x20;

#### Evaluation

Miners aim to optimize the following:

* Compression Ratio - How small the compressed solution is on disk versus the starting matrix.
* Time - How fast the compression/decompression algorithm runs.

To surpass the current winner of the competition, a miner must earn a **raw score** of at least 1% higher than the current top score. If there is no current winner, then a miner must earn a raw score of at least 1% higher than the baseline score.&#x20;

* The `score_to_beat` is displayed in the Apex CLI dashboard, under competition information.&#x20;

**Raw score is calculated by:**

```
raw_score = 1 * (30 - task_time) + 1000 * similarity + 1000000 * compression_ratio
```

* Where `task_time` includes both compression and decompression.
* Similarity is calculated by `cosine_similarity * norm_similarity`.
* Compression ratio is calculated by `original_size / compressed_file_size`.

**This raw score is then normalized with a sigmoid normalization function:**

```
normalized_score = 1 / (1 + np.exp(-0.003 * (raw_score / 1000 - 2000)))
```

* Where a normalized score of 0.5 correlates to a raw score of 2,000,000.



#### For Miners

View the matrix compression [**baseline miner solution**](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/matrix_compression/baseline.py) provided as an example.

View the matrix compression [**general miner solution**](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/matrix_compression/miner_solution.py) template.

Test your solution with the provided samples in this R2 bucket: [https://pub-77097c3387c340de9ff1bd5e5b443d8d.r2.dev](https://pub-77097c3387c340de9ff1bd5e5b443d8d.r2.dev). Files are listed in `manifest.csv`

* First, download `manifest.csv` from the R2 bucket to access all sample file names.&#x20;
* You will then be able to access all sample files with their given file names.&#x20;

Then, continue to the [**Apex CLI guide**](https://docs.macrocosmos.ai/~/revisions/sm0UfbwJePs5Nk1ErAj9/subnets/new-subnet-1-apex/subnet-1-base-miner-setup/apex-cli) to submit a solution.&#x20;





