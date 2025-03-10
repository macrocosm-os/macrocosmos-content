---
description: Subnet 1 incentive system overview
---

# Subnet 13: Incentive Mechanism

Subnet 13 incentive mechanism rewards miners for providing successfully validated, non-duplicate, fresh data. There are two main parts that make up a miner’s total scaled score: their raw score and their credibility.&#x20;

To maximise their raw scores, miners either scrape data according to their own preferences (with value equal to our default scale factor, which is currently set 0.5), or scrape data from dynamically specified labels that validators can submit with the [validator API](https://github.com/macrocosm-os/data-universe/tree/main/vali_utils/api). Validator voting power is proportional to the amount they have currently staked on Subnet 13, and is indicative of the amount the custom label will be incentivised. From this incentivised list, miners can choose labels to scrape and receive significantly higher reward for returning data with said labels. This mechanism allows validators with significant subnet stake to leverage their bandwidth and request large amounts of fresh data for use in analytics, training, and more.&#x20;

Miners will also be rewarded for their uploads to our data hub, currently set to Hugging Face (HF), which contribute to their raw score. These uploads enable Subnet 13 to have reliable, reputable publicly accessible open source data. HF Rewards, which are programmed to activate on Jan 27, 2025, consist of an up to 5 million score boost based on HF validation results. HF validation works similarly to local validation, in which miners are given reward based on the percentage of randomly chosen HF rows that are successfully re-scraped and validated. See the current [HF Scoring Update document](https://docs.google.com/document/d/1NzQy0DTuDsh2u_TgVhN_Qb2XXShROXKk9yp1c7cius8/edit?tab=t.0) for the latest status on planned changes.&#x20;

To maximise their credibility, miners must provide data that matches a real-time scrape. This is determined by an exponential moving average based off of the percentage of successfully validated bytes. The scaled score is heavily reliant on credibility– raw scores are multiplied by credibility2.5, so this is key to miner success on the network. Credibility is such an important mechanism on the network because unreliable data is worthless data. Keeping miners accountable for failed validation keeps data on Data Universe fresh and trustworthy.&#x20;

Subnet 13 Data Universe’s reward mechanism is based on the source, type and age of scraped data. This is separated into 2 parts, the scoring system and the credibility system.

<figure><img src="../../.gitbook/assets/Screenshot 2025-03-05 at 17.29.15.png" alt="" width="375"><figcaption></figcaption></figure>

Where:

* Σ represents the sum over all data entity buckets
* DSW: Data Source Weight (weight from DataSourceDesirability)
* LSF: Label Scale Factor (from label\_scale\_factors or default\_scale\_factor)
* ASF: Age Scale Factor (calculated based on data age)
* SB: Scorable Bytes
* C: Miner Credibility

The Data Source Weights sum to 1 and currently include Reddit and X. Label Scale Factors determine the weight placed on certain subreddits and hashtags for Reddit and X respectively, ranging anywhere from 0-1. Age Scale Factors depend on content age, with data over 30 days old valued at 0.

This total is then multiplied by the miner’s credibility to the power of 2.5, the credibility is calculated with an exponential moving average. Credibility is scored from 0-1 (worst to best). Good credibility is obtained by providing data that is successfully validated. This means that the data that the miner uploads has the right labels, matching size, etc. to the original, and that the original post hasn’t been deleted or misrepresented.

<figure><img src="../../.gitbook/assets/Screenshot 2025-03-05 at 17.29.21.png" alt="" width="360"><figcaption></figcaption></figure>

Where:

* C\_new: New credibility
* C\_old: Old credibility
* α: EMA alpha (set to 0.15 in the code)
* V: Validation score (percentage of valid bytes in the latest validation)

[Reward model in GitHub](https://github.com/macrocosm-os/data-universe/tree/main/rewards)

[Miner reward evaluation](https://github.com/macrocosm-os/data-universe/blob/main/rewards/miner_scorer.py#L131)
