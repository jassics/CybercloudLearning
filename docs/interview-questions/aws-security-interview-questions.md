# AWS Security Interview Questions

Questions sourced and expanded from [jassics/security-interview-questions](https://github.com/jassics/security-interview-questions/blob/main/aws-security-interview-questions.md).

These are geared toward Cloud/AWS Security Engineer roles. Several are open-ended on purpose - the interviewer is checking whether you've actually operated the relevant AWS service, not whether you can recite a definition.

!!! tip "Before you start"
    Work through the [AWS Security Study Plan](../study-plan/cloud-security/aws-security-study-plan.md) first if AWS security is new to you.

## Core AWS Security

??? question "Q: How would you find evidence of malicious activity in services like EBS or Lambda?"
    This checks whether you've actually used GuardDuty, CloudTrail, and Config to investigate an incident - not just that you know the service names. Be ready to describe a real (or realistic) investigation: which data source flagged the anomaly, how you traced it, and what remediation followed.

??? question "Q: CloudTrail vs. CloudWatch - explain the difference from a security perspective."
    CloudTrail records **who did what, when** (API/management-plane audit trail) - it's your primary tool for incident/event analysis. CloudWatch is about **operational metrics and logs** (performance, custom application logs, alarms). A security engineer should be fluent in CloudTrail event analysis and aware of what CloudWatch adds on top.

??? question "Q: How is IMDSv1 vulnerable to SSRF, and how does IMDSv2 fix it?"
    IMDSv1 lets any process on the instance (or an attacker exploiting an SSRF bug in your app) fetch instance credentials over HTTP with a simple GET request - no extra proof of intent required. This is how the Capital One breach happened. IMDSv2 requires a session token obtained via a PUT request first, which SSRF payloads typically can't replicate, closing that path. Enforce IMDSv2-only at the instance/launch-template level.

??? question "Q: How are logs stored in AWS, and how do you monitor them?"
    CloudTrail logs to S3 (optionally aggregated across accounts via Organizations), CloudWatch Logs for application/service logs, and both can feed GuardDuty, Security Hub, or a SIEM for centralized monitoring and alerting.

??? question "Q: A security group named 'default' has ports 22, 25, 53, 80, 443, 3679, 3306, 9001 open. Any issues?"
    Yes - this is a broad, poorly-scoped rule set on the default security group (which shouldn't be actively used at all). Flag: SSH (22) and database (3306) exposed without justification, unusual/uncommon ports (3679, 9001) with no documented purpose, and no indication of source IP restriction. Recommend explicit, purpose-built security groups per tier, with source CIDR/security-group references instead of `0.0.0.0/0`.

??? question "Q: What issue do you see when any API endpoint is exposed to the public?"
    Think about: authentication/authorization on the endpoint, rate limiting (see [API Security](../product-security/application-security/api-security.md#unrestricted-resource-consumption)), input validation, and whether it should be public at all vs. behind a VPN/PrivateLink.

Other questions to prepare for: should a database ever be exposed directly to a web application or the public internet; assessing security posture for a WordPress site hosted on AWS; experience with AWS security design/enforcement documentation; when to use Transit Gateway and its security implications; backup security and monitoring experience; RTO vs. RPO.

## IAM

??? question "Q: Explain this IAM policy."
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [{
            "Sid": "DenyAllUsersNotUsingMFA",
            "Effect": "Deny",
            "NotAction": "iam:*",
            "Resource": "*",
            "Condition": {"BoolIfExists":
                            {"aws:MultiFactorAuthPresent": "false"}
                        }
        }]
    }
    ```
    This denies **every action except IAM actions** unless the caller authenticated with MFA. `NotAction: iam:*` lets users still manage their own IAM credentials (e.g., set up MFA) even before MFA is present, while blocking everything else. `BoolIfExists` handles the case where the condition key isn't present at all (e.g., long-term access keys with no MFA context).

??? question "Q: What's wrong with this policy?"
    ```json
    {
        "Version": "2012-10-17",
        "Statement": {
        "Effect": "Deny",
        "Action": "s3:*",
        "NotResource": [
          "arn:aws:s3:::HRBucket/Payroll",
          "arn:aws:s3:::HRBucket/Payroll/*"
        ]
        }
    }
    ```
    This denies all S3 actions on every resource **except** the Payroll path - meaning it explicitly *allows* (by not denying) full S3 access to the Payroll folder itself, which is almost certainly the opposite of intent. `NotResource` combined with `Deny` is a common footgun; the author likely meant to restrict access **to** Payroll, not exempt it from a restriction.

??? question "Q: What comes to mind when a service needs cross-account access?"
    Least-privilege cross-account IAM roles (not shared long-term credentials), an external ID to prevent the confused-deputy problem, and scoping the trust policy to the specific source account/role rather than `"*"`.

## Data Security & Data Protection

- How do you secure data in transit? (TLS everywhere, no fallback to plaintext)
- Do you agree encryption at rest should be enabled by default? Why or why not?

??? question "Q: KMS-encrypted S3 objects can be downloaded but not opened. What's the likely cause and fix?"
    The caller has S3 `GetObject` permission but not `kms:Decrypt` permission on the CMK used to encrypt the object. Fix by granting the caller's role `kms:Decrypt` (and `kms:GenerateDataKey` if they also write) in the key policy or an IAM policy, scoped to that specific key.

??? question "Q: How would you automate CMK rotation (e.g., every 3 months) and detect it?"
    AWS-managed keys rotate automatically yearly; for customer-managed keys needing a custom cadence, use a CloudWatch Event/EventBridge rule on a schedule to trigger rotation via Lambda, and monitor via CloudTrail/Config for `RotateKey` events or key age drift.

Other prompts: what to secure when standing up an RDS instance; when is "encryption by default" not enough (e.g., application-layer encryption for specific sensitive fields); would you recommend key rotation, and what period, and why.

## Logging, Monitoring & Infrastructure

- Ensuring data integrity for CloudTrail logs (log file validation, restricted bucket write access)
- Finding unencrypted EBS volumes at scale (AWS Config rules + custom queries)
- Building CloudWatch metric filters for specific event patterns
- Automating EC2 patch management (Systems Manager Patch Manager)
- What checks does AWS Inspector run to find instance vulnerabilities?

??? question "Q: You've used GuardDuty, but it has a lot of false positives. Any suggestions?"
    Tune finding-type suppression rules for known-benign patterns (e.g., expected VPN egress IPs), use trusted IP/threat lists to reduce noise, and route findings through Security Hub for correlation before alerting - don't page on every raw GuardDuty finding.

## Scenario & Design Questions

??? question "Q: I need an alert to Slack/email whenever backend APIs return 5xx errors in CloudWatch. How would you build that?"
    CloudWatch Logs metric filter matching the 5xx pattern → CloudWatch Alarm on that metric → SNS topic → Lambda (or a native Slack/chatbot integration) to post to Slack, and an email subscription on the same SNS topic.

??? question "Q: Design a Lambda function that checks non-compliant Config rules across an AWS Organizations aggregator and emails results via SES."
    Use the org-level Config aggregator to query non-compliant resources per rule, group results by rule/account/resource, format into a report, and send via SES to the configured recipient list. Key design points: pagination handling for large result sets, least-privilege execution role for the Lambda, and scheduling via EventBridge.

Other design prompts: top 3 priorities if building a CSPM tool from scratch; verifying AWS resources use encrypted channels; enforcing org-wide AWS security guidelines at scale; enabling SSO/integrating a third-party tool securely into a shared AWS environment.

## Practice Next

- [AWS Security Study Plan](../study-plan/cloud-security/aws-security-study-plan.md)
- [Cloud Security Essentials](../product-security/cloud-security/cloud-security-essentials.md)
- Full question set on GitHub: [security-interview-questions](https://github.com/jassics/security-interview-questions/blob/main/aws-security-interview-questions.md)
