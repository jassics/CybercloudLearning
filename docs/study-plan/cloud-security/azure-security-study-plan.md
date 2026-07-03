# Azure Security Study Plan

This page is updated based on [jassics/security-study-plan/azure-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/azure-security-study-plan.md)

This study plan is designed to help you master Azure Security, from foundational concepts to advanced security engineering and operations. It aligns with Microsoft certifications like AZ-500 and the SC series.

Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

## ToC
1. [Azure Fundamentals](#azure-fundamentals) - 2 weeks
2. [Identity and Access Management](#identity-and-access-management) - 2 weeks
3. [Platform Protection](#platform-protection) - 2 weeks
4. [Security Operations](#security-operations) - 2 weeks
5. [Resources](#resources)

## Azure Fundamentals
**Duration: 2 weeks**

Start here if you are new to Azure.

### Week 1-2: Cloud Basics (AZ-900 level)
1. **Core Concepts:**
   - Regions, Availability Zones, Subscriptions, Resource Groups.
   - IaaS, PaaS, SaaS in the Azure context.
2. **Core Services:**
   - Compute (VMs, App Service, AKS).
   - Networking (VNet, NSG, Load Balancers).
   - Storage (Blob, File, Disk).
3. **Basic Security:**
   - Shared Responsibility Model.
   - Azure Policy & Blueprints basics.
   - Microsoft Defender for Cloud (Free tier).

## Identity and Access Management
**Duration: 2 weeks**

Identity is the new perimeter.

### Week 3-4: Microsoft Entra ID (formerly Azure AD)
1. **Core Identity:**
   - Users, Groups, Service Principals, Managed Identities.
   - Hybrid Identity (Azure AD Connect).
2. **Access Control:**
   - **RBAC:** Built-in roles, custom roles, scope (Management Group > Subscription > Resource Group > Resource).
   - **Conditional Access:** Policies based on location, device state, risk.
3. **Identity Protection:**
   - PIM (Privileged Identity Management).
   - MFA and passwordless auth.
   - Identity Protection (risk detection).

## Platform Protection
**Duration: 2 weeks**

Securing the infrastructure and data.

### Week 5-6: Network & Compute
1. **Network Security:**
   - NSGs vs ASGs.
   - Azure Firewall & Azure Firewall Manager.
   - DDoS Protection (Basic vs Standard).
   - Private Link & Service Endpoints.
2. **Compute & Container Security:**
   - VM security (Bastion, JIT access, Disk Encryption).
   - AKS Security (network policies, private clusters) - see also this site's [Kubernetes Security Study Plan](../cybersecurity/kubernetes-security-study-plan.md).
3. **Data Security:**
   - Key Vault (Secrets, Keys, Certs).
   - Storage Security (SAS tokens, Access Keys, Encryption).
   - SQL Database Security (TDE, Firewall, Auditing).

## Security Operations
**Duration: 2 weeks**

Monitoring and responding to threats.

### Week 7-8: Defender & Sentinel
1. **Microsoft Defender for Cloud:**
   - CSPM (Cloud Security Posture Management) - Secure Score.
   - CWP (Cloud Workload Protection) - alerts for VMs, Storage, SQL, Containers.
2. **Microsoft Sentinel (SIEM/SOAR):**
   - Connecting data sources.
   - KQL (Kusto Query Language) basics for hunting.
   - Creating Analytics Rules and Incidents.
   - Automation with Playbooks (Logic Apps).

## Resources

### Certifications
- **AZ-500:** Azure Security Technologies (core certification)
- **SC-900:** Security, Compliance, and Identity Fundamentals
- **SC-200:** Security Operations Analyst (Sentinel/Defender focus)
- **SC-300:** Identity and Access Administrator (Entra ID focus)

### Learning Paths
- [Microsoft Learn: Azure Security Engineer](https://learn.microsoft.com/en-us/credentials/certifications/azure-security-engineer/)
- [Microsoft Learn: SC-200](https://learn.microsoft.com/en-us/credentials/certifications/security-operations-analyst/)

### Labs & Practice
- [Azure Citadel](https://azurecitadel.com/)
- [Microsoft GitHub Labs](https://github.com/MicrosoftLearning) (search for AZ-500)

**Practice next:** this site's own [Azure Security Overview](../../product-security/cloud-security/learning-azure-security/azure-security-overview.md), and [jassics/security-interview-questions](https://github.com/jassics/security-interview-questions) for interview prep (Azure-specific questions are on the roadmap for that repo).
