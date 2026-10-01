# Harness Engineering and Loop Engineering

!!! note "Emerging practitioner vocabulary, not an established academic field"
    Unlike "Transformer" or "ReAct," the terms **harness engineering** and **loop engineering** come from 2025-2026 practitioner discourse around agentic coding tools (Claude Code, Cursor, Codex, Aider, Cline) rather than a single foundational paper. The underlying concepts are solid and worth knowing precisely; the terminology itself is still settling, and you'll see it used somewhat differently across different blogs and vendors. Treat the definitions below as the current practitioner consensus, not a standardized spec.

Read [Agentic AI Fundamentals](agentic-ai-fundamentals.md) first - this page is about the engineering discipline *around* the agent loop described there, not a replacement for it.

## Harness Engineering: Everything That Isn't the Model

If you're not the model, you're the harness. The harness is every piece of code, configuration, and execution logic surrounding a raw LLM API call that turns "a model that can emit tool-call JSON" into "a working agent product." Claude Code, Cursor, Codex, and Aider are all harnesses - the underlying model is often comparable across them, but the behavior you actually experience is dominated by what each harness does differently.

The term traces to OpenAI's own account of building Codex: a small engineering team (reportedly around three engineers) drove the agent to produce roughly a million lines of code across 1,500+ merged pull requests in five months, by treating the scaffolding *around* the model as the primary engineering surface rather than the model itself. The operating philosophy: humans steer, agents execute - and the harness is what makes that division of labor actually work in practice.

A practical breakdown of what the harness covers, using Claude Code's own architecture as a concrete example:

| Layer | What It Does |
|-------|----------------|
| **Memory** | Persistent project context loaded into every session (e.g. `CLAUDE.md`) - what the agent "knows" about this codebase without being told again each time |
| **Tools** | What the agent can actually call - file read/write, shell execution, MCP-connected external tools (see [MCP Security](../ai-security/mcp-security.md)) |
| **Permissions** | What the agent is *allowed* to do without asking - auto-approved vs. requires-confirmation vs. always-denied, configured per tool/action |
| **Hooks** | Code that runs before/after a tool call (pre-validation, post-logging, blocking a disallowed action outright) regardless of what the model intended |
| **Observability** | Session logs, audit trails, and transcripts - what lets a human reconstruct what the agent actually did after the fact |

A useful distinction worth internalizing: the **inner harness** is whatever the tool vendor built in - you can observe and work within it, but you can't change it. The **outer harness** is everything you configure or build on top (your own hooks, your own permission policy, your own tool definitions) - and that's where engineering effort on your side actually pays off, because it's the layer you control.

This is precisely why harness design, not raw model capability, is the real control point for [LLM03:2026 Excessive Agency](../ai-security/llm-security.md#llm03-excessive-agency): the model can only ever propose an action. The harness is what decides whether that action is permitted, logged, sandboxed, or requires human approval before it executes.

## Loop Engineering: Designing When the Loop Stops

If harness engineering is the scaffolding, loop engineering is the specific design of the run loop itself from [Agentic AI Fundamentals](agentic-ai-fundamentals.md#the-core-agent-loop) - most importantly, **how and when it terminates**. A loop with no explicit exit criteria either declares victory prematurely or never stops; both are real, observed failure modes in production agentic systems, distinct from a traditional program loop that just exits on a counter or a `break` statement.

Termination conditions worth designing explicitly, rather than leaving implicit:

- **Explicit completion signal** - the agent calls a dedicated "done" tool with a status (success/failure) and summary, or produces a plain-text response with no further tool calls and no pending error.
- **Budget/iteration cap** - a hard maximum on turns, tokens, or dollar cost, so a bug or an adversarial input can't cause unbounded spend. This is the loop-level control that backs [LLM06:2026 Unbounded Consumption](../ai-security/llm-security.md#llm06-unbounded-consumption) - the mitigation isn't just rate-limiting the API, it's bounding how many iterations any single agent run is allowed to take in the first place.
- **Stuck/repetition detection** - if the agent invokes the same tool with identical arguments several iterations in a row, that's a strong signal it's stuck, not making progress toward the goal. A well-instrumented loop keeps a short window of recent actions, detects the repeat, and exits with a diagnostic rather than continuing indefinitely.
- **Error-recovery exhaustion** - allow a bounded number of retry/recovery attempts after a tool call fails, then stop and escalate rather than retrying forever.
- **Premature-completion guard** - if the agent signals "done" while outstanding task items clearly remain unaddressed, the loop can reject the completion signal and nudge the agent to continue, rather than accepting a technically-valid but incomplete stop.
- **Human-in-the-loop escalation** - pause and hand control back to a human when the agent hits genuine ambiguity or is about to take a high-stakes, hard-to-reverse action - this is the loop-level implementation of the human-approval-gate mitigations covered in [Agentic AI Security](../ai-security/agentic-ai-security.md).

One academic framing worth knowing: rather than a binary success/failure, some recent work on this formalizes a small set of **named terminal states** - success, no-op, blocked, stalled, exhausted - since "the loop just stopped" conflates several meaningfully different outcomes that a harness should handle and log differently.

```python
# A minimal sketch of a loop with explicit termination logic
MAX_TURNS = 25
recent_actions = []

turn = 0
while turn < MAX_TURNS:
    plan = model.reason(context)
    action = model.act(plan)

    if action.is_completion_signal():
        break  # explicit success/failure signal

    if action in recent_actions[-3:]:
        log("stuck: repeated identical action 3x in a row")
        break  # stuck/repetition detection

    result = harness.execute_if_authorized(action)  # the harness decides, not the model
    context.append(result)
    recent_actions.append(action)
    turn += 1
else:
    log("exhausted: hit MAX_TURNS without a completion signal")
```

## Security Angle

Harness and loop design decisions are where most agentic risk is actually created or prevented - not in the model weights. Cross-reference:

- [LLM Security](../ai-security/llm-security.md) - **LLM03 Excessive Agency** (the harness grants more standing capability than the task needs) and **LLM06 Unbounded Consumption** (the loop has no budget/iteration cap)
- [Agentic AI & Agent Security](../ai-security/agentic-ai-security.md) - **ASI08 Cascading Failures** (a single fault propagates because the loop/harness has no circuit breaker between planning and execution) and **ASI10 Rogue Agents** (behavioral drift that a well-designed loop's termination/escalation conditions should catch before it compounds)

## Credits/References

1. [Addy Osmani: Agent Harness Engineering](https://addyosmani.com/blog/agent-harness-engineering/)
2. [awesome-harness-engineering](https://github.com/ai-boost/awesome-harness-engineering) - curated list of harness-engineering tools, patterns, and practices
3. ["Loop Engineering: Building Blocks, Adoption, and Impact"](https://arxiv.org/abs/2608.21884)
4. ["Stop Hand-Holding Your Coding Agent: Engineering the Loops that Replace Step-by-Step Prompting"](https://arxiv.org/abs/2607.00038)
5. ["Building Effective AI Coding Agents for the Terminal: Scaffolding, Harness, Context Engineering, and Lessons Learned"](https://arxiv.org/abs/2603.05344)
