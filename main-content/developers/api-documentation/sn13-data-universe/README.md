---
description: Getting started - Data Scraping on Macrocosms
---

# SN13 - Data Universe

**Gravity** is an on-demand data scraping application, allowing developers and business owners to access timely, relevant, and decentralized data from various sources like Twitter (X), Reddit, Youtube and Hugging Face repositories.

***

## What is Gravity?

**SN13 - Gravity** is designed for real-time data retrieval. You can:

* Fetch recent posts by accounts (e.g. Elon Musk mentioning "space")
* Search Reddit using keywords or specific subreddits
* Discover Hugging Face repositories deployed by miners
* Launch incentivized scraping tasks for specific keywords (miners get rewarded for collecting the data you request)

Try the visual interface at [**Mission Command**](https://app.macrocosmos.ai/mission-command)&#x20;

***

## Base URL: `https://sn13.api.macrocosmos.ai`

The SN13 Gravity API is designed for data collection across social platforms, including Reddit and Twitter (X). You can create data collection tasks, monitor their progress, build and retrieve structured datasets upon completion. Each task is registered on the network and remains active for seven days, after which the compiled dataset becomes available for download. You can access these operations through the `GravityClient` in the [macrocosmos-sdk](../../macrocosmos-sdk/ "mention").

***

## Gravity's APIs

The SN13 API is organized around a few endpoints:

* **POST** `/api/v1/on_demand_data_request`\
  Query X or Reddit for real-time, validated posts matching keywords, usernames, and timeframes.
* **POST** `/api/v1/set_desirabilities`\
  Create tasks that miners will prioritize scraping.
* **GET** `/api/v1/list_repo_names`\
  List Hugging Face models published by SN13 miners.

***

## **Rate limits**&#x20;

Regular API keys: Limited to 100 requests per hour\
Validator key: Limited to 1000 requests per hour



### Need Help?

Join the [**Macrocosmos Discord**](https://discord.gg/sXJPmGTnVR) and drop into the `#sn13-data-universe` channel — we’re happy to help you get started.
