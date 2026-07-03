# Pulumi Security

## The Security Trade-off of "IaC in a Real Language"

Pulumi lets you write infrastructure in Python, TypeScript, Go, C#, or Java instead of a declarative DSL like HCL. That's a genuine upgrade for testability (you can unit-test infrastructure logic with normal test frameworks) and for reusing existing engineering practices - but it cuts both ways from a security standpoint:

| Terraform (HCL) | Pulumi (general-purpose language) |
|------------------|-------------------------------------|
| Declarative, limited expressiveness | Full language - loops, conditionals, functions, third-party libraries |
| Harder to accidentally introduce a logic bug | Easier to hide a security-relevant bug inside "normal" code (an off-by-one in a loop that provisions IAM policies, for example) |
| Small, well-understood attack surface | Inherits the language's own supply-chain risk - a compromised `pip`/`npm` package used in your Pulumi program can run arbitrary code during `pulumi up` |
| IaC scanners (Checkov/tfsec) are mature | Scanning general-purpose code with embedded infra logic is less standardized - lean more on Pulumi's own policy engine |

**Practical takeaway:** treat a Pulumi program with the same rigor as any other application code that runs with cloud-admin-level credentials - because that's exactly what it is. Dependency pinning and [SCA](../application-security/sca.md) scanning of your Pulumi program's own dependencies matter here in a way they don't for pure HCL.

## Built-in Secrets Encryption

Pulumi encrypts secret values in its state by default (via a passphrase, or a cloud KMS-backed provider), and marks values as secrets explicitly rather than relying on convention:

```python
import pulumi

config = pulumi.Config()
db_password = config.require_secret("dbPassword")  # encrypted in state, redacted from CLI output

# Values derived from a secret stay marked as secret automatically
connection_string = pulumi.Output.concat("postgres://admin:", db_password, "@db.internal:5432")
```

```bash
# Store a secret value (encrypted at rest via the configured provider)
pulumi config set --secret dbPassword 'S3cr3tValue!'
```

For production stacks, back the encryption with a cloud KMS key (AWS KMS, Azure Key Vault, GCP KMS) rather than the default passphrase provider - this gives you the same key-management benefits (rotation, access policy, audit trail) covered in [KMS](../cloud-security/learning-aws-security/kms.md), applied to your infrastructure secrets themselves.

## Policy as Code with CrossGuard

Pulumi's CrossGuard lets you write policies in the same language as your infrastructure and enforce them at `pulumi up` time - failing the deployment before a non-compliant resource is ever created, not after a scanner finds it later.

```python
# policy-pack/__main__.py - deny public S3 buckets at deploy time
from pulumi_policy import (
    EnforcementLevel,
    PolicyPack,
    ResourceValidationPolicy,
    ResourceValidationArgs,
    ResourceValidationResult,
)

def s3_no_public_read(args: ResourceValidationArgs, report_violation):
    if args.resource_type == "aws:s3/bucket:Bucket":
        acl = args.props.get("acl")
        if acl in ("public-read", "public-read-write"):
            report_violation(
                "S3 buckets must not use a public-read ACL. Use bucket policies with explicit, scoped access instead."
            )

PolicyPack(
    name="security-baseline",
    enforcement_level=EnforcementLevel.MANDATORY,
    policies=[
        ResourceValidationPolicy(
            name="s3-no-public-read",
            description="Prohibits public-read/public-read-write ACLs on S3 buckets.",
            validate=s3_no_public_read,
        ),
    ],
)
```

Set `EnforcementLevel.MANDATORY` for anything you want to hard-block, and `ADVISORY` for policies you're rolling out gradually and want to surface as warnings first - the same "warn, then enforce" rollout pattern used when introducing any new gate into an existing pipeline (see [SDL in CI/CD](sdl-cicd.md)).

## Best Practices

1. **Pin your Pulumi program's own language-level dependencies** and scan them with the same [SCA](../application-security/sca.md) tooling you'd use for an application - a compromised transitive dependency here has cloud-admin blast radius.
2. **Mark every sensitive config value as a secret explicitly** (`config.require_secret`, not `config.require`) - don't rely on remembering not to print it.
3. **Back secrets encryption with a cloud KMS provider in production**, not the default local passphrase.
4. **Write CrossGuard policies for your non-negotiables** (no public buckets, no `0.0.0.0/0` ingress, encryption required) and run them in CI before merge, not just at deploy time.
5. **Code-review Pulumi programs like application code** - a for-loop that provisions IAM roles deserves the same scrutiny as a for-loop that handles user input.

## Credits/References

1. [Pulumi Documentation](https://www.pulumi.com/docs/)
2. [Pulumi CrossGuard (Policy as Code)](https://www.pulumi.com/docs/using-pulumi/crossguard/)
3. [Pulumi Secrets Management](https://www.pulumi.com/docs/concepts/secrets/)
