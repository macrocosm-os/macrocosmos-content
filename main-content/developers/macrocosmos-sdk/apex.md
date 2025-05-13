---
description: >-
  Apex (SN1) enables developers to interact with decentralized LLMs and access
  web-retrieved responses.
---

# APEX

## Quickstart

Use `ApexClient` to send prompts to open-source language models like LLaMA and Mistral, or perform web-augmented completions using subnet-based retrieval.



### Chat Completions&#x20;

Send a prompt to an LLM on the Apex subnet.

{% tabs %}
{% tab title="Typescript" %}
```typescript
import { ApexClient } from 'macrocosmos';

// Initialize the client
const client = new ApexClient({ apiKey: 'your-api-key' });

// Chat completions
const response = await client.chat.completions.create({
  messages: [
    { role: 'system', content: 'You are a helpful assistant.' },
    { role: 'user', content: 'Hello, how are you?' }
  ],
  stream: true
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.ApexClient(api_key="api-key")
response = client.chat.completions.create(
    messages=[{"role": "user", "content": "Write a short story about a cosmonaut learning to paint."}],
)

print(response)
```
{% endtab %}
{% endtabs %}



**Body**

| Name       | Type   | Description                                            |
| ---------- | ------ | ------------------------------------------------------ |
| `messages` | string | A list of messages in chat format (`role`, `content`). |

**Response**

{% tabs %}
{% tab title="200" %}
```json
{
 id: "bdb39416-aac3-45b5-af90-c40197ff819b"
choices {
  finish_reason: "stop"
  message {
    content: "**The Starlight Brush**\n\nAs the Soyuz spacecraft soared through the cosmos, Cosmonaut Sergei gazed out the window at the endless expanse of stars. The weightlessness of space made his body feel free, but his mind was trapped in a world of calculations and routine checks. He longed for a creative outlet, something to express the beauty he witnessed every day.\n\nOne evening, while reviewing the ship\'s inventory, Sergei stumbled upon a forgotten art kit. The box was dusty, but the paints and brushes inside seemed untouched. He couldn\'t resist the urge to try. As he floated in front of the window, he dipped a brush into a vibrant shade of blue and began to paint.\n\nAt first, the strokes were clumsy, and the colors clashed. Sergei\'s lack of experience showed in every splatter. But he persisted, entranced by the way the paint danced in mid-air. With each passing day, his skills improved, and his art took on a life of its own.\n\nSergei\'s crewmates, Anatoly and Elena, were amazed by his transformation. They\'d never seen him so carefree, lost in the world of art. As they floated around him, they\'d offer words of encouragement, and Sergei would share his latest creations. The spacecraft became a studio, with canvases attached to the walls and paint-splattered brushes drifting through the air.\n\nOne night, as the stars aligned in a perfect crescent, Sergei set out to capture their beauty on canvas. He mixed shades of gold, silver, and purple, creating a palette that shimmered like the cosmos. The brushstrokes flowed effortlessly, as if guided by the celestial bodies themselves. When he finished, the painting glowed with an otherworldly light.\n\nAnatoly and Elena gasped as they beheld the masterpiece. \"Sergei, this is incredible!\" Anatoly exclaimed. Elena nodded, her eyes shining with tears. \"You\'ve captured the essence of our journey.\"\n\nThe painting, titled \"Stellar Odyssey,\" became a symbol of the crew\'s shared experience. As they gazed at the stars, they saw not just a sea of light, but a universe of possibility. Sergei\'s art had unlocked a new dimension, one that transcended the boundaries of space and time.\n\nWhen the Soyuz returned to Earth, Sergei\'s paintings were met with acclaim. The cosmonaut-turned-artist had discovered a new way to share the beauty of the cosmos with the world. As he looked up at the night sky, now a reminder of his time in space, Sergei smiled, knowing that the stars would forever be his muse.\n\n---\n\nI hope you enjoyed this short story about a cosmonaut learning to paint."
    role: "assistant"
  }
}
created: 1743701513
object: "chat.completion"
}
```
{% endtab %}

{% tab title="400" %}
```json
{
  "error": "Invalid request"
}
```
{% endtab %}
{% endtabs %}



### Web Search

Use Apex's integrated web retriever to fetch relevant content.

{% tabs %}
{% tab title="Typescript" %}
```javascript
import { ApexClient } from 'macrocosmos';

// Initialize the client
const client = new ApexClient({ apiKey: 'your-api-key' });

// Web retrieval
const webResults = await client.webRetrieval({
  query: 'latest news about AI'
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.ApexClient(api_key="api-key")
response = client.web_search.search(
    search_query="What is Bittensor?",
    n_results=3,
    max_response_time=20,
)

print(response)
```
{% endtab %}
{% endtabs %}

**Body**

| Name                | Type   | Description                                                                     |
| ------------------- | ------ | ------------------------------------------------------------------------------- |
| `search_query`      | string | The search term or natural language query.                                      |
| `n_results`         | int    | Number of search results to retrieve. Defaults to `3`                           |
| `max_response time` | int    | Maximum time (in seconds) to wait for subnet miner responses. Defaults to `20`. |

**Response**

{% tabs %}
{% tab title="200" %}
```json
{
  url: "https://bittensor.com/intro"
  content: "Bittensor Explained\nThere is no greater story than people\'s relentless and dogged endeavor to overcome repressive regimes. Whether we notice it or not, centralized firms, markets and authorities are engaged in a never-ending disempowerment of human people\'s autonomy. Bittensor is creating a new future for humanity, where new economies and new commodities are decentralized by design and where no single entity is a sole authority.\nAt the core of the Bittensor ecosystem is the production, marketing and selling of digital commodities. At the expanding periphery of this ecosystem are the entire internet geographies of ecosystems.\nEverything is decentralized. Digital commodities like compute, data, storage, predictions, and models are transformed into intelligence. When digital commodities are recast as intelligence, then new architectures are discovered, new commodities are produced and surprisingly cheaper ways to achieve innovations are being revealed—the possibilities are turning out to be limitless.\nTAO, the decentralized currency, fuels the production of this intelligence in subnets.These intelligence-producing subnets are then innovatively connected in productive and profitable ways, feeding one intelligence into another.\nEntrepreneurs with skills and ideas will use Bittensor when they are deprived of investments from traditional sources of capital. And most important, any such entrepreneur can participate profitably and thrive in the Bittensor ecosystem.\nYou can be a consumer of a subnet\'s digital commodity. Or if you are a subject-matter expert, for example an ML practitioner, then be a subnet miner, produce best predictions for your customer and earn TAO. Or, you can be a subnet validator, find markets, enterprises, small-businesses, application developers or end-users, for these digital products, generate revenue and earn TAO. Or you can just be a subnet owner and create fertile grounds for the growth of your subnet validators and subnet miners and earn TAO.\nCome join us and write your own decentralized economies into existence."
  relevant: "Bittensor Explained\nThere is no greater story than people\'s relentless and dogged endeavor to overcome repressive regimes. Whether we notice it or not, centralized firms, markets and authorities are engaged in a never-ending disempowerment of human people\'s autonomy. Bittensor is creating a new future for humanity, where new economies and new commodities are decentralized by design and where no single entity is a sole authority.\nAt the core of the Bittensor ecosystem is the production, marketing and selling of digital commodities. At the expanding periphery of this ecosystem are the entire internet geographies of ecosystems.\nEverything is decentralized. Digital commodities like compute, data, storage, predictions, and models are transformed into intelligence. When digital commodities are recast as intelligence, then new architectures are discovered, new commodities are produced and surprisingly cheaper ways to achieve innovations are being revealed—the possibilities are turning out to be limitless.\nTAO, the decentralized currency, fuels the production of this intelligence in subnets.These intelligence-producing subnets are then innovatively connected in productive and profitable ways, feeding one intelligence into another.\nEntrepreneurs with skills and ideas will use Bittensor when they are deprived of investments from traditional sources of capital. And most important, any such entrepreneur can participate profitably and thrive in the Bittensor ecosystem.\nYou can be a consumer of a subnet\'s digital commodity. Or if you are a subject-matter expert, for example an ML practitioner, then be a subnet miner, produce best predictions for your customer and earn TAO. Or, you can be a subnet validator, find markets, enterprises, small-businesses, application developers or end-users, for these digital products, generate revenue and earn TAO. Or you can just be a subnet owner and create fertile grounds for the growth of your subnet validators and subnet miners and earn TAO.\nCome join us and write your own decentralized economies into existence."
}
results {
  url: "https://docs.bittensor.com/"
  content: "Bittensor Documentation\nBittensor is an open source platform where participants produce best-in-class digital commodities, including compute power, storage space, artificial intelligence (AI) inference and training, protein folding, financial markets prediction, and many more.\nBittensor is composed of distinct subnets. Each subnet is an independent community of miners (who produce the commodity), and validators (who evaluate the miners\' work).\nThe Bittensor network constantly emits liquidity, in the form of its token, TAO (), to participants in proportion to the value of their contributions. Participants include:\n- Miners—Work to produce digital commodities. See mining in Bittensor.\n- Validators—Evaluate the quality of miners\' work. See validating in Bittensor\n- Subnet Creators—Manage the incentive mechanisms that specify the work miners and validate must perform and evaluate, respectively. See Create a Subnet\n- Stakers—TAO holders can support specific validators by staking TAO to them. See Staking.\nBrowse the subnets and explore links to their code repositories on Taostats\' subnets listings.\nParticipate\nYou can participate in an existing subnet as either a subnet validator or a subnet miner, or by staking your TAO to running validators.\nRunning a subnet\nReady to run your own subnet? Follow the below links.\nBittensor CLI, SDK, Wallet SDK\nUse the Bittensor CLI and SDK and Wallet SDK to develop and participate in the Bittensor network."
  relevant: "Bittensor Documentation\nBittensor is an open source platform where participants produce best-in-class digital commodities, including compute power, storage space, artificial intelligence (AI) inference and training, protein folding, financial markets prediction, and many more.\nBittensor is composed of distinct subnets. Each subnet is an independent community of miners (who produce the commodity), and validators (who evaluate the miners\' work).\nThe Bittensor network constantly emits liquidity, in the form of its token, TAO (), to participants in proportion to the value of their contributions. Participants include:\n- Miners—Work to produce digital commodities. See mining in Bittensor.\n- Validators—Evaluate the quality of miners\' work. See validating in Bittensor\n- Subnet Creators—Manage the incentive mechanisms that specify the work miners and validate must perform and evaluate, respectively. See Create a Subnet\n- Stakers—TAO holders can support specific validators by staking TAO to them. See Staking.\nBrowse the subnets and explore links to their code repositories on Taostats\' subnets listings.\nParticipate\nYou can participate in an existing subnet as either a subnet validator or a subnet miner, or by staking your TAO to running validators.\nRunning a subnet\nReady to run your own subnet? Follow the below links.\nBittensor CLI, SDK, Wallet SDK\nUse the Bittensor CLI and SDK and Wallet SDK to develop and participate in the Bittensor network."
}

```
{% endtab %}

{% tab title="400" %}
```json
{
  "error": "Invalid request"
}
```
{% endtab %}
{% endtabs %}



