# Common Security Concepts

Understanding fundamental security concepts is essential for anyone starting their cybersecurity journey. This page covers the core principles and terminology you'll encounter throughout your learning.

## CIA Triad

The CIA Triad is the foundation of information security:

- **Confidentiality** - Ensuring data is accessible only to authorized individuals
- **Integrity** - Maintaining accuracy and trustworthiness of data
- **Availability** - Ensuring systems and data are accessible when needed

## Authentication vs Authorization

| Concept | Description | Example |
|---------|-------------|---------|
| **Authentication** | Verifying identity (Who are you?) | Username/password login |
| **Authorization** | Verifying permissions (What can you do?) | Role-based access control |

## Defense in Depth

A layered security approach where multiple security controls protect assets:

1. **Physical Security** - Locks, badges, cameras
2. **Network Security** - Firewalls, IDS/IPS, segmentation
3. **Host Security** - Antivirus, EDR, patching
4. **Application Security** - Input validation, secure coding
5. **Data Security** - Encryption, DLP, access controls

## Principle of Least Privilege

Users and systems should only have the minimum permissions necessary to perform their tasks.

!!! tip "Best Practice"
    Always start with zero permissions and grant only what's explicitly required.

## Common Security Terminology

| Term | Definition |
|------|------------|
| **Vulnerability** | A weakness that can be exploited |
| **Threat** | A potential danger to assets |
| **Risk** | Likelihood × Impact of a threat exploiting a vulnerability |
| **Exploit** | Code or technique that takes advantage of a vulnerability |
| **Attack Vector** | The path an attacker uses to gain access |
| **Attack Surface** | Total sum of vulnerabilities in a system |

## Types of Security Controls

### By Function
- **Preventive** - Stop attacks before they happen (firewall rules)
- **Detective** - Identify attacks in progress (SIEM alerts)
- **Corrective** - Fix issues after an attack (patch management)
- **Deterrent** - Discourage attackers (warning banners)

### By Implementation
- **Technical** - Software/hardware controls (encryption)
- **Administrative** - Policies and procedures (security training)
- **Physical** - Physical barriers (security guards)

## Zero Trust Model

"Never trust, always verify" - A security model that:

- Verifies every user and device
- Limits access with least privilege
- Assumes breach and minimizes blast radius

## Common Attack Types

| Attack | Description |
|--------|-------------|
| **Phishing** | Social engineering via fraudulent emails |
| **SQL Injection** | Inserting malicious SQL into queries |
| **XSS** | Injecting scripts into web pages |
| **DDoS** | Overwhelming systems with traffic |
| **Man-in-the-Middle** | Intercepting communications |
| **Brute Force** | Systematically trying all passwords |

## Next Steps

- Explore [Product Security](product-security/index.md) for domain-specific knowledge
- Check out [Study Plans](study-plan/index.md) to structure your learning
- Review [Cybersecurity Overview](cybersecurity-overview.md) for career guidance
