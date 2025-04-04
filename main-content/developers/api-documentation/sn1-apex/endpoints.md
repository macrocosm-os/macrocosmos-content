# Endpoints

We provide two primary API endpoints:

* `POST /v1/chat/completions`
* `POST /web_retrieval`

{% openapi src="../../../.gitbook/assets/openapisn1_updated.json" path="/v1/chat/completions" method="post" %}
[openapisn1_updated.json](../../../.gitbook/assets/openapisn1_updated.json)
{% endopenapi %}

`/v1/chat/completions` supports various inference strategies, which can be configured via the  request parameters.&#x20;

**Supported inference modes:**

* **Standard Chat Completion**
* **Multistep Reasoning**
* **Test-Time Inference**
* **Mixture of Miners**

It selects appropriate miners based on either explicitly provided `UIDs` or by applying internal filtering logic that matches miners to the task and model requirements.





{% openapi src="../../../.gitbook/assets/openapisn1new  (2).json" path="/web_retrieval" method="post" %}
[openapisn1new  (2).json](<../../../.gitbook/assets/openapisn1new  (2).json>)
{% endopenapi %}

&#x20;`/web_retrieval`enables distributed web search via a network of miners. A search query is dispatched to multiple miners, each of which performs an independent web retrieval process. The aggregated results are deduplicated based on URLs before being returned to the client.











