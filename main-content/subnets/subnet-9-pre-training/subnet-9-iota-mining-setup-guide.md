---
hidden: true
---

# Subnet 9 IOTA Mining Setup Guide

## Miners purpose in IOTA

In a SWARM-based decentralized LLM-training system, miners are the workers that supply GPU compute, memory, and bandwidth to collaboratively train and refine model checkpoints. Each miner downloads its assigned parameter shard, runs forward-backward passes on locally streamed data, and submits encrypted gradient updates or low-rank deltas to the coordination layer, where they are aggregated and verified. By dispersing workloads across thousands of independent miners, the network achieves massive parallelism, fault tolerance, and censorship resistance while eliminating single-point infrastructure costs.&#x20;

IOTA incentive mechanism continuously scores miners on throughput, data quality, and update fidelity, rewarding high-performing nodes with subnet 9 tokens and reallocating tasks away from unreliable participants. The result is a self-optimising, permissionless fabric that scales LLM training to global levels, democratising access to state-of-the-art models without sacrificing security or provenance.

Operations explained

At unknown, random intervals in the future, miners are able to register onto the network. While registered, the miner is initialized with the orchestrator and assigned a model layer to train. From this point, the cadence of the miner-orchestrator communication is critical, and can be simply broken down into two major pieces, the training phase, and the merging phase.

Figure 1 below illustrates the training loop.

<img src="https://lh7-rt.googleusercontent.com/docsz/AD_4nXchK1fl8OljpzMosnmdSgpDC9V0eimk58o24An7BI0cmwnVV092ec1tUp8SNgvnrmm0UMH96j8aLkmor7ZGXpt1aExqSLLpQ4Eh-e3yJlumT12OfqD5V06DGSpDcfXpWd1Amfd3?key=AwwdJzWEYS6KGt6pohXAWw" alt="" data-size="original">

While inside the training loop, the miner is responsible for performing forward and backward passes while uploading their activations to the dedicated storage bucket. In the forward direction, miners receive activations from the previous layer, compute transformed outputs, and propagate them downstream. During the backward pass, they consume gradients, compute local weight updates, and send gradients upstream. Importantly, the number of forward and backward passes per training loop is controlled via an orchestrator level hyperparameter called BATCHES\_BEFORE\_MERGING.

## Setting Up Mining

This section provides an instruction on the IOTA miner set up. The setting up process is described as a full flow, assuming use of the Terminal. Some operations should be adjusted, when using any UI dev tools for set up. At the bottom of the page you may find instructions on RunPod setup examples for the ones who are not familiar with infrastructure setup.

Before working with subnet 9, you should familiarize yourself with the [Bittensor documentation](https://docs.bittensor.com/), describing the ecosystem and relationships between network participants.

If you have any questions, not covered in the instruction or facing issues with installation, reach us out for support in:

* ​[Macrocosmos Discord](https://discord.com/channels/1238450997848707082)
* [Bittensor Discord](https://discord.com/channels/799672011265015819/1162768567821930597)

### Prerequisites

To start setting up the miner on IOTA requires:

* Bittensor wallet - [set up instructions](https://docs.bittensor.com/working-with-keys)
* Training infrastructure:\
  Miners must run on GPUs with at least 80 GB of VRAM (A100-class or higher); hardware with less memory will process updates more slowly and consequently may earn markedly lower rewards.
* Bittensor wallet - instructions

### Installation

1.  Provide the files executable rights to run on your local machine

    ```python
    # Provide the files executable rights to run on your local machine
    cd .ssh
    vim id_rsa
    chmod 0400 ~/.ssh/id_rsa

    #Clone the repository
    cd workspace
    git clone https://github.com/macrocosm-os/IOTA.git
    cd IOTA
    bash

    #Check uv version
    uv –version

    #Install dependencies
    cd IOTA
    uv sync

    #Install bittensor cli
    pip install bittensor-cli

    #Optional - update the bittensor-cli, if a new version is available
    python -m pip install --upgrade pip
    ```

### Bittensor Wallet Registraton

```python
# Regenerate the coldkey: create a name of the wallet = coldkey name and provide your Bittensor Wallet mnemonic key.
btcli w regen_coldkey

# Regenerate the hotkey: Provide your wallet (just created coldkey name) and create a name of the hotkey (do not insert your actual key symbolic combination).
btcli w regen_hotkey

#Check your wallets balance
btcli wallets balance
```

### Miner Registration and Launch

{% hint style="info" %}
A registration fee in TAO can be expensive. Any expenses incurred during registration or infrastructure setup will not be reimbursed by Macrocosmos. So first run your miner on the testnet to avoid deregistration caused by technical issues or underperformance before moving to mainnet.
{% endhint %}

#### Register on Mainnet

```python
# Activate virtual environment
source .venv/bin/activate

# Register on the mainnet (finney)
btcli s register --netuid 9 --wallet.name [wallet_name] --wallet.hotkey [wallet.hotkey]
```

**Change miner values, where necessary, and copy them:**

wallet\_name="wallet\_name" #change the wallet\_name to your wallet name (coldkey name)

wallet\_hotkey="wallet\_hotkey" #change the wallet\_hotkey to your hotkey name

netuid=9

network="finney"

MOCK=False

BITTENSOR=True

S3\_BUCKET="swarm-mvp"

HF\_TOKEN="hf\_token

AWS\_ACCESS\_KEY

```python
#Edit miners file with required values
vim .env

# For Terminal - use a ky combination Ctrl + Shift + V (Cmd + V)
:wq

#For the UI enabled tools just change the values in the miner's .env file

#Launch the miner
source .venv/bin/activate
python launch_miner.py
```

Expected output:

#### Register on Testnet

To request the test TAO, follow the [instructions on Discord channel](https://discord.com/channels/799672011265015819/1331693251589312553/1331694633822060544).

```python
# Activate virtual environment
source .venv/bin/activate

# Register on the mainnet (finney)
btcli s register --netuid 141 --wallet.name [wallet_name] --wallet.hotkey [wallet.hotkey] –subtensor.network test
```

**Change miner values, where necessary, and copy them:**

wallet\_name="wallet\_name" #change the wallet\_name to your wallet name (coldkey name)

wallet\_hotkey="wallet\_hotkey" #change the wallet\_hotkey to your hotkey name

netuid=141

network="test"

MOCK=False

BITTENSOR=True

S3\_BUCKET="swarm-mvp"

HF\_TOKEN="hf\_token"??

AWS\_ACCESS\_KEY??

```python
#Edit miners file with required values
vim .env

# For Terminal - use a ky combination Ctrl + Shift + V (Cmd + V)
:wq

#For the UI enabled tools just change the values in the miner's .env file

#Launch the miner
source .venv/bin/activate
python launch_miner.py
```

Expected output:

🎉Congratulations! You have set up the miner and are able to contribute to the world of breaking edge innovation!\


\
