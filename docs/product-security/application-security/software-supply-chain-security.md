# Software Supply Chain Security

## What "Supply Chain" Means Beyond Dependencies

Software supply chain security is often reduced to "scan your dependencies for CVEs" - that's [SCA](sca.md), and it's necessary but covers only one link in a much longer chain:

```text
Source Code → Dependencies → Build/CI Pipeline → Artifacts/Registry → Deployment/Runtime
```

An attacker doesn't need to find a vulnerability in your first-party code if they can compromise any link upstream of it: a maintainer's credentials, a CI runner, a signing key, or an artifact registry. Every one of those compromises inherits the trust your users already place in your software - that's what makes supply chain attacks disproportionately damaging relative to their technical complexity.

## Risk by Stage

| Stage | What Can Go Wrong |
|-------|---------------------|
| **Source control** | Compromised developer credentials, unsigned/unverified commits, insufficient branch protection |
| **Dependencies** | Malicious or typosquatted packages, compromised maintainer accounts, dependency confusion (see [SCA](sca.md)) |
| **Build/CI pipeline** | Compromised build agents, poisoned build scripts, secrets leaked from CI environment variables |
| **Artifacts/registry** | Unsigned or mutable artifacts, compromised registry credentials, tampering between build and publish |
| **Deployment/runtime** | Pulling unverified images/packages, no attestation check before deploy, drift between what was built and what's running |

## SLSA: Graduated Levels of Build Integrity

[**SLSA**](https://slsa.dev/) (Supply-chain Levels for Software Artifacts, pronounced "salsa") is a framework - incubated at Google, now governed by the Open Source Security Foundation (OpenSSF) under the Linux Foundation - for reasoning about how much you can trust that a given artifact was built the way it claims to have been, rather than just scanning the artifact after the fact:

| Level | Requirement | Protects Against |
|-------|--------------|---------------------|
| **Build L0** | No requirements (single-machine dev/test builds) | Nothing - baseline |
| **Build L1** | Provenance exists (build platform, process, and inputs are documented) | Accidental mistakes; provides an audit trail |
| **Build L2** | Builds run on a hosted platform, provenance is signed | Post-build tampering - a downstream consumer can verify authenticity |
| **Build L3** | Build platform isolates runs from each other and protects signing material from build steps | Tampering **during** the build itself, including by a compromised build script |

Most organizations today sit at L1-L2. Reaching L3 typically means moving off self-hosted, shared CI runners onto a platform that enforces run isolation and keeps signing keys out of reach of the build script - a meaningful infrastructure investment, not just a policy change.

## Securing Each Link

**Source control:** require signed commits or at minimum verified commit authorship, enforce branch protection with required reviews before merge to main/release branches, and treat any CI/CD config change (`.github/workflows/`, `Jenkinsfile`, etc.) with the same review rigor as application code - a modified pipeline file is a more direct path to compromise than modifying the application itself.

**Dependencies:** see [SCA](sca.md) for the full treatment - lockfiles for deterministic installs, private registries/proxies to reduce exposure to the public registry's full attack surface, and scanning on every build, not periodically.

**Build/CI pipeline:** least-privilege service accounts for CI (a build job should not hold broader cloud/registry permissions than the specific artifact it publishes requires), isolate build agents by trust level (don't run untrusted PR builds on the same infrastructure/credentials as release builds), and never let build scripts read signing keys directly - this is exactly what SLSA Build L3 formalizes.

**Artifacts:** sign every artifact (container images via [Sigstore/Cosign](https://www.sigstore.dev/), packages via your ecosystem's signing mechanism) and verify signatures before deploy, not just at publish time. Publish an SBOM (CycloneDX or SPDX) with every release - see [SCA: What SCA Tools Check](sca.md#what-sca-tools-check) for SBOM generation tooling.

**Deployment:** enforce that only signed, attested artifacts can be deployed (an admission controller in Kubernetes is the common enforcement point - see [Kubernetes Security](../container-security/kubernetes-security.md)), and track which artifact version is actually running where, so an incident response team isn't guessing.

## Real Incidents

**SolarWinds / SUNBURST (disclosed December 2020).** Attackers compromised SolarWinds' own build system and inserted a backdoor (SUNBURST) directly into legitimate, digitally-signed updates of the Orion IT-monitoring platform, which then shipped to an estimated 18,000 customers worldwide including multiple US government agencies. Customers had no reason to distrust the update - it was signed with SolarWinds' legitimate certificate. FireEye discovered and disclosed the campaign after detecting it being used against their own network. *Lesson: a build system is as valuable a target as production itself, because compromising it launders malicious code through the vendor's own trusted signing identity.*

**event-stream npm compromise (September-November 2018).** The original maintainer of the widely-used `event-stream` package (2M+ weekly downloads) handed maintenance to a new contributor who had volunteered, no vetting beyond that. The new maintainer added a dependency, `flatmap-stream`, which a different, unrelated account later modified to inject an obfuscated payload - one specifically engineered to activate only in environments matching the Copay Bitcoin wallet app, targeting its users' funds. NPM's security team called it "the most sophisticated payload we've seen to date" at the time. A computer science student noticed the obfuscated code and flagged it publicly before NPM unpublished the malicious package. *Lesson: maintainer handoff in open source has essentially no formal vetting process by default - "a new person volunteered to maintain this" is itself a supply-chain trust decision, whether or not anyone treats it as one.*

**XZ Utils backdoor, CVE-2024-3094 (discovered March 29, 2024).** An account using the name "Jia Tan" spent roughly two years building trust as a co-maintainer of the widely-used `xz` compression library (a dependency of OpenSSH on most Linux distributions via `liblzma`), using sockpuppet accounts to pressure the original maintainer into handing over commit access. Once trusted, they embedded a backdoor across versions 5.6.0-5.6.1, hidden inside binary test files and only activated by a build-script modification that detected it was compiling on `x86-64` Linux with `glibc`. The backdoor would have allowed remote code execution against any system with a specific Ed448 private key, via SSH - security researcher Alex Stamos described what it would have been had it gone undetected as "a master key to any of the hundreds of millions of computers around the world that run SSH." It was caught by pure chance: Microsoft engineer Andres Freund noticed SSH logins were using slightly more CPU than expected and investigated. *Lesson: this is widely regarded as the most sophisticated supply-chain social-engineering campaign ever publicly documented against open source - and it was caught by a performance anomaly, not a security control. Design your supply-chain defenses assuming the social-engineering/trust-building attack vector will eventually bypass whatever human vetting you rely on.*

## Governance and Response

- **Maintain an up-to-date inventory** of what's built, where it's deployed, and its SBOM - you cannot respond quickly to "is component X affected" if you have to go find out first.
- **Have a rapid patch/rollback plan** for a compromised dependency discovered in production, not just a vulnerability disclosed before exploitation.
- **Run tabletop exercises against real incidents** above - "if XZ Utils had shipped in our product, how long would it have taken us to notice, and by what means?" is a more useful exercise than a generic scenario.
- **Policy, not just tooling**: define who can add a new dependency, who can modify CI/CD configuration, and what review a maintainer handoff requires - the event-stream and XZ Utils incidents were both, fundamentally, failures of process around trust transfer, not failures of a scanning tool.

## Credits/References

1. [SLSA (Supply-chain Levels for Software Artifacts)](https://slsa.dev/)
2. [CISA: SolarWinds and Active Exploitation Alert](https://www.cisa.gov/news-events/alerts/2020/12/13/active-exploitation-solarwinds-software)
3. [The Register: npm Package Compromise Targeting Bitcoin Wallets](https://www.theregister.com/2018/11/26/npm_repo_bitcoin_stealer/)
4. [CVE-2024-3094: XZ Utils Backdoor](https://nvd.nist.gov/vuln/detail/CVE-2024-3094)
5. [Sigstore: Keyless Signing for Software Artifacts](https://www.sigstore.dev/)
6. [CycloneDX SBOM Standard](https://cyclonedx.org/)
7. [jassics/security-study-plan: Software Supply Chain Security](https://github.com/jassics/security-study-plan/blob/main/software-supply-chain-security-study-plan.md)
