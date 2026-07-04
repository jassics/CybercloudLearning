# GCP IAM & Data Security

## The Resource Hierarchy Drives Everything

GCP's Organization → Folder → Project → Resource hierarchy means an IAM policy binding set high up applies to everything beneath it. This is the single most important structural fact to internalize before auditing GCP IAM: a broad `roles/editor` binding at the Organization level is not "one project's problem" - it's every project's problem. Always check bindings at every level of the hierarchy, not just the resource you're reviewing.

## Predefined vs. Custom vs. Basic Roles

| Role Type | Granularity | When to Use |
|-----------|-------------|-------------|
| **Basic roles** (`Owner`, `Editor`, `Viewer`) | Extremely broad - `Editor` can modify almost everything in a project | Rarely appropriate in production; convenient for early prototyping only |
| **Predefined roles** (e.g. `roles/storage.objectViewer`) | Scoped to a specific service and set of actions, curated by Google | The right default for most production use cases |
| **Custom roles** | You define the exact permission set | When even the narrowest predefined role is still broader than the task needs |

**IAM Conditions** add a further layer - context-aware grants like "this role only applies if the request comes from this IP range" or "only before this date," letting you scope access more tightly without creating a proliferation of custom roles.

## Service Accounts: Keys vs. Workload Identity Federation

A GCP service account is the equivalent of an AWS IAM role or an Azure managed identity - but unlike a managed identity, a service account CAN have a downloadable JSON key, and that key is exactly the kind of long-lived credential every cloud provider now recommends avoiding:

- **Service account keys** are permanent (until manually rotated/revoked) JSON credential files - if one leaks into a git repo, a log file, or a compromised laptop, it's valid until someone notices and revokes it.
- **Workload Identity Federation** lets external workloads (CI/CD pipelines, other clouds, on-prem systems) authenticate as a service account WITHOUT ever having a long-lived key - the same "no credential to steal" principle behind AWS IAM roles for EC2/Lambda and Azure managed identities.

**This is one of the most important modern GCP security recommendations** - if you see a service account key file anywhere in application code or CI/CD configuration, that's a finding.

## Common GCP IAM Misconfigurations

1. **Overly broad `roles/editor` or `roles/owner` bindings** on service accounts or users where a narrow predefined/custom role would do.
2. **Service account keys committed to source control** or left in CI/CD logs/artifacts - a recurring, real, high-impact finding.
3. **Public IAM bindings** - granting a role to `allUsers` or `allAuthenticatedUsers` on a sensitive resource, which is the GCP equivalent of an S3 bucket with public access enabled.
4. **Org-level bindings that are broader than any single project actually needs**, inherited silently by every project in the hierarchy.

## Cloud Storage Security

- **Bucket-level IAM vs. legacy ACLs**: Google recommends **uniform bucket-level access**, which disables per-object ACLs and enforces IAM-only access control for the entire bucket - simpler to reason about and audit than a mix of bucket policy and object-level ACLs.
- **Public access prevention**: a bucket-level (or org-level) setting that blocks public access regardless of any IAM binding that would otherwise allow it - defense in depth against an accidental `allUsers` grant.

```bash
# Vulnerable direction - turns OFF the guardrail against public exposure
gcloud storage buckets update gs://my-bucket --no-public-access-prevention

# Secure direction - enforce public access prevention regardless of IAM bindings
gcloud storage buckets update gs://my-bucket --public-access-prevention
```

## Cloud KMS

- **Customer-managed encryption keys (CMEK) vs. Google-managed**: Google-managed keys are the default and require no setup, but CMEK gives you control over key rotation schedule, access policy, and the ability to revoke access by disabling the key - required for many compliance regimes.
- **Scope KMS IAM roles narrowly**: separate "can encrypt/decrypt using this key" (`roles/cloudkms.cryptoKeyEncrypterDecrypter`) from "can manage this key's lifecycle" (`roles/cloudkms.admin`) - an application needs the former, almost never the latter.

## Cloud Audit Logs

- **Admin Activity logs** - always on, cannot be disabled, capture administrative actions (creating/deleting resources, changing IAM policies).
- **Data Access logs** - must be explicitly enabled per service, capture read/write/access operations on the data itself, and generate significantly higher volume/cost.

For sensitive services (Cloud Storage buckets holding regulated data, BigQuery datasets with PII), enabling Data Access logs despite the noise/cost is almost always worth it - it's frequently the only way to answer "who actually read this data" during an incident investigation.

## Vulnerable vs. Secure: Service Account Configuration

```bash
# Vulnerable: a downloadable long-lived key, bound to an overly broad role
gcloud iam service-accounts keys create key.json \
  --iam-account=my-app@my-project.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding my-project \
  --member="serviceAccount:my-app@my-project.iam.gserviceaccount.com" \
  --role="roles/editor"
```

```bash
# Secure: no downloadable key at all - Workload Identity Federation authenticates
# the external workload directly, scoped to a narrow custom/predefined role
gcloud projects add-iam-policy-binding my-project \
  --member="principalSet://iam.googleapis.com/projects/.../workloadIdentityPools/my-pool/*" \
  --role="roles/storage.objectViewer"
```

## Best Practices Checklist

- [ ] Basic roles (`Owner`/`Editor`/`Viewer`) avoided in production - predefined or custom roles used instead
- [ ] Service accounts use Workload Identity Federation instead of downloadable JSON keys wherever possible
- [ ] No service account key files in source control, CI/CD logs, or application code
- [ ] No `allUsers`/`allAuthenticatedUsers` bindings on sensitive resources
- [ ] Uniform bucket-level access enabled; public access prevention enforced
- [ ] CMEK used for regulated/sensitive data, with KMS roles scoped to encrypt/decrypt only where possible
- [ ] Data Access logs enabled for services handling sensitive data, despite the added volume
- [ ] IAM bindings audited at every level of the resource hierarchy, not just the resource in scope

## Practice Next

- [GCP Security Overview](gcp-security-overview.md)
- [AWS IAM Security](../learning-aws-security/iam-security.md) - the AWS equivalent for side-by-side comparison
- [AWS KMS](../learning-aws-security/kms.md) - the AWS equivalent of Cloud KMS
- [Multi-Cloud Security Architecture](../multi-cloud-security-architecture.md)
- [Cloud Security Resources](../cloud-security-resources.md)

## Credits/References

1. [Google Cloud IAM Documentation](https://cloud.google.com/iam/docs)
2. [Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation)
3. [Cloud Storage Security and Access Control](https://cloud.google.com/storage/docs/access-control)
4. [Cloud KMS Documentation](https://cloud.google.com/kms/docs)
5. [Cloud Audit Logs Documentation](https://cloud.google.com/logging/docs/audit)
6. [Google Cloud Security Foundations Blueprint](https://cloud.google.com/architecture/security-foundations)
