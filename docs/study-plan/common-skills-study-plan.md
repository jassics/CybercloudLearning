# Common Skills for Cybersecurity Study Plan

This page is updated based on [jassics/security-study-plan/common-skills-study-plan](https://github.com/jassics/security-study-plan/blob/main/common-skills-study-plan.md)

Whichever domain you choose in the cybersecurity umbrella - Application Security, Cloud Security, DevSecOps, or anything else - there are common skills you must learn to excel. See the [common skills breakdown](https://github.com/jassics/cybersecurity-roadmap/blob/main/common-skills.md) in the cybersecurity-roadmap repo for the full picture.

This page focuses on **where to study and how much time to devote** to each of these 5 common skills so you're job-ready and interview-ready.

## ToC
1. [Linux Basics and Linux Commands](#linux-basics-and-linux-commands) - 1-2 weeks
2. [Networking Fundamentals](#networking-fundamentals) - 2-4 weeks
3. [Programming Skills](#programming-skills) - 4-8 weeks
4. [Cloud Computing](#cloud-computing) - 3-4 weeks
5. [Git Commands](#git-commands) - 1 week
6. [Networking Matters](#networking-matters)

## Linux Basics and Linux Commands
**Duration: 1-2 weeks**

It should not take more than a week to be comfortable with basic Linux commands for day-to-day activities. Once comfortable, move to networking and other security-related commands.

### Week 1: Basic Commands
Bug bounty hunters, penetration testers, and almost all tech-focused security professionals use an OS like Kali Linux, Parrot OS, or BlackArch Linux, which come loaded with security tools. But you need to know the basic workings of Linux and its commands first.

**Some common (50) commands, in alphabetical order:**

1. `awk`, `cat`, `cd`, `chmod`, `chown`, `cp`, `curl`, `dig`, `du`, `df`
2. `echo`, `export`, `find`, `grep`, `head`, `history`, `host`, `ifconfig`, `kill`, `less`
3. `locate`, `ls`, `man`, `mkdir`, `more`, `mount`, `mv`, `nslookup`, `ping`, `ps`
4. `pwd`, `rm`/`rmdir`, `scp`, `sed`, `service`/`systemctl`, `sort`, `ssh`, `sudo`, `tail`, `tar`
5. `top`, `touch`, `uname`, `uniq`, `wget`, `whois`, `whatis`, `w`, `wc`, `zip`

See the site's own [Linux Commands](../miscellaneous/linux-commands.md) reference for detailed usage.

### Week 2: Security-Focused Commands
**Beyond the basics, commands security professionals (mainly AppSec and pentesters) rely on:**

1. `netcat`, `nslookup`, `host`, `dig`, `netstat`, `traceroute`
2. `nmap`, `nikto`, `fierce`, `dirb`
3. install/uninstall/update/upgrade package management
4. `find`, `grep`, `ifconfig`
5. Basics of [regular expressions](../miscellaneous/regular-expression.md)
6. Starting and stopping services
7. Basic understanding of `/opt`, `/tmp`, and log server locations
8. Comfort running scripts written in Python, Ruby, Go, etc.

### Resources

**Books**

1. [Linux Basics for Hackers](https://www.amazon.in/Linux-Basics-Hackers-Networking-Scripting/dp/1593278551/) - Recommended
2. [The Linux Command Line](https://www.amazon.in/Linux-Command-Line-2nd-Introduction/dp/1593279523/)
3. [How Linux Works](https://www.amazon.in/How-Linux-Works-Brian-Ward/dp/1718500408/)

**Courses**

1. [Introduction to Linux Commands and Scripting](https://www.coursera.org/learn/hands-on-introduction-to-linux-commands-and-shell-scripting)
2. [Linux Fundamentals for Security Practitioners](https://www.cybrary.it/course/linux-fundamentals-for-security-practitioners/) - Recommended

## Networking Fundamentals
**Duration: 2-4 weeks**

Except for Audit and Compliance roles, almost every security professional needs a basic-to-intermediate understanding of computer networks.

### Week 3-4: Core Concepts
1. IPv4/IPv6, CIDR, IP addressing and subnetting
2. Public vs private IPs, TCP/IP model
3. DMZs, Zero Trust networks
4. Common ports and protocols (22, 25, SSH, HTTPS, and so on)
5. Understanding of common cryptographic modules and functions
6. How DNS works, how SSL works

### Week 5-6: Network Security
1. Common network threats
2. MiTM, network sniffing
3. Various TCP attacks
4. DoS and DDoS attacks and prevention
5. Firewalls and software-defined networks
6. Basic network troubleshooting (why the internet is slow/down, Wi-Fi issues, etc.)

### Resources

**Books**

1. [Computer Networking: A Top-Down Approach](https://www.amazon.in/Computer-Networking-Top-Down-Kurose-James/dp/9332585490/r) - Recommended
2. [Networking All-in-One For Dummies](https://www.amazon.in/Networking-All-One-Dummies-Doug/dp/1119471605)

**Videos**

1. [Basics of Computer Networking](https://www.youtube.com/watch?v=0j6-QFnnwQk)
2. [Computer Networking Full Course](https://www.youtube.com/watch?v=qiQR5rTSshw&t=14s) - Recommended

**Courses**

1. [Computer Networking by Georgia Tech on Udacity](https://www.udacity.com/course/computer-networking--ud436) - Recommended
2. [Bits and Bytes of Computer Networking by Google on Coursera](https://www.coursera.org/learn/computer-networking)

Also see this site's own [Network Security Overview](../product-security/network-security/network-security-overview.md) and the dedicated [Network Security Study Plan](cybersecurity/network-security-study-plan.md).

## Programming Skills
**Duration: 4-8 weeks**

A decent knowledge of at least one programming language is now mandatory for most tech security roles. Common languages that attract security folks: Python (recommended), Go (gaining popularity), Ruby.

### Week 7-10: Basics & Projects
**What to try when learning any of these languages:**

1. Learn basic concepts
2. Try a few basic projects, such as:
   1. Connecting to a DB and fetching data
   2. Extracting data from a webpage
   3. Displaying info from the cloud, e.g. AWS instance details region-wise
   4. Automating security tasks - a docker monitor, fetching public IPs, server details, etc.
   5. Working with CSV/JSON
   6. Using crypto modules
   7. Simulating a few Linux/other commands to build comfort with the language, e.g. a small `nmap` simulation

### Week 11-14: Security Focus
1. Understand OOP concepts well enough to comfortably read others' code
2. Review source code from a security perspective
3. [Read Python Security Best Practices](https://snyk.io/blog/python-security-best-practices-cheat-sheet/)

This site's [Python Track](../python-track/python-track-overview.md) and the [jassics/python-for-cybersecurity](https://github.com/jassics/python-for-cybersecurity) repo have hands-on code you can work through directly.

### Resources

**Books**

1. [Learn Python 3 the Hard Way](https://www.amazon.in/Learn-Python-Hard-Way-Introduction/dp/0134692888/) - Recommended
2. [Violent Python](https://www.amazon.in/Violent-Python-Cookbook-Penetration-Engineers/dp/1597499579)
3. [Black Hat Python](https://www.amazon.in/Black-Hat-Python-2nd-Programming/dp/1718501129/) - Must read
4. [Full Stack Python Security](https://www.manning.com/books/full-stack-python-security) - Must for AppSec professionals
5. [Mastering Python for Networking and Security](https://www.oreilly.com/library/view/mastering-python-for/9781788992510/)

**Videos**

1. [Python Security Best Practices](https://www.youtube.com/watch?v=ZDzDpapddPg)
2. [Security Checks for Python Code](https://www.youtube.com/watch?v=zVIfH89oWno)
3. [Intro to Python for Security Professionals](https://www.youtube.com/watch?v=pFMzgPGfl4w)

**Courses**

1. [Python for Cybersecurity Specialization](https://www.coursera.org/specializations/pythonforcybersecurity)
2. [SEC573: Automating Information Security with Python](https://www.sans.org/cyber-security-courses/automating-information-security-with-python/)
3. [Python for Pentesters](https://www.pentesteracademy.com/course?id=1)

## Cloud Computing
**Duration: 3-4 weeks**

Cloud computing is everywhere - industrial, pharma, finance, IT, and more. Sooner or later, it will be a mandatory skill for any cybersecurity job role.

### Week 15-18: Cloud Fundamentals
Learn any of the major CSPs (AWS, Azure, or GCP) and:

1. Understand how it solves traditional infrastructure challenges
2. Understand what new security challenges it introduces
3. Understand the various service and deployment models
4. Understand the Shared Responsibility Model
5. Understand microservices
6. Master IAM functionality (must understand very well)
7. Understand data encryption
8. Understand cloud networking - critical to succeed in cloud security

For a deeper focus on identity and access, see the [IAM Security Study Plan](https://github.com/jassics/security-study-plan/blob/main/iam-security-study-plan.md).

Dedicated cloud security study plans on this site:

1. [AWS Security Study Plan](cloud-security/aws-security-study-plan.md)
2. [Azure Security Study Plan](cloud-security/azure-security-study-plan.md)
3. [GCP Security Study Plan](cloud-security/gcp-security-study-plan.md)

### Resources

**Books**

1. Cloud Computing for Dummies
2. [AWS in Action](https://www.manning.com/books/amazon-web-services-in-action)

**Videos**

1. [Cloud Computing Playlist by Flexmind](https://www.youtube.com/playlist?list=PLRTsCutScZnyfH0NLaOJxDEn2ZWZuBlup)
2. [What is Cloud Computing by AWS](https://www.youtube.com/watch?v=mxT233EdY5c)
3. [Inside a Cloud Data Center](https://www.youtube.com/watch?v=XZmGGAbHqa0)

**Courses**

1. [Introduction to Cloud Computing by IBM on Coursera](https://www.coursera.org/learn/introduction-to-cloud)
2. [Micro Masters Program in Cloud Computing](https://www.edx.org/micromasters/usmx-umgc-cloud-computing)

## Git Commands
**Duration: 1 week**

You must understand a version control system, and Git is the standard today. Skip GUI clients like SourceTree and learn the terminal-level commands - they transfer everywhere.

### Week 19: Git Basics
**Most basic Git commands to understand:**

1. `git clone`, `git add`, `git commit`, `git branch`, `git pull`
2. `git fetch`, `git merge`, `git push`, `git config`, `git log`

Many job roles require this as a mandatory skill: Application Security, Penetration Testing, DevSecOps, API Security, Security Engineering. See this site's own [Git Essentials with Examples](../miscellaneous/git-basics.md).

### Resources

**Books**

1. [Pro Git](https://git-scm.com/book/en/v2) - Highly recommended
2. [GitHub cheatsheet](https://education.github.com/git-cheat-sheet-education.pdf)

**Videos**

1. [Git and GitHub for Beginners - Crash Course by freeCodeCamp](https://www.youtube.com/watch?v=RGOj5yH7evk)
2. [Git Fundamentals for Beginners - Full Course by Flexmind](https://www.youtube.com/watch?v=zyB-6U7DRKI)

**Courses**

1. [Git Fundamentals for Everyone on Udemy](https://www.udemy.com/course/git-basics-for-everyone/)
2. [Version Control with Git by Atlassian on Coursera](https://www.coursera.org/learn/version-control-with-git)
3. [Learn Git and GitHub by Codecademy](https://www.codecademy.com/learn/learn-git)

## Networking Matters
Once you're on track and understand the fundamentals, it's time to:

1. Make good LinkedIn contacts in the security domain you're targeting
2. Find a mentor, or follow someone who shares blogs, tutorials, and talks on these topics
3. Make connections through security conferences, online or offline
4. Publish a few good security articles - basic concepts are fine, but publish
5. Join webinars, conferences, and newsletters
6. Help a beginner who's struggling - you learn better while teaching others

By the time you've worked through this checklist, you'll already be on your way to a strong start in a security job role. All the best!

**Practice next:** [jassics/security-interview-questions](https://github.com/jassics/security-interview-questions/blob/main/common-security-interview-questions.md) for common interview questions, and the [security-study-plan](https://github.com/jassics/security-study-plan) repo for the latest updates to this plan.
