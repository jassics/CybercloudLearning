# Compliance as Code

## What Compliance as Code Solves

Traditional compliance is a point-in-time audit: someone manually checks a sample of resources against a control list once a quarter, produces a spreadsheet, and hopes nothing drifted before the next audit. That doesn't scale in cloud environments where infrastructure changes hundreds of times a day.

Compliance as code encodes policy requirements as machine-readable rules that run automatically against every change - so "is this compliant?" is answered continuously, not quarterly, and a non-compliant resource can be blocked before it's ever provisioned.

## Policy-as-Code Tools

| Tool | Language | Typical Use |
|------|----------|--------------|
| **Open Policy Agent (OPA) / Rego** | Rego | General-purpose policy engine - Kubernetes admission control, API authorization, CI/CD gates |
| **Checkov** | YAML/Python rules | IaC scanning (Terraform, CloudFormation, Kubernetes manifests, Dockerfiles) |
| **Conftest** | Rego (built on OPA) | Testing structured config files (YAML/JSON/Terraform plan output) against policies |
| **HashiCorp Sentinel** | Sentinel (proprietary) | Policy enforcement in Terraform Cloud/Enterprise |
| **AWS Config Rules / Azure Policy / GCP Organization Policy** | Native cloud policy | Continuous compliance checking on live cloud resources, not just IaC |

## A Real Example: Deny Unencrypted S3 Buckets

**Checkov** (Python-based, works directly against Terraform):

```python
# Built-in check - CKV_AWS_19: "Ensure S3 bucket has server-side encryption enabled"
# Run against a Terraform plan:
checkov -d ./terraform --check CKV_AWS_19
```

**OPA/Rego**, written by hand for a Terraform plan JSON:

```rego
package terraform.s3

deny[msg] {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket"
    not resource.change.after.server_side_encryption_configuration
    msg := sprintf("S3 bucket '%s' must have encryption enabled", [resource.address])
}
```

Both approaches produce the same outcome: a `terraform plan` that creates an unencrypted bucket fails the pipeline before `apply` ever runs.

## Wiring Policy Checks into CI/CD

```yaml
# GitHub Actions example
name: IaC Compliance Check
on: pull_request

jobs:
  policy-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Checkov
        uses: bridgecrewio/checkov-action@v12
        with:
          directory: terraform/
          soft_fail: false   # fail the build on violations
      - name: Run Conftest against Terraform plan
        run: |
          terraform plan -out=plan.tfplan
          terraform show -json plan.tfplan > plan.json
          conftest test plan.json --policy policy/
```

`soft_fail: false` is the important part - a compliance check that only warns and never blocks gets ignored under deadline pressure, same as an unenforced SAST gate.

**See also:** this is the same pattern used to scan real infrastructure code before it ships - see [Terraform](terraform.md) for IaC-specific scanning with Checkov/tfsec, and [Ansible](ansible.md) for enforcing the same kind of hardening rules against configuration-management playbooks.

## Mapping Automated Checks Back to Frameworks

The value of compliance-as-code compounds when each rule is explicitly mapped to the framework requirement it satisfies, so audit evidence is generated automatically instead of assembled by hand:

| Automated Check | Maps To |
|------------------|---------|
| S3/storage encryption enforced | [ISO/IEC 27001](../../grc/iso27k1.md) Annex A cryptography controls; [NIST CSF](../../grc/nist-csf.md) Protect (PR.DS) |
| MFA required on privileged IAM users | NIST CSF Protect (PR.AC) |
| Public access blocked on storage by default | GDPR/data-privacy requirements (see [Data Privacy](../../grc/data-privacy.md)) |
| Audit logging enabled on all resources | NIST CSF Detect (DE.AE); SOC 2 monitoring criteria |

A control that exists only as policy-as-code with no framework mapping is hard to defend in an audit. A control that exists only as a framework citation with no automated enforcement is easy to violate by accident. You want both.

## Best Practices

1. **Start with a small set of high-value rules** (encryption, public access, MFA) rather than trying to codify an entire framework on day one.
2. **Run checks in "warn" mode first**, gather false-positive feedback, then flip to blocking - same rollout pattern as any new CI gate.
3. **Version-control policies alongside infrastructure code**, with the same PR review process - a policy change is a security-relevant change.
4. **Generate audit evidence automatically** - CI logs of every policy check run are far stronger audit evidence than a manual quarterly review.

## Credits/References

1. [Open Policy Agent](https://www.openpolicyagent.org/)
2. [Checkov by Bridgecrew](https://www.checkov.io/)
3. [Conftest](https://www.conftest.dev/)
