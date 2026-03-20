# NIST Risk Management Framework (RMF)

## Overview

The NIST Risk Management Framework provides a structured process for integrating security, privacy, and cyber supply chain risk management into the system development lifecycle.

## RMF Steps

The RMF consists of seven steps:

| Step | Name | Purpose |
|------|------|---------|
| 0 | Prepare | Establish context and priorities |
| 1 | Categorize | Determine system impact level |
| 2 | Select | Choose appropriate controls |
| 3 | Implement | Put controls in place |
| 4 | Assess | Evaluate control effectiveness |
| 5 | Authorize | Accept risk and authorize operation |
| 6 | Monitor | Ongoing assessment and updates |

## Step Details

### Step 0: Prepare

Preparation activities at organization and system levels:

**Organization Level:**

- Define risk management roles
- Establish risk management strategy
- Conduct organization-wide risk assessment
- Develop common controls

**System Level:**

- Identify stakeholders
- Identify assets
- Conduct system risk assessment
- Define security requirements

### Step 1: Categorize

Determine the security impact level using FIPS 199:

| Impact Level | Confidentiality | Integrity | Availability |
|--------------|-----------------|-----------|--------------|
| **Low** | Limited adverse effect | Limited adverse effect | Limited adverse effect |
| **Moderate** | Serious adverse effect | Serious adverse effect | Serious adverse effect |
| **High** | Severe/catastrophic effect | Severe/catastrophic effect | Severe/catastrophic effect |

### Step 2: Select

Choose security controls from NIST SP 800-53:

- **Baseline Controls** - Starting point based on impact level
- **Tailoring** - Adjust controls for specific needs
- **Overlays** - Additional controls for specific environments

### Step 3: Implement

Put controls into operation:

- Deploy technical controls
- Establish operational procedures
- Document implementation details
- Configure systems securely

### Step 4: Assess

Evaluate control effectiveness:

- Develop assessment plan
- Execute assessment procedures
- Document findings
- Recommend remediation

### Step 5: Authorize

Risk-based decision to operate:

- Review assessment results
- Determine residual risk
- Accept or reject risk
- Issue Authorization to Operate (ATO)

### Step 6: Monitor

Continuous monitoring activities:

- Track control changes
- Assess control effectiveness
- Report security status
- Update authorization as needed

## Key Documents

| Document | Purpose |
|----------|---------|
| **System Security Plan (SSP)** | Describes system and controls |
| **Security Assessment Report (SAR)** | Documents assessment findings |
| **Plan of Action & Milestones (POA&M)** | Tracks remediation activities |
| **Authorization Package** | Complete documentation for ATO |

## NIST SP 800-53 Control Families

| ID | Family |
|----|--------|
| AC | Access Control |
| AT | Awareness and Training |
| AU | Audit and Accountability |
| CA | Assessment, Authorization, and Monitoring |
| CM | Configuration Management |
| CP | Contingency Planning |
| IA | Identification and Authentication |
| IR | Incident Response |
| MA | Maintenance |
| MP | Media Protection |
| PE | Physical and Environmental Protection |
| PL | Planning |
| PM | Program Management |
| PS | Personnel Security |
| PT | PII Processing and Transparency |
| RA | Risk Assessment |
| SA | System and Services Acquisition |
| SC | System and Communications Protection |
| SI | System and Information Integrity |
| SR | Supply Chain Risk Management |

## Best Practices

1. **Start with preparation** - Don't skip Step 0
2. **Involve stakeholders** - Security is everyone's responsibility
3. **Document thoroughly** - Maintain comprehensive records
4. **Automate monitoring** - Use tools for continuous assessment
5. **Iterate regularly** - RMF is continuous, not one-time
