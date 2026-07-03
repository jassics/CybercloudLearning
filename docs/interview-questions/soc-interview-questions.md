# SOC Interview Questions

The [security-interview-questions](https://github.com/jassics/security-interview-questions) repo's SOC file is still a stub upstream, and this site doesn't yet have a dedicated SOC/Blue Team product-security guide - so these are grounded in the [Blue Team, Detection & Response Study Plan](../study-plan/specialized/blue-team-detection-response-study-plan.md) plus well-established SOC fundamentals. Expect a dedicated SOC docs page and richer upstream content to fill this out further over time.

## SOC Fundamentals & Roles

??? question "Q: What actually distinguishes a SOC analyst's day-to-day from a security engineer's?"
    A SOC analyst is primarily **reactive and investigative** - triaging alerts as they come in, investigating whether something flagged by a SIEM/EDR is a real incident, and following playbooks/runbooks to contain and escalate. A security engineer is primarily **proactive and constructive** - building the detections, pipelines, and controls the SOC analyst later relies on. In practice the line blurs (detection engineers sit between the two, and senior SOC analysts often build their own detection rules), but if asked to distinguish them cleanly: the SOC analyst answers "is this activity bad, and what do I do about it right now," while the security engineer answers "how do we make sure we'd catch this, or prevent it, next time."

??? question "Q: Describe common SOC operating models and a tradeoff between them."
    - **In-house SOC** - full control over tooling, tuning, and institutional knowledge, but expensive to staff 24/7 and hard to scale quickly.
    - **MSSP (managed security service provider)** - outsourced monitoring, cheaper and provides 24/7 coverage without hiring a full team, but often produces generic alerts with less context on your specific environment and can be slower to adapt detections to your stack.
    - **Hybrid** - typically Tier 1 triage handled by an MSSP or follow-the-sun team, with in-house Tier 2/3 handling escalations and detection engineering - balances cost against the context loss of full outsourcing.

    A strong interview answer picks based on organizational maturity and budget rather than declaring one universally best.

## Logging, SIEM & Detection Engineering

??? question "Q: How would you design logging for a new web application or API from a SOC perspective?"
    Start from "what would I need to answer during an investigation," not "what's easy to log": authentication events (success/failure, source IP, MFA status), authorization failures (who tried to access what they shouldn't), all state-changing requests with the acting user/service identity, and enough context (timestamps, request IDs, correlation IDs) to reconstruct a session across services. Logs need to be centralized (shipped to a SIEM, not left on individual hosts where an attacker with access could tamper with them), tamper-evident where possible, and retained long enough to cover realistic dwell-time investigations (breaches are often discovered weeks to months after initial compromise, so short retention windows quietly destroy evidence).

??? question "Q: What makes a detection rule 'high quality' versus just noisy?"
    A high-quality detection rule is built from a specific hypothesis tied to real attacker behavior (ideally mapped to a MITRE ATT&CK technique), tuned against your own environment's baseline so it doesn't fire on routine legitimate activity, and produces an alert with enough context that a Tier 1 analyst can triage it without immediately escalating. A noisy rule is usually one written too broadly ("alert on any failed login" instead of "alert on 10+ failed logins from a single source in 5 minutes followed by a success") - it trains analysts to ignore the alert type entirely, which is functionally the same as not having the detection at all ("alert fatigue" is a real operational risk, not just an annoyance).

??? question "Q: You get an alert that could be a false positive. Walk through how you triage it."
    1. **Context first** - what triggered it, what's the baseline for this asset/user (is this normal behavior for them specifically)?
    2. **Corroborate** - check adjacent logs/telemetry (network, endpoint, identity) for anything that supports or contradicts the alert being malicious.
    3. **Scope** - if it looks real, determine what else the same actor/asset touched, not just the single flagged event.
    4. **Decide and document** - close as false positive with reasoning (so the rule can be tuned if it's a pattern), or escalate/begin containment if it's confirmed or ambiguous-but-high-risk.

    The failure mode interviewers are probing for is treating every alert as either "obviously nothing" or "full incident" with no structured middle step - triage is specifically that middle step.

## Incident Response

??? question "Q: Walk through the incident response lifecycle."
    **Preparation** (playbooks, tooling, and access ready *before* an incident, not during) → **Detection & Analysis** (identify and confirm the incident, scope its extent) → **Containment** (stop it from getting worse - short-term isolation vs. long-term structural fixes) → **Eradication** (remove the actual cause - malware, compromised credentials, the vulnerability that let it in) → **Recovery** (restore normal operations, verify the threat is actually gone before reconnecting/restoring) → **Lessons Learned** (post-incident review, feeding findings back into detections and playbooks).

    A common interview follow-up: "which phase do teams most often skip?" - Lessons Learned, because once the fire is out there's organizational pressure to move on, but skipping it means the same gap that caused this incident goes unaddressed until it recurs.

??? question "Q: How would you investigate a suspected cloud account compromise?"
    Start with identity: check the cloud provider's audit logs (CloudTrail/Azure Activity Log/Cloud Audit Logs) for the account's recent activity - unusual source IPs/geolocations, new access keys or credentials created, MFA changes, privilege escalation attempts (new role assignments, policy changes granting broader access). Cross-reference against the account's normal baseline (does this user normally operate from this region/ASN, at this time?). If compromise looks confirmed: revoke active sessions/tokens, rotate credentials, and scope what the compromised identity actually touched (which resources, what data, what changes) before declaring it fully contained - assuming a single revoked credential ends the incident without checking what it was used for is a common mistake.

??? question "Q: How do you measure whether your detection and IR program is actually effective, beyond 'we haven't been breached'?"
    Absence of a known breach isn't evidence of good detection - it might mean nothing happened, or it might mean something happened and wasn't caught. Better signals: mean time to detect (MTTD) and mean time to respond/contain (MTTR) trending down over time, detection coverage measured against a framework like MITRE ATT&CK (what techniques do we have detections for vs. not), results from purple-team exercises or tabletop simulations (did the team actually follow the playbook correctly under a simulated incident), and the false-positive rate of alerts (a program generating alerts nobody trusts isn't actually providing coverage, regardless of what it claims to detect).

## Practice Next

- [Blue Team, Detection & Response Study Plan](../study-plan/specialized/blue-team-detection-response-study-plan.md)
- [Network Security Interview Questions](network-security-interview-questions.md) - telemetry and detection concepts overlap heavily
- [GRC Interview Questions](grc-interview-questions.md) - NIST CSF's Detect/Respond/Recover functions map directly onto SOC operations
- [security-interview-questions](https://github.com/jassics/security-interview-questions/blob/main/soc-interview-questions.md) on GitHub for the canonical, evolving question set
