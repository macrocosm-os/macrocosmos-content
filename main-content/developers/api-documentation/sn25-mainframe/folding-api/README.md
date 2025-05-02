# Folding API

The Folding API provides a HTTP interface for external clients to interact with the Bittensor Folding Subnet (Subnet 25). It enables programmatic submission of protein folding jobs, querying job status, and retrieving results from the network of validators and miners that perform protein folding simulations. It is implemented using FastAPI and integrates with several core components of the subnet system.

### Core components&#x20;

#### Validator Registry <a href="#validatorregistry" id="validatorregistry"></a>

Maintains a registry of available validators on the network, tracks their status, and provides methods to select validators based on availability and stake.

#### Subtensor Service <a href="#subtensorservice" id="subtensorservice"></a>

Interfaces with the Bittensor blockchain to synchronize the metagraph and retrieve validator information.

#### Authentication System <a href="#authentication-system" id="authentication-system"></a>

Uses API keys for authentication and rate limiting of requests.

#### Request Flow

When a client submits a folding job request, the following sequence occurs:

<figure><img src="../../../../.gitbook/assets/Screenshot 2025-05-02 at 07.44.31.png" alt=""><figcaption></figcaption></figure>

### Data Models <a href="#data-models" id="data-models"></a>

The API uses several core data models defined using Pydantic: [https://github.com/macrocosm-os/mainframe/blob/61136333/folding\_api/schemas.py#L12-L259](https://github.com/macrocosm-os/mainframe/blob/61136333/folding_api/schemas.py#L12-L259)







