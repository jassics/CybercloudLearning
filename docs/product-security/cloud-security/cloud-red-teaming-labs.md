# Cloud Red Teaming & Practice Labs

Cloud penetration testing is less about scanning open ports and more about tracing identity: what can this role assume, what can that assumed role read, and does any of it lead somewhere it shouldn't. This page covers methodology, real tools, and where to practice safely.

## Before You Start: Know the Rules of Engagement

AWS, Azure, and GCP each publish a penetration testing policy - read it before testing anything beyond a personal sandbox account:

- [AWS Penetration Testing](https://aws.amazon.com/security/penetration-testing/) - most services can be tested against your own resources without prior authorization; a small list (DoS-style testing, DNS zone walking) still requires a request.
- [Microsoft Cloud Unified Penetration Testing Rules of Engagement](https://www.microsoft.com/en-us/msrc/pentest-rules-of-engagement) - covers Azure, Microsoft 365, and Dynamics 365.
- [Google Cloud Platform Terms of Service](https://cloud.google.com/terms) plus [Google's Vulnerability Reward Program scope](https://bughunters.google.com/about/rules/6625378258649088) for what's in-bounds.

Testing your **own** account's resources for misconfigurations is generally fine everywhere; testing anything that could affect other tenants or the provider's shared infrastructure is not, regardless of provider.

## A Cloud Security Assessment Methodology

1. **Enumerate identity** - what IAM users/roles/service principals/service accounts do you have credentials for, and what can each one actually do? (`aws iam get-account-authorization-details`, `az role assignment list`, `gcloud projects get-iam-policy`)
2. **Check for public exposure** - storage buckets, snapshots, and any resource with a public-facing endpoint (cross-link: [S3 Security](learning-aws-security/s3-security.md), [Azure Identity & Data Security](learning-azure-security/azure-identity-and-data-security.md), [GCP IAM & Data Security](learning-gcp-security/gcp-iam-and-data-security.md)).
3. **Check network exposure** - security groups/NSGs/firewall rules open to `0.0.0.0/0` on ports that shouldn't be.
4. **Look for hardcoded or overly long-lived credentials** - access keys in code/CI variables, service account JSON keys checked into repos, instance metadata services reachable from an application with an SSRF flaw.
5. **Trace privilege escalation paths** - can a low-privilege identity reach a high-privilege one through role assumption, policy attachment permissions, or resource-based policies?
6. **Check logging/monitoring coverage** - is anything you just did actually being logged and alerted on? (cross-link: [CloudTrail](learning-aws-security/cloudtrail.md), [GuardDuty](learning-aws-security/guardduty.md))

## CSPM / Auditing Tools (Defensive, But Great for Finding Your Own Gaps)

| Tool | Coverage |
|------|----------|
| [Prowler](https://github.com/prowler-cloud/prowler) | AWS, Azure, GCP, Kubernetes - 400+ checks, the most widely used open-source CSPM |
| [ScoutSuite](https://github.com/nccgroup/ScoutSuite) (NCC Group) | Multi-cloud security auditing, strong report visualization |
| [Cloudsplaining](https://github.com/salesforce/cloudsplaining) | AWS IAM least-privilege assessment - flags overly permissive policies specifically |

## Offensive Tools by Provider

**AWS**

- [Pacu](https://github.com/RhinoSecurityLabs/pacu) - the standard offensive AWS exploitation framework, modular attack/enumeration modules
- [CloudMapper](https://github.com/duo-labs/cloudmapper) - visualizes an AWS account's network and resource layout
- [PMapper](https://github.com/nccgroup/PMapper) - graphs IAM privilege escalation paths
- [S3Scanner](https://github.com/sa7mon/S3Scanner) - finds open/misconfigured S3 buckets

**Azure**

- [ROADtools](https://github.com/dirkjanm/ROADtools) - Entra ID (Azure AD) enumeration
- [AzureHound](https://github.com/BloodHoundAD/AzureHound) - maps Azure AD attack paths into BloodHound
- [MicroBurst](https://github.com/NetSPI/MicroBurst) - PowerShell toolkit for Azure-specific attacks

**GCP**

- [GCPBucketBrute](https://github.com/RhinoSecurityLabs/GCPBucketBrute) - enumerates GCS bucket permissions
- [gcp_scanner](https://github.com/google/gcp_scanner) - Google's own GCP privilege/resource scanner

## Practice Labs (Safe, Legal, Deliberately Vulnerable)

**AWS**

- [flaws.cloud](https://flaws.cloud/) and [flaws2.cloud](https://flaws2.cloud/) by Scott Piper - the classic AWS CTFs, attacker and defender tracks
- [CloudGoat](https://github.com/RhinoSecurityLabs/cloudgoat) - Terraform-deployable, vulnerable-by-design AWS scenarios
- [IAM Vulnerable](https://github.com/BishopFox/iam-vulnerable) (Bishop Fox) - focused specifically on IAM privilege escalation paths

**Azure**

- [AzureGoat](https://github.com/ine-labs/AzureGoat) (INE Labs) - vulnerable Azure environment
- [XMGoat](https://github.com/XMCyber/XMGoat) - Azure misconfiguration CTF
- [BadZure](https://github.com/mvelazc0/BadZure) - spins up a deliberately misconfigured Entra ID tenant

**GCP**

- [GCPGoat](https://github.com/ine-labs/GCPGoat) (INE Labs)
- [ThunderCTF](https://thunder-ctf.cloud/) - GCP-focused CTF

**Multi-cloud**

- [HackTricks Cloud](https://cloud.hacktricks.xyz/) - AWS/Azure/GCP/Kubernetes attack cheatsheet, the closest thing to a living reference
- [TryHackMe Cloud Security path](https://tryhackme.com/path/outline/cloud)

## Certification Path

[AWS Certified Security - Specialty](https://aws.amazon.com/certification/certified-security-specialty/), [Microsoft AZ-500](https://learn.microsoft.com/en-us/certifications/azure-security-engineer/), and [Google Professional Cloud Security Engineer](https://cloud.google.com/learn/certification/cloud-security-engineer) are the provider-specific tracks. [CCSK](https://cloudsecurityalliance.org/education/ccsk/) and [CCSP](https://www.isc2.org/certifications/ccsp) are the vendor-neutral options if you want cloud-security credibility that isn't tied to one provider.

## Credits/References

1. [Prowler](https://github.com/prowler-cloud/prowler), [ScoutSuite](https://github.com/nccgroup/ScoutSuite), [Pacu](https://github.com/RhinoSecurityLabs/pacu)
2. [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks) for AWS, Azure, and GCP
3. [AWS Penetration Testing Policy](https://aws.amazon.com/security/penetration-testing/)
4. [jassics/awesome-cloud-security-learning-resources](https://github.com/jassics/awesome-cybersecurity-learning-resources/blob/main/awesome-cloud-security-learning-resources.md) - full, continuously updated list this page draws from
