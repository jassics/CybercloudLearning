# AWS Security Overview

## Start Here: The Shared Responsibility Model

AWS secures the cloud; you secure what's in the cloud. Getting this boundary wrong is the single biggest cause of cloud breaches - not exotic zero-days.

| AWS Is Responsible For | You Are Responsible For |
|-------------------------|--------------------------|
| Physical data center security | IAM policies and least privilege |
| Hypervisor and host OS patching | Guest OS patching (EC2) |
| Network infrastructure | Security groups, NACLs, VPC design |
| Managed service internals (e.g. RDS engine) | Data encryption, backups, access control |
| Global infrastructure availability | Application-layer security |

For managed services (S3, Lambda, DynamoDB) AWS takes on more of the stack, but **data classification, IAM, and configuration are always yours** - this is why S3 bucket misconfigurations are one of the most common breach patterns despite S3 itself being secure by design.

## The Core AWS Security Services Landscape

You don't need to memorize every AWS service to be effective - you need to know which service answers which question:

| Question | Service |
|----------|---------|
| "Who can do what?" | [IAM](iam-security.md) |
| "Who did what, when?" | [CloudTrail](cloudtrail.md) |
| "Is something actively malicious happening?" | [GuardDuty](guardduty.md) |
| "Is my resource configuration compliant/drifted?" | AWS Config |
| "Where's my encryption key and who can use it?" | [KMS](kms.md) |
| "Is this S3 bucket safe?" | [S3 Security](s3-security.md) |
| "Do I have sensitive data (PII) I don't know about?" | Macie |
| "Are my EC2/ECR images vulnerable?" | Inspector |
| "Am I blocking web attacks at the edge?" | WAF + Shield |
| "Where do all my findings roll up?" | Security Hub |

A good mental model: **IAM is the front door, CloudTrail is the security camera, GuardDuty is the alarm system, Config is the compliance checklist, and Security Hub is the dashboard that ties it all together.**

## How a Real AWS Security Review Flows

This is close to what you'd actually be asked to do in an interview scenario or on the job in your first 90 days:

1. **Map the account structure** - Is this a single account or an AWS Organization with multiple accounts? Multi-account (via AWS Organizations + Service Control Policies) is the modern best practice - it isolates blast radius between prod/dev/security-tooling.
2. **Audit IAM first** - Root account has MFA and no access keys? Any users with wildcard (`*:*`) policies? Unused access keys older than 90 days? See [IAM Security](iam-security.md).
3. **Check the logging baseline** - Is CloudTrail enabled account-wide (or org-wide), multi-region, with log file validation on? See [CloudTrail](cloudtrail.md).
4. **Turn on threat detection** - Is GuardDuty enabled in every region/account? Are findings actually routed somewhere a human sees them? See [GuardDuty](guardduty.md).
5. **Check public exposure** - Any S3 buckets with public access? Any security groups open to `0.0.0.0/0` on ports that shouldn't be? See [S3 Security](s3-security.md).
6. **Verify encryption** - Are customer-managed KMS keys used for sensitive data, with sane key policies? See [KMS](kms.md).
7. **Benchmark it** - Run the CIS AWS Foundations Benchmark (via AWS Config conformance packs, Prowler, or ScoutSuite) to catch what you missed.

## Quick CLI Health Check

A few commands that reveal a lot about an account's security posture fast - the kind of thing worth running before you trust any environment:

```bash
# Is CloudTrail actually logging, and where?
aws cloudtrail describe-trails

# Does the root account have access keys? (it never should)
aws iam get-account-summary | grep AccountAccessKeysPresent

# Is GuardDuty enabled in this region?
aws guardduty list-detectors

# Any S3 buckets missing Block Public Access?
aws s3api list-buckets --query 'Buckets[].Name' --output text | \
  xargs -I{} aws s3api get-public-access-block --bucket {} 2>&1

# Password policy set, or defaults?
aws iam get-account-password-policy
```

## Best Practices Checklist

- [ ] Root account has MFA enabled and no access keys
- [ ] AWS Organizations + Service Control Policies used for multi-account isolation
- [ ] CloudTrail enabled account-wide/org-wide, multi-region, with log file validation
- [ ] GuardDuty enabled in every active region
- [ ] AWS Config enabled with conformance packs (e.g. CIS Benchmark) running
- [ ] S3 Block Public Access enabled at the account level as a baseline
- [ ] Customer-managed KMS keys used for sensitive workloads, with rotation on
- [ ] IAM Access Analyzer running to catch unintended external access
- [ ] Security Hub aggregating findings from GuardDuty, Config, Inspector, Macie

## Practice Next

- [IAM Security](iam-security.md)
- [S3 Security](s3-security.md)
- [CloudTrail](cloudtrail.md)
- [GuardDuty](guardduty.md)
- [KMS](kms.md)

## Credits/References

1. [AWS Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/)
2. [AWS Well-Architected Framework: Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
3. [AWS CIS Foundations Benchmark](https://d1.awsstatic.com/whitepapers/compliance/AWS_CIS_Foundations_Benchmark.pdf)
4. [AWS Security Documentation](https://docs.aws.amazon.com/security/)
