# Endpoints

#### Base URL: `https://sn13.api.macrocosmos.ai`

We provide three primary API endpoints for SN13:

* **`POST /api/v1/on_demand_data_request`**
* **`GET /api/v1/list_repo_names`**
* **`POST /api/v1/set_desirabilities`**

***

{% openapi-operation spec="scraping" path="/api/v1/on_demand_data_request" method="post" %}
[OpenAPI scraping](https://4401d86825a13bf607936cc3a9f3897a.r2.cloudflarestorage.com/gitbook-x-prod-openapi/raw/de63f9c982edb108e8da852c36dd18657edeb149ed8f9b0019ddcfc88f14b429.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=dce48141f43c0191a2ad043a6888781c%2F20251203%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20251203T101618Z&X-Amz-Expires=172800&X-Amz-Signature=081ed6527837fc46e4282021ac7858ed056939f1cc308405adc50a20796db782&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject)
{% endopenapi-operation %}

`POST /api/v1/on_demand_data_request`

This endpoint enables **real-time social data retrieval** across decentralized miners. It supports flexible querying with parameters such as keywords, usernames, timeframes, and data sources.

**Supported data sources:**

* `x` – Twitter-style content
* `reddit` – Subreddit-based or keyword-driven Reddit searches

You can retrieve posts from public accounts like **Elon Musk** , specifying a keyword (e.g. `"space"`) and a timeframe. The API will return relevant posts matching your query.

To search Reddit, simply change the `source` to `"reddit"` and use subreddit-style keywords like `"/bittensor"`.

\
Example usag&#x65;**:** [Broken link](/broken/pages/OeUoaAQ7gV0C35bDEKsd#on-demand-api-script "mention")



{% openapi src="../../../.gitbook/assets/openapi.sn13.json" path="/api/v1/set_desirabilities" method="post" %}
[openapi.sn13.json](../../../.gitbook/assets/openapi.sn13.json)
{% endopenapi %}

#### `POST /api/v1/set_desirabilities`

This endpoint allows you to define **scraping tasks** that direct miners to focus on specific keywords or hashtags. These tasks help guide the network's attention and incentivize participation , miners receive increased rewards for successfully scraping content associated with your task.





{% openapi src="../../../.gitbook/assets/openapi.sn13.json" path="/api/v1/list_repo_names" method="get" %}
[openapi.sn13.json](../../../.gitbook/assets/openapi.sn13.json)
{% endopenapi %}

#### `GET /api/v1/list_repo_names`

SN13 miners contribute to the open-source ecosystem by publishing models on Hugging Face. This endpoint returns a list of all repositories deployed by SN13 miners, enabling you to explore the tools and models built on the subnet.

\
Example usage: [Broken link](/broken/pages/OeUoaAQ7gV0C35bDEKsd#list-hugging-face-repositories "mention")
