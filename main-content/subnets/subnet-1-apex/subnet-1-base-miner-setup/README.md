---
description: Your guide to setup and participation as a miner.
---

# Subnet 1 Mining

### Introduction

**Apex** drives algorithmic innovation across diverse problem domains. Each pursuit of the best solution takes place within a **Competition**, which consists of multiple **Rounds** of evaluation. Participants, known as miners, join Competitions by submitting their solutions through the [Apex CLI](apex-cli.md), and earn rewards based on their performance.



### Prerequisites

To setup a miner on Apex you will need the following:

* A registered [Bittensor wallet](https://docs.bittensor.com/working-with-keys)&#x20;
  * If your chosen competition has a submission fee, the wallet must contain enough funds per submission to pay for it.



### Setting Up the Environment&#x20;

To get started, [clone the repo](https://github.com/macrocosm-os/apex) and run `./install_cli.sh`. Then, activate the environment created by running `source .venv/bin/activate` .



### Creating Your Solutions:

Miners are encouraged to review the baseline solutions for available competitions before submitting their own. All baseline solutions and general submission templates can be found in their respective competition folders within `shared/competition/src/competition`.

Keep all function signatures identical to the baseline to ensure that your submission can be evaluated properly.&#x20;

To understand the current competitions and their scoring guidelines visit the  [Current Competitions](../subnet-1-current-competitions/) page.



### Submitting Your Solutions

To use the CLI to submit miner solutions, pull previous winning submissions, and view the submission dashboard, visit the [CLI Usage](apex-cli.md) page.
