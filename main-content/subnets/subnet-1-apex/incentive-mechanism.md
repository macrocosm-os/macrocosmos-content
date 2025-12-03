---
description: Subnet 1 incentive and operation
---

# Incentive Mechanism

The core idea behind the subnet is to share problem-solving code openly to enhance competition results, round by round. Open-sourcing these solutions widens impact and helps tackle real-world challenges.

In the Matrix Compression competition — the first event on the subnet — the winning solution will not only directly enhance Subnet 9’s output but may also contribute to optimising data centres and cloud infrastructure.



### General Operations <a href="#general-operation" id="general-operation"></a>

* **Solution Submission**\
  Miners submit their solutions to the competition to the submission endpoint API.
* **Execution and Metrics**\
  Each solution runs inside an isolated secure sandbox, generating its evaluation metrics.
* **Evaluation**\
  The subnet validator reviews these metrics and assigns a score to each submitted solution.
* **Scoring and Selection**\
  Validators retrieve the scores from the subnet orchestrator to determine the winning miner.
* **Rewards**\
  The miner with the highest score receives the full reward. If that solution is replaced or improved, the new best submission takes over and earns the rewards of the competition.

<figure><img src="../../.gitbook/assets/Screenshot 2025-11-17 at 14.14.01.png" alt=""><figcaption></figcaption></figure>



### Incentive Challenges <a href="#incentive-challenges" id="incentive-challenges"></a>

#### 1. How does SN1 prevent successful solution code from being stolen and resubmitted for reward? <a href="#id-1.-how-to-ensure-that-the-successful-solution-code-submitted-by-one-miner-is-not-used-be-other-miner" id="id-1.-how-to-ensure-that-the-successful-solution-code-submitted-by-one-miner-is-not-used-be-other-miner"></a>

To ensure miners are fairly rewarded for their best solutions, the submitted code remains hidden for a set period. Once evaluation is complete and rewards are distributed, the code is made public for others to explore.

<figure><img src="../../.gitbook/assets/Competition1.png" alt=""><figcaption></figcaption></figure>

The winner’s code is revealed with a delay. The duration of the hidden code period depends on the competition. Logs are published only after the completion of a competition round.&#x20;

This approach guarantees creators to fully exercise the submission rewards, while still allowing others to learn from and improve existing solutions — tapping into the power of community innovation.

<figure><img src="../../.gitbook/assets/Code-visibility.png" alt=""><figcaption></figcaption></figure>

#### 2. How are miners driven toward continuous improvement? <a href="#id-2.-how-to-motivate-miners-for-continuous-improvement" id="id-2.-how-to-motivate-miners-for-continuous-improvement"></a>

The emission burning mechanism was created to push successful miners toward improving their code. Once a top-performing solution is submitted, its associated emissions gradually start to burn. The longer the solution remains unchallenged, the higher the burn rate becomes — motivating continuous innovation and competition.

<figure><img src="../../.gitbook/assets/Burning-rate.png" alt=""><figcaption></figcaption></figure>

#### 3. What will be the baseline and success metrics of the Matrix Compression competition? <a href="#id-3.-what-will-be-the-baseline-and-success-metrics-of-the-compression-competition" id="id-3.-what-will-be-the-baseline-and-success-metrics-of-the-compression-competition"></a>

The initial baseline for the Matrix Compression challenge will be the Lempel–Ziv–Markov-Chain Algorithm (LZMA). LZMA, recognisable in due to its frequent usage in 7-zip. It combines dictionary and range encoding, saving bits on repeated data and predictable byte sequences. Apex adopts the implementation from the standard python library.&#x20;

#### 4. How are code submissions validated? <a href="#id-4.-how-to-ensure-fair-and-safe-validation-of-someones-code-which-can-not-be-public-until-the-validat" id="id-4.-how-to-ensure-fair-and-safe-validation-of-someones-code-which-can-not-be-public-until-the-validat"></a>

The Code Executor is a part of the subnet where miner code is ran and evaluated. Evaluation metrics depend on the competition. In case of the Matrix Compression competition such metrics are:

* Compression ratio - the max level of compression provided by solution
* Compression speed - the time required to run a compression and decompression processes
* De-compression accuracy - similarity between the input and output of compression - decompression process.

After solutions run in the Code Executor, metrics are converted into score in accordance with the given competition's scoring mechanism.&#x20;

