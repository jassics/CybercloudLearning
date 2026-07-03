# Python for Security Study Plan

This page pairs the site's [Python for Cybersecurity](../../python-track/python-for-cybersecurity.md) guide with the hands-on, code-along [jassics/python-for-cybersecurity](https://github.com/jassics/python-for-cybersecurity) repository. Unlike the other study plans (which are synced from [jassics/security-study-plan](https://github.com/jassics/security-study-plan)), this one is original - built directly from that repo's structure so you can follow along file by file.

Also check the [Common Security Skills study plan](../common-skills-study-plan.md) first if you haven't already.

## In Short

1. You don't need to be a "software engineer" - you need to be able to read, adapt, and write small scripts that solve a security problem fast.
2. Every script you write should map to something you'd actually do on the job: scan a host, parse a log, hit an API, automate a repetitive check.
3. Practice by cloning [python-for-cybersecurity](https://github.com/jassics/python-for-cybersecurity) and working through it top to bottom - `basic_concepts/` → `exercises/` → `real_world_examples/` → `web_security/` and `cryptography/`.

## ToC

1. [Python Fundamentals](#python-fundamentals) - 2-3 weeks
2. [Exercises - Building Logic](#exercises---building-logic) - 1-2 weeks
3. [Real-World Automation Scripts](#real-world-automation-scripts) - 2 weeks
4. [Python for Web Security](#python-for-web-security) - 2 weeks
5. [Python for Cryptography](#python-for-cryptography) - 1 week
6. [Security-Specific Libraries](#security-specific-libraries)
7. [Books, Videos & Courses](#books-videos--courses)
8. [Interview Questions](#interview-questions)

## Python Fundamentals
**Duration: 2-3 weeks**

### Week 1-3: Language Basics

Work through the `basic_concepts/` folder of the repo in order - it's built as a numbered progression:

1. **Core syntax** - `0-hello-world.py`, `1-number.py`, string handling (`1c-string.py`, `1d-string-format.py`, `1e-string-methods.py`)
2. **Control flow** - `2-if-elif-else.py`, loops (`2a-while-loop.py`, `2b-for-loop.py`, `2c-range.py`), `2d-break-continue-pass.py`
3. **Operators** - arithmetic, comparison, assignment, logical, identity (`3a`-`3e`)
4. **Data structures** - `4-data-structure.py`, `4a-list.py`, `4b-dictionary.py`, `4c-tuples.py`, `4d-sets.py`
5. **Functions** - `5-function.py`, `5a-collection-function.py`, `5b-builtin-function.py`
6. **File handling and regex** - `6-file-handle.py`, `7-regex-examples.py` (regex is a daily tool for log parsing and validation)
7. **Error handling and classes** - `10-error-handling.py`, `11-class.py`

**Why this order matters for security work:** file handling and regex show up constantly - parsing logs, config files, and scan output. Don't skip them to rush toward "cooler" topics.

## Exercises - Building Logic
**Duration: 1-2 weeks**

### Week 4: Problem Solving

Work through the `exercises/` folder to build comfort translating a problem into code before you need speed under pressure (interviews, incident response):

- `isprime.py`, `n_prime_numbers.py`, `prime_range.py` - algorithmic thinking
- `two_sum_index.py` - common interview-style problem
- `in_memory_db.py`, `in_memory_db_json.py`, `in_memory_db_persistent.py`, `in_memory_db_cmd.py` - a progressively more realistic mini-project (plain dict → JSON-backed → persistent → CLI)
- `fahrenheit_to_celcius.py`, `city_weather.py` - working with external data/APIs

## Real-World Automation Scripts
**Duration: 2 weeks**

### Week 5-6: Practical Scripts

The `real_world_examples/` folder is where this repo earns the "for cybersecurity" part of its name. Work through:

- `generate_password.py`, `generate_otp.py` - secure secrets generation
- `download_file_from_url.py`, `get_all_links.py` - reconnaissance-style scripting
- `regex_validator.py` - input validation patterns
- `rename_files.py`, `pdf_manipulation.py`, `pdf_to_jpeg.py`, `heic_to_png.py` - bulk file/evidence handling, useful in forensics/DFIR workflows
- `sysinfo.py` - environment/host enumeration
- `get_gituser_details.py`, `linkedin_profile_views.py`, `linkedin_connections_details.py` - OSINT-style API scripting
- `ip-ranges.json` + related scripts - working with structured threat/network data

**Job-ready exercise:** pick 3 of these scripts, break them (change inputs, remove error handling) and fix them again. That's closer to real troubleshooting than writing from a blank file.

## Python for Web Security
**Duration: 2 weeks**

### Week 7-8: Web-Focused Scripting

Work through the `web_security/` folder, then cross-reference with the site's [API Security](../../product-security/application-security/api-security.md) and [OWASP Top 10](../../product-security/web-security/owasp-top10.md) guides:

- `header_info.py`, `security_header_info.py` - checking security headers (CSP, HSTS, X-Frame-Options) programmatically
- `site_security_info.py` - basic site security posture scripting
- `fake_it.py` - generating test/fixture data for security testing
- `burp_extender_plugins/` - writing Burp Suite extensions in Python (once you're comfortable, this is a strong differentiator for AppSec/pentest roles)

## Python for Cryptography
**Duration: 1 week**

### Week 9: Applied Crypto in Python

- `crypto_basic.py` - hands-on encryption/hashing basics in Python
- Cross-reference with the site's [Cryptography guide](../../product-security/application-security/cryptography.md) and the [Cryptography study plan](cryptography-study-plan.md) for the "why," not just the "how"

## Security-Specific Libraries

Once comfortable with the fundamentals, get hands-on with the libraries covered in [Python for Cybersecurity](../../python-track/python-for-cybersecurity.md):

| Library | Use Case |
|---------|----------|
| `scapy` | Packet crafting and analysis |
| `paramiko` | SSH automation |
| `requests` | Web/API security testing |
| `pycryptodome` | Cryptographic operations |
| `python-nmap` | Network scanning |
| `impacket` | Network protocol manipulation |

## Books, Videos & Courses

- *Automate the Boring Stuff with Python*
- *Learn Python3 the Hard Way*
- *Python Crash Course*
- [Flexmind Python Videos Playlist](https://youtube.com/playlist?list=PLRTsCutScZnwoFVqkk630BLBGMCIsj426)
- [Python for Everybody Specialization (Coursera)](https://www.coursera.org/specializations/python)
- [Crash Course on Python by Google (Coursera)](https://www.coursera.org/learn/python-crash-course)

## Interview Questions

Python-for-security questions frequently overlap with general [Application Security](../../interview-questions/application-security-interview-questions.md) and [DevSecOps](../../interview-questions/devsecops-interview-questions.md) interview sets - review those alongside hands-on scripting practice.
