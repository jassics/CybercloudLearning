# XSS & Client-Side Security

## Why This Goes Deeper Than "Escape Your Output"

[Web Security Concepts](../web-security/web-security-concepts.md) covers CSP, cookies, and CSRF at the level you need to pass an interview screen. This page goes deeper on Cross-Site Scripting specifically and the client-side attack classes around it - the level you need to actually find and fix these bugs, or explain why a "simple" fix doesn't fully close the hole.

## The Three Types of XSS

| Type | Where the payload lives | How it triggers | Example |
|------|--------------------------|-------------------|---------|
| **Stored** | Persisted server-side (DB, file) | Any user who later views the affected page/data | A malicious `<script>` saved in a comment field, executes for every visitor who views that comment |
| **Reflected** | In the request itself | The response immediately reflects it back, unescaped - requires tricking the victim into clicking a crafted link | `https://site.com/search?q=<script>...</script>` where the search page echoes `q` back into the page |
| **DOM-based** | Client-side JavaScript itself | The vulnerability is entirely in the browser - the server may never see the payload at all | JavaScript reads `location.hash` and writes it into the page with `innerHTML`, so the payload never leaves the browser |

Stored is generally the highest severity (affects every viewer, no social engineering needed), but DOM-based is the one developers most often miss, because there's no server-side log entry or WAF rule that will ever see the malicious data.

### A DOM XSS Example, Vulnerable vs. Fixed

```javascript
// Insecure - anything after # in the URL gets executed as HTML
const name = decodeURIComponent(location.hash.slice(1));
document.getElementById('greeting').innerHTML = `Hello, ${name}!`;
// Visiting page#<img src=x onerror=alert(document.cookie)> executes attacker JS

// Secure - textContent never interprets its input as markup
const name = decodeURIComponent(location.hash.slice(1));
document.getElementById('greeting').textContent = `Hello, ${name}!`;
```

If you genuinely need to render user-controlled HTML (rich text, Markdown preview), use a real sanitization library (e.g. DOMPurify) - never hand-roll a regex-based HTML stripper, they are reliably bypassable.

## Why "Just Escape HTML" Isn't Enough: Context Matters

The same untrusted value needs **different encoding** depending on where it lands in the page. Applying only HTML-entity encoding everywhere is one of the most common reasons XSS fixes still fail:

| Injection Context | Example Sink | Required Encoding |
|--------------------|---------------|---------------------|
| HTML body | `<div>UNTRUSTED</div>` | HTML entity encoding (`<` → `&lt;`) |
| HTML attribute | `<input value="UNTRUSTED">` | HTML attribute encoding (also encode `"` and whitespace) |
| JavaScript string | `<script>var x = "UNTRUSTED";</script>` | JavaScript string escaping (HTML encoding does **not** stop `"; alert(1); //`) |
| URL | `<a href="UNTRUSTED">` | URL encoding, plus reject `javascript:` scheme values entirely |
| CSS | `<style>body { color: UNTRUSTED }</style>` | CSS encoding (rarely needed if you avoid user-controlled CSS entirely) |

This is why modern templating frameworks (React, Angular, Vue, Django templates) that auto-escape based on the actual output context are safer by default than manually concatenating strings - they pick the right encoding for you.

## Content Security Policy as Defense in Depth

CSP (basics in [Web Security Concepts](../web-security/web-security-concepts.md)) doesn't prevent XSS bugs from existing, but it can stop them from being exploitable:

- **Nonce-based CSP** - each page load generates a random nonce, and only `<script>` tags carrying that exact nonce execute (`script-src 'nonce-r4nd0m123'`). An attacker who can't predict the nonce can't get their injected script to run, even if the injection itself succeeds.
- **Hash-based CSP** - allow-list specific scripts by their SHA-256 hash. Works well for static inline scripts, breaks the moment the script content changes.
- **`unsafe-inline` defeats the point** - if your policy includes `script-src 'unsafe-inline'`, any injected `<script>` tag runs freely regardless of the rest of the policy. This is the single most common CSP misconfiguration that makes a "strict-looking" policy meaningless.

**Real CSP bypass techniques attackers use even against a reasonable policy** (conceptually, not exhaustively): abusing a whitelisted CDN or JSONP endpoint that itself allows arbitrary script execution, exploiting "gadgets" in an allowed library (older jQuery/AngularJS versions have known DOM-manipulation gadgets that can be chained into script execution), or finding an `unsafe-eval` allowance and abusing `eval`-adjacent sinks. The takeaway: CSP is real defense in depth, not a substitute for fixing the underlying injection.

## DOM Clobbering

A less well-known but real client-side attack: HTML elements with an `id` or `name` attribute can, in some browsers/contexts, override JavaScript global variables and even some DOM properties. If application code does something like:

```javascript
if (config.isAdmin) { /* ... */ }
```

and `config` was never explicitly initialized but happens to resolve to a DOM element (e.g. via `window.config` accidentally referring to `<div id="config">`), an attacker who can inject HTML (even where script tags are blocked by CSP) may be able to influence that lookup. It's a narrow, framework/context-dependent bug class, but worth knowing it exists - CSP alone does not prevent it, since no `<script>` execution is required.

## Real Incident: Magecart-Style Card Skimming (British Airways, 2018)

British Airways suffered a breach affecting roughly 429,000 individuals, with about 244,000 having full payment card details stolen. Attackers gained a foothold via compromised third-party credentials, then modified the live website to inject roughly 22 lines of malicious JavaScript into the payment page - this script quietly forwarded submitted card data to an attacker-controlled domain before the legitimate checkout completed. This is the signature technique of the "Magecart" family of attacks: compromise a script (first-party or a trusted third-party dependency loaded on the page) to skim data client-side, which is why **Subresource Integrity (SRI)** and strict CSP `script-src` allow-lists matter even for scripts you didn't write yourselves.

## Modern Frameworks Auto-Escape - Here's Where That Breaks

React, Angular, and Vue all escape interpolated content by default. Developers reintroduce XSS almost exclusively through the explicit "trust me" escape hatches:

- React: `dangerouslySetInnerHTML`
- Vue: `v-html`
- Angular: `[innerHTML]` binding, or `bypassSecurityTrustHtml()`

If you find one of these in a codebase, treat it as a mandatory manual review point: is the content genuinely from a trusted source, or could a user (even indirectly, via a stored value) influence it?

## Credits/References

1. [OWASP XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
2. [OWASP DOM-based XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.html)
3. [MDN: Content Security Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
4. [British Airways data breach - overview](https://en.wikipedia.org/wiki/British_Airways_data_breach)
