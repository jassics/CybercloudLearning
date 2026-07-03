# Terraform Security

## Shift Left for Infrastructure

Application code gets code review, SAST, and SCA before it ships. Infrastructure defined in Terraform deserves the same treatment - a misconfigured `aws_s3_bucket` or `aws_security_group` resource is just as exploitable as a SQL injection bug, and it's far cheaper to catch in a pull request than after `terraform apply` has already created the resource in production.

"IaC security" mostly means: **scan the plan before it's applied, and don't let secrets or overly permissive state live in the codebase.**

## Insecure vs. Hardened: A Real Example

```hcl
# INSECURE - publicly readable bucket, no encryption, no logging
resource "aws_s3_bucket" "data" {
  bucket = "company-user-uploads"
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

```hcl
# HARDENED - encrypted, public access blocked, versioned, logged
resource "aws_s3_bucket" "data" {
  bucket = "company-user-uploads"
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "data" {
  bucket        = aws_s3_bucket.data.id
  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "data-access-logs/"
}
```

This is exactly the pattern covered in more depth on the [S3 Security](../cloud-security/learning-aws-security/s3-security.md) page - Terraform is just how you *express and enforce* that hardened configuration as code instead of clicking through the console (and clicking through it correctly every single time).

The same logic applies to security groups: a Terraform module that defaults `cidr_blocks = ["0.0.0.0/0"]` on an ingress rule is a scanner finding waiting to happen - default to specific CIDR ranges or security-group references, not the whole internet.

## IaC Scanning Tools

| Tool | Notes |
|------|-------|
| **Checkov** | Open-source, broad policy library (AWS/Azure/GCP/Kubernetes/Dockerfile), easy CI integration |
| **tfsec** | Open-source, Terraform-specific, fast, now merged into Trivy's IaC scanning |
| **Terrascan** | Open-source, OPA/Rego-based policies, supports custom policy authoring |
| **Trivy** (IaC mode) | Same tool used for [SCA](../application-security/sca.md) container/dependency scanning, also scans Terraform/CloudFormation/Kubernetes manifests |

```yaml
# .github/workflows/terraform-scan.yml - gate a PR on Checkov findings
name: Terraform Security Scan
on: pull_request

jobs:
  checkov:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Checkov
        uses: bridgecrewio/checkov-action@master
        with:
          directory: .
          framework: terraform
          soft_fail: false   # fail the build on any CRITICAL/HIGH finding
```

This is the same shift-left pattern as [SCA in CI/CD](sca-cicd.md) and [SAST](../application-security/sast.md) - scan on every PR, gate on severity, track lower-severity findings as backlog debt rather than blocking unrelated work.

## Remote State Security

Terraform state files often contain **plaintext secrets** - database passwords, private keys, connection strings pulled from resource attributes - even if you never wrote a secret directly into your `.tf` files. Treat state with the same care as a secrets store:

- Use a remote backend (S3 + DynamoDB lock table, Terraform Cloud, etc.) - never commit `terraform.tfstate` to git.
- Encrypt the state backend at rest (S3 bucket encryption + a restrictive bucket policy).
- Restrict who/what can read the state bucket - it's often more sensitive than the Terraform code itself.
- Avoid storing sensitive values as plain resource attributes when you can reference them from a secrets manager at apply time instead (e.g. `data "aws_secretsmanager_secret_version"` rather than a hardcoded `variable` with a default).

## Policy as Code with Sentinel/OPA

Beyond point-in-time scanning, some teams enforce policy at the `terraform plan` stage itself using Sentinel (Terraform Cloud/Enterprise) or OPA/Conftest (open-source), so a plan that violates policy can't be applied at all, not just flagged. See [Compliance as Code](compliance-as-code.md) for the general pattern and a Rego example.

## Best Practices

1. **Scan every plan, not just the initial apply** - drift and new resources both need scanning.
2. **Never commit `.tfvars` files containing secrets** - use environment variables or a secrets manager integration instead.
3. **Pin provider and module versions** - an unpinned module can silently pull in a compromised or breaking update (a supply-chain risk, same category as dependency pinning in [SCA](../application-security/sca.md)).
4. **Use remote state with encryption and strict access control.**
5. **Review `terraform plan` output like a code diff** - a plan showing an unexpected `destroy` or a broadened IAM policy is a red flag before you ever get to `apply`.

## Credits/References

1. [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
2. [Checkov Documentation](https://www.checkov.io/)
3. [tfsec / Trivy IaC Scanning](https://aquasecurity.github.io/trivy/latest/docs/scanner/misconfiguration/)
4. [OWASP Cloud-Native Application Security Top 10](https://owasp.org/www-project-cloud-native-application-security-top-10/)
