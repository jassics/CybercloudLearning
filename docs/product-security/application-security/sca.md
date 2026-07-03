# SCA (Software Composition Analysis)

## What is SCA?

Software Composition Analysis identifies the open-source and third-party components used in an application - direct and transitive dependencies - and checks them against known vulnerability databases (CVEs), license obligations, and maintenance health.

Modern applications are often 70-90% third-party code by volume. A vulnerability in a deeply nested transitive dependency (like the Log4Shell vulnerability in Log4j) can be just as exploitable as a first-party bug, but far easier to miss without tooling.

## Why SCA Matters

- **Scale of the supply chain problem** - a single application can pull in hundreds of transitive dependencies most developers have never directly reviewed.
- **High-profile incidents** - Log4Shell (CVE-2021-44228), the `event-stream` npm package compromise, the XZ Utils backdoor (CVE-2024-3094) all originated in dependencies, not first-party code.
- **Speed of disclosure** - new CVEs are published continuously; without automated scanning, teams have no reliable way to know they're affected.

## What SCA Tools Check

1. **Known vulnerabilities (CVEs)** - matches dependency versions against vulnerability databases (NVD, GitHub Advisory Database, OSV).
2. **License compliance** - flags dependencies with licenses incompatible with your project's licensing (e.g., GPL in a proprietary commercial product).
3. **Outdated/unmaintained dependencies** - components with no recent updates or an abandoned upstream project.
4. **Transitive dependency risk** - vulnerabilities in dependencies-of-dependencies, which are easy to miss manually.
5. **Software Bill of Materials (SBOM) generation** - a machine-readable inventory of everything shipped, increasingly required by regulation (e.g., US Executive Order 14028).

## Popular SCA Tools

| Tool | Notes |
|------|-------|
| **Trivy** | Open-source, scans dependencies, containers, and IaC; fast, widely adopted in CI/CD |
| **Grype** | Open-source vulnerability scanner, pairs well with Syft for SBOM generation |
| **OWASP Dependency-Check** | Open-source, Java/multi-language, integrates with Maven/Gradle/CI |
| **Snyk** | Commercial (free tier), strong developer experience, PR-based fix suggestions |
| **GitHub Dependabot** | Native to GitHub, automated PRs for vulnerable/outdated dependencies |
| **pip-audit / npm audit / OSV-Scanner** | Ecosystem-native or cross-ecosystem CLI scanners |
| **Syft** | SBOM generation (CycloneDX/SPDX formats) |

## SCA in the CI/CD Pipeline

```text
Dependency added/updated → SCA scan → Block on Critical/High CVE → Generate SBOM → Store as build artifact
```

- Run SCA on every build, not just periodically - new CVEs can affect dependencies that haven't changed in your codebase.
- Gate merges/releases on critical/high severity findings; track medium/low as backlog debt.
- Publish an SBOM (CycloneDX or SPDX format) with each release for supply-chain transparency and incident response readiness.

See [SCA in CI/CD Pipeline](../devsecops/sca-cicd.md) for pipeline integration details.

## Remediation Strategies

1. **Upgrade** to a patched version - the most common and preferred fix.
2. **Apply a workaround/mitigating control** if no patch exists yet (e.g., disable the vulnerable feature/config).
3. **Replace the dependency** if it's abandoned or the maintainer is unresponsive.
4. **Vendor/pin and patch internally** as a last resort, with a plan to remove the fork once upstream fixes it.
5. **Accept the risk** (documented, time-bound) only when the vulnerable code path is genuinely unreachable in your usage.

## Prioritizing SCA Findings

Not every CVE in a dependency list is equally urgent. Prioritize using:

- **Reachability** - is the vulnerable function/code path actually called by your application? (Tools like Semgrep or Grype's reachability analysis help here.)
- **Exploitability** - is there a known public exploit (check CISA's Known Exploited Vulnerabilities catalog)?
- **CVSS score** - baseline severity, but should never be the only factor.
- **Exposure** - is the affected component internet-facing or internal-only?

## SCA vs. SAST

| Aspect | SCA | SAST |
|--------|-----|------|
| Analyzes | Third-party/open-source dependencies | First-party source code |
| Finds | Known CVEs, license issues | Custom code vulnerabilities |
| Update mechanism | Upgrade dependency version | Fix code directly |

They're complementary - see [SAST](sast.md) for the first-party code counterpart.

## Credits/References

1. [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)
2. [NIST National Vulnerability Database (NVD)](https://nvd.nist.gov/)
3. [OSV (Open Source Vulnerabilities) Database](https://osv.dev/)
4. [CISA Known Exploited Vulnerabilities Catalog](https://www.cisa.gov/known-exploited-vulnerabilities-catalog)
5. [CycloneDX SBOM Standard](https://cyclonedx.org/)
