# Blue Team, Detection & Response Study Plan

This study plan is based on milestones, sourced from [jassics/security-study-plan/blue-team-detection-response-study-plan](https://github.com/jassics/security-study-plan/blob/main/blue-team-detection-response-study-plan.md). The more topics you cover, the better candidate you are for Blue Team, SOC, Detection Engineering, and Incident Response roles.

Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

It covers what you need to **monitor, detect, and respond** to attacks across endpoints, networks, applications, and cloud.

**How this connects:** Start with [Common Skills](../common-skills-study-plan.md) and [Network Security](../cybersecurity/network-security-study-plan.md), then pair this plan with the cloud study plans ([AWS](../cloud-security/aws-security-study-plan.md), [Azure](../cloud-security/azure-security-study-plan.md), [GCP](../cloud-security/gcp-security-study-plan.md)) and [Web Security Testing](../cybersecurity/web-security-testing-study-plan.md) / [Application Security](../cybersecurity/application-security-study-plan.md) so you can detect the attacks you already know how to perform. Combine it with [Threat Modeling](https://github.com/jassics/security-study-plan/blob/main/threat-modeling-study-plan.md) to turn identified threats into concrete detections and playbooks.

## In Short

1. Blue Team is not just "watching a SIEM" - it's about **detecting and responding to real attacks**.
2. You must understand how logs, telemetry, and alerts are generated and correlated.
3. Know the incident response lifecycle and how to build playbooks.
4. Be comfortable mapping activity to frameworks like MITRE ATT&CK.
5. Understand the basics of cloud, endpoint, and network telemetry.

## ToC

1. [Blue Team & SOC Fundamentals](#blue-team--soc-fundamentals) - 2 weeks
2. [Logging, Telemetry & SIEM](#logging-telemetry--siem) - 2-3 weeks
3. [Detection Engineering & Threat Hunting](#detection-engineering--threat-hunting) - 3-4 weeks
4. [Incident Response (IR) Fundamentals](#incident-response-ir-fundamentals) - 3-4 weeks
5. [Digital Forensics Basics](#digital-forensics-basics) - 2-3 weeks
6. [Cloud & Modern Environments](#cloud--modern-environments) - 2-3 weeks
7. [Books, Videos, Courses, Certifications](#books-videos-courses-certifications)
8. [Interview Questions](#interview-questions)

---

## Blue Team & SOC Fundamentals
**Duration: 2 weeks**

Goal: understand what the Blue Team does and how SOCs operate.

### Week 1-2: Core Concepts
1. **Roles & Functions** - Tier 1-3 analysts, incident handlers, detection engineers, IR lead
2. **SOC Operating Models** - in-house, MSSP, hybrid
3. **Core Activities** - triage, investigation, containment, eradication, recovery, reporting
4. **Frameworks** - NIST CSF (Identify-Protect-Detect-Respond-Recover), basic exposure to MITRE ATT&CK

---

## Logging, Telemetry & SIEM
**Duration: 2-3 weeks**

Goal: understand what to log, how, and where it lands.

### Week 3-5: Data & Platforms
1. **Log Types** - OS logs (Windows Event Logs, Linux syslog), network logs (firewall, proxies, IDS/IPS), application/API logs, cloud logs (CloudTrail, Azure Activity, GCP Audit)
2. **Log Quality** - timestamps, normalization, context, correlation IDs
3. **SIEM Concepts** - ingestion, parsing, normalization, correlation, dashboards, alerts
4. **Hands-on** - use a lab with ELK, Splunk, or any SIEM-like tool to ingest and search logs

---

## Detection Engineering & Threat Hunting
**Duration: 3-4 weeks**

Goal: learn how to create high-quality detections and proactively hunt.

### Week 6-9: Detections & Hunts
1. **Detection Engineering Basics** - use cases, hypotheses, detection rules, balancing false positives/negatives
2. **MITRE ATT&CK Mapping** - tactics vs techniques, mapping detections to techniques
3. **Query Languages** - SIEM query basics (KQL-like or SPL-like)
4. **Threat Hunting** - hypothesis-driven hunts, baselines/anomaly detection, documented hunting notebooks

---

## Incident Response (IR) Fundamentals
**Duration: 3-4 weeks**

Goal: understand how to handle incidents end-to-end.

### Week 10-13: IR Lifecycle
1. **IR Phases** - Preparation, Detection & Analysis, Containment, Eradication, Recovery, Lessons Learned
2. **Playbooks & Runbooks** - phishing incident, ransomware/malware outbreak, cloud credential compromise
3. **Communication** - internal stakeholders, leadership, legal, PR; when to involve regulators/law enforcement
4. **Tabletop Exercises** - running simulated incidents to test readiness

---

## Digital Forensics Basics
**Duration: 2-3 weeks**

Goal: learn fundamentals of collecting and analyzing evidence safely.

### Week 14-16: Forensics Overview
1. **Evidence Handling** - chain of custody, integrity, imaging vs live response
2. **Endpoint Forensics** - Windows (registry artifacts, event logs), Linux (logs, processes, file timelines)
3. **Memory & Disk Analysis** (high level) - what's possible and when it's needed
4. **Cloud Forensics Basics** - using cloud logs and snapshots to reconstruct events

---

## Cloud & Modern Environments
**Duration: 2-3 weeks**

Goal: understand detection & response in cloud, SaaS, and modern stacks.

### Week 17-19: Modern Blue Teaming
1. **Cloud Telemetry** - AWS, Azure, GCP basic security logs and where they're configured
2. **Containers & Kubernetes** - high-level understanding of pod/node logs and common attack traces
3. **SaaS & IdP Logs** - identity provider logs (SSO, MFA), email security logs, EDR logs
4. **Integration** - sending these logs into SIEM/XDR and writing detections around them

---

## Books, Videos, Courses, Certifications

- Strong Blue Team/SOC operations books; books on incident response and digital forensics; case studies of real intrusions
- Conference talks on detection engineering, Blue Teaming, SOC operations, and DFIR case studies
- Blue Team/SOC analyst fundamentals courses; IR/DFIR-focused training with hands-on labs; threat hunting courses using common SIEM/XDR tools
- Entry-level SOC/Blue Team certs; IR/DFIR-oriented certifications if you want to specialize; Security+ for foundational knowledge

## Interview Questions

Reuse questions from Network Security, Cloud Security, and GRC, but focus on detection & response:

1. How would you design logging for a new web application or API?
2. How do you triage an alert that might be a false positive?
3. How would you investigate a suspected account compromise in a cloud environment?
4. How do you measure the effectiveness of your detections and IR process?

More SOC-focused questions live in the [security-interview-questions](https://github.com/jassics/security-interview-questions/blob/main/soc-interview-questions.md) repo.
