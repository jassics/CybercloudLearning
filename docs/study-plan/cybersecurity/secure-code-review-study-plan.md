# Secure Code Review Study Plan

This page is updated based on [jassics/security-study-plan/secure-code-review-study-plan](https://github.com/jassics/security-study-plan/blob/main/secure-code-review-study-plan.md)

This study plan is designed to help you master Secure Code Review - methodologies, common vulnerabilities, tools, and best practices for finding security flaws in source code. Pair it with the site's [Secure Code Review guide](../../product-security/application-security/secure-code-review.md) for the full methodology writeup.

## ToC

1. [Code Review Fundamentals](#code-review-fundamentals) - 2 weeks
2. [Common Vulnerabilities in Code](#common-vulnerabilities-in-code) - 2 weeks
3. [Process and Checklists](#process-and-checklists) - 2 weeks
4. [Tools and Automation](#tools-and-automation) - 2 weeks
5. [Resources](#resources)

## Code Review Fundamentals
**Duration: 2 weeks**

### Week 1-2: The Basics

1. **What is Secure Code Review?**
    - Functional review vs. security review
    - Manual vs. automated review
2. **Code Review Strategies:**
    - **Top-down** - start from high-level logic/entry points
    - **Bottom-up** - start from sensitive functions (sinks)
3. **Secure Coding Principles:** input validation, output encoding, least privilege, defense in depth - see [Secure Coding](../../product-security/application-security/secure-coding.md)

## Common Vulnerabilities in Code
**Duration: 2 weeks**

### Week 3-4: Spotting Bugs

1. **OWASP Top 10 (Code Perspective):**
    - **Injection** - SQLi, command injection (unparameterized queries, `eval()`, `exec()`)
    - **Broken Auth** - hardcoded credentials, weak session management
    - **XSS** - lack of context-aware encoding
    - **Insecure Deserialization** - unsafe handling of serialized objects
2. **Language-Specific Issues:**
    - **Java** - deserialization, XXE
    - **Python** - `pickle`, `eval()`, Jinja2 SSTI
    - **JavaScript/Node.js** - prototype pollution, `eval()`

## Process and Checklists
**Duration: 2 weeks**

### Week 5-6: Systematic Review

1. **OWASP Secure Code Review Guide** - read it to understand the methodology
2. **Checklists:** authentication & authorization, data validation, error handling & logging, cryptography (weak algorithms, hardcoded keys)
3. **Reviewing Business Logic:** race conditions, order-of-operations flaws, price manipulation

## Tools and Automation
**Duration: 2 weeks**

### Week 7-8: SAST & IDE Plugins

1. **Static Application Security Testing (SAST):**
    - **SonarQube** - setup and rule configuration
    - **Semgrep** - writing custom rules (highly recommended) - see the site's [SAST guide](../../product-security/application-security/sast.md)
    - **CodeQL** - querying code as data
2. **IDE Plugins:** Snyk, SonarLint
3. **Limitations of Tools:** understanding false positives/negatives, and why manual review is still needed for logic bugs

## Resources

### Guides

- [OWASP Secure Code Review Guide](https://owasp.org/www-project-secure-code-review-guide/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/archive/2023/2023_cwe_top25.html)

### Tools

- [Semgrep](https://semgrep.dev/)
- [SonarQube](https://www.sonarqube.org/)
- [CodeQL](https://codeql.github.com/)

### Practice

- [Secure Code Warrior](https://www.securecodewarrior.com/) (free trial/community)
- [SonarQube Rules Explorer](https://rules.sonarsource.com/) - learn by seeing bad vs. good code side by side

### Interview Questions

Secure code review questions are commonly bundled into [Application Security interview questions](https://github.com/jassics/security-interview-questions/blob/main/application-security-interview-questions.md).
