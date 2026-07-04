# Cloud Security Resources

!!! tip "This page distills the highlights"
    For the full, continuously updated list, see [jassics/awesome-cloud-security-learning-resources](https://github.com/jassics/awesome-cybersecurity-learning-resources/blob/main/awesome-cloud-security-learning-resources.md) on GitHub. Also see the companion [Awesome AWS Security](https://github.com/jassics/awesome-aws-security) repo.

Use this page as the "go deeper" reference for the whole Cloud Security section - organized so you can jump straight to standards, papers, tools, or hands-on practice depending on what you need.

## Standards & Frameworks

| Framework | What It Covers |
|-----------|-----------------|
| [CSA Cloud Controls Matrix (CCM) v4](https://cloudsecurityalliance.org/research/cloud-controls-matrix/) | The de-facto control framework spanning all major cloud providers |
| [NIST SP 800-210](https://csrc.nist.gov/publications/detail/sp/800-210/final) | General access control guidance for cloud systems |
| [MITRE ATT&CK for Cloud](https://attack.mitre.org/matrices/enterprise/cloud/) | Real-world adversary tactics/techniques specific to cloud environments |
| [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks) | Configuration baselines for AWS, Azure, GCP, and Kubernetes |
| [Azure Security Benchmark](https://learn.microsoft.com/en-us/security/benchmark/azure/) | Microsoft's baseline security recommendations for Azure workloads |
| [Google Cloud Security Foundations Blueprint](https://cloud.google.com/architecture/security-foundations) | Google's reference architecture for a secure GCP organization |
| [AWS Well-Architected Framework: Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html) | AWS's own security design guidance |

## Books

| Book | Author |
|------|--------|
| [AWS Security](https://www.manning.com/books/aws-security) | Dylan Shields - hands-on, covers IAM/VPC/KMS/GuardDuty/Security Hub |
| [Practical Cloud Security](https://www.oreilly.com/library/view/practical-cloud-security/9781492037507/) | Chris Dotson - cloud-agnostic, very accessible (2nd ed. 2023) |
| [Microsoft Azure Security Infrastructure](https://www.microsoftpressstore.com/store/microsoft-azure-security-infrastructure-9781509304158) | Yuri Diogenes |
| [Cloud Security Handbook](https://www.packtpub.com/product/cloud-security-handbook/9781800569188) | Eyal Estrin - multi-cloud, defender-oriented |

## Videos & Conferences

- [fwd:cloudsec](https://www.youtube.com/@fwdcloudsec) - arguably the best practitioner-led cloud security conference
- [AWS re:Inforce](https://www.youtube.com/@AWSEventsChannel/search?query=reInforce) - AWS's annual security conference
- [Cloud Security Podcast by Ashish Rajan](https://www.youtube.com/@CloudSecurityPodcast)
- [John Savill's Technical Training - Azure Security](https://www.youtube.com/@NTFAQGuy)

## Courses & Certifications

**AWS** - [AWS Skill Builder Security Learning Plan](https://explore.skillbuilder.aws/learn/public/learning_plan/view/83/security-learning-plan) (free), [SANS SEC488/SEC510/SEC540](https://www.sans.org/cyber-security-courses/?focus-area=cloud-security)

**Azure** - [Microsoft Learn AZ-500 path](https://learn.microsoft.com/en-us/training/courses/az-500t00) (free), [SC-100 Cybersecurity Architect](https://learn.microsoft.com/en-us/training/courses/sc-100t00)

**GCP** - [Google Cloud Skills Boost - Security Engineer path](https://www.cloudskillsboost.google/paths/12)

**Vendor-neutral** - [CCSK](https://cloudsecurityalliance.org/education/ccsk/), [CCSP](https://www.isc2.org/certifications/ccsp), [Practical DevSecOps CCSE](https://www.practical-devsecops.com/certified-cloud-security-engineer/)

**Certifications** - [AWS Security-Specialty](https://aws.amazon.com/certification/certified-security-specialty/), [Azure AZ-500](https://learn.microsoft.com/en-us/certifications/azure-security-engineer/), [Google Professional Cloud Security Engineer](https://cloud.google.com/learn/certification/cloud-security-engineer), [CCAK](https://cloudsecurityalliance.org/education/ccak/)

## Tools

### Multi-Cloud CSPM / CNAPP (Open Source)

| Tool | Purpose |
|------|---------|
| [Prowler](https://github.com/prowler-cloud/prowler) | AWS/Azure/GCP/Kubernetes CSPM, 400+ checks |
| [ScoutSuite](https://github.com/nccgroup/ScoutSuite) | Multi-cloud security auditing |
| [Cloudsplaining](https://github.com/salesforce/cloudsplaining) | AWS IAM least-privilege assessment |
| [Steampipe](https://steampipe.io/) | Query cloud configuration with SQL |
| [Cartography](https://github.com/cartography-cncf/cartography) (Lyft, now CNCF sandbox) | Graph-based infrastructure asset inventory |

### AWS-Specific

[Pacu](https://github.com/RhinoSecurityLabs/pacu), [aws-nuke](https://github.com/rebuy-de/aws-nuke), [Parliament](https://github.com/duo-labs/parliament) (IAM policy linter), [Policy Sentry](https://github.com/salesforce/policy_sentry) (least-privilege policy generator), [CloudMapper](https://github.com/duo-labs/cloudmapper), [PMapper](https://github.com/nccgroup/PMapper), [S3Scanner](https://github.com/sa7mon/S3Scanner)

### Azure-Specific

[ROADtools](https://github.com/dirkjanm/ROADtools), [AzureHound](https://github.com/BloodHoundAD/AzureHound), [MicroBurst](https://github.com/NetSPI/MicroBurst), [Stormspotter](https://github.com/Azure/Stormspotter) (archived, still useful)

### GCP-Specific

[GCPBucketBrute](https://github.com/RhinoSecurityLabs/GCPBucketBrute), [gcp_scanner](https://github.com/google/gcp_scanner)

### Commercial CNAPP Landscape

Wiz (acquired by Google, $32B, 2025), Orca Security, Cortex Cloud by Palo Alto Networks (formerly Prisma Cloud, rebranded Feb 2025), CrowdStrike Falcon Cloud Security, Lacework (Fortinet), Microsoft Defender for Cloud, AWS Security Hub + GuardDuty + Inspector, Sysdig Secure, Aqua Security, Snyk Cloud, Tenable Cloud Security.

## Hands-On Labs & CTFs

See [Cloud Red Teaming & Practice Labs](cloud-red-teaming-labs.md) for the full list organized by provider (flaws.cloud, CloudGoat, AzureGoat, GCPGoat, HackTricks Cloud, and more) plus assessment methodology.

## Blogs & Research

- [AWS Security Blog](https://aws.amazon.com/blogs/security/), [Microsoft Security Blog](https://www.microsoft.com/en-us/security/blog/), [Google Cloud Security Blog](https://cloud.google.com/blog/products/identity-security)
- [Summit Route by Scott Piper](https://summitroute.com/blog/) - deep AWS security research
- [Rhino Security Labs blog](https://rhinosecuritylabs.com/blog/)
- [Wiz Research](https://www.wiz.io/blog/tag/research), [Orca Security Research](https://orca.security/resources/blog/)
- [Hacking the Cloud](https://hackingthe.cloud/) - community wiki, one of the best living references for cloud attack techniques
- [Chris Farris - AWS threat research](https://www.chrisfarris.com/)

## Where to Go Next on This Site

- [Cloud Security Essentials](cloud-security-essentials.md) and [OWASP Top 10 Cloud](owasp-top10-cloud.md) for foundations
- [AWS Security Overview](learning-aws-security/aws-security-overview.md), [Azure Security Overview](learning-azure-security/azure-security-overview.md), [GCP Security Overview](learning-gcp-security/gcp-security-overview.md) for provider-specific depth
- [Multi-Cloud Security Architecture](multi-cloud-security-architecture.md) for the architecture/CSPM view
- [Cloud Security Incidents](cloud-security-incidents.md) to learn from real breaches
- [Cloud Red Teaming & Practice Labs](cloud-red-teaming-labs.md) to practice

## Credits/References

1. [jassics/awesome-cloud-security-learning-resources](https://github.com/jassics/awesome-cybersecurity-learning-resources/blob/main/awesome-cloud-security-learning-resources.md) - the full, continuously updated source this page distills
2. [jassics/awesome-aws-security](https://github.com/jassics/awesome-aws-security) - companion AWS-specific repo
3. [Hacking the Cloud](https://hackingthe.cloud/)
