# DevSecOps Interview Questions

The [security-interview-questions](https://github.com/jassics/security-interview-questions) repo's DevSecOps file is still empty upstream, so these questions are grounded directly in this site's [DevSecOps](../product-security/devsecops/devsecops-fundamentals.md) section instead. Expect them to get merged back once the source repo catches up.

## Shift Left & Pipeline Design

??? question "Q: What does 'shift left' actually mean, and why isn't it about eliminating testing later in the pipeline?"
    Shift left means moving security activities as early as possible - threat modeling at design, secrets/SAST scanning at commit, SCA/SBOM at build, DAST/pen testing before release, policy gates before deploy, and runtime monitoring after. The economic argument is simple: a vulnerability caught during code review costs minutes to fix, while the same class of bug found in production costs an incident, a hotfix, and possibly a post-mortem.

    It's not about removing later-stage testing - DAST still matters because it catches runtime/environment-specific issues static analysis is blind to. Shifting left is about catching what's *cheap* to catch early, so what's left for later stages is genuinely stuff that can only be found once the system is actually running.

??? question "Q: You have SAST, SCA, secrets scanning, IaC scanning, container scanning, and DAST all as candidate pipeline checks. How do you order them?"
    Order by cost and speed: fast, cheap checks run on every commit/PR (secrets scanning, a fast SAST subset, linting), while slower, deeper checks run at merge-to-main or pre-deploy (full SAST rule sets, SCA, container scanning). DAST runs latest of all, because it needs a *running* application - typically against a staging or ephemeral preview environment, either on every PR (a fast passive/baseline scan) or on a schedule/pre-release (a slower, active scan that actually sends attack payloads).

    A good answer explicitly separates "gate every commit" from "gate the merge" from "gate the deploy" rather than treating all checks as one undifferentiated pile that all runs everywhere.

??? question "Q: How would you roll out a new SAST/SCA gate without breaking every existing build on day one?"
    Baseline first: run the scanner, capture the current set of findings as a baseline, and configure the gate to fail only on *new* findings not present in that baseline - not on the full accumulated backlog. This lets you turn on enforcement immediately ("no new critical/high vulnerabilities") while tracking the existing debt separately for a planned remediation effort. Skipping this step is the single most common reason teams end up disabling a security gate entirely - a build that's red from day one because of years of legacy findings just trains developers to ignore it.

## Maturity & Vulnerability Management

??? question "Q: Describe a DevSecOps maturity model in your own words - what's the difference between Level 2 and Level 3?"
    A simple four-level model: Level 1 (Initial) is manual, reactive security with no CI scanning; Level 2 (Managed) has SAST/SCA running in CI but as *informational-only* - findings pile into a backlog nobody prioritizes; Level 3 (Defined) turns those same scans into *enforced gates* with severity thresholds and defined remediation SLAs; Level 4 (Optimizing) adds policy-as-code gates that block non-compliant deploys automatically, with full traceability and metrics driving continuous tuning.

    The Level 2→3 jump is the one that trips up most teams, because it requires getting engineering leadership buy-in that a red build for a critical finding is genuinely non-negotiable - not just "nice to have." Getting there needs baselining (see above) and aggressively tuning out false positives before flipping enforcement on, since a gate developers can't trust gets bypassed.

??? question "Q: Why is CVSS alone a poor way to prioritize vulnerability remediation, and what would you combine it with?"
    CVSS measures theoretical severity in isolation - it doesn't know whether the vulnerable code path is actually reachable in your application, whether the asset is internet-facing, or whether it's being actively exploited in the wild. A mature prioritization approach combines CVSS with EPSS (Exploit Prediction Scoring System - the probability a given CVE gets exploited in the next 30 days), CISA's Known Exploited Vulnerabilities catalog (automatic critical priority if listed), reachability/exploitability analysis (is the vulnerable function actually called?), and business context (does this asset touch payment data or PII?).

    Concretely: a CVSS 9.8 in an unreachable code path of an internal tool is lower priority than a CVSS 7.5 on an internet-facing login endpoint that's on the CISA KEV list.

??? question "Q: A scanner update just surfaced 200 new SCA findings overnight. Walk through how you'd triage that."
    First, figure out if it's a real new-dependency issue or a rule/database update surfacing findings that were always there (very common after a scanner version bump). Dedupe against anything already formally risk-accepted. Then prioritize using reachability and exposure rather than blanket severity - most dependency CVEs sit in code paths the application never actually calls, so filtering to reachable, internet-facing, critical/high findings usually shrinks 200 down to a handful of real action items. Don't just blanket-assign all 200 to already-overloaded teams; that guarantees the backlog gets ignored.

## Policy as Code & CI/CD Integration

??? question "Q: What's 'compliance as code,' and how is it different from a traditional quarterly audit?"
    Traditional compliance is a point-in-time manual check - someone samples resources against a control list once a quarter and hopes nothing drifted before the next audit. That doesn't scale when infrastructure changes hundreds of times a day. Compliance as code encodes policy requirements as machine-readable rules (OPA/Rego, Checkov, Sentinel) that run automatically against every change, so a non-compliant resource - like an S3 bucket without encryption - can be blocked *before* it's ever provisioned, and audit evidence is generated continuously as pipeline logs instead of assembled by hand once a quarter.

??? question "Q: Write (or describe) a policy that blocks an unencrypted S3 bucket from being provisioned via Terraform. What tool would you use?"
    Using Checkov (works directly against a Terraform plan), you'd rely on a built-in check like `CKV_AWS_19` ("Ensure S3 bucket has server-side encryption enabled") and run it in CI with `soft_fail: false` so a violation actually fails the pipeline rather than just warning. Equivalently, with OPA/Rego against the Terraform plan JSON:

    ```rego
    package terraform.s3

    deny[msg] {
        resource := input.resource_changes[_]
        resource.type == "aws_s3_bucket"
        not resource.change.after.server_side_encryption_configuration
        msg := sprintf("S3 bucket '%s' must have encryption enabled", [resource.address])
    }
    ```

    Both approaches produce the same outcome: `terraform plan` creating an unencrypted bucket fails the pipeline before `apply` ever runs. The `soft_fail: false` / hard-fail detail matters in an interview answer - a check that only warns gets ignored under deadline pressure, same as an unenforced SAST gate.

??? question "Q: How does DAST complement SAST rather than duplicate it, and why does DAST typically run later in the pipeline?"
    SAST analyzes source code without executing it, so it's blind to runtime/deployment-specific issues - missing security headers, verbose error pages, broken auth flows that only manifest when the app is actually running end-to-end. DAST attacks a *running instance* with real HTTP requests, which is exactly why it needs a deployed environment (staging or an ephemeral preview) and typically runs later than SAST/SCA in the pipeline. The two are complementary, not redundant: SAST might flag a SQL query as a data-flow risk pattern, while DAST separately confirms it's actually exploitable by triggering a real database error via a crafted request - together that's a stronger signal ("this pattern is dangerous" + "this pattern is exploitable in the deployed app") than either alone.

## Practice Next

- [DevSecOps Fundamentals](../product-security/devsecops/devsecops-fundamentals.md)
- [DevSecOps Maturity Model](../product-security/devsecops/devsecops-maturity.md)
- [Vulnerability Management](../product-security/devsecops/vulnerability-management.md)
- [Compliance as Code](../product-security/devsecops/compliance-as-code.md)
- [DevSecOps Study Plan](../study-plan/cybersecurity/devsecops-study-plan.md)
- [security-interview-questions](https://github.com/jassics/security-interview-questions) on GitHub for the canonical, evolving question set
