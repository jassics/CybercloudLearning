# Real-World Network Security Incidents

Abstract advice like "segment your network" or "don't trust unauthenticated DNS/BGP" lands very differently once you've seen exactly how skipping it played out at internet scale. Every incident below is real, dated, and sourced - use it to pattern-match against [Network Security Overview](network-security-overview.md).

## DNS Infrastructure Attacks

**Mirai Botnet DDoS Against Dyn (October 21, 2016)**

On October 21, 2016, Dyn - a major managed DNS provider - was hit by three consecutive, massive DDoS attacks described by Dyn as "a sophisticated, highly distributed attack involving 10s of millions of IP addresses." The attacks ran from roughly 11:07 to 16:55 UTC in waves, flooding Dyn's DNS infrastructure with SYN floods and recursive DNS retry traffic targeting port 53. The Mirai botnet - built from a hundred thousand compromised IoT devices (cameras, routers, DVRs) hijacked via default/weak factory credentials over Telnet - was confirmed as the primary source. Because dozens of major platforms (Twitter, GitHub, Netflix, PayPal, Reddit, Amazon, and more) relied on Dyn for DNS resolution, their services became unreachable for large parts of the US and Europe even though none of those companies' own infrastructure was attacked directly.

*Category: DNS availability / IoT botnet DDoS. Lesson: DNS is a single point of failure most architectures don't treat with the same rigor as their own infrastructure - relying on one DNS provider with no fallback creates a blast radius far beyond anything you directly control. This is also the canonical case for why IoT/default-credential hygiene (see [Network Security Overview: Common Attacks](network-security-overview.md#common-network-attacks-and-mitigations)) is a network-wide concern, not just a device owner's problem.*

## BGP Hijacking

**Pakistan Telecom Hijacks YouTube's IP Space (February 24, 2008)**

After the Pakistani government ordered ISPs to block YouTube domestically, Pakistan Telecom (AS17557) attempted to black-hole the traffic internally by announcing a more specific BGP route (208.65.153.0/24) for part of YouTube's address space pointing to a null interface. Pakistan Telecom's upstream provider, PCCW (AS3491), did not validate this route announcement against YouTube's legitimate ownership (RIR allocation/IRR records) and propagated it globally. Because BGP's longest-prefix-match rule prefers more specific routes, routers worldwide began sending YouTube-bound traffic to Pakistan Telecom instead, making YouTube unreachable for most of the internet for roughly two hours. YouTube regained reachability by countering with two even-more-specific sub-announcements (208.65.153.0/25 and 208.65.153.128/25) once PCCW withdrew the bad route.

*Category: routing-layer trust failure. Lesson: BGP has no built-in authentication - any network can announce routes for address space it doesn't own, and the entire internet's routing table largely runs on implicit trust between providers. This is the real-world justification for RPKI (Resource Public Key Infrastructure) and route-origin validation, which didn't exist in any meaningful deployment in 2008 and are still incompletely deployed today.*

## Amplification DDoS

**Memcached-Amplified DDoS Against GitHub (February 28, 2018)**

On February 28, 2018, GitHub was hit by the largest DDoS attack publicly recorded at the time, peaking at 1.35 Tbps and 126.9 million packets per second. Rather than using a compromised-device botnet like Mirai, attackers abused roughly 88,000+ internet-exposed Memcached servers that had no authentication and responded to spoofed UDP requests on port 11211. A tiny spoofed request could trigger a response tens of thousands of times larger - Cloudflare measured an amplification factor as high as 51,200x - letting a modest number of attacker-controlled requests generate an overwhelming flood directed at GitHub's IP space. GitHub had DDoS scrubbing already in place and the attack was mitigated within about 10-20 minutes with no significant downtime; a second, smaller wave (~400 Gbps) followed roughly 30 minutes later.

*Category: UDP reflection/amplification DDoS. Lesson: an unauthenticated, internet-reachable service with a tiny-request/huge-response ratio is a force-multiplier for anyone, not just its intended users - this is the same underlying principle behind DNS and NTP amplification attacks. The fix is at the source (Memcached should never be exposed to the internet, full stop) as much as at the target (scrubbing/CDN capacity).*

## VPN Exploitation

**CVE-2019-11510: Pulse Secure VPN Arbitrary File Read (disclosed April 2019, mass-exploited from August 2019)**

Pulse Secure patched CVE-2019-11510 in April 2019: an unauthenticated, remote arbitrary file-read vulnerability in Pulse Connect Secure SSL-VPN appliances that could expose session databases, cleartext credentials, and NTLM hashes - and could be chained with a separate remote command-injection bug (CVE-2019-11539) for full compromise. After researchers detailed the vulnerability at Black Hat/DEF CON in early August 2019 and a public proof-of-concept followed, mass exploitation began almost immediately. Scans found hundreds of vulnerable organizations across multiple countries still unpatched months later. Threat actors used the flaw to breach a US financial entity's research network and a US municipal government network in August 2019 alone, and it was later used as an initial-access vector to deploy Sodinokibi/REvil ransomware (Travelex was among the victims). In August 2020, plaintext credentials for 900+ Pulse Secure VPN servers were dumped on an underground forum - CISA continued observing active exploitation against unpatched systems for years, and warned that even patched organizations remained compromised if they hadn't also rotated credentials stolen before the patch was applied.

*Category: VPN appliance / perimeter access control failure. Lesson: a VPN is meant to be the trusted gateway into your internal network - when the VPN appliance itself is the vulnerability, the entire "trusted inside vs. untrusted outside" model in [Network Security Overview: VPNs and Zero Trust Network Access](network-security-overview.md#vpns-and-zero-trust-network-access) collapses at once. Patching alone is not remediation if credentials were already exfiltrated before the patch landed - this is a strong practical argument for Zero Trust Network Access over broad network-level VPN trust.*

## Credits/References

1. [DDoS attacks on Dyn - Wikipedia](https://en.wikipedia.org/wiki/DDoS_attacks_on_Dyn)
2. [DDoS On Dyn Used Malicious TCP, UDP Traffic - Dark Reading](https://www.darkreading.com/cyberattacks-data-breaches/ddos-on-dyn-used-malicious-tcp-udp-traffic)
3. [YouTube Hijacking (February 24th, 2008): Analysis of BGP Routing Dynamics - Google Research](https://research.google/pubs/youtube-hijacking-february-24th-2008-analysis-of-bgp-routing-dynamics/)
4. [A Brief History of the Internet's Biggest BGP Incidents - Kentik](https://www.kentik.com/blog/a-brief-history-of-the-internets-biggest-bgp-incidents/)
5. [Biggest-Ever DDoS Attack (1.35 Tbps) Hits GitHub - The Hacker News](https://thehackernews.com/2018/03/biggest-ddos-attack-github.html)
6. [The world's largest DDoS attack took GitHub offline for fewer than 10 minutes - TechCrunch](https://techcrunch.com/2018/03/02/the-worlds-largest-ddos-attack-took-github-offline-for-less-than-tens-minutes/)
7. [Continued Exploitation of Pulse Secure VPN Vulnerability - CISA AA20-010A](https://www.cisa.gov/news-events/cybersecurity-advisories/aa20-010a)
8. [Continued Threat Actor Exploitation Post Pulse Secure VPN Patching - CISA AA20-107A](https://www.cisa.gov/news-events/cybersecurity-advisories/aa20-107a)
9. [Vulnerable Private Networks: Corporate VPNs Exploited in the Wild - Volexity](https://www.volexity.com/blog/2019/09/11/vulnerable-private-networks-corporate-vpns-exploited-in-the-wild/)
