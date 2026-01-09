---
description: Using Macrocosmos MCP with Claude Desktop or Cursor
---

# Macrocosmos MCP

## Macrocosmos MCP

Using Macrocosmos MCP with Claude Desktop or Cursor

***

Macrocosmos MCP (Model Context Protocol) allows you to integrate with Data Universe APIs directly into Claude for Desktop, Cursor, or your custom LLM pipeline. Query **X (Twitter)** and **Reddit** data on demand from your AI environment!

### Prerequisites

* Python 3.10+
* `uv` package manager
* Claude Desktop or Cursor installed

### Install UV Package Manager

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Or via pip:

```bash
pip3 install uv
```

### Quickstart

1. Get your API key from [Macrocosmos](https://app.macrocosmos.ai/account?tab=api-keys). There is a free tier with $5 of credits to start.
2. Install `uv` using the command above or see the [uv repo](https://github.com/astral-sh/uv) for additional install methods.

***

### Configure Claude Desktop

Run the following command to open your Claude configuration file:

```bash
code ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

Update with this configuration:

```json
{
  "mcpServers": {
    "macrocosmos": {
      "command": "uvx",
      "args": ["macrocosmos-mcp"],
      "env": {
        "MC_API": "<insert-your-api-key-here>"
      }
    }
  }
}
```

Open Claude Desktop and look for the **hammer icon** — this confirms your MCP server is running. You'll now have SN13 tools available inside Claude.

***

### Configure Cursor

#### Option 1: Via UI (Recommended)

1. Go to **Cursor Settings**
2. Navigate to MCP settings and select **Add New Global MCP Server**
3. Enter the configuration details

#### Option 2: Manual JSON

```bash
code ~/Library/Application\ Support/Cursor/cursor_mcp_config.json
```

Add the same configuration:

```json
{
  "mcpServers": {
    "macrocosmos": {
      "command": "uvx",
      "args": ["macrocosmos-mcp"],
      "env": {
        "MC_API": "<insert-your-api-key-here>"
      }
    }
  }
}
```

> ⚠️ **Note:** In some cases, manually editing this file doesn't activate the MCP server in Cursor. If this happens, use the UI method above for best results.

#### Use Agent Mode

In Cursor, make sure you're using **Agent Mode** in the chat. Agents have the ability to use any MCP tool — including custom ones and those from SN13.

***

### Available Tools

#### Quick Query Tool

**`query_on_demand_data` - Real-time Social Media Queries**

Fetch real-time data from X (Twitter) and Reddit. Best for quick queries up to 1,000 results.

| Parameter      | Type   | Description                                                                          |
| -------------- | ------ | ------------------------------------------------------------------------------------ |
| `source`       | string | **REQUIRED**. Platform: `'X'` or `'REDDIT'` (case-sensitive)                         |
| `usernames`    | list   | Up to 5 usernames. For X: `@` is optional. Not available for Reddit                  |
| `keywords`     | list   | Up to 5 keywords/hashtags. For Reddit: subreddit names (e.g., `'r/MachineLearning'`) |
| `start_date`   | string | ISO format (e.g., `'2024-01-01T00:00:00Z'`). Defaults to 24h ago                     |
| `end_date`     | string | ISO format. Defaults to now                                                          |
| `limit`        | int    | Max results 1-1000. Default: 10                                                      |
| `keyword_mode` | string | `'any'` (default) or `'all'` for strict matching                                     |

**Example prompts:**

* "What has @elonmusk been posting about today?"
* "Get me the latest posts from r/bittensor about dTAO"
* "Fetch 50 tweets about #AI from the last week"

***

#### Large-Scale Collection Tools (Gravity)

Use Gravity tools when you need to collect large datasets over 7 days (more than 1,000 results).

**`create_gravity_task` - Start 7-Day Data Collection**

| Parameter | Type   | Description                          |
| --------- | ------ | ------------------------------------ |
| `tasks`   | list   | **REQUIRED**. List of task objects   |
| `name`    | string | Optional name for the task           |
| `email`   | string | Email for notification when complete |

**Task object structure:**

```json
{
  "platform": "x",
  "topic": "#Bittensor",
  "keyword": "dTAO"
}
```

> ⚠️ **Important:** For X (Twitter), topics **MUST** start with `#` or `$` (e.g., `#ai`, `$BTC`). Plain keywords are rejected!

***

**`get_gravity_task_status` - Monitor Collection Progress**

| Parameter          | Type   | Description                                          |
| ------------------ | ------ | ---------------------------------------------------- |
| `gravity_task_id`  | string | **REQUIRED**. The task ID from create\_gravity\_task |
| `include_crawlers` | bool   | Include detailed stats per crawler. Default: `True`  |

**Returns:** Task status, crawler IDs, records\_collected, bytes\_collected

***

**`build_dataset` - Build Dataset from Collected Data**

| Parameter    | Type   | Description                                       |
| ------------ | ------ | ------------------------------------------------- |
| `crawler_id` | string | **REQUIRED**. Get from get\_gravity\_task\_status |
| `max_rows`   | int    | Max rows to include. Default: 10,000              |
| `email`      | string | Email for notification when ready                 |

> ⚠️ **Warning:** Building a dataset will **STOP** the crawler and de-register it from the network.

***

**`get_dataset_status` - Get Download Links**

| Parameter    | Type   | Description                                      |
| ------------ | ------ | ------------------------------------------------ |
| `dataset_id` | string | **REQUIRED**. The dataset ID from build\_dataset |

**Returns:** Build status, download URLs for Parquet files when complete

***

**`cancel_gravity_task` - Stop Data Collection**

| Parameter         | Type   | Description                         |
| ----------------- | ------ | ----------------------------------- |
| `gravity_task_id` | string | **REQUIRED**. The task ID to cancel |

***

**`cancel_dataset` - Cancel Build or Purge Dataset**

| Parameter    | Type   | Description                                  |
| ------------ | ------ | -------------------------------------------- |
| `dataset_id` | string | **REQUIRED**. The dataset ID to cancel/purge |

***

### Example Workflows

#### Quick Query (On-Demand)

```
User: "What's the sentiment about $TAO on Twitter today?"

→ Uses query_on_demand_data to fetch recent tweets
→ Returns up to 1,000 results instantly
```

#### Large Dataset Collection (Gravity)

```
User: "I need to collect a week's worth of #AI tweets for analysis"

1. create_gravity_task → Returns gravity_task_id
2. get_gravity_task_status → Monitor progress, get crawler_ids
3. build_dataset → When ready, build the dataset (stops crawler)
4. get_dataset_status → Get download URL for Parquet file
```

***

### Example Prompts

#### On-Demand Queries

* "What has the president of the U.S. been saying over the past week on X?"
* "Fetch me information about what people are posting on r/politics today"
* "Please analyze posts from @elonmusk for the last week"
* "Get me 100 tweets about #Bittensor and analyze the sentiment"

#### Large-Scale Collection

* "Create a gravity task to collect data about #AI from Twitter"
* "Start a 7-day collection of $BTC tweets with keyword 'ETF'"
* "Check how many records my gravity task has collected"
* "Build a dataset with 10,000 rows from my crawler"

***

### Supported Platforms

| Platform    | Username Filtering | Keyword Search | Subreddit Filtering |
| ----------- | ------------------ | -------------- | ------------------- |
| X (Twitter) | ✅ Yes              | ✅ Yes          | N/A                 |
| Reddit      | ❌ No               | ✅ Yes          | ✅ Yes               |

***

### Troubleshooting

If you encounter any issues:

1. **Ensure you're using Python 3.10+**
2. **Verify uv is installed:** Run `uv --version`
3. **Check your API key:** Ensure `MC_API` is set correctly
4. **Restart the application:** After config changes, restart Claude Desktop or Cursor

For more on MCPs, refer to the [official MCP documentation](https://modelcontextprotocol.io/).
