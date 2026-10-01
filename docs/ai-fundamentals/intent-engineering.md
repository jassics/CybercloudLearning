# Intent Engineering

!!! note "This term is still settling"
    Unlike prompt engineering (well-established since 2020-2022) and context engineering (coined mid-2025, now reasonably standardized around Anthropic's and LangChain's definitions - see [Context Engineering](context-engineering.md)), "intent engineering" is actively being defined by multiple independent practitioners and consultancies right now, with meaningfully different scopes depending on the source - some frame it around enterprise AI governance, others around product/coding-agent specification. What follows describes the real, underlying problem these sources agree exists, while being explicit about where the terminology itself is still unsettled.

## The Real Problem, Regardless of Label

A human gives an agent an ambiguous, underspecified goal: "clean up this codebase," "help me plan a trip," "reduce our cloud spend." A single-turn chatbot has no choice but to guess at what you meant on each individual response. An **agent**, by contrast, takes that ambiguous goal and turns it into a sequence of autonomous actions - which means a misread of your actual intent doesn't produce one wrong answer you immediately notice and correct. It can drive many actions, compounding on each other, before a human ever sees the result (see [Agentic AI Fundamentals](agentic-ai-fundamentals.md) for the planning-loop mechanics this depends on).

Closing that gap - whatever you call the discipline - requires three things:

1. **Disambiguation** - deciding when to ask a clarifying question versus when to proceed on a reasonable default assumption, and being explicit about which one happened.
2. **Scope-bounding** - stating what is explicitly *not* part of this request, not just what is, since agents will otherwise happily expand scope to anything plausibly related to the stated goal.
3. **Success-criteria definition** - a concrete, checkable definition of "done," so the agent (and the human reviewing its output) can tell whether the task was actually completed correctly, not just completed.

## How the Term Is Currently Used

Several independent sources ([Pathmode](https://pathmode.io/glossary/intent-engineering), [Coforge](https://blog.coforge.com/blog/the-3-layers-of-enterprise-ai-from-prompts-to-context-to-intent), and others writing in late 2025/early 2026) frame intent engineering as a layer that sits *above* prompt and context engineering: prompt engineering governs what you say to the model, context engineering governs what the model knows, and intent engineering governs what the agent is actually trying to achieve and under what constraints - turning human goals into machine-readable objectives, guardrails, and trade-off criteria that can be audited after the fact. A version of this used in coding-agent contexts frames it more narrowly: translating a user's problem into a structured specification precise enough that a human can review the decision and an agent can implement it without inventing product judgment on its own.

The common thread across all of these framings, regardless of which scope you adopt: **the quality of an agent's output is bounded by the quality of the objective it was actually given** - and that objective is rarely the literal sentence the human typed.

## A Practical Version of This Today

You don't need to wait for the terminology to settle to apply the underlying discipline:

- Have the agent restate its understood objective and constraints before acting, and let a human correct it before any action is taken - cheap, and catches most intent-translation failures before they compound.
- Write explicit out-of-scope statements for ambiguous requests ("don't touch the test suite," "don't make purchases over $50") rather than relying on the agent to infer reasonable boundaries.
- Define a checkable completion condition up front, not just a description of the work.

## Security Angle

A goal-hijack attack ([ASI01: Agent Goal Hijack](../ai-security/agentic-ai-security.md)) is, mechanically, an attacker overriding or corrupting the agent's objective *after* it's been established - attacker-controlled content (a document, an email, another agent's message) redirects what the agent is trying to accomplish. Understanding how intent gets established and bounded in the first place is a direct prerequisite to understanding how it gets subverted: a system with no explicit success criteria or scope boundary has nothing concrete for a defender to check the agent's behavior against, which is exactly the gap ASI01 exploits.

## Credits/References

1. [Pathmode: What Is Intent Engineering? Definition, Examples, and FAQ](https://pathmode.io/glossary/intent-engineering)
2. [Coforge: The 3 Layers of Enterprise AI - From Prompts to Context to Intent](https://blog.coforge.com/blog/the-3-layers-of-enterprise-ai-from-prompts-to-context-to-intent)
3. [OWASP Top 10 for Agentic Applications](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/) - ASI01 Agent Goal Hijack
