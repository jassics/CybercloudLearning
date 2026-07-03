# DevSecOps Maturity Model

## Why a Maturity Model

"We do DevSecOps" means very different things at different organizations - one team runs a manual pentest once a year and calls it done, another blocks every deploy automatically on unreviewed policy violations. A maturity model gives you a shared vocabulary to answer "how mature are we, really?" and a concrete next step instead of a vague "get better at security."

This is a simplified, four-level model in the spirit of the [OWASP DevSecOps Maturity Model (DSOMM)](https://dsomm.owasp.org/) - use DSOMM directly if you need a more granular, dimension-by-dimension assessment. See [DevSecOps Fundamentals](devsecops-fundamentals.md) for the broader practice areas this model is scoring you against.

## The Four Levels

| Level | Name | What It Looks Like |
|-------|------|---------------------|
| **1** | Initial | Security is manual, reactive, and happens right before release (or after an incident). No automated scanning in CI. |
| **2** | Managed | SAST/SCA run in CI but as informational-only jobs; findings go to a backlog nobody prioritizes. Security review is a checklist, not a gate. |
| **3** | Defined | SAST/SCA/secrets scanning/container scanning are enforced gates with defined severity thresholds. DAST runs against staging pre-release. Findings are triaged with SLAs. |
| **4** | Optimizing | Policy-as-code gates block non-compliant deploys automatically (see [Compliance as Code](compliance-as-code.md)). Full traceability from finding to fix. Metrics (MTTR, escaped-vulnerability rate) drive continuous tuning of the pipeline itself. |

## Self-Assessment Checklist

Score your org against each row - "yes" moves you toward the next level up:

- [ ] SAST runs automatically on every pull request (not just on-demand)
- [ ] SCA/dependency scanning blocks merges on critical/known-exploited CVEs
- [ ] Secrets scanning runs pre-commit or pre-push, not just in CI
- [ ] Container images are scanned before they can be deployed
- [ ] IaC ([Terraform](terraform.md)/CloudFormation) is scanned for misconfigurations before `apply`
- [ ] DAST runs against a staging environment before every release
- [ ] Vulnerability remediation has defined SLAs by severity (see [Vulnerability Management](vulnerability-management.md))
- [ ] Compliance requirements are encoded as automated policy checks, not manual audits
- [ ] Security findings are tracked in the same system engineers already use (Jira, GitHub Issues) - not a separate spreadsheet
- [ ] Leadership sees a dashboard of security metrics (MTTR, open critical count, scan coverage), not just a quarterly PDF

Roughly: 0-2 checked = Level 1, 3-5 = Level 2, 6-8 = Level 3, 9-10 = Level 4.

## Moving Up a Level

The jump that trips up most teams is **Level 2 → Level 3**: going from "scanners run and produce a report" to "scanners actually block bad merges." This requires:

1. Baselining existing findings (don't fail the build on years of accumulated debt - track it separately, gate only on *new* findings).
2. Getting engineering leadership buy-in that a red build for a critical vuln is non-negotiable.
3. Tuning out false positives aggressively before turning on enforcement - a gate developers can't trust gets bypassed.

The jump to **Level 4** is less about tooling and more about culture: security becomes something engineering teams own and are measured on, not something a separate team polices.

## Best Practices

1. **Don't skip levels** - trying to jump straight to full policy-as-code enforcement without first getting clean SAST/SCA signal just trains developers to ignore red builds.
2. **Re-assess quarterly** - maturity isn't a one-time audit; pipelines and teams regress without maintenance.
3. **Different services can be at different levels** - a legacy monolith and a new microservice don't have to move at the same pace, but track both explicitly.

## Credits/References

1. [OWASP DevSecOps Maturity Model (DSOMM)](https://dsomm.owasp.org/)
2. [BSIMM (Building Security In Maturity Model)](https://www.bsimm.com/)
