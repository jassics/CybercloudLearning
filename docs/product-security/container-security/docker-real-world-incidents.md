# Real-World Docker Security Incidents

Abstract advice like "don't expose the daemon API" or "scan your images" lands very differently once you've seen exactly how skipping it played out at scale. Every incident below is real, dated, and sourced - use it to pattern-match against [Docker Security](docker-security.md) and [Docker Attack Techniques](docker-attack-techniques.md).

## Registry & Supply Chain

**Docker Hub Data Breach (disclosed April 25, 2019)**

Docker disclosed unauthorized access to a Docker Hub database affecting an estimated 190,000 accounts - under 5% of Docker Hub's user base at the time. The exposed data included usernames and password hashes for a subset of those accounts, plus GitHub and Bitbucket access tokens used for Docker autobuilds. Docker reset affected passwords, revoked the exposed GitHub/Bitbucket tokens, and had affected users reconnect their repositories. Docker stated official images were not impacted.

*Category: registry/platform compromise, not a Docker Engine vulnerability. Lesson: a container registry is itself a high-value target - the tokens it stores can pivot an attacker directly into your source repositories, not just your image supply. Treat registry credentials and build tokens with the same care as any other secret (see [Secure Coding](../application-security/secure-coding.md)).*

**Unit 42 "20 Million Miners": Cryptojacking Images on Docker Hub (published March 26, 2021)**

Palo Alto Networks' Unit 42 identified 30 malicious images across 10 Docker Hub accounts that had been collectively pulled over 20 million times, deploying XMRig-based Monero cryptominers on unsuspecting users' infrastructure. Researchers estimated the campaigns had mined roughly $200,000 worth of cryptocurrency. A related, separately-disclosed account ("azurenql") hosted six malicious mining images pulled more than 2 million times on its own, and Unit 42 also documented "Graboid," a self-propagating cryptojacking worm that spread between hosts via exposed Docker daemons and pulled its payload from Docker Hub.

*Category: supply-chain/typosquatting - malicious images published under names resembling legitimate projects (or simply left undetected long enough to rack up millions of pulls). Lesson: "it's on Docker Hub" is not a trust signal. Pin images to a digest from a known-good, actively maintained publisher, and scan every image you pull - not just the ones you build yourself (see [Docker Security: Image Scanning](docker-security.md#image-scanning)).*

## Exposed Daemon Exploitation

**Kinsing Malware Campaign Targeting Exposed Docker APIs (ongoing, first widely reported 2020, continuously active since)**

Aqua Security's research team has tracked an long-running, large-scale campaign in which the Kinsing malware scans the internet for Docker hosts with an unauthenticated daemon API exposed (the classic `-H tcp://0.0.0.0:2375` misconfiguration), then uses that access to launch a container that disables competing malware/cryptominers, harvests SSH credentials and known_hosts from the host to spread laterally across a network, and finally deploys a cryptominer. Aqua reported thousands of exploitation attempts occurring daily against exposed Docker APIs, run by an operator with sustained infrastructure - not an opportunistic one-off.

*Category: exposed management interface, directly matching the daemon-exposure risk already flagged in [Docker Security](docker-security.md#runtime-hardening). Lesson: an exposed, unauthenticated Docker API is not a theoretical risk - it is actively, continuously scanned for and exploited at internet scale within hours of exposure. Never bind the daemon API to `0.0.0.0` without TLS client-certificate authentication, and treat any host that briefly exposed it as compromised until proven otherwise.*

## Runtime Escape

**CVE-2019-5736: runc Container Escape** - covered in full on [Kubernetes Real-World Incidents](kubernetes-real-world-incidents.md#container-runtime-escape-vulnerabilities), since `runc` underlies Docker, containerd, and CRI-O alike. The short version: a malicious container could overwrite the host's `runc` binary via a `/proc/self/exe` file-descriptor bug, achieving host root the next time `runc` ran on that host - with no privileged mode or unusual configuration required. See [Docker Attack Techniques](docker-attack-techniques.md) for the mechanism.

## Credits/References

1. [Docker Hub Breach Hits 190,000 Accounts - SecurityWeek](https://www.securityweek.com/docker-hub-breach-hits-190000-accounts/)
2. [190,000 Users Affected by Docker Hub's Security Breach - Snyk](https://snyk.io/blog/190000-users-affected-by-docker-hubs-security-breach-now-what/)
3. [20 Million Miners: Finding Malicious Cryptojacking Images in Docker Hub - Unit 42](https://unit42.paloaltonetworks.com/malicious-cryptojacking-images/)
4. [Graboid: First-Ever Cryptojacking Worm Found in Images on Docker Hub - Unit 42](https://unit42.paloaltonetworks.com/graboid-first-ever-cryptojacking-worm-found-in-images-on-docker-hub/)
5. [Misconfigured Docker Daemon API Ports Attacked for Kinsing Malware Campaign - Aqua Security](https://www.aquasec.com/blog/threat-alert-kinsing-malware-container-vulnerability/)
