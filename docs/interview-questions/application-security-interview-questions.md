# Application Security Interview Questions

Questions sourced and expanded from [jassics/security-interview-questions](https://github.com/jassics/security-interview-questions/blob/main/application-security-interview-questions.md).

This set is mostly for **defensive** AppSec roles (as opposed to pentesting/web security, which are covered separately) - how an application is developed, maintained, and deployed, and how you help engineering teams overcome security challenges. Click each question to reveal what a strong answer covers.

!!! tip "Before you start"
    If you're new to this domain, work through the [Application Security Study Plan](../study-plan/cybersecurity/application-security-study-plan.md) and [API Security Study Plan](../study-plan/cybersecurity/api-security-study-plan.md) first - interviewers assume that baseline.

## Application Security Basics

??? question "Q: What's the difference between SAST and SCA?"
    **SAST** analyzes your first-party source code for vulnerabilities without executing it (injection flaws, hardcoded secrets, dangerous function use). **SCA** analyzes your third-party/open-source dependencies for known CVEs and license issues. They're complementary - see the site's [SAST](../product-security/application-security/sast.md) and [SCA](../product-security/application-security/sca.md) guides for the full comparison.

??? question "Q: What is SQL injection and how would you prevent/mitigate it?"
    SQLi happens when untrusted input is concatenated directly into a query, letting an attacker change the query's logic. Prevent it with parameterized queries/prepared statements, an ORM with proper escaping, and least-privilege database accounts. See [Secure Coding](../product-security/application-security/secure-coding.md#injection-sql-command-ldap-nosql).

??? question "Q: Explain XSS with a few examples and how it can be avoided."
    Reflected, stored, and DOM-based XSS all boil down to unescaped attacker-controlled data being rendered as HTML/JS. Mitigate with context-aware output encoding, frameworks that auto-escape by default (React, Angular, Django templates), and a strict Content-Security-Policy as defense in depth.

??? question "Q: How do you avoid brute-force attacks on a login page?"
    Rate limiting, CAPTCHA after N failed attempts, account lockout/backoff, MFA, and alerting/monitoring for anomalous login patterns. Also worth mentioning: don't reveal whether the username or password was wrong (avoid user enumeration).

Other questions worth preparing for in this section: explain the TCP 3-way handshake; why TLS matters and how SSL/TLS actually secures traffic; what happens when you type a URL into a browser; describe a time you had to learn something quickly.

## Role-Based Questions

??? question "Q: How is CSRF dangerous, and what prevents it?"
    CSRF tricks an authenticated user's browser into submitting a request they didn't intend, exploiting the fact that cookies are sent automatically. Prevent it with anti-CSRF tokens, `SameSite` cookies, and re-authentication for sensitive actions.

??? question "Q: What are the key differences between manual code review and automated static analysis?"
    Automated (SAST) scales, is consistent, and is good at pattern-matching known-bad code; it misses business logic flaws and authorization gaps that depend on context. Manual review catches those but doesn't scale and is reviewer-dependent. See [Secure Code Review](../product-security/application-security/secure-code-review.md#manual-review-vs-automated-scanning) for the full comparison table.

??? question "Q: Describe the STRIDE threat modeling methodology."
    Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege - each maps to a security property being violated. Walk the interviewer through the [Threat Modeling](../product-security/application-security/threat-modeling.md#step-2-identify-threats-stride) worked example (a login flow) if asked to demonstrate it live.

Other questions in this section: input validation approach and examples; secure error handling and logging; encryption best practices in code; managing secrets in code; securing third-party dependencies; how you balance finding issues vs. development velocity; prioritizing threats from a threat-modeling exercise; integrating threat modeling into Agile.

## Assessment & SDLC Questions

- Where do we need security in the SDLC phase, and what does each phase involve?
- What would you suggest for input sanitization?
- What should a developer do for secrets management?
- Strategies for secure session management in web applications
- How do you handle security misconfigurations across dev/prod?
- Importance of least privilege and RBAC in application security
- How do you keep logging/monitoring from leaking sensitive data?
- Challenges of running an SDL program in a fast-paced org, and how to overcome them

??? question "Q: How can an attacker exploit SSRF, and what should developers do to prevent it?"
    SSRF lets an attacker make the server issue requests to internal-only resources (cloud metadata endpoints, admin panels) by supplying a URL that gets fetched server-side. Prevent it by allow-listing destination hosts, blocking requests to private/link-local IP ranges, and disabling redirects when fetching user-supplied URLs. See the site's [API Security](../product-security/application-security/api-security.md#server-side-request-forgery-ssrf) SSRF section.

## Senior / Problem-Solving Questions

These are less about facts and more about how you think and lead - come with real examples from your own experience:

- What steps would you take to get developers following secure coding practices?
- How do you handle typical developer-vs-security friction?
- Approach to identifying/mitigating risk in a large, unmaintained legacy codebase
- Enforcing a secure coding standard across a globally distributed team
- Designing a security strategy for a microservices architecture against external and internal threats
- Conducting threat modeling for a cloud-native application
- Key metrics to measure the effectiveness of an SDL program

## Scenario-Based Questions (Senior/Staff Level)

??? question "Q: How would you design a safe and secure password mechanism?"
    Cover: password hashing algorithm choice (Argon2id/bcrypt, never fast hashes like MD5/SHA-256), unique random salt per password, minimum complexity/length policy, MFA, rate limiting on auth endpoints, and secure password reset flow (time-limited tokens, no password in the reset link/email). See [Cryptography - Password Hashing](../product-security/application-security/cryptography.md#password-hashing-different-from-general-hashing).

??? question "Q: A dev team plans to hash passwords with MD5. How do you advise them?"
    MD5 is fast and unsalted by default - trivially brute-forced with GPUs/rainbow tables. Recommend Argon2id (or bcrypt/scrypt), a unique random salt per user (usually handled automatically by the library), and explain the cost-factor tuning tradeoff (slower = more resistant to brute force, but adds latency).

Other scenario prompts to rehearse out loud: mitigating risk from vulnerable third-party libraries found via SCA; threat modeling a new financial application handling banking data; fixing string-concatenated SQL found in review; handling a critical 0-day in a widely-used dependency; designing security architecture for a new e-commerce platform (web + mobile + APIs); preventing automated brute-force/dictionary attacks.

## Secure Code Review Round (Spot the Bug)

Practice identifying the issue **before** reading the hint.

??? question "Q: What's wrong here? [Hint: CSRF]"
    ```php
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $userId = $_POST['userId'];
        $newEmail = $_POST['newEmail'];
        updateEmail($userId, $newEmail);
    }
    ```
    No CSRF token validation and no re-authentication before a sensitive state change (changing account email). An attacker can host a form on another site that auto-submits to this endpoint using the victim's existing session cookie.

??? question "Q: What's wrong here? [Hint: insecure deserialization]"
    ```java
    ObjectInputStream in = new ObjectInputStream(new FileInputStream("data.ser"));
    Object obj = in.readObject();
    in.close();
    ```
    Deserializing data from a file/stream without validating its origin/integrity can lead to remote code execution if an attacker controls `data.ser`. Avoid native Java serialization for untrusted data; use a safe format like JSON with schema validation instead.

??? question "Q: What's wrong here? [Hint: password hashing]"
    ```python
    import hashlib
    def store_password(password):
        hashed_password = hashlib.md5(password.encode()).hexdigest()
        save_to_database(hashed_password)
    ```
    MD5 is fast and unsalted - crackable at scale with rainbow tables/GPUs. Replace with Argon2id (or bcrypt) via a vetted password-hashing library.

??? question "Q: What issue does this code cause? [Hint: XSS]"
    ```typescript
    const userInput = request.query.userInput;
    const output = "<div>" + userInput + "</div>";
    response.send(output);
    ```
    Reflected XSS - `userInput` is rendered as raw HTML with no encoding. Encode output for the HTML context, or use a templating engine that auto-escapes by default.

??? question "Q: What issue does this code cause?"
    ```javascript
    String userId = request.getParameter("userId");
    String query = "SELECT * FROM users WHERE user_id = '" + userId + "'";
    Statement stmt = connection.createStatement();
    ResultSet rs = stmt.executeQuery(query);
    ```
    Classic SQL injection via string concatenation. Use a parameterized query / `PreparedStatement` instead.

## Deep-Dive Topics (What Interviewers Are Actually Listening For)

??? question "Q: What do you think makes a good password (policy)?"
    Drill into: what counts as "complex," whether admin and user password policies should differ, whether passwords are hashed (never encrypted or plaintext) in the database, whether salting is per-user and random, and how the code defends against credential-stuffing/brute-force attacks.

??? question "Q: How do you stop brute-force attacks on login/signup/forgot-password pages?"
    Listen for: CAPTCHA, CSRF tokens, rate limiting, MFA, alerting/monitoring for anomalous behavior, and account lockout after N failed attempts.

??? question "Q: What happens when you type google.com into a browser?"
    Listen for: DNS resolution (URL → IP), the TCP 3-way handshake, how HTTPS/TLS protects the connection, and how the setup defends against a man-in-the-middle attack.

??? question "Q: How does SSL/TLS actually secure my content over the internet?"
    Listen for: the TLS handshake (client/server hello), asymmetric key exchange followed by symmetric encryption for bulk data, Certificate Signing Requests, weak vs. strong cipher suites, being able to read a cipher suite name like `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`, TLS 1.2 vs 1.3, Perfect Forward Secrecy, and why an HTTPS site can still get hacked (TLS only secures transport, not the app itself).

??? question "Q: How would you get developers to adopt secure coding practices?"
    Listen for concrete delivery experience: OWASP ASVS, OWASP Top 10, running secure-review workshops with real examples, secure design principles, and - critically - how they *verify* adoption stuck (IDE plugins, CI/CD gates, SAST in the pipeline) rather than just training and hoping.

??? question "Q: How well do you understand SQL injection?"
    Listen for: when "data becomes code," ability to spot SQLi in a code review, hands-on experience with a SAST/DAST tool that catches it, and fluency with prepared statements as the fix.

??? question "Q: Explain how you handle AuthN and AuthZ."
    A strong answer covers: the distinction between authentication and authorization, concrete protocols (OAuth, SAML, RBAC), awareness of common risks in both, the role of logging/monitoring, real examples of implementations they've shipped or improved, and current trends (adaptive auth, zero trust, passkeys/biometrics).

Other subjective deep-dive prompts worth rehearsing: how do you implement CSP and does it add real security; benefits of SOP/CORS/CSP with real examples; techniques to prevent web server attacks (patching, hardening, custom ports, firewalling, monitoring); steps for successful DLP controls; how OAuth works; what is SCA and how you perform it; why XOR matters in cryptography basics.

## Practice Next

- [Application Security Study Plan](../study-plan/cybersecurity/application-security-study-plan.md)
- [Secure Coding](../product-security/application-security/secure-coding.md), [Secure Code Review](../product-security/application-security/secure-code-review.md), [Threat Modeling](../product-security/application-security/threat-modeling.md)
- Full question set on GitHub: [security-interview-questions](https://github.com/jassics/security-interview-questions/blob/main/application-security-interview-questions.md)
