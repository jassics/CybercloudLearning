# SCA in CI/CD Pipeline

This page covers concretely wiring [SCA](../application-security/sca.md) into a pipeline. Read that page first for the underlying concepts (what SCA checks, how to prioritize findings, SBOMs) - this page is the "how do I actually make this run on every PR" follow-up.

## A Real GitHub Actions Pipeline

```yaml
name: Dependency Scan
on:
  pull_request:
  push:
    branches: [main]

jobs:
  sca-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Trivy filesystem scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: fs
          scan-ref: .
          severity: CRITICAL,HIGH
          exit-code: 1          # fail the build on critical/high findings
          format: sarif
          output: trivy-results.sarif

      - name: Upload SARIF to GitHub Security tab
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: trivy-results.sarif

      - name: Generate SBOM
        uses: anchore/sbom-action@v0
        with:
          format: cyclonedx-json
          output-file: sbom.cdx.json

      - name: Upload SBOM as build artifact
        uses: actions/upload-artifact@v4
        with:
          name: sbom
          path: sbom.cdx.json
```

What this does:

1. Scans every dependency manifest in the repo (works across ecosystems - npm, pip, Maven, Go modules, etc.).
2. **Fails the build** (`exit-code: 1`) on critical/high severity findings - this is the difference between "informational" and "enforced." A scan that never blocks anything trains developers to ignore it.
3. Uploads results in SARIF format so findings show up natively in GitHub's Security tab, not just a build log nobody reads.
4. Generates and stores a CycloneDX SBOM as a build artifact for every build - this is what lets you answer "are we affected by CVE-XXXX?" in minutes instead of days when the next Log4Shell-style incident happens.

## Handling the "This Breaks Every Build" Problem

The first time you turn on hard-blocking SCA, you'll likely surface a backlog of existing critical/high findings across the whole dependency tree. Don't disable the gate - baseline it instead:

```bash
# Generate a baseline of currently-known findings
trivy fs --format json --output baseline.json .

# In CI, only fail on NEW findings not in the baseline
trivy fs --severity CRITICAL,HIGH --ignorefile baseline.json --exit-code 1 .
```

This lets you enforce "no new critical/high dependency vulnerabilities" immediately while planning a separate remediation effort for the existing backlog - the same pattern used for [SAST](../application-security/sast.md) baseline management.

## Reachability-Aware Gating (Reducing Noise)

A large fraction of dependency CVEs are in code paths your application never calls. Where the tool supports it (Grype's reachability analysis, Snyk's reachable vulnerabilities feature), gate more strictly on *reachable* critical/high findings and treat unreachable ones as lower priority - this cuts a huge amount of the noise that causes teams to disable SCA gates entirely out of frustration.

## Best Practices

1. **Fail the build on critical/high, not on everything** - medium/low findings should be visible but shouldn't block a release, or the gate becomes an obstacle course.
2. **Store the SBOM as a build artifact on every build**, not just at release time - you want history to answer "were we affected on March 3rd?"
3. **Re-scan continuously, not just at build time** - new CVEs get disclosed for dependencies that haven't changed in your codebase in months.
4. **Baseline before enforcing** - see above.

## Credits/References

1. [Trivy by Aqua Security](https://trivy.dev/)
2. [Anchore SBOM Action](https://github.com/anchore/sbom-action)
3. [CycloneDX SBOM Standard](https://cyclonedx.org/)
4. [SCA](../application-security/sca.md)
