# Validating

#### Prerequisites <a href="#prerequisites" id="prerequisites"></a>

To setup a validator on subnet 1 Apex, you will need the following:

* A Registered [Bittensor wallet](https://docs.bittensor.com/working-with-keys) with at least 35k Alpha staked.

### Getting Started&#x20;

To get started, [clone the repo](https://github.com/macrocosm-os/apex), setup your .env file, and run `./start_validator.sh` , activating it with `source .venv/bin/activate`

Clone your validator keys, and add the following to your .env file.

```
WALLET_NAME=""
WALLET_HOTKEY=""
BITTENSOR=True
```

The default subtensor network is Finney. If you would like to use a local subtensor, add the following to your `.env`:

```
NETWORK=""
```

### Auto-updates with PM2

A validator auto-update script is located in the `scripts` folder. The script spawns a PM2 process which runs the validator, restarting when the repo has a new release.&#x20;

To run this script:

```
./scripts/start_autoupdater_pm2.sh
```

