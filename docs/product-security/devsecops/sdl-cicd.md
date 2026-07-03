# SDL in CI/CD Pipeline

## What This Is

A Security Development Lifecycle (SDL) defines the security activities required at each stage of building software - threat modeling at design time, secure coding standards during implementation, testing before release, and a response plan after deployment. Historically, SDL was a document teams referenced manually. Embedding it in CI/CD means SDL gates are enforced automatically at the point they're relevant, instead of relying on someone remembering to run through a checklist.

## Mapping SDL Stages to Pipeline Stages

```
Design          PR Opened         Merge to Main       Pre-Deploy         Post-Deploy
  │                 │                    │                  │                  │
  ▼                 ▼                    ▼                  ▼                  ▼
Threat model    SAST + secrets      SCA + full SAST     DAST against      Runtime monitoring
trigger for     scan + lint         scan + security     staging +         + incident
new features    (fast, every       sign-off for high-   manual pentest    response plan
                 commit)            risk changes         for major        active
                                                          releases
```

### Design Stage: Threat Modeling Trigger

Not every PR needs a full threat model, but certain changes should automatically flag one as required - a lightweight CI check can catch this:

```yaml
# Flag PRs touching auth/payment/data-access code for mandatory threat model sign-off
- name: Check for high-risk paths
  run: |
    if git diff --name-only origin/main | grep -E '(auth/|payment/|pii/)'; then
      echo "::warning::This PR touches a high-risk area - threat model review required before merge"
    fi
```

See [Threat Modeling](../application-security/threat-modeling.md) for the STRIDE process itself.

### PR Stage: Fast, Cheap Gates

Every PR, every time, should run in under a few minutes:

```yaml
name: PR Security Gates
on: pull_request
jobs:
  fast-checks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Secrets scan
        uses: gitleaks/gitleaks-action@v2
      - name: SAST (fast subset)
        run: semgrep --config auto --error
```

### Merge Stage: Deeper, Slower Checks

Full SAST rule sets and SCA don't need to block every commit push, but should gate the merge to main:

```yaml
name: Merge Gates
on:
  push:
    branches: [main]
jobs:
  full-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Full SAST scan
        run: semgrep --config p/owasp-top-ten
      - name: SCA
        run: trivy fs --severity CRITICAL,HIGH --exit-code 1 .
```

See [SCA in CI/CD Pipeline](sca-cicd.md) for the SCA step in depth.

### Pre-Deploy Stage: Runtime Verification

Before promoting to production, run DAST against a staging environment and require a security sign-off for major releases - see [DAST in CI/CD Pipeline](dast-cicd.md).

## Security Sign-Off as Code, Not a Meeting

Instead of a manual "security team approves the release" meeting, encode the sign-off criteria as required CI status checks in your branch protection rules: no open critical SAST/SCA findings, DAST scan passed, threat model completed for flagged high-risk changes. GitHub/GitLab branch protection can require these checks to pass before merge is even allowed - removing the human bottleneck for the common case, while still allowing an explicit manual override (logged) for genuine emergencies.

## Best Practices

1. **Match gate cost to pipeline stage** - cheap/fast checks on every commit, expensive/slow checks at merge or pre-deploy.
2. **Make high-risk paths self-flagging** - don't rely on developers remembering which directories need extra scrutiny.
3. **Encode sign-off as branch protection rules**, not a Slack approval - it's auditable and can't be skipped by accident.
4. **Keep an emergency override path**, but log every use of it and review those logs regularly.

## Credits/References

1. [Microsoft Security Development Lifecycle (SDL)](https://www.microsoft.com/en-us/securityengineering/sdl)
2. [OWASP Software Assurance Maturity Model (SAMM)](https://owaspsamm.org/)
3. [NIST SP 800-218: Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final)
