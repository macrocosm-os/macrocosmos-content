# Mining

## Introduction

In IOTA, miners are the workers that supply GPU compute, memory, and bandwidth to collaboratively train models. Our architecture uses data- and pipeline-parallelism, meaning that miners run sections of the model rather than its entirety, which greatly reduces the hardware requirement for participation. Each miner downloads its assigned section of the model, runs forwards and backward passes of activations and periodically sync their weights with peers in the same layer via a merging process. By distributing workloads across a large number of independent miners, the network achieves massive parallelism and fault tolerance.

The IOTA incentive mechanism continuously scores miners on the quality of their contributions, and rewards them with subnet 9 alpha tokens.

## Operations explained

### Joining the network

Miners join the network and get registered with the orchestrator using their API client, which assigns them to a training layer. Then, they download the current global weights for their layer and begin processing activations.

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

Figure 1 below illustrates the training loop.

<img src="../../.gitbook/assets/file.excalidraw (2).svg" alt="Figure 1 The training loop process" class="gitbook-drawing">

Figure 1 Explanation - While inside the training loop, the miner is responsible for performing forward and backward passes while uploading their activations to the dedicated storage bucket. In the forward direction, miners receive activations from the previous layer, compute transformed outputs, and propagate them downstream. During the backward pass, they consume gradients, compute local weight updates, and send gradients upstream. Importantly, the number of forward and backward passes per training loop is controlled via an orchestrator level hyperparameter called BATCHES\_BEFORE\_MERGING.

For the details on validating, please follow the link -> [Subnet 9 Validation](https://docs.macrocosmos.ai/subnets/subnet-9-pre-training/subnet-9-validating).

## Setting Up a Miner

Before working with subnet 9, you should familiarize yourself with the [Bittensor documentation](https://docs.bittensor.com/), describing the ecosystem and relationships between network participants.

If you have any questions, not covered in the instruction or facing issues with installation, reach us out for support in:

* ​[Macrocosmos Discord](https://discord.com/channels/1238450997848707082)
* [Bittensor Discord](https://discord.com/channels/799672011265015819/1162768567821930597)

### Prerequisites

To setup a miner on IOTA you will need the following:

* [Bittensor wallet](https://docs.bittensor.com/working-with-keys).
* Minimum training infrastructure: CUDA GPU with 8GB of VRAM (e.g. RTX-4080 class or higher) and Ubuntu 22.04 (Jammy)
* Basic [HuggingFace Access token](https://huggingface.co/docs/hub/en/security-tokens) to pull the model.

### Installation&#x20;

To-do: test on fresh install

1.  Download the IOTA repository and setup your environment.

    ```python
    #Clone the repository
    git clone https://github.com/macrocosm-os/IOTA.git
    cd IOTA

    # Assuming a new .venv is needed
    uv venv
    source .venv/bin/activate
    uv sync


    ```
2.  Register your miner.

    ```bash
    # Activate virtual environment if needed
    source .venv/bin/activate

    # Register on mainnet (finney)
    btcli s register --netuid 9 --wallet.name [your_wallet_name] --wallet.hotkey [your_wallet_hotkey]
    ```
3.  Make sure that your `.env` file contains all necessary variables.

    ```
    To Do
    ```
4.  Launch your miner

    ```
    To Do
    ```

🎉Welcome to the Cosmos!
