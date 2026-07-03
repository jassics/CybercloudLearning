# Network Security Study Plan

This page is updated based on [jassics/security-study-plan/network-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/network-security-study-plan.md)

This plan assumes you already have some basic computer science skills (Linux basics, common Windows/macOS use, searching the internet, editing a file). See the [Common Security Skills study plan](../common-skills-study-plan.md) first if you need to shore those up.

**What is network security?** It includes all methods, both defensive and offensive, used to protect and keep a network functional.

This plan has three objectives, in short:

- Understand networks and how they work
- Understand common vulnerabilities and how to detect them
- Learn how to remedy those vulnerabilities and secure a network

## ToC
1. [Network Fundamentals](#network-fundamentals) - 2 weeks
2. [Network Defense](#network-defense) - 2 weeks
3. [Network Attacks and Analysis](#network-attacks-and-analysis) - 2 weeks
4. [Wireless and Advanced Topics](#wireless-and-advanced-topics) - 2 weeks
5. [Resources](#resources)

## Network Fundamentals
**Duration: 2 weeks**

Focus on the basic concepts of networks: architectures, protocols, and the OSI model. See this site's own [Network Security Overview](../../product-security/network-security/network-security-overview.md) alongside this section.

### Week 1-2: Core Concepts
1. **OSI & TCP/IP Models:** layers and encapsulation
2. **Protocols:** IP, TCP, UDP, ICMP, DNS, DHCP, HTTP/HTTPS, SSH
3. **Addressing:** IPv4, IPv6, subnetting, MAC addresses
4. **Routing & Switching:** basics of how data moves

**Resources:**

- [Networking for Ethical Hackers](https://www.youtube.com/playlist?list=PLLKT__MCUeiyUKmYaakznsZeU4lZYwt_j) from The Cyber Mentor
- [You Suck at Subnetting](https://www.youtube.com/playlist?list=PLIhvC56v63IKrRHh3gvZZBAGvsvOhwrRF) from NetworkChuck
- [TryHackMe Pre-Security Path](https://tryhackme.com/path/outline/presecurity)

## Network Defense
**Duration: 2 weeks**

Learn how to protect and maintain a functional network.

### Week 3-4: Defensive Technologies
1. **Firewalls:** stateful vs stateless, WAFs
2. **IDS/IPS:** Snort, Suricata basics
3. **VPNs:** tunneling, IPsec, SSL VPNs
4. **Hardening:** port security, disabling unused services, segmentation (VLANs)

**Resources:**

- [Blue Teaming and Network Defense Series](https://www.youtube.com/playlist?list=PL0-xwzAwzllxblO9Pcx_iZTT_8uD7T83D) from LoiLiangYang
- [TryHackMe Network Security Module](https://tryhackme.com/module/network-security)

## Network Attacks and Analysis
**Duration: 2 weeks**

Understand common vulnerabilities and how to detect them.

### Week 5-6: Offensive Concepts & Analysis
1. **Scanning:** Nmap, Masscan (host discovery, port scanning)
2. **Sniffing:** Wireshark, tcpdump (packet analysis)
3. **Attacks:** MITM, ARP spoofing, DoS/DDoS, DNS poisoning
4. **Tools:** Netcat, Metasploit (basics)

**Resources:**

- [TryHackMe Wireshark](https://tryhackme.com/module/wireshark)
- [HakTip: Netcat](https://www.youtube.com/playlist?list=PLW5y1tjAOzI1v-RQ8rAftvqKawXQR87eL)

## Wireless and Advanced Topics
**Duration: 2 weeks**

Expanding into wireless and more complex scenarios.

### Week 7-8: Wireless & Beyond
1. **Wireless Security:** WEP, WPA2/WPA3, handshakes, Aircrack-ng
2. **Network Architecture:** DMZ, bastion hosts, Zero Trust basics
3. **Traffic Analysis:** identifying anomalies and malware traffic

**Resources:**

- [RootMe Network Challenges](https://www.root-me.org/en/Challenges/Network/)

## Resources

To finish with this plan: create free accounts on platforms like [TryHackMe](https://tryhackme.com) or [Root Me](https://root-me.org) - useful for building both skills and knowledge. Create a [GitHub](https://www.github.com) account too, to post code and projects (if you don't code yet, see [this TryHackMe scripting module](https://tryhackme.com/module/scripting-for-pentesters)). A Twitter/X account is also useful to keep up with cybersecurity news and build a reputation in the domain.

If you want to go deeper into monitoring, detection, and incident response after Network Security, read the [Blue Team, Detection & Response Study Plan](https://github.com/jassics/security-study-plan/blob/main/blue-team-detection-response-study-plan.md) on GitHub.

**Practice next:** [jassics/security-interview-questions](https://github.com/jassics/security-interview-questions/blob/main/network-security-interview-questions.md) for interview prep, and [jassics/security-study-plan](https://github.com/jassics/security-study-plan) for the latest updates to this plan.
