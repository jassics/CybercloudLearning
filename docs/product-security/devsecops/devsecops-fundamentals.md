# DevSecOps Fundamentals

## What DevSecOps Actually Means

DevSecOps is not "add a security team to your DevOps pipeline." It means security is a shared responsibility embedded into every stage of the SDLC - design, code, build, test, release, deploy, operate - rather than a gate bolted on right before release.

The old model treated security as a checkpoint: build the whole app, then hand it to a security team for a pre-release audit. That's slow (findings surface after months of work are already sunk into a design) and adversarial (developers see security as the team that blocks releases). DevSecOps flips this: security tooling and practices run continuously, in the same pipelines developers already use, producing fast feedback while a fix is still cheap.

## Shift Left

"Shift left" means moving security activities as early as possible in the timeline:

```
Design → Code → Build → Test → Release → Deploy → Operate
  ↑        ↑       ↑       ↑        ↑         ↑         ↑
Threat   SAST/   SCA/   DAST/   Signed    Policy    Runtime
Model    Secrets  SBOM   Pen    Artifacts  Gates     Monitoring
         Scan            Test
```

A vulnerability caught during code review costs minutes to fix. The same class of bug found in production costs an incident, a hotfix, customer notification, and possibly a post-mortem. Shifting left isn't about eliminating testing later in the pipeline - it's about catching what's cheap to catch early, so what's left for later stages is genuinely runtime/environment-specific.

## Core DevSecOps Practice Areas

| Practice | Catches | Runs |
|----------|---------|------|
| **Secrets scanning** | Hardcoded credentials, API keys | Pre-commit, every push |
| **SAST** | Code-level vulnerabilities (injection, weak crypto) | Every PR |
| **SCA** | Known CVEs in dependencies, license issues | Every PR/build |
| **IaC scanning** | Misconfigured cloud resources before they're provisioned | Every PR touching Terraform/CloudFormation |
| **Container scanning** | Vulnerable base images, malware in layers | Image build |
| **DAST** | Runtime/config flaws in a running app | Staging, pre-release |
| **Policy-as-code gates** | Non-compliant deploys | Pre-deploy |

See [SAST](../application-security/sast.md) and [SCA](../application-security/sca.md) for the first two in depth.

## Security as Code, Not a Separate Team's Checklist

The defining shift is treating security controls the same way you treat application code: version-controlled, code-reviewed, tested, and deployed through the same CI/CD pipeline.

- A security policy becomes a Rego/OPA rule in the pipeline, not a PDF in a wiki (see [Compliance as Code](compliance-as-code.md)).
- A vulnerability threshold becomes a CI gate, not an email asking someone to "please fix this before launch" (see [Vulnerability Management](vulnerability-management.md)).
- An audit trail is generated automatically by pipeline logs, not reconstructed manually before a compliance review.

This is what lets security scale with engineering headcount instead of becoming a bottleneck - a five-person security team can't manually review every PR at a 500-engineer company, but they can own the rules that every PR is automatically checked against.

## How This Section Fits Together

- [DevSecOps Maturity Model](devsecops-maturity.md) - where your org sits today, and what the next level looks like
- [Vulnerability Management](vulnerability-management.md) - what happens after a scanner finds something
- [Compliance as Code](compliance-as-code.md) - encoding policy/compliance requirements as automated checks
- [SDL in CI/CD Pipeline](sdl-cicd.md) - embedding secure design/review gates into the pipeline
- [SCA in CI/CD Pipeline](sca-cicd.md) - dependency scanning, concretely wired into CI
- [DAST in CI/CD Pipeline](dast-cicd.md) - runtime scanning, concretely wired into CI

## Best Practices

1. **Automate before you mandate** - a manual security checklist gets skipped under deadline pressure; a CI gate doesn't.
2. **Fail fast, fail cheap** - order pipeline stages so fast, cheap checks (secrets scan, lint) run before slow ones (DAST).
3. **Make the secure path the easy path** - golden CI templates, pre-approved base images, and secure-by-default IaC modules beat writing a wiki page nobody reads.
4. **Treat false positives as a tooling bug** - a noisy pipeline that developers learn to ignore is worse than no pipeline.
5. **Measure outcomes, not activity** - track mean-time-to-remediate and escaped-vulnerability rate, not just "number of scans run."

## Credits/References

1. [OWASP DevSecOps Guideline](https://owasp.org/www-project-devsecops-guideline/)
2. [NIST SP 800-218: Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final)
3. [DevSecOps Maturity Model (DSOMM)](https://dsomm.owasp.org/)
