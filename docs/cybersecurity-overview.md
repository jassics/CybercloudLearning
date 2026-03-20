# Cybersecurity Overview

## Introduction

Cybersecurity is the practice of protecting systems, networks, and data from digital attacks. As organizations increasingly rely on technology, the demand for skilled security professionals continues to grow exponentially.

This guide provides an overview of cybersecurity domains, career paths, and essential skills needed to succeed in this field.

## Cybersecurity Domains

| Domain | Focus Area |
|--------|------------|
| **Application Security** | Securing software throughout SDLC |
| **Cloud Security** | Protecting cloud infrastructure and data |
| **Network Security** | Defending network infrastructure |
| **Identity & Access Management** | Managing user access and authentication |
| **Security Operations** | Monitoring, detection, and incident response |
| **GRC** | Governance, Risk, and Compliance |
| **Penetration Testing** | Offensive security and vulnerability assessment |

## Common Skill Sets for Security Engineer

### Technical Skills

- **Programming** - Python, Bash, PowerShell, Go
- **Networking** - TCP/IP, DNS, HTTP/HTTPS, firewalls
- **Operating Systems** - Linux, Windows administration
- **Cloud Platforms** - AWS, Azure, GCP fundamentals
- **Security Tools** - SIEM, vulnerability scanners, IDS/IPS

### Soft Skills

- Analytical thinking and problem-solving
- Clear communication (technical and non-technical)
- Continuous learning mindset
- Attention to detail
- Collaboration and teamwork

## Common Security Questions

### Is DAST and PenTesting same?

**No.** While both find vulnerabilities, they differ:

| Aspect | DAST | Penetration Testing |
|--------|------|---------------------|
| **Approach** | Automated scanning | Manual + automated |
| **Scope** | Application layer | Full system/network |
| **Depth** | Surface-level findings | Deep exploitation |
| **Frequency** | Continuous in CI/CD | Periodic assessments |

### How SSL/TLS works?

SSL/TLS provides encrypted communication through a handshake:

1. **Client Hello** - Client sends supported cipher suites
2. **Server Hello** - Server selects cipher, sends certificate
3. **Key Exchange** - Asymmetric encryption establishes shared secret
4. **Secure Communication** - Symmetric encryption for data transfer

### What is JWT security?

JWT (JSON Web Token) is used for authentication/authorization. Security considerations:

- **Never store sensitive data** in payload (it's Base64, not encrypted)
- **Use strong signing algorithms** (RS256 over HS256 for distributed systems)
- **Set appropriate expiration** times
- **Validate all claims** including issuer and audience

### What is the difference between SCA and SAST?

| Aspect | SAST | SCA |
|--------|------|-----|
| **Analyzes** | Your source code | Third-party dependencies |
| **Finds** | Coding vulnerabilities | Known CVEs in libraries |
| **When** | During development | Build/deployment time |
| **Example Tools** | SonarQube, Checkmarx | Snyk, Dependabot |

### Is Web Security and Application Security same?

**No.** Application Security is broader:

- **Web Security** - Focuses on web applications (OWASP Top 10 Web)
- **Application Security** - Includes web, mobile, desktop, APIs, and the entire SDLC

### What is Security Champion?

A Security Champion is a developer or engineer who:

- Acts as security liaison within their team
- Promotes secure coding practices
- Helps triage security findings
- Bridges gap between security and development teams

### Vulnerability vs Exploit

| Term | Definition | Example |
|------|------------|---------|
| **Vulnerability** | A weakness in a system | SQL injection flaw |
| **Exploit** | Code/technique that leverages the vulnerability | SQLMap payload |

!!! info "Relationship"
    Not all vulnerabilities have exploits, and not all exploits work in every environment.

## Career Paths in Cybersecurity

```
Entry Level → Mid Level → Senior → Leadership
    │            │           │          │
    ├─ SOC Analyst → Security Engineer → Security Architect
    ├─ Jr. Pentester → Senior Pentester → Red Team Lead
    ├─ Security Analyst → AppSec Engineer → AppSec Manager
    └─ GRC Analyst → Compliance Manager → CISO
```

## Next Steps

- Start with [Common Security Concepts](common-security-concepts.md)
- Explore domain-specific content in [Product Security](product-security/index.md)
- Follow a structured [Study Plan](study-plan/index.md)
