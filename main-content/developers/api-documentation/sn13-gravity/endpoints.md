# Endpoints

#### Base URL: `https://sn13.api.macrocosmos.ai`

We provide three primary API endpoints for SN13:

* **`POST /api/v1/on_demand_data_request`**
* **`GET /api/v1/list_repo_names`**
* **`POST /api/v1/set_desirabilities`**

***

{% openapi-operation spec="scraping" path="/api/v1/on_demand_data_request" method="post" %}
[Broken link](broken-reference)
{% endopenapi-operation %}

`POST /api/v1/on_demand_data_request`

This endpoint enables **real-time social data retrieval** across decentralized miners. It supports flexible querying with parameters such as keywords, usernames, timeframes, and data sources.

**Supported data sources:**

* `x` – Twitter-style content
* `reddit` – Subreddit-based or keyword-driven Reddit searches

You can retrieve posts from public accounts like **Elon Musk** , specifying a keyword (e.g. `"space"`) and a timeframe. The API will return relevant posts matching your query.

To search Reddit, simply change the `source` to `"reddit"` and use subreddit-style keywords like `"/bittensor"`.

\
Example usag&#x65;**:** [#on-demand-api-script](examples.md#on-demand-api-script "mention")



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
Example usage: [#list-hugging-face-repositories](examples.md#list-hugging-face-repositories "mention")
