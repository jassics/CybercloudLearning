# Python for Automation

## Overview

Python excels at automating repetitive tasks, from file management to system administration and workflow automation.

## File System Automation

### Bulk File Operations

```python
import os
import shutil
from pathlib import Path

def organize_files_by_extension(source_dir):
    """Organize files into folders by extension."""
    source = Path(source_dir)
    
    for file in source.iterdir():
        if file.is_file():
            ext = file.suffix.lower()[1:] or "no_extension"
            dest_dir = source / ext
            dest_dir.mkdir(exist_ok=True)
            shutil.move(str(file), str(dest_dir / file.name))

# Usage
# organize_files_by_extension("/path/to/downloads")
```

### Watch Directory for Changes

```python
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class FileHandler(FileSystemEventHandler):
    def on_created(self, event):
        print(f"New file: {event.src_path}")
    
    def on_modified(self, event):
        print(f"Modified: {event.src_path}")

def watch_directory(path):
    observer = Observer()
    observer.schedule(FileHandler(), path, recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
```

## System Administration

### System Information

```python
import platform
import psutil

def get_system_info():
    return {
        "os": platform.system(),
        "version": platform.version(),
        "cpu_count": psutil.cpu_count(),
        "memory_gb": round(psutil.virtual_memory().total / (1024**3), 2),
        "disk_usage": psutil.disk_usage('/').percent
    }

print(get_system_info())
```

### Process Management

```python
import psutil

def find_process_by_name(name):
    """Find processes by name."""
    matches = []
    for proc in psutil.process_iter(['pid', 'name', 'cpu_percent']):
        if name.lower() in proc.info['name'].lower():
            matches.append(proc.info)
    return matches

def kill_process_by_name(name):
    """Kill all processes matching name."""
    for proc in psutil.process_iter(['pid', 'name']):
        if name.lower() in proc.info['name'].lower():
            psutil.Process(proc.info['pid']).terminate()
```

## Task Scheduling

### Schedule with schedule library

```python
import schedule
import time

def job():
    print("Running scheduled task...")

# Schedule tasks
schedule.every(10).minutes.do(job)
schedule.every().hour.do(job)
schedule.every().day.at("10:30").do(job)
schedule.every().monday.do(job)

# Run scheduler
while True:
    schedule.run_pending()
    time.sleep(1)
```

## Web Automation

### Web Scraping

```python
import requests
from bs4 import BeautifulSoup

def scrape_headlines(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    headlines = soup.find_all('h2')
    return [h.text.strip() for h in headlines]
```

### API Automation

```python
import requests

class APIClient:
    def __init__(self, base_url, api_key):
        self.base_url = base_url
        self.headers = {"Authorization": f"Bearer {api_key}"}
    
    def get(self, endpoint):
        return requests.get(
            f"{self.base_url}/{endpoint}",
            headers=self.headers
        ).json()
    
    def post(self, endpoint, data):
        return requests.post(
            f"{self.base_url}/{endpoint}",
            headers=self.headers,
            json=data
        ).json()
```

## Email Automation

### Send Email

```python
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_email(to, subject, body, smtp_server, smtp_port, username, password):
    msg = MIMEMultipart()
    msg['From'] = username
    msg['To'] = to
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))
    
    with smtplib.SMTP(smtp_server, smtp_port) as server:
        server.starttls()
        server.login(username, password)
        server.send_message(msg)
```

## Report Generation

### Generate PDF Report

```python
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

def generate_pdf_report(filename, title, data):
    c = canvas.Canvas(filename, pagesize=letter)
    c.setFont("Helvetica-Bold", 16)
    c.drawString(100, 750, title)
    
    c.setFont("Helvetica", 12)
    y = 700
    for line in data:
        c.drawString(100, y, line)
        y -= 20
    
    c.save()
```

### Generate CSV Report

```python
import csv

def generate_csv_report(filename, headers, data):
    with open(filename, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(headers)
        writer.writerows(data)
```

## Automation Libraries

| Library | Purpose |
|---------|---------|
| `schedule` | Task scheduling |
| `watchdog` | File system monitoring |
| `psutil` | System information |
| `paramiko` | SSH automation |
| `selenium` | Browser automation |
| `requests` | HTTP automation |
| `reportlab` | PDF generation |

## Best Practices

1. **Use logging** - Track what automation does
2. **Handle errors gracefully** - Don't crash on failures
3. **Add delays** - Avoid overwhelming systems
4. **Use configuration files** - Don't hardcode values
5. **Test incrementally** - Verify each step works
6. **Document your scripts** - Future you will thank you
