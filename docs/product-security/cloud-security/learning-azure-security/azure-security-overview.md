# Azure Security Overview

!!! info "Go deeper"
    This page is the entry point for Azure security on the site - for a hands-on deep dive into Entra ID, RBAC, Storage, and Key Vault, see [Azure Identity & Data Security](azure-identity-and-data-security.md). If you already know AWS, use the comparison table below as your map.

## Shared Responsibility Model

Like every major cloud provider, Microsoft splits security responsibility between itself and the customer, and the split shifts depending on the service model:

| Model | Microsoft secures | You secure |
|-------|--------------------|------------|
| **IaaS** (e.g. Azure VMs) | Physical datacenter, host infrastructure, hypervisor | Guest OS patching, network config, identity, data, application |
| **PaaS** (e.g. Azure App Service, Azure SQL) | Above + the runtime/platform | Identity, data, application configuration, access control |
| **SaaS** (e.g. Microsoft 365) | Above + the application itself | Identity, data, user access, device security |

The single most common cloud security failure - across every provider - is treating something the provider secures as if it covers something the customer is actually responsible for.

## Core Azure Security Services

| Service | What it does |
|---------|---------------|
| **Microsoft Entra ID** (formerly Azure AD) | Identity and access management - the equivalent of AWS IAM, but also the backbone of conditional access and SSO across Microsoft's ecosystem |
| **Microsoft Defender for Cloud** | Cloud security posture management (CSPM) and workload protection - continuously assesses configuration against benchmarks and flags active threats |
| **Azure Key Vault** | Managed secrets, keys, and certificate storage - the equivalent of AWS Secrets Manager + KMS combined |
| **Microsoft Sentinel** | Cloud-native SIEM/SOAR - log aggregation, threat detection, and automated response |
| **Network Security Groups (NSGs)** | Stateful firewall rules at the subnet/NIC level - the equivalent of AWS security groups |
| **Azure Policy** | Enforces organizational standards at scale (e.g. "deny any storage account without encryption") - the equivalent of AWS Config rules / Service Control Policies |
| **Azure Monitor / Activity Log** | Platform-level audit logging - the equivalent of AWS CloudTrail |

## Mapping From AWS (If You're Coming From There)

| AWS | Azure |
|-----|-------|
| IAM | Microsoft Entra ID |
| CloudTrail | Azure Activity Log / Monitor |
| GuardDuty | Microsoft Defender for Cloud |
| KMS | Azure Key Vault |
| Security Groups | Network Security Groups (NSGs) |
| Organizations / SCPs | Management Groups / Azure Policy |
| Config | Azure Policy + Resource Graph |

The concepts transfer almost directly - if you understand [AWS Security](../learning-aws-security/aws-security-overview.md), you're mostly learning new names and new console/CLI ergonomics, not new fundamentals.

## Where to Start Hands-On

1. Enable Microsoft Defender for Cloud on a subscription and review its Secure Score recommendations - it's the fastest way to see what "good" looks like for your specific resources.
2. Review Entra ID conditional access policies - are privileged roles protected by MFA and device compliance requirements?
3. Check Key Vault access policies - is access scoped per-application/per-identity, or is everything using one shared vault with broad access?
4. Look at NSG rules for anything exposed to the internet - is management access (RDP/SSH) restricted to known IP ranges or a bastion, not `0.0.0.0/0`?

## Credits/References

1. [Microsoft Azure Security Documentation](https://learn.microsoft.com/en-us/azure/security/)
2. [Azure Well-Architected Framework: Security Pillar](https://learn.microsoft.com/en-us/azure/well-architected/security/)
3. [Microsoft Defender for Cloud Documentation](https://learn.microsoft.com/en-us/azure/defender-for-cloud/)
4. [CIS Microsoft Azure Foundations Benchmark](https://www.cisecurity.org/benchmark/azure)
