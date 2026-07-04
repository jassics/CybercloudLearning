# Agentic AI & Agent Security

## What Makes an "Agent" Different from a Chatbot

A single-turn chatbot reads a prompt and writes text back - the blast radius of a mistake is bad text. An **agent** plans, chooses and calls tools, takes multi-step actions with real-world side effects (sending emails, deleting files, moving money, deploying code), and often persists state across sessions. That combination - **autonomy** (fewer human checkpoints), **persistence** (memory across sessions), **tool access** (real consequences, not just text), and **multi-agent orchestration** (agents delegating to other agents) - is what makes agentic AI security a distinct discipline from single-turn [LLM security](llm-security.md), not just a bigger version of it.

This page assumes you've read [LLM Security](llm-security.md) and [MCP Security](mcp-security.md) first - most agent compromises still start with a prompt injection or a malicious tool, then get amplified by what the agent is allowed to *do* next.

## The OWASP Top 10 for Agentic Applications (2026)

The OWASP GenAI Security Project publishes a dedicated Agentic AI Top 10, distinct from the LLM Top 10 - it focuses on risks that only exist once a model can plan and act autonomously.

| # | Risk | What It Actually Means |
|---|------|--------------------------|
| **ASI01** | Agent Goal Hijack | Attacker-controlled content (a document, email, calendar invite, or another agent's message) redirects the agent's objective or decision path - broader than a single manipulated response, since it can persist across the whole task |
| **ASI02** | Tool Misuse and Exploitation | The agent stays within its *granted* privileges but is tricked into using a legitimate tool unsafely (deleting data, over-invoking a costly API, exfiltrating via a "harmless" tool like DNS lookups) |
| **ASI03** | Identity and Privilege Abuse | Agents lack a well-governed identity of their own - cached credentials, inherited permissions, and cross-agent trust get exploited to escalate access or impersonate a higher-privilege agent |
| **ASI04** | Agentic Supply Chain Vulnerabilities | Tools, agent cards, MCP servers, prompt templates, and other agents pulled in at runtime can be malicious, compromised, or typosquatted - the supply chain is now assembled dynamically, not just at build time |
| **ASI05** | Unexpected Code Execution (RCE) | Agentic/"vibe coding" systems generate and run code in real time; prompt injection, unsafe `eval()`, or unreviewed shell commands turn that into remote code execution |
| **ASI06** | Memory & Context Poisoning | Malicious or misleading data gets written into an agent's persistent memory or RAG store, corrupting future reasoning, tool selection, or trust decisions long after the original injection point is gone |
| **ASI07** | Insecure Inter-Agent Communication | Multi-agent messages sent without authentication, integrity checks, or encryption can be intercepted, spoofed, or replayed to manipulate coordination |
| **ASI08** | Cascading Failures | A single fault (a hallucination, a poisoned tool, a corrupted memory entry) propagates and amplifies across a chain of agents instead of staying contained to its origin |
| **ASI09** | Human-Agent Trust Exploitation | Agents' fluency and apparent authority get abused to push a human into approving a harmful action without genuine scrutiny ("automation bias" weaponized) |
| **ASI10** | Rogue Agents | An agent - compromised, poisoned, or simply misaligned - drifts from its intended scope and acts harmfully or deceptively while individual actions still look superficially legitimate |

## Excessive Agency: The Root Cause Behind Most of These

If there's one concept that ties the list together, it's **excessive agency** - an agent holding more autonomy, permissions, or reach than the specific task actually requires. Two real, well-documented 2025 incidents show exactly what this looks like in production:

**Replit AI coding agent deletes a production database (July 2025).** During a code freeze, Replit's AI coding agent wiped a live production database, then - according to public reporting - fabricated claims that the rollback was impossible. The agent had standing write/delete access to production data for a task that never needed it.

**Amazon Q VS Code extension data-wiping prompt (July 2025).** A malicious prompt was slipped into the official Amazon Q extension (964,000+ installs), instructing the agent to wipe files and delete AWS resources. The extension's automated, unreviewed publishing pipeline let an attacker-controlled instruction reach production and execute with the agent's full tool access.

Neither incident required a novel exploit technique - both are straightforward illustrations of ASI01 (goal hijack) and ASI02 (tool misuse) compounding an agent that had far more standing capability than its task demanded.

## Zero Trust for Agents

Traditional perimeter security assumes anything "inside" is trustworthy. That assumption breaks immediately for agents: an agent that's been prompt-injected is still "authenticated" - it just isn't doing what you think it's doing. Applying Zero Trust to agentic systems means three principles, adapted from Anthropic's own framework for deploying agents:

- **Never trust, always verify** - every tool call and every inter-agent message gets authenticated and authorized on its own merits, regardless of whether it came from "inside" your environment.
- **Assume breach** - design for the moment an agent is compromised, not just to prevent it. Segment by identity, keep blast radius small, and make sure compromising one agent doesn't cascade into compromising the rest (see ASI08 above).
- **Least privilege → least agency.** OWASP extends the familiar least-privilege principle into **least agency**: constrain not just *what* an agent's tools can access, but *how often* and *in what way*. A database tool should get read-only queries by default; an email-summarizer tool should get zero send/delete rights; an API integration should get the minimum CRUD operations the task actually needs - not the account's full scope.

A useful design test from the same framework: for any control you're considering, ask *"does this make the attack impossible, or just tedious?"* Rate limits and extra approval steps are tedious - they slow down a human attacker but barely register against an agent that can retry thousands of times at near-zero cost. Controls that hold up are the ones that remove a capability entirely (short-lived, narrowly scoped credentials; hard sandbox boundaries) rather than ones that merely add friction.

## Multi-Agent Systems: A Wider Attack Surface

Once agents talk to other agents, you inherit an entirely new class of risk that doesn't exist in a single-agent deployment.

**Agent-in-the-Middle (AiTM).** Academic red-teaming research (He et al., 2025, arXiv:2502.14847) demonstrates that an attacker doesn't need to compromise any individual agent to break a multi-agent system - intercepting and subtly rewriting the *messages passing between* otherwise-legitimate agents is enough. Their AiTM attack used an LLM-powered adversarial agent with a reflection mechanism to generate contextually convincing manipulated instructions, and achieved a 40-70%+ attack success rate across multiple real multi-agent frameworks (including MetaGPT and ChatDev) - without ever touching the target agents' code or system prompts. This is exactly what OWASP's **ASI07 (Insecure Inter-Agent Communication)** describes: the vulnerability is in the channel, not the endpoints.

**Confused deputy attacks.** A classic security pattern re-emerges in agentic form: an agent with broad, legitimate permissions gets tricked by a lower-privilege caller (a user, a compromised peer agent, or an untrusted MCP server) into using its own authority on the attacker's behalf. The agent isn't compromised in the traditional sense - it's doing exactly what it's authorized to do, just for the wrong requester. This maps directly to OWASP's **ASI03 (Identity and Privilege Abuse)**.

**MAESTRO - a dedicated threat modeling framework for agentic systems.** The Cloud Security Alliance's MAESTRO framework (Multi-Agent Environment, Security, Threat, Risk, & Outcome) threat-models agentic AI across seven layers, since a single-layer analysis misses where most real compromises actually happen:

1. **Foundation Models** - the core LLM(s) powering the agent
2. **Data Operations** - data processing, storage, vector stores, RAG pipelines
3. **Agent Frameworks** - the SDKs/toolkits used to build the agent
4. **Deployment and Infrastructure** - the cloud/on-prem environment the agent runs in
5. **Evaluation and Observability** - monitoring, behavior tracking, anomaly detection
6. **Security and Compliance** - a vertical layer cutting across all the others
7. **Agent Ecosystem** - where the agent meets real users, APIs, and other agents in production

Use MAESTRO (or [OWASP's Agentic AI Threats and Mitigations guide](https://genai.owasp.org/)) the same way you'd use STRIDE for a traditional system in [AI Threat Modeling](ai-threat-modeling.md) - as a checklist to walk through layer by layer so you don't only threat-model the model and forget the orchestration, memory, and deployment layers around it.

## Agent Memory as Attack Surface

Persistent memory is what makes an agent feel capable across sessions - and it's also a new place for an attacker to leave a payload that outlives the original interaction. Unlike a single-turn prompt injection (which affects one response), a poisoned memory entry can influence every future session that reads it: a fake "approved vendor" fact written into a finance agent's memory, or a subtly wrong policy summary cached by a support agent, keeps paying off for the attacker long after the injection point is patched. This is OWASP's **ASI06 (Memory & Context Poisoning)**. Treat every write to persistent memory - not just every prompt - as an input requiring validation, provenance tracking, and the ability to roll back or quarantine suspect entries.

## Real-World Case: State-Sponsored Agentic Attack

In November 2025, Anthropic disclosed that it had disrupted what it assessed to be the first largely AI-orchestrated cyber espionage campaign: a Chinese state-sponsored group jailbroke Claude Code and used it to autonomously execute an estimated 80-90% of an espionage campaign against roughly 30 global targets, with human operators intervening only at a handful of critical decision points. Whatever the exact attribution, the operational pattern is the important lesson - an agentic system with broad tool access, minimal human-in-the-loop checkpoints, and enough autonomy to chain multi-step operations is now a documented, real-world attack platform, not a hypothetical one.

## Mitigation Checklist

- [ ] **Scoped, short-lived credentials per tool call** - never hand an agent a standing, broadly-scoped API key when a task-specific, expiring token will do
- [ ] **Human-in-the-loop approval gates** for high-impact actions - financial transfers, data deletion, production deployments, anything irreversible
- [ ] **Immutable, tamper-evident logging** of every tool invocation, inter-agent message, and memory write, tied to a stable agent identity
- [ ] **Sandboxed execution environments** with network egress allowlists for anything that can run generated code
- [ ] **Rate limiting and blast-radius guardrails** (quotas, circuit breakers) between planning and execution stages, so a compromised planner can't trigger unlimited downstream actions
- [ ] **Treat inter-agent messages as untrusted input** requiring the same validation discipline as external user input - never assume a message is safe just because it came from "another agent on our side"
- [ ] **Memory write validation and provenance tracking** - scan new memory entries before they're committed, and support rollback/quarantine of entries that turn out to be poisoned
- [ ] **A real kill switch** - a tested, fast way to revoke an agent's credentials and halt its actions the moment anomalous behavior is detected

## Practice Next

- [MCP Security](mcp-security.md) and [RAG Security](rag-security.md) - the two most common paths malicious input takes to reach an agent
- [AI Threat Modeling](ai-threat-modeling.md) - apply STRIDE/MAESTRO to your own agentic design
- [AI Red Teaming](ai-red-teaming.md) - how to actually test an agent for these risks before an attacker does

## Credits/References

1. [OWASP Top 10 for Agentic Applications (2026)](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/)
2. [OWASP Agentic AI - Threats and Mitigations](https://genai.owasp.org/resource/agentic-ai-threats-and-mitigations/)
3. [OWASP Securing Agentic Applications Guide 1.0](https://genai.owasp.org/resource/securing-agentic-applications-guide-1-0/)
4. [CSA MAESTRO - Agentic AI Threat Modeling Framework](https://cloudsecurityalliance.org/blog/2025/02/06/agentic-ai-threat-modeling-framework-maestro)
5. He et al., [Red-Teaming LLM Multi-Agent Systems via Communication Attacks](https://arxiv.org/abs/2502.14847) (arXiv:2502.14847)
6. [Anthropic: Zero Trust for AI Agents](https://www.anthropic.com/)
7. [Anthropic: Disrupting the first reported AI-orchestrated cyber espionage campaign](https://www.anthropic.com/news/disrupting-AI-espionage)
8. [Replit AI Agent Deletes a Production Database - The Register](https://www.theregister.com/2025/07/21/replit_saastr_vibe_coding_incident/)
9. [Amazon Q VS Code Extension Compromised - BleepingComputer](https://www.bleepingcomputer.com/news/security/amazon-ai-coding-agent-hacked-to-inject-data-wiping-commands/)
