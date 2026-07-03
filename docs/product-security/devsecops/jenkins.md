# Jenkins Security

## Secure the Pipeline Tool, Not Just What Runs In It

Every other DevSecOps page on this site is about using CI/CD to *enforce* security - SAST/SCA/DAST gates, policy-as-code, IaC scanning. This page is about a different problem: **Jenkins itself is a high-value target.** It typically holds deployment credentials, cloud API keys, source code access, and the ability to run arbitrary code on every build agent. A compromised Jenkins instance is often a faster path to production than any application vulnerability.

## The Script Console Is a Backdoor by Design

Jenkins' built-in Script Console runs arbitrary Groovy with the permissions of the Jenkins process - which usually means it can read every credential Jenkins holds and execute code on connected agents. It's meant for admin troubleshooting, not general access.

- Restrict `Overall/Administer` (which gates Script Console access) to a small, named set of admins - never grant it broadly "to unblock people faster."
- Enable **Role-Based Access Control** (via the Role-based Authorization Strategy plugin) instead of relying on the simple matrix authorization's coarse `Admin`/`User` split.
- Audit who has `Administer` quarterly - it's a common area of privilege creep.

## Credentials: Use the Credentials Plugin, Never Hardcode

```groovy
// INSECURE - secret visible in the Jenkinsfile, build logs, and git history
pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                sh 'aws configure set aws_secret_access_key AKIAABCDEF1234567890'
                sh './deploy.sh'
            }
        }
    }
}
```

```groovy
// SECURE - secret injected at runtime from Jenkins' credential store, masked in logs
pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-deploy-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh './deploy.sh'   // env vars available only within this block, auto-masked in console output
                }
            }
        }
    }
}
```

Store the actual secret in Jenkins' Credentials store (backed by a KMS-encrypted file, or better, an external secrets manager plugin pointing at Vault/AWS Secrets Manager), scope each credential to the specific folder/job that needs it, and never echo a secret variable directly (`echo $AWS_SECRET_ACCESS_KEY`) - Jenkins masks known credential bindings in log output, but only if you use `withCredentials` rather than reading the secret into a variable some other way.

## Untrusted Code on Shared Agents

If Jenkins builds pull requests from external contributors (or even from less-trusted internal repos) on the same agents that hold deployment credentials, a malicious PR can potentially read those credentials or pivot to other jobs on the same agent.

- Run PR builds from forks/untrusted sources on **isolated, ephemeral agents** (containers or VMs spun up per-build and destroyed after) with no access to deployment credentials.
- Never auto-trigger a full build+deploy pipeline on an unreviewed PR - require a maintainer to approve running CI on external contributions (GitHub's "Approve and run" gate for forks is the equivalent pattern on GitHub Actions).
- Treat any Jenkinsfile change in a PR itself as untrusted input - `Jenkinsfile` is code, and a PR can modify it to do anything the agent's permissions allow.

## Webhook and Trigger Security

- Validate webhook payloads (e.g. GitHub's `X-Hub-Signature-256` HMAC) rather than trusting any POST to your trigger URL - an unauthenticated build trigger endpoint lets anyone kick off jobs, potentially with attacker-controlled parameters.
- Restrict which jobs can be parameterized/triggered remotely, and validate/sanitize any parameters used in shell steps (a parameterized build that interpolates a user-supplied string directly into `sh "deploy.sh ${params.ENV}"` is a command injection waiting to happen).

## Plugin Supply-Chain Risk

Jenkins' plugin ecosystem is large, community-maintained, and has had real supply-chain incidents (compromised or vulnerable plugins with broad permissions).

- Keep Jenkins core and plugins patched - subscribe to the Jenkins Security Advisories.
- Minimize the plugin footprint - every installed plugin is additional attack surface, especially plugins with credential or script-execution capabilities.
- Review plugin permissions before installing, the same way you'd review an npm/PyPI package before adding it as a dependency (see [SCA](../application-security/sca.md) for the general supply-chain risk model).

## Best Practices

1. **Restrict Script Console / `Administer` to a small admin group**, audited regularly.
2. **Store every secret in the Credentials plugin (or an external secrets manager)** - never in a Jenkinsfile, environment default, or shell script committed to the repo.
3. **Isolate untrusted PR builds on ephemeral agents with no deployment credentials.**
4. **Validate webhook signatures** and sanitize any pipeline parameters used in shell steps.
5. **Patch Jenkins core and plugins on a schedule**, and minimize installed plugins to reduce supply-chain exposure.

## Credits/References

1. [Jenkins Security Documentation](https://www.jenkins.io/doc/book/security/)
2. [Jenkins Security Advisories](https://www.jenkins.io/security/advisories/)
3. [OWASP CI/CD Security Top 10](https://owasp.org/www-project-top-10-ci-cd-security-risks/)
