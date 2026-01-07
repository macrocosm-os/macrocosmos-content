---
description: >-
  Gravity is a decentralized data collection platform powered by SN13 (Data
  Universe) on the Bittensor network.
---

# Subnet 13 Data Universe API

## Get Started

To get started using Macrocosmos API you should:

1. Generate your API key using the instruction from the [API Keys](/broken/pages/O3pJKPdh5VoU7QLhjMfb) page
2. Ensure that you are using Python 3.9+ or Typescript

**📎 Supported Platforms**

* `reddit`
* `twitter` (X)

More platforms will be supported as subnet capabilities expand.

3. Install the Macrocosmos API using pip or npm:

{% tabs %}
{% tab title="Python" %}
```python
pip install macrocosmos
```
{% endtab %}

{% tab title="Typescript" %}
```javascript
npm install macrocosmos
```
{% endtab %}
{% endtabs %}

4. Macrocosmos API should be version 3.0.0. For upgrade use the command

{% tabs %}
{% tab title="Python" %}
```python
pip install macrocosmos==3.0.0
```
{% endtab %}

{% tab title="Typescript" %}
```javascript
npm install macrocosmos==2.1.1
```
{% endtab %}
{% endtabs %}

5. Choose `GravityClient` for sync tasks. Use `AsyncGravityClient` if async fits better.\
   Check [examples/gravity\_workflow\_example.py](https://github.com/macrocosm-os/macrocosmos-py/blob/main/examples/gravity_workflow_example.py) for a complete working example of a data collection CLI you can use for your next big project or to plug right into your data product.

### Demo Video

{% embed url="https://drive.google.com/file/d/1-vRJiFJv6JzXaqGsMrASKZMwN5fT8cp8/view?usp=drive_link" %}

## Data Universe API Endpoints

### Create a task for Data Collection

The task after the launch gets registered on the network within 20 min. The data is starting to be collected and delivered by miners from the moment of the registration on the Blockchain. The task stays live for 7 days to allow the most data to be collected. After that, the dataset gets built automatically. If you provided an email you’ll get a notification with a download link.&#x20;

To check the status of the task and the amount of data collected at any time use the endpoint [**Get status of the task**](gravity.md#get-status-of-task)**.** To start building the dataset prior the 7 days completion, use the endpoint [**Build dataset**](gravity.md#build-dataset).

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

To check the status of the task and the amount of data collected at any time use the endpoint Get status of the task.

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

No need to wait 7 days until the task is complete. If you already got enough data, you can request your dataset early. Add a notification to get alerted when the dataset is built. Once built, the task gets completed and de-registered.

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

client = mc.GravityClient(api_key="your-api-key")

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

Watch your dataset build with `GetDataset()`. Once built, the task gets completed and de-registered.&#x20;

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

response = client.gravity.GetDataset(dataset_id='your-dataset-id')

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

client = mc.GravityClient(api_key="your-api-key")

# Cancel a gravity task
response_grav = client.gravity.CancelGravityTask(
    gravity_task_id='your-gravity-task-id'
)

# Cancel a dataset
# response_data = client.gravity.CancelDataset(
#     dataset_id='your-dataset-id'
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

### Streaming API ( On Demand Data API)

Run precise, real-time queries using the synchronous `Sn13Client` to query historical or current data based on users, keywords, and time range on platforms like X (Twitter) Reddit, and YouTube.&#x20;

The Streaming API is limited to 1000 posts per request.

As of the latest data-universe [release](https://github.com/macrocosm-os/data-universe/releases):&#x20;

* &#x20;Users may select two post-filtering modes via the `keyword_mode` parameter:
  * `"any"` : Returns posts that contain any combination of the listed keywords.
  * `"all"` : Returns posts that contain all of the keywords (default, if field omitted).
* For Reddit requests, the first keyword in the list corresponds to the requested subreddit, and subsequent keywords are treated as normal.&#x20;
* For YouTube requests, the username field value must correspond to the YouTube channel name.
* URL mode is mutually exclusive with `usernames` and `keywords` fields. If `url` is provided, `usernames` and `keywords` must be empty.

{% tabs %}
{% tab title="Typescript" %}
```typescript
import { Sn13Client } from 'macrocosmos';

// Initialize the client
const client = new Sn13Client({apiKey: 'your-api-key'});

// Get the onDemandData response
const response = await client.onDemandData({
    source: 'X',                           // or 'Reddit', 'YouTube'
    usernames: ['nasa', 'spacex'],         // Optional, up to 5 users
    keywords: ['photo', 'space', 'mars'],  // Optional, up to 5 keywords
    startDate: '2024-04-01',               // Defaults to 24h range if not specified
    endDate: '2025-04-25',                 // Defaults to current time if not specified
    limit: 3,                              // Optional, up to 1000 results
    keywordMode: 'any',                    // Optional, 'any' or 'all'
});
```
{% endtab %}

{% tab title="Python" %}
```python
import macrocosmos as mc

client = mc.Sn13Client(api_key="your-api-key")

response = client.sn13.OnDemandData(
    source='X',                           # or 'Reddit', 'YouTube'
    usernames=["nasa", "spacex"],         # Optional, up to 5 users
    keywords=["photo", "space", "mars"],  # Optional, up to 5 keywords
    start_date='2024-04-01',              # Defaults to 24h range if not specified
    end_date='2025-04-25',                # Defaults to current time if not specified
    limit=3,                              # Optional, up to 1000 results
    keyword_mode='any'                    # Optional, 'any' or 'all'
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
    "limit": 3,
    "keyword_mode": "any"
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
    "limit": 3,
    "keyword_mode": "any"
  }' \
  constellation.api.cloud.macrocosmos.ai:443 \
  sn13.v1.Sn13Service/OnDemandData
```
{% endtab %}
{% endtabs %}

#### Body

| Name          | Type              | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ------------- | ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `source`      | string            | Data source (`X` or `Reddit`).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `usernames`   | Array of strings  | <p>Default: <code>[]</code></p><p></p><p>Number of items: <code>&#x3C;= 10 items</code></p><p></p><p>List of usernames to fetch data from. Searches for posts from <strong>any</strong> of the given usernames. </p><p></p><p>If <code>usernames</code> are not included, they will not be constrained in the search parameters. <br><br>For YouTube:<br>The item in the <code>usernames</code> field should correspond to the YouTube Channel name. Only one keyword (URL) OR one username (channel name) is allowed per request, not both. </p>                                                                                                                                               |
| `keywords`    | Array of strings  | <p>Default: <code>[]</code><br></p><p>Number of items: <code>&#x3C;= 5 items</code></p><p></p><p>List of keywords to search for. Searches for posts where <strong>all</strong> given keywords are present. </p><p></p><p>If <code>keywords</code> are not included in the query, they will not be constrained in the search parameters. <br><br>For Reddit: <br>The first keyword indicates the subreddit (r/all for cross-subreddit queries), and subsequent keywords are text matches. <br><br>For YouTube:<br>Enter a video URL as a YouTube keyword to request the transcript from that video. Only one keyword (URL) OR one username (channel name) is allowed per request, not both. </p> |
| `startDate`   | string            | <p><code>[Optional]</code></p><p></p><p>Start date or datetime (ISO format).<br><br>Defaults to 24 hours prior to the request time if not specified.<br><br>Datetimes without time information will be set to midnight (00:00:00) by default.</p><p>Datetimes without timezone information will be set to UTC by default. </p>                                                                                                                                                                                                                                                                                                                                                                  |
| `endDate`     | string            | <p><code>[Optional]</code></p><p></p><p>End date or datetime (ISO format).<br><br>Defaults to the request time if not specified.</p><p><br>Datetimes without time information will be set to midnight (00:00:00) by default. </p><p>Datetimes without timezone information will be set to UTC by default. </p>                                                                                                                                                                                                                                                                                                                                                                                  |
| `limit`       | integer           | <p><code>[Optional]</code></p><p></p><p>Default: <code>100</code></p><p></p><p>Options: <code>[1,...,1000]</code></p><p></p><p>Maximum number of items to return.</p>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `keywordMode` | string            | <p><code>[Optional]</code> <br><br>Default: <code>all</code> <br><br>Options: <code>all</code> , <code>any</code> <br><br>Selects the post-filtering mode:</p><ul><li><code>"any"</code>: Returns posts that contain any combination of the listed <code>keywords</code>.</li><li><code>"all"</code>: Returns posts that contain all of the <code>keywords</code></li></ul>                                                                                                                                                                                                                                                                                                                     |
| `url`         | string            | <p><code>[Optional]</code> <br><br>Single <code>url</code> for URL search mode (X or YouTube)<br><br>If <code>url</code> is provided, <code>usernames</code> and <code>keywords</code> must be empty or omitted.</p>                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |

#### Response

{% tabs %}
{% tab title="200" %}
{% code fullWidth="false" %}
```json
{
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
  ]
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

#### Request Examples

```
import macrocosmos as mc

client = mc.Sn13Client(api_key="your-api-key")

response = client.sn13.OnDemandData(
    source='YouTube',                     # Searches YouTube
    usernames=["mrbeast"],                # For videos from Mr Beast
    start_date='2024-08-01',              # From midnight 2024-08-01 UTC
                                          # To the time this request was made. 
    limit=10                              # For 10 items maximum
)

print(response)
```

```
import macrocosmos as mc

client = mc.Sn13Client(api_key="your-api-key")

response = client.sn13.OnDemandData(
    source='YouTube',                                          # Searches YouTube
    url="https://www.youtube.com/watch?v=pqwZ1mYM4v0",         # For the transcript corresponding to this video URL
)

print(response)
```

```
import macrocosmos as mc

client = mc.Sn13Client(api_key="your-api-key")

response = client.sn13.OnDemandData(
    source='Reddit',                      # Searches Reddit
    keywords=["r/astronomy", "space"],    # For posts/comments mentioning 'space', in the r/astronomy subreddit
                                          # In the default time range of the past 24 hours
    limit=50                              # For 50 items maximum
)

print(response)
```

```
import macrocosmos as mc

client = mc.Sn13Client(api_key="your-api-key")

response = client.sn13.OnDemandData(
    source='Reddit',                      # Searches Reddit
    keywords=["r/all", "space"],          # For posts/comments mentioning 'space', across all subreddits
    start_date='2025-04-01',              # From midnight 2025-04-01 UTC
    end_date='2025-04-02',                # To midnight 2025-04-02 UTC
    limit=50                              # For 50 items maximum
)

print(response)
```
