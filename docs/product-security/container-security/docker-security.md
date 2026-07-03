# Docker Security

If you haven't yet, start with [Introduction to Docker](docker-introduction.md) for the fundamentals - this page assumes you know what an image and a container are, and focuses entirely on hardening them for production.

## The Docker Attack Surface

A container is not a security boundary by default - it's a process isolation mechanism. Containers share the host kernel, which means a container escape or kernel exploit can compromise the host and every other container on it. Docker security is about closing the gaps between "runs" and "runs safely":

| Layer | Risk if unhardened |
|-------|---------------------|
| Base image | Inherited CVEs, bloated attack surface, unnecessary packages |
| Dockerfile | Running as root, secrets baked into layers, writable filesystem |
| Registry | Pulling untrusted/unscanned images, `:latest` tag drift |
| Runtime | Excess Linux capabilities, host mounts, privileged mode |
| Host | Unpatched Docker daemon, exposed Docker socket |

## Hardening the Dockerfile

### Use Minimal or Distroless Base Images

Every package in your base image is attack surface you didn't need. Prefer `alpine`, `slim` variants, or [distroless](https://github.com/GoogleContainerTools/distroless) images that ship no shell, no package manager, nothing beyond your app's runtime dependencies.

### Run as a Non-Root User

```dockerfile
# Insecure - runs as root by default
FROM python:3.12
COPY . /app
WORKDIR /app
CMD ["python", "app.py"]
```

```dockerfile
# Hardened
FROM python:3.12-slim
RUN groupadd -r appuser && useradd -r -g appuser appuser
COPY --chown=appuser:appuser . /app
WORKDIR /app
USER appuser
CMD ["python", "app.py"]
```

If the container is compromised, a non-root process is far more limited in what it can do to the host or other containers sharing the kernel.

### Multi-Stage Builds

Keep build tools (compilers, dev dependencies) out of the final image entirely:

```dockerfile
FROM golang:1.22 AS build
WORKDIR /src
COPY . .
RUN go build -o /app

FROM gcr.io/distroless/base-debian12
COPY --from=build /app /app
USER nonroot:nonroot
ENTRYPOINT ["/app"]
```

The final image contains only the compiled binary - no Go toolchain, no source code, no shell to `exec` into.

### Never Bake Secrets Into Images

```dockerfile
# Insecure - secret is permanently in the image layer history
ARG API_KEY=sk-abc123
ENV API_KEY=${API_KEY}
```

Anyone with `docker history` or access to the image can extract that value, even from a layer that was later "overwritten." Use runtime secret injection instead (Docker secrets, Kubernetes Secrets/external-secrets, or environment variables set at container start - not build time).

## Runtime Hardening

- **Read-only root filesystem** - `docker run --read-only` (with explicit `tmpfs` mounts for anything that genuinely needs to write) prevents an attacker from persisting a payload inside the container filesystem.
- **Drop unnecessary Linux capabilities** - containers get a default capability set that's broader than almost any app needs. Drop everything and add back only what's required:

```bash
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE myapp
```

- **Never run `--privileged`** - this disables nearly all container isolation and gives the container full access to host devices. If you think you need it, you almost certainly need a specific capability instead.
- **Never mount the Docker socket into a container** (`-v /var/run/docker.sock:/var/run/docker.sock`) unless that container is a trusted, purpose-built management tool - it's equivalent to giving the container root on the host.
- **Set resource limits** (`--memory`, `--cpus`) to prevent a single compromised or buggy container from starving the host.

## Image Scanning

Every image you build or pull should be scanned for known CVEs before it runs - see [SCA](../application-security/sca.md) for the underlying dependency-scanning concept. For containers specifically:

```bash
# Trivy - fast, widely used in CI/CD
trivy image myapp:latest

# Grype - alternative scanner, pairs with Syft for SBOM generation
grype myapp:latest
```

Gate your CI/CD pipeline on critical/high findings, and re-scan images periodically even after they're deployed - new CVEs get published against base images you haven't rebuilt in weeks.

## Auditing Your Setup

[Docker Bench for Security](https://github.com/docker/docker-bench-security) runs a battery of checks against the CIS Docker Benchmark on a running host/daemon - it's the fastest way to get a "here's what's misconfigured" report:

```bash
docker run --rm --net host --pid host --userns host --cap-add audit_control \
  -v /var/lib:/var/lib -v /var/run/docker.sock:/var/run/docker.sock \
  -v /etc:/etc --label docker_bench_security \
  docker/docker-bench-security
```

## Best Practices Checklist

- [ ] Base image is minimal/distroless, pinned to a specific digest (not `:latest`)
- [ ] Container runs as a non-root `USER`
- [ ] Multi-stage build strips build tools from the final image
- [ ] No secrets in `ENV`, `ARG`, or layer history - injected at runtime instead
- [ ] Root filesystem is read-only where possible
- [ ] Unnecessary Linux capabilities dropped (`--cap-drop=ALL`, add back only what's needed)
- [ ] Never run with `--privileged` or mount the Docker socket into untrusted containers
- [ ] Images scanned for CVEs in CI/CD (Trivy/Grype) and gated on critical/high findings
- [ ] Resource limits set (`--memory`, `--cpus`)
- [ ] Docker daemon itself patched and audited (Docker Bench for Security)

## Credits/References

1. [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
2. [Docker Bench for Security](https://github.com/docker/docker-bench-security)
3. [OWASP Docker Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
4. [Google Distroless Images](https://github.com/GoogleContainerTools/distroless)
5. [Trivy Documentation](https://aquasecurity.github.io/trivy/)
