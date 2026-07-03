# API Security Study Plan

This page is updated based on [jassics/security-study-plan/api-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/api-security-study-plan.md)

This study plan is based on milestones. So, check how much you can cover within the timeline. The more you cover the topics, the better candidate you are for the varied job roles which require good knowledge of API security.
Also, I assume you have already checked and comfortable with [Common Security Skills study plan](../common-skills-study-plan.md).

It will cover what you need to learn to excel in API security (part of the [Application Security](application-security-study-plan.md) domain). Please keep in mind that it would require knowledge of:

1. How websites work
2. How API endpoints are defined and their request and response
3. Basics of coding to write your own APIs for testing
4. [OWASP Top 10 for Web](../../product-security/web-security/owasp-top10.md)
5. [OWASP Top 10 for API 2023](https://owasp.org/API-Security/editions/2023/en/0x11-t10/) (latest version) - see the site's own [API Security guide](../../product-security/application-security/api-security.md) for a working summary

**Note:** Usually it will take you 3-6 months to be good at the API Security fundamentals to get a job at entry level.

## ToC

1. [API Fundamentals](#api-fundamentals) - 2 weeks
2. [API Security Understandings](#api-security-understandings) - 2 weeks
3. [API Security Labs and Practices](#api-security-labs-and-practices) - 2 weeks
4. [API Security Tools](#api-security-tools)
5. [Books](#books)
6. [Videos](#videos)
7. [Courses](#courses)
8. [Certifications](#certifications)
9. [Interview Questions](#interview-questions)

## API Fundamentals
**Duration: 2 weeks**

### Week 1: Basics of API & Endpoints

#### API Endpoints
Imagine you're ordering food from a delivery app. You select items and click "Place Order." Behind the scenes, the app calls a specific API endpoint designated for order submission with your items, address, and instructions. A different endpoint handles order tracking. Endpoints are the specific doors that let systems exchange information for a particular purpose or action.

#### Types of Microservices
Microservices break an application into small, loosely-coupled, independently deployable services, each owning a business capability. Common types you'll encounter:

1. **User Service** - registration, authentication, profile management
2. **Product Service** - catalog, inventory, pricing, search
3. **Order Service** - order lifecycle, payments, invoices
4. **Payment Service** - payment gateway integration, secure transaction processing
5. **Notification Service** - email/SMS/push notifications
6. **Analytics Service** - usage metrics and monitoring
7. **Integration Service** - adapters/connectors to external APIs and legacy systems
8. **Image/Video Processing Service** - resizing, thumbnails, encoding

### Week 2: Microservices & Cloud-Native APIs

#### Microservices from an API Security Perspective

1. **Authentication Service** - verifies identity (username/password, tokens, MFA)
2. **Authorization Service** - enforces access control policies
3. **API Gateway** - entry point for external requests; enforces rate limiting, auth, encryption
4. **Logging and Monitoring Service** - detects anomalies and security events
5. **Encryption Service** - protects data at rest and in transit
6. **Threat Intelligence Service** - compares traffic against known threat patterns

#### Cloud-Native API Styles

1. **RESTful API** - stateless, standard HTTP verbs, most common
2. **Event-Driven APIs** - asynchronous, message queues/event brokers
3. **GraphQL API** - flexible querying, single entry point across services
4. **Serverless APIs** - AWS Lambda/Azure Functions, scale automatically
5. **OpenAPI (Swagger)** - machine-readable API contract, docs and mocks

## API Security Understandings
**Duration: 2 weeks**

### Week 3: Core Security Concepts

#### API Security is Not Web Security
They're related but distinct:

| Aspect | Web App Security | API Security |
|--------|-------------------|---------------|
| Focus | UI, server, database | The API and the data it transmits |
| Common attacks | SQLi, XSS, CSRF, file inclusion | Spoofing, parameter manipulation, MitM |
| AuthN/AuthZ | Username/password, sessions | OAuth, API keys, JWTs |
| Interaction model | User-facing UI | Back-end system-to-system |

#### Why API Security Matters
1. **Data Protection** - APIs often carry sensitive data (credentials, PII, financial data)
2. **Authorization & Access Control** - restrict actions to authenticated/authorized callers
3. **Trust and Reputation** - breaches damage customer trust
4. **Compliance** - GDPR, HIPAA and similar regulations apply to API-transmitted data too
5. **Attack Prevention** - injection, XSS, CSRF, DoS all have API equivalents
6. **Secure Integration** - APIs are the seam between systems, orgs, and third parties
7. **Monitoring & Auditing** - visibility into who called what and when

### Week 4: Advanced Concepts (AuthN, AuthZ, Rate Limiting)

#### AuthN vs AuthZ
- **Authentication (AuthN)** - proves identity: username/password, token-based auth, MFA (SMS, TOTP, FIDO keys).
- **Authorization (AuthZ)** - decides what an authenticated identity can do: RBAC (roles), ABAC (attributes), scope-based access (OAuth scopes), and fine-grained per-resource permissions.

#### Rate Limiting
Caps how often an action can repeat in a window - stops brute force and DoS, and keeps usage fair.

- **Token Bucket** - tokens refill at a fixed rate; each request consumes one.
- **Leaky Bucket** - processes requests at a fixed rate, smoothing bursts.
- **Fixed Window** - counts per window; can be gamed at window edges.
- **Sliding Window** - smooths out the fixed-window edge case.
- Communicate limits via `X-RateLimit-Limit`/`X-RateLimit-Remaining`/`X-RateLimit-Reset` headers and return `429 Too Many Requests` when exceeded.

#### API Gateway
Sits between clients and backend services as a reverse proxy. Key security functions: centralized AuthN/AuthZ (verifies JWTs, passes user context downstream), rate limiting/throttling, input validation, IP allow/deny lists, TLS termination, and centralized logging.

Popular gateways: Kong, Apigee, AWS API Gateway, Azure API Management, Tyk.

## API Security Labs and Practices
**Duration: 2 weeks**

1. [OWASP crAPI](https://github.com/OWASP/crAPI) - "Completely Ridiculous API," a mock microservices app implementing nearly every API security anti-pattern (Identity, Web, Community, Mailhog, Workshop, Postgres, Mongo services).
2. [vAPI](https://github.com/roottusk/vapi) - PHP-based, mimics OWASP API Top 10 scenarios through exercises.
3. [VAmPI](https://github.com/erev0s/VAmPI) - Vulnerable API built with Python/Flask.

## API Security Tools

1. [Dastardly (Burp Suite, free)](https://portswigger.net/burp/documentation/dastardly/generic) - for CI/CD pipeline scanning
2. [42Crunch API Security Audit](https://bitbucket.org/product/features/pipelines/integrations?p=42crunch/api-security-audit)
3. [Wallarm](https://www.wallarm.com/product/advanced-api-security)
4. [Google Apigee Sense](https://cloud.google.com/apigee/sense)
5. [Traceable](https://www.traceable.ai/)
6. [Levo](https://levo.ai/)
7. [Beagle Security](https://beaglesecurity.com/)
8. [Salt Security](https://salt.security/)
9. [Cequence](https://www.cequence.ai/)
10. [Neosec (now part of Akamai)](https://www.neosec.com/)

## Books

1. [API Security in Action](https://www.manning.com/books/api-security-in-action)
2. [Hacking APIs: Breaking Web Application Programming Interfaces](https://nostarch.com/hacking-apis)
3. [Web Application Security](https://www.oreilly.com/library/view/web-application-security/9781492053101/)
4. [Advanced API Security](https://www.amazon.in/Advanced-API-Security-Definitive-Guide/dp/1484220498)

## Videos

1. [API Security: Everything you need to know to protect your APIs](https://www.youtube.com/watch?v=SrOxtGXg4DA)
2. [The 2022 Guide to API Security](https://www.youtube.com/watch?v=6TojWjr4oOQ)
3. [Analysing the OWASP API Security Top 10 for Pen Testers](https://www.youtube.com/watch?v=5UTHUZ3NGfw)

## Courses

1. [API Security Fundamentals - APISec University (free)](https://www.apisecuniversity.com/courses/api-security-fundamentals)
2. [API Penetration Testing Course - APISec University (free)](https://university.apisec.ai/apisec-certified-expert)
3. [API Security on Google Cloud's Apigee API Platform](https://www.coursera.org/learn/api-security-apigee-gcp)
4. [API Fundamentals - Qualys (free)](https://www.qualys.com/training/course/qualys-api-fundamentals/)
5. [Introduction to the OWASP API Security Top 10 - Cybrary (free)](https://www.cybrary.it/course/securing-apis-fundamentals)

## Certifications

1. [CSSLP](https://www.isc2.org/Certifications/CSSLP)
2. [API Security Architect Certification](https://apiacademy.co/2020/07/api-security-architect-certification/)
3. [Certified API Security Professional](https://www.practical-devsecops.com/certified-api-security-professional/)

## Interview Questions

Practice with [API Security interview questions](../../interview-questions/api-security-interview-questions.md), also kept up to date on GitHub alongside the rest of the [career roadmap guide](https://github.com/jassics/cybersecurity-roadmap).
