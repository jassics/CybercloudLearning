# Cryptography Study Plan

This page is updated based on [jassics/security-study-plan/cryptography-study-plan](https://github.com/jassics/security-study-plan/blob/main/cryptography-study-plan.md)

This plan assumes you already have basic computer science skills (Linux basics, common Windows/macOS use, editing a file, searching the internet). Also check the [Common Security Skills study plan](../common-skills-study-plan.md) if you haven't already.

**What is cryptography?** The practice and study of techniques for secure communication in the presence of adversarial behavior. Pair this plan with the site's own [Cryptography guide](../../product-security/application-security/cryptography.md) for a practical, code-level summary.

This plan has three objectives:

- Learn cryptography's theoretical concepts
- Become familiar with useful cryptography tools
- Apply that knowledge in the context of cybersecurity

## ToC

1. [Theoretical Concepts](#theoretical-concepts) - 2 weeks
2. [Applied Cryptography](#applied-cryptography) - 2 weeks
3. [Cryptography Tools](#cryptography-tools) - 2 weeks
4. [Cryptanalysis & Challenges](#cryptanalysis-and-challenges) - 2 weeks
5. [Resources](#resources)

## Theoretical Concepts
**Duration: 2 weeks**

### Week 1-2: Core Concepts

1. **Symmetric vs Asymmetric Encryption** - DES, AES, RSA, ECC
2. **Hashing Algorithms** - MD5, SHA-1, SHA-256, SHA-3
3. **Public Key Infrastructure (PKI)** - Certificates, CAs, Chain of Trust
4. **Digital Signatures** - how they work and why they matter

**Resources:**

- [Basic Cryptography playlist](https://www.youtube.com/playlist?list=PLSNNzog5eyduN6o4e6AKFHekbH5-37BdV) by Sunny Classroom
- [Cryptography Module on TryHackMe](https://tryhackme.com/module/cryptography)

## Applied Cryptography
**Duration: 2 weeks**

### Week 3-4: Protocols & Implementation

1. **SSL/TLS** - handshake process, versions, security
2. **SSH** - secure remote access, key management
3. **Email Security** - PGP, GPG, S/MIME
4. **Data at Rest vs Data in Transit**

**Resources:**

- [Hak5: SSH Inside and Out](https://www.youtube.com/playlist?list=PLW5y1tjAOzI3IjZWkI4Qh0GP2bPTTF83a)
- [Real-World Cryptography](https://www.manning.com/books/real-world-cryptography) (book)

## Cryptography Tools
**Duration: 2 weeks**

### Week 5-6: Hands-on Tools

1. **OpenSSL** - generating keys, CSRs, testing connections
2. **GPG** - encrypting and signing files
3. **John the Ripper / Hashcat** - password cracking basics (to understand password strength, not for unauthorized use)
4. **CyberChef** - the "Swiss Army Knife" for encoding/decoding/encryption

**Resources:**

- [TryHackMe Practice](https://tryhackme.com/r/hacktivities/practice)
- [CyberChef](https://gchq.github.io/CyberChef/)

## Cryptanalysis & Challenges
**Duration: 2 weeks**

### Week 7-8: Breaking Codes

1. **Classical Ciphers** - Caesar, Vigenère (historical context)
2. **Modern Attacks** - Padding Oracle, POODLE, Heartbleed (understand the underlying flaws)
3. **CTF Challenges** - solve crypto challenges on dedicated platforms

**Resources:**

- [RootMe Cryptanalysis Challenges](https://www.root-me.org/en/Challenges/Cryptanalysis/)
- [Cryptopals Crypto Challenges](https://cryptopals.com/)

## Resources

### Platforms

- [pwn.guide](https://pwn.guide)
- [TryHackMe](https://tryhackme.com)
- [RootMe](https://root-me.org)

### Books

- *Serious Cryptography* by Jean-Philippe Aumasson
- *Real-World Cryptography* by David Wong

### Interview Questions

Cryptography questions frequently show up inside broader [Application Security interview questions](https://github.com/jassics/security-interview-questions/blob/main/application-security-interview-questions.md) - review that set alongside this plan.
