# ViM for Everyone

## Why Vim Matters for Incident Response

You will, at some point, SSH into a box with nothing but a bare terminal - no GUI, no VS Code Remote, sometimes not even `nano` installed. This happens most often exactly when it matters most: investigating a compromised production server, working on an air-gapped system, or editing a config on a minimal container image mid-incident. Vim (or at minimum `vi`) is available almost everywhere by default, which is precisely why it's worth being fluent in it rather than fighting it.

## The Three Modes

| Mode | Purpose | How to enter |
|------|---------|----------------|
| **Normal** | Navigation and commands (the default mode) | `Esc` from any other mode |
| **Insert** | Actually typing text | `i`, `a`, `o` from Normal mode |
| **Visual** | Selecting text for an operation | `v` (character), `V` (line), `Ctrl+v` (block) from Normal mode |

The single most common beginner mistake: typing commands while still in Insert mode, which just inserts those letters as text. Always `Esc` back to Normal mode before issuing a command.

## Essential Navigation

| Command | Action |
|---------|--------|
| `h` `j` `k` `l` | Left, down, up, right |
| `w` / `b` | Jump forward/backward one word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Start / end of file |
| `:n` | Jump to line `n` |
| `Ctrl+f` / `Ctrl+b` | Page forward / backward |
| `%` | Jump to matching bracket/paren |

## Essential Editing

| Command | Action |
|---------|--------|
| `i` / `a` | Insert before / after cursor |
| `o` / `O` | Open new line below / above |
| `dd` | Delete (cut) current line |
| `yy` | Yank (copy) current line |
| `p` / `P` | Paste after / before cursor |
| `x` | Delete character under cursor |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `.` | Repeat last change - underrated, huge time-saver |
| `:w` | Save |
| `:q` | Quit |
| `:wq` or `ZZ` | Save and quit |
| `:q!` | Quit without saving |

## Search and Replace (with Regex)

```
/pattern          " search forward for pattern
?pattern          " search backward
n / N             " next / previous match

:%s/old/new/g     " replace all occurrences of old with new, whole file
:%s/old/new/gc    " same, but confirm each replacement
```

Vim's search/replace supports full regex - see [Regular Expression Essentials](regular-expression.md) for the syntax. A realistic incident-response example: you SSH into a compromised host and need to comment out a malicious cron entry:

```
:%s/^\(.*malicious-domain\.com.*\)$/#\1/
```

This wraps any line containing `malicious-domain.com` in a comment, using a capture group and backreference (`\1`) to preserve the original line content.

## Why This Matters Specifically for Incident Response

- Production and compromised hosts often have minimal tooling installed by design (smaller attack surface) - `vi`/`vim` is POSIX-standard and present essentially everywhere, unlike `nano` or a GUI editor.
- Air-gapped or restricted environments (common in regulated/critical infrastructure environments) may not allow installing new tools mid-investigation - you work with what's there.
- Being fast in vim means less time fumbling with the editor and more time on the actual investigation, which matters when you're on the clock during an active incident.

## Quick Reference Cheat Sheet

| Task | Command |
|------|---------|
| Save and exit | `:wq` |
| Discard changes and exit | `:q!` |
| Delete a line | `dd` |
| Copy a line | `yy` |
| Undo | `u` |
| Find text | `/text` then `n` for next match |
| Replace all in file | `:%s/old/new/g` |
| Go to line 42 | `:42` |
| Select a block, then delete | `Ctrl+v`, select, `d` |
| Show line numbers | `:set number` |

## Credits/References

1. [Vim official documentation](https://www.vim.org/docs.php)
2. `vimtutor` - the built-in interactive tutorial, run it from any terminal with Vim installed
3. [Regular Expression Essentials](regular-expression.md) - the regex syntax used in Vim's search/replace
