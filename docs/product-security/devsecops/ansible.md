# Ansible for Security Automation

## Why Ansible Shows Up in Security Work

Ansible is agentless (SSH/WinRM only, no daemon to compromise on managed hosts), idempotent (running a playbook twice doesn't double-apply changes), and human-readable (YAML, not a DSL you need to learn from scratch). That combination makes it a natural fit for one job security teams constantly need: **applying the same hardening baseline consistently across hundreds or thousands of hosts, and proving it stayed applied.**

This page is about using Ansible *as a security control*, not a general Ansible tutorial.

## Enforcing CIS Benchmarks at Scale

Manually hardening a server against a CIS Benchmark is a checklist exercise. Enforcing it across a fleet - and catching drift when someone "temporarily" loosens a setting - is an automation problem.

```yaml
# harden-ssh.yml - a minimal CIS-aligned SSH hardening playbook
- name: Harden SSH daemon per CIS benchmark
  hosts: all
  become: true
  tasks:
    - name: Disable root login over SSH
      ansible.builtin.lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^#?PermitRootLogin'
        line: 'PermitRootLogin no'
      notify: restart sshd

    - name: Disable password authentication (keys only)
      ansible.builtin.lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^#?PasswordAuthentication'
        line: 'PasswordAuthentication no'
      notify: restart sshd

    - name: Set idle session timeout (15 minutes)
      ansible.builtin.lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^#?ClientAliveInterval'
        line: 'ClientAliveInterval 900'
      notify: restart sshd

  handlers:
    - name: restart sshd
      ansible.builtin.service:
        name: sshd
        state: restarted
```

Run this in **check mode** (`ansible-playbook harden-ssh.yml --check --diff`) first in any pipeline - it shows exactly what would change without applying it, which is what you want in a CI gate before a human approves the run against production.

Existing CIS-aligned Ansible role collections (e.g. community `ansible-lockdown` roles for RHEL/Ubuntu CIS benchmarks) are usually a better starting point than writing every control from scratch - customize from there rather than reinventing the baseline.

## Ansible Vault: What It's Good For, and Its Real Limits

Ansible Vault encrypts secrets (passwords, API keys, certificates) at rest inside your playbook/inventory files using AES-256, so you can commit `vault.yml` to git without exposing plaintext secrets.

```bash
# Encrypt a secrets file
ansible-vault encrypt group_vars/production/vault.yml

# Edit it in place (decrypts to a temp file, re-encrypts on save)
ansible-vault edit group_vars/production/vault.yml

# Run a playbook that references vaulted variables
ansible-playbook site.yml --ask-vault-pass
```

**Where Vault falls short of a real secrets manager:**

| Limitation | Why it matters |
|------------|-----------------|
| Single shared vault password (per vault ID) | No per-user access control or audit trail on who decrypted what |
| No automatic rotation | Rotating a secret means editing the file and redistributing the new vault password out-of-band |
| Secrets land on disk during execution | Briefly written to temp files / process memory on managed hosts, unlike a secrets manager that injects at runtime |
| No centralized revocation | Revoking access means re-encrypting and redistributing, not flipping an IAM policy |

**Practical rule:** use Vault for low-churn, low-blast-radius secrets (an internal service account password rotated quarterly). For anything high-value or that needs rotation/audit/fine-grained access - database credentials, cloud API keys, TLS private keys - have Ansible pull them at runtime from a real secrets manager (HashiCorp Vault the product, AWS Secrets Manager, Azure Key Vault) via the relevant lookup plugin instead of storing them in Ansible Vault at all.

## Idempotent Remediation Playbooks

The property that makes Ansible good for configuration management also makes it good for *continuous remediation*: a playbook that disables an unused service is safe to run every hour via a scheduler, because it's a no-op on hosts that are already compliant and only takes action on hosts that drifted.

```yaml
- name: Ensure telnet server is absent (should never run in production)
  hosts: all
  become: true
  tasks:
    - name: Remove telnet server package if present
      ansible.builtin.package:
        name: telnetd
        state: absent

    - name: Ensure telnet port is not listening
      ansible.builtin.wait_for:
        port: 23
        state: stopped
        timeout: 1
      ignore_errors: true
```

Pair this with a scheduled run (cron, AWX/Ansible Automation Platform job template, or a CI pipeline trigger) and you get continuous compliance enforcement instead of a point-in-time audit that's stale the moment someone changes something.

## Ansible in a Compliance-as-Code Pipeline

Ansible playbooks are themselves a form of compliance-as-code: the playbook *is* the executable definition of your security baseline. See [Compliance as Code](compliance-as-code.md) for how to pair this with policy-as-code tools (OPA, Checkov) that verify infrastructure state against policy, while Ansible handles actually *remediating* the drift Ansible or a scanner finds.

A common pattern: a scanner (OpenSCAP, InSpec, or a cloud-native posture tool) detects non-compliant hosts, and an Ansible playbook - triggered automatically or reviewed and run by a human - brings them back into compliance.

## Best Practices

1. **Run `--check --diff` before every production apply** - never push blind.
2. **Store playbooks in version control with PR review** - a hardening playbook is security-critical code.
3. **Use Ansible Vault only for low-churn secrets** - route anything sensitive/rotatable through a real secrets manager.
4. **Tag plays so you can target specific controls** (`--tags cis-ssh`) rather than re-running an entire fleet-wide play for one fix.
5. **Log and alert on remediation runs** - a playbook silently "fixing" dozens of hosts every night is a signal something upstream keeps drifting; investigate the root cause, not just the symptom.

## Credits/References

1. [Ansible Documentation](https://docs.ansible.com/)
2. [Ansible Vault Documentation](https://docs.ansible.com/ansible/latest/vault_guide/index.html)
3. [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks)
4. [ansible-lockdown CIS role collections](https://github.com/ansible-lockdown)
