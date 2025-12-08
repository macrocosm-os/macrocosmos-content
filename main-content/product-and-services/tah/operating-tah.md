---
description: How to run, pause, update, and observe TAH
---

# Operating TAH

This page describes the main controls in the TAH desktop app and how to run, pause, and monitor your node.

![TAH dashboard showing Start training and Connect controls](../../.gitbook/assets/image.png)

## Main controls (top right)

- **Start training** (primary button): begins contributing your GPU/CPU to the current run. Click again to stop/exit the run.
- **Connect** (smaller button): optionally paste your wallet coldkey to receive rewards to that address. You can train without connecting; if you connect later, rewards accrue to the provided coldkey from that point forward.
- **Status pill**: shows whether your hardware is ready (e.g., “Connected • Your GPU is ready to contribute”). Resolve any warnings before starting.

## Start a session

1) Launch the app and wait for the status pill to read **Connected**.
2) (Optional) Click **Connect**, paste your wallet coldkey, and save.
3) Click **Start training**. The run ID, model size, and layer count populate in the right panel; progress and tokens/hour graphs begin updating.
4) To stop, click **Start training** again (it toggles off) or quit the app.

## Monitor while training

- **Run panel (right)**: shows run ID, model size, layers, cumulative progress, and tokens/hour graph.
- **Network view (center)**: visualizes peers and traffic; switch tabs (Network/Layer/Miner) for different views.
- **Loss chart (bottom center)**: training loss over time; toggle Log/Linear and tokens/time axes.
- **Run Log (bottom right)**: per-epoch/step logs; lock icon indicates read-only when idle.

## Resource behavior

- The app uses available GPU/CPU once training starts. If you need to pause, toggle **Start training** off.
- Keep the laptop powered and on a stable network for steady rewards. Thermal throttling may reduce contribution; use a cooler or lower-power profile if needed.

## Updates

- If an update is available, install the latest build before starting a new session for compatibility with the active run.
