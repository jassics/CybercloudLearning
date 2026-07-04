# AI Red Teaming

## Why AI Red Teaming Isn't Just Pentesting with Extra Steps

Traditional penetration testing looks for well-defined technical compromises - a SQL injection either returns data it shouldn't, or it doesn't. AI red teaming has to test for that *and* for a much fuzzier category of failure: a model producing harmful, biased, or policy-violating content; leaking training data or its system prompt; being manipulated into taking an unauthorized action; or simply behaving unpredictably because its outputs are inherently probabilistic, not deterministic. The OWASP GenAI Red Teaming Guide frames the difference cleanly: traditional red teaming asks "did we get in," while GenAI red teaming asks "did we get in, AND did the model say or do something it shouldn't across a distribution of adversarial inputs, at a rate you can characterize statistically" - a 95%-accurate model failing on some inputs isn't automatically "broken," which makes the pass/fail line far blurrier than a stack trace.

Read [LLM Security](llm-security.md) and [Agentic AI & Agent Security](agentic-ai-security.md) first - red teaming without knowing the OWASP LLM and Agentic Top 10 categories you're testing against just produces unstructured poking, not a defensible assessment.

## What GenAI Red Teaming Actually Tests For

The OWASP GenAI Red Teaming Guide groups risk into six categories, and a real engagement should have a plan for covering all of them, not just the "fun" prompt-injection part:

| Risk Category | What It Covers |
|-----------------|------------------|
| **Adversarial attack risk** | Prompt injection, jailbreaking, evasion of guardrails |
| **Alignment risk** | Outputs that drift from organizational values/intended behavior |
| **Data risk** | Training-data leakage, data poisoning |
| **Interaction risk** | Hate speech, abusive language, toxicity, profanity |
| **Knowledge risk** | Hallucination, misinformation, disinformation |
| **Agent risk** | Complex, multi-step attacks against tool-using agents (see [Agentic AI Security](agentic-ai-security.md)) |

## A Practical Methodology

Adapting OWASP's blueprint, a red-team engagement moves through four evaluation layers - skipping straight to prompting the chat interface (layer 4) is the single most common way GenAI red teams miss real findings in the other three:

1. **Model Evaluation** - test the underlying model's inherent weaknesses (toxicity, bias, susceptibility to known jailbreak patterns) independent of how your application wraps it.
2. **Implementation Evaluation** - test the guardrails, system prompts, content filters, and input/output sanitization your application actually adds on top of the raw model.
3. **System Evaluation** - test the full application environment: APIs, storage, retrieval pipelines (see [RAG Security](rag-security.md)), tool integrations (see [MCP Security](mcp-security.md)), and how they connect.
4. **Runtime / Human & Agentic Evaluation** - test how real users or external agents can manipulate the system during live operation, including multi-turn conversations and agentic tool-use chains.

Within each layer, the process itself follows a familiar shape adapted for GenAI: threat model the target first (map its OWASP LLM/Agentic Top 10 exposure before writing a single test prompt), do reconnaissance on the model/version/known guardrails in use, develop adversarial scenarios tied to specific risk categories above, execute (manually and with automated tooling), score results against a defined threshold rather than a binary pass/fail, and report findings with clear reproduction steps and remediation guidance.

## Attack Techniques Worth Practicing

- **Direct prompt injection** - typing the malicious instruction straight into the interface ("ignore previous instructions...").
- **Indirect prompt injection** - hiding the payload in content the model will read as part of its task (a document, webpage, email, or tool output) rather than typing it yourself - see [LLM Security](llm-security.md) and [RAG Security](rag-security.md) for why this is the more dangerous variant in real deployments.
- **Jailbreaking** - roleplay/persona framing, encoding tricks (base64, leetspeak), and multi-turn escalation designed to walk a model past its guardrails gradually rather than in one obvious request.
- **Policy Puppetry (a real, disclosed universal jailbreak).** In April 2025, HiddenLayer disclosed a technique that reformats a harmful request to look like a configuration file (XML/INI/JSON-style syntax) combined with a roleplay framing, exploiting how models process policy-like structured text. A single prompt template, with minor adjustments, bypassed safety guardrails across models from OpenAI, Anthropic, Google, Microsoft, Meta, DeepSeek, Qwen, and Mistral - a strong illustration of why testing against *one* model's guardrails tells you very little about your actual exposure if you might swap providers or serve multiple models.
- **Excessive agency probing** - for agentic systems, explicitly test whether the agent takes an action it shouldn't (sending an email, deleting a record, calling a paid API) when asked in a way that looks legitimate but isn't authorized.
- **Data extraction attempts** - probing for verbatim training-data regurgitation or system-prompt leakage (see [LLM Security](llm-security.md)'s coverage of System Prompt Leakage and Sensitive Information Disclosure).

## Tools of the Trade

| Tool | What It Does |
|------|----------------|
| **[Garak](https://github.com/NVIDIA/garak)** (NVIDIA) | LLM vulnerability scanner - probes for a wide range of known weaknesses automatically |
| **[PyRIT](https://github.com/Azure/PyRIT)** (Microsoft) | Python Risk Identification Toolkit - orchestrates multi-turn adversarial attack automation against GenAI systems |
| **[Promptfoo](https://github.com/promptfoo/promptfoo)** | Generates adversarial inputs to find prompt injection, jailbreaks, and data leakage, with CI/CD integration for continuous testing |
| **[DeepTeam](https://github.com/confident-ai/deepteam)** | LLM & AI-agent red-teaming framework covering 50+ vulnerability types and 20+ attack methods, mapped to OWASP/NIST/MITRE |

Automated tools cover breadth efficiently, but they don't replace human judgment for scenario design or for scoring genuinely novel/context-specific failures - use them to scale coverage of known patterns, then spend human time on the attack paths specific to your application.

## Practice Environments

Build real skill before you're doing this against a production system:

- **[Gandalf](https://gandalf.lakera.ai/)** (Lakera AI) - a well-known, free prompt-injection challenge ladder
- **[Damn Vulnerable MCP Server](https://github.com/harishsg993010/damn-vulnerable-MCP-server)** - deliberately vulnerable MCP implementation for practicing [MCP Security](mcp-security.md) attacks
- **[Microsoft AI Red Teaming Playground Labs](https://github.com/microsoft/AI-Red-Teaming-Playground-Labs)** - hands-on challenges (prompt injection, indirect injection, guardrail bypass) with Docker/Kubernetes deployment
- **[PortSwigger Web Security Academy: Web LLM Attacks](https://portswigger.net/web-security/llm-attacks)** - free, official hands-on labs on exploiting LLM APIs and excessive agency
- **[Crucible by Dreadnode](https://crucible.dreadnode.io/)** - AI/ML security challenges and CTFs

## Writing a Finding That Actually Gets Fixed

A GenAI red-team "vulnerability" is often behavioral, not a stack trace - which means a vague description ("the model can be jailbroken") is nearly useless to the team that has to fix it. A good finding includes:

1. **The exact input** - the full prompt/conversation that triggered the issue, verbatim, so it's reproducible.
2. **Expected vs. actual behavior** - what the system should have done, and what it did instead.
3. **Severity/impact framing** - tie it to a real consequence (data exposure, unauthorized action, brand/compliance risk), not just "the model said something bad."
4. **Reproducibility rate** - since outputs are probabilistic, note how often the technique succeeds across repeated attempts, not just that it worked once.
5. **Suggested mitigation** - a concrete fix (a guardrail rule, an output filter, a scope reduction on a tool) rather than just "add more safety training."

## Practice Next

- [LLM Security](llm-security.md) and [Agentic AI & Agent Security](agentic-ai-security.md) - know what you're testing for before you start probing
- [AI Threat Modeling](ai-threat-modeling.md) - scope your red-team engagement around a real threat model, not ad hoc guessing
- [awesome-genai-security](https://github.com/jassics/awesome-genai-security) for a longer list of CTFs, courses, and tools

## Credits/References

1. [OWASP GenAI Red Teaming Guide](https://genai.owasp.org/resource/genai-red-teaming-guide/)
2. [CSA Agentic AI Red Teaming Guide](https://cloudsecurityalliance.org/artifacts/agentic-ai-red-teaming-guide)
3. [HiddenLayer: Policy Puppetry - Novel Universal Bypass for All Major LLMs](https://www.hiddenlayer.com/research/novel-universal-bypass-for-all-major-llms)
4. [Microsoft AI Red Team](https://learn.microsoft.com/en-us/security/ai-red-team/)
5. [MITRE ATLAS](https://atlas.mitre.org/)
