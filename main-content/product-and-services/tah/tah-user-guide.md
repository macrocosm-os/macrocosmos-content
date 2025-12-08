---
description: Plug in to power decentralised AI model training
---

# TAH User Guide

Training at Home (TAH) application allows you to connect and partake in our decentralized AI training platform [IOTA](../../subnets/subnet-9-iota/). You can plug in any hardware you have access to and earn rewards for powering decentralized AI model training.&#x20;

## Installation

To become a first beta tester of TAH application fill the form at [iota.macrocosmos.ai/train-at-home](http://iota.macrocosmos.ai/train-at-home). We are scaling the system and gradually rolling out to more users. Currently TAH only supports MacOS, with Linux support coming soon. Look at [Hardware & OS Requirements](hardware-requirements.md) for more details.

If you already have access, you can double click a `.dmg` file to install the app.&#x20;

We are still working on receiving notarization from Apple, therefore after opening the installed app you will be prompted with the warning "Apple could not verify "IOTA Train at Home.app" is free of malware that may harm your Mac or compromise your privacy.

<figure><img src="../../.gitbook/assets/Apple-warning.png" alt=""><figcaption></figcaption></figure>

To work around the warning follow the next steps:

1. Using Apple logo in the top left open **System Settings -> Privacy & Security**
2. Click on **"Open Anyway"** - the app should open correctly

<figure><img src="../../.gitbook/assets/Screenshot 2025-12-08 at 11.56.44.png" alt=""><figcaption></figcaption></figure>

Video below demonstrates installation process

{% embed url="https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FJDlWdmSC3GnzBPSkAiBM%2Fuploads%2FnxT5vvIvbkghk58drv46%2FTAH-security-workaround.mp4?alt=media&token=80315f68-e7f1-4d0d-869f-58fca6c64287" %}

## Operating TAH

Once the app is installed you should be able to see the main dashboard:

![TAH dashboard showing Start training and Connect controls](../../.gitbook/assets/image.png)

You’ll see metrics for your model, and in the center there will be a visualization of all the other participants in the training.

#### Main controls (top right of the screen)

* **Start training** (primary button): begins contributing your GPU/CPU to the current run. Click again to stop/exit the run.
* **Connect** (smaller button): optionally paste your wallet coldkey to receive rewards to that address. You can train without connecting; if you connect later, rewards accrue to the provided coldkey from that point forward.
* **Status pill**: shows whether your hardware is ready (e.g., “Connected • Your GPU is ready to contribute”). Resolve any warnings before starting.

#### Start a session

1. Launch the app and wait for the status pill to read **Connected**.
2. (Optional) Click **Connect**, paste your wallet coldkey, and save.
3. Click **Start training**. The run ID, model size, and layer count populate in the right panel; progress and tokens/hour graphs begin updating.
4. To stop, click **Start training** again (it toggles off) or quit the app.

#### Monitor while training

* **Run panel** (right): shows run ID, model size, layers, cumulative progress, and tokens/hour graph.
* **Network view** (center): visualizes peers and traffic; switch tabs (Network/Layer/Miner) for different views.
* **Loss chart** (bottom center): training loss over time; toggle Log/Linear and tokens/time axes.
* **Run Log** (bottom right): per-epoch/step logs; lock icon indicates read-only when idle.

#### Resource behavior

* The app uses available GPU/CPU once training starts. If you need to pause, toggle **Start training** off.
* Keep the laptop powered and on a stable network for steady rewards. Thermal throttling may reduce contribution; use a cooler or lower-power profile if needed.

#### Updates

* If an update is available, install the latest build before starting a new session for compatibility with the active run.

## Rewards

Beta Launch is operating with o rewards. Once the major version of TAH is published, the earnings will be calculated and paid as described below.

#### How Rewards Are Calculated

Rewards are primarily based on:

* The amount of tokens you contribute during training.
* How many times you contribute your model weights back to the network.
* Additional factors such as uptime, quality, and current network parameters.

Note: Exact weighting can evolve as the system updates.

#### Payout Cadence

* Payouts occur approximately every 24 hours; this window may be extended in the future.
* Minimum payout is **2 ALPHA**. Balances below the threshold roll over to the next payout.
* Network transfer costs are deducted from the amount you receive.
* To receive payouts, optionally connect a wallet by pasting your public coldkey (via the **Connect** button in the app). If you don’t connect, training still runs but rewards won’t be delivered to you; unconnected earnings are not paid retroactively.

#### Viewing Earnings

* In the app, click the **Miner** button (top left) to view your current earnings and contribution stats.

#### Taxes & Compliance

* You are responsible for complying with local tax and regulatory requirements related to rewards.

{% columns %}
{% column %}
For more questions use [FAQs](faqs.md)
{% endcolumn %}

{% column %}
If you have any issues use [TAH Support](../../subnets/subnet-9-iota/support.md)
{% endcolumn %}
{% endcolumns %}
