# SAST (Static Application Security Testing)

## What is SAST?

Static Application Security Testing analyzes source code, bytecode, or binaries **without executing the application** to find security vulnerabilities. It works by building a model of the code (control flow, data flow, abstract syntax trees) and matching it against known-insecure patterns.

Because it runs on source code, SAST can be integrated as early as the developer's IDE and as part of every commit/pull request - making it one of the cheapest places to catch vulnerabilities.

## How SAST Works

1. **Parsing** - the tool builds an Abstract Syntax Tree (AST) and Control Flow Graph (CFG) of the code.
2. **Data flow analysis** - tracks how data (especially untrusted input) moves through the program ("taint tracking" - source → sink).
3. **Rule matching** - compares code patterns/data flows against a rule set of known-insecure constructs (e.g., "untrusted input reaches a SQL query without sanitization").
4. **Reporting** - flags findings with file/line, severity, and often a suggested fix.

## What SAST Is Good At

- Injection flaws (SQL, command, LDAP) via taint analysis
- Hardcoded secrets and credentials
- Use of deprecated/dangerous functions (`eval`, weak crypto APIs, `pickle.loads`)
- Insecure configuration patterns in code
- Consistent, repeatable coverage across an entire codebase, every build

## What SAST Misses

- **Business logic flaws** - a scanner can't know that "apply discount code twice" shouldn't be allowed.
- **Authorization gaps** - missing checks that depend on application-specific ownership models.
- **Runtime/environment-specific issues** - misconfigurations only visible when the app is running (covered better by DAST).
- Anything requiring understanding of intent, not just pattern - this is why [manual secure code review](secure-code-review.md) remains necessary.

## Popular SAST Tools

| Tool | Language Coverage | Notes |
|------|--------------------|-------|
| **Semgrep** | Multi-language | Open-source, fast, highly customizable rule syntax, good CI/CD fit |
| **SonarQube** | Multi-language | Combines code quality + security, self-hosted or cloud |
| **Checkmarx** | Multi-language | Commercial, enterprise-scale |
| **Fortify (OpenText)** | Multi-language | Commercial, deep enterprise integration |
| **Bandit** | Python-specific | Lightweight, common in Python CI pipelines |
| **ESLint security plugins** | JavaScript/TypeScript | Combines linting with security rules |
| **Gosec** | Go-specific | Common in Go CI pipelines |
| **CodeQL** | Multi-language | GitHub-native, semantic query-based analysis |

## Integrating SAST into the SDLC

```
IDE (pre-commit)  →  Pull Request (CI gate)  →  Merge to main (full scan)  →  Scheduled deep scan
   Fast/local           Blocks bad merges          Baseline tracking          Comprehensive sweep
```

- **Shift left**: run a fast subset of rules in the IDE or pre-commit hook for instant feedback.
- **CI/CD gate**: run on every PR, fail the build on new critical/high findings (not on pre-existing debt, to avoid blocking unrelated work).
- **Baseline management**: track existing findings separately so teams can pay down technical debt without blocking every PR.

## Handling False Positives

SAST tools are inherently imprecise (they analyze code without full runtime context), so triage is essential:

1. Tune/suppress rules that consistently produce noise for your codebase's patterns.
2. Use inline suppression comments **sparingly** and only with a documented justification (never as a blanket bypass).
3. Track false-positive rate as a tool health metric - a noisy scanner gets ignored by developers.

## SAST vs. DAST vs. SCA

| Aspect | SAST | DAST | SCA |
|--------|------|------|-----|
| What it analyzes | Source/bytecode | Running application | Dependencies/libraries |
| When it runs | Build time, pre-runtime | Runtime (staging/prod-like) | Build time |
| Finds | Code-level flaws | Runtime/config flaws | Known CVEs in dependencies |
| Requires running app | No | Yes | No |

They are complementary, not substitutes - a mature AppSec program runs all three (see [SCA](sca.md), and [DAST in CI/CD](../devsecops/dast-cicd.md)).

## Credits/References

1. [OWASP Source Code Analysis Tools](https://owasp.org/www-community/Source_Code_Analysis_Tools)
2. [Semgrep Documentation](https://semgrep.dev/docs/)
3. [NIST SP 800-218: Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final)
