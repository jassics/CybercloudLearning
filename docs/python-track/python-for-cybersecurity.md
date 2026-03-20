# Python for Cybersecurity

## Overview

Python is the de facto language for cybersecurity professionals. It's used for automation, scripting, tool development, and security testing.

## Security Libraries

| Library | Use Case |
|---------|----------|
| `scapy` | Packet crafting and analysis |
| `paramiko` | SSH automation |
| `requests` | Web security testing |
| `pycryptodome` | Cryptographic operations |
| `python-nmap` | Network scanning |
| `impacket` | Network protocols |

## Network Security Scripts

### Port Scanner

```python
import socket
from concurrent.futures import ThreadPoolExecutor

def scan_port(host, port):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        result = sock.connect_ex((host, port))
        sock.close()
        return port if result == 0 else None
    except:
        return None

def scan_host(host, ports):
    open_ports = []
    with ThreadPoolExecutor(max_workers=100) as executor:
        results = executor.map(lambda p: scan_port(host, p), ports)
        open_ports = [p for p in results if p]
    return open_ports

# Usage
target = "scanme.nmap.org"
ports = range(1, 1025)
open_ports = scan_host(target, ports)
print(f"Open ports: {open_ports}")
```

### Banner Grabbing

```python
import socket

def grab_banner(host, port):
    try:
        sock = socket.socket()
        sock.settimeout(2)
        sock.connect((host, port))
        banner = sock.recv(1024).decode().strip()
        sock.close()
        return banner
    except:
        return None

# Usage
banner = grab_banner("example.com", 80)
print(f"Banner: {banner}")
```

## Web Security Scripts

### Directory Bruteforcer

```python
import requests
from concurrent.futures import ThreadPoolExecutor

def check_path(base_url, path):
    url = f"{base_url}/{path}"
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            return url
    except:
        pass
    return None

def bruteforce_dirs(base_url, wordlist_path):
    with open(wordlist_path, "r") as f:
        paths = [line.strip() for line in f]
    
    found = []
    with ThreadPoolExecutor(max_workers=20) as executor:
        results = executor.map(lambda p: check_path(base_url, p), paths)
        found = [r for r in results if r]
    return found

# Usage
# found = bruteforce_dirs("http://example.com", "wordlist.txt")
```

### Subdomain Enumeration

```python
import dns.resolver

def find_subdomains(domain, wordlist_path):
    subdomains = []
    with open(wordlist_path, "r") as f:
        prefixes = [line.strip() for line in f]
    
    for prefix in prefixes:
        subdomain = f"{prefix}.{domain}"
        try:
            dns.resolver.resolve(subdomain, "A")
            subdomains.append(subdomain)
            print(f"Found: {subdomain}")
        except:
            pass
    return subdomains
```

## Cryptography

### Hashing

```python
import hashlib

def hash_password(password, algorithm="sha256"):
    return hashlib.new(algorithm, password.encode()).hexdigest()

# Usage
hashed = hash_password("mysecretpassword")
print(f"SHA256: {hashed}")

# MD5 (not recommended for passwords)
md5_hash = hashlib.md5("data".encode()).hexdigest()
```

### Encryption with Fernet

```python
from cryptography.fernet import Fernet

# Generate key
key = Fernet.generate_key()
cipher = Fernet(key)

# Encrypt
message = "Secret message"
encrypted = cipher.encrypt(message.encode())

# Decrypt
decrypted = cipher.decrypt(encrypted).decode()
print(f"Decrypted: {decrypted}")
```

## Log Analysis

### Parse Auth Logs

```python
import re
from collections import Counter

def analyze_auth_log(log_path):
    failed_logins = []
    pattern = r"Failed password for .* from (\d+\.\d+\.\d+\.\d+)"
    
    with open(log_path, "r") as f:
        for line in f:
            match = re.search(pattern, line)
            if match:
                failed_logins.append(match.group(1))
    
    return Counter(failed_logins).most_common(10)

# Usage
# top_attackers = analyze_auth_log("/var/log/auth.log")
```

## Password Tools

### Password Generator

```python
import secrets
import string

def generate_password(length=16):
    alphabet = string.ascii_letters + string.digits + string.punctuation
    return ''.join(secrets.choice(alphabet) for _ in range(length))

# Usage
password = generate_password(20)
print(f"Generated: {password}")
```

## Best Practices

1. **Use virtual environments** - Isolate project dependencies
2. **Handle exceptions** - Don't let scripts crash unexpectedly
3. **Add timeouts** - Prevent hanging on network operations
4. **Rate limiting** - Don't overwhelm targets
5. **Logging** - Track what your scripts do
6. **Input validation** - Sanitize user inputs

## Tools Built with Python

- **SQLMap** - SQL injection
- **Volatility** - Memory forensics
- **theHarvester** - OSINT
- **Impacket** - Network protocols
- **Scapy** - Packet manipulation
