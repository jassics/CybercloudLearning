# AI Governance

## Overview

AI Governance establishes policies, processes, and controls to ensure AI systems are developed and used responsibly, ethically, and in compliance with regulations.

## AI Governance Framework

### Core Pillars

| Pillar | Focus |
|--------|-------|
| **Accountability** | Clear ownership and responsibility for AI systems |
| **Transparency** | Explainability of AI decisions |
| **Fairness** | Preventing bias and discrimination |
| **Privacy** | Protecting personal data |
| **Security** | Protecting AI systems from attacks |
| **Safety** | Preventing harm from AI decisions |

## Regulatory Landscape

### EU AI Act

Risk-based classification of AI systems:

| Risk Level | Examples | Requirements |
|------------|----------|--------------|
| **Unacceptable** | Social scoring, real-time biometric ID | Banned |
| **High-Risk** | Medical devices, hiring systems | Strict requirements |
| **Limited Risk** | Chatbots, deepfakes | Transparency obligations |
| **Minimal Risk** | Spam filters, games | No specific requirements |

### Other Regulations

- **NIST AI RMF** - US framework for AI risk management
- **ISO/IEC 42001** - AI management system standard
- **Singapore Model AI Governance Framework**
- **Canada's Directive on Automated Decision-Making**

## AI Risk Management

### Risk Categories

1. **Technical Risks** - Model failures, adversarial attacks
2. **Operational Risks** - Deployment issues, monitoring gaps
3. **Ethical Risks** - Bias, unfairness, lack of transparency
4. **Legal Risks** - Regulatory non-compliance
5. **Reputational Risks** - Public perception, trust issues

### Risk Assessment Process

```text
Identify → Assess → Mitigate → Monitor → Review
   ↑                                      ↓
   └──────────── Continuous ──────────────┘
```

## AI Ethics

### Key Principles

- **Beneficence** - AI should benefit society
- **Non-maleficence** - AI should not cause harm
- **Autonomy** - Respect human decision-making
- **Justice** - Fair distribution of AI benefits and risks
- **Explicability** - AI decisions should be explainable

### Bias Mitigation

| Stage | Techniques |
|-------|------------|
| **Pre-processing** | Data balancing, bias detection |
| **In-processing** | Fairness constraints during training |
| **Post-processing** | Output calibration, threshold adjustment |

## Governance Structure

### Roles and Responsibilities

- **AI Ethics Board** - Strategic oversight and policy
- **AI Risk Committee** - Risk assessment and mitigation
- **Model Risk Management** - Technical validation
- **Data Governance** - Data quality and privacy
- **Legal/Compliance** - Regulatory adherence

### Documentation Requirements

| Document | Purpose |
|----------|---------|
| **Model Cards** | Document model capabilities and limitations |
| **Data Sheets** | Document dataset characteristics |
| **Impact Assessments** | Evaluate societal impact |
| **Audit Trails** | Track model development and decisions |

### What a Model Card Actually Looks Like

A model card isn't a blank compliance form - it's a short, filled-in document a reviewer can act on. A minimal but real example for an internal support-ticket classifier:

```text
Model Card: Support Ticket Priority Classifier v2.3

Intended use: Suggest a priority (Low/Medium/High/Urgent) for inbound
support tickets. Human agent makes the final call - model output is
advisory, not auto-applied to SLAs.

Training data: 180k historical tickets (2022-2024), English only.
Excludes tickets from before the 2022 support-process change.

Known limitations:
  - Underperforms on tickets under 10 words (high false-negative rate
    for "Urgent" on terse messages)
  - Not validated on non-English tickets - do not deploy for other locales
  - Trained on B2B tickets only; do not use for consumer support queue

Evaluation metrics: 87% agreement with human-assigned priority on a
held-out 2024 Q4 test set (n=4,200). Urgent-class recall: 71%
(intentionally biased toward flagging more tickets Urgent - a false
Urgent costs an agent a few minutes; a missed Urgent costs an SLA breach).

Owner: Support Engineering team (#support-ml-oncall)
Last reviewed: 2026-05-01. Next review due: 2026-11-01.
```

This is the level of specificity a governance review actually needs - vague answers like "trained on internal data" or "performs well" don't let a reviewer make a real risk decision.

## Implementing AI Governance

### Step 1: Establish Policies

- AI acceptable use policy
- Model development standards
- Data governance requirements
- Incident response procedures

### Step 2: Build Processes

- Model review and approval workflow
- Risk assessment procedures
- Monitoring and alerting
- Regular audits

### Step 3: Deploy Technology

- Model registries
- Automated testing pipelines
- Monitoring dashboards
- Audit logging systems

### Step 4: Train People

- AI ethics training
- Technical security training
- Regulatory awareness
- Incident response drills

## Best Practices

1. **Start with governance** - Don't retrofit after deployment
2. **Document everything** - Maintain comprehensive records
3. **Engage stakeholders** - Include diverse perspectives
4. **Iterate continuously** - Governance evolves with AI
5. **Learn from incidents** - Update policies based on lessons learned

## Credits/References

1. [EU Artificial Intelligence Act - Official Text](https://artificialintelligenceact.eu/)
2. [NIST AI Risk Management Framework (AI RMF 1.0)](https://www.nist.gov/itl/ai-risk-management-framework)
3. [ISO/IEC 42001:2023 - AI Management System](https://www.iso.org/standard/81230.html)
4. [Mitchell et al., Model Cards for Model Reporting](https://arxiv.org/abs/1810.03993)
