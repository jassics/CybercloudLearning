# Docker Red Teaming & Labs

## A Basic Docker Security Assessment Methodology

1. **Review the build process.** Check the Dockerfile and image for the anti-patterns covered in [Docker Security](docker-security.md): does it run as root, is the base image bloated/unpinned, and - critically - does `docker history <image>` reveal secrets baked into any layer, even one that was later "overwritten"?
2. **Scan the image for known CVEs.** Trivy or Grype against every image before it runs, exactly as described in [Docker Security: Image Scanning](docker-security.md#image-scanning).
3. **Audit the running host.** [Docker Bench for Security](docker-security.md#auditing-your-setup) is the fastest way to get a CIS-Benchmark-aligned "here's what's misconfigured" report - see Docker Security for the exact command, not repeated here.
4. **Check for the Docker socket mounted somewhere it shouldn't be.** `docker inspect <container> | grep docker.sock` across every running container - any hit outside a trusted, purpose-built management tool is a finding (see [Docker Attack Techniques](docker-attack-techniques.md) for why this is equivalent to host root).
5. **Check whether the daemon API is exposed on the network.** `nmap -p 2375,2376 <host>` from outside the host - an open, unauthenticated 2375 is an immediate critical finding (see [Real-World Docker Security Incidents](docker-real-world-incidents.md) for what happens when this is found by an attacker instead of you).

## Docker-Specific Things a Generic Web Pentest Methodology Misses

- **Socket breakout.** If you find the Docker socket mounted into a container you control, can you actually use it to launch a new privileged container and mount the host filesystem? (Lab-only - this is a full host compromise technique, never test against anything you don't own.)
- **Cross-container data leakage via shared volumes.** Two containers mounting the same named volume or bind mount can read/write each other's data regardless of any network-level isolation between them - check `docker inspect` for `Mounts` shared across containers that shouldn't trust each other.
- **Leftover build secrets in layers.** `docker history --no-trunc <image>` and `docker save <image> | tar -xO` to inspect individual layer contents - a secret passed via `ARG`/`ENV` at build time and "removed" in a later layer is still recoverable from the earlier layer.
- **Excess capabilities in practice, not just in the spec.** `docker inspect --format '{{.HostConfig.CapAdd}} {{.HostConfig.CapDrop}}' <container>` to see the actual granted set, then verify from inside the container (`capsh --print`) whether a capability you didn't expect the workload to need is actually usable.

## Real Practice Labs

| Lab | Focus |
|-----|-------|
| **[Vulhub](https://github.com/vulhub/vulhub)** | Large, actively maintained collection of pre-built vulnerable environments launched via Docker Compose, each reproducing a real, documented CVE (not synthetic challenges) - the closest thing to a "practice real-world exploits" lab for container-hosted applications |
| **[Kubernetes Goat](https://madhuakula.com/kubernetes-goat/)** | Primarily K8s-focused (see [Kubernetes Red Teaming & Labs](kubernetes-red-teaming-labs.md)), but its early modules cover container-level misconfigurations that apply directly to plain Docker too |

For the broader tool and lab catalog spanning both Docker and Kubernetes, see [Container Security Resources](container-security-resources.md) - this page intentionally stays narrow to Docker-specific testing technique, not a full tool list.

## Credits/References

1. [Docker Bench for Security](https://github.com/docker/docker-bench-security)
2. [Vulhub](https://github.com/vulhub/vulhub)
3. [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
