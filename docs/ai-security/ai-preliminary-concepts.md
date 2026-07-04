# Preliminary AI Concepts (Before You Study AI Security)

You don't need a machine learning degree to be effective at AI security, but you do need to be fluent in a handful of concepts - because almost every AI-specific vulnerability is a direct consequence of how these systems actually work under the hood, not an arbitrary design flaw. This page is the "zero" in zero-to-hero: read it before [AI Security Fundamentals](ai-security-fundamentals.md) if any of the terms below feel unfamiliar.

## What Machine Learning Actually Is

Traditional software is rule-based: a human writes explicit logic (`if age >= 18: allow`), and the program executes exactly those rules. Machine learning flips this around - instead of writing the rules, you show the system many examples of inputs and correct outputs, and an algorithm searches for a mathematical function (a set of numbers called **parameters** or **weights**) that maps inputs to outputs as accurately as possible. The system learns the rule from data rather than being told the rule.

This matters for security immediately: **a rule-based system fails in predictable ways** (a missing `if` branch), while **a learned system fails in ways that depend on its training data and the exact input it receives** - which is why attacks like adversarial examples and prompt injection don't have direct analogues in traditional software security.

## Neural Networks, Conceptually

A neural network is a large mathematical function built from layers of simple units ("neurons"), each performing a weighted sum of its inputs followed by a non-linear transformation. Stack enough layers together, and the network can approximate extremely complex functions - image recognition, language understanding, code generation. You do not need the calculus to work in AI security, but you should know:

- **Training** = adjusting the network's weights (often billions of them) so its outputs get closer to the correct answer, using an algorithm called gradient descent.
- **Parameters** = the learned weights. This is what's actually being protected when people talk about "model theft" - the parameters are the valuable, expensive-to-produce IP.
- **Inference** = running the already-trained network on new input to get an output. This is what happens every time you send a prompt to a deployed model - no learning happens at this stage (in the general case).

## What Makes an LLM Different

A Large Language Model is a neural network built on the **Transformer** architecture ([Vaswani et al., 2017](https://arxiv.org/abs/1706.03762)), trained to predict the next token in a sequence, at massive scale.

### Tokens

Text isn't fed to the model as words - it's broken into **tokens**, sub-word units from a fixed vocabulary. The sentence `"AI security is fascinating"` might tokenize into something like `["AI", " security", " is", " fasc", "inating"]` - notice "fascinating" split into two pieces. This matters for security because:

- Token-boundary tricks (splitting a forbidden word across token boundaries, or using homoglyphs/lookalike characters) are a real jailbreak technique, because content filters that check for exact word matches can be bypassed if the tokenizer segments the malicious phrase differently than the filter expects.
- Every token costs money and counts against the context window - which is directly relevant to resource-exhaustion attacks (see LLM10 in [LLM Security](llm-security.md)).

### Attention (Why Transformers Work)

The core innovation in a Transformer is the **attention mechanism** - for every token, the model computes how much "attention" to pay to every other token in the input when deciding what comes next. This is what lets an LLM track that "it" in a long paragraph refers to a specific noun mentioned three sentences earlier. You don't need the matrix math (queries, keys, values) to work in AI security, but the practical consequence matters enormously: **the model treats everything in its context window as material it can attend to and be influenced by - including instructions, data, and any text an attacker manages to sneak in.** There is no built-in mechanism that makes the model inherently trust the system prompt more than a user message or a retrieved document; that separation has to be engineered on top, which is the entire root cause of prompt injection.

### Embeddings

Before a token can be processed mathematically, it's converted into a vector embedding - a list of a few hundred to a few thousand numbers that represents the token's meaning as a point in high-dimensional space. Words used in similar contexts end up as nearby points. The classic illustrative example: `vector("king") - vector("man") + vector("woman") ≈ vector("queen")` - the model has implicitly learned that the relationship between "king" and "man" is analogous to the relationship between "queen" and "woman," purely from seeing text.

Embeddings matter for security because they're also how [RAG](rag-security.md) systems find "similar" documents to retrieve - and an attacker who understands the embedding space can sometimes craft content specifically engineered to be retrieved for queries it shouldn't match (see Vector and Embedding Weaknesses in [LLM Security](llm-security.md)).

## Training vs. Fine-Tuning vs. Inference

These three stages have completely different security profiles - conflating them is a common and consequential mistake:

| Stage | What Happens | Security Relevance |
|-------|--------------|----------------------|
| **Pre-training** | The model learns general language patterns from a massive, broad text corpus (often scraped from the public internet) | Data poisoning here is expensive to pull off (you'd need to corrupt a meaningful fraction of a huge dataset) but has the widest blast radius - it affects every downstream use of the model |
| **Fine-tuning** | The pre-trained ("foundation") model is further trained on a smaller, task-specific or organization-specific dataset to specialize its behavior | Poisoning is far cheaper here since fine-tuning datasets are smaller and often assembled less carefully (e.g. scraped support tickets, user feedback) - this is the more realistic poisoning attack surface for most organizations |
| **Inference** | The trained model is deployed and generates outputs in response to live input, with no weight updates happening | This is where prompt injection, jailbreaking, and most of the OWASP LLM Top 10 actually happens - it's runtime, not training-time, so classic security thinking (input validation, access control, monitoring) largely still applies |

## Foundation Models

A **foundation model** is a single large pre-trained model (GPT, Claude, Gemini, Llama, etc.) designed to be adapted to many different downstream tasks via fine-tuning or prompting, rather than training a new model from scratch for each task. This "one model, many uses" pattern is why AI security has become its own discipline: a vulnerability class discovered in one foundation model (e.g. a universal jailbreak string) can potentially transfer to every application built on top of it, and every organization fine-tuning or prompting that same base model inherits both its capabilities and its weaknesses.

## Context Window

The context window is the maximum amount of text (measured in tokens) a model can consider at once - system prompt, conversation history, retrieved documents, and the current query all compete for this same finite space. Two direct security implications:

1. **Anything placed in the context window is potentially extractable.** If your system prompt contains a secret, an API key, or proprietary instructions, a sufficiently creative prompt can often get the model to repeat it back (see System Prompt Leakage in [LLM Security](llm-security.md)).
2. **Anything placed in the context window can influence behavior**, whether it's a legitimate instruction or an attacker's payload hidden in a document the model is asked to summarize. The model has no innate way to distinguish "trusted instruction" from "untrusted data it's processing" unless the application explicitly engineers that separation.

## Prompting Basics: System, User, and Assistant Roles

Modern LLM APIs structure a conversation as a list of messages, each tagged with a role:

```python
messages = [
    {"role": "system", "content": "You are a customer support assistant. Only answer questions about billing."},
    {"role": "user", "content": "What's my current balance?"},
    {"role": "assistant", "content": "Let me look that up for you..."},
]
```

- **System** - instructions from the application developer, meant to set the model's behavior and boundaries.
- **User** - input from the end user (or, critically, from any untrusted source the application feeds into this role or embeds into a user-role message - a retrieved document, a webpage, an email).
- **Assistant** - the model's own prior responses, included so it has conversational memory.

This three-way split is entirely a software engineering convention layered on top of the model - the model itself just sees a sequence of tokens with role markers. **Every prompt injection attack, at its core, is an attempt to make the model treat untrusted content as if it were a system-level instruction.** Understanding this distinction is the single most important prerequisite for understanding LLM security - see [LLM Security](llm-security.md) for the full OWASP Top 10 treatment of what goes wrong when this separation fails.

## Temperature and Sampling

When generating the next token, the model doesn't just output one deterministic answer - it computes a probability distribution over its entire vocabulary, then samples from that distribution. **Temperature** controls how "sharp" or "flat" that distribution is: temperature near 0 makes the model almost always pick the highest-probability token (closer to deterministic), while higher temperature flattens the distribution and increases randomness/creativity.

Security relevance: this is why the exact same prompt, including the exact same attack payload, can succeed on one attempt and fail on the next against the same model - LLM outputs are not fully deterministic unless temperature is set to 0 (and even then, some providers introduce additional non-determinism at the infrastructure level). When you're red-teaming or testing an LLM application, a single failed jailbreak attempt does not mean the vulnerability doesn't exist - repeat testing and statistical thinking matter here in a way they don't for traditional deterministic software bugs.

## Concept → Why It Matters for Security

| Concept | Security Implication |
|---------|------------------------|
| Tokens | Token-boundary and encoding tricks can bypass naive content filters; token count drives cost/resource-exhaustion attacks |
| Attention | The model has no built-in trust hierarchy between system/user/data - the entire basis of prompt injection |
| Embeddings | Attackers can craft content to be deliberately retrieved by RAG systems, or exploit weak embedding models |
| Training vs. fine-tuning vs. inference | Data poisoning risk and mitigation differs enormously by stage; most day-to-day AI security work is about the inference stage |
| Foundation models | A shared vulnerability (e.g. a universal jailbreak) can affect every application built on the same base model |
| Context window | Anything placed in context is potentially extractable and can influence model behavior |
| System/user/assistant roles | This is a software-layer convention, not a hard security boundary - it must be reinforced with explicit engineering |
| Temperature/sampling | LLM security testing needs repeated trials, not single-shot pass/fail testing |

## What's Next

- [AI Security Fundamentals](ai-security-fundamentals.md) - the AI/ML attack taxonomy built on top of these concepts
- [LLM Security](llm-security.md) - the OWASP Top 10 for LLM Applications, in depth
- [RAG Security](rag-security.md), [MCP Security](mcp-security.md), and [Agentic AI Security](agentic-ai-security.md) - once you're comfortable with the fundamentals

## Credits/References

1. Vaswani et al., ["Attention Is All You Need"](https://arxiv.org/abs/1706.03762) - the original Transformer paper
2. Xiao & Zhu, ["Foundations of Large Language Models"](https://arxiv.org/abs/2501.09223) - accessible coverage of pre-training, fine-tuning, prompting, and alignment
3. [DataCamp: What Are Foundation Models?](https://www.datacamp.com/blog/what-are-foundation-models)
4. [OWASP GenAI Security Project](https://genai.owasp.org/) - the umbrella project behind the LLM/Agentic Top 10 lists referenced throughout this section
