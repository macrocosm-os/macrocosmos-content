---
description: Subnet 13 incentive overview
---

# Subnet 13 Incentive Mechanism

Subnet 13 is Bittensor’s decentralized data layer, focused on the collection, and distribution of fresh, desirable data. Incentive mechanism rewards miners for providing successfully validated, non-duplicate, fresh data. There are two main parts that make up a miner’s total scaled score: their raw score and their credibility.

To maximise their raw scores, miners either scrape data according to their own preferences (with a value equal to our default scale factor, which is currently set 0.075), or scrape data from dynamically specified labels that validators can submit with the [validator API](https://github.com/macrocosm-os/data-universe/tree/main/vali_utils/api).&#x20;

Desirable content, based on the following:

* Source of the data,
* Specific categories of data within that source, such as hashtags, keywords, etc,
* The age of the data,
* Data uniqueness.

Validator voting power is proportional to the amount they have currently staked on subnet 13, and indicates the amount the custom label will be incentivised for. From this incentivised list, miners can choose labels to scrape and receive significantly higher reward for returning data with required labels. This mechanism allows validators with significant subnet stake to leverage their bandwidth and request large amounts of fresh data for use in analytics, training, and more.&#x20;

To maximise their credibility, miners must provide data that matches a real-time scrape. This is determined by an exponential moving average based on the percentage of successfully validated bytes. The scaled score is heavily reliant on credibility– raw scores are multiplied by credibility of 2.5, so this is key to miner success on the network. Credibility is such an important mechanism on the network because unreliable data is worthless. Keeping miners accountable for failed validation keeps data on SN13 fresh and trustworthy.&#x20;

Miners upload scraped data to S3 via presigned URLs obtained from an auth server. Validators retrieve and validate this data through pagination-supported S3 access, performing comprehensive checks on format, content, and quality. For more details see [S3 Storage & Validation](https://github.com/macrocosm-os/data-universe/blob/main/docs/s3_validation.md).

Final Score Formula

```
Final Score = (Raw Data Score + S3 Boost + OnDemand Boost) × Credibility^2.5
```

This formula combines three revenue sources and applies an exponential credibility multiplier (exponent = 2.5) that severely penalizes unreliable miners.

**Raw Data Score Calculation (P2P Verification)**

The raw data score is calculated during p2p verification by the DataValueCalculator class, which sums the value of all data entity buckets in a miner’s index. Data source weights are applied only to this p2p raw score component, not to S3 or OnDemand boosts.

For each bucket, the score contribution is:

```
bucket_score = data_source_weight × job_weight × time_scalar × effective_scorable_bytes
```

The Data Source Weights sum to 1 and currently include Reddit and X. Label Scale Factors determine the weight placed on certain subreddits and hashtags for Reddit and X respectively, ranging anywhere from 0-1. Age Scale Factors depend on content age, with data over 30 days old valued at 0.

Data Source Weight (P2P Only): Each platform has a fixed weight applied during p2p verification scoring:

| Source     | Weight     |
| ---------- | ---------- |
| Reddit     | 0.61 (61%) |
| X/Twitter  | 0.35 (35%) |
| YouTube    | 0.04 (4%)  |

Note: These weights are applied only to the raw p2p data score. S3 and OnDemand boosts are not weighted by data source.

S3 upload validation details can be found in [S3 Validation](https://github.com/macrocosm-os/data-universe/blob/main/docs/s3_validation.md).

For more information, see our [reward model in GitHub](https://github.com/macrocosm-os/data-universe/tree/main/rewards), and our [miner reward evaluation details](https://github.com/macrocosm-os/data-universe/blob/main/rewards/miner_scorer.py#L131).
