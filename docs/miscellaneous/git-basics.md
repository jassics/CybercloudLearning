# Git Essentials with Examples

## Why a Security Site Has a Git Page

You'll use Git every day regardless of specialization - reviewing PRs for vulnerabilities, investigating when a risky change was introduced, or just not leaking a secret into history by accident. This page covers the commands you actually reach for, with a security lens layered on top of the basics.

## Core Commands

| Command | What it does |
|---------|---------------|
| `git clone <url>` | Copy a remote repo locally |
| `git status` | Show what's staged/unstaged/untracked |
| `git branch <name>` | Create a new branch |
| `git checkout -b <name>` / `git switch -c <name>` | Create and switch to a new branch |
| `git add <file>` | Stage changes |
| `git commit -m "message"` | Commit staged changes |
| `git push origin <branch>` | Push commits to remote |
| `git pull` | Fetch and merge remote changes |
| `git merge <branch>` | Merge another branch into the current one |
| `git rebase <branch>` | Replay current branch's commits on top of another branch |
| `git stash` / `git stash pop` | Temporarily shelve uncommitted changes and restore them later |

```bash
git clone https://github.com/jassics/CybercloudLearning.git
cd CybercloudLearning
git checkout -b fix/typo-in-docs
# ... make changes ...
git add docs/some-page.md
git commit -m "Fix typo in some-page.md"
git push origin fix/typo-in-docs
```

## The Security Angle: Never Commit Secrets

The most common Git-related security incident isn't a Git vulnerability - it's a human committing an API key, password, or private key straight into history.

**Prevent it before it happens:**

- Use a pre-commit hook with a secret scanner like [gitleaks](https://github.com/gitleaks/gitleaks) or `detect-secrets` so a commit containing an obvious secret pattern (`AKIA[0-9A-Z]{16}`, `-----BEGIN PRIVATE KEY-----`, etc.) never lands in the first place.
- `.gitignore` real secret files (`.env`, `*.pem`, `credentials.json`) *before* you ever create them, not after.

**If a secret already made it into history**, deleting the file in a new commit is NOT enough - the secret is still readable in the git log/blob history forever, for anyone with clone access. You have to rewrite history:

```bash
# Using git filter-repo (recommended over the older filter-branch)
git filter-repo --path path/to/secret-file --invert-paths

# Or with BFG Repo-Cleaner (faster for large repos)
bfg --delete-files secret-file.env
```

After either, you must force-push the rewritten history and **rotate the leaked credential immediately** - rewriting history doesn't undo the exposure if anyone already cloned/fetched before the rewrite, or if the secret was cached/indexed anywhere (CI logs, forks, GitHub's own caches).

!!! danger "Rotate first, clean up second"
    If you find a live secret in git history, treat the credential as compromised and rotate it *immediately* - don't wait until the history rewrite is done. History cleanup reduces future exposure; it doesn't undo past exposure.

## Commands Useful for Security Review Work

- **`git blame <file>`** - shows who last changed each line and in which commit - the first thing to run when you find a vulnerable line and need to understand intent/context.
- **`git log -S"<string>"`** - finds every commit that added or removed an exact string (the "pickaxe" search) - invaluable for finding when a hardcoded secret, a dangerous function call, or a specific config value was introduced.
  ```bash
  git log -S"AKIA" --all -p    # find every commit that touched something matching an AWS key pattern
  ```
- **`git diff <commit1> <commit2>`** - review exactly what changed between two points, essential for PR/code review.
- **`git log --all --full-history -- <path>`** - full history of a specific file, including through renames, useful when investigating how a vulnerable file evolved.
- **`git show <commit>`** - view the full diff and metadata of a single commit.

## Branching Workflow Basics

- **Feature branches** - one branch per change, merged via PR/code review, never commit security-relevant changes straight to `main`.
- **Merge vs. rebase** - merge preserves history exactly as it happened (useful for audit trails); rebase rewrites history to look linear (cleaner logs, but rewrites shared history - never rebase a branch others have already pulled).
- Protect `main`/`release` branches with required PR reviews and required status checks (SAST/SCA/tests passing) before merge - this is often the very first DevSecOps control any org sets up.

## Further Reading

- [jassics/cybersecurity-slides](https://github.com/jassics/cybersecurity-slides) - includes a "Git Fundamentals" slide deck (`Git-Fundamentals-Flexmind.pdf`) for a visual walkthrough
- [Secure Code Review](../product-security/application-security/secure-code-review.md) - how `git diff`/`git blame` fit into a structured review process

## Credits/References

1. [Pro Git Book (free)](https://git-scm.com/book/en/v2)
2. [gitleaks](https://github.com/gitleaks/gitleaks)
3. [git filter-repo](https://github.com/newren/git-filter-repo)
4. [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
