# GenAI Security Study Plan (GenAI/LLM)

This page is updated based on [jassics/security-study-plan/genai-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/genai-security-study-plan.md), covering all the topics, concepts, blogs, videos, books, and newsletters needed to build GenAI security skills.

It should take 6-9 months to be good at GenAI security so that you can do one or more of the below:

1. LLM pentesting
2. GenAI security assessment
3. Design and implement secure GenAI/LLM architectures for organizations
4. Understand GenAI from a GRC perspective
5. Apply different GenAI security frameworks
6. AI-enabled threat modeling, or threat modeling of AI systems
7. Get a good grip on LLM safety, guardrails, responsible AI, and AI ethics

Note: this plan does not require core AI/ML skills - everything here is scoped with a security focus. This also pairs well with the site's own [AI Security](../../ai-security/ai-security-overview.md) section.

!!! important "Fast-moving field"
    GenAI security is still evolving, so this plan (and the source repo) keeps changing. Check back often.

## Organizational Capabilities You'll Be Job-Ready For

### Security Assessments & Audits
- Conduct comprehensive GenAI security assessments using the [OWASP LLM Top 10 framework](https://genai.owasp.org/)
- Perform LLM application penetration testing and vulnerability assessments
- Audit RAG (Retrieval Augmented Generation) implementations for security risks
- Evaluate prompt injection and jailbreaking vulnerabilities
- Assess model security, including adversarial attacks and data poisoning risks
- Review AI/ML supply chain security (model provenance, dependencies, third-party APIs)

### Governance, Risk & Compliance (GRC)
- Develop GenAI security policies aligned with [NIST AI RMF](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf)
- Create AI governance frameworks and risk management strategies
- Implement compliance controls for AI regulations ([EU AI Act](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=CELEX%3A32021R0215), etc.)
- Establish AI ethics and responsible AI practices
- Design AI security awareness training programs
- Create incident response plans specifically for AI/ML security incidents

### Architecture & Implementation
- Design secure AI/ML pipelines and infrastructure
- Implement secure GenAI architectures (secure RAG, fine-tuning, inference)
- Deploy AI security tools (LLM Guard, model scanning, prompt filtering)
- Establish secure model deployment and MLOps practices
- Design data privacy controls for AI training/inference data
- Implement monitoring and logging for AI systems

### Risk Management & Threat Modeling
- Conduct [AI/ML-specific threat modeling](https://www.matillion.com/blog/ai-threat-modeling) exercises
- Assess business risks associated with GenAI implementations
- Develop risk mitigation strategies for AI adoption
- Create AI security metrics and KPIs for organizational reporting
- Establish AI risk registers and continuous monitoring processes

### Security Engineering & DevSecOps
- Integrate AI security into CI/CD pipelines
- Implement security testing for AI/ML models and applications
- Design secure model training environments and data handling processes
- Establish model version control and security scanning practices
- Automate security testing for prompt injection and other LLM vulnerabilities

### Incident Response & Forensics
- Investigate AI/ML security incidents and breaches
- Develop playbooks for AI-specific security incidents
- Perform forensic analysis on compromised AI systems
- Create incident classification systems for AI/ML security events

### Consulting & Advisory Services
- Provide GenAI security consulting to organizations
- Conduct security reviews of vendor AI solutions
- Advise on secure AI procurement and third-party risk management
- Lead AI security transformation initiatives
- Mentor and train internal security teams on AI security

## ToC

1. [GenAI/LLM Fundamental Concepts](#genai-fundamental-concepts) - 4 weeks
2. [Prompt Engineering](#prompt-engineering) - 1 week
3. [RAG (Retrieval Augmented Generation)](#rag-retrieval-augmented-generation) - 1-2 weeks
4. [Fine Tuning](#fine-tuning) - 2 weeks
5. [AI Agents](#ai-agents) - 1 week
6. [Agentic AI](#agentic-ai) - 1 week
7. [MCP (Model Context Protocol)](#mcp-model-context-protocol) - 1 week
8. [Certifications](#certifications) - on your bandwidth and wish
9. [GenAI Interview Questions](#genai-interview-questions)
10. [GenAI Security Tools](#genai-security-tools)

---

## GenAI Fundamental Concepts
**Duration: 4 weeks**

### Week 1: AI/ML Foundations & LLM Basics
- [ ] **Understanding AI vs ML vs Deep Learning vs GenAI**
    - [What are Foundation Models](https://www.datacamp.com/blog/what-are-foundation-models)
    - [Introduction to Large Language Models](https://www.coursera.org/learn/generative-ai-with-llms)
    - [Transformer Architecture Explained](https://jalammar.github.io/illustrated-transformer/)
- [ ] **LLM Architecture & Components** - attention mechanisms, encoder-decoder architecture, pre-training vs fine-tuning, token embeddings
- [ ] **Popular LLM Models** - GPT family, Claude (Anthropic), Llama 2/3 (Meta), Gemini (Google), open-source vs proprietary

### Week 2: LLM Security Fundamentals
- [ ] **OWASP LLM Top 10** - [full list](https://owasp.org/www-project-top-10-for-large-language-model-applications/assets/PDF/OWASP-Top-10-for-LLMs-2023-v1_1.pdf): Prompt Injection, Insecure Output Handling, Training Data Poisoning, Model DoS, Supply Chain Vulnerabilities, Sensitive Information Disclosure, Insecure Plugin Design, Excessive Agency, Overreliance, Model Theft
- [ ] **Common Attack Vectors** - [prompt injection & jailbreaking](https://ogre51.medium.com/security-of-llm-apps-prompt-injection-jailbreaking-fb9fc5c883a8), data poisoning, model extraction/theft, adversarial examples, membership inference

### Week 3: AI Governance & Compliance
- [ ] **Regulatory Frameworks** - [NIST AI RMF](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf), [EU AI Act](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=CELEX%3A32021R0215), [NIST AI RMF Playbook](https://airc.nist.gov/AI_RMF_Knowledge_Base/Playbook), ISO/IEC 23053:2022
- [ ] **AI Ethics & Responsible AI** - bias/fairness, transparency/explainability, privacy, accountability and human oversight

### Week 4: Threat Modeling & Risk Assessment
- [ ] **AI-Specific Threat Modeling** - [Microsoft's AI/ML Threat Modeling](https://learn.microsoft.com/en-us/security/engineering/threat-modeling-aiml), [Matillion's AI Threat Modeling](https://www.matillion.com/blog/ai-threat-modeling), [Quick AI Threat Model Check](https://plot4.ai/assessments/quick-check) - also see this site's [AI Threat Modeling](../../ai-security/ai-threat-modeling.md) page
- [ ] **Risk Assessment Frameworks** - [NIST Adversarial ML](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.100-2e2023.pdf), [Failure Modes in ML](https://securityandtechnology.org/wp-content/uploads/2020/07/failure_modes_in_machine_learning.pdf)

**Hands-on Practice:**
- [ ] Complete the [Gandalf LLM Security Challenge](https://gandalf.lakera.ai/)
- [ ] Try the [Prompt Airlines CTF](https://promptairlines.com/)
- [ ] Practice with the [LLM Security Portal](https://llmsecurity.net/)

---

## Prompt Engineering
**Duration: 1 week**

- [ ] **Fundamentals** - zero-shot/few-shot/chain-of-thought prompts, prompt structure, context window limitations
- [ ] **Security-Focused Prompt Engineering** - defensive prompting, input validation via prompts, output sanitization, injection prevention
- [ ] **Prompt Injection Attacks** - direct, indirect, jailbreaking, prompt leaking
- [ ] **Defensive Strategies** - prompt templates/parameterization, input filtering, output monitoring, role-based prompt design

**Hands-on Practice:**
- [ ] Practice prompt injection techniques on safe platforms
- [ ] Design secure prompt templates
- [ ] Test prompt robustness against various attack vectors

---

## RAG (Retrieval Augmented Generation)
**Duration: 1-2 weeks**

### Week 1: RAG Fundamentals
- [ ] [RAG: The Essential Guide](https://www.nightfall.ai/ai-security-101/retrieval-augmented-generation-rag), [Why RAG is Revolutionising GenAI](https://www.immuta.com/guides/data-security-101/retrieval-augmented-generation-rag/)
- [ ] Components: retrieval system, knowledge base, generation model, vector databases/embeddings, chunking strategies
- [ ] Implementation patterns: simple vs advanced RAG, multi-step reasoning, hybrid search, RAG with fine-tuned models

### Week 2: RAG Security (optional deeper dive)
- [ ] [Riding the RAG Trail: Access, Permissions and Context](https://www.lasso.security/blog/riding-the-rag-trail-access-permissions-and-context)
- [ ] [Security Risks with RAG Architectures](https://ironcorelabs.com/security-risks-rag/)
- [ ] [Mitigating Security Risks in RAG Applications](https://cloudsecurityalliance.org/blog/2023/11/22/mitigating-security-risks-in-retrieval-augmented-generation-rag-llm-applications)
- [ ] Access control for knowledge bases, data privacy in retrieval, context injection attacks, information leakage, secure document pipelines

**Hands-on Practice:**
- [ ] Build a simple RAG system with security controls
- [ ] Test for information leakage vulnerabilities
- [ ] Implement access controls for knowledge bases

---

## Fine Tuning
**Duration: 2 weeks**

### Week 1: Fine-Tuning Fundamentals
- [ ] Pre-training vs fine-tuning vs prompt engineering
- [ ] Types: full fine-tuning, parameter-efficient (LoRA, QLoRA)
- [ ] Techniques: supervised fine-tuning (SFT), RLHF, Constitutional AI, domain-specific fine-tuning

### Week 2: Fine-Tuning Security
- [ ] Training data security/privacy, model poisoning via fine-tuning, backdoor attacks, model extraction risks
- [ ] Secure practices: data sanitization, secure training environments, model versioning/provenance, security testing of fine-tuned models

**Hands-on Practice:**
- [ ] Fine-tune a small model with security considerations
- [ ] Test for data leakage in fine-tuned models
- [ ] Implement secure fine-tuning pipelines

---

## AI Agents
**Duration: 1 week**

- [ ] **Fundamentals** - agent architectures (ReAct, Plan-and-Execute, multi-agent), tool use/function calling, memory/state management
- [ ] **Types** - conversational, task-specific, autonomous, multi-agent systems
- [ ] **Security Risks** - excessive agency, tool misuse/privilege escalation, agent-to-agent communication security, persistent memory risks
- [ ] **Securing Agents** - least privilege, action validation/approval workflows, behavior monitoring, secure tool integration patterns

**Hands-on Practice:**
- [ ] Build a simple AI agent with security controls
- [ ] Test agent behavior under various scenarios
- [ ] Implement monitoring for agent actions

---

## Agentic AI
**Duration: 1 week**

- [ ] **Concepts** - autonomous decision-making, goal-oriented behavior, planning/reasoning, human-AI collaboration
- [ ] **Architectures** - multi-agent orchestration, hierarchical agent systems, distributed agentic networks, agent communication protocols
- [ ] **Unique Security Challenges** - emergent behaviors, goal misalignment/specification gaming, inter-agent trust, scalability of controls
- [ ] **Governance** - boundaries/constraints, monitoring/auditing behavior, human oversight, ethics in autonomous systems

**Hands-on Practice:**
- [ ] Design security controls for agentic systems
- [ ] Analyze case studies of agentic AI failures
- [ ] Develop monitoring strategies for autonomous agents

---

## MCP (Model Context Protocol)
**Duration: 1 week**

- [ ] **Fundamentals** - what MCP is, architecture/components, client-server communication, resource management/sharing
- [ ] **Implementation** - setting up MCP servers/clients, resource discovery/access, tool integration, context sharing
- [ ] **Security** - authentication/authorization, resource access control, data privacy in context sharing, network security
- [ ] **Best Practices** - secure server deployment, client-side security, monitoring MCP interactions, incident response

**Hands-on Practice:**
- [ ] Set up a secure MCP environment
- [ ] Implement access controls for MCP resources
- [ ] Test MCP security configurations

---

## Certifications
**Duration: based on your bandwidth and goals**

- [ ] [Certified AI/ML Pentester (SecOps Group)](https://secops.group/product/certified-ai-ml-pentester/) - covers LLM pentest methodology with hands-on assessments
- [ ] Cloud AI security certs: AWS ML Specialty, Google Cloud Professional ML Engineer, Azure AI Engineer Associate
- [ ] Vendor-specific: OpenAI Safety and Alignment, Anthropic Constitutional AI, Microsoft Responsible AI, Google AI Ethics

**Preparation Resources:**
- [ ] [AttackIQ Foundations of AI Security](https://www.academy.attackiq.com/courses/foundations-of-ai-security)
- [ ] [Coursera AI for Cybersecurity Specialization](https://www.coursera.org/specializations/ai-for-cybersecurity)
- [ ] [IBM GenAI for Cybersecurity Professionals](https://www.coursera.org/specializations/generative-ai-for-cybersecurity-professionals)

---

## GenAI Interview Questions

### Technical Questions
- Explain the transformer architecture and its security implications
- What are the key differences between GPT, BERT, and T5 models?
- How do attention mechanisms work and what security risks do they pose?
- Walk through the OWASP LLM Top 10 with examples
- How would you test an LLM application for prompt injection vulnerabilities?
- Explain the difference between direct and indirect prompt injection
- What are the main security considerations when implementing RAG?
- How would you secure a fine-tuning pipeline?

### Scenario-Based Questions
- "A company wants a customer service chatbot using GPT-4. What security risks would you identify?"
- "How would you conduct a security assessment of an existing LLM application?"
- "Design a secure architecture for a RAG-based document Q&A system."
- "An LLM application is leaking sensitive customer data. How would you investigate?"
- "Users report the chatbot is giving inappropriate responses. What's your approach?"
- "A competitor seems to have extracted your fine-tuned model. How do you respond?"

### Governance and Compliance
- How does the EU AI Act impact LLM deployments?
- What are the key components of NIST AI RMF?
- How would you implement AI governance in an organization?
- What metrics would you use to measure AI security posture?

More AI security questions live on the [AI Security interview questions](../../interview-questions/ai-security-interview-questions.md) page.

---

## GenAI Security Tools

### Open Source
- **[LLM Guard (ProtectAI)](https://github.com/protectai/llm-guard)** - input/output filtering, prompt injection detection, sensitive data redaction ([playground](https://huggingface.co/spaces/protectai/llm-guard-playground))
- **[ModelScan (ProtectAI)](https://github.com/protectai/modelscan)** - scans AI/ML models for security vulnerabilities and malicious code
- **[AI Exploits (ProtectAI)](https://github.com/protectai/ai-exploits)** - collection of AI/ML security exploits for education/testing
- **[Garak](https://github.com/leondz/garak)** - LLM vulnerability scanner, extensible framework
- **[PromptFoo](https://github.com/promptfoo/promptfoo)** - LLM evaluation/testing with security-focused test cases, CI/CD integration

### Commercial Platforms
- **Lakera Guard** - real-time LLM security monitoring, prompt injection detection, content filtering
- **Robust Intelligence** - AI security/monitoring, model validation, drift and attack monitoring
- **WhyLabs** - ML monitoring/observability, data drift detection

### Bug Bounty & Monitoring
- **[Huntr.com](https://huntr.com/)** - the first AI/ML bug bounty platform
- **LangSmith** - LLM application monitoring, trace analysis, security metrics
- **Weights & Biases** - ML experiment tracking, model monitoring/versioning

### Cloud-Native Security
- **AWS Bedrock Guardrails** - content filtering, custom guardrail policies
- **Azure AI Content Safety** - content moderation, custom classification
- **Google Cloud AI Platform Security** - model security scanning, IAM, audit logging

### Implementation Checklist
- [ ] Evaluate tools based on your specific use case
- [ ] Set up monitoring/alerting for LLM applications
- [ ] Implement input/output filtering and validation
- [ ] Deploy model scanning in CI/CD pipelines
- [ ] Establish incident response procedures for AI incidents
- [ ] Run regular security assessments and penetration tests
- [ ] Stay current with new tools and techniques

## Additional Resources

**Courses:** [Stanford CS324: LLMs](https://stanford-cs324.github.io/winter2022/) - [Princeton COS 597G](https://www.cs.princeton.edu/courses/archive/fall22/cos597G/) - [Coursera: Generative AI with LLMs](https://www.coursera.org/learn/generative-ai-with-llms) - [Coursera: GenAI Engineering Specialization](https://www.coursera.org/specializations/generative-ai-engineering-with-llms)

**Guides & Checklists:** [OWASP LLM Top 10](https://owasp.org/www-project-top-10-for-large-language-model-applications/assets/PDF/OWASP-Top-10-for-LLMs-2023-v1_1.pdf) - [OWASP LLM AI Security & Governance Checklist](https://owasp.org/www-project-top-10-for-large-language-model-applications/llm-top-10-governance-doc/LLM_AI_Security_and_Governance_Checklist.pdf) - [NIST AI RMF](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf) - [Microsoft Threat Modeling AI/ML](https://learn.microsoft.com/en-us/security/engineering/threat-modeling-aiml)

**Challenges & CTFs:** [Gandalf](https://gandalf.lakera.ai/) - [Prompt Airlines](https://promptairlines.com/) - [SecOps Certified AI/ML Pentester Exam](https://secops.group/product/certified-ai-ml-pentester/)

**More curated links:** [jassics/awesome-genai-security](https://github.com/jassics/awesome-genai-security)

**Practice next:** [AI Security interview questions](../../interview-questions/ai-security-interview-questions.md) for interview prep, and [jassics/security-study-plan](https://github.com/jassics/security-study-plan) for the latest updates to this plan.
