# Mobile Application Security Study Plan

This study plan is based on milestones, sourced from [jassics/security-study-plan/mobile-application-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/mobile-application-security-study-plan.md). Check how much you can cover within the timeline - the more you cover, the better candidate you are for roles requiring good Android/iOS application security knowledge.

Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md) and [Web Security Testing study plan](../cybersecurity/web-security-testing-study-plan.md).

It covers what you need to test and secure mobile apps, including client, API, and backend aspects.

**How this connects:** Use this plan together with [Web Security Testing](../cybersecurity/web-security-testing-study-plan.md), [Application Security](../cybersecurity/application-security-study-plan.md), and [API Security](https://github.com/jassics/security-study-plan/blob/main/api-security-study-plan.md), since mobile apps almost always talk to web backends and APIs.

## In Short

1. Mobile security is not just "web on a smaller screen" - there are **platform-specific risks**.
2. You must understand Android and iOS app models and storage.
3. You should be comfortable proxying traffic, analyzing APK/IPA files, and using common tools.
4. Align with [OWASP MASVS/MSTG](https://mas.owasp.org/) for methodology.
5. Consider both the app and its backend APIs.

## ToC

1. [Mobile Fundamentals](#mobile-fundamentals) - 2 weeks
2. [Android Security](#android-security) - 3-4 weeks
3. [iOS Security](#ios-security) - 3-4 weeks
4. [Mobile Testing Methodology (OWASP MASVS/MSTG)](#mobile-testing-methodology-owasp-masvsmstg) - 3-4 weeks
5. [Tools & Labs](#tools--labs) - 3-4 weeks
6. [Books, Videos, Courses](#books-videos-courses)
7. [Certifications](#certifications)
8. [Interview Questions](#interview-questions)

---

## Mobile Fundamentals
**Duration: 2 weeks**

Goal: understand how mobile apps are built and deployed.

### Week 1-2: Architecture
1. **Mobile App Models** - native, hybrid, cross-platform
2. **Typical Architecture** - client app ↔ API ↔ backend services
3. **Data Storage & Permissions** - local storage, keychain/keystore, runtime permissions

---

## Android Security
**Duration: 3-4 weeks**

Goal: understand Android internals and common vulnerabilities.

### Week 3-6: Android Basics & Risks
1. **Android Architecture** - APK structure, components (activities, services, receivers)
2. **Permissions & Manifest** - exported components, dangerous permissions
3. **Common Issues** - insecure storage, hardcoded secrets, insecure logging
4. **Reverse Engineering Basics** - decompiling APKs, basic static analysis

---

## iOS Security
**Duration: 3-4 weeks**

Goal: understand the iOS app model and security controls.

### Week 7-10: iOS Basics & Risks
1. **iOS Architecture** - IPA packages, app sandboxing
2. **Keychain & Secure Storage** - where secrets go and how they can leak
3. **Common Issues** - insecure local storage, weak jailbreak detection, insecure URL schemes
4. **High-Level Static & Dynamic Analysis** - understanding what's possible

---

## Mobile Testing Methodology (OWASP MASVS/MSTG)
**Duration: 3-4 weeks**

Goal: follow a structured approach for mobile security testing.

### Week 11-14: Methodology
1. **OWASP MASVS** - security requirement categories (architecture, storage, crypto, etc.)
2. **OWASP MSTG** - test cases and practical guidance
3. **Testing Focus Areas** - local data storage, authentication/session management, network communication and certificate pinning, code tampering and reverse-engineering resistance

---

## Tools & Labs
**Duration: 3-4 weeks**

Goal: get hands-on experience.

### Week 15-18: Practice
1. **Proxying & Interception** - Burp/ZAP, cert installation, bypassing certificate pinning (at a high level)
2. **Emulators & Devices** - basic setup for Android and iOS testing
3. **Deliberately Vulnerable Apps** - practice on intentionally vulnerable mobile apps from reputable sources
4. **Backend APIs** - reuse techniques from the [API Security Study Plan](https://github.com/jassics/security-study-plan/blob/main/api-security-study-plan.md) to test the APIs mobile apps use

---

## Books, Videos, Courses

- Books focused on mobile application security or testing, plus web/API security books to complement backend testing knowledge
- Conference talks on Android and iOS application security, and mobile app security assessment walkthroughs
- Official platform security overviews from Google/Apple
- Mobile application security/pentesting courses with hands-on labs
- Android/iOS development basics (optional, but helps in reading app code)

## Certifications

- Mobile security-focused certifications if they align with your goals
- General offensive security certs (OSCP/eWPTX/etc.) if you want broader pentest credentials

## Interview Questions

Reuse questions from Web & API Security, plus mobile specifics:

1. How would you test a mobile banking app for insecure storage?
2. What is OWASP MASVS and how would you use it in an assessment?
3. How would you approach bypassing certificate pinning (conceptually)?
4. What are common pitfalls in mobile auth and session management?
