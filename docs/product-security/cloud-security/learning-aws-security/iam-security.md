# IAM Security

## Why IAM Is the First Thing to Get Right

Every AWS security review starts here because IAM is the front door - a well-configured S3 bucket behind an over-permissive IAM policy is still a breach waiting to happen. Most real-world cloud incidents trace back to identity: leaked access keys, overly broad policies, or missing MFA - not exotic infrastructure attacks.

## Users, Groups, and Roles

| Identity Type | Use For | Avoid For |
|----------------|---------|-----------|
| **IAM User** | Break-glass/emergency access, legacy systems that can't assume roles | Day-to-day human access (use federation/SSO instead), application credentials |
| **IAM Group** | Bundling permissions for a set of users (e.g. "Developers") | Anything requiring per-resource scoping |
| **IAM Role** | Cross-account access, EC2/Lambda/ECS execution, federated human access via SSO | - |

**Rule of thumb:** if you're assigning permissions to a human, prefer federated access (IAM Identity Center / SSO) over long-lived IAM users. If you're assigning permissions to a workload (EC2, Lambda, ECS task), always use a role, never embed access keys.

## Policy Evaluation Logic

This trips up almost everyone at some point, and it's a near-guaranteed interview question:

1. By default, everything is **implicitly denied**.
2. An explicit **Allow** in any applicable policy (identity-based, resource-based, permissions boundary, SCP) grants access.
3. An explicit **Deny** anywhere always wins, overriding any Allow.

So the evaluation order that actually matters is: **explicit Deny > explicit Allow > implicit deny**. If a user's policy allows `s3:GetObject` but a Service Control Policy at the OU level explicitly denies it, the SCP wins - a common gotcha when debugging "why can't this role do X" tickets.

## Least Privilege in Practice

Least privilege isn't a slogan - it's a discipline of writing narrow, resource-scoped policies instead of convenient wildcards.

```json
// Overly broad - this is what shows up in almost every AWS security audit
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
```

```json
// Least privilege - scoped to a specific action, bucket, and prefix
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::app-uploads-bucket/uploads/*",
      "Condition": {
        "StringEquals": { "aws:PrincipalTag/team": "checkout-service" }
      }
    }
  ]
}
```

The second version answers the four questions a reviewer will always ask: which actions, on which resource, under which conditions, for whom.

## Cross-Account Access

For multi-account setups (the norm once an org has more than a handful of AWS accounts), grant access via **role assumption**, not shared credentials:

```json
// Trust policy on the role in Account B, allowing Account A to assume it
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111122223333:root" },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": { "sts:ExternalId": "unique-shared-secret" }
      }
    }
  ]
}
```

Always add an `ExternalId` condition for third-party cross-account access (this is exactly what prevents the "confused deputy" problem) and scope the trust policy's `Principal` as narrowly as possible - not `"AWS": "*"`.

## Custom Policy vs. AWS Managed Policy

- **AWS Managed Policies** (e.g. `AmazonS3ReadOnlyAccess`) are convenient and versioned by AWS, but are often broader than a specific role actually needs.
- **Customer Managed Policies** take more effort to write but let you scope exactly to what a role needs - the right default for anything touching production or sensitive data.
- **Inline policies** are tied to a single identity and don't show up in reusable policy libraries - avoid them except for one-off, truly unique permission sets.

## IAM Access Analyzer

Access Analyzer finds resources shared with entities *outside* your account/organization - S3 buckets, IAM roles, KMS keys, Lambda functions, and more - that you didn't intend to expose. Run it continuously, not as a one-time audit:

```bash
aws accessanalyzer list-findings --analyzer-arn <analyzer-arn> \
  --filter '{"status":{"eq":["ACTIVE"]}}'
```

It also has a **policy validation** feature that checks policies you're about to attach against security best practices before you deploy them - use it in CI/CD for infrastructure-as-code pipelines.

## Common IAM Misconfigurations (What Auditors and Interviewers Look For)

1. **Wildcard actions/resources** (`"Action": "*"`, `"Resource": "*"`) on any policy attached to a human or workload identity.
2. **Long-lived access keys** with no rotation, or keys unused for 90+ days that were never deactivated.
3. **No MFA on privileged users** - especially anyone with `iam:*` or admin-equivalent access.
4. **Root account in active use** - the root account should have MFA, no access keys, and be used only for the handful of tasks that require it (e.g. closing the account).
5. **Overly permissive trust policies** on cross-account roles (`"Principal": "*"` or missing `ExternalId`).
6. **Service Control Policies not used** - single-account setups with no guardrails against accidental region use, resource deletion, or IAM changes.

```bash
# Find access keys that haven't been used in 90+ days
aws iam generate-credential-report
aws iam get-credential-report --query 'Content' --output text | base64 -d
```

## Best Practices Checklist

- [ ] Root account: MFA enabled, no access keys, used only for emergencies
- [ ] Humans access AWS via federated SSO, not long-lived IAM users
- [ ] Workloads (EC2/Lambda/ECS) use IAM roles, never embedded access keys
- [ ] Every policy scoped to specific actions/resources - no blanket wildcards
- [ ] MFA required for any privileged/administrative action
- [ ] Cross-account roles use `ExternalId` and narrowly scoped `Principal`
- [ ] IAM Access Analyzer running continuously, findings triaged
- [ ] Access keys rotated regularly; unused keys and users deactivated
- [ ] Service Control Policies enforce org-wide guardrails

## Practice Next

- [AWS Security Overview](aws-security-overview.md)
- [S3 Security](s3-security.md) - the most common place IAM mistakes become breaches
- [Cryptography](../../application-security/cryptography.md) for the key-management side of access control

## Credits/References

1. [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
2. [IAM Policy Evaluation Logic](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html)
3. [IAM Access Analyzer](https://aws.amazon.com/iam/features/analyze-access/)
4. [AWS Security Blog: Cross-Account Access](https://aws.amazon.com/blogs/security/)
