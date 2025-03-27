# Agentic Tasks

### Agentic Tasks

The `task` parameter in the `/v1/chat/completions` endpoint allows you direct miners toward specific agentic behaviors.&#x20;

Validator creates a variety of tasks, which include a "challenge" for the miner to solve, scoring all the completions they send back.

***

#### **1. `QA` – Question Answering**

**Description:** The miner receives a question about a specific section from a Wikipedia page. The miner must then find the original context in the specified section and use it to return an accurate answer. References are generated using the validators privileged knowledge of the context, and miner completions are scored based on similarity metrics.\
\
**Purpose:** Measures grounding in source context.\
**task parameter:** `"task": "QA"`\
**Behavior:** Miner fetches relevant passage and answers using it.\
&#x20;✍️ Best for factual QA

***

#### **2. `Inference`**

**Description:** A question is given with some pre-seeded information and a random seed. The miner must perform an inference based on this information to provide the correct answer. Completions are scored based on similarity metrics.

\
**Purpose:** Measures reasoning accuracy based on limited info.\
**task parameter:** `"task": "Inference"`\
**Behavior:** Produces deterministic outputs influenced by seed.\
🧪 Good for hypothesis testing

***

#### **3. `MultiChoice`**

**Description:** The miner is presented with a question from Wikipedia along with four possible answers (A, B, C, or D). The miner must search Wikipedia and return the correct answer by selecting one of the given options. Miner completions are scored by Regex matching.

\
**Purpose:** Tests search + selection capabilities.\
**task parameter:** `"task": "MultiChoice"`\
**Behavior:** Searches Wikipedia, returns A/B/C/D.

***

#### **4. `Programming`**

**Description:** Given a partial code snippet, miners complete the function. The validator generates a reference using it's internal LLM, and the miner is scored based on its similarity to this reference.

\
**Purpose:** Evaluates code generation ability.\
**task parameter:** `"task": "Programming"`\
**Behavior:** Returns complete code.\
👨‍💻 Useful for developer assistants or coding agents.

***

#### **5. `WebRetrieval`**

**Description:** Miner finds an external page that best answers a question. This requires searching the web to locate the most accurate and reliable source to provide the answer. The miner is scored based on the embedding similarity between the answer it returns and the original website that the validator generated the reference from.

\
**Purpose:** Measures real-world web search & retrieval.\
**task parameter:** `"task": "WebRetrieval"`\
**Behavior:** Returns URL and summarized content.\
🔍 Ideal for real-time info lookup.

***

#### **6. `MultistepReasoning`**

**Description:** The miner is given a complex problem that requires multiple steps to solve. Each step builds upon the previous one, and the miner must provide intermediate results before arriving at the final answer. The validator generates a reference solution using its internal LLM, and the miner is scored based on the accuracy and coherence of the intermediate and final results.

\
**Purpose:** Tests complex problem-solving.\
**task parameter:** `"task": "MultistepReasoning"`\
**Behavior:** Outputs multiple logical steps, final result.\
🧮 Designed for chain-of-thought tasks, math, planning.

***



