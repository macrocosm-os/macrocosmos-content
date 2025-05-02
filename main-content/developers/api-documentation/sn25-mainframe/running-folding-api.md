---
hidden: true
---

# Running Folding API



Core software requirements include:

```
conda
poetry 
```



1. To start, simply clone this repository:

```
git clone https://github.com/macrocosm-os/folding.git
cd folding
```



2. Next, install Conda:

```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh

source ~/miniconda3/bin/activate
conda init --all
```



3. We use a combination of `conda` and `poetry` to manage our environments. It is very important to create the environment with python 3.11 as this is necesssary for `bittensor` and `openmm`

```
conda create --name folding python=3.11
```



4.

```
poetry install --with api
```



5.

```
conda activate folding 
```



6. folding\_api isn't included in the pyproject.toml and needs to be installed separately. Let's fix this:

```
pip3.11 install -e .
```







7.

```
poetry install --with api
```



8.

```
python3.11 folding_api/main.py --netuid 141 --subtensor.network test --wallet.name xxxx --wallet.hotkey xxxx --gjp-address 167.99.209.27:4001
```



python neurons/validator.py\
\--netuid <25/141>\
\--subtensor.network \<finney/test>\
\--wallet.name # Must be created using the bittensor-cli\
\--wallet.hotkey # Must be created using the bittensor-cli\
\--axon.port #VERY IMPORTANT: set the port to be one of the open TCP ports on your machine

\--gjp-address 167.99.209.27:4001 (tesnet global job pool)&#x20;



9.

You should get a link in the resposne like this `Uvicorn running on http://0.0.0.0:8029` \
Click the link . You can also edit the link to [http://localhost:8029/docs](http://localhost:8029/docs) - opening up the fastapi documentation for api testing.&#x20;

You can see all the endpoints&#x20;



10.

In order to pass a request , you need an API key . Navigate to `api_keys.json` located in the `folding` folder and copy your api key .



11.

If you navigate back to the docs with your copied api key and click authorize, you'll be able to make requests&#x20;

