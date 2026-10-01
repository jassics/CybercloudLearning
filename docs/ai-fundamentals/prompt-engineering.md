# Prompt Engineering

## Why Prompting Is Engineering, Not Just "Asking Nicely"

A prompt is the lowest-cost lever you have for controlling model behavior - cheaper than fine-tuning, faster to iterate than retraining, and deployable with a config change instead of a release cycle. But "lowest cost" doesn't mean "unstructured." The techniques below are measurable and repeatable: you can run the same prompt against a benchmark, change one variable, and quantify the effect - which is what separates prompt *engineering* from trial-and-error.

## Zero-Shot vs. Few-Shot Prompting

**Zero-shot** gives the model only an instruction, no examples: "Classify this review as positive or negative." **Few-shot** includes a handful of worked examples in the prompt itself before the actual task:

```text
Review: "Fast shipping, exactly as described." -> Positive
Review: "Broke after one use, total waste of money." -> Negative
Review: "The battery life is shorter than advertised." -> ?
```

Few-shot reliably improves consistency on tasks with a specific output format or an ambiguous category boundary, at the cost of extra tokens on every single call - a direct tradeoff with [Context Engineering](context-engineering.md)'s budget constraints.

## Chain-of-Thought Prompting

[Wei et al., 2022](https://arxiv.org/abs/2201.11903) showed that asking a model to produce intermediate reasoning steps before its final answer ("Let's think step by step") measurably improves performance on arithmetic, commonsense, and symbolic reasoning tasks - the model does better when it "shows its work" rather than jumping straight to an answer. This works because autoregressive generation is sequential: each reasoning token the model writes becomes part of the context it conditions on for the next token, effectively giving the model more computation to work with before committing to a final answer.

**Self-consistency** ([Wang et al., 2022](https://arxiv.org/abs/2203.11171)) extends this: instead of generating one chain of thought, sample several independently (using non-zero temperature - see [LLM Architecture](llm-architecture.md)), then take the majority answer across them. This trades inference cost (multiple generations) for accuracy, and is a standard technique when correctness matters more than latency.

## Role and Persona Prompting

Assigning the model a role ("You are a senior security engineer reviewing this code for vulnerabilities") steers its tone, vocabulary, and implicit evaluation criteria toward what a person in that role would actually produce. This is a real, measurable effect on output quality for domain-specific tasks - not just theater - but it is not a security boundary: a persona instruction is still just text in the context window, with no more enforcement power than any other instruction (see [LLM Architecture](llm-architecture.md) on why the model has no built-in trust hierarchy).

## Structured Output Prompting

Explicitly requesting a specific output format - JSON, XML, a fixed schema - makes model output reliably parseable by downstream code instead of requiring fragile text-scraping:

```text
Respond only with valid JSON matching this schema:
{"severity": "low|medium|high|critical", "summary": "string", "cve_ids": ["string"]}
```

This is the same underlying mechanic that makes tool-calling work: a tool-calling LLM is, structurally, just being prompted (via its harness) to produce a structured-output object matching a function's schema, which the harness then parses and executes. See [Harness & Loop Engineering](harness-and-loop-engineering.md) for how this gets wired into an actual agent loop, and [MCP Security](../ai-security/mcp-security.md) for what goes wrong when the schema itself becomes part of the attack surface.

## Prompt Templates and Reusability

Production systems don't write prompts inline per-request - they maintain versioned templates with variable slots, often shared across an application or even exposed as a first-class primitive (MCP's `prompts` capability standardizes exactly this: a server-provided, reusable prompt template a client can invoke - see [MCP Security](../ai-security/mcp-security.md) for the security implications of pulling prompt templates from a server you don't control).

## Prompt Sensitivity Is a Real Engineering Problem

Small wording changes can produce large, hard-to-predict output differences - reordering a sentence, swapping a synonym, or changing punctuation can shift a model from a correct answer to an incorrect one, or from compliant behavior to a jailbreak. This isn't a minor quirk to shrug off; it's a direct consequence of how attention and token-level probability distributions work (see [LLM Architecture](llm-architecture.md)), and it means prompts need the same engineering discipline as code:

- **Version control** - track prompt changes with the same rigor as application code, since a "small wording tweak" can silently regress behavior.
- **Regression testing against a golden set** - maintain a fixed set of test inputs with known-good expected outputs, and re-run it on every prompt change.
- **A/B testing in production** - for anything user-facing, measure the actual effect of a prompt change on real traffic rather than assuming a prompt that "looks better" performs better.

## Security Angle

Prompt *engineering* is you deliberately crafting input to produce a desired model behavior. Prompt *injection* ([LLM01 in LLM Security](../ai-security/llm-security.md)) is an attacker doing exactly the same thing, for an undesired behavior, often using the same techniques (role/persona framing, structured-output requests, few-shot-style examples of the "wrong" behavior) - same mechanism, opposite intent. Understanding prompt engineering well is what makes you good at recognizing a prompt injection payload for what it is: another prompt, engineered by someone else, aimed at your model instead of their own task.

## Credits/References

1. Wei et al., ["Chain-of-Thought Prompting Elicits Reasoning in Large Language Models"](https://arxiv.org/abs/2201.11903)
2. Wang et al., ["Self-Consistency Improves Chain of Thought Reasoning in Language Models"](https://arxiv.org/abs/2203.11171)
3. [DeepLearning.AI: ChatGPT Prompt Engineering for Developers](https://www.deeplearning.ai/courses/chatgpt-prompt-eng) (Isa Fulford, Andrew Ng)
4. [Model Context Protocol specification](https://modelcontextprotocol.io/) - the `prompts` primitive referenced above
