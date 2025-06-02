# Subnet 9 Validating

#### Joining the network

Validators join the network and get registered with the orchestrator using their API client.

#### Shadowing miners

Validators will periodically reproduce an epoch’s worth of work of a randomly selected miner. This can take up to an hour per miner in the current version, and we will reduce this as one of our first priorities post-launch. This is why there is an important tradeoff between effective batch size and network stability. Validators have more work to reproduce when scoring a miner the longer the training stage is. We will soon integrate CLASP into the system to allow the validators to estimate miner contributions using an auditor-like mechanism, but for now we have more basic and hopefully robust approach which is reproducibility checks. Once a validator has checked that all activations were correctly processed by a miner it then performs a local all-reduce to compare its local weights and optimizer state with what the miner uploaded. If a miner passes the check it ‘banks’ a score equal to the total number of activations it processed in that interval.

#### Setting weights

Validators share information via the orchestrator by design. This means that validators submit the miner scores that they produce in their spot check, and all the miner scores are pooled together to give a total consensus score. Periodically, validators request the miner scores from the orchestrator, normalize and set weights. This guarantees that validators agree with each other, sustaining very high validator trust.

Installation

To install the validator:Clone the repo:

\
`git clone` [`https://github.com/macrocosm-os/iota.git`](https://github.com/macrocosm-os/iota.git)\
Enter the folder:\
`cd iota`\
Create your `.env`:\
It is necessary to add \`wallet\_name, wallet\_hotkey, netuid, network,\
Install the dependencies:\
`uv sync`\
&#x20;  If `uv` is not installed in your system, [install it here](https://docs.astral.sh/uv/getting-started/installation/)\
Activate the environment:\
`source .venv/bin/activate`\
Start the validator:\
`python launch_validator.py --host 0.0.0.0 --port 8081`
