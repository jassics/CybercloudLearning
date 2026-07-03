# CloudTrail

## What CloudTrail Actually Gives You

CloudTrail is your security camera - it records every API call made against your AWS account, who made it, from where, and when. Without it, incident response is guesswork; with it, "who deleted this security group" becomes a query, not an investigation.

## Management Events vs. Data Events

| Event Type | Examples | Logged by Default? |
|------------|----------|---------------------|
| **Management Events** | Creating/deleting an EC2 instance, changing an IAM policy, modifying a security group | Yes, free, in the last 90 days via Event History |
| **Data Events** | S3 `GetObject`/`PutObject`, Lambda `Invoke` | No - must be explicitly enabled, incurs cost |

Interview-relevant distinction: management events tell you about **control-plane changes** (infrastructure), data events tell you about **data-plane activity** (someone reading/writing an actual object). If you're investigating a suspected S3 data exfiltration, you need data events turned on for that bucket *before* the incident - they aren't retroactive.

## Setting Up a Trail That Actually Helps During an Incident

The default 90-day Event History is not enough for real investigations or compliance. A proper setup:

```bash
# Create an organization-wide, multi-region trail delivering to a security account
aws cloudtrail create-trail \
  --name org-security-trail \
  --s3-bucket-name security-account-cloudtrail-logs \
  --is-multi-region-trail \
  --is-organization-trail \
  --enable-log-file-validation
```

Key decisions baked into that command:

1. **Multi-region** - an attacker who spins up resources in an unused region you don't normally monitor is a classic evasion technique; multi-region trails close that gap.
2. **Organization trail** - one trail captures every account in the AWS Organization, so no member account can quietly disable its own logging.
3. **Log file validation** (`--enable-log-file-validation`) - produces cryptographic digest files so you can prove logs weren't tampered with after the fact, which matters for both incident response credibility and compliance audits.
4. **Delivery to a security-owned account/bucket** - if logs live in the same account being attacked, an attacker with sufficient privilege can delete them. Centralizing logs in a separate, tightly locked-down security account is standard practice.

## Investigating an Incident: "Who Deleted This Security Group?"

A realistic walkthrough of the kind of question you'd get in a hands-on interview or actual incident:

**Step 1 - Find the event via CLI (fast, for a known timeframe):**

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=DeleteSecurityGroup \
  --start-time 2026-07-01T00:00:00Z \
  --end-time 2026-07-03T00:00:00Z
```

**Step 2 - For broader/historical investigation, query with Athena** (CloudTrail logs are JSON in S3 - Athena lets you SQL-query them directly):

```sql
SELECT eventtime, useridentity.arn, sourceipaddress, requestparameters
FROM cloudtrail_logs
WHERE eventname = 'DeleteSecurityGroup'
  AND eventtime BETWEEN '2026-07-01' AND '2026-07-03'
ORDER BY eventtime DESC;
```

**Step 3 - Pivot on the identity.** Once you have the `useridentity.arn` from the event, search for everything else that principal did around the same time - this is how a single suspicious event turns into a full timeline of a compromised credential or insider action.

**CloudTrail Lake** is the newer managed alternative to rolling your own Athena setup - it gives you a SQL-queryable data store for CloudTrail events without managing S3/Athena/Glue yourself, and is worth mentioning if asked about modern investigation tooling.

## Common Gaps That Undermine CloudTrail's Value

1. **Trail exists but data events are off** - management events alone won't show you data exfiltration from S3.
2. **Single-region trail** - misses activity in regions nobody normally uses.
3. **Logs stored in the same account being monitored** - no separation of duties; an attacker with admin access can delete the trail itself.
4. **Log file validation not enabled** - can't prove integrity if logs are ever challenged (e.g. in a legal/compliance context).
5. **Nobody's actually looking at the logs** - CloudTrail without a SIEM integration, alerting, or scheduled review is just very expensive storage.

## Best Practices Checklist

- [ ] Organization-wide (or account-wide, at minimum) trail enabled
- [ ] Multi-region trail so no region goes unmonitored
- [ ] Log file validation enabled
- [ ] Logs delivered to a separate, security-owned account/bucket
- [ ] Data events enabled for sensitive S3 buckets and Lambda functions
- [ ] Logs integrated with a SIEM or queryable via Athena/CloudTrail Lake
- [ ] Alerting configured on high-risk events (e.g. `DeleteTrail`, `StopLogging`, root login)

## Practice Next

- [GuardDuty](guardduty.md) - uses CloudTrail data as one of its detection inputs
- [IAM Security](iam-security.md) - most CloudTrail investigations end at an identity
- [AWS Security Overview](aws-security-overview.md)

## Credits/References

1. [AWS CloudTrail User Guide](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)
2. [CloudTrail Log File Validation](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-log-file-validation-intro.html)
3. [CloudTrail Lake](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-lake.html)
