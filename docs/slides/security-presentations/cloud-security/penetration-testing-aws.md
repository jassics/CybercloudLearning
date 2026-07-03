# Penetration Testing AWS

"Get Ready for Hands-on AWS Security" - a hands-on session covering AWS pentesting fundamentals, AWS's rules of engagement, and practice environments to build the skill.

<iframe src="//www.slideshare.net/slideshow/embed_code/key/KlZItvtHUgqwqF" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/jassics/penetration-testing-aws" title="Penetration Testing AWS" target="_blank">Penetration Testing AWS</a> </strong> from <strong><a href="//www.slideshare.net/jassics" target="_blank">Sanjeev Kumar Jaiswal</a></strong> </div>

## Key Takeaways

- **Prerequisites assumed:** AWS console access, IAM basics, EC2 operations, S3 buckets, ELB, security groups/NACLs, API Gateway, Lambda, VPC - plus Python3, Terraform, aws-cli, and git installed locally.
- **How pentesting AWS differs from traditional pentesting:** you're testing across infrastructure (external/internal), environment (hybrid/native), application implementation (serverless/Lambda, Beanstalk, Lightsail), data storage (S3, RDS), and IAM misconfigurations specifically.
- **AWS's rules for pentesting:** no DoS/DDoS, port flooding, protocol flooding, or network stress testing without prior notification to AWS - 8 services are pre-permitted for customer-initiated testing without needing to ask first (EC2, RDS, CloudFront, Aurora, API Gateway, Lambda, Lightsail, Elastic Beanstalk). Testing services outside that list generally just means checking AWS's current policy/support first - the Simulated Events process (`aws-security-simulated-event@amazon.com`) is specifically for covert/adversarial simulations, C2 infrastructure hosting, and malware testing, not a blanket gate on every other service.
- **Common IAM security issues:** overly permissive policies (avoid `"Resource": "*"`, broad `put*`/`attach*` actions), cross-account permission mistakes, misconfigured role combinations, and policies published without review.
- **Hands-on practice tools referenced:** flaws.cloud and flaws2.cloud (guided CTFs), CloudGoat (deliberately vulnerable AWS environments), Pacu (AWS exploitation framework), and Prowler (AWS security auditing).

## Go Deeper

- [IAM Security](../../../product-security/cloud-security/learning-aws-security/iam-security.md), [S3 Security](../../../product-security/cloud-security/learning-aws-security/s3-security.md), [GuardDuty](../../../product-security/cloud-security/learning-aws-security/guardduty.md)
- [AWS Security Study Plan](../../../study-plan/cloud-security/aws-security-study-plan.md) - includes the same flaws.cloud/CloudGoat/Pacu/Prowler labs with links
- [AWS Security Interview Questions](../../../interview-questions/aws-security-interview-questions.md)
