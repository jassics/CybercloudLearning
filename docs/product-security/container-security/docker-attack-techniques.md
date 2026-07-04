# Docker Attack Techniques

This is the attacker's-eye-view counterpart to [Docker Security](docker-security.md) - that page tells you how to configure defenses; this one walks through how those defenses actually get bypassed in practice, so you know what you're really defending against.

## Container Breakout via the Docker Socket

[Docker Security](docker-security.md#runtime-hardening) already flags mounting `/var/run/docker.sock` into a container as dangerous - here's the full exploit chain that makes it so severe. The Docker socket is how any client (including the `docker` CLI) talks to the Docker daemon, which runs as root on the host. A container with that socket mounted doesn't just have "some extra access" - it can ask the daemon to launch a **brand new container**, on its behalf, with whatever configuration it wants:

```bash
# From inside a container that has the Docker socket mounted:
# ask the host's Docker daemon to launch a NEW privileged container
# that mounts the entire host filesystem
docker -H unix:///var/run/docker.sock run -it --rm \
  -v /:/host \
  --privileged \
  alpine chroot /host sh
```

That one command, run from *inside* an already-compromised container, results in a fresh container with the host's root filesystem mounted and full privileged access - which is simply full host compromise. Mounting the Docker socket into any container that isn't a trusted, purpose-built management tool is architecturally equivalent to giving that container root on the node.

## runc Container Escape (CVE-2019-5736)

A real, high-severity vulnerability in `runc` - the low-level container runtime underneath Docker, containerd, and CRI-O - independently confirmed against AWS's technical writeup:

- **Mechanism**: `runc` starts a container by executing itself inside the new container's namespaces via `/proc/self/exe`. A malicious container could run a command that also targets `/proc/self/exe`, using `LD_PRELOAD` to get a malicious library loaded, then open `/proc/self/fd/[fd]` (a file descriptor pointing at the host's `runc` binary) and overwrite it once the original binary's text section was no longer in use.
- **Requirements**: the attacker needs the ability to run an arbitrary command inside a container built from an attacker-controlled image, and `runc` running as root - which is the *default* configuration in Docker, Kubernetes, containerd, and CRI-O. No privileged mode, no unusual mount, no misconfiguration required beyond "someone ran a malicious image."
- **Impact**: full root code execution on the host, achieved the next time `runc` was invoked (e.g. for any subsequent container start/exec on that host) - because the host's own `runc` binary had been silently replaced.

This is precisely why [Kubernetes Attack Techniques](kubernetes-attack-techniques.md#container-escape--breakout) treats keeping the container runtime itself patched as equally important as hardening individual pod/container specs - the isolation boundary is *code*, and code has bugs. See [Docker & Container Isolation Architecture](docker-container-isolation-architecture.md) for why this class of bug can defeat every namespace/capability/seccomp layer at once: they're all enforced by (and share) the one host kernel and runtime.

## Privileged Container Escape

`--privileged` (already flagged in [Docker Security](docker-security.md#runtime-hardening)) isn't a single permission - it disables nearly the *entire* isolation stack covered in [Docker & Container Isolation Architecture](docker-container-isolation-architecture.md#5-the-layered-isolation-model) at once: the full Linux capability set is granted, the default seccomp profile is dropped, AppArmor/SELinux confinement is disabled, and the container gets access to all host devices (`/dev/*`). A privileged container can mount the host's block devices directly, load kernel modules, and reconfigure networking - there's very little practical difference between "a privileged container" and "a process running directly on the host as root." If a workload seems to need `--privileged`, it almost always actually needs one or two specific capabilities instead (`--cap-add=SYS_PTRACE` for a debugger, `--cap-add=NET_ADMIN` for network tooling, etc.) - see [Docker Security's capability guidance](docker-security.md#runtime-hardening).

## Malicious and Typosquatted Images on Public Registries

Public registries are a real, ongoing attack vector: attackers publish images disguised as popular software (misspelled names, fake "official" variants, or genuinely useful-looking utility images) that quietly run a cryptominer or open a backdoor alongside whatever functionality the image appears to provide. This has been documented repeatedly by container security researchers analyzing Docker Hub's public image corpus - malicious/cryptomining images have been found accumulating substantial pull counts before removal, meaning real production and development environments picked them up. The defense is the same principle covered in [AI Supply Chain Security](../../ai-security/ai-supply-chain-security.md) for model files and in [SCA](../application-security/sca.md) for application dependencies: **verify the source before you run it**, don't trust a registry search result's popularity as a proxy for safety, and scan every pulled image (see [Docker Security's Image Scanning section](docker-security.md#image-scanning)) even for "well-known" software.

## Exposed Docker Daemon API

The Docker daemon can be configured to listen on a TCP socket (`-H tcp://0.0.0.0:2375`) for remote management - without TLS client-certificate authentication enabled, this exposes **unauthenticated root-equivalent access to the host** to anyone who can reach that port. This is not a theoretical risk: internet-wide scanning campaigns specifically probe for exposed, unauthenticated Docker daemon APIs (port 2375) and automatically deploy cryptomining containers the moment they find one - it's one of the most commonly and automatically exploited container misconfigurations on the public internet. If remote daemon access is genuinely needed, it must be behind mutual TLS (`--tlsverify` with client certificates) or an SSH tunnel, never a bare unauthenticated TCP listener.

## Mapping Attacks to Existing Defenses

| Attack Technique | Mitigated By (see [Docker Security](docker-security.md)) |
|--------------------|---------------------------------------------------------------|
| Docker socket breakout | Never mount the socket into untrusted containers |
| runc escape (CVE-2019-5736) | Patch the container runtime; read-only root filesystem + dropped capabilities limit post-escape damage |
| Privileged container escape | Never use `--privileged`; use specific `--cap-add` instead |
| Malicious/typosquatted images | Image scanning (Trivy/Grype) before every run; pin by digest |
| Exposed daemon API | Never expose the daemon on an unauthenticated TCP socket; use TLS client certs or SSH tunneling |

## Credits/References

1. [CVE-2019-5736 - runc container escape, AWS writeup](https://aws.amazon.com/blogs/compute/anatomy-of-cve-2019-5736-a-runc-container-escape/)
2. [Docker Engine Security Documentation](https://docs.docker.com/engine/security/)
3. [Protect the Docker daemon socket - Docker Docs](https://docs.docker.com/engine/security/protect-access/)
4. [MITRE ATT&CK for Containers](https://attack.mitre.org/matrices/enterprise/containers/)

## Continue Learning

- [Docker Security](docker-security.md) - the hardening checklist these attacks map back to
- [Docker & Container Isolation Architecture](docker-container-isolation-architecture.md) - why these isolation layers can be bypassed at all
- [Docker Real-World Incidents](docker-real-world-incidents.md) - these techniques as they've actually played out in production
- [Kubernetes Attack Techniques](kubernetes-attack-techniques.md) - the same attacker's-eye-view treatment at the cluster level
