# Python for DevOps

## Overview

Python is essential for DevOps engineers, used for automation, infrastructure management, CI/CD pipelines, and monitoring.

## Infrastructure as Code

### Working with YAML

```python
import yaml

# Read YAML
def read_yaml(filepath):
    with open(filepath, 'r') as f:
        return yaml.safe_load(f)

# Write YAML
def write_yaml(filepath, data):
    with open(filepath, 'w') as f:
        yaml.dump(data, f, default_flow_style=False)

# Example: Update Kubernetes deployment
config = read_yaml('deployment.yaml')
config['spec']['replicas'] = 3
write_yaml('deployment.yaml', config)
```

### Working with JSON

```python
import json

def read_json(filepath):
    with open(filepath, 'r') as f:
        return json.load(f)

def write_json(filepath, data):
    with open(filepath, 'w') as f:
        json.dump(data, f, indent=2)
```

## Docker Automation

### Docker SDK

```python
import docker

client = docker.from_env()

# List containers
def list_containers():
    return [c.name for c in client.containers.list()]

# Run container
def run_container(image, name):
    return client.containers.run(
        image,
        name=name,
        detach=True
    )

# Build image
def build_image(path, tag):
    image, logs = client.images.build(path=path, tag=tag)
    return image.tags
```

### Docker Compose Automation

```python
import subprocess

def docker_compose_up(compose_file):
    subprocess.run([
        'docker-compose',
        '-f', compose_file,
        'up', '-d'
    ], check=True)

def docker_compose_down(compose_file):
    subprocess.run([
        'docker-compose',
        '-f', compose_file,
        'down'
    ], check=True)
```

## Kubernetes Automation

### Kubernetes Python Client

```python
from kubernetes import client, config

# Load kubeconfig
config.load_kube_config()

v1 = client.CoreV1Api()

def list_pods(namespace='default'):
    pods = v1.list_namespaced_pod(namespace)
    return [pod.metadata.name for pod in pods.items]

def list_services(namespace='default'):
    services = v1.list_namespaced_service(namespace)
    return [svc.metadata.name for svc in services.items]

def get_pod_logs(name, namespace='default'):
    return v1.read_namespaced_pod_log(name, namespace)
```

## CI/CD Integration

### GitHub Actions Trigger

```python
import requests

def trigger_workflow(owner, repo, workflow_id, token, ref='main'):
    url = f"https://api.github.com/repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    data = {"ref": ref}
    
    response = requests.post(url, headers=headers, json=data)
    return response.status_code == 204
```

### Jenkins API

```python
import requests

class JenkinsClient:
    def __init__(self, url, username, token):
        self.url = url
        self.auth = (username, token)
    
    def trigger_build(self, job_name, params=None):
        endpoint = f"{self.url}/job/{job_name}/buildWithParameters"
        return requests.post(endpoint, auth=self.auth, params=params)
    
    def get_build_status(self, job_name, build_number):
        endpoint = f"{self.url}/job/{job_name}/{build_number}/api/json"
        return requests.get(endpoint, auth=self.auth).json()
```

## Monitoring & Alerting

### Prometheus Metrics

```python
from prometheus_client import start_http_server, Counter, Gauge

# Define metrics
REQUEST_COUNT = Counter('app_requests_total', 'Total requests')
CPU_USAGE = Gauge('app_cpu_usage', 'CPU usage percentage')

# Update metrics
REQUEST_COUNT.inc()
CPU_USAGE.set(45.2)

# Start metrics server
start_http_server(8000)
```

### Send Slack Alert

```python
import requests

def send_slack_alert(webhook_url, message, channel="#alerts"):
    payload = {
        "channel": channel,
        "text": message,
        "username": "DevOps Bot"
    }
    requests.post(webhook_url, json=payload)
```

## SSH Automation

### Remote Command Execution

```python
import paramiko

def execute_remote_command(host, username, key_path, command):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(host, username=username, key_filename=key_path)
    
    stdin, stdout, stderr = ssh.exec_command(command)
    output = stdout.read().decode()
    errors = stderr.read().decode()
    
    ssh.close()
    return output, errors
```

## Log Management

### Parse and Analyze Logs

```python
import re
from collections import Counter

def analyze_nginx_logs(log_path):
    pattern = r'(\d+\.\d+\.\d+\.\d+).*"(\w+)\s+(\S+)'
    
    ips = []
    endpoints = []
    
    with open(log_path, 'r') as f:
        for line in f:
            match = re.search(pattern, line)
            if match:
                ips.append(match.group(1))
                endpoints.append(match.group(3))
    
    return {
        'top_ips': Counter(ips).most_common(10),
        'top_endpoints': Counter(endpoints).most_common(10)
    }
```

## DevOps Libraries

| Library | Purpose |
|---------|---------|
| `boto3` | AWS automation |
| `docker` | Docker SDK |
| `kubernetes` | K8s client |
| `paramiko` | SSH client |
| `ansible` | Configuration management |
| `requests` | API interactions |
| `prometheus_client` | Metrics |

## Best Practices

1. **Use version control** - Track all automation scripts
2. **Implement idempotency** - Scripts should be safe to run multiple times
3. **Use secrets management** - Never hardcode credentials
4. **Add error handling** - Graceful failure recovery
5. **Write tests** - Validate automation before production
6. **Document everything** - Maintain runbooks
