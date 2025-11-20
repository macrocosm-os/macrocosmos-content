---
description: Instructions on how to use Apex's CLI tool
---

# Apex CLI

The Apex CLI is a miner's interface with the subnet: linking wallets, submitting competition solutions, and viewing the dashboard. The dashboard contains all miner submissions to past and current competitions - use it to view others' code submissions and logs to compare your individual performance against the subnet.&#x20;

To use the CLI you must have a [registered wallet on subnet 1.](https://docs.learnbittensor.org/miners#miner-registration)&#x20;

### Link Wallet

Link your registered wallet with the cli - required for most cli commands:

`apex link`&#x20;

This will prompt you to enter your Bittensor wallet location, which defaults to the default Bittensor wallet path: `/Users/{USERNAME}/.bittensor/wallets` .

* To select the default wallet location, press _ENTER/RETURN_.&#x20;

Then, use the arrow keys to select your registered coldkey and hotkey from the list provided.&#x20;

### View Competitions

#### To view the currently active competition:

`apex competitions`

This will return a list of all active competitions and their associated competition IDs.&#x20;

#### To view competitions and their status in detail:

`apex dashboard`

Example Output:

<figure><img src="../../../.gitbook/assets/dashboard_screenshot.png" alt=""><figcaption></figcaption></figure>

### View Submissions

To view a submission, first open the dashboard `apex dashboard` and press _ENTER/RETU&#x52;_&#x4E; when hovering the competition of interest.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-11-14 at 10.15.29 PM.png" alt=""><figcaption></figcaption></figure>

Your own submissions will be viewable immediately, other's submissions will be viewable after a delay.&#x20;

### Submit a Solution

```
apex submit <Path_To_Solution> -c <Competition_ID> -r <Round_ID>
```

View the \<Competition\_ID> and \<Round\_ID> via the dashboard
