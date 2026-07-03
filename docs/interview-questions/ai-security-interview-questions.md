# AI Security Interview Questions

The [security-interview-questions](https://github.com/jassics/security-interview-questions) repo's AI Security file is still a stub upstream, so these questions are grounded directly in this site's [AI Security](../ai-security/ai-security-overview.md) section instead. Expect them to get merged back once the source repo catches up.

## Fundamentals & Attack Taxonomy

??? question "Q: What's the difference between data-level, model-level, and inference-level attacks on an ML system?"
    They map to *where* in the ML lifecycle the attacker interferes:

    - **Data-level** - attacking the training data itself: data poisoning (injecting malicious samples), label flipping, or data extraction (stealing training data through queries).
    - **Model-level** - attacking the trained artifact: model extraction (recreating the model via API queries, i.e. IP theft) or model inversion (reconstructing training data from the model, a privacy violation).
    - **Inference-level** - attacking the model at request time: adversarial examples (crafted inputs causing misclassification), evasion attacks (bypassing ML-based controls), and prompt injection for LLMs.

    See [AI Security Fundamentals](../ai-security/ai-security-fundamentals.md) for the full attack taxonomy table.

??? question "Q: What is prompt injection, and how is it different from a jailbreak?"
    **Prompt injection** manipulates an LLM's behavior by embedding instructions in the input - either directly (the user types "ignore previous instructions...") or indirectly (malicious instructions hidden in a document, webpage, or tool output the model reads). **Jailbreaking** specifically targets bypassing the model's safety guardrails to get it to produce disallowed content - it's a subset of what prompt injection can achieve.

    Defenses for both overlap: input sanitization, prompt hardening, output filtering, and strict separation of system vs. user vs. tool-output message roles so the model can distinguish trusted instructions from untrusted content it's merely processing.

??? question "Q: How would you defend a production LLM API against model extraction attacks?"
    Model extraction works by systematically querying an API to learn its decision boundaries (or side-channel timing/power analysis for on-device models). Practical mitigations:

    - Rate limiting and quota enforcement per API key/user
    - Query pattern monitoring/anomaly detection (bursts of near-boundary queries are a tell)
    - Output perturbation - adding small noise to confidence scores so an attacker can't cleanly map the decision surface
    - Limiting how much raw probability/confidence data is exposed in the API response at all

??? question "Q: What is differential privacy, and when would you use it over federated learning?"
    **Differential privacy** adds calibrated mathematical noise to data or model outputs so no single record can be confidently inferred, while preserving aggregate statistical utility. **Federated learning** keeps raw data on-device entirely and only shares model updates, which are then aggregated centrally.

    Use differential privacy when you need a mathematically provable privacy guarantee on a centralized dataset or model output. Use federated learning when data literally cannot leave the source environment (e.g. hospital records, mobile devices) - and the two are often combined, adding DP noise to the aggregated federated updates for defense in depth. See [AI Data Security](../ai-security/ai-data-security.md) for more on both.

## Governance & Risk

??? question "Q: How does the EU AI Act's risk-based classification work, and why does it matter for engineering teams?"
    The Act sorts AI systems into four tiers: **Unacceptable** (banned outright, e.g. social scoring), **High-Risk** (e.g. hiring systems, medical devices - subject to strict conformity requirements), **Limited Risk** (e.g. chatbots - transparency obligations like disclosing it's an AI), and **Minimal Risk** (e.g. spam filters - no specific requirements).

    It matters to engineering because the classification determines what you must build in from day one: for High-Risk systems that includes risk management documentation, data governance records, human oversight mechanisms, and logging - retrofitting these after a model ships is far more expensive than designing for them upfront. See [AI Governance](../ai-security/ai-governance.md).

??? question "Q: Walk through how you'd stand up an AI governance program at a company that has none."
    A strong answer moves through: (1) **policies first** - an AI acceptable-use policy, model development standards, data governance requirements, and an incident response plan for model-related incidents; (2) **processes** - a model review/approval workflow before anything ships, a risk assessment procedure per model, and scheduled audits; (3) **technology** - a model registry, automated testing/red-teaming pipelines, monitoring dashboards, and audit logging; (4) **people** - training for both the AI ethics/compliance side and the technical security side.

    Emphasize that governance should be established *before* deployment, not retrofitted - and that documentation (model cards, datasheets, impact assessments) is what makes audits and incident response tractable later.

## Model Security & Testing

??? question "Q: A team wants to ship an LLM feature that reads untrusted web content. What's your biggest concern and how do you test for it?"
    The biggest concern is **indirect prompt injection** - the model treats attacker-controlled content on a webpage as instructions rather than data, potentially exfiltrating data, taking unintended actions via connected tools, or misleading the user. To test: craft webpages/documents containing hidden instructions (in HTML comments, white-on-white text, metadata) and verify the model doesn't follow them; test whether the model can be tricked into calling connected tools/APIs it shouldn't; and check whether output filtering catches leaked system prompts or exfiltrated data.

??? question "Q: What tools would you use to test a model's adversarial robustness before shipping it?"
    Depends on the modality: **Adversarial Robustness Toolbox (ART)** and **Foolbox** for general adversarial example generation on vision/tabular models, **CleverHans** for TensorFlow-based adversarial testing, and **TextAttack** for NLP-specific adversarial perturbations. Beyond tooling, the process should also include extraction-risk testing (can the model be cloned via queries?) and privacy testing (does it leak training data?) - see [AI Model Security](../ai-security/ai-model-security.md) for the full pre-deployment testing matrix.

## Practice Next

- [AI Security Overview](../ai-security/ai-security-overview.md)
- [AI Threat Modeling](../ai-security/ai-threat-modeling.md)
- [awesome-genai-security](https://github.com/jassics/awesome-genai-security) for curated further reading
- [security-interview-questions](https://github.com/jassics/security-interview-questions) on GitHub for the canonical, evolving question set
