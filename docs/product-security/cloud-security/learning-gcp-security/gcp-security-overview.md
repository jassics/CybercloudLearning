# GCP Security Overview

!!! info "Go deeper"
    This page is the entry point for GCP security on the site - for a hands-on deep dive into IAM, Workload Identity Federation, Cloud Storage, and Cloud KMS, see [GCP IAM & Data Security](gcp-iam-and-data-security.md). If you already know AWS or Azure, use the comparison table below as your map.

## Shared Responsibility Model

Google Cloud splits security responsibility the same way every major provider does, shifting by service model:

| Model | Google secures | You secure |
|-------|------------------|------------|
| **IaaS** (e.g. Compute Engine) | Physical datacenter, host infrastructure, hypervisor | Guest OS patching, network config, identity, data, application |
| **PaaS** (e.g. App Engine, Cloud SQL) | Above + the runtime/platform | Identity, data, application configuration, access control |
| **SaaS** (e.g. Google Workspace) | Above + the application itself | Identity, data, user access, device security |

## Core GCP Security Services

| Service | What it does |
|---------|---------------|
| **Cloud IAM** | Identity and access management - roles, permissions, and policy bindings at the org/folder/project/resource level |
| **Security Command Center** | Cloud security posture management (CSPM) - asset inventory, misconfiguration detection, threat findings (the GCP equivalent of AWS Security Hub / Azure Defender for Cloud) |
| **Cloud KMS** | Managed encryption key storage and management |
| **VPC Service Controls** | Creates a security perimeter around GCP resources to mitigate data exfiltration risk - notably, this has no direct 1:1 equivalent in AWS/Azure and is worth understanding on its own terms |
| **Cloud Audit Logs** | Platform-level audit logging (Admin Activity, Data Access, System Event logs) - the equivalent of AWS CloudTrail |
| **Organization Policy Service** | Enforces org-wide constraints (e.g. "deny public IP addresses on VMs") - the equivalent of AWS SCPs / Azure Policy |

## Mapping From AWS / Azure (If You're Coming From There)

| AWS | Azure | GCP |
|-----|-------|-----|
| IAM | Microsoft Entra ID | Cloud IAM |
| CloudTrail | Azure Activity Log | Cloud Audit Logs |
| GuardDuty / Security Hub | Microsoft Defender for Cloud | Security Command Center |
| KMS | Key Vault | Cloud KMS |
| Security Groups | Network Security Groups | Firewall Rules |
| Organizations / SCPs | Management Groups / Azure Policy | Resource Manager / Organization Policy |

Core IAM concepts (least privilege, roles vs. policies, service accounts vs. users) carry over directly from [AWS IAM](../learning-aws-security/iam-security.md) - GCP's IAM model uses the same principles with different terminology (GCP "roles" bind to "members" via "policy bindings," conceptually similar to AWS policies attached to principals).

## GCP-Specific Concepts Worth Knowing

- **Resource hierarchy** - Organization → Folders → Projects → Resources. IAM policies inherit downward, so a policy set at the Organization level applies to every project beneath it - a common source of both convenience and accidental over-permissioning.
- **Service accounts are identities, not just credentials** - a GCP service account is itself an IAM principal that can be granted roles, impersonated, and have its own service account keys (which, like any long-lived credential, should be avoided in favor of workload identity federation where possible).
- **VPC Service Controls** - designed specifically to prevent data exfiltration from managed services (e.g. someone copying data out of BigQuery to a personal GCP project) even if IAM permissions would otherwise allow it.

## Where to Start Hands-On

1. Review Security Command Center's findings for a project - it surfaces misconfigurations similarly to how AWS Security Hub or Azure Defender for Cloud do.
2. Audit IAM policy bindings at the Organization and Folder level - broad grants set high in the resource hierarchy affect every project beneath them.
3. Check for service accounts with long-lived JSON keys instead of workload identity federation - key sprawl is one of the most common GCP-specific findings in real audits.
4. Review firewall rules for anything allowing `0.0.0.0/0` on management ports.

## Credits/References

1. [Google Cloud Security Documentation](https://cloud.google.com/security)
2. [Google Cloud Security Best Practices](https://cloud.google.com/security/best-practices)
3. [Security Command Center Documentation](https://cloud.google.com/security-command-center/docs)
4. [CIS Google Cloud Platform Foundation Benchmark](https://www.cisecurity.org/benchmark/google_cloud_computing_platform)
