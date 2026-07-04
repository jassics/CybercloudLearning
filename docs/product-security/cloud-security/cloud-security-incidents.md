# Cloud Security Incidents

A curated, sourced timeline of real cloud security incidents - concrete pattern-matching material for interviews and for recognizing the same root causes when they show up again in a different environment.

!!! note "Capital One (2019) is covered elsewhere"
    The single most important cloud security incident to know - Capital One's SSRF-to-cloud-metadata-to-S3 breach affecting 106M+ customers - is covered in full on the [Real-World AppSec Incidents](../application-security/appsec-real-world-incidents.md) page, since its root cause was an application-layer SSRF vulnerability. It belongs in both places by reference: read it there for the full exploit chain.

## Identity & Token Compromise

### Microsoft Storm-0558 (May-June 2023)

**What happened:** A China-based threat actor forged authentication tokens to access Exchange Online mailboxes at roughly 25 organizations, including US government agencies, by using a stolen Microsoft account (MSA) consumer signing key to sign tokens that were - due to a validation bug - also accepted for **enterprise** Azure AD accounts. Microsoft's own investigation found the key had leaked into a crash dump from a 2021 signing-system crash, which was then accessible from a corporate debugging environment; the actor compromised a Microsoft engineer's corporate account that had access to that environment.

**Root cause:** identity/token trust boundary failure - a consumer-scoped signing key was, due to a library validation gap, accepted for enterprise-scoped tokens; compounded by key material leaking outside its intended secure environment via a crash dump.

**Lesson/mitigation:** validate token scope/issuer explicitly rather than assuming a library does it; treat crash dumps and debugging environments as potentially containing secrets and scope access to them accordingly; rotate signing keys on a defined cadence rather than indefinitely, which shrinks the blast radius of exactly this kind of multi-year-old leaked-key scenario.

## Credential Exposure & Lateral Movement

### Uber (September 2022)

**What happened:** An attacker ran an MFA-fatigue attack against an Uber contractor - repeatedly triggering push-based MFA prompts, then social-engineering the contractor over WhatsApp (posing as Uber IT) into approving one. That got the attacker onto Uber's internal VPN. From there, they found PowerShell scripts on an internal network share containing **hardcoded privileged access management (PAM) admin credentials**, which they used to pivot into Uber's AWS, Google Cloud Platform, Google Workspace, Slack, and incident-response tooling.

**Root cause:** MFA fatigue exploited a weak authentication UX (unlimited push retries with no rate limiting or number-matching), and a hardcoded credential in an internal script defeated what was otherwise a reasonably mature cloud IAM setup.

**Lesson/mitigation:** use number-matching or phishing-resistant MFA (not simple push-approve) and rate-limit MFA prompts; hardcoded credentials in scripts/network shares are a recurring, entirely preventable failure mode - scan internal repositories and shares for secrets the same way you'd scan a public GitHub repo, and use short-lived credentials from a secrets manager instead.

## Exposed & Misconfigured Storage

### Alteryx / Experian Consumer Data Exposure (2017)

**What happened:** Analytics firm Alteryx left a misconfigured AWS S3 bucket publicly accessible, exposing a dataset (originally licensed from Experian's ConsumerView marketing product) covering over 120 million US households - addresses, contact details, mortgage and financial information, and detailed consumer demographic profiles. It was discovered by security researchers (UpGuard) scanning for open buckets, not by an active attacker, but the data was genuinely internet-accessible with no authentication.

**Root cause:** an S3 bucket's access control was left at "public" (or a public-readable ACL/policy was applied) with no compensating control to catch the misconfiguration before it was discovered.

**Lesson/mitigation:** enable [Block Public Access](learning-aws-security/s3-security.md#block-public-access) at the account level as a default, not an opt-in; treat any bucket holding an external vendor's licensed data with the same access rigor as your own customer data - the sensitivity of the data determines the required control, not who originally collected it.

## Why Study These

Every one of these incidents traces back to a small number of recurring root causes - weak MFA UX, a hardcoded credential, a validation assumption that wasn't checked, a storage default left open - that show up again and again across every cloud provider. Recognizing the *pattern* (not just the specific incident) is what separates "I read about Uber's breach once" from "I know to check for hardcoded credentials on internal shares during every cloud security review."

## Credits/References

1. [Microsoft: Analysis of Storm-0558 techniques for unauthorized email access](https://www.microsoft.com/en-us/security/blog/2023/07/14/analysis-of-storm-0558-techniques-for-unauthorized-email-access/)
2. [Microsoft: Results of Major Technical Investigations for Storm-0558 Key Acquisition](https://www.microsoft.com/en-us/msrc/blog/2023/09/results-of-major-technical-investigations-for-storm-0558-key-acquisition)
3. [UpGuard: What Caused the Uber Data Breach](https://www.upguard.com/blog/what-caused-the-uber-data-breach)
4. [Trend Micro: Data on 123 Million US Households Exposed Due to Misconfigured AWS S3 Bucket](https://www.trendmicro.com/vinfo/pl/security/news/virtualization-and-cloud/data-on-123-million-us-households-exposed-due-to-misconfigured-aws-s3-bucket)
5. [nagwww/s3-leaks - a running list of public S3 bucket exposure incidents](https://github.com/nagwww/s3-leaks)

## Continue Learning

- [Real-World AppSec Incidents](../application-security/appsec-real-world-incidents.md) - Capital One's SSRF-driven cloud breach
- [Cloud Security Essentials](cloud-security-essentials.md) · [OWASP Top 10 Cloud](owasp-top10-cloud.md)
- [Multi-Cloud Security Architecture](multi-cloud-security-architecture.md) - the architecture patterns these incidents argue for
