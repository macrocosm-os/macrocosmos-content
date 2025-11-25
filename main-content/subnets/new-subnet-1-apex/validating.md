# Validating

#### Prerequisites <a href="#prerequisites" id="prerequisites"></a>

To setup a validator on subnet 1 Apex, you will need the following:

* A Registered [Bittensor wallet](https://docs.bittensor.com/working-with-keys) with at least 10k Alpha staked.

### Getting Started&#x20;

To get started, [clone the repo](https://github.com/macrocosm-os/apex) and run `./setup.sh` , activating it with `source .venv/bin/activate`

Add the following to your .env file, after creating a new .env created by `./setup.sh`

```
WALLET_NAME=""
WALLET_HOTKEY=""
```

Then clone your validator keys onto the machine, and run `./start_validator.sh`
