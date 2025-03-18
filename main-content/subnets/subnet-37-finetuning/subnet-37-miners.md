---
description: Mining on subnet 37
---

# Subnet 37: Miners

## Miner

Miners train locally and periodically publish their best model to HuggingFace. They then commit the metadata for that model to the Bittensor chain.

Miners can only have one model associated with them on the chain for evaluation by validators at a time.

The communication between the miner and validator happens asynchronously, and therefore miners don't need to be running continuously. Validators will use whichever metadata was most recently published by the miner to know which model to download from HuggingFace.

## System Requirements

Miners will need enough disk space to store their model. Each uploaded model ([as of June 15th, 2024](#user-content-fn-1)[^1]) cannot be over 15 GB, although, it's recommended to have at least 50 GB of disk space.

Miners will need enough processing power to train their model. We recommend using a large GPU with at least 48 GB of VRAM. To be competitive, you'll likely need clusters of GPUs.

## Getting started

### Prerequisites

1. **Get a HuggingFace Account:**

Miners and validators use HuggingFace in order to share model state information. Miners will upload to HuggingFace and therefore must have an account, along with a user access token which can be found by following [these instructions](https://huggingface.co/docs/hub/security-tokens).

Make sure any repo you create for uploading is public so that the validators can download from it for evaluation.

2. **Get a Wandb Account:**&#x20;

Miners and validators use [Wandb](https://wandb.ai/) to download data from [subnet 1](https://github.com/macrocosm-os/prompting). You then need a user access token, which can be [found here](https://wandb.ai/authorize) once logged in.

3. **Clone the repo:**

Input the following text to do so:

```shell
git clone https://github.com/macrocosm-os/finetuning.git
```

4. **Setup your Python virtual environment or Conda environment:**

The [virtual environment details are here](https://docs.python.org/3/library/venv.html), and the [Conda environment details are here](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-with-commands).

5. **Install the requirements:**

&#x20;[From your virtual environment, run:](#user-content-fn-2)[^2]

```shell
cd finetuning
python -m pip install -e .
```

_Note: We require Python 3.9 or higher._

6. **Make sure you've created a wallet and registered a hotkey:**

Create a [Bittensor wallet here](https://docs.bittensor.com/getting-started/wallets), and get a [registered hotkey here](#user-content-fn-3)[^3].

7. **(Optional) Run a Subtensor instance**:

Your node will run better if you are connecting to a local Bittensor chain entrypoint node, rather than using Opentensor's. We recommend running a local node and passing the `--subtensor.network local` flag to your running miners/validators. To install and run a local subtensor node, follow the commands below with _Docker_ and _Docker-Compose_ previously installed:

```bash
git clone https://github.com/opentensor/subtensor.git
cd subtensor
docker compose up --detach
```

***

## Running the Miner

The mining script has a shell that does some initial setup, _but isn't fully implemented_. You will need to implement the specific training logic yourself prior to running it.

As of Oct 1st, 2024, the subnet works with models matching the [subnet 9](https://github.com/macrocosm-os/pretraining/) outputs and evaluates them against synthetic data from [subnet 1](https://github.com/macrocosm-os/prompting).

The specific requirements for each competition can be found [here](../constants/__init__.py).

The `finetune/mining.py` file has several methods that you may find useful. See the [examples](examples.ipynb) Jupyter notebook for ideas.

See the [Validator Psuedocode](docs/validator.md#validator) for more information on how the evaluation occurs.

### Env File

The Miner requires a .env file with your HuggingFace access token in order to upload models, and a Wandb access token in order to download training data from [subnet 1](https://github.com/macrocosm-os/prompting).

Create a `.env` file in the `finetuning` directory and add the following to it:

```shell
HF_ACCESS_TOKEN="YOUR_HF_ACCESS_TOKEN"
WANDB_ACCESS_TOKEN="YOUR_WANDB_ACCESS_TOKEN"
```

### Starting the Miner

To start your miner the most basic command is

```shell
python neurons/miner.py --wallet.name coldkey --wallet.hotkey hotkey --hf_repo_id my-username/my-project --avg_loss_upload_threshold YOUR_THRESHOLD
```

* `--wallet.name`: should be the name of the coldkey that contains the hotkey your miner is registered with.
* `--wallet.hotkey`: should be the name of the hotkey that your miner is registered with.
* `--hf_repo_id`: should be the namespace/model\_name that matches the HuggingFace repo you want to upload to. It must be public so the validators can download from it.
* `--avg_loss_upload_threshold`: should be the minimum average loss or deviation before you want your miner to upload the model.
* `--competition_id`: this is competition you wish to mine for; run `--list_competitions` to get a list of available options.

### Flags

The Miner offers some flags to customize properties, such as how to train the model and which HuggingFace repo to upload to.

You can view the full set of flags by running

```shell
python ./neurons/miner.py -h
```

Some flags you may find useful:

* `--offline`: when this is set, you can run the miner without being registered and it won't attempt to upload the model.
* `--wandb_entity` + `--wandb_project`: when both flags are set, the miner will log its training to the provided wandb project.
* `--device`: by default the miner will use your GPU, but you can specify with this flag if you have multiple.

### Training from pre-existing models

* `--load_best`: when this is set, you will download and train the model from the current best miner on the network.
* `--load_uid`: when passing a UID you will download and train the model from the matching miner on the network.
* `--load_model_dir`: the path to a local model directory \[saved via HuggingFace API].

***

### Manually uploading a model

In some cases, you may have failed to upload a model or wish to upload a model without further training.

Due to rate limiting by the Bittensor chain you may only upload a model every 20 minutes.

You can manually upload with the following command:

```shell
python scripts/upload_model.py --load_model_dir <path to model> --hf_repo_id my-username/my-project --wallet.name coldkey --wallet.hotkey hotkey
```

[^1]: Is this still accurate?

[^2]: Is this the same for people using Conda as well?

[^3]: Could we get a link for this?
