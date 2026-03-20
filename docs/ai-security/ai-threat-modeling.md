# AI Threat Modeling

## Overview

AI threat modeling adapts traditional threat modeling to address unique risks in machine learning systems. It helps identify vulnerabilities before deployment.

## AI Threat Modeling Frameworks

### STRIDE for AI

| Threat | AI Context |
|--------|------------|
| **Spoofing** | Fake training data, impersonating data sources |
| **Tampering** | Data poisoning, model manipulation |
| **Repudiation** | Lack of audit trails for model decisions |
| **Information Disclosure** | Model inversion, membership inference |
| **Denial of Service** | Resource exhaustion attacks on inference |
| **Elevation of Privilege** | Prompt injection, jailbreaking LLMs |

### MITRE ATLAS Framework

ATLAS (Adversarial Threat Landscape for AI Systems) provides:

- **Tactics** - Adversary goals (Reconnaissance, Initial Access, etc.)
- **Techniques** - Methods to achieve goals
- **Case Studies** - Real-world AI attacks

## AI System Components to Analyze

1. **Data Pipeline** - Collection, storage, preprocessing
2. **Training Infrastructure** - Compute, frameworks, hyperparameters
3. **Model Repository** - Model storage, versioning, access
4. **Inference System** - APIs, edge deployment, monitoring
5. **Human Interfaces** - Labeling tools, admin dashboards

## Threat Modeling Process for AI

### Step 1: Define Scope

- What type of ML system? (Classification, NLP, Computer Vision)
- What is the deployment model? (Cloud API, Edge, Embedded)
- Who are the users? What data do they provide?

### Step 2: Create Architecture Diagram

Include:

- Data sources and flows
- Model training pipeline
- Inference endpoints
- Trust boundaries

### Step 3: Identify Threats

For each component, consider:

- What could go wrong?
- Who might attack this?
- What's the impact?

### Step 4: Prioritize Risks

Use risk matrix:

| Likelihood/Impact | Low | Medium | High |
|-------------------|-----|--------|------|
| **High** | Medium | High | Critical |
| **Medium** | Low | Medium | High |
| **Low** | Low | Low | Medium |

### Step 5: Define Mitigations

Map threats to controls from [AI Security Fundamentals](ai-security-fundamentals.md).

## Common AI Threat Scenarios

!!! warning "High-Risk Scenarios"
    - **Public-facing ML APIs** - High exposure to extraction and adversarial attacks
    - **Models trained on user data** - Privacy and poisoning risks
    - **LLMs with tool access** - Prompt injection leading to unauthorized actions
    - **Autonomous systems** - Safety-critical decision manipulation

## Tools for AI Threat Modeling

- **Microsoft Threat Modeling Tool** - With AI extensions
- **OWASP Threat Dragon** - Open-source alternative
- **Counterfit** - Microsoft's AI security testing tool
- **ART (Adversarial Robustness Toolbox)** - IBM's testing framework
