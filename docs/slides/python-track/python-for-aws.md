# Python (Boto3) for AWS

"AWSome scripts, Pythonic way" - a hands-on session on automating AWS security tasks with Python3 and Boto3, requiring only minimal AWS/Python knowledge to start.

<iframe src="//www.slideshare.net/slideshow/embed_code/key/CjlYA0zxe7KRfL" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/jassics/python-sdkboto3-for-aws" title="Python3 (boto3) for aws" target="_blank">Python3 (boto3) for aws</a> </strong> from <strong><a href="//www.slideshare.net/jassics" target="_blank">Sanjeev Kumar Jaiswal</a></strong> </div>

## Key Takeaways

- **Assumed baseline:** AWS console access, IAM basics, EC2 operations, S3 buckets, ELB awareness, and prior security group use - plus minimal Python (data types, control statements, functions, lists/tuples/dicts, `pip` installs).
- **Hands-on scripts built in the session:** AWS resource inventory, listing public S3 buckets, listing IAM details, finding security groups exposed to the internet, getting ELB public IPs for follow-up scanning, and finding orphaned security groups.
- **Broader AWS practice exercises referenced:** creating IAM users/groups/roles via CLI, spinning up EC2 instances with different security groups, making one S3 bucket public and one private (then correctly encrypting/securing them), building separate security groups per service (web/mysql/mongo/ssh), attaching instances to load balancers, checking AWS Config for non-compliant resources, and reviewing CloudTrail/CloudWatch output.
- Core message: security automation in Python/Boto3 turns manual security reviews (checking IAM policies, hunting public buckets, auditing security groups) into repeatable scripts you can run on a schedule or in CI/CD.

## Go Deeper

- [Python for AWS](../../python-track/python-for-aws.md) - the full written guide with code examples on this site
- [Python Track Introduction](../../python-track/python-track-overview.md)
- [IAM Security](../../product-security/cloud-security/learning-aws-security/iam-security.md), [S3 Security](../../product-security/cloud-security/learning-aws-security/s3-security.md)
- [python-for-cybersecurity](https://github.com/jassics/python-for-cybersecurity) repo for more code-along scripts
