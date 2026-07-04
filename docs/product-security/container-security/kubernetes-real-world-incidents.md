# Real-World Kubernetes Security Incidents

Abstract hardening advice ("enable RBAC," "don't expose the dashboard") lands very differently once you've seen exactly how skipping it played out in production. Every incident below is real, dated, and sourced - use it to pattern-match against [Kubernetes Attack Techniques](kubernetes-attack-techniques.md) and the [OWASP Kubernetes Top 10](owasp-kubernetes-top10.md).

## Exposed Components & Cluster-to-Cloud Lateral Movement

**Tesla Kubernetes Dashboard Cryptojacking (discovered Feb 2018)**

Security firm RedLock discovered that one of Tesla's Kubernetes administration consoles was running with no password protection at all, reachable from the internet. Attackers used that open access to deploy cryptocurrency-mining pods running the Stratum mining protocol, and took real steps to stay hidden - connecting to an unlisted mining pool endpoint, hiding the pool server's IP behind Cloudflare, and reportedly keeping CPU usage low to avoid obvious detection. Critically, the compromised pods also had access to Tesla's AWS credentials, which in turn exposed non-public Tesla data stored in S3 - Tesla stated it saw no evidence of impact to customer data or vehicle safety/security.

*Category: maps to OWASP Kubernetes Top 10 K06 (Overly Exposed Kubernetes Components) escalating into K08 (Cluster to Cloud Lateral Movement) - see [OWASP Kubernetes Top 10](owasp-kubernetes-top10.md). Lesson: an unauthenticated management console is not a low-severity finding - it's a direct path to whatever cloud credentials the cluster's workloads carry. Never expose the Kubernetes Dashboard (or any admin console) without authentication, and scope workload cloud-IAM roles tightly enough that compromising one pod doesn't hand over the whole account (see [Cluster-to-Cloud Lateral Movement](kubernetes-attack-techniques.md#cluster-to-cloud-lateral-movement)).*

## Control-Plane Privilege Escalation Vulnerabilities

**CVE-2018-1002105: Kubernetes API Server Privilege Escalation (disclosed Dec 2018)**

Described at the time as the most severe vulnerability found in Kubernetes to date. The flaw was in how `kube-apiserver` handled error responses to proxied "upgrade" requests (the mechanism behind `kubectl exec`/`attach`/port-forward): a specially crafted request let an attacker establish a connection through the API server to a backend service, then send arbitrary follow-on requests directly to that backend - authenticated using the *API server's own* TLS credentials instead of the requester's actual permissions. In the default configuration this let any authenticated user escalate to cluster-admin-equivalent access against any backend; in some configurations it required no authentication at all. It scored CVSS 3.0 9.8 (Critical) and affected every Kubernetes release prior to v1.10.11, v1.11.5, and v1.12.3.

*Category: maps to OWASP Kubernetes Top 10 K07 (Misconfigured and Vulnerable Cluster Components) and K09 (Broken Authentication Mechanisms) - see [OWASP Kubernetes Top 10](owasp-kubernetes-top10.md) and [Privilege Escalation Within a Cluster](kubernetes-attack-techniques.md#privilege-escalation-within-a-cluster). Lesson: this was a control-plane bug, not a misconfiguration - no amount of RBAC tuning would have stopped it. Keeping the API server itself on a patched, supported version is a security control in its own right, not just an operational nicety.*

## Container Runtime Escape Vulnerabilities

**CVE-2019-5736: runc Container Escape (disclosed Feb 2019)**

A vulnerability in `runc` - the low-level container runtime used underneath Docker, containerd, and CRI-O across essentially the entire container ecosystem, including most Kubernetes clusters - allowed a malicious or already-compromised container to overwrite the *host's* `runc` binary via a file-descriptor mishandling bug involving `/proc/self/exe`. Once overwritten, the next invocation of `runc` on that host (e.g. starting or `exec`-ing into any container) would run the attacker's code as host root. Exploiting it required no privileged container mode and no unusual configuration - just running a malicious image.

*Category: container escape at the runtime layer, not the orchestrator layer - see [Container Escape / Breakout](kubernetes-attack-techniques.md#container-escape--breakout). Lesson: cluster hardening (RBAC, NetworkPolicy, Pod Security) all assume the container boundary itself holds. Patching the container runtime is a foundational, non-optional layer underneath every other Kubernetes security control.*

## Credits/References

1. [RedLock/Palo Alto Networks: Hackers Hijack Tesla's Cloud System to Mine Cryptocurrency - CNBC](https://www.cnbc.com/2018/02/21/hackers-hijack-teslas-cloud-system-to-mine-cryptocurrency-redlock.html)
2. [Tesla Drives Cryptojack Gang's AWS Cloud Down Kubernetes Avenue - TechBeacon](https://techbeacon.com/security/tesla-drives-cryptojack-gangs-aws-cloud-down-kubernetes-avenue)
3. [CVE-2018-1002105 - NVD](https://nvd.nist.gov/vuln/detail/CVE-2018-1002105)
4. [CVE-2019-5736 - runc container escape, Palo Alto Networks Unit 42 writeup](https://unit42.paloaltonetworks.com/breaking-docker-via-runc-explaining-cve-2019-5736/)
5. [Kubernetes Official Security Announcements](https://kubernetes.io/docs/reference/issues-security/security/)
