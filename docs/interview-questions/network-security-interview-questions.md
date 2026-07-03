# Network Security Interview Questions

The [security-interview-questions](https://github.com/jassics/security-interview-questions) repo's Network Security file is still empty upstream, so these questions are grounded directly in this site's [Network Security Overview](../product-security/network-security/network-security-overview.md) instead. Expect them to get merged back once the source repo catches up.

## Defense in Depth & Segmentation

??? question "Q: Why does network security still matter in a cloud-native, API-first world?"
    Because a lot of real attacks happen or get *contained* at the network layer regardless of architecture - lateral movement after an initial compromise, data exfiltration, DDoS, and misconfigured internal services accidentally exposed to the internet. Application-layer security tells you how an attacker gets in; network security largely determines how far they can go once they're in. A security engineer needs enough network fluency to reason about blast radius, not just app-layer flaws.

??? question "Q: You're asked 'how would you segment this architecture?' in an interview. What's the wrong way to answer, and what's the right way?"
    The wrong way is describing segmentation abstractly - "I'd use VLANs and subnets." The right way starts from a data flow diagram: figure out *what actually needs to talk to what*, then deny everything else by default. Concretely: VLANs separate broadcast domains at Layer 2 so a compromised device can't directly see traffic on another VLAN; subnetting (public/private split in a cloud VPC) keeps databases and internal services off any public IP; and micro-segmentation goes further still, applying firewall rules between individual workloads/pods rather than whole network zones - see the [Kubernetes NetworkPolicy example](../product-security/container-security/kubernetes-security.md) for what that looks like concretely at the pod level.

??? question "Q: Explain the difference between AWS Security Groups and NACLs, and why you'd use both together."
    Security Groups are **stateful** and apply at the instance level - if you allow inbound traffic on a port, the matching outbound return traffic is automatically allowed, and rules are evaluated as an allow-list. NACLs are **stateless** and apply at the subnet level - they evaluate every packet independently in both directions, and support explicit deny rules, which Security Groups don't. You use both together for defense in depth: NACLs as a coarse subnet-wide backstop, Security Groups for fine-grained per-instance control. If a Security Group is accidentally misconfigured too permissively, a tightly scoped NACL at the subnet boundary can still limit the blast radius.

## Firewalls, IDS/IPS & Zero Trust

??? question "Q: Walk through the difference between a stateless packet filter, a stateful firewall, and a next-gen firewall (NGFW)."
    A **stateless packet filter** allows/denies each packet independently based on IP/port/protocol, with no awareness of connection state. A **stateful firewall** tracks connection state and only allows return traffic for connections that were actually established - closing off a lot of spoofing tricks that work against pure packet filters. An **NGFW** adds deep packet inspection, application-layer awareness, intrusion prevention, and often TLS inspection - it can tell the difference between "port 443 traffic" and "port 443 traffic that's actually a disguised non-HTTPS protocol," at the cost of more tuning to avoid false positives.

??? question "Q: What's the difference between IDS and IPS, and between signature-based and anomaly-based detection?"
    An **IDS** monitors traffic and alerts - it doesn't block anything. An **IPS** sits inline and actively blocks traffic matching known-bad signatures or anomalous patterns. Separately, **signature-based** detection matches known attack patterns fast and reliably but misses zero-days by definition; **anomaly-based** detection can catch novel attacks by flagging deviation from a baseline, but tends to have a higher false-positive rate. Most real deployments run both detection styles together, and often both IDS (for visibility/tuning without risking false-positive outages) and IPS (for active blocking) at different chokepoints.

??? question "Q: Explain Zero Trust Network Access and why it's different from a traditional VPN model."
    Traditional VPN grants broad network-level access once connected - if the device or credentials are compromised, the attacker often gets lateral access to everything reachable on that network segment. Zero Trust flips the model: there's no implicit trust based on network location at all; every request is authenticated and authorized *per-resource*, regardless of whether it originates "inside" or "outside" the traditional perimeter. In shorthand: traditional VPN is "user connects to a trusted network, then can reach most internal systems," while ZTNA is "user authenticates per-request, and only reaches the specific app/service they were explicitly granted." This is the idea behind Google's BeyondCorp model and products like Zscaler or Cloudflare Access.

## DNS & Common Attacks

??? question "Q: What is DNS tunneling, and what would you actually look for in logs to detect it?"
    DNS tunneling disguises data exfiltration or command-and-control traffic as DNS queries, since DNS is almost always allowed outbound even in restrictive network environments. In logs, the tells are: unusually long or high-entropy subdomains (encoded data smuggled into the subdomain field), an abnormally high query volume directed at a single domain, and query patterns that don't match normal browsing/resolution behavior. Mitigations include DNS filtering/monitoring at the resolver, restricting which resolvers are used at all, and DNSSEC to prevent a *different* but related class of DNS attack (spoofing/cache poisoning) by cryptographically signing responses.

??? question "Q: Explain ARP spoofing and how you'd defend against it on a local network."
    ARP spoofing works because ARP has no built-in authentication - an attacker sends forged ARP replies claiming their MAC address corresponds to a victim's IP (often the default gateway), so traffic meant for that IP gets routed through the attacker's machine instead, enabling a man-in-the-middle position on the local network. Defenses live at the switch layer: Dynamic ARP Inspection (validates ARP packets against a trusted binding table, typically built from DHCP snooping) and port security (limiting which MAC addresses are allowed on a given switch port).

## Practice Next

- [Network Security Overview](../product-security/network-security/network-security-overview.md)
- [Network Security Study Plan](../study-plan/cybersecurity/network-security-study-plan.md)
- [Kubernetes Security](../product-security/container-security/kubernetes-security.md) for micro-segmentation in practice
- [security-interview-questions](https://github.com/jassics/security-interview-questions) on GitHub for the canonical, evolving question set
