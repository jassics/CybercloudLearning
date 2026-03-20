# Learning Python

## Why Python?

Python is one of the most versatile programming languages, making it essential for cybersecurity professionals:

- **Easy to learn** - Clean syntax, beginner-friendly
- **Powerful libraries** - Extensive security and automation tools
- **Cross-platform** - Works on Windows, Linux, macOS
- **Community support** - Large ecosystem and resources

## Getting Started

### Installation

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install python3 python3-pip

# macOS (with Homebrew)
brew install python3

# Verify installation
python3 --version
pip3 --version
```

### Virtual Environments

Always use virtual environments for projects:

```bash
# Create virtual environment
python3 -m venv myproject

# Activate (Linux/macOS)
source myproject/bin/activate

# Activate (Windows)
myproject\Scripts\activate

# Install packages
pip install requests
```

## Python Basics

### Variables and Data Types

```python
# Strings
name = "Security"
print(f"Hello, {name}!")

# Numbers
port = 443
timeout = 3.5

# Lists
open_ports = [22, 80, 443, 8080]

# Dictionaries
host = {"ip": "192.168.1.1", "ports": [22, 80]}

# Booleans
is_secure = True
```

### Control Flow

```python
# Conditionals
if port == 443:
    print("HTTPS")
elif port == 80:
    print("HTTP")
else:
    print("Other")

# Loops
for port in open_ports:
    print(f"Port {port} is open")

# While loop
count = 0
while count < 5:
    print(count)
    count += 1
```

### Functions

```python
def scan_port(host, port):
    """Check if a port is open."""
    import socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)
    result = sock.connect_ex((host, port))
    sock.close()
    return result == 0

# Usage
if scan_port("example.com", 80):
    print("Port 80 is open")
```

### File Operations

```python
# Reading files
with open("hosts.txt", "r") as f:
    hosts = f.readlines()

# Writing files
with open("results.txt", "w") as f:
    f.write("Scan completed\n")

# Appending
with open("log.txt", "a") as f:
    f.write("New entry\n")
```

### Exception Handling

```python
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero")
except Exception as e:
    print(f"Error: {e}")
finally:
    print("Cleanup code here")
```

## Essential Libraries for Security

| Library | Purpose |
|---------|---------|
| `requests` | HTTP requests |
| `socket` | Network programming |
| `paramiko` | SSH connections |
| `scapy` | Packet manipulation |
| `cryptography` | Encryption/decryption |
| `beautifulsoup4` | Web scraping |
| `subprocess` | System commands |

### Installing Libraries

```bash
pip install requests paramiko scapy cryptography beautifulsoup4
```

## Next Steps

- [Python for Cybersecurity](python-for-cybersecurity.md)
- [Python for AWS](python-for-aws.md)
- [Python for DevOps](python-for-devops.md)
- [Python for Automation](python-for-automation.md)

## Resources

- [Official Python Documentation](https://docs.python.org/3/)
- [Real Python Tutorials](https://realpython.com/)
- [Automate the Boring Stuff](https://automatetheboringstuff.com/)
