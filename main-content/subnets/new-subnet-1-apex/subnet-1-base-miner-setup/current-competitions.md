---
description: Subnet 1 Apex competitions registry
---

# Current Competitions

### Matrix Compression <a href="#compression-of-activations-challenge" id="compression-of-activations-challenge"></a>

<figure><img src="../../../.gitbook/assets/image (2).png" alt="" width="375"><figcaption></figcaption></figure>

The first competition - Matrix Compression - explores how small neural activations - both forward and backward - can be compressed while still retaining all their original information. Reducing activation size enables faster data transfer across the internet, a crucial step toward making distributed training more efficient, as it’s often constrained by network bandwidth. The top-performing algorithms from this competition will be integrated to enhance training on subnet 9 **IOTA**.&#x20;

Miners aim to optimize the following:

* Compression Ratio - How small the compressed solution is on disk versus the starting matrix.
* Time - How fast the compression/decompression algorithm runs.

To surpass the current winner of the competition, a miner must earn a **raw score** of at least 1% higher than the current top score. If there is no current winner, then a miner must earn a raw score of at least 1% higher than the baseline score.&#x20;

* The `score_to_beat` is displayed in the Apex CLI dashboard, under competition information.&#x20;

#### For Miners

View the matrix compression [**baseline miner solution**](https://github.com/macrocosm-os/apex-mvp/blob/main/shared/competition/src/competition/matrix_compression/baseline.py) provided as an example.

View the matrix compression [**general miner solution**](https://github.com/macrocosm-os/apex-mvp/blob/main/shared/competition/src/competition/matrix_compression/miner_solution.py) template.

Build your solution testing with the provided samples in this r2 bucket: [https://pub-77097c3387c340de9ff1bd5e5b443d8d.r2.dev](https://pub-77097c3387c340de9ff1bd5e5b443d8d.r2.dev) Files are listed in `manifest.csv`

Then, continue to the [**Apex CLI guide**](https://docs.macrocosmos.ai/~/revisions/sm0UfbwJePs5Nk1ErAj9/subnets/new-subnet-1-apex/subnet-1-base-miner-setup/apex-cli) to submit a solution.&#x20;



### Overview

**Why Matrix Compression matters so much in decentralized LLM training:**

1. Activations must be communicated or stored between layers/devices. Without compression, this inter-layer communication becomes the major bottleneck in throughput and scalability.
2. Matrix Compression enables effective scalability across many nodes by mitigating network communication latencies. ￼
3. Reducing the memory footprint of activations frees up resources for other parts of the pipeline, improving the overall efficiency and cost-effectiveness of decentralized training.

Innovative matrix compression solutions unlock several high-impact real-world applications:

* Distributed AI and Federated Learning Efficiency
* Data Center and Cloud Infrastructure Optimisation
* Edge and Networked Systems Performance
* Large-Scale Simulation and Optimisation Systems.

Optimisation advancements translate into lower network strain in AI-driven systems, more sustainable infrastructure, faster, scalable collaboration between machines and data centres, real-time enhancement for logistics, transportation, and communication networks.

