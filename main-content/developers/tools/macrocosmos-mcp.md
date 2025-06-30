---
description: Using Macrocosmos MCP with Claude Desktop or Cursor
---

# Macrocosmos MCP

**Macrocosmos MCP** (Model Context Protocol) lets you integrate **SN13** APIs directly into **Claude for Desktop,** **Cursor,** or **your custom LLM pipeline**. Instantly tap into social data, perform live web searches, and explore Hugging Face models — all from your AI environment.

### Features

* 🔍 Query **X** (Twitter) and **Reddit** data on demand
* 🌐 Perform live **web search** using SN1 miners ( coming soon)

### Prerequisites

* Python 3.10
* `uv` package manager
* [Install Claude desktop](https://claude.ai/download)
* Install Cursor&#x20;

**Install UV package manager:**

{% tabs %}
{% tab title="Curl" %}
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```
{% endtab %}

{% tab title="Python" %}
```python
pip3 install uv
```
{% endtab %}
{% endtabs %}



## Server setup instructions

This step is **required for both Claude Desktop and Cursor** — the server is what enables access to the SN1 and SN13 tools.

**1. Clone the Repo and Navigate to your project directory**

```
git clone https://github.com/macrocosm-os/macrocosmos-mcp.git
cd macrocosmos-mcp/src
```



2. **Create and activate a virtual environment**

```bash
uv venv
source .venv/bin/activate
```



3. **Initialize the project directory (src)**

```bash
uv init
```



4. **Install required dependencies**

```bash
uv add "mcp[cli]" httpx macrocosmos
```



5. **Test your MCP server**

While it's not required to run the server continuously, performing a quick test ensures that your setup is correct.​

To test your server, execute the following command:​

```bash
uv run macrocosmos_mcp.py
```

This command starts the server and waits for connections. Once you've confirmed it's running correctly, you can stop it by pressing `Ctrl+C`.​

After this verification, you don't need to run the server manually. As long as the necessary files are present on your local machine, your MCP client (such as Claude Desktop or Cursor) will handle starting the server as needed.



6. **Get the full path to your `uv` executable:**

```bash
which uv
```



## Configure **Claude Desktop**

**Run the following command , this will open your Claude configuration file**&#x20;

```bash
code ~/Library/Application\ Support/Claude/claude_desktop_config.json
```



**Update with this:**

```bash
{
    "mcpServers": {
        "macrocosmos": {
            "command": "FULL_PATH_TO_UV",  // Replace with output from `which uv`
            "args": [
                "--directory",
                "/path/to/macrocosmos-mcp",  // Replace with the path to your local clone of macrocosmos-mcp
                "run",
                "src/macrocosmos_mcp.py"
            ],
            "env": {
                "MC_KEY": "your-sdk-api-key"
            }
        }
    }
}

```

Replace "FULL\_PATH\_TO\_UV" with the full path you got from `which uv`.

For instance:

```
/Users/victorkanu/.local/bin/uv
```



**Open Claude desktop**

<figure><img src="../../.gitbook/assets/canva .png" alt=""><figcaption></figcaption></figure>

**Look for the hammer icon — this confirms your MCP server is running. You’ll now see SN1 and SN13 tools available inside Claude.**

<figure><img src="../../.gitbook/assets/canva mcp.png" alt=""><figcaption></figcaption></figure>



**Watch a demo 👇**

{% embed url="https://drive.google.com/file/d/1bcS4Vq-MTgbamZMFOnIjWBItFK3LHgjN/view?usp=sharing" %}
MCP Demo Video
{% endembed %}



## Configure **Cursor**

You can either update the config file manually or use the built-in UI.

**Option 1: Via UI (Recommended)**

* Go to **Cursor Settings**
* Navigate to your Cursor settings and select `add new global MCP server`&#x20;

<figure><img src="../../.gitbook/assets/canva10.png" alt=""><figcaption></figcaption></figure>



**Option 2: Manual JSON**&#x20;

```bash
code ~/Library/Application\ Support/Cursor/cursor_mcp_config.json
```

Paste the same config block (updated with your paths and API keys).

> ⚠️ Note: In some cases, manually editing this file doesn't activate the MCP server in Cursor. If this happens, use the UI method above for best results.



**Update your `mcp.json` file**

\
Add the following configuration to your `mcp.json`. This will let you access the available tools.            (Same values as shown in the Claude config above.)

```
{
    "mcpServers": {
        "macrocosmos": {
            "command": "FULL_PATH_TO_UV",  // Replace with output from `which uv`
            "args": [
                "--directory",
                "/path/to/macrocosmos-mcp",  // Replace with the path to your local clone of macrocosmos-mcp
                "run",
                "src/macrocosmos_mcp.py"
            ],
            "env": {
                "MC_KEY": "your-sdk-api-key"
            }
        }
    }
}

```



<figure><img src="../../.gitbook/assets/canva11.png" alt=""><figcaption></figcaption></figure>





**Use Agent Mode**

In Cursor, make sure you're using **Agent Mode** in the chat. Agents have the ability to use any MCP tool — including custom ones and those from SN1/SN13. You can ask it questions like:

<figure><img src="../../.gitbook/assets/canva13.png" alt=""><figcaption></figcaption></figure>

You can now ask questions or give prompts. Be sure to **specify when you want the agent to use MCP tools**.



**Tool Usage in Action**\


When the agent responds, you’ll see it indicate which **MCP tool** it’s using, along with a coherent and context-aware reply.

<figure><img src="../../.gitbook/assets/Screenshot 2025-04-16 at 04.38.41.png" alt=""><figcaption></figcaption></figure>



### Troubleshooting

If you encounter any issues:

1. Ensure you're in the correct directory
2. Verify that `uv` is properly installed
3. Make sure the virtual environment is activated
4. Check that all dependencies are properly installed



For more on MCPs please refer to the [official documentation](https://modelcontextprotocol.io/introduction)&#x20;
