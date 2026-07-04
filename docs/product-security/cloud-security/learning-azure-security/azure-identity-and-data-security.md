# Azure Identity & Data Security

## Why Entra ID Is the Azure Equivalent of "Get IAM Right First"

Just as [AWS IAM Security](../learning-aws-security/iam-security.md) is the front door for AWS, Microsoft Entra ID (formerly Azure AD) is the front door for Azure - and for most enterprises, for their entire Microsoft 365 estate too, since Entra ID is usually the same identity plane behind both. A misconfigured Entra ID tenant doesn't just risk Azure resources; it risks email, SharePoint, Teams, and every other Microsoft 365 service tied to the same directory.

## Service Principals vs. Managed Identities

| Identity Type | What It Is | Credential Risk |
|----------------|------------|-------------------|
| **Service Principal** | An application's identity in Entra ID, authenticated via a client secret or certificate | The secret/certificate is a credential you must store, rotate, and can leak |
| **Managed Identity** | An identity Azure manages FOR a resource (VM, Function, App Service) - no credential to store at all | None - Azure handles the credential lifecycle entirely |

**Rule of thumb:** always prefer a managed identity over a service principal with a manually-managed secret, for the same reason AWS prefers IAM roles over embedded access keys - there's no long-lived secret for an attacker to steal in the first place.

## Conditional Access: Azure's Core Access-Control Mechanism

Conditional Access policies are "if this, then that" rules evaluated on every sign-in - the mechanism behind requirements like "admins must use MFA" or "block sign-in from outside approved countries":

```
IF: user is a member of "Global Administrators"
AND: sign-in is NOT from a compliant/managed device
THEN: require MFA AND require a compliant device
```

Every privileged role should have a Conditional Access policy requiring MFA at minimum - this is the single highest-leverage Entra ID control, in the same way MFA-on-privileged-users is for AWS IAM.

## Privileged Identity Management (PIM)

PIM makes admin roles **eligible** rather than permanently **active** - a user activates the role only when needed, for a limited time window, often requiring approval and justification. This is Azure's equivalent of just-in-time (JIT) privileged access, and it directly addresses the same "standing admin access" risk that AWS's temporary STS credentials and short-lived role assumptions address.

## Common Entra ID Misconfigurations

1. **Overly broad app registration permissions** - an application requesting (and being granted, via admin consent) far more Microsoft Graph API permissions than it actually uses, e.g. `Directory.ReadWrite.All` when it only ever reads a user's profile.
2. **Stale service principals** - app registrations from decommissioned projects that still have valid credentials and were never cleaned up.
3. **Unreviewed guest access** - external/guest users invited for a one-time collaboration who retain access indefinitely because nobody runs periodic access reviews.
4. **No Conditional Access on privileged roles** - the Entra ID equivalent of "no MFA on the AWS root account."

## Azure RBAC

Azure RBAC assigns roles at a **scope**: Management Group → Subscription → Resource Group → Resource, with permissions inheriting downward - narrower scope is always safer.

```bash
# Scope a role assignment as narrowly as the task allows - here, read-only
# blob access to one specific resource group, not the whole subscription
az role assignment create \
  --assignee "user@company.com" \
  --role "Storage Blob Data Reader" \
  --scope "/subscriptions/<sub-id>/resourceGroups/payments-rg"
```

Built-in roles (`Reader`, `Contributor`, `Owner`) are broad and convenient but rarely least-privilege for production workloads - custom roles, scoped to the specific actions a workload needs, are the right default once you're past initial setup, the same way customer-managed IAM policies beat AWS managed policies for anything sensitive.

## Azure Storage Security

Azure Storage Accounts are the Azure equivalent of S3 buckets, and share the exact same top misconfiguration pattern - public exposure of data that was never meant to be public:

- **Access keys vs. Entra ID auth**: Storage Account access keys are long-lived, account-wide shared secrets (closer to AWS root credentials than a scoped IAM policy) - prefer Entra ID-based access with RBAC scoped to specific containers/operations wherever the client supports it.
- **Public blob access**: a Storage Account or individual container can be configured to allow anonymous public read access - this is architecturally identical to an S3 bucket public-access misconfiguration, and just as commonly the root cause of real data exposure incidents.
- **Storage firewall and private endpoints**: restrict network access to specific VNets/IP ranges, or eliminate public network exposure entirely via a Private Endpoint.
- **Encryption at rest**: enabled by default with Microsoft-managed keys; use customer-managed keys (CMK) stored in Key Vault when compliance requires control over key rotation and revocation.

```bash
# Vulnerable direction - do not do this for anything holding real data
az storage account update --name mystorageacct --allow-blob-public-access true

# Secure direction - disable public access at the account level
az storage account update --name mystorageacct --allow-blob-public-access false
```

## Azure Key Vault

Key Vault is Azure's combined equivalent of AWS Secrets Manager + KMS - it stores secrets, encryption keys, and certificates.

- **Access policies vs. Azure RBAC for Key Vault**: the legacy access-policy model grants broad vault-level permissions; the newer Azure RBAC model allows fine-grained, per-secret/per-key role assignments consistent with the rest of Azure RBAC - prefer RBAC for new vaults.
- **Soft-delete and purge protection**: without these enabled, a deleted Key Vault (or a deleted secret/key within it) can be permanently and immediately gone - accidentally or maliciously. Soft-delete keeps a recoverable copy for a retention period; purge protection prevents even an admin from permanently deleting it before that period expires. Enable both on any vault holding production secrets.

## Vulnerable vs. Secure: Storage Account Configuration

```bash
# Vulnerable: public blob access enabled, shared-key auth allowed, no network restriction
az storage account create --name insecureacct --resource-group payments-rg \
  --allow-blob-public-access true --sku Standard_LRS
```

```bash
# Secure: public access disabled, Entra ID auth preferred, private endpoint only
az storage account create --name secureacct --resource-group payments-rg \
  --allow-blob-public-access false \
  --default-action Deny \
  --sku Standard_LRS
az storage account update --name secureacct --set properties.encryption.keySource=Microsoft.Keyvault
```

## Best Practices Checklist

- [ ] Managed identities used instead of service principals with manually-managed secrets, wherever supported
- [ ] Conditional Access requires MFA (and ideally a compliant device) for every privileged role
- [ ] Privileged Identity Management (PIM) used for admin roles - eligible, not standing, access
- [ ] App registrations reviewed periodically for unused/over-permissioned entries
- [ ] Guest/external user access reviewed on a schedule, not left indefinite
- [ ] Storage Accounts have public blob access disabled by default, exceptions documented
- [ ] Storage network access restricted via firewall rules or Private Endpoints
- [ ] Key Vault uses Azure RBAC (not legacy access policies) with soft-delete and purge protection enabled

## Practice Next

- [Azure Security Overview](azure-security-overview.md)
- [AWS IAM Security](../learning-aws-security/iam-security.md) - the AWS equivalent for side-by-side comparison
- [AWS S3 Security](../learning-aws-security/s3-security.md) - the AWS equivalent of the Storage Account risks above
- [Multi-Cloud Security Architecture](../multi-cloud-security-architecture.md)
- [Cloud Security Resources](../cloud-security-resources.md)

## Credits/References

1. [Microsoft Entra ID Documentation](https://learn.microsoft.com/en-us/entra/identity/)
2. [Azure RBAC Documentation](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)
3. [Conditional Access Documentation](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)
4. [Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)
5. [Azure Storage Security Guide](https://learn.microsoft.com/en-us/azure/storage/blobs/security-recommendations)
6. [Azure Key Vault Security Overview](https://learn.microsoft.com/en-us/azure/key-vault/general/security-features)
7. [Azure Security Benchmark](https://learn.microsoft.com/en-us/security/benchmark/azure/)
