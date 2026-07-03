# Network Security Overview

## Why Network Security Still Matters in a Cloud/App-First World

Even with workloads moving to cloud-native and API-driven architectures, the network layer is still where a lot of real attacks happen or get contained - lateral movement after an initial compromise, data exfiltration, DDoS, and misconfigured exposure of internal services to the internet. A security engineer needs enough network fluency to reason about blast radius, not just application-layer flaws.

## Defense in Depth at the Network Layer

No single control should be your only line of defense. A typical layered model:

| Layer | Control |
|-------|---------|
| Perimeter | Firewall, WAF, DDoS protection |
| Segmentation | VLANs, subnets, security groups/NACLs |
| Access | VPN / Zero Trust Network Access (ZTNA), NAC |
| Detection | IDS/IPS, network traffic analysis |
| Encryption | TLS in transit, VPN tunnels, IPsec |

## Segmentation: VLANs, Subnets, and Micro-Segmentation

- **VLANs** separate broadcast domains at Layer 2 - stops a compromised device on one VLAN from directly seeing traffic on another.
- **Subnetting** (public/private subnet split in cloud VPCs) limits what's directly internet-reachable - databases and internal services belong in private subnets with no public IP.
- **Micro-segmentation** goes further: firewall rules between individual workloads/pods, not just network zones - so a compromised container can't freely talk to every other service (see [Kubernetes Security](../container-security/kubernetes-security.md) for a concrete NetworkPolicy example).

**Job-interview framing:** if asked "how would you segment this architecture," always start from *what needs to talk to what* (a data flow diagram) and deny everything else by default - don't just describe VLANs abstractly.

## Firewalls: Stateful vs. Next-Gen

| Type | What it does | Limitation |
|------|---------------|------------|
| **Stateless packet filter** | Allows/denies based on IP/port/protocol per packet | No awareness of connection state |
| **Stateful firewall** | Tracks connection state, only allows return traffic for established connections | Still blind to application-layer content |
| **Next-Gen Firewall (NGFW)** | Adds deep packet inspection, application awareness, intrusion prevention, TLS inspection | More expensive, needs tuning to avoid false positives |

Cloud equivalents: AWS Security Groups (stateful, instance-level) vs. NACLs (stateless, subnet-level) - a very common interview question is explaining why you'd use both together.

## IDS/IPS

- **IDS (Intrusion Detection System)** - monitors and alerts, doesn't block traffic.
- **IPS (Intrusion Prevention System)** - sits inline and actively blocks traffic matching known-bad signatures/anomalies.
- Signature-based detection catches known attacks fast but misses zero-days; anomaly-based detection catches novel attacks but has a higher false-positive rate. Most real deployments run both.

## VPNs and Zero Trust Network Access (ZTNA)

Traditional VPN grants broad network-level access once connected - if the device or credentials are compromised, the attacker often gets lateral access to everything on that network. **Zero Trust** flips the model: no implicit trust based on network location, every request is authenticated/authorized per-resource regardless of whether it originates "inside" or "outside" the perimeter.

```
Traditional:  User --VPN--> [Trusted Network] --> can reach most internal systems
Zero Trust:   User --ZTNA--> per-request authz --> only the specific app/service granted
```

This is the underlying idea behind BeyondCorp (Google), and commercial ZTNA products (Zscaler, Cloudflare Access, Tailscale).

## DNS Security

DNS is a common blind spot:

- **DNS spoofing/cache poisoning** - attacker returns a forged IP for a domain, redirecting victims to a malicious server.
- **DNS tunneling** - attackers exfiltrate data or run C2 traffic disguised as DNS queries (a classic thing to look for in logs: unusually long/high-entropy subdomains, high query volume to a single domain).
- **Mitigations**: DNSSEC (cryptographically signs DNS responses), restricting recursive resolvers, DNS filtering/monitoring (e.g. blocking known malicious domains at the resolver).

## Common Network Attacks and Mitigations

| Attack | How it works | Mitigation |
|--------|---------------|------------|
| **ARP Spoofing** | Attacker sends forged ARP replies to associate their MAC with a victim's IP, enabling MITM on a local network | Dynamic ARP inspection, port security on switches |
| **DNS Poisoning** | Forged DNS responses redirect victims to malicious hosts | DNSSEC, trusted resolvers |
| **Man-in-the-Middle (MITM)** | Attacker intercepts traffic between two parties | TLS everywhere, certificate pinning, HSTS |
| **DDoS** | Overwhelming a target with traffic/requests to exhaust resources | Rate limiting, CDN/scrubbing services (Cloudflare, AWS Shield), autoscaling with limits |
| **Port Scanning / Recon** | Attacker probes open ports/services to map attack surface | Minimize exposed services, IDS alerting on scan patterns, rate-limit connection attempts |

## OSI Model to Security Controls

| OSI Layer | Example Controls |
|-----------|-------------------|
| Layer 2 (Data Link) | Port security, dynamic ARP inspection, VLAN segmentation |
| Layer 3 (Network) | Firewalls, NACLs, routing/segmentation |
| Layer 4 (Transport) | Security groups (stateful), TCP/UDP filtering |
| Layer 7 (Application) | WAF, NGFW deep packet inspection, API gateways |

## Hands-On Tools Every Security Engineer Should Know

- **nmap** - port scanning and service/version discovery (`nmap -sV -p- target`) - used both offensively and for your own asset inventory.
- **Wireshark** - packet capture and protocol analysis GUI - essential for diagnosing "why is this connection failing" or investigating suspicious traffic.
- **tcpdump** - CLI packet capture, useful on servers without a GUI (`tcpdump -i eth0 host 10.0.0.5 -w capture.pcap`).
- **Zeek (formerly Bro)** - network security monitoring, generates structured logs of network activity for detection/investigation.

## Best Practices Checklist

- [ ] Default-deny network policies, explicit allow-lists for required traffic only
- [ ] Public-facing services isolated in a DMZ/public subnet, data stores in private subnets with no direct internet route
- [ ] TLS enforced for all traffic, including internal service-to-service where feasible (mTLS)
- [ ] DNSSEC enabled where supported, DNS query logging retained for investigation
- [ ] IDS/IPS deployed at key chokepoints, tuned to reduce alert fatigue
- [ ] Regular network segmentation review - verify segmentation actually matches the intended trust boundaries

## Credits/References

1. [OWASP Foundation](https://owasp.org/)
2. [NIST SP 800-41: Guidelines on Firewalls and Firewall Policy](https://csrc.nist.gov/pubs/sp/800/41/r1/final)
3. [Google BeyondCorp (Zero Trust)](https://cloud.google.com/beyondcorp)
4. [Zeek Network Security Monitor](https://zeek.org/)
