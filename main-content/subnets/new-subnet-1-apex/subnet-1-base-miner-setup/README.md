---
description: Subnet 1 mining guide
---

# Mining

## Miner Documentation

### Overview

**Apex** drives algorithmic innovation across diverse problem domains. Each pursuit of the best solution takes place within a **Competition**, which consists of multiple **Rounds** of evaluation. Participants, known as miners, join Competitions by submitting their Python-based algorithms through the Apex CLI and earn rewards based on their performance.



## Setting Up a Miner

Before contributing to subnet 1 Apex, you should familiarize yourself with the [Bittensor documentation](https://docs.bittensor.com/) to better understand the ecosystem and the relationships between network participants. Then, follow the setup guide below and submit solutions with the [Apex CLI](https://docs.macrocosmos.ai/~/revisions/3XwlL8WNSEcVH2lg1gKX/subnets/new-subnet-1-apex/subnet-1-base-miner-setup/apex-cli).

If you have any questions not covered here, reach out for support in:

* ​[Macrocosmos Discord](https://discord.com/channels/1238450997848707082)
* [Bittensor Discord](https://discord.com/channels/799672011265015819/1162768567821930597)



### Prerequisites

To setup a miner on Apex you will need the following:

* A [Bittensor wallet](https://docs.bittensor.com/working-with-keys).
* [The Bittensor command line interface](https://docs.learnbittensor.org/getting-started/install-btcli) (CLI) - `btcli` .



### Getting Started&#x20;

To get started, [clone the repo](https://github.com/macrocosm-os/apex) and run `./setup.sh`

Add the following to your .env file created by `setup.sh`

```
ENV="test" #TODO: Update to mainnet
ORCHESTRATOR_SCHEMA="https"
ORCHESTRATOR_HOST="apex-stage.api.macrocosmos.ai"
ORCHESTRATOR_PORT=443
```



### To Submit Solutions:

Miners are encouraged to review the baseline solutions for available competitions before submitting their own. All baseline solutions and general submission templates can be found in their respective competition folders within `shared/competition/src/competition`.

To understand the current competitions and their scoring guidlelines: [Current Competitions](current-competitions.md)

To use the CLI to submit miner solutions or view the submission dashboard: [CLI Usage](apex-cli.md)
