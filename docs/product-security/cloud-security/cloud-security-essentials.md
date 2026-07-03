# Cloud Security Essentials

## What is Cloud Security?

Cloud security is the set of practices, controls, and shared processes that protect data, applications, and infrastructure running on a cloud provider (AWS, Azure, GCP, or others). It overlaps heavily with traditional infrastructure/application security, but the operating model is different: you rarely touch physical hardware, most controls are configuration rather than code, and a single misconfigured setting (a public bucket, an overly broad IAM policy) can expose data at internet scale in seconds.

## Why Cloud Security Now

- **Cloud is the default**, not the exception - most new workloads start in the cloud, so cloud security skills are now baseline requirements for almost any security role, not a specialization.
- **Misconfiguration, not novel exploits, drives most breaches** - see [OWASP Top 10 Cloud](owasp-top10-cloud.md) for the recurring failure patterns.
- **The attack surface moved** - instead of a perimeter firewall, your attack surface is now IAM policies, API endpoints, storage bucket policies, and CI/CD pipelines with cloud credentials.
- **Speed cuts both ways** - infrastructure-as-code and self-service provisioning let teams move fast, but also let a single bad `terraform apply` or console click propagate a misconfiguration instantly across an environment.

## The Shared Responsibility Model

Every major cloud provider splits security responsibility between itself and the customer. The provider secures the underlying platform; you secure how you configure and use it. Getting this boundary wrong - assuming the provider handles something it doesn't - is the single most common root cause behind public cloud breach disclosures.

Where that line falls shifts depending on the service model:

| Service Model | Example | Provider Handles | You Handle |
|----------------|---------|-------------------|-------------|
| **IaaS** (Infrastructure as a Service) | AWS EC2, Azure VMs, GCP Compute Engine | Physical hardware, hypervisor, network infrastructure | Guest OS patching, network config (security groups/NSGs), identity, data, application code |
| **PaaS** (Platform as a Service) | AWS RDS/Lambda, Azure App Service, GCP Cloud Run | Everything in IaaS, plus the OS and runtime | Application code, data, access control, configuration of the managed service |
| **SaaS** (Software as a Service) | Microsoft 365, Salesforce, Google Workspace | Everything up to and including the application itself | Data you put into it, user access management, configuration settings (sharing, retention, DLP) |

The pattern: the more "as a Service" you consume, the more the provider absorbs - but your responsibility for **identity, data, and configuration** never goes away, at any layer. See each provider's own overview for the fully worked-out version of this table: [AWS](learning-aws-security/aws-security-overview.md), [Azure](learning-azure-security/azure-security-overview.md), [GCP](learning-gcp-security/gcp-security-overview.md).

## What is IAM (in a Cloud Context)?

Identity and Access Management is the system of users, groups, roles, and policies that decides who (or what service/workload) can do what to which resource. In the cloud, IAM is arguably the single highest-leverage control:

- It's usually the first thing an attacker targets after gaining any foothold (leaked key, compromised CI/CD credential, SSRF into a metadata endpoint).
- Overly broad IAM policies (`"Action": "*"`, `"Resource": "*"`) are one of the most common cloud misconfigurations found in breach postmortems.
- The core discipline is **least privilege**: grant only the specific actions on the specific resources a principal actually needs, and prefer temporary/role-based credentials over long-lived access keys.

See [IAM Security](learning-aws-security/iam-security.md) for a hands-on deep dive (AWS-specific, but the principles - least privilege, policy evaluation logic, avoiding wildcards - transfer directly to Azure RBAC and GCP Cloud IAM).

## What is Data Security (in a Cloud Context)?

Protecting data across its lifecycle in a cloud environment - at rest, in transit, and in use:

- **At rest**: encrypt storage (S3/Blob Storage/Cloud Storage, databases, disks) using provider-managed or customer-managed keys, and know which one your compliance requirements demand.
- **In transit**: enforce TLS for all data moving between services, users, and the cloud - never allow unencrypted fallback.
- **Access control**: data security fails most often not because encryption was missing, but because access controls around the encrypted data were too permissive (a public bucket is still readable even if "encryption at rest" is checked).
- **Classification and lifecycle**: know what data you have, how sensitive it is, and how long you're required (or allowed) to keep it - this drives retention policies and deletion/erasure processes (see [GDPR](../../grc/gdpr.md)).

## Building a Cloud Security Foundation

A practical starting checklist, regardless of provider:

- [ ] Root/organization-level account has MFA enforced and is never used for daily work
- [ ] IAM follows least privilege - no wildcard actions/resources on production principals
- [ ] All storage services default to private, with public access requiring an explicit, documented exception
- [ ] Centralized, immutable audit logging is enabled account/organization-wide (CloudTrail, Azure Activity Log, GCP Audit Logs)
- [ ] Encryption at rest and in transit is the default, not an opt-in
- [ ] A cloud security posture management (CSPM) tool or provider-native equivalent (Security Hub, Defender for Cloud, Security Command Center) is actively monitored, not just enabled

## Credits/References

1. [AWS Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/)
2. [Microsoft Shared Responsibility in the Cloud](https://learn.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility)
3. [Google Cloud Shared Responsibility Model](https://cloud.google.com/architecture/framework/security/shared-responsibility-shared-fate)
4. [NIST SP 800-145: The NIST Definition of Cloud Computing](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-145.pdf)
