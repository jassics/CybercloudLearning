# GRC Interview Questions

The [security-interview-questions](https://github.com/jassics/security-interview-questions) repo's GRC file is still a stub upstream, so these are grounded directly in this site's [GRC](../grc/grc-overview.md) section instead. Expect them to get merged back once the source repo catches up.

## GRC Fundamentals

??? question "Q: What's the difference between governance, risk, and compliance, and why bundle them together?"
    - **Governance** - the policies, procedures, and organizational structure that set security direction (who decides what, and how).
    - **Risk management** - the ongoing cycle of identifying, assessing, treating, and monitoring risks.
    - **Compliance** - adherence to laws, regulations, and standards (which are themselves usually a codified subset of "good risk management").

    They're bundled because they reinforce each other: governance sets the policies that risk management operationalizes, and compliance is largely evidence that governance and risk management are actually working. Treating them as three disconnected functions (a common anti-pattern) leads to duplicated controls, audit fatigue, and gaps where nobody owns a given risk. See [GRC Overview](../grc/grc-overview.md).

??? question "Q: Walk through the four risk treatment options and give an example of each."
    - **Accept** - acknowledge the risk and monitor it (e.g. a low-severity finding on a legacy system slated for decommission in a month).
    - **Mitigate** - implement controls to reduce likelihood/impact (e.g. adding MFA to reduce credential-stuffing risk).
    - **Transfer** - shift the risk elsewhere, typically via insurance or outsourcing (e.g. cyber insurance, or using a PCI-compliant payment processor instead of handling card data yourself).
    - **Avoid** - eliminate the risky activity entirely (e.g. deciding not to build a feature that would require storing sensitive biometric data at all).

    A good interview answer picks a treatment based on cost of mitigation vs. cost of the risk materializing - not defaulting to "mitigate everything."

??? question "Q: What are policies, standards, procedures, and guidelines, and how do they differ?"
    Think of them as a hierarchy of decreasing authority and increasing specificity: **policies** state high-level intent ("all data must be encrypted at rest"), **standards** define specific required parameters ("use AES-256"), **procedures** are step-by-step instructions to meet the standard ("here's how to configure disk encryption on our EC2 fleet"), and **guidelines** are recommended-but-not-mandatory practices. Auditors typically check whether procedures actually implement the standards, and whether standards actually satisfy the policy - gaps anywhere in that chain are common audit findings.

## Frameworks & Standards

??? question "Q: How would you explain ISO 27001 to an engineering team that's never heard of it?"
    ISO 27001 certifies that an organization runs a systematic **Information Security Management System (ISMS)** - not that any specific technology is secure. It requires identifying information assets, assessing risks to them, implementing controls from Annex A (93 controls across 4 themes: organizational, people, physical, technological), and continually monitoring/improving. For engineers, the practical impact is usually: expect to document what you're protecting and why, expect periodic control effectiveness reviews, and expect that "we did it once" isn't enough - ISO 27001 audits check for continual improvement, not a one-time snapshot. See [ISO/IEC 27001:2022](../grc/iso27k1.md).

??? question "Q: Compare the NIST Cybersecurity Framework (CSF) and the NIST Risk Management Framework (RMF) - when would you reach for each?"
    **NIST CSF** is a five-function framework (Identify, Protect, Detect, Respond, Recover) used mainly for organization-wide risk *communication and prioritization* - it's lightweight and works well as an executive-facing maturity model. **NIST RMF** is a seven-step, more prescriptive process (Prepare, Categorize, Select, Implement, Assess, Authorize, Monitor) aimed at *system-level* authorization, most associated with US federal/government system accreditation (ATO).

    In practice: use CSF to structure a security program and talk to leadership about posture; use RMF when you need to formally authorize a specific system for operation with documented, assessed controls. See [NIST CSF](../grc/nist-csf.md) and [NIST RMF](../grc/nist-rmf.md).

## Privacy & Data Protection

??? question "Q: What's the difference between privacy and security, and why does an interviewer care that you know it?"
    **Security** protects data from unauthorized access/threats (encryption, access control) - the question is "can we protect it?" **Privacy** governs whether and how data should be used at all (consent, purpose limitation, individual rights) - the question is "should we?" You can have excellent security around data you had no right to collect in the first place, which is exactly the scenario regulators (and interviewers) are probing for. See [Data Privacy](../grc/data-privacy.md).

??? question "Q: A user invokes their GDPR 'right to erasure.' What has to actually happen, and where does it get complicated?"
    You must delete their personal data without undue delay, including from backups where feasible - not just deactivate the account. It gets complicated with: data replicated across multiple systems/vendors (do you have a process to propagate deletion?), data baked into ML training sets (deleting a source record doesn't un-train a model that learned from it - see "model unlearning" in [AI Data Security](../ai-security/ai-data-security.md)), legal holds or other lawful bases that override the erasure right (e.g. financial record retention requirements), and backups that can't be selectively purged without a restore-and-rebuild process. A strong answer acknowledges the "easy in policy, hard in distributed systems" gap.

## Practice Next

- [GRC Overview](../grc/grc-overview.md)
- [GRC Study Plan](../study-plan/grc-study-plan.md)
- [security-interview-questions](https://github.com/jassics/security-interview-questions) on GitHub for the canonical, evolving question set
