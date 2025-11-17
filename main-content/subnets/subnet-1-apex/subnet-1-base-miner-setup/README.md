---
description: Overview of Mining on SN1 APEX
---

# Subnet 1 (APEX) Mining Guide

## Miner Documentation

### Overview

**Apex** drives algorithmic innovation across diverse problem domains. Each pursuit of the best solution takes place within a **Competition**, which consists of multiple **Rounds** of evaluation. Participants, known as miners, join Competitions by submitting their Python-based algorithms through the Apex CLI and earn rewards based on their performance.

### Getting Started&#x20;

To get started, [clone the repo](https://github.com/macrocosm-os/apex) and run `./setup.sh`

Add the following to your .env file, after creating a new .env from the provided `.env.template`

```
ENV="test" #TODO: Update to mainnet
ORCHESTRATOR_SCHEMA="https"
ORCHESTRATOR_HOST="apex-stage.api.macrocosmos.ai"
ORCHESTRATOR_PORT=443
```

### To Submit Solutions:

[Current Competitions](current-competitions.md)

[Cli Usage](apex-cli.md)

### To Get Started with A Baseline

View `shared/competition/src/competition/<competition_name>/baseline.py`
