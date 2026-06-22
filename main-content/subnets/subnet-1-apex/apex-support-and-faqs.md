---
description: Frequently asked questions and Apex support channels
---

# Apex Support and FAQs

{% columns %}
{% column %}
![](../../.gitbook/assets/roket-icon.png) **Get started**

[Current Competitions](subnet-1-current-competitions/)

[Mining Guide](subnet-1-base-miner-setup/)

[Validation Guide](validating.md)
{% endcolumn %}

{% column %}
![](../../.gitbook/assets/contact-icon.png) **Contact us for support**

[Macrocosmos Discord](https://discord.gg/vRTaAXpRcd)

[Bittensor Discord](https://discord.com/channels/799672011265015819/1162768567821930597)

[Support Email](mailto:support@macrocosmos.ai)
{% endcolumn %}
{% endcolumns %}

### Mining

<details>

<summary>Where do I start?</summary>

Read the docs related to the [Apex subnet](../../) and [current competitions](subnet-1-current-competitions/). Have a look at the [Subnet 1 Mining](subnet-1-base-miner-setup/) page for setup guidance.&#x20;

</details>

<details>

<summary>How to test my miner locally?</summary>

Visit each of the [competition folders](https://github.com/macrocosm-os/apex/tree/main/shared/competition/src/competition) to see example submission formats as well as a baseline submission. Inside each competition-specific folder is also a ReadMe guide to get started.&#x20;

</details>

<details>

<summary>Where can I see my scores and other metrics?</summary>

Each competition has its own dashboard demonstrating relevant metrics. You can find them on the Apex website at [apex.macrocosmos.ai/](https://apex.macrocosmos.ai/) in the competition section. If you are registered on the subnet, you may also view your results and download files from the [Apex CLI](subnet-1-base-miner-setup/apex-cli.md).

</details>

### Submission Fees

<details>

<summary>How much are submission fees?</summary>

Submission fees are variable per competition. If a competition is not listed here, then it's free to submit to.

* RL Tron: $1.40 per submission
* Energy Arbitrage: $1.00 per submission
* Iota Simulator: $10.00 per submission

</details>

<details>

<summary>My submission was rejected. What happens to my fee?</summary>

If your submission was rejected, you can reuse the fee payment information on another submission. Resubmit with:

`apex submit --payment-block-hash [YOUR BLOCK HASH] --payment-extrinsic-index [YOUR EXTRINSIC INDEX]`&#x20;

</details>

<details>

<summary>Something went wrong with my submission fee payment. What can I do?</summary>

If your payment went through successfully, you will receive a receipt including the payment block hash and extrinsic index. You can resubmit your solution with the unused payment with:

\
`apex submit --payment-block-hash [YOUR BLOCK HASH] --payment-extrinsic-index [YOUR EXTRINSIC INDEX]`&#x20;

</details>

<details>

<summary>I don't have my payment receipt log. What can I do?</summary>

If you do not have this receipt log, you can retrieve your block hash and extrinsic index from [taostats](https://taostats.io/account/5EtauUg5ZyHYuRN8MP1hBSejvFjXsKoCKcDr3FJrdy8dZepK/transfers).&#x20;

* The extrinsic index is the number after the `-`  in the "Extrinsic" column, without any leading zeros.
  * i.e. Extrinsic: 8077100-0020 -> extrinsic index = 20.
* You can find the block number by clicking on the transaction details for an extrinsic.

\
To convert block number to block hash:

```
import bittensor as bt

print(bt.subtensor('wss://archive.chain.opentensor.ai:443').substrate.get_block_hash(YOUR_BLOCK_HASH))
```

</details>
