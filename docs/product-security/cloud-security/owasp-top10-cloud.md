# OWASP Top 10 Cloud

!!! note "About this list"
    Unlike the [OWASP Top 10 (Web)](../web-security/owasp-top10.md) or the [OWASP API Security Top 10](../application-security/api-security.md), there isn't a single, actively-maintained "OWASP Cloud Top 10" document in the way most people expect. What's presented below synthesizes the risk categories OWASP's cloud-focused projects (OWASP Cloud-Native Application Security Top 10, OWASP Serverless Top 10) and mainstream cloud security guidance (CSA, CIS benchmarks, AWS/Azure/GCP security whitepapers) consistently converge on. Treat it as a practical risk taxonomy, not a citation of one canonical document.

## The Top 10 Cloud Security Risks

| # | Risk | Real-World Example | Mitigation |
|---|------|---------------------|------------|
| 1 | **Insecure Identity & Access Management** | Overly permissive IAM roles with `*:*` permissions, unused access keys never rotated | Least-privilege policies, regular access reviews, short-lived credentials (see [IAM Security](learning-aws-security/iam-security.md)) |
| 2 | **Misconfigured Cloud Storage** | Publicly readable S3 bucket exposing customer PII (a recurring root cause across dozens of breach disclosures) | Block Public Access by default, bucket policy reviews, automated misconfiguration scanning (see [S3 Security](learning-aws-security/s3-security.md)) |
| 3 | **Insufficient Logging & Monitoring** | An attacker persists in an environment for months because no one is watching CloudTrail/Activity Logs | Centralized logging, alerting on privileged actions, retained audit trails (see [CloudTrail](learning-aws-security/cloudtrail.md)) |
| 4 | **Insecure APIs and Interfaces** | A cloud-hosted API with broken object-level authorization exposes other tenants' data | Apply the [API Security](../application-security/api-security.md) controls consistently to cloud-native APIs |
| 5 | **Misconfigured Network Access** | Security group allowing SSH (22) or RDP (3389) from `0.0.0.0/0` | Least-access security groups/NSGs, network segmentation, private subnets for anything not internet-facing |
| 6 | **Lack of Encryption / Weak Key Management** | Unencrypted EBS volumes or RDS instances; encryption keys with overly broad decrypt permissions | Encrypt at rest and in transit by default, scope KMS key policies tightly (see [KMS](learning-aws-security/kms.md) and [Cryptography](../application-security/cryptography.md)) |
| 7 | **Inadequate Identity Federation & SSO Controls** | Long-lived static credentials used instead of federated, short-lived tokens; no MFA on privileged accounts | Enforce SSO/federation for human access, MFA everywhere, eliminate long-lived static credentials where possible |
| 8 | **Insecure Secrets Management** | API keys and database passwords committed to a repo or baked into a container image | Centralized secrets manager (Vault, AWS Secrets Manager), automated secret scanning in CI |
| 9 | **Lack of Multi-Account/Tenant Isolation** | A single flat AWS account holding dev, staging, and prod - a dev mistake takes down production | Account-per-environment (or landing zone) strategy, strict cross-account role boundaries |
| 10 | **Supply Chain & IaC Risks** | A Terraform module or public IaC template silently provisions an overly permissive resource | Policy-as-code scanning of IaC (Checkov, tfsec) before apply, pin module versions, review third-party modules |

## Why Misconfiguration Dominates This List

Unlike traditional on-prem breaches that often start with a network-level exploit, the overwhelming majority of publicly disclosed cloud breaches trace back to **misconfiguration**, not a novel attack technique: a bucket left public, a security group left open, an IAM policy left too broad. This is a direct consequence of the cloud shared responsibility model - the provider secures the underlying infrastructure, but *you* are responsible for how you configure the services you consume. See the [Cloud Security Essentials](cloud-security-essentials.md) page for how responsibility splits by service model (IaaS/PaaS/SaaS).

## How to Use This List in Practice

1. **Map each risk to your actual environment** - not every organization runs serverless or multi-tenant workloads; prioritize the risks that apply to your architecture.
2. **Automate detection, don't rely on manual review** - tools like AWS Config, Security Hub, Prowler, ScoutSuite, and Checkov continuously check for exactly these misconfiguration classes.
3. **Pair this list with cloud-specific benchmarks** - the CIS Benchmarks for AWS/Azure/GCP translate these risk categories into specific, checkable configuration settings.
4. **Treat IaC as the enforcement point** - if your infrastructure is defined in Terraform/CloudFormation/Pulumi, scanning that code before `apply` catches most of these risks before they ever reach a running environment.

## Credits/References

1. [OWASP Cloud-Native Application Security Top 10](https://owasp.org/www-project-cloud-native-application-security-top-10/)
2. [OWASP Serverless Top 10](https://owasp.org/www-project-serverless-top-10/)
3. [Cloud Security Alliance (CSA) Top Threats](https://cloudsecurityalliance.org/research/topics/top-threats/)
4. [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
5. [AWS Well-Architected Framework: Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
