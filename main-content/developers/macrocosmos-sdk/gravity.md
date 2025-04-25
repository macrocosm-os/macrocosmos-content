---
description: >-
  Gravity is a decentralized data collection platform powered by SN13 (Data
  Universe) on the Bittensor network.
---

# Gravity

## Quickstart

Choose `GravityClient` for sync tasks. Use `AsyncGravityClient` if async fits better.\
Check [examples/gravity\_workflow\_example.py](https://github.com/macrocosm-os/macrocosmos-py/blob/main/examples/gravity_workflow_example.py) for a complete working example of a data collection CLI you can use for your next big project or to plug right into your favorite data product.



**📎 Supported Platforms**

* `reddit`
* `twitter` (X)

More platforms will be supported as subnet capabilities expand.



### Create a task for Data Collection

Each task gets registered on the network. Miners begin work right away. The task stays live for 7 days. After that, the dataset gets built automatically. You’ll get an email with a download link.\
Use any email you like.

{% tabs %}
{% tab title="Typescript" %}
{% code overflow="wrap" %}
```javascript
import { GravityClient } from 'macrocosmos';

// Initialize the client
const client = new GravityClient({ apiKey: 'your-api-key' });

// Create a new gravity task
const task = await client.createGravityTask({
  name: 'My Data Collection Task',
  gravityTasks: [
    { platform: 'x', topic: '#ai' },
    { platform: 'reddit', topic: 'r/ai' }
  ],
  notificationRequests: [
    { type: 'email', address: 'user@example.com', redirectUrl: 'https://example.com/datasets' }
  ]
});
```
{% endcode %}
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.GravityClient(api_key="<your-api-key>")

gravity_tasks = [
    {"topic": "#ai", "platform": "x"},
    {"topic": "r/MachineLearning", "platform": "reddit"},
]

notification = {
    "type": "email",
    "address": "<your-email-address>",
    "redirect_url": "https://app.macrocosmos.ai/",
}

response =  client.gravity.CreateGravityTask(
    gravity_tasks=gravity_tasks, name="My First Gravity Task", notification_requests=[notification]
)

# Print the gravity task ID
print(response)
```
{% endtab %}
{% endtabs %}





**Body**

| Name             | Type   | Description                                                                              |
| ---------------- | ------ | ---------------------------------------------------------------------------------------- |
| `gravity_tasks`  | string | List of task objects. Each must include a `topic` and a `platform` (`x`, `reddit`, etc.) |
| `name`           | string | Optional name for the Gravity task. Helpful for organizing jobs.                         |
| `notification`   | string | List of notification configs. Supports `type`, `address`, and `redirect_url`.            |

**Response**

{% tabs %}
{% tab title="200" %}
```json
gravity_task_id: "multicrawler-53ba1f6e-e31b-437c-9033-956e1e756198"
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





### Get status of task

If you wish to get further information about the crawlers, you can use the `include_crawlers` flag or make separate `GetCrawler()` calls since returning in bulk can be slow.

{% tabs %}
{% tab title="JavaScript" %}
```javascript
import { GravityClient } from 'macrocosmos';

// Initialize the client
const client = new GravityClient({ apiKey: 'your-api-key' });

/ List all gravity tasks
const tasks = await client.getGravityTasks({
  includeCrawlers: true
});

// Get a specific crawler
const crawler = await client.getCrawler({
  crawlerId: 'crawler-id'
});

```
{% endtab %}

{% tab title="Python" %}
{% code overflow="wrap" %}
```python
import macrocosmos as mc

client = mc.GravityClient(api_key="<your-api-key>")

response = client.gravity.GetGravityTasks(gravity_task_id="<your-gravity-task-id>", include_crawlers=False)

# Print the details about the gravity task and crawler IDs
print(response)
```
{% endcode %}
{% endtab %}
{% endtabs %}

**Body**

| Name               | Type    | Description                                                                     |
| ------------------ | ------- | ------------------------------------------------------------------------------- |
| `gravity_task_id`  | string  | The unique identifier of the Gravity task you want to inspect.                  |
| `include_crawlers` | bool    | Whether to include details of the associated crawler jobs. Defaults to `False`. |

**Response**

{% tabs %}
{% tab title="200" %}
```json
{
 
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





### Build dataset&#x20;

No need to wait 7 days. You can request your dataset early. Add a notification to get alerted when it's ready.&#x20;

{% tabs %}
{% tab title="TypeScript" %}
```javascript
import { GravityClient } from 'macrocosmos';

// Initialize the client
const client = new GravityClient({ apiKey: 'your-api-key' });


// Build a dataset from a crawler
const dataset = await client.buildDataset({
  crawlerId: 'crawler-id',
  notificationRequests: [
    { type: 'email', address: 'user@example.com' }
  ]
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.GravityClient(api_key="<your-api-key>")

notification = {
    "type": "email",
    "address": "<your-email-address>",
    "redirect_url": "https://app.macrocosmos.ai/",
}

response = client.gravity.BuildDataset(
    crawler_id="<your-crawler-id>", notification_requests=[notification]
)

# Print the dataset ID
print(response)
```
{% endtab %}
{% endtabs %}

**Body**

| Name           | Type   | Description                                                                                              |
| -------------- | ------ | -------------------------------------------------------------------------------------------------------- |
| `notification` | string | A list of notification objects (e.g., email or webhook). Includes `type`, `address`, and `redirect_url`. |
| `crawler_id`   |        | The ID of the completed crawler job you want to convert into a dataset.                                  |

**Response**

{% tabs %}
{% tab title="200" %}
```json
{

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







### Get status of a build

Watch your dataset build with `GetDataset()`. Once built, the task gets de-registered.&#x20;

{% tabs %}
{% tab title="TypeScript" %}
```javascript
import { GravityClient } from 'macrocosmos';

// Initialize the client
const client = new GravityClient({ apiKey: 'your-api-key' });


// Get a dataset
const datasetStatus = await client.getDataset({
  datasetId: 'dataset-id'
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.GravityClient(api_key="<your-api-key>")

response = client.gravity.GetDataset(datasetId: 'dataset-id')

# Print the details about the gravity task and crawler IDs
print(response)
```
{% endtab %}
{% endtabs %}



### Cancel requests

Use `CancelDataset()` to stop a build. If it's done, that call will purge the dataset.

{% tabs %}
{% tab title="TypeScript" %}
```javascript
import { GravityClient } from 'macrocosmos';

// Initialize the client
const client = new GravityClient({ apiKey: 'your-api-key' });


// Cancel a gravity task
const cancelResult = await client.cancelGravityTask({
  gravityTaskId: 'task-id'
});

// Cancel a dataset build
const cancelDataset = await client.cancelDataset({
  datasetId: 'dataset-id'
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.GravityClient(api_key="<your-api-key>")

response = client.gravity.CancelDataset(
    datasetId: 'dataset-id'
)

# Print the dataset ID
print(response)
```
{% endtab %}
{% endtabs %}











