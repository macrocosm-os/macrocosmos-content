---
description: Quickstart
---

# SN1 - Apex

1. Clone SN1's GitHub repository Use the following command:

```
git clone https://github.com/macrocosm-os/prompting.git
```

2. **Set up the .env.api file**: Navigate to your .env.api file and fill in the validator hotkey

````
```shellscript
#Input Scoring key to access the endpoint 👇
SCORING_KEY = "123" # The scoring key for the validator (must match the scoring key in the .env.validator file)

#URL to your validator 👇
VALIDATOR_API = "0.0.0.0:8094" # The validator API to forward responses to for scoring
WORKERS=4

```
````











