# Validating

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
