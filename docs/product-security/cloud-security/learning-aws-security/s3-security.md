# S3 Security

## Why S3 Shows Up in So Many Breach Reports

S3 itself is secure by default - new buckets are private. Every major "S3 data leak" headline is a **misconfiguration**, not a flaw in the service: a bucket policy that grants public access, an ACL left open, or encryption/logging simply never turned on. This makes S3 one of the highest-yield things to get right, and one of the most common interview topics for any cloud security role.

## Bucket Policies vs. IAM Policies vs. ACLs

Three different mechanisms can grant access to the same object - knowing which one to reach for (and which ones to avoid) matters:

| Mechanism | Attached To | Best For |
|-----------|-------------|----------|
| **IAM Policy** | A user/role | Controlling what your own principals can do across many buckets |
| **Bucket Policy** | The bucket itself | Cross-account access, public access (rare, deliberate cases), bucket-wide rules like "deny non-TLS requests" |
| **ACL (Access Control List)** | Individual objects/buckets | Legacy - AWS now recommends disabling ACLs entirely on new buckets |

**Rule of thumb:** use IAM policies for your own principals, bucket policies for cross-account/public rules, and disable ACLs (S3 supports "Bucket owner enforced" mode, which does this for you).

## Block Public Access

This is the single highest-leverage control against accidental data exposure - it overrides bucket policies and ACLs that would otherwise make content public, at both the account and bucket level.

```bash
# Check if Block Public Access is enabled account-wide
aws s3control get-public-access-block --account-id <account-id>

# Enable it account-wide (should be the default in any serious org)
aws s3control put-public-access-block --account-id <account-id> \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

Treat any bucket that needs to be genuinely public (e.g. static website hosting) as an explicit, documented exception - not a default.

## A Real Misconfiguration, and the Fix

This is close to the actual policy behind several public breach disclosures:

```json
// Vulnerable: grants read access to literally anyone on the internet
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::customer-data-bucket/*"
    }
  ]
}
```

```json
// Fixed: scoped to a specific role, over TLS only
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111122223333:role/reporting-service" },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::customer-data-bucket/*"
    },
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::customer-data-bucket",
        "arn:aws:s3:::customer-data-bucket/*"
      ],
      "Condition": { "Bool": { "aws:SecureTransport": "false" } }
    }
  ]
}
```

That second statement (deny non-TLS requests) is a best-practice addition worth adding to every bucket policy handling sensitive data, not just public ones.

## Encryption Options

| Option | Who Manages the Key | Use When |
|--------|----------------------|----------|
| **SSE-S3** | AWS | Default baseline encryption, no compliance requirement for customer key control |
| **SSE-KMS** | You (customer-managed key in [KMS](kms.md)) | You need audit trails on key usage, key rotation control, or cross-account key policies |
| **SSE-C** | You (you supply the key per request) | Rare - you want AWS to never store the key at all |

For anything regulated (PCI, HIPAA, customer PII), **SSE-KMS with a customer-managed key** is the standard answer - it gives you a CloudTrail record every time the key is used to encrypt/decrypt, which SSE-S3 does not.

```bash
# Enforce SSE-KMS as the bucket default
aws s3api put-bucket-encryption --bucket customer-data-bucket \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "aws:kms",
        "KMSMasterKeyID": "arn:aws:kms:us-east-1:111122223333:key/abcd-1234"
      }
    }]
  }'
```

## Versioning and MFA Delete

Versioning protects against accidental overwrites/deletes and is a prerequisite for MFA Delete - an extra layer that requires MFA to permanently delete a version or change versioning state, protecting against a compromised credential wiping out data.

```bash
aws s3api put-bucket-versioning --bucket customer-data-bucket \
  --versioning-configuration Status=Enabled,MFADelete=Enabled \
  --mfa "arn:aws:iam::111122223333:mfa/root-account-mfa-device 123456"
```

## Access Logging

Enable server access logging (or S3 data events in [CloudTrail](cloudtrail.md) for finer-grained, queryable logs) so you can answer "who accessed this object" during an investigation - without it, you have no forensic trail after the fact.

## Best Practices Checklist

- [ ] Block Public Access enabled at the account level, bucket-level exceptions documented
- [ ] ACLs disabled (Bucket owner enforced mode)
- [ ] Bucket policies scoped to specific principals, not `"Principal": "*"` unless deliberately public
- [ ] Deny non-TLS requests (`aws:SecureTransport: false`) on sensitive buckets
- [ ] Default encryption enabled - SSE-KMS with customer-managed keys for regulated data
- [ ] Versioning enabled on buckets holding anything you can't afford to lose
- [ ] MFA Delete enabled on critical buckets
- [ ] Access logging or CloudTrail data events enabled for audit trail
- [ ] Regular automated scans (AWS Config rules, Trivy, or third-party) for public buckets

## Practice Next

- [IAM Security](iam-security.md)
- [KMS](kms.md) for the encryption key management side
- [CloudTrail](cloudtrail.md) for investigating who accessed what

## Credits/References

1. [Amazon S3 Security Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)
2. [S3 Block Public Access](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)
3. [S3 Server-Side Encryption Options](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingKMSEncryption.html)
