# Mining

## Introduction

In IOTA, miners are the workers that supply GPU compute, memory, and bandwidth to collaboratively train models. Our architecture uses data- and pipeline-parallelism, meaning that miners run sections of the model rather than its entirety, which reduces the hardware requirement for participation. Each miner downloads its assigned section of the model, runs forwards and backward passes of activations and periodically sync their weights with peers in the same layer via a merging process. By distributing workloads across a large number of independent miners, the network achieves massive parallelism and fault tolerance.

The IOTA incentive mechanism continuously scores miners on the quality of their contributions, and rewards them with IOTA alpha tokens.

## Operations

### Joining the network

Miners join the network and get registered with the orchestrator, which assigns them to a training layer. Then, they download the current global weights for their layer and begin processing activations.

### Activations

There are two activation types: forward and backward.

* Forwards activations propagate samples through the model to produce a next-token prediction, which is fed to an evaluation function.
* Backwards activations propagate learning signals in the opposite direction, allowing the entire network to adjust its parameters.

Miners must process as many activations as possible in each epoch — their score is based on throughput. If a miner fails to process an activation that it has been assigned, it is penalized.&#x20;

### Merging

Once the orchestrator signals that enough samples have been processed in the network, the state of the system changes from training mode to merging mode.&#x20;

In merging mode, the miners perform a multi-stage process which is a modified version of Butterfly All-Reduce.&#x20;

1. Miners upload their local weights and optimiser states to the s3 bucket.&#x20;
2. They are assigned a set of random weight partitions.&#x20;

Importantly, multiple miners are assigned to the same partitions which provides redundant measurement of results for improved fault tolerance and robustness!&#x20;

3. Miners then must download their partitions, perform a local merge (currently the element-wise geometric mean) and then upload their merged partitions.&#x20;

This design is tolerant to miner failures, so merging is not blocked if some miners do not successfully complete this stage.&#x20;

5. Finally, miners download the complete set of merged weights and optimiser states. The merging stage is currently the slowest, so we amortise this by running the training stage for longer and effectively training on larger batch sizes.

Once merging is complete, the orchestrator state returns to training mode and the miners continue processing activations. The miners cycle between training mode and merging mode in perpetuity.

For the details on validating, please follow the link -> [Subnet 9 Validation](https://docs.macrocosmos.ai/subnets/subnet-9-pre-training/subnet-9-validating).

## Setting Up a Miner

Before contributing to IOTA, you should familiarize yourself with the [Bittensor documentation](https://docs.bittensor.com/) to better understand the ecosystem and the relationships between network participants.

If you have any questions not covered here, reach out for support in:

* ​[Macrocosmos Discord](https://discord.com/channels/1238450997848707082)
* [Bittensor Discord](https://discord.com/channels/799672011265015819/1162768567821930597)

### Prerequisites

To setup a miner on IOTA you will need the following:

* A [Bittensor wallet](https://docs.bittensor.com/working-with-keys).
* [The Bittensor command line interface](https://docs.learnbittensor.org/getting-started/install-btcli) (CLI) - `btcli` .
* [UV](https://docs.astral.sh/uv/#installation).
* Minimum training infrastructure: CUDA GPU with at least 16GB VRAM (RTX 4090, for example) and Ubuntu 22.04 (Jammy).
* Basic [HuggingFace Access token](https://huggingface.co/docs/hub/en/security-tokens) to pull the model.

### Installation&#x20;

1. Download the IOTA repository

```bash
#Clone the repository
git clone https://github.com/macrocosm-os/iota
cd iota
```

2. Register your miner

```bash
# Register on mainnet (finney)
btcli s register --netuid 9 --wallet.name [your_wallet_name] --wallet.hotkey [your_wallet_hotkey]
```

3. Launch the setup script

<pre class="language-bash" data-full-width="false"><code class="lang-bash"><strong>bash setup.sh
</strong></code></pre>

4. Launch the miner

{% code fullWidth="false" %}
```bash
./start_miner.sh
```
{% endcode %}





🎉Welcome to the Cosmos!
