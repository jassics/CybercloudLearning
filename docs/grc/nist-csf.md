# NIST Cybersecurity Framework (CSF) 2.0

## Overview

The NIST Cybersecurity Framework provides a policy framework of computer security guidance for organizations to assess and improve their ability to govern, prevent, detect, and respond to cyber attacks.

!!! info "This page covers CSF 2.0"
    NIST released **CSF 2.0 in February 2024**, which added a sixth core function - **Govern** - and broadened the framework's scope beyond critical infrastructure to organizations of any size or sector. If you encounter older material describing "five core functions," it's referring to the superseded CSF 1.1 - make sure you can speak to Govern and CSF 2.0 in an interview, since it's now the current version.

## Framework Core

CSF 2.0 is organized around six core functions - Govern sits at the center, informing how the other five are carried out:

| Function | Purpose | Key Activities |
|----------|---------|-----------------|
| **Govern (GV)** | Establish and monitor the organization's risk management strategy, expectations, and policy | Organizational context, risk strategy, roles/responsibilities, policy, oversight, supply chain risk management |
| **Identify (ID)** | Understand cybersecurity risk to systems, assets, data, and capabilities | Asset management, risk assessment, improvement planning |
| **Protect (PR)** | Implement safeguards to manage risk | Identity/access management, awareness training, data security, platform security, resilience |
| **Detect (DE)** | Find and analyze possible cybersecurity attacks and compromises | Continuous monitoring, adverse event analysis |
| **Respond (RS)** | Take action on a detected incident | Incident management, analysis, communication, mitigation |
| **Recover (RC)** | Restore assets and operations affected by an incident | Recovery plan execution, recovery communication |

## Framework Components

### 1. Framework Core - Categories

**Govern (GV)** - new in 2.0, and where a lot of interview questions now focus:

- Organizational Context (GV.OC)
- Risk Management Strategy (GV.RM)
- Roles, Responsibilities, and Authorities (GV.RR)
- Policy (GV.PO)
- Oversight (GV.OV)
- Cybersecurity Supply Chain Risk Management (GV.SC)

**Identify (ID)** - narrower in 2.0 since Governance and Business Environment moved into GV:

- Asset Management (ID.AM)
- Risk Assessment (ID.RA)
- Improvement (ID.IM)

**Protect (PR)**:

- Identity Management, Authentication, and Access Control (PR.AA)
- Awareness and Training (PR.AT)
- Data Security (PR.DS)
- Platform Security (PR.PS)
- Technology Infrastructure Resilience (PR.IR)

**Detect (DE)**:

- Continuous Monitoring (DE.CM)
- Adverse Event Analysis (DE.AE)

**Respond (RS)**:

- Incident Management (RS.MA)
- Incident Analysis (RS.AN)
- Incident Response Reporting and Communication (RS.CO)
- Incident Mitigation (RS.MI)

**Recover (RC)**:

- Incident Recovery Plan Execution (RC.RP)
- Incident Recovery Communication (RC.CO)

### 2. Implementation Tiers

Tiers describe the degree of rigor in cybersecurity risk governance and management practices (unchanged in structure from 1.1, but now explicitly cover governance too):

| Tier | Name | Description |
|------|------|-------------|
| 1 | Partial | Ad hoc, reactive, limited awareness of risk at the organizational level |
| 2 | Risk Informed | Risk-aware practices approved by management but not established as organization-wide policy |
| 3 | Repeatable | Formal policies, consistently applied and regularly updated |
| 4 | Adaptive | Continuous improvement, risk-informed and predictive, adapts to a changing threat landscape |

### 3. Framework Profiles

Profiles align cybersecurity activities with business requirements - CSF 2.0 also introduces **Community Profiles** (shared, sector-specific profiles published by NIST or industry groups) alongside organization-specific ones:

- **Current Profile** - Where you are now
- **Target Profile** - Where you want to be
- **Community Profile** - A shared baseline profile for a sector or use case (e.g. a small business profile), which you can adapt into your own Current/Target profiles
- **Gap Analysis** - Difference between current and target

## Using NIST CSF

### Step 1: Scope and Prioritize

- Identify business objectives and organizational context (this now overlaps directly with the Govern function)
- Determine systems and assets in scope
- Establish risk tolerance

### Step 2: Create Current Profile

- Assess current cybersecurity practices across all six functions
- Map to Framework categories/subcategories
- Document gaps, including gaps in governance (a common blind spot before 2.0 made Govern explicit)

### Step 3: Conduct Risk Assessment

- Analyze threats and vulnerabilities
- Determine likelihood and impact
- Prioritize risks

### Step 4: Create Target Profile

- Define desired cybersecurity outcomes
- Consider business drivers and supply chain risk
- Set improvement goals

### Step 5: Determine and Prioritize Gaps

- Compare current and target profiles
- Prioritize gaps by risk and business impact
- Plan remediation

### Step 6: Implement Action Plan

- Execute improvement initiatives
- Monitor progress against the target profile
- Update profiles as the organization and threat landscape change

## Why Govern Was Added

Under CSF 1.1, governance-adjacent activities were scattered - partly under Identify (ID.GV, ID.BE), partly assumed as a prerequisite nobody described directly. In practice, organizations kept treating cybersecurity as a purely technical/operational problem, disconnected from executive risk decisions and supply chain oversight. CSF 2.0 makes governance an explicit, first-class function to force the connection between board-level risk strategy and the technical functions (Identify/Protect/Detect/Respond/Recover) that implement it - a direct response to how many real breaches trace back to a governance gap (nobody owned the risk, no policy existed, supply chain risk was never assessed) rather than a purely technical failure.

## Benefits

- **Flexible** - Adaptable to any organization, any size, any sector (2.0 explicitly broadened this from the original critical-infrastructure focus)
- **Risk-based** - Focuses on actual risk, not a compliance checklist
- **Voluntary** - No mandatory requirements (though often referenced by regulators and contracts)
- **Common language** - Shared terminology across governance, technical, and business stakeholders
- **Widely adopted** - De facto industry standard, and a common thread across the [ISO 27001](iso27k1.md) and [NIST RMF](nist-rmf.md) frameworks

## Credits/References

1. [NIST CSF 2.0 Official Site](https://www.nist.gov/cyberframework)
2. [NIST Releases Version 2.0 of Landmark Cybersecurity Framework](https://www.nist.gov/news-events/news/2024/02/nist-releases-version-20-landmark-cybersecurity-framework)
3. [NIST CSF 2.0 Reference Tool](https://csrc.nist.gov/Projects/cybersecurity-framework)
4. NIST SP 800-53 (Detailed Controls)
5. NIST SP 800-171 (CUI Protection)
