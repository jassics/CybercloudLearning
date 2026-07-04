# AI Security Resources

!!! tip "This page distills the highlights"
    For the full, continuously updated list, see [jassics/awesome-genai-security](https://github.com/jassics/awesome-genai-security) on GitHub - a curated list of links, books, videos, tools, CTFs, and incidents covering GenAI, LLM, RAG, MCP, Agents, and Agentic AI security.

Use this page as the "go deeper" reference for the whole [AI Security](ai-security-overview.md) section - organized so you can jump straight to standards, papers, tools, or hands-on practice depending on what you need right now.

## Standards & Frameworks

| Framework | What It Covers |
|-----------|-----------------|
| [OWASP GenAI Security Project](https://genai.owasp.org/) | The umbrella project behind the LLM Top 10, Agentic Top 10, and related guides |
| [OWASP Top 10 for LLM Applications](https://owasp.org/www-project-top-10-for-large-language-model-applications/) | The canonical LLM risk taxonomy - see [LLM Security](llm-security.md) for a full deep dive |
| [OWASP Top 10 for Agentic Applications](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/) | Risk taxonomy specific to autonomous, tool-using agents - see [Agentic AI & Agent Security](agentic-ai-security.md) |
| [OWASP LLM AI Security and Governance Checklist](https://genai.owasp.org/resource/llm-applications-cybersecurity-and-governance-checklist/) | Practical checklist bridging security and governance teams |
| [MITRE ATLAS](https://atlas.mitre.org/) | Adversarial Threat Landscape for AI Systems - real-world adversary tactics/techniques against ML systems, ATT&CK-style |
| [NIST AI Risk Management Framework (AI RMF)](https://www.nist.gov/itl/ai-risk-management-framework) + [Playbook](https://airc.nist.gov/AI_RMF_Knowledge_Base/Playbook) | US voluntary framework for identifying and managing AI risk across the lifecycle |
| [NIST AI 600-1: Generative AI Profile](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf) | GenAI-specific companion profile to the AI RMF |
| [Google Secure AI Framework (SAIF)](https://safety.google/cybersecurity-advancements/saif/) | Google's conceptual framework for securing AI systems |
| [ISO/IEC 42001:2023](https://www.iso.org/standard/81230.html) | AI Management System standard - the "ISO 27001 for AI governance" |
| [Databricks AI Security Framework (DASF)](https://www.databricks.com/resources/whitepaper/databricks-ai-security-framework-dasf) | Practical controls mapped to AI system components and risks |
| [CSA MAESTRO](https://cloudsecurityalliance.org/blog/2025/02/06/agentic-ai-threat-modeling-framework-maestro) | Seven-layer threat modeling framework specifically for agentic AI |

## Key Papers (arXiv & Research)

| Paper | Relevance |
|-------|-----------|
| [Attention Is All You Need (Vaswani et al., 2017)](https://arxiv.org/abs/1706.03762) | The transformer architecture paper underlying every modern LLM - see [Preliminary AI/ML Concepts](ai-preliminary-concepts.md) |
| [Extracting Training Data from Large Language Models (Carlini et al.)](https://arxiv.org/abs/2012.07805) | Foundational paper on training-data extraction attacks |
| [Not What You've Signed Up For: Compromising Real-World LLM-Integrated Applications](https://arxiv.org/abs/2302.12173) | Early, influential paper on indirect prompt injection against real deployed systems |
| [Prompt Injection Attacks and Defenses in LLM-Integrated Applications](https://arxiv.org/abs/2310.12815) | Systematic treatment of injection attack/defense patterns |
| [Red-Teaming LLM Multi-Agent Systems via Communication Attacks](https://arxiv.org/abs/2502.14847) | Attacks that exploit inter-agent communication in multi-agent pipelines - see [Agentic AI & Agent Security](agentic-ai-security.md) |
| [Adaptive Red-Teaming Agent Against Multimodal Models](https://arxiv.org/abs/2510.02677) | Automated/AI-driven red teaming approach - see [AI Red Teaming](ai-red-teaming.md) |
| [Agentic JWT: A Secure Delegation Protocol for Autonomous AI Agents (Goswami, 2025)](https://arxiv.org/abs/2509.13597) | Proposes cryptographically binding agent actions to a verified user intent + workflow step, addressing how OAuth 2.0's deterministic-client assumptions break down for autonomous, prompt-driven agents |
| [Google DeepMind: Evaluating Frontier Models for Dangerous Capabilities](https://arxiv.org/abs/2403.13793) | Methodology for evaluating frontier-model risk before release |

## Books

| Book | Author |
|------|--------|
| [The Developer's Playbook for Large Language Model Security](https://www.oreilly.com/library/view/the-developers-playbook/9781098162191/) | Steve Wilson |
| [Not with a Bug, But with a Sticker](https://www.goodreads.com/book/show/63079484-not-with-a-bug-but-with-a-sticker) | Ram Shankar Siva Kumar & Hyrum Anderson |
| [Generative AI Security](https://link.springer.com/book/10.1007/978-3-031-54252-7) | Ken Huang & Yang Wang |
| [Adversarial AI: Attacks, Mitigations, and Defense Strategies](https://www.packtpub.com/en-us/product/adversarial-ai-attacks-mitigations-and-defense-strategies-9781801300568) | John Sotiropoulos |
| [Red Teaming AI: A Field Manual for Attacking Intelligent Systems](https://nostarch.com/red-teaming-AI) | Philip A. Dursey (No Starch, early access) |

## Videos & Talks

- [Intro to LLM Security - WhyLabs](https://www.youtube.com/watch?v=dj1H4g4YSlU)
- [OWASP Top 10 for LLM Applications Explained - OWASP](https://www.youtube.com/watch?v=engR9tYSsug)
- [Hacking LLMs and Prompt Injection - LiveOverflow](https://www.youtube.com/watch?v=Sv5OLj2nVAQ)
- [AI Red Teaming - DEFCON AI Village](https://www.youtube.com/watch?v=JCRoFMHjLng)
- [Securing LLM Applications - SANS Institute](https://www.youtube.com/watch?v=gcnWoR5eJQQ)

## Tools

### Defensive / Scanning

| Tool | Purpose |
|------|---------|
| [LLM Guard](https://github.com/protectai/llm-guard) | Information-extraction protection and input/output security for LLMs |
| [ModelScan](https://github.com/protectai/modelscan) | Scans models for serialization attacks |
| [Rebuff](https://github.com/protectai/rebuff) | Prompt injection detection |
| [Cisco MCP Scanner](https://github.com/cisco-ai-defense/mcp-scanner) | Scans MCP servers/tools for poisoning and prompt injection |
| [Snyk Agent Scan](https://github.com/snyk/agent-scan) | Inventories and scans AI agents, MCP servers, and skills for 15+ risk types |
| [Fickling (Trail of Bits)](https://github.com/trailofbits/fickling) | Decompiler/analyzer/safety-scanner for malicious Pickle/PyTorch model files |
| [ModelAudit](https://github.com/promptfoo/modelaudit) | Static scanner for malicious code/backdoors across 40+ model file formats |

### Offensive / Red Teaming

| Tool | Purpose |
|------|---------|
| [Garak (NVIDIA)](https://github.com/NVIDIA/garak) | LLM vulnerability scanner |
| [PyRIT (Microsoft)](https://github.com/Azure/PyRIT) | Python Risk Identification Toolkit for GenAI |
| [ART - Adversarial Robustness Toolbox (IBM)](https://github.com/Trusted-AI/adversarial-robustness-toolbox) | Adversarial-example generation and robustness testing |
| [promptmap](https://github.com/utkusen/promptmap) | Prompt injection testing |
| [DeepTeam](https://github.com/confident-ai/deepteam) | LLM & AI-agent red teaming - 50+ vulnerability types mapped to OWASP/NIST/MITRE |
| [Promptfoo](https://github.com/promptfoo/promptfoo) | LLM testing/red-teaming with CI/CD integration |

### Guardrails & Firewalls

| Tool | Purpose |
|------|---------|
| [Guardrails AI](https://github.com/guardrails-ai/guardrails) | Input/output validation for LLMs |
| [NeMo Guardrails (NVIDIA)](https://github.com/NVIDIA/NeMo-Guardrails) | Programmable guardrails for LLM applications |
| [Vigil](https://github.com/deadbits/vigil-llm) | LLM prompt injection detection |
| [Trylon Gateway](https://github.com/trylonai/gateway) | Self-hosted AI firewall/proxy (prompt-injection defense, PII redaction) |
| [Bifrost AI Gateway](https://github.com/maximhq/bifrost) | High-performance gateway unifying 20+ LLM providers with governance/policy enforcement |

## Hands-On Labs & CTFs

| Lab / CTF | Focus |
|-----------|-------|
| [Gandalf (Lakera AI)](https://gandalf.lakera.ai/) | Prompt-injection challenge, beginner-friendly |
| [Prompt Airlines](https://promptairlines.com/) | AI security challenges, CTF style |
| [Damn Vulnerable MCP Server](https://github.com/harishsg993010/damn-vulnerable-MCP-server) | Deliberately vulnerable MCP implementation - see [MCP Security](mcp-security.md) |
| [Vulnerable MCP Servers Lab](https://github.com/appsecco/vulnerable-mcp-servers-lab) | Collection of vulnerable MCP servers |
| [FinBot Agentic AI CTF (OWASP)](https://genai.owasp.org/resource/finbot-agentic-ai-capture-the-flag-ctf-application/) | Agentic-security-focused CTF |
| [OWASP WrongSecrets](https://owasp.org/www-project-wrongsecrets/) | Includes an LLM/AI secrets-leakage challenge |
| [HackAPrompt](https://www.aicrowd.com/challenges/hackaprompt-2023) | Prompt hacking competition |
| [Crucible (Dreadnode)](https://crucible.dreadnode.io/) | AI/ML security challenges and CTFs |
| [AI Goat](https://github.com/dhammon/ai-goat) | Vulnerable LLM CTF built on AWS |
| [Microsoft AI Red Teaming Playground Labs](https://github.com/microsoft/AI-Red-Teaming-Playground-Labs) | Hands-on red-teaming challenges with Docker/Kubernetes deployment |
| [PortSwigger Web Security Academy: Web LLM Attacks](https://portswigger.net/web-security/llm-attacks) | Free official hands-on labs on LLM API exploitation and excessive agency |
| [Huntr.com](https://huntr.com/) | Bug bounty platform specifically for AI/ML |

## Courses & Certifications

| Course / Cert | Provider |
|----------------|----------|
| [SANS SEC545: GenAI and LLM Application Security](https://www.sans.org/cyber-security-courses/genai-llm-application-security/) | SANS (maps to GIAC GAIPS) |
| [Microsoft AI Red Teaming 101](https://learn.microsoft.com/en-us/security/ai-red-team/training) | Microsoft Learn, free |
| [Coursera: Generative AI for Cybersecurity Professionals](https://www.coursera.org/specializations/generative-ai-for-cybersecurity-professionals) | IBM |
| [Certified AI Security Professional (CAISP)](https://www.practical-devsecops.com/certified-ai-security-professional/) | Practical DevSecOps |
| [GIAC AI Platform Security (GAIPS)](https://www.giac.org/certifications/ai-security-platform-security-gaips) | GIAC - hands-on CyberLive certification |
| [GIAC AI Security Automation Engineer (GASAE)](https://www.giac.org/certifications/ai-security-automation-engineer-gasae) | GIAC |
| [ISC2 AI Security Certificate](https://www.isc2.org/landing/ai-security-skills) | ISC2 |

## Communities & Newsletters

- [OWASP GenAI Slack](https://owasp.slack.com/) - `#project-top10-for-llm` channel
- [AI Village (DEF CON)](https://aivillage.org/) - AI security research community
- [MLSecOps Community](https://mlsecops.com/)
- [Embrace the Red](https://embracethered.com/) - Johann Rehberger's AI security research blog
- [LLM Security](https://llmsecurity.net/) - curated LLM security news and research
- [Protect AI Blog](https://protectai.com/blog) (now part of Palo Alto Networks)

## This Site's Own GenAI Security Toolkit

[jassics/awesome-claude-security](https://github.com/jassics/awesome-claude-security) is a Claude Code plugin marketplace covering the full security lifecycle, with dedicated GenAI-security plugins you can install directly into a Claude Code session:

- `llm-security` - OWASP LLM Top 10, prompt injection testing
- `rag-security` - retrieval poisoning and isolation checks
- `agentic-ai-security` - tool-permission audits, autonomy-boundary review
- `multimodal-security` - cross-modal injection
- `mlops-security` - ML supply chain and pipeline security
- `ai-safety` - harm modeling, safety evals, responsible red-teaming (a *distinct* discipline from AI security - see the [taxonomy note](https://github.com/jassics/awesome-claude-security/blob/main/docs/TAXONOMY.md#ai-security-vs-ai-safety))

Install with `/plugin marketplace add jassics/awesome-claude-security` inside a Claude Code session, then `/plugin install llm-security@awesome-claude-security` (or any of the plugins above).

## Where to Go Next on This Site

- Start from zero: [Preliminary AI/ML Concepts](ai-preliminary-concepts.md)
- Core attack surface: [LLM Security](llm-security.md), [RAG Security](rag-security.md), [MCP Security](mcp-security.md), [Agentic AI & Agent Security](agentic-ai-security.md)
- Practice: [AI Red Teaming](ai-red-teaming.md)
- Learn from the past: [Real-World AI Security Incidents](ai-security-incidents.md)
- Program-level: [AI Threat Modeling](ai-threat-modeling.md), [AI Data Security](ai-data-security.md), [AI Model Security](ai-model-security.md), [AI Governance](ai-governance.md)

## Credits/References

1. [jassics/awesome-genai-security](https://github.com/jassics/awesome-genai-security) - the full, continuously updated source this page distills
2. [jassics/awesome-claude-security](https://github.com/jassics/awesome-claude-security) - Claude Code plugin marketplace for security work, including GenAI security
3. [OWASP GenAI Security Project](https://genai.owasp.org/)
4. [MITRE ATLAS](https://atlas.mitre.org/)
