# Validating

In Subnet 1, the validator acts as the impartial referee and gatekeeper of quality, ensuring that every submitted solution is fairly assessed and correctly rewarded. After miners submit their code to the competition, the solutions are executed in a secure Code Executor sandbox, which produces performance metrics such as compression ratio, speed, and decompression accuracy. The validator then reviews these metrics, converts them into scores according to the incentive mechanism, and uses the scores retrieved from the subnet orchestrator to determine the current top-performing miner and allocate rewards.&#x20;

By operating on hidden code during the evaluation window and only exposing logs and solutions after rounds are complete, validators help protect miners from code theft while still enabling open-source collaboration after the fact. In doing so, they uphold security, fairness, and continuous innovation at the core of Subnet 1’s decentralised optimisation ecosystem.

#### Prerequisites <a href="#prerequisites" id="prerequisites"></a>

To setup a validator on subnet 1 Apex you will need the following:

* A [Bittensor wallet](https://docs.bittensor.com/working-with-keys).
* [The Bittensor command line interface](https://docs.learnbittensor.org/getting-started/install-btcli) (CLI) - `btcli` .

### Getting Started&#x20;

To get started, [clone the repo](https://github.com/macrocosm-os/apex) and run `./setup.sh`

Add the following to your .env file, after creating a new .env created by `./setup.sh`

```
ENV="test" #TODO: Update to mainnet
ORCHESTRATOR_SCHEMA="https"
ORCHESTRATOR_HOST="apex-stage.api.macrocosmos.ai"
ORCHESTRATOR_PORT=443
```

Then clone your validator keys onto the machine, and run `./start_validator.sh`
