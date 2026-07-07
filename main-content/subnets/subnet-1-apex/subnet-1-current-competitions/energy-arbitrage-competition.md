---
description: Algorithmic electric grid optimization
---

# Energy Arbitrage Competition

**Energy storage arbitrage** is a core problem in modern electricity markets: a battery operator can profit by purchasing power when prices are low and selling it back when prices are high, but must act under uncertainty as real-time prices deviate from day-ahead forecasts due to weather, demand shocks, and transmission congestion.

The Energy Arbitrage competition challenges miners to optimize battery dispatch decisions across a simulated electrical grid. Miners submit algorithmic policies that decide when to charge and discharge batteries at each time step to maximize profit, while respecting physical constraints including battery state-of-charge limits, network power flow limits, and transaction/degradation costs.

### Evaluation Overview <a href="#evaluation" id="evaluation"></a>

Each evaluation runs the miner's policy across 100 challenge instances. Instances cycle through 5 scenarios of increasing difficulty:

| Scenario  | Nodes | Lines | Batteries | Time Steps | Duration |
| --------- | ----- | ----- | --------- | ---------- | -------- |
| Baseline  | 20    | 30    | 10        | 96         | 1 Day    |
| Congested | 40    | 60    | 20        | 96         | 1 Day    |
| Multiday  | 80    | 120   | 40        | 192        | 2 Days   |
| Dense     | 100   | 200   | 60        | 192        | 2 Days   |
| Capstone  | 150   | 300   | 100       | 192        | 2 Days   |

* Each time step represents 15 minutes. Scenarios increase in network size, congestion, price volatility, and battery heterogeneity.
* Each rounds's evaluation set is seeded to ensure determinism.
  * This seed changes from round to round.



#### Step by Step

At each time step, the miner's policy function receives:

* The current state: battery state-of-charge levels, real-time nodal electricity prices, exogenous grid injections, feasible action bounds per battery, and accumulated profit.
* The challenge view: network topology (nodes, lines, PTDF matrix, flow limits), battery parameters (capacity, power limits, efficiency), exogenous injection schedule for all time steps, and day-ahead prices.
* The policy returns a list of actions (MW), one per battery. Negative values charge; positive values discharge.&#x20;
  * Actions must stay within the provided bounds.
* Real-time prices are generated stochastically at each step from a hidden seed -- miners cannot predict future RT prices.&#x20;
  * Day-ahead prices are known in advance for the full horizon.



#### Constraints

* Battery SOC: Must remain between 10% and 90% of capacity. Starts at 50%.
* Charge/discharge efficiency: 95% each direction.
* Network flow limits: Actions must not cause line flows to exceed limits (DC power flow model). Violations cause the step to fail.
* Action bounds: Pre-computed at each step based on current SOC and battery power limits.
* Timeouts:
  * Per-step timeout = 30 seconds.
  * Total evaluation timeout = 1200 seconds.&#x20;



#### Profit Calculation

At each time step, per battery:

```
  profit = revenue - transaction_cost - degradation_cost                                                                   
                                                                                                                         
  revenue           = action * rt_price * dt                                                                               
  transaction_cost  = 0.25 * |action| * dt
  degradation_cost  = 1.00 * (|action| * dt / capacity)^2                                                                  
                                                                                                                           
  Where dt = 0.25 hours (15 min). Total profit is the sum across all batteries and all time steps.                         
 
```



#### Scoring

* Each instance is scored by comparing the miner's total profit against a baseline (the better of two built-in heuristic policies -- greedy and conservative):
* `quality = (miner_profit - baseline_profit) / (baseline_profit + 1e-6)`
* `quality_int = round(clamp(quality, -10, +10) * 1,000,000)`
* The miner's final score is the average quality across all 100 instances.
* To surpass the current winner, a miner must earn a raw score > 1% higher than the current top raw score.&#x20;
  * If there is no current winner, the miner must beat the baseline raw score by at least 1%.
* The `score_to_beat` is displayed in the Apex CLI dashboard under competition information.



#### Miner Submissions

* Miners submit a single .py file implementing:
  * `def policy(challenge: PolicyView, state: State) -> list[float]:`
* Maximum submission size: 50,000 characters.
* Default round length: 1 day.
* Submission Fee: $1.00 USD.
* 1% `raw_score` threshold to beat current top scorer.
* Miners code is revealed 1 day after evaluation.
* Logs are opened after the current round is completed.
* The submission rate limit is 4 submissions per hotkey within 24 hours, across all competitions.
* An example of baseline solver implementations can be found in the [energy\_arbitrage/python](https://github.com/macrocosm-os/apex/tree/main/shared/competition/src/competition/energy_arbitrage/python) folder.
* The information about enabled packages is in [requirements.txt](https://github.com/macrocosm-os/apex/blob/main/shared/competition/src/competition/energy_arbitrage/dockerfiles/requirements.txt). Only numpy is available beyond the standard library.
