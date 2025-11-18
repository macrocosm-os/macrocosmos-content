---
description: Subnet 1 Apex competitions registry
---

# Current Competitions

### Matrix Compression <a href="#compression-of-activations-challenge" id="compression-of-activations-challenge"></a>

The first competition - Matrix Compression - explores how small neural activations - both forward and backward - can be compressed while still retaining all their original information. Reducing activation size enables faster data transfer across the internet, a crucial step toward making distributed training more efficient, as it’s often constrained by network bandwidth. The top-performing algorithms from this competition will be integrated to enhance training on subnet 9 **IOTA**. A follow-up **lossy** compression competition is planned for the future. Miners aim to optimize the following:

* Compression Ratio - How small the compressed solution is on disk versus the starting matrix.
* Time - How fast the compression/decompression algorithm runs.

Base-miner solution can be found [here](https://github.com/macrocosm-os/apex-mvp/blob/main/shared/competition/src/competition/matrix_compression/baseline.py).

For more details on activation compression, see the [Subnet 1 Overview](../../new-subnet-1-apex.md#compression-of-activations-challenge).

