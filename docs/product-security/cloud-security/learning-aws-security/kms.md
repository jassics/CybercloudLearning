# KMS (Key Management Service)

## What KMS Actually Manages

KMS is where AWS's encryption story starts and ends - nearly every other service's "encryption at rest" option (S3, EBS, RDS, DynamoDB, Secrets Manager) delegates key management to KMS rather than reinventing it. Understanding KMS well means understanding cryptography-in-practice fundamentals too - see [Cryptography](../../application-security/cryptography.md) for the underlying primitives.

## AWS Managed Keys vs. Customer Managed Keys

| Key Type | Who Controls It | Key Policy Editable? | Rotation | Use When |
|----------|-------------------|------------------------|----------|----------|
| **AWS Managed Key** (`aws/s3`, etc.) | AWS | No | Automatic, AWS-controlled schedule | Quick baseline encryption, no compliance requirement for key control |
| **Customer Managed Key (CMK)** | You | Yes - full key policy control | Optional automatic annual rotation, or manual | Regulated data, cross-account access, audit requirements, need to disable/delete the key yourself |

**Interview-relevant distinction:** if an interviewer asks "how would you prove to an auditor that only these three roles can ever decrypt this data," the answer is a **customer managed key with a scoped key policy** - AWS managed keys don't give you that level of control.

## Key Policies vs. IAM Policies for KMS

This is the part that confuses people the most, and is worth memorizing cold:

- A **key policy** is a resource-based policy attached directly to the KMS key. **By default, IAM policies alone cannot grant access to a CMK unless the key policy also allows it** - this is different from most other AWS resources.
- The common pattern is: key policy grants the account root broad admin rights, then delegates actual usage permissions to IAM policies:

```json
// Key policy: root has full control, IAM is allowed to delegate usage permissions
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111122223333:root" },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow specific role to use the key for decryption only",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111122223333:role/reporting-service" },
      "Action": ["kms:Decrypt", "kms:DescribeKey"],
      "Resource": "*"
    }
  ]
}
```

That second statement is the least-privilege pattern: a specific role gets `Decrypt` only, not `Encrypt`/`GenerateDataKey`/`ScheduleKeyDeletion` - a common audit finding is roles with far broader KMS permissions than their actual job requires.

## Envelope Encryption

KMS doesn't encrypt large amounts of data directly with the CMK - the CMK never leaves KMS. Instead, services use **envelope encryption**:

1. Call `GenerateDataKey` to get a plaintext data key and its KMS-encrypted counterpart.
2. Use the plaintext data key to encrypt your actual data locally (fast, symmetric AES).
3. Discard the plaintext data key from memory; store only the encrypted data key alongside the encrypted data.
4. To decrypt later, call KMS `Decrypt` on the encrypted data key, then use the resulting plaintext key to decrypt the data.

```bash
aws kms generate-data-key \
  --key-id arn:aws:kms:us-east-1:111122223333:key/abcd-1234 \
  --key-spec AES_256
```

This is why KMS scales to encrypting huge datasets efficiently - the expensive/rate-limited KMS API call only ever handles small data keys, never your actual bulk data.

## Key Rotation

Automatic annual rotation (for customer managed keys, opt-in) keeps the same key ID/ARN but rotates the underlying cryptographic material behind the scenes - nothing referencing the key ARN needs to change. This is a good default for most workloads and a common "why wouldn't you always turn this on" interview question (answer: there generally isn't a reason not to, unless you need precise manual control over rotation timing for compliance reasons).

```bash
aws kms enable-key-rotation --key-id arn:aws:kms:us-east-1:111122223333:key/abcd-1234
```

## Cross-Account Key Access

Two things must both be true for Account B to use a key owned by Account A:

1. **The key policy** (in Account A) must grant Account B's principal permission.
2. **An IAM policy in Account B** must also grant its own principal permission to use that key.

Missing either side is the most common cause of "access denied" tickets in cross-account KMS setups - both halves have to line up.

## Common Mistake: Decrypt Permissions Too Broad

The single most common KMS misconfiguration found in audits: a role or application has `kms:Decrypt` on `"Resource": "*"`, meaning it can decrypt *any* key in the account it has any path to - not just the one key it actually needs. Combined with an overly permissive IAM policy elsewhere, this turns a narrow application into a skeleton key for every encrypted secret in the account.

```json
// Wrong: this role can decrypt with any KMS key in the account
{ "Effect": "Allow", "Action": "kms:Decrypt", "Resource": "*" }
```

```json
// Right: scoped to the one key this workload actually needs
{ "Effect": "Allow", "Action": "kms:Decrypt", "Resource": "arn:aws:kms:us-east-1:111122223333:key/abcd-1234" }
```

## Best Practices Checklist

- [ ] Customer managed keys used for regulated/sensitive data, not just AWS managed defaults
- [ ] Key policies follow least privilege - specific actions, specific principals, not blanket `kms:*`
- [ ] Automatic key rotation enabled unless there's a documented reason not to
- [ ] `kms:Decrypt` never granted on `Resource: "*"` for application roles
- [ ] Cross-account key access verified on both the key policy and the consuming account's IAM policy
- [ ] CloudTrail data events or key usage logging enabled to audit who used which key, when
- [ ] Envelope encryption used (via SDKs, which do this automatically) rather than raw KMS calls on large payloads

## Practice Next

- [S3 Security](s3-security.md) - SSE-KMS is the standard for regulated S3 data
- [Cryptography](../../application-security/cryptography.md) for the underlying crypto primitives
- [IAM Security](iam-security.md) for the policy fundamentals KMS builds on

## Credits/References

1. [AWS KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)
2. [AWS KMS Best Practices Whitepaper](https://d1.awsstatic.com/whitepapers/aws-kms-best-practices.pdf)
3. [KMS Key Policies](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)
4. [Envelope Encryption Concepts](https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#enveloping)
