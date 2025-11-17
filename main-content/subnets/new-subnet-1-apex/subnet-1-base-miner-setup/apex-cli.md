---
description: Instructions on how to use Apex's CLI tool
---

# APEX CLI

To use the CLI you must have a[ registered wallet on subnet 1.](https://docs.learnbittensor.org/miners#miner-registration)&#x20;

### Link Wallet

Link your registered wallet with the cli - required for most cli commands

`apex link`

### View Competitions

To view competitions and their status

`apex dashboard`

Example Output:

<figure><img src="../../../.gitbook/assets/dashboard_screenshot.png" alt=""><figcaption></figcaption></figure>

### View Submissions

To view a submission, first open the dashboard `apex dashboard` and hit `enter/return` when hovering the competition of interest.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-11-14 at 10.15.29 PM.png" alt=""><figcaption></figcaption></figure>

Your own submissions will be viewable immediately, other's submissions will be viewable after a delay.&#x20;

### Submit a Solution

```
apex submit <Path_To_Solution> -c <Competition_ID> -r <Round_ID>
```

View the \<Competition\_ID> and \<Round\_ID> via the dashboard
