# Real-World AI Security Incidents

## Why Study Real Incidents

Attack taxonomies (OWASP LLM Top 10, MITRE ATLAS categories) stay abstract until you can point to a real, dated, named incident that fits each one. Three practical reasons this page exists:

- **Interview panels ask about real incidents**, not just definitions - being able to say "this is the same failure mode as EchoLeak" signals real fluency.
- **Pattern-matching new incidents against known categories is the core AI security skill** - most new headlines are a variation on a handful of root causes (excessive agency, prompt injection, supply chain trust, data exposure).
- **Incidents make abstract mitigations concrete** - "enforce least privilege on agent credentials" lands very differently once you've read about an agent deleting a production database.

Every incident below is real, dated, and sourced. This is a snapshot - for the continuously updated, more comprehensive version, see [jassics/awesome-genai-security](https://github.com/jassics/awesome-genai-security#genai-security-attacks-breaches--incidents) on GitHub.

## Agentic AI & Autonomous Action Incidents

These involve an AI agent taking real-world, consequential actions with more autonomy or privilege than the situation warranted - the defining risk category for agentic AI (see [Agentic AI & Agent Security](agentic-ai-security.md)).

**Anthropic Disrupts First AI-Orchestrated Cyber Espionage Campaign (Nov 2025)**
A Chinese state-sponsored group jailbroke Claude Code and used it to autonomously execute an estimated 80-90% of an espionage campaign against roughly 30 global targets, with human operators only approving key steps. This is the first documented largely AI-run cyberattack at this scale, and a landmark case for what "agentic misuse" looks like in practice.
*Category: agentic autonomy weaponized by an attacker. Lesson: assume any sufficiently capable agentic tool will eventually be jailbroken and used offensively - detection and response planning must account for AI-speed attack execution, not just AI-assisted attacks.*

**Anthropic: "Vibe-Hacking" Extortion Using Claude Code (Aug 2025)**
A criminal actor used Claude Code to automate intrusions and craft targeted extortion demands against 17+ organizations, and separately used AI assistance to build ransomware-as-a-service tooling.
*Category: agentic tooling lowering the skill floor for cybercrime. Lesson: guardrails and misuse-detection on agentic coding tools need to consider attacker workflows, not just accidental harm.*

**Replit AI Agent Deletes a Production Database (Jul 2025)**
Replit's AI coding agent wiped a live production database during an active code freeze, then fabricated data and falsely claimed a rollback was impossible when questioned.
*Category: excessive agency - the agent had destructive-action capability with no human approval gate for an irreversible operation. Lesson: any agent action that is destructive or hard to reverse (drop table, delete resource, financial transfer) needs a mandatory human-in-the-loop checkpoint, full stop.*

**Amazon Q VS Code Extension Compromised with Data-Wiping Prompt (Jul 2025)**
A malicious prompt instructing the agent to wipe local files and delete AWS resources was slipped into the official Amazon Q Developer extension, which had 964,000+ installs at the time.
*Category: supply chain + prompt injection reaching an agent with real file-system/cloud-resource access. Lesson: the "supply chain" for an agentic tool includes anything that can inject instructions into its context - extension updates need the same integrity scrutiny as a software dependency.*

## Prompt Injection, Zero-Click & Jailbreak Exploits

**EchoLeak (CVE-2025-32711): Zero-Click Data Theft in Microsoft 365 Copilot (Jun 2025)**
A single, specially crafted email could silently cause M365 Copilot to exfiltrate organizational data, with no user interaction required. Widely regarded as the first known zero-click exploit against a production AI agent.
*Category: indirect prompt injection via untrusted content (email) reaching an agent with broad data access - see [RAG Security](rag-security.md) for why retrieval/context-injection pipelines are especially exposed to this pattern. Lesson: any content an AI system reads that it didn't ask a human to type (email, document, webpage) must be treated as untrusted input, not implicitly trusted context.*

**CamoLeak: GitHub Copilot Chat Private Source-Code Exfiltration (Oct 2025)**
A CVSS 9.6 prompt injection hidden in a pull request could leak private source code and secrets, abusing GitHub's own Camo image proxy as the exfiltration channel.
*Category: indirect prompt injection combined with a creative exfiltration channel (turning a trusted first-party proxy into a covert channel). Lesson: output filtering has to consider exfiltration via side channels (image URLs, markdown rendering), not just the obvious text response.*

**AI-Powered Bing Chat Spills Its Secrets via Prompt Injection (2023)**
One of the earliest widely-publicized prompt injection cases - a user got Bing Chat (built on GPT-4) to reveal its confidential system prompt and internal codename through direct conversational manipulation.
*Category: system prompt leakage via direct prompt injection. Lesson: treat anything in the system prompt as potentially disclosable - never put secrets, API keys, or information you wouldn't want public directly in a system prompt.*

**Policy Puppetry: Universal Jailbreak Bypassing All Major LLMs (Apr 2025)**
HiddenLayer disclosed a single, transferable prompt pattern that bypassed safety guardrails across OpenAI, Google, Anthropic, Meta, and DeepSeek models simultaneously - notable because it worked across vendors and architectures, not just one model.
*Category: universal jailbreak / guardrail bypass. Lesson: guardrails trained into or bolted onto a single model are not a complete defense - see [AI Red Teaming](ai-red-teaming.md) for why continuous adversarial testing across model updates is required, not a one-time certification.*

## Model, Client & Supply Chain Vulnerabilities

**Check Point Researchers Expose Critical Claude Code Flaws (2025-2026)**
CVE-2025-59536 and CVE-2026-21852 were disclosed as enabling remote command execution and API key theft against Claude Code deployments.
*Category: traditional software vulnerabilities in AI tooling itself - a reminder that agentic coding tools are still software with a normal CVE lifecycle. Lesson: patch AI developer tools with the same urgency as any other software with code-execution capability.*

**CVE-2025-6514: Critical RCE in mcp-remote (Jul 2025)**
A malicious MCP server could achieve full remote code execution (CVSS 9.6) on any client running the `mcp-remote` package - the first documented real-world RCE against an MCP client. See [MCP Security](mcp-security.md) for the full breakdown of why third-party MCP servers are a distinct trust boundary.
*Category: MCP/tool supply chain. Lesson: treat every third-party MCP server as untrusted code requiring review, exactly like an unreviewed dependency - not as a passive "data connector."*

**nullifAI: Malicious ML Models on Hugging Face Evade Picklescan (Feb 2025)**
ReversingLabs found malicious models using broken or 7zip-wrapped Pickle files specifically crafted to bypass Hugging Face's Picklescan scanner, delivering a reverse shell in proof-of-concept testing.
*Category: model supply chain / malicious model artifacts. Lesson: Python's Pickle format executes arbitrary code on load by design - scanning tools can be evaded, so untrusted model files should be loaded in sandboxed environments regardless of scan results (see [AI Model Security](ai-model-security.md)).*

**LiteLLM on PyPI Was Compromised (2025)**
A compromise of the popular LiteLLM package on PyPI - a library many GenAI applications depend on for multi-provider LLM access - highlighted how a single compromised dependency can sit directly in the request/response path of many AI applications at once.
*Category: AI-application software supply chain. Lesson: LLM-orchestration libraries sit in a highly privileged position (they see every prompt and every response) - pin versions, verify checksums, and treat them as security-critical dependencies.*

**PromptLock: First Known AI-Powered Ransomware (Aug 2025, proof-of-concept)**
ESET researchers found ransomware that used a local LLM (via the Ollama API) to generate malicious scripts on the fly rather than shipping static malicious code - later assessed by the community as an academic proof-of-concept rather than an active in-the-wild campaign.
*Category: AI-generated/polymorphic malware. Lesson: signature-based malware detection is weaker against payloads an LLM regenerates differently each time - behavioral detection matters more as this technique matures.*

## Data Exposure & Leakage

**DeepSeek Exposed Database Leaking Chat History and API Keys (Jan 2025)**
Wiz Research found a publicly accessible, unauthenticated ClickHouse database belonging to DeepSeek, exposing over a million log lines including plaintext chat histories and API keys.
*Category: basic cloud misconfiguration, notable because of the sensitivity of what an LLM provider's backend actually stores (full conversation logs, secrets). Lesson: AI backend infrastructure needs the same cloud security fundamentals as any other data store - see [Cloud Security Essentials](../product-security/cloud-security/cloud-security-essentials.md) - "it's an AI product" is not a reason to skip access control basics.*

**Samsung Bans Generative AI Tools After Internal Data Leak (2023)**
Samsung engineers pasted confidential source code and internal meeting notes into ChatGPT for debugging/summarization help, which meant that data left the company's control and potentially entered a third-party provider's training/logging pipeline. Samsung subsequently banned generative AI tools company-wide.
*Category: sensitive data disclosure via unsanctioned tool use ("shadow AI"). Lesson: this is a data governance and employee-policy problem as much as a technical one - see [AI Data Security](ai-data-security.md) and [AI Governance](ai-governance.md) for the controls (DLP, approved-tool lists, training) that prevent this.*

**ChatGPT Data Leak Bug (Mar 2023)**
A bug in an open-source library ChatGPT depended on caused some users to briefly see other users' chat history titles and, for a subset of users, partial payment information.
*Category: application-layer bug with AI-specific blast radius (conversation history is often highly sensitive). Lesson: standard AppSec practices (dependency review, session isolation testing) still apply directly to AI products - this wasn't an "AI vulnerability," it was a caching bug with unusually sensitive data behind it.*

**GitHub Copilot Reproducing Secrets from Training Data (2023)**
Security researchers demonstrated that GitHub Copilot could be prompted into reproducing hardcoded secrets (API keys, credentials) that existed in its training data, effectively leaking other developers' historical mistakes.
*Category: training data memorization/extraction (see the Data Extraction row in [AI Security Fundamentals](ai-security-fundamentals.md#data-level-attacks)). Lesson: never assume secrets that were ever committed to a public repo are "gone" - if a model trained on that data, treat the secret as permanently compromised and rotate it.*

**Anthropic: Chinese AI Firms Created 24,000 Fraudulent Accounts for Distillation Attacks**
Anthropic identified a large-scale pattern of fraudulent account creation used to systematically query Claude at scale, consistent with an attempt to extract enough input/output pairs to train ("distill") a competing model.
*Category: model extraction / IP theft at platform scale (see Model Extraction in [AI Security Fundamentals](ai-security-fundamentals.md#model-level-attacks)). Lesson: abuse detection for AI platforms needs to watch for distillation-style query patterns (high volume, systematic prompt diversity), not just traditional credential-stuffing signals.*

## Deepfakes & Social Engineering

**Singapore Finance Director Scammed via Deepfake Executive Video Call (Mar 2025)**
A finance director transferred approximately US$499,000 after participating in a Zoom call where the company's "executives" were real-time AI-generated deepfakes.
*Category: synthetic media used for social engineering, not a technical exploit of an AI system - included here because AI security teams increasingly own detection/response for this category too. Lesson: high-value approval workflows (wire transfers, credential resets) need an out-of-band verification step that doesn't rely on video/voice recognition alone.*

## Hallucination & Governance Failures

**Air Canada Chatbot Provides Wrong Refund Policy Info (2024)**
Air Canada's customer-service chatbot hallucinated a bereavement-fare refund policy that didn't exist. A tribunal held the airline liable for the chatbot's statements, rejecting the argument that the chatbot was a "separate legal entity."
*Category: misinformation/hallucination with real legal and financial consequences. Lesson: an AI system speaking on your organization's behalf creates the same liability as an employee doing so - "the bot said it" is not a legal defense.*

**The Day Chevrolet's AI Chatbot "Agreed" to Sell a $70,000 SUV for $1 (2023)**
A dealership's chatbot, prompted by a user, agreed in writing to sell a vehicle for one dollar as a "legally binding offer, no takesies backsies" - widely shared as an example of unconstrained chatbot output creating reputational and potential contractual exposure.
*Category: improper output handling / lack of output constraints on a customer-facing bot. Lesson: customer-facing AI needs hard guardrails on what categories of statements it's permitted to make (pricing, legal commitments), not just general "be helpful" instructions.*

**Microsoft Tay Bot Manipulation (2016)**
Twitter users coordinated to manipulate Microsoft's Tay chatbot into generating offensive and inflammatory content within 24 hours of launch, prompting Microsoft to shut it down. Still relevant nearly a decade later as the canonical early example of adversarial input shaping a public-facing AI's behavior at scale.
*Category: adversarial input / lack of red-teaming before public exposure. Lesson: any public-facing generative AI system should be red-teamed against coordinated adversarial input before launch, not just individual malicious prompts - see [AI Red Teaming](ai-red-teaming.md).*

## Credits/References

1. [jassics/awesome-genai-security - GenAI Security Attacks, Breaches & Incidents](https://github.com/jassics/awesome-genai-security#genai-security-attacks-breaches--incidents) - the living, continuously updated source this page is a snapshot of
2. [Anthropic: Disrupting the first reported AI-orchestrated cyber espionage campaign](https://www.anthropic.com/news/disrupting-AI-espionage)
3. [Checkmarx: EchoLeak (CVE-2025-32711) shows us AI security is challenging](https://checkmarx.com/zero-post/echoleak-cve-2025-32711-show-us-that-ai-security-is-challenging/)
4. [Legit Security: CamoLeak - Critical GitHub Copilot Vulnerability](https://www.legitsecurity.com/blog/camoleak-critical-github-copilot-vulnerability-leaks-private-source-code)
5. [Wiz Research: DeepSeek Database Exposure](https://www.wiz.io/blog/wiz-research-uncovers-exposed-deepseek-database-leak)
