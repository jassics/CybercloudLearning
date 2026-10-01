# Network Security Red Teaming & Labs

## A Basic Network Security Assessment Methodology

1. **Recon and asset discovery.** Map what's actually reachable before testing anything: `nmap -sV -sC -p- target` for a full TCP port/service sweep, plus `nmap -sU --top-ports 100 target` for the UDP services generic scans miss (DNS, SNMP, NTP are common UDP findings). Compare the result against the organization's own asset inventory - the gap between "what we think is exposed" and "what's actually reachable" is itself a finding.
2. **Map the trust boundaries.** Using the segmentation model in [Network Security Overview](network-security-overview.md#segmentation-vlans-subnets-and-micro-segmentation), verify what each discovered host can actually reach - not just what's documented. A host in a "private" subnet that can still reach the internet directly, or two segments that are supposed to be isolated but aren't, is a common and high-impact finding.
3. **Test the perimeter control, not just its existence.** A firewall rule that exists on paper can still be misconfigured. Confirm NACLs/security groups/firewall rules actually block what they claim to - overly broad `0.0.0.0/0` inbound rules on management ports (22, 3389, 2375) are one of the most common real-world findings.
4. **Capture and analyze traffic.** `tcpdump`/Wireshark on a span port or representative host to confirm encryption is actually happening where it's claimed - plaintext credentials over Telnet/FTP/HTTP, or internal service-to-service traffic that isn't using mTLS even though the architecture doc says it should.
5. **Test DNS behavior.** Confirm whether internal DNS leaks to external resolvers, whether DNSSEC validation is actually enforced (not just configured), and whether unusually large or high-entropy DNS queries would be noticed (see [DNS Security](network-security-overview.md#dns-security)).
6. **Check IDS/IPS coverage, not just presence.** Run a known-signature test (e.g., an EICAR-over-HTTP test or a benign Nmap scan against a monitored segment) and confirm it's actually detected and alerted on - a deployed-but-untuned IDS generating no alerts is effectively absent.

## Things a Generic Pentest Methodology Misses at the Network Layer

- **ARP spoofing / local MITM.** On a flat, unsegmented LAN, `arpspoof`/`ettercap` can insert an attacker between a victim and the gateway, intercepting any traffic not protected by TLS. Generic web-app methodologies skip this because it requires L2 network access, not just an application endpoint - but it's exactly the attack an insider or a compromised device on the same segment can run.
- **DNS tunneling as a C2/exfil channel.** A web-focused assessment rarely inspects DNS query patterns. Lab-test this yourself with a tool like `iodine` or `dnscat2` against a sandboxed resolver, then check whether your own monitoring would have caught the high-volume, high-entropy subdomain queries that tunneling produces.
- **Lateral movement after a single host compromise.** Most methodologies stop at "we got a shell." The network-security-specific follow-up is: from that one host, what else is reachable that shouldn't be? This is where segmentation claims get tested for real, not on paper.
- **Exposed management interfaces.** Router/switch web UIs, exposed daemon APIs (see [Docker Red Teaming & Labs](../container-security/docker-red-teaming-labs.md#a-basic-docker-security-assessment-methodology) for the containerized equivalent), SNMP with default community strings (`public`/`private`) - these rarely show up in an application-layer scope but are routinely how real intrusions start.
- **IDS/IPS evasion basics.** Fragmentation, slow scans (`nmap -T1`), and protocol-level ambiguity are worth testing deliberately in a lab so you understand what your own detection stack would and wouldn't catch - this is blue-team-informing red-team work, not just "can I get past it."

!!! warning "Scope and authorization"
    Everything above - ARP spoofing, DNS tunneling, IDS evasion - is active interception/manipulation of network traffic. Only run these techniques against infrastructure you own or have explicit written authorization to test, and only in an isolated lab for anything beyond passive recon.

## Real Practice Labs

| Lab | Focus |
|-----|-------|
| **[TryHackMe - Network Fundamentals / Network Security modules](https://tryhackme.com/)** | Structured, guided rooms covering OSI/TCP-IP fundamentals, Nmap, Wireshark, and network service enumeration - the best starting point if you're new to the network layer specifically |
| **[PentesterLab PCAP exercises](https://pentesterlab.com/exercises/pcap_31)** | A series of short, focused Wireshark packet-analysis exercises (Telnet credential capture, DNS transaction-ID spoofing, ICMP covert channels, TLS SNI inspection) - excellent for building real packet-reading fluency rather than just running a tool |
| **[Hack The Box](https://www.hackthebox.com/)** | Full machine-based labs where network service enumeration and exploitation (not just web apps) are core to most boxes - good for combining recon methodology with real exploitation |

For the broader AppSec-focused lab catalog, see [AppSec Red Teaming & Labs](../application-security/appsec-red-teaming-labs.md) - this page intentionally stays narrow to network-layer technique.

## Credits/References

1. [Nmap Reference Guide](https://nmap.org/book/man.html)
2. [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/)
3. [PentesterLab PCAP Exercises](https://pentesterlab.com/exercises/pcap_31)
4. [TryHackMe](https://tryhackme.com/)
