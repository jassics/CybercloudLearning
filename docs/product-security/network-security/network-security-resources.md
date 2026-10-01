# Network Security Resources

## Standards & Frameworks

| Standard | Focus |
|----------|-------|
| [NIST SP 800-41: Guidelines on Firewalls and Firewall Policy](https://csrc.nist.gov/pubs/sp/800/41/r1/final) | Firewall architecture and policy fundamentals |
| [NIST SP 800-53](https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final) | Security and privacy controls, including the System and Communications Protection (SC) family |
| [MANRS (Mutually Agreed Norms for Routing Security)](https://www.manrs.org/) | Industry-driven BGP/routing security best practices |
| [CIS Controls v8](https://www.cisecurity.org/controls) | Control 12 (Network Infrastructure Management) and Control 13 (Network Monitoring and Defense) |

## Books

1. [Network Security Essentials (William Stallings)](https://www.amazon.com/Network-Security-Essentials-Applications-Standards/dp/0135823170/) - foundational textbook covering cryptography through to network-layer controls
2. [Practical Packet Analysis (Chris Sanders)](https://www.amazon.com/Practical-Packet-Analysis-3rd-Wireshark/dp/1593278025/) - the standard reference for learning Wireshark-driven investigation
3. [The Practice of Network Security Monitoring (Richard Bejtlich)](https://nostarch.com/nsm) - NSM methodology, written by a former Air Force/Mandiant/GE threat hunter

## Courses & Certifications

- [CompTIA Security+](https://www.comptia.org/certifications/security) - entry-level, covers network security fundamentals alongside broader security topics
- [CompTIA Network+](https://www.comptia.org/certifications/network) - vendor-neutral networking fundamentals, a strong prerequisite before specializing in network security
- [(ISC)² SSCP](https://www.isc2.org/certifications/sscp) - covers network and communications security as one of its domains
- [TryHackMe - Network Fundamentals](https://tryhackme.com/) - guided, hands-on rooms covering OSI/TCP-IP, Nmap, and traffic analysis

## Tools

### Traffic Capture & Analysis

| Tool | Purpose |
|------|---------|
| [Wireshark](https://www.wireshark.org/) | GUI packet capture and protocol analysis - the de facto standard |
| [tcpdump](https://www.tcpdump.org/) | CLI packet capture, available on nearly every Unix-like system including headless servers |
| [Zeek](https://zeek.org/) (formerly Bro) | Network security monitoring - generates structured, queryable logs of network activity rather than raw packet dumps |

### Intrusion Detection / Prevention

| Tool | Purpose |
|------|---------|
| [Suricata](https://suricata.io/) | High-performance, open-source IDS/IPS with native multi-threading and protocol-aware detection |
| [Snort](https://www.snort.org/) | The original widely-deployed open-source IDS/IPS, rule-based signature detection |
| [Security Onion](https://securityonionsolutions.com/) | Free, source-available Linux distribution bundling Suricata, Zeek, Elasticsearch, Kibana, and CyberChef into a ready-to-deploy NSM/threat-hunting platform |

### Recon & Scanning

- [Nmap](https://nmap.org/) - port scanning, service/version detection, and scriptable recon (`nmap -sV -sC -p- target`)
- [Masscan](https://github.com/robertdavidgraham/masscan) - internet-scale port scanner, orders of magnitude faster than Nmap for broad sweeps (pair with Nmap for detail on found ports)

## Hands-On Labs & CTFs

See [Network Security Red Teaming & Labs](network-red-teaming-labs.md) for full methodology and the practice-lab list (TryHackMe, PentesterLab PCAP exercises, Hack The Box) - this page intentionally stays a reference index, not a duplicate of that content.

## Blogs & Research

- [MANRS Blog](https://www.manrs.org/blog/) - routing security advocacy and incident analysis
- [Kentik Blog](https://www.kentik.com/blog/) - BGP/network observability research, including historical incident write-ups
- [Cloudflare Blog - Security](https://blog.cloudflare.com/tag/security/) - frequent deep dives on DDoS, DNS, and BGP incidents as they happen
- [Krebs on Security](https://krebsonsecurity.com/) - investigative reporting that frequently covers botnet/DDoS/infrastructure attacks in depth

## Where to Go Next on This Site

- [Network Security Overview](network-security-overview.md) for foundations - segmentation, firewalls, IDS/IPS, VPN/ZTNA, DNS security
- [Network Security Red Teaming & Labs](network-red-teaming-labs.md) to practice
- [Real-World Network Security Incidents](network-security-incidents.md) to learn from real breaches
- [Cloud Security Resources](../cloud-security/cloud-security-resources.md) for the cloud-native equivalent of network segmentation (security groups, NACLs, VPC design)
- [Network Security Interview Questions](../../interview-questions/network-security-interview-questions.md) to self-test
- [Network Security Study Plan](../../study-plan/cybersecurity/network-security-study-plan.md) for a structured path through this domain

## Credits/References

1. [NIST SP 800-41: Guidelines on Firewalls and Firewall Policy](https://csrc.nist.gov/pubs/sp/800/41/r1/final)
2. [MANRS](https://www.manrs.org/)
3. [Zeek Network Security Monitor](https://zeek.org/)
4. [Security Onion](https://securityonionsolutions.com/)
