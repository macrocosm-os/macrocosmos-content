---
description: Data Universe API – Social Media Data Skill
---

# OpenClaw Skills

Fetch real-time social media data from X (Twitter) and Reddit by keyword, username, date range, and filters with engagement metrics via Macrocosmos SN13 API on Bittensor.

Fetch real-time social media data from X (Twitter) and Reddit by keyword, username, date range, and filters with engagement metrics via Macrocosmos SN13 API on Bittensor.

Link to the ClawHub: [https://clawhub.ai/Arrmlet/social-data](https://clawhub.ai/Arrmlet/social-data)

### Tips & Known Behaviors

#### What works reliably

* **High-volume keyword searches**: Popular terms like "bittensor", "AI", "iran", "lfg" return fast
* **Wider date ranges**: Setting `start_date` further back (e.g., weeks/months) improves results
* **`keyword_mode: "all"`**: Great for finding intersection of two topics (e.g., "chutes" AND "bittensor")

#### What can be flaky

* **Username-only queries**: Can timeout (DEADLINE\_EXCEEDED). Adding `start_date` far back helps
* **Niche/low-volume keywords**: Very specific terms may timeout if miners don't have data indexed
* **No `start_date`**: Defaults to last 24h which can miss data; set explicitly for best results

#### Best practices for LLM agents

1. **Always set `start_date`** — don't rely on the 24h default. Use at least 7 days back for user queries
2. **Prefer keywords over usernames** — keyword searches are more reliable
3. **For username queries, always include `start_date`** set weeks/months back
4. **Use `keyword_mode: "all"`** when combining a topic with a subtopic (e.g., "bittensor" + "chutes")
5. **Handle timeouts gracefully** — if a query times out, retry with broader date range or switch to keyword search
6. **Parse engagement metrics** — `view_count`, `like_count`, `retweet_count` help rank relevance
7. **Check `is_reply` and `is_quote`** — filter for original tweets vs replies depending on use case
