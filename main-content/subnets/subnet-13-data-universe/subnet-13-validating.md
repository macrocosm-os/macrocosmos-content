# Subnet 13 Validating

### Introduction

The Validator is responsible for validating the data delivered by Miners and scoring Miners according to the [Incentive Mechanism](https://docs.macrocosmos.ai/subnets/subnet-13-data-universe/subnet-13-incentive-mechanism).

Validators run multiple concurrent threads:

| **Component**       | **Purpose**                                |
| ------------------- | ------------------------------------------ |
| Main Loop           | Evaluation cycles, weight setting          |
| Miner Evaluator     | Score calculation and validation           |
| On-Demand Processor | Data Collection job validation             |
| API Server          | External query interface (FastAPI/uvicorn) |
| W\&B Logger         | Metrics logging (rotates every 3 hours)    |
| Metagraph Syncer    | Network state updates                      |

### System Requirements

Validators require at least 32 GB of RAM but do not require a GPU. We recommend a decent CPU (4+ cores) and sufficient network bandwidth to handle protocol traffic. Must have python >= 3.10.

### Getting Started

#### Prerequisites

1. Data Universe supports Twitter and Reddit scraping via Apify so miners have to [setup their Apify API token](https://github.com/macrocosm-os/data-universe/blob/main/docs/apify.md). Validators will default to using the recommended reddit account for reliability but this can be changed editing the PREFERRED\_SCRAPERS map in validator.py locally. Data Universe also supports YouTube Scraping via a [official youtube api](https://github.com/macrocosm-os/data-universe/blob/main/docs/youtube.md).
2. Clone the repo

```
git clone https://github.com/RusticLuftig/data-universe.git
```

3. Setup python [virtual environment](https://docs.python.org/3/library/venv.html) or [Conda environment](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-with-commands).
4. Install the requirements. From your virtual environment, run

```
cd data-universe
python -m pip install -e .
```

5. Make sure you've [created a Wallet](https://docs.learnbittensor.org/keys/working-with-keys) and [registered a hotkey](https://docs.learnbittensor.org/local-build/mine-validate#1-register-the-neuron-hotkeys).

````

This will prompt you to navigate to https://wandb.ai/authorize and copy your api key back into the terminal.

## Running the Validator

### With auto-updates

We highly recommend running the validator with auto-updates. This will help ensure your validator is always running the latest release, helping to maintain a high vtrust.

Prerequisites:
1. To run with auto-update, you will need to have [pm2](https://pm2.keymetrics.io/) installed.
2. Make sure your virtual environment is activated. This is important because the auto-updater will automatically update the package dependencies with pip.
3. Make sure you're using the main branch: `git checkout main`.

From the data-universe folder:
```shell
pm2 start --name net13-vali-updater --interpreter python scripts/start_validator.py -- --pm2_name net13-vali --wallet.name cold_wallet --wallet.hotkey hotkey_wallet [other vali flags]
````

This will start a process called `net13-vali-updater`. This process periodically checks for a new git commit on the current branch. When one is found, it performs a `pip install` for the latest packages, and restarts the validator process (who's name is given by the `--pm2_name` flag)

#### Without auto-updates

If you'd prefer to manage your own validator updates...

From the data-universe folder:

```
pm2 start python -- ./neurons/validator.py --wallet.name your-wallet --wallet.hotkey your-hotkey
```

## Configuring the Validator

### Flags

The Validator offers some flags to customize properties.

You can view the full set of flags by running

```
python ./neurons/validator.py -h
```

### `.env`

Your validator `.env` should look like the following after setup for all data sources:

```
APIFY_API_TOKEN="your_apify_token"
REDDIT_CLIENT_ID="your_reddit_client_id"
REDDIT_CLIENT_SECRET="your_reddit_client_secret"
REDDIT_USERNAME="your_reddit_username"
REDDIT_PASSWORD="your_reddit_password"
YOUTUBE_API_KEY="your_youtube_api_key"
```

Please see docs on [Apify](https://github.com/macrocosm-os/data-universe/blob/main/docs/apify.md), [Reddit](https://github.com/macrocosm-os/data-universe/blob/main/docs/reddit.md), and [Youtube](https://github.com/macrocosm-os/data-universe/blob/main/docs/youtube.md) for more information on the environment variables above.
