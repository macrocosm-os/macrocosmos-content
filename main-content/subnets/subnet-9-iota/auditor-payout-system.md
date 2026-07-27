# Auditor Payout System

The auditor payout system is a set of public endpoints that allow anyone to observe why specific compute was allocated to an IOTA run. The information includes decision logic, pricing, location, provider details, and more.&#x20;

It is recommended that your agent ingest the docs below to build your own custom introspection tool.

### Verify provisioning decisions

The provisioning decision trail is exposed read-only and unauthenticated, so anyone can check why each GPU was bought or dropped — the price we paid, its provenance, and the alternatives we rejected. Two GET endpoints, no credentials.

**Base URL**

```
https://liquid-compute.api.macrocosmos.ai
```

> ⏱ Rate-limited to **1 request / minute per IP** — for spot-checks, not bulk pulls.

***

### 1. The decision trail

Per run, newest first: the machine we chose, the ones we rejected (each with a reason), the pillar scores it was ranked on, and the price. `run_id` is required; `limit` ≤ 32.

```bash
# decisions for a run (realized compute only, by default)
curl -s "https://liquid-compute.api.macrocosmos.ai/audit/placement/decisions?run_id=INSERT_RUN_ID&limit=5" | jq
```

Read `chosen.price_per_hour_usd` alongside `price_is_dynamic` / `price_source_system` — a live market quote vs a static catalog price — and `rejected[].reject_reason` to see why cheaper options were passed over.

***

### 2. Filter to what you're checking

If desired, you can narrow by decision type or widen to include picks that never came up. Same endpoint, extra query params.

```bash
# only skips (wanted to buy, every candidate was gated)
curl -s "https://liquid-compute.api.macrocosmos.ai/audit/placement/decisions?run_id=INSERT_RUN_ID&decision=skip" | jq
```

```bash
# include decided-but-never-provisioned picks
curl -s "https://liquid-compute.api.macrocosmos.ai/audit/placement/decisions?run_id=INSERT_RUN_ID&include_pending=true" | jq
```

A `create` with `provisioned_at` set = realized compute; `null` = decided but never ran (hidden unless `include_pending=true`). Page with `&offset=`.

***

### 3. The glossary — `/audit/placement/schema`

Self-documenting: this endpoint returns the field definitions and the meaning of every pillar score and reject reason, so a decision row is verifiable without insider context.

```bash
curl -s "https://liquid-compute.api.macrocosmos.ai/audit/placement/schema" | jq
```

The response has three keys:

* `entry_schema` — JSON Schema of one decision
* `field_notes`
* `reject_reasons`

#### Pillar scores — how a candidate is ranked

| Field                   | Meaning                                                                                                                                                                                                     |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `composite`             | The score the strategy sorts on — lower is better. `price_per_runner(on-demand) × capability_fit × stability_churn`. A unitless heuristic, not dollars; computed on the on-demand price even for spot runs. |
| `price_per_runner_hour` | Effective (billed) $/runner-hr = `price_per_hour_usd / runners_per_vm`. The money.                                                                                                                          |
| `capability_fit`        | `gpu_memory_gb / min_gpu_memory_gb`. 1.0 = exact fit; >1 = paying for memory over the requested floor.                                                                                                      |
| `stability_churn`       | `1 / √(accelerator_count)`. Lower = a larger multi-GPU VM (fewer VMs to manage).                                                                                                                            |
| `quality_reliability`   | 0..1 supplier reliability; 1.0 = the (cell, sku) failure bucket is cool (no recent failures/throttles).                                                                                                     |

#### `reject_reasons` — why an alternative was passed over

| Reason             | Meaning                                                                                                     |
| ------------------ | ----------------------------------------------------------------------------------------------------------- |
| `scored_worse`     | Valid + available, but ranked below the chosen option (composite margin in `reject_detail`).                |
| `capacity_capped`  | Cloud advertised 0 remaining for the cell or (cell, sku) this tick (per-cell instance quota folds in here). |
| `bucket_cooldown`  | The (cell, sku) failure bucket is still cooling after recent failures.                                      |
| `excluded_sku`     | Operator excluded this SKU/accelerator (`params.excluded_skus`).                                            |
| `slot_unavailable` | No free (group, slot) left this tick.                                                                       |
| `quota_exhausted`  | Reserved — currently surfaces as `capacity_capped`.                                                         |
| `throttled`        | Reserved — recent provider throttle (not emitted by the elastic core today).                                |

***

### Provenance

Provenance on every entry pins it to exact config + code — `params_sha256` (hash of the effective strategy params) + `git_sha` (the commit the image was built from). That's what makes a row reproducible.

> 💡 Only runs created with `auditing: true` record a trail. A run with no rows either had auditing off or doesn't exist — the endpoint returns **404**, not an empty list.
