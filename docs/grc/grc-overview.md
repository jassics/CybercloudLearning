# GRC (Governance, Risk and Compliance) Overview

## What is GRC?

GRC stands for **Governance, Risk, and Compliance** - an integrated approach to managing organizational security posture.

| Component | Description |
|-----------|-------------|
| **Governance** | Policies, procedures, and organizational structure |
| **Risk Management** | Identifying, assessing, and mitigating risks |
| **Compliance** | Adhering to laws, regulations, and standards |

## Why GRC Matters

- **Reduces risk** - Systematic approach to identifying and addressing threats
- **Ensures compliance** - Avoids fines and legal issues
- **Improves efficiency** - Eliminates redundant controls
- **Builds trust** - Demonstrates security commitment to stakeholders

## GRC Framework Components

### Governance

- **Security policies** - High-level security direction
- **Standards** - Specific requirements to implement policies
- **Procedures** - Step-by-step instructions
- **Guidelines** - Recommendations and best practices

### Risk Management

```text
Identify → Assess → Treat → Monitor → Review
```

**Risk Treatment Options:**

- **Accept** - Acknowledge and monitor
- **Mitigate** - Implement controls to reduce risk
- **Transfer** - Insurance or outsourcing
- **Avoid** - Eliminate the risky activity

**What a real risk register entry looks like** - not just the abstract cycle above, but the actual artifact a GRC analyst maintains:

| Risk ID | Description | Likelihood | Impact | Treatment | Owner | Status |
|---------|-------------|------------|--------|-----------|-------|--------|
| R-014 | Third-party vendor has access to customer PII with no signed DPA | Medium | High | Mitigate - block data access until DPA signed, add to vendor risk review cadence | Vendor Risk Manager | Open, due 2026-08-01 |
| R-015 | Legacy internal tool has no MFA, used by 3 admins | Low | High | Mitigate - enforce MFA via SSO gateway | IT Security Lead | In Progress |

This is the level of specificity an auditor or a manager expects - "we manage risk" isn't an answer, a tracked register with owners and dates is.

### Compliance

Common frameworks and regulations:

| Framework/Regulation | Focus |
|---------------------|-------|
| [ISO 27001](iso27k1.md) | Information Security Management |
| [NIST CSF](nist-csf.md) | Cybersecurity Framework |
| [NIST RMF](nist-rmf.md) | Risk Management Framework |
| [GDPR](gdpr.md) | EU Data Protection |
| [Data Privacy](data-privacy.md) | Privacy Regulations |

## GRC Roles

| Role | Responsibilities |
|------|------------------|
| **CISO** | Overall security strategy and governance |
| **GRC Manager** | Framework implementation and compliance |
| **Risk Analyst** | Risk assessment and reporting |
| **Compliance Officer** | Regulatory adherence |
| **Internal Auditor** | Control effectiveness verification |

## GRC Tools

- **ServiceNow GRC** - Enterprise GRC platform
- **RSA Archer** - Risk management solution
- **OneTrust** - Privacy and compliance
- **LogicGate** - Risk and compliance automation
- **Drata** - Compliance automation

## Getting Started with GRC

1. **Understand your obligations** - Identify applicable regulations
2. **Assess current state** - Gap analysis against frameworks
3. **Define risk appetite** - How much risk is acceptable?
4. **Implement controls** - Address gaps systematically
5. **Monitor and improve** - Continuous compliance

## Practice Next

- [GRC Interview Questions](../interview-questions/grc-interview-questions.md)
- [GRC Study Plan](../study-plan/grc-study-plan.md)

## Credits/References

1. [NIST SP 800-37: Risk Management Framework](https://csrc.nist.gov/pubs/sp/800/37/r2/final)
2. [ISO/IEC 27001:2022](https://www.iso.org/standard/27001)
3. [OCEG GRC Capability Model (Red Book)](https://www.oceg.org/redbook/)