# Identity and Access Management (IAM) Security Study Plan

This page is updated based on [jassics/security-study-plan/iam-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/iam-security-study-plan.md)

This study plan is based on milestones. Check how much you can cover within the timeline - the more you cover, the better a candidate you are for job roles that need strong Identity & Access Management skills (AppSec, Cloud Security, Product Security, GRC, Security Architecture, and more).

Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

It covers what you need to excel at IAM from both **application** and **cloud** perspectives.

**How this connects:** Use this plan alongside the [AWS](../cloud-security/aws-security-study-plan.md), [Azure](../cloud-security/azure-security-study-plan.md), and [GCP](../cloud-security/gcp-security-study-plan.md) security study plans for cloud-specific IAM, and with the [Application Security](application-security-study-plan.md) study plan when designing or reviewing secure systems.

## In Short

1. IAM is not just "creating users and groups" - it is access control for everything.
2. Think of IAM as the **new perimeter** across apps, APIs, cloud, and SaaS.
3. You must be comfortable with AuthN/AuthZ concepts and common protocols.
4. You should understand how IAM is implemented in AWS, Azure, and GCP at a high level.
5. You should recognize common IAM misconfigurations and how to avoid them.

## ToC

1. [IAM Fundamentals](#iam-fundamentals) - 2 weeks
2. [Authentication (AuthN) Deep Dive](#authentication-authn-deep-dive) - 2 weeks
3. [Authorization (AuthZ) & Access Control](#authorization-authz--access-control) - 2 weeks
4. [Cloud Provider IAM (AWS/Azure/GCP)](#cloud-provider-iam-awsazuregcp) - 3-4 weeks
5. [Identity Lifecycle, Privileged Access & Federation](#identity-lifecycle-privileged-access--federation) - 2-3 weeks
6. [Threats, Misconfigurations & Hardening](#threats-misconfigurations--hardening) - 2-3 weeks
7. [Books](#books)
8. [Videos](#videos)
9. [Courses](#courses)
10. [Certifications](#certifications)
11. [Interview Questions](#interview-questions)

## IAM Fundamentals
**Duration: 2 weeks**

### Week 1-2: Core Concepts

1. **What is IAM?** Digital identities, principals, subjects, resources, permissions, policies.
2. **Types of Identities:** human identities (users, groups), machine identities (service accounts, workloads), external identities (partners, customers, B2B/B2C).
3. **Access Models:** Discretionary Access Control (DAC), Mandatory Access Control (MAC), Role-Based Access Control (RBAC), Attribute-Based Access Control (ABAC).
4. **Core Principles:** least privilege, separation of duties, Zero Trust (never trust, always verify), Just-In-Time (JIT) and Just-Enough-Access (JEA).

## Authentication (AuthN) Deep Dive
**Duration: 2 weeks**

### Week 3: Traditional AuthN

1. **Credentials** - passwords, password policies, password managers
2. **Multi-Factor Authentication (MFA)** - SMS, TOTP apps, FIDO keys
3. **Sessions & Cookies** - session IDs, secure flags, timeouts

### Week 4: Modern Protocols

1. **OAuth 2.0** (high level) - roles (resource owner, client, auth server), grant types
2. **OpenID Connect (OIDC)** - ID token, userinfo endpoint, common flows
3. **SAML 2.0 basics** - assertions, IdP vs SP, SSO scenarios
4. **Modern web/mobile auth patterns** - SPA and mobile apps using OAuth/OIDC

## Authorization (AuthZ) & Access Control
**Duration: 2 weeks**

### Week 5-6: AuthZ Models & Implementation

1. **RBAC** - roles, role hierarchies, the role-explosion problem
2. **ABAC** - policies based on user/resource/environment attributes
3. **Policy Languages & Engines** (high level) - XACML, OPA/Rego, custom JSON/YAML policies
4. **Application-Level Authorization** - route/method-level access control, object-level (BOLA) and function-level (BFLA) authorization, mapping business roles to technical permissions - see [API Security](../../product-security/application-security/api-security.md) for BOLA in depth

## Cloud Provider IAM (AWS/Azure/GCP)
**Duration: 3-4 weeks**

### Week 7-8: AWS IAM Basics

1. **Core Concepts** - principals, policies, actions, resources, conditions
2. **Identity Types** - IAM users, groups, roles, root account
3. **Policies** - identity-based vs resource-based policies, SCPs (Organizations)
4. **Common Services** - IAM, AWS SSO/IAM Identity Center, STS, KMS
5. **Hands-on** - create roles, attach policies, test access

### Week 9: Azure & GCP IAM Overview

1. **Azure** - Entra ID (formerly Azure AD), roles, role assignments, scopes (MG → Sub → RG → Resource)
2. **GCP** - IAM policies, members, roles, service accounts, resource hierarchy
3. **Compare Patterns** - how roles/scopes differ across AWS/Azure/GCP, and common misconfigurations (overly broad roles, wildcard permissions)

## Identity Lifecycle, Privileged Access & Federation
**Duration: 2-3 weeks**

### Week 10-11: Identity Lifecycle & PAM

1. **Lifecycle** - joiner/mover/leaver processes
2. **Provisioning & Deprovisioning** - HR systems, directories, SCIM basics
3. **Privileged Access Management (PAM)** - break-glass accounts, session recording/approvals, JIT privileged access

### Week 12: Federation & B2B/B2C

1. **Federation Concepts** - trusting external IdPs, SSO across organizations
2. **Common Scenarios** - SAML/OIDC from a corporate IdP to SaaS/cloud
3. **Security Considerations** - trust boundaries, token lifetimes, revocation

## Threats, Misconfigurations & Hardening
**Duration: 2-3 weeks**

### Week 13-15: Attacks & Defenses

1. **Common IAM Attacks** - credential stuffing, password spraying, MFA fatigue/bypass, OAuth misconfig (open redirect, overbroad scopes), IDOR/BOLA/BFLA from missing authz checks, privilege escalation via misconfigured roles/policies
2. **Cloud IAM Pitfalls** - `*:*` permissions, public buckets, overly broad service roles, long-lived access keys
3. **Hardening Practices** - enforce MFA for admins/remote access, regular access reviews and certification, least-privilege role design and periodic cleanup, conditional/risk-based access where available

## Books

1. A solid book on Identity & Access Management in enterprise or cloud contexts
2. Books on OAuth 2.0 / OpenID Connect and modern authentication patterns
3. Cloud security books with strong IAM chapters (AWS/Azure/GCP)

## Videos

1. Conference talks on IAM, SSO, OAuth/OIDC pitfalls, and cloud IAM misconfigurations
2. Cloud provider official IAM deep-dive videos (AWS re:Invent, Azure, GCP)
3. Talks on Zero Trust and modern identity-centric security

## Courses

1. Cloud security fundamentals courses with strong IAM modules
2. Vendor-specific identity courses (AWS, Azure, GCP IAM)
3. Courses focused on OAuth 2.0 / OIDC and modern auth patterns

## Certifications

1. Cloud security certifications (AWS/Azure/GCP) where IAM is a major exam component
2. Identity-focused or access management certifications, if aligned with your goals
3. General security certs (CISSP, CCSP, etc.) for broader IAM context

## Interview Questions

Reuse questions from [Application Security](../../interview-questions/application-security-interview-questions.md), [AWS Security](../../interview-questions/aws-security-interview-questions.md), and [Common Security](../../interview-questions/common-security-interview-questions.md), but focus on Identity & Access:

1. How would you design authentication and authorization for a new web/mobile app?
2. How would you migrate on-prem identities to a cloud IdP safely?
3. How do you enforce least privilege across many AWS accounts or Azure subscriptions?
4. How would you investigate and respond to a suspected IAM credential compromise?

**Practice next:** [AWS Security interview questions](../../interview-questions/aws-security-interview-questions.md) for hands-on IAM scenarios, and [jassics/security-study-plan](https://github.com/jassics/security-study-plan) for the latest updates to this plan.
