# GuardDuty

## What GuardDuty Does

GuardDuty is AWS's managed threat-detection service - it continuously analyzes [CloudTrail](cloudtrail.md) events, VPC Flow Logs, DNS logs, S3 data events, and EKS audit logs using threat intelligence and machine learning, and surfaces findings when something looks malicious. It's the alarm system that sits behind IAM's front door and CloudTrail's security camera.

Unlike CloudTrail (which just records), GuardDuty actively correlates signals - a single failed login isn't a finding, but a pattern matching known credential-compromise behavior is.

## What It Actually Detects

| Category | Example Finding Types | What It Means |
|----------|------------------------|----------------|
| **Reconnaissance** | `Recon:EC2/PortProbeUnprotectedPort` | Someone is port-scanning your resources |
| **Instance Compromise** | `Backdoor:EC2/C2Activity.B`, `CryptoCurrency:EC2/BitcoinTool.B` | An EC2 instance is communicating with known command-and-control infrastructure or mining crypto |
| **Account Compromise** | `UnauthorizedAccess:IAMUser/ConsoleLoginSuccess.B`, `Impossible Traveler` | Credentials are being used in a way inconsistent with normal behavior (impossible geographic travel, unusual API calls) |
| **S3 Threats** | `Exfiltration:S3/AnomalousBehavior`, `PenTest:S3/KaliLinux` | Anomalous data access patterns or known attack tooling touching S3 |
| **EKS/Container Threats** | `Persistence:Kubernetes/ContainerWithSensitiveMount` | Suspicious Kubernetes API activity or risky container configuration |

## Finding Severity and What It Means for Response

GuardDuty scores every finding 0.1-8.9+, bucketed into Low/Medium/High:

| Severity | Example | Typical Response |
|----------|---------|-------------------|
| **High (7.0-8.9)** | Active C2 communication, credential exfiltration | Immediate response - isolate the resource, rotate credentials |
| **Medium (4.0-6.9)** | Port scanning, unusual API call volume | Investigate within the day, may indicate early-stage reconnaissance |
| **Low (0.1-3.9)** | Failed login attempts, benign anomalies | Track for patterns, rarely needs immediate action alone |

Severity alone shouldn't drive response blindly - a Medium finding on your production database host deserves more urgency than a High finding on a disposable dev sandbox. Context (which resource, what environment) matters as much as the score.

## Turning Findings Into Action

GuardDuty findings are only useful if they reach a human or an automated response - a dashboard nobody checks is theater, not detection.

```bash
# Enable GuardDuty in a region
aws guardduty create-detector --enable

# List active findings
aws guardduty list-findings --detector-id <detector-id> \
  --finding-criteria '{"Criterion":{"severity":{"Gte":7}}}'
```

A typical production pipeline: **GuardDuty finding → EventBridge rule → Lambda (auto-remediation for known-safe actions, e.g. isolate an instance's security group) + notification to Security Hub/SIEM/ticketing (Jira, PagerDuty) for anything requiring human judgment.**

```json
// EventBridge rule pattern matching high-severity GuardDuty findings
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"],
  "detail": {
    "severity": [{ "numeric": [">=", 7] }]
  }
}
```

## Tuning Out Noise Without Suppressing Real Threats

Noisy findings that get ignored train your team to ignore GuardDuty entirely - the real risk of "alert fatigue." The right way to handle known-benign activity is **suppression rules scoped as narrowly as possible**, not disabling finding types wholesale:

- Suppress `Recon:EC2/PortProbeUnprotectedPort` for a specific, known vulnerability-scanner IP range used by your own security team - not for the finding type across the whole account.
- Never suppress by finding *type* alone across an entire account/org - that blinds you to the same attack pattern from a genuinely malicious source.
- Review suppression rules periodically; a rule created for a decommissioned scanner is a permanent blind spot if forgotten.

## Best Practices Checklist

- [ ] GuardDuty enabled in every active region, ideally org-wide via a delegated administrator account
- [ ] S3 protection, EKS protection, and Malware Protection features enabled (not just the base detector)
- [ ] Findings routed via EventBridge to both automated remediation (for known-safe cases) and human review (SIEM/ticketing)
- [ ] Suppression rules scoped narrowly (specific resource/IP), reviewed periodically
- [ ] High-severity findings have a documented, rehearsed response runbook
- [ ] Findings aggregated into Security Hub alongside Config and Inspector for a unified view

## Practice Next

- [CloudTrail](cloudtrail.md) - one of GuardDuty's core data sources
- [AWS Security Overview](aws-security-overview.md)
- [IAM Security](iam-security.md) - many GuardDuty findings resolve to a compromised identity

## Credits/References

1. [Amazon GuardDuty User Guide](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html)
2. [GuardDuty Finding Types](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_finding-types-active.html)
3. [Automating GuardDuty Response with EventBridge](https://aws.amazon.com/blogs/security/)
