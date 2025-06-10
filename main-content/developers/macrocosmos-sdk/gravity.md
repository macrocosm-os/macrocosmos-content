---
description: >-
  Gravity is a decentralized data collection platform powered by SN13 (Data
  Universe) on the Bittensor network.
---

# Subnet 13 Gravity API

Quickstart

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
  gravityTasks: [
      { platform: 'x', topic: '#ai' },
      { platform: 'reddit', topic: 'r/MachineLearning' }
    ],
  name: 'My Data Collection Task',
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

client = mc.GravityClient(api_key="your-api-key")

gravity_tasks = [
    {"platform": "x", "topic": "#ai"},
    {"platform": "reddit", "topic": "r/MachineLearning"},
]

notification = {
    "type": "email",
    "address": "user@example.com",
    "redirect_url": "https://app.macrocosmos.ai/",
}

response =  client.gravity.CreateGravityTask(
    gravity_tasks=gravity_tasks, name="My First Gravity Task", notification_requests=[notification]
)

# Print the gravity task ID
print(response)
```
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "gravity_tasks": [
      {
        "topic": "#ai",
        "platform": "x"
      },
      {
        "topic": "r/MachineLearning",
        "platform": "reddit"
      }
    ],
    "name": "My First Gravity Task",
    "notification_requests": [
      {
        "type": "email",
        "address": "user@example.com",
        "redirect_url": "https://app.macrocosmos.ai/"
      }
    ]
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/gravity.v1.GravityService/CreateGravityTask
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{
    "gravity_tasks": [
      {
        "topic": "#ai",
        "platform": "x"
      },
      {
        "topic": "r/MachineLearning",
        "platform": "reddit"
      }
    ],
    "name": "My First Gravity Task",
    "notification_requests": [
      {
        "type": "email",
        "address": "user@example.com",
        "redirect_url": "https://app.macrocosmos.ai/"
      }
    ]
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  gravity.v1.GravityService/CreateGravityTask
```
{% endtab %}
{% endtabs %}

**Body**

| Name                   | Type                                  | Description                                                                              |
| ---------------------- | ------------------------------------- | ---------------------------------------------------------------------------------------- |
| `gravityTasks`         | List of `GravityTask` objects         | List of task objects. Each must include a `topic` and a `platform` (`x`, `reddit`, etc.) |
| `name`                 | string                                | Optional name for the Gravity task. Helpful for organizing jobs.                         |
| `notificationRequests` | List of `NotificationRequest` objects | List of notification configs. Supports `type`, `address`, and `redirect_url`.            |

**Response**

{% tabs %}
{% tab title="200" %}
```json
{
  "gravityTaskId": "multicrawler-9f518ae4-xxxx-xxxx-xxxx-8b73d7cd4c49"
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





### Get status of task

If you wish to get further information about the crawlers, you can use the `include_crawlers` flag or make separate `GetCrawler()` calls since returning in bulk can be slow.

{% tabs %}
{% tab title="Typescript" %}
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

client = mc.GravityClient(api_key="your-api-key")

response = client.gravity.GetGravityTasks(gravity_task_id="your-gravity-task-id", include_crawlers=False)

# Print the details about the gravity task and crawler IDs
print(response)
```
{% endcode %}
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "gravity_task_id": "your-gravity-task-id",
    "include_crawlers": false
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/gravity.v1.GravityService/GetGravityTasks
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{
    "gravity_task_id": "your-gravity-task-id",
    "include_crawlers": false
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  gravity.v1.GravityService/GetGravityTasks
```
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
  "gravityTaskStates": [
    {
      "gravityTaskId": "multicrawler-9f518ae4-xxxx-xxxx-xxxx-8b73d7cd4c49",
      "name": "My First Gravity Task",
      "status": "Running",
      "startTime": "2025-05-30T15:56:20.201500586Z",
      "crawlerIds": [
        "crawler-0-multicrawler-9f518ae4-xxxx-xxxx-xxxx-8b73d7cd4c49",
        "crawler-1-multicrawler-9f518ae4-xxxx-xxxx-xxxx-8b73d7cd4c49"
      ]
    }
  ]
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
  crawlerId: 'your-crawler-id',
  notificationRequests: [
    { type: 'email', 
      address: 'user@example.com', 
      redirect_url: 'https://app.macrocosmos.ai/'
      }
  ],
  maxRows: 100,
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.GravityClient(api_key="<your-api-key>")

notification = {
    "type": "email",
    "address": "user@example.com",
    "redirect_url": "https://app.macrocosmos.ai/"
}

response = client.gravity.BuildDataset(
    crawler_id="your-crawler-id", 
    notification_requests=[notification],
    max_rows=100
)

# Print the dataset ID
print(response)
```
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "crawler_id": "your-crawler-id",
    "notification_requests": [
      {
        "type": "email",
        "address": "user@example.com",
        "redirect_url": "https://app.macrocosmos.ai/"
      }
    ],
    "max_rows": 100
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/gravity.v1.GravityService/BuildDataset
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{
    "crawler_id": "your-crawler-id",
    "notification_requests": [
      {
        "type": "email",
        "address": "user@example.com",
        "redirect_url": "https://app.macrocosmos.ai/"
      }
    ],
    "max_rows": 100
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  gravity.v1.GravityService/BuildDataset
```
{% endtab %}
{% endtabs %}

**Body**

| Name                   | Type                                  | Description                                                                                              |
| ---------------------- | ------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `crawlerId`            | string                                | The ID of the completed crawler job you want to convert into a dataset.                                  |
| `notificationRequests` | List of `NotificationRequest` objects | A list of notification objects (e.g., email or webhook). Includes `type`, `address`, and `redirect_url`. |
| `maxRows`              | int                                   | The maximum number of rows to include in the dataset                                                     |

**Response**

{% tabs %}
{% tab title="200" %}
```json
{
  "datasetId": "dataset-71e97cfa-xxxx-xxxx-xxxx-33cd91be9028",
  "dataset": {
    "crawlerWorkflowId": "crawler-0-multicrawler-b56179b1-xxxx-xxxx-xxxx-0ffd616ad830",
    "status": "Running",
    "statusMessage": "Initializing",
    "totalSteps": "10"
  }
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
  datasetId: 'your-dataset-id'
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.GravityClient(api_key="your-api-key")

response = client.gravity.GetDataset(datasetId: 'your-dataset-id')

# Print the details about the gravity task and crawler IDs
print(response)
```
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "dataset_id": "your-dataset-id"
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/gravity.v1.GravityService/GetDataset
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{
    "dataset_id": "your-dataset-id"
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  gravity.v1.GravityService/GetDataset
```
{% endtab %}
{% endtabs %}

#### Body

| Name        | Type   | Description           |
| ----------- | ------ | --------------------- |
| `datasetId` | string | The ID of the dataset |

#### Response

{% tabs %}
{% tab title="200" %}
```json
{
  "dataset": {
    "crawlerWorkflowId": "crawler-0-multicrawler-b56179b1-xxxx-xxxx-xxxx-0ffd616ad830",
    "createDate": "2025-06-04T10:31:38.747918Z",
    "expireDate": "2025-07-04T10:31:38.747933Z",
    "files": [
      {
        "fileName": "x_ai_0.parquet",
        "fileSizeBytes": "261100",
        "lastModified": "2025-06-04T10:31:28.770Z",
        "numRows": "478",
        "s3Key": "example-s3-key",
        "url": "example-url"
      }
    ],
    "status": "Completed",
    "statusMessage": "Dataset ready for download",
    "steps": [
      {
        "progress": 1,
        "step": "1",
        "stepName": "Registering dataset"
      },
      {
        "progress": 1,
        "step": "2",
        "stepName": "Collecting crawler information"
      },
      {
        "progress": 1,
        "step": "3",
        "stepName": "Collecting available data sources"
      },
      {
        "progress": 1,
        "step": "4",
        "stepName": "Validating data sources"
      },
      {
        "progress": 1,
        "step": "5",
        "stepName": "Collating data"
      },
      {
        "progress": 1,
        "step": "6",
        "stepName": "Creating dataset path"
      },
      {
        "progress": 1,
        "step": "7",
        "stepName": "Extracting data"
      },
      {
        "progress": 1,
        "step": "8",
        "stepName": "Consolidate dataset"
      },
      {
        "progress": 1,
        "step": "9",
        "stepName": "Publish dataset"
      },
      {
        "progress": 1,
        "step": "10",
        "stepName": "Cleaning up"
      }
    ],
    "totalSteps": "10",
    "nebula": {
      "fileSizeBytes": "795061",
      "url": "example-url"
    }
  }
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
  gravityTaskId: 'your-gravity-task-id'
});

// Cancel a dataset build
// const cancelDataset = await client.cancelDataset({
//   datasetId: 'your-dataset-id'
// });
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.GravityClient(api_key="<your-api-key>")

# Cancel a gravity task
response_grav = client.gravity.CancelGravityTask(
    gravity_task_id: 'your-gravity-task-id'
)

# Cancel a dataset
# response_data = client.gravity.CancelDataset(
#     datasetId: 'your-dataset-id'
#)

# Print the dataset ID
print(response_grav)
```
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "gravity_task_id": "your-gravity-task-id"
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/gravity.v1.GravityService/CancelGravityTask
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{
    "gravity_task_id": "your-gravity-task-id"
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  gravity.v1.GravityService/CancelGravityTask
```
{% endtab %}
{% endtabs %}

#### Body

| Name                           | Type   | Description               |
| ------------------------------ | ------ | ------------------------- |
| `gravityTaskId` (`datasetId`)  | string | Gravity task (dataset) Id |

#### Response

{% tabs %}
{% tab title="200" %}
```json
{
  "message": "success"
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

### On demand data

Run precise, real-time queries against platforms like X (Twitter) and Reddit (YouTube forthcoming), using the synchronous `Sn13Client` to query historical or current data based on users, keywords, and time range

{% tabs %}
{% tab title="Typescript" %}
```typescript
import { Sn13Client } from 'macrocosmos';

// Initialize the client
const client = new Sn13Client({apiKey: 'your-api-key'});

// Get the onDemandData response
const response = await client.onDemandData({
    source: 'X',                           // or 'Reddit'
    usernames: ['nasa', 'spacex'],         // Optional, up to 5 users
    keywords: ['photo', 'space', 'mars'],  // Optional, up to 5 keywords
    startDate: '2024-04-01',               // Defaults to 24h range if not specified
    endDate: '2025-04-25',                 // Defaults to current time if not specified
    limit: 3                               // Optional, up to 1000 results
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.Sn13Client(api_key="your-api-key")

response = client.sn13.OnDemandData(
    source='X',                           # or 'Reddit'
    usernames=["nasa", "spacex"],         # Optional, up to 5 users
    keywords=["photo", "space", "mars"],  # Optional, up to 5 keywords
    start_date='2024-04-01',              # Defaults to 24h range if not specified
    end_date='2025-04-25',                # Defaults to current time if not specified
    limit=3                               # Optional, up to 1000 results
)

print(response)
```
{% endtab %}

{% tab title="Constellation API: curl" %}
```bash
curl -H "Authorization: Bearer your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "source": "X",
    "usernames": ["nasa", "spacex"],
    "keywords": ["photo", "space", "mars"],
    "start_date": "2024-04-01",
    "end_date": "2025-04-25",
    "limit": 3
  }' \
  https://constellation.api.cloud.macrocosmos.ai\
/sn13.v1.Sn13Service/OnDemandData
```
{% endtab %}

{% tab title="Constellation API: grpcurl" %}
```bash
grpcurl -H "Authorization: Bearer your-api-key" \
  -d '{
    "source": "X",
    "usernames": ["nasa", "spacex"],
    "keywords": ["photo", "space", "mars"],
    "start_date": "2024-04-01",
    "end_date": "2025-04-25",
    "limit": 3
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  sn13.v1.Sn13Service/OnDemandData
```
{% endtab %}
{% endtabs %}

#### Body

| Name        | Type              | Description                                                                                                                                                                           |
| ----------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `source`    | string            | Data source (`X` or `Reddit`).                                                                                                                                                        |
| `usernames` | Array of strings  | <p>Default: <code>[]</code></p><p></p><p>Number of items: <code>&#x3C;= 10 items</code></p><p></p><p>List of usernames to fetch data from. If Default, random usernames selected.</p> |
| `keywords`  | Array of strings  | <p>Default: <code>[]</code><br></p><p>Number of items: <code>&#x3C;= 5 items</code></p><p></p><p>List of keywords to search for. If Default, random keywords are selected.</p>        |
| `startDate` | string            | <p><code>[Optional]</code></p><p></p><p>Start date (ISO format).</p>                                                                                                                  |
| `endDate`   | string            | <p><code>[Optional]</code></p><p></p><p>End date (ISO format).</p>                                                                                                                    |
| `limit`     | integer           | <p><code>[Optional]</code></p><p></p><p>Default: <code>100</code></p><p></p><p>Options: <code>[1,...,1000]</code></p><p></p><p>Maximum number of items to return.</p>                 |

#### Response

{% tabs %}
{% tab title="200" %}
{% code fullWidth="false" %}
```json
{
  "status": "success",
  "data": [
    {
      "content": "Falcon 9 launches the Bandwagon-3 rideshare mission to orbit from Florida",
      "datetime": "2025-04-22T03:00:38+00:00",
      "label": null,
      "media": [
        {
          "type": "photo",
          "url": "https://pbs.twimg.com/media/GpG2kuBagAADw92.jpg"
        },
        {
          "type": "photo",
          "url": "https://pbs.twimg.com/media/GpG2kuDa4AEr1RV.jpg"
        },
        {
          "type": "photo",
          "url": "https://pbs.twimg.com/media/GpG2kuBbUAAU7Rd.jpg"
        },
        {
          "type": "video",
          "url": "https://pbs.twimg.com/amplify_video_thumb/1914512114154409984/img/lD1axdjW7cRnRol6.jpg"
        }
      ],
      "source": "X",
      "tweet": {
        "conversation_id": "1914514653763584254",
        "hashtags": [],
        "id": "1914514653763584254",
        "is_quote": false,
        "is_reply": false,
        "is_retweet": false,
        "like_count": 10689,
        "quote_count": 76,
        "reply_count": 677,
        "retweet_count": 2058
      },
      "uri": "https://x.com/SpaceX/status/1914514653763584254",
      "user": {
        "display_name": "SpaceX",
        "followers_count": 39073448,
        "following_count": 121,
        "id": "34743251",
        "username": "@SpaceX",
        "verified": false
      }
    },
    {
      "content": "Falcon 9 launches NROL-145 from California, completing our first of the new national security missions awarded in October 2024",
      "datetime": "2025-04-20T17:05:09+00:00",
      "label": null,
      "media": [
        {
          "type": "photo",
          "url": "https://pbs.twimg.com/media/Go_mYDJbIAA9mbK.jpg"
        },
        {
          "type": "video",
          "url": "https://pbs.twimg.com/amplify_video_thumb/1914001831661084672/img/ydKPVd7KoS6B6U_l.jpg"
        }
      ],
      "source": "X",
      "tweet": {
        "conversation_id": "1914002408545615936",
        "hashtags": [],
        "id": "1914002408545615936",
        "is_quote": false,
        "is_reply": false,
        "is_retweet": false,
        "like_count": 8190,
        "quote_count": 71,
        "reply_count": 495,
        "retweet_count": 1802
      },
      "uri": "https://x.com/SpaceX/status/1914002408545615936",
      "user": {
        "display_name": "SpaceX",
        "followers_count": 39073448,
        "following_count": 121,
        "id": "34743251",
        "username": "@SpaceX",
        "verified": false
      }
    }
  ],
  "meta": {
    "consistent_miners": 2,
    "inconsistent_miners": 0,
    "items_returned": 2,
    "miner_hotkey": "5CacbhmQxhAVGWgrYvCypqhR3n3mNmmWEA8JYzAVghmTDYZy",
    "miner_uid": 179,
    "miners_queried": 5,
    "miners_responded": 5,
    "source": "consistent",
    "validated_miners": 0
  }
}
```
{% endcode %}
{% endtab %}

{% tab title="400" %}
```bash
{
  "error": "Invalid request"
}
```
{% endtab %}
{% endtabs %}

