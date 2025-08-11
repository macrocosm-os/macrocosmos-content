# Validating

Within the system, validators play a core role in determining if the work completed by the miner was honest. Primarily, the validator relies on computational reproducibility to achieve this validation signal. As the validator is tracking a specific miner, a portion of the miner’s training is completely rerun on the validator side. Forward and backwards passes are checked against the submitted miner activations using a cosine similarity. However, there are many complications when it comes to reliable validation, and we explore them in the remainder of the paper.

#### Joining the network

Validators join the network and get registered with the orchestrator using their API client.

#### Shadowing miners

Validators will periodically reproduce an epoch’s worth of work of a randomly selected miner. This can take up to an hour per miner in the current version, and we will reduce this as one of our first priorities post-launch. This is why there is an important tradeoff between effective batch size and network stability. Validators have more work to reproduce when scoring a miner the longer the training stage is. We will soon integrate CLASP into the system to allow the validators to estimate miner contributions using an auditor-like mechanism, but for now we have more basic and hopefully robust approach which is reproducibility checks. Once a validator has checked that all activations were correctly processed by a miner it then performs a local all-reduce to compare its local weights and optimizer state with what the miner uploaded. If a miner passes the check it ‘banks’ a score equal to the total number of activations it processed in that interval.

#### Setting weights

Validators share information via the orchestrator by design. This means that validators submit the miner scores that they produce in their spot check, and all the miner scores are pooled together to give a total consensus score. Periodically, validators request the miner scores from the orchestrator, normalize and set weights. This guarantees that validators agree with each other, sustaining very high validator trust.

### Prerequisites

To setup a validator on IOTA you will need the following:

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

2. Launch the setup script

<pre class="language-bash" data-full-width="false"><code class="lang-bash"><strong>bash setup.sh
</strong></code></pre>

3. Launch the validator

{% code fullWidth="false" %}
```bash
./start_validator.sh
```
{% endcode %}
