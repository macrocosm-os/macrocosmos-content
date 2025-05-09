# Running Folding API Server

The Folding API provides protein folding capabilities through the Bittensor network. This API allows users to submit protein sequences for folding, query the status of folding jobs, and retrieve results. The service is designed to work with NVIDIA GPUs for optimal performance in protein folding computations.

#### **Requirements**

To ensure reliable and efficient MD simulations, please make sure your environment meets the following requirements:

* **GPU**: **NVIDIA RTX 4090** (recommended)\
  Required for protein folding workloads due to its high number of CUDA cores and strong performance with molecular dynamics tasks.\
  See our [reproducibility guidelines](https://github.com/macrocosm-os/mainframe/blob/main/documentation/molecular_dynamics/reproducibility.md) for more details on why this specific GPU is recommended.
* **Python**: Version **3.11** (for compatibility with Bittensor and OpenMM)
* **Conda**: For managing Python environments
* **Poetry**: For managing project dependencies

#### Installation&#x20;

1\. Clone the Repository

```bash
git clone https://github.com/macrocosm-os/mainframe.git
cd folding
```

#### 2. Install Conda

If you don't have Conda installed, run the following command:

```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh

# Initialize conda
source ~/miniconda3/bin/activate
conda init --all
```

#### 3. Create and Activate Conda Environment

```bash
# Create a new environment with Python 3.11
conda create --name folding python=3.11

# Activate the environment
conda activate folding
```

#### 4. Install Dependencies

```bash
# Install project dependencies using poetry
poetry install --with api

# Install the folding_api package in development mode
pip install -e .
```





### Running the API&#x20;

{% tabs %}
{% tab title="Testnet" %}
```javascript
python3.11 main.py --netuid 141 --subtensor.network test --wallet.name your_wallet_name --wallet.hotkey your_hotkey --gjp-address 167.99.209.27:4001
```
{% endtab %}

{% tab title="Mainnet" %}
```python
python3.11 main.py --netuid 25 --subtensor.network finney --wallet.name your_wallet_name --wallet.hotkey your_hotkey --gjp-address 167.99.209.27:4001
```
{% endtab %}
{% endtabs %}

Replace `your_wallet_name` and `your_hotkey` with your Bittensor wallet credentials.

### Global Job Pool (GJP) <a href="#global-job-pool-gjp" id="global-job-pool-gjp"></a>

The API queries the Global Job Pool (GJP) using SQL for job information:

* `/job_pool` endpoint executes SQL queries against the GJP database
* Results are parsed and transformed into appropriate response models
* Allows filtering by status, job IDs, and PDB ID search

The Global Job Pool also allows validators to distribute jobs and miners to fetch work. The following describes how miners interact with the GJP:

1. When your miner starts, it automatically connects to the read node
2. It maintains a local snapshot of the GJP in the `/db` directory
3. You can use `/scripts/query_rqlite.py` to examine and analyze data from the job pool

The interaction between miners and the GJP is facilitated by the `FoldingMiner` class, which handles job fetching, preparation, and execution.



### API Usage

1\. Accessing the API Documentation

Once the API is running, you can access:

* API server: http://0.0.0.0:8029
* You can edit server address to access Interactive API documentation: http://localhost:8029/docs

#### 2. Authentication

1. Locate the `api_keys.json` file in the folding folder
2. Copy your API key
3. In the Swagger UI (/docs), click "Authorize" and enter your API key
4. You can now make authenticated requests to the API

###

### Additional Notes

* The API requires an NVIDIA GPU with CUDA support for MD simulations&#x20;
* Regular system updates and proper CUDA configuration are essential
* Monitor system resources during folding operations
* Keep your API key secure and never share it publicly

