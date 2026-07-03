# GCP Security Study Plan

This page is updated based on [jassics/security-study-plan/gcp-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/gcp-security-study-plan.md)

I am making this study plan irrespective of job role under the GCP Security category. It can be Cloud Security Analyst, Cloud Security Researcher, Cloud Security Engineer, Cloud Security Operations Expert, Cloud Security Manager, or Cloud Governance.

So, check how much you can cover and learn practically. The more you are good at these concepts, the better candidate you are for the job role. Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

## GCP Security Skills Learning and Checklist
My only suggestion here is to ask below 4 questions while learning each topic/concept:

1. What is this? (For example: What is an instance group, where is it used, and why?)
2. Why am I learning this specific service or concept now? Will it help me for my job role and in future?
3. How can I implement this? (Practical/hands-on knowledge always has an extra edge.)
4. How will this make things secure, or how do I make it secure, depending on the topic or concept?

### GCP Fundamentals
**Duration: 2-3 weeks**

I am listing only the topic names with a few pointers. How much you learn and how comfortable you get with each concept is up to you - feel free to go deeper for better candidacy and experience.

#### Week 1: IAM Deep Dive
A very important topic for any cloud role. Try to understand it practically, as much as your job demands.

1. [Start with the GCP IAM official docs](https://cloud.google.com/iam/docs/overview)
2. [Understand IAM roles and permissions](https://cloud.google.com/iam/docs/roles-overview) - the second most important thing to excel at IAM
3. User, Group, Roles - understand when to use which, and don't forget to ask why this, why not that
4. Custom role vs Google-managed role
5. Cross-account IAM policy across different roles, services, accounts
6. Understand the IAM policy from a security mindset - why this, why not this?
7. [Using IAM Securely](https://cloud.google.com/iam/docs/using-iam-securely)

#### Week 2-3: Core Services
**For any GCP service, follow this strategy:**

1. What does this service do?
2. What business problem does it solve?
3. Security best practices for that service (e.g. GCS security best practices, VPC security best practices)
4. What permissions should each role/principal/service account have to maintain least privilege?
5. How is it typically misused or misconfigured?
6. Is multi-tier/multi-region required for this service?
7. How can you achieve encryption at rest and in transit?
8. Is logging required? If so, what data, and for how long?
9. Are we monitoring it - and why or why not?
10. Any service-specific security settings (e.g. bucket permissions for a specific GCS bucket)?

**Key services to cover:**

1. GCS (Google Cloud Storage)
2. GKE
3. VPC (Virtual Private Cloud)
4. Firewall rules and policies
5. Load Balancer
6. Cloud DNS
7. Cloud CDN
8. Google Cloud Armor
9. Google Cloud Logging
10. BigQuery
11. API Gateway
12. Certificate Manager
13. Secret Manager
14. Cloud Run
15. Cloud Functions

## GCP Native Security Skills
**Duration: 4-6 weeks**

What I mean here is:

1. GCP core services related to security
2. GCP security services hands-on knowledge

### Week 4-6: Core Services Security
**These are the core services:**

1. IAM - super important
2. Compute Instances
3. GCS (Storage Object)
4. VPC - I feel it's the toughest one so far, apart from GKE
5. Cloud SQL (RDS equivalent)
6. Bigtable (NoSQL)
7. API Gateway
8. GKE
9. Cloud Run
10. Cloud Functions
11. Cloud Composer
12. BigQuery
13. Datastore
14. Dataproc
15. Secret Manager
16. Cloud Key Management

### Week 7-9: Security Services Hands-On
**GCP core security services you should know and try hands-on as much as possible:**

1. IAM Policy Analyzer
2. IAM Organization Policies

## GCP Security Whitepapers
**Duration: 2 weeks**

GCP has an excellent set of whitepapers on GCP Security - a few important ones are listed here.

### Week 10-11: Reading & Analysis
1. [GCP Overview](https://cloud.google.com/docs/overview) - an important starting point to understand GCP
2. [Introduction to GCP Security Whitepaper](https://cloud.google.com/static/docs/security/overview/resources/google_security_wp.pdf)
3. [Google Cloud Security Foundation Guide](https://services.google.com/fh/files/misc/google-cloud-security-foundations-guide.pdf)
4. [GCP Well-Architected Security Pillar](https://cloud.google.com/architecture/framework/security)
5. [Risk Governance of Digital Transformation](https://services.google.com/fh/files/misc/risk-governance-of-digital-transformation.pdf)
6. [GCP Security Checklist](https://medium.com/@hassene/google-cloud-platform-security-checklist-5f57fe8eb761)
7. [Google Infrastructure Security Design Overview](https://cloud.google.com/static/docs/security/infrastructure/design/resources/google_infrastructure_whitepaper_fa.pdf)
8. [NIST Cybersecurity Framework in the GCP cloud](https://services.google.com/fh/files/misc/gcp_nist_cybersecurity_framework.pdf)
9. [NIST 800-144 Security and Privacy in Public Cloud Computing](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-144.pdf)

## Check Your GCP Pentesting Skills
**Duration: 2-3 weeks**

### Week 12-14: Practical Labs
1. [GCPGoat](https://github.com/ine-labs/GCPGoat) - a damn vulnerable GCP infrastructure
2. Try out the scenarios in [Cloud Goat](https://github.com/RhinoSecurityLabs/cloudgoat)
3. [GCP Pentest Lab](https://github.com/lacioffi/GCP-pentest-lab/)
4. [GCP Pentesting on HackTricks](https://cloud.hacktricks.xyz/pentesting-cloud/gcp-security)

## Check Your Knowledge Against Common Security Benchmarks and Frameworks
1. [CIS Benchmark for Google Cloud](https://www.cisecurity.org/benchmark/google_cloud_computing_platform)
2. [CSA Cloud Matrix and STAR Framework](https://cloudsecurityalliance.org/download/artifacts/cloud-controls-matrix-v4/)
3. [NIST CSF for GCP](https://services.google.com/fh/files/misc/gcp_nist_cybersecurity_framework.pdf)
4. [ISO 27017](https://www.amnafzar.net/files/1/ISO%2027000/ISO%20IEC%2027017-2015.pdf)

## GCP Security Videos and Courses
1. [GCP Cloud Security Features](https://www.youtube.com/watch?v=83IwaIaBRRU)
2. [GCP Full Course from Intellipaat](https://www.youtube.com/watch?v=cwpbY4wJMBs)
3. [Google Cloud Security Fundamentals - Level 1](https://www.youtube.com/watch?v=9Bx_cqpJDpI)
4. [Managing Security in Google Cloud](https://www.cloudskillsboost.google/course_templates/21)

## GCP Security Interview Questions
There's a [separate repo for GCP Security interview questions](https://github.com/jassics/security-interview-questions/blob/main/gcp-security-interview-questions.md), kept up to date over time. Star it or [fork it](https://github.com/jassics/security-interview-questions/fork).

**Practice next:** this site's own [GCP Security Overview](../../product-security/cloud-security/learning-gcp-security/gcp-security-overview.md), and the [security-study-plan](https://github.com/jassics/security-study-plan) repo for the latest updates to this plan.
