# Python for AWS

## Overview

Python with Boto3 is the primary way to automate AWS infrastructure and security tasks programmatically.

## Setup

### Installation

```bash
pip install boto3 awscli
```

### Configuration

```bash
# Configure AWS CLI
aws configure

# Or use environment variables
export AWS_ACCESS_KEY_ID="your_key"
export AWS_SECRET_ACCESS_KEY="your_secret"
export AWS_DEFAULT_REGION="us-east-1"
```

### Basic Boto3 Usage

```python
import boto3

# Create a client
s3 = boto3.client('s3')

# Create a resource (higher-level)
s3_resource = boto3.resource('s3')

# Specify region
ec2 = boto3.client('ec2', region_name='us-west-2')
```

## EC2 Operations

### List Instances

```python
import boto3

ec2 = boto3.client('ec2')

def list_instances():
    response = ec2.describe_instances()
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            print(f"ID: {instance['InstanceId']}")
            print(f"State: {instance['State']['Name']}")
            print(f"Type: {instance['InstanceType']}")
            print("---")

list_instances()
```

### Security Group Audit

```python
def audit_security_groups():
    ec2 = boto3.client('ec2')
    response = ec2.describe_security_groups()
    
    risky_groups = []
    for sg in response['SecurityGroups']:
        for rule in sg.get('IpPermissions', []):
            for ip_range in rule.get('IpRanges', []):
                if ip_range.get('CidrIp') == '0.0.0.0/0':
                    risky_groups.append({
                        'GroupId': sg['GroupId'],
                        'GroupName': sg['GroupName'],
                        'Port': rule.get('FromPort', 'All')
                    })
    return risky_groups

# Find publicly accessible security groups
risky = audit_security_groups()
for sg in risky:
    print(f"Warning: {sg['GroupName']} allows 0.0.0.0/0 on port {sg['Port']}")
```

## S3 Security

### List Buckets

```python
def list_buckets():
    s3 = boto3.client('s3')
    response = s3.list_buckets()
    return [bucket['Name'] for bucket in response['Buckets']]
```

### Check Public Buckets

```python
def check_bucket_acl(bucket_name):
    s3 = boto3.client('s3')
    try:
        acl = s3.get_bucket_acl(Bucket=bucket_name)
        for grant in acl['Grants']:
            grantee = grant['Grantee']
            if grantee.get('URI') == 'http://acs.amazonaws.com/groups/global/AllUsers':
                return True
    except Exception as e:
        print(f"Error: {e}")
    return False

# Check all buckets
for bucket in list_buckets():
    if check_bucket_acl(bucket):
        print(f"WARNING: {bucket} is public!")
```

### Enable Bucket Encryption

```python
def enable_bucket_encryption(bucket_name):
    s3 = boto3.client('s3')
    s3.put_bucket_encryption(
        Bucket=bucket_name,
        ServerSideEncryptionConfiguration={
            'Rules': [{
                'ApplyServerSideEncryptionByDefault': {
                    'SSEAlgorithm': 'AES256'
                }
            }]
        }
    )
    print(f"Encryption enabled for {bucket_name}")
```

## IAM Security

### List IAM Users

```python
def list_iam_users():
    iam = boto3.client('iam')
    paginator = iam.get_paginator('list_users')
    users = []
    for page in paginator.paginate():
        users.extend(page['Users'])
    return users
```

### Find Users Without MFA

```python
def users_without_mfa():
    iam = boto3.client('iam')
    users = list_iam_users()
    no_mfa = []
    
    for user in users:
        mfa_devices = iam.list_mfa_devices(UserName=user['UserName'])
        if not mfa_devices['MFADevices']:
            no_mfa.append(user['UserName'])
    
    return no_mfa

# Report users without MFA
for user in users_without_mfa():
    print(f"No MFA: {user}")
```

### Find Old Access Keys

```python
from datetime import datetime, timezone

def find_old_keys(days=90):
    iam = boto3.client('iam')
    users = list_iam_users()
    old_keys = []
    
    for user in users:
        keys = iam.list_access_keys(UserName=user['UserName'])
        for key in keys['AccessKeyMetadata']:
            age = (datetime.now(timezone.utc) - key['CreateDate']).days
            if age > days:
                old_keys.append({
                    'User': user['UserName'],
                    'KeyId': key['AccessKeyId'],
                    'Age': age
                })
    return old_keys
```

## CloudTrail Analysis

### Search CloudTrail Events

```python
def search_cloudtrail(event_name, hours=24):
    import datetime
    
    cloudtrail = boto3.client('cloudtrail')
    end_time = datetime.datetime.utcnow()
    start_time = end_time - datetime.timedelta(hours=hours)
    
    events = []
    paginator = cloudtrail.get_paginator('lookup_events')
    
    for page in paginator.paginate(
        LookupAttributes=[{
            'AttributeKey': 'EventName',
            'AttributeValue': event_name
        }],
        StartTime=start_time,
        EndTime=end_time
    ):
        events.extend(page['Events'])
    
    return events

# Find console login events
logins = search_cloudtrail('ConsoleLogin')
```

## Lambda Functions

### Invoke Lambda

```python
import json

def invoke_lambda(function_name, payload):
    lambda_client = boto3.client('lambda')
    response = lambda_client.invoke(
        FunctionName=function_name,
        InvocationType='RequestResponse',
        Payload=json.dumps(payload)
    )
    return json.loads(response['Payload'].read())
```

## Best Practices

1. **Use IAM roles** - Avoid hardcoding credentials
2. **Enable CloudTrail** - Audit all API calls
3. **Paginate results** - Handle large datasets properly
4. **Handle exceptions** - AWS API calls can fail
5. **Use regions** - Specify regions explicitly
6. **Tag resources** - Track ownership and purpose
