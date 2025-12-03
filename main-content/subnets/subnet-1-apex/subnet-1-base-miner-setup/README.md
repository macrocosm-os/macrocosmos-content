---
description: Subnet 1 mining guide
---

# Mining

## Miner Documentation

### Overview

**Apex** drives algorithmic innovation across diverse problem domains. Each pursuit of the best solution takes place within a **Competition**, which consists of multiple **Rounds** of evaluation. Participants, known as miners, join Competitions by submitting their Python-based algorithms through the[ Apex CLI](https://docs.macrocosmos.ai/subnets/subnet-1-apex/subnet-1-base-miner-setup/apex-cli) and earn rewards based on their performance.



### Prerequisites

To setup a miner on Apex you will need the following:

* A registered [Bittensor wallet](https://docs.bittensor.com/working-with-keys)&#x20;



### Setting Up the Environment&#x20;

To get started, [clone the repo](https://github.com/macrocosm-os/apex) and run `./install_cli.sh` then activate the environment created by running `source .venv/bin/activate`



### Creating Your Solutions:

Miners are encouraged to review the baseline solutions for available competitions before submitting their own. All baseline solutions and general submission templates can be found in their respective competition folders within `shared/competition/src/competition`.

You should keep all function signatures identical to the baseline to ensure that your submission can be evaluated properly.&#x20;



### Submitting Your Solutions

To understand the current competitions and their scoring guidlelines: [Current Competitions](https://docs.macrocosmos.ai/subnets/subnet-1-apex/current-competitions)

To use the CLI to submit miner solutions, pull previous winning submissions, and view the submission dashboard: [CLI Usage](https://docs.macrocosmos.ai/subnets/subnet-1-apex/subnet-1-base-miner-setup/apex-cli)
