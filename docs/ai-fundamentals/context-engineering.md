# Context Engineering

## A Broader Frame Than Prompt Engineering

"Context engineering" is a term that gained real traction in mid-to-late 2025 as production agent systems exposed the limits of thinking only about the prompt. Anthropic's applied engineering team defines it as "the set of strategies for curating and maintaining the optimal set of tokens (information) during LLM inference, including all the other information that may land there outside of the prompts" - the system prompt is just one input competing for space alongside conversation history, retrieved documents, tool definitions, and persistent memory. [LangChain's framing](https://www.langchain.com/blog/context-engineering-for-agents) is practically identical: context engineering is "the art and science of filling the context window with just the right information at each step of an agent's trajectory," broken into four recurring strategies - **write** (persist information outside the immediate context, e.g. to a scratchpad or memory store), **select** (pull in only what's relevant to the current step), **compress** (summarize or trim as the window fills), and **isolate** (keep different concerns in separate context, e.g. per-subagent).

[Prompt Engineering](prompt-engineering.md) is now best understood as a subset of context engineering: how you word the instruction matters, but in a production agent, the instruction is a small fraction of what's actually in the context window.

## The Context Budget Problem

Everything competes for the same finite token budget (see [LLM Architecture](llm-architecture.md) for what the context window actually is):

| Consumer | Notes |
|----------|-------|
| System prompt | Usually small, but grows if it accumulates every edge-case instruction over time |
| Tool/function definitions | Every tool exposed to the model costs tokens for its name, description, and parameter schema - see [Harness & Loop Engineering](harness-and-loop-engineering.md) |
| Conversation history | Grows unboundedly in a long-running session unless actively managed |
| Retrieved documents | RAG chunks pulled in per-query - see [RAG Architecture](rag-architecture.md) |
| Memory | Facts/state persisted across sessions and re-injected |

A harness that exposes 40 tools "just in case" is spending real context budget on every single turn, whether or not any of those tools get used - this is a concrete engineering tradeoff, not a free design choice.

## Context Compaction

When a conversation or agent run grows long enough to threaten the context budget, the common strategies are: **summarization** (periodically collapse older turns into a condensed summary rather than keeping full verbatim history), **sliding window** (keep only the N most recent turns, accepting loss of older detail), and **selective retention** (keep structurally important turns - e.g. the original task statement, key decisions - while summarizing routine back-and-forth). Naive truncation (just dropping the oldest messages) is the worst of these options for anything where early context (the original goal, a constraint stated once) matters for the rest of the run.

## Selective Retrieval and Injection

Pulling in everything potentially relevant "to be safe" is a common anti-pattern: it burns context budget and, per the "lost in the middle" effect below, can actually make the genuinely relevant information harder for the model to use. Good context engineering retrieves narrowly for the current step rather than broadly for the whole task - see [RAG Architecture](rag-architecture.md) for chunking/retrieval strategy, which is the mechanism that determines how narrow "narrow" actually is in practice.

## Position Matters: "Lost in the Middle"

[Liu et al., 2023](https://arxiv.org/abs/2307.03172) found that model performance on long-context tasks is highest when the relevant information is at the very beginning or very end of the context, and degrades significantly when it's buried in the middle - even for models explicitly designed for long contexts. The practical consequence for context engineering: where you place information in the context window is itself a design decision, not just what you include. Critical instructions or the most relevant retrieved chunk shouldn't be left to float in the middle of a large context dump.

## Tool-Definition Context Cost

Every tool schema exposed to the model is simultaneously a context-budget cost and part of the attack surface: it's text the model reads and can be influenced by, exactly like any other context content (see [Harness & Loop Engineering](harness-and-loop-engineering.md) for how tool definitions get wired into a loop, and the next section for why this specific overlap matters for security).

## Security Angle

Context engineering decisions directly determine what's discoverable and what's leakable. Everything you choose to put in context - including things you assume are "hidden" from the end user, like a detailed system prompt or an internal policy document pulled in via RAG - is still something the model has read and can, in principle, be induced to reveal or act on; see [LLM08: Hidden Context Exposure](../ai-security/llm-security.md) for the full treatment of why "the model won't repeat that" is not a security boundary. Tool definitions are a specific, high-value case of this: they're part of your context budget *and* part of your attack surface at the same time, since a maliciously-crafted tool description is read by the model identically to a legitimate one (see [MCP Security](../ai-security/mcp-security.md)'s coverage of tool poisoning).

## Credits/References

1. [Anthropic: Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
2. [LangChain: Context Engineering for Agents](https://www.langchain.com/blog/context-engineering-for-agents)
3. Liu et al., ["Lost in the Middle: How Language Models Use Long Contexts"](https://arxiv.org/abs/2307.03172)
