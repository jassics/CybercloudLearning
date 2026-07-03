# GCP Security Interview Questions

The [security-interview-questions](https://github.com/jassics/security-interview-questions) repo's GCP Security file is still a stub upstream, so these are grounded directly in this site's [GCP Security Overview](../product-security/cloud-security/learning-gcp-security/gcp-security-overview.md) instead. Expect them to get merged back once the source repo catches up.

## GCP Fundamentals & Shared Responsibility

??? question "Q: How does GCP's shared responsibility model shift across IaaS, PaaS, and SaaS?"
    Google secures progressively more of the stack as you move up the service model:

    - **IaaS** (e.g. Compute Engine) - Google secures the physical datacenter, host infrastructure, and hypervisor; you're responsible for guest OS patching, network config, identity, data, and the application.
    - **PaaS** (e.g. App Engine, Cloud SQL) - Google also manages the runtime/platform; you're left with identity, data, application configuration, and access control.
    - **SaaS** (e.g. Google Workspace) - Google manages the application itself too; you're responsible for identity, data, user access, and device security.

    The pattern is the same as AWS and Azure - the more managed the service, the more of the security burden shifts to the provider, but identity and data are *always* your responsibility regardless of tier.

??? question "Q: You're coming from an AWS background and starting a GCP security role. What maps to what?"
    Core concepts carry over, terminology changes:

    | AWS | GCP |
    |-----|-----|
    | IAM | Cloud IAM |
    | CloudTrail | Cloud Audit Logs |
    | GuardDuty / Security Hub | Security Command Center |
    | KMS | Cloud KMS |
    | Security Groups | Firewall Rules |
    | Organizations / SCPs | Resource Manager / Organization Policy |

    Least privilege, roles-vs-policies, and service-accounts-vs-users all carry over directly from [AWS IAM](../product-security/cloud-security/learning-aws-security/iam-security.md) - GCP just binds "roles" to "members" via "policy bindings" instead of attaching policies to principals. Interviewers care less about you memorizing the table and more about whether you can reason from AWS concepts to the GCP equivalent on the fly.

??? question "Q: Explain GCP's resource hierarchy and why it matters for IAM audits."
    GCP resources nest as **Organization → Folders → Projects → Resources**, and IAM policy bindings *inherit downward* - a policy granted at the Organization level automatically applies to every project and resource beneath it. This is powerful for consistent policy enforcement but is also one of the most common sources of accidental over-permissioning in real audits: a broad grant set high in the hierarchy (e.g. "Editor" at the Org level) silently affects everything below it. A GCP IAM audit should always start at the Organization and Folder level before drilling into individual projects, not the other way around.

## Core Security Services

??? question "Q: What does Security Command Center do, and what's its AWS/Azure equivalent?"
    Security Command Center is GCP's cloud security posture management (CSPM) tool - it provides asset inventory, misconfiguration detection, and threat findings across a GCP environment. It's functionally equivalent to AWS Security Hub (paired with GuardDuty) or Microsoft Defender for Cloud on Azure. In an interview, the useful framing isn't just "it finds misconfigurations" - it's that CSPM tools like this exist because manually auditing configuration drift across hundreds of projects/resources doesn't scale, so continuous automated posture checking is table stakes for any cloud security program.

??? question "Q: What is VPC Service Controls, and why doesn't it have a direct AWS/Azure equivalent?"
    VPC Service Controls creates a security perimeter around GCP resources specifically to mitigate **data exfiltration** - even if a user's IAM permissions would technically allow them to read data from a managed service like BigQuery, VPC Service Controls can block them from copying that data out to an untrusted project or the public internet. It doesn't have a clean 1:1 AWS/Azure equivalent because it operates at the network-perimeter layer around managed services rather than at the IAM-policy layer - it's a defense-in-depth control against exactly the scenario where IAM alone isn't enough (e.g. an insider or compromised credential with legitimate read access).

??? question "Q: A service account has a long-lived JSON key. Why is a security reviewer going to flag this, and what's the fix?"
    A GCP service account is itself an IAM principal, and a long-lived JSON key is a static, exportable credential - if it leaks (committed to a repo, left in a CI log, exfiltrated from a compromised machine), it grants standing access until someone notices and revokes it, with no built-in expiry. It's one of the most common findings in real GCP security audits precisely because it's easy to create and easy to forget about.

    The fix is **workload identity federation** - it lets external workloads (e.g. a CI/CD pipeline, or a workload running on another cloud) impersonate a service account using short-lived, automatically-rotated tokens instead of a static key, eliminating the long-lived-credential risk entirely.

## Practice Next

- [GCP Security Overview](../product-security/cloud-security/learning-gcp-security/gcp-security-overview.md)
- [AWS Security Overview](../product-security/cloud-security/learning-aws-security/aws-security-overview.md) for the comparison baseline
- [AWS Security Interview Questions](aws-security-interview-questions.md) - many concepts transfer directly
- [security-interview-questions](https://github.com/jassics/security-interview-questions) on GitHub for the canonical, evolving question set
