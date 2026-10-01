# AI Fundamentals Resources

Use this page as the "go deeper" reference for the whole [AI Fundamentals](index.md) section - standards and papers behind the architecture, books and courses to build real depth, and the tools you'll actually touch.

## Key Papers

| Paper | Relevance |
|-------|-----------|
| [Attention Is All You Need (Vaswani et al., 2017)](https://arxiv.org/abs/1706.03762) | The original Transformer architecture paper - see [LLM Architecture](llm-architecture.md) |
| [Chain-of-Thought Prompting Elicits Reasoning (Wei et al., 2022)](https://arxiv.org/abs/2201.11903) | Foundational reasoning-prompting technique - see [Prompt Engineering](prompt-engineering.md) |
| [Self-Consistency Improves Chain of Thought Reasoning (Wang et al., 2022)](https://arxiv.org/abs/2203.11171) | Majority-vote sampling over multiple reasoning paths |
| [ReAct: Synergizing Reasoning and Acting (Yao et al., 2022)](https://arxiv.org/abs/2210.03629) | The reasoning-plus-action interleaving pattern underlying most agent loops - see [Agentic AI Fundamentals](agentic-ai-fundamentals.md) |
| [Lost in the Middle (Liu et al., 2023)](https://arxiv.org/abs/2307.03172) | Position-dependent performance degradation in long contexts - see [Context Engineering](context-engineering.md) |
| [Xiao & Zhu, Foundations of Large Language Models](https://arxiv.org/abs/2501.09223) | Accessible coverage of pre-training, fine-tuning, prompting, and alignment |

## Books

| Book | Author |
|------|--------|
| [Hands-On Large Language Models](https://www.oreilly.com/library/view/hands-on-large-language/9781098150952/) | Jay Alammar & Maarten Grootendorst - heavily illustrated, covers Transformer internals through RAG and fine-tuning |
| [AI Engineering: Building Applications with Foundation Models](https://www.oreilly.com/library/view/ai-engineering/9781098166298/) | Chip Huyen - prompt engineering, RAG, fine-tuning, agents, and production serving tradeoffs |
| [Designing Machine Learning Systems](https://www.oreilly.com/library/view/designing-machine-learning/9781098107956/) | Chip Huyen - the ML-systems fundamentals underneath any LLM-specific stack |

## Courses

| Course | Provider |
|--------|----------|
| [ChatGPT Prompt Engineering for Developers](https://www.deeplearning.ai/courses/chatgpt-prompt-eng) | DeepLearning.AI (Isa Fulford, Andrew Ng) |
| [LangChain for LLM Application Development](https://www.deeplearning.ai/short-courses/langchain-for-llm-application-development/) | DeepLearning.AI |
| [Hugging Face NLP Course](https://huggingface.co/learn/nlp-course) | Hugging Face - free, covers Transformers library end to end |

## Tools

| Tool | Purpose |
|------|---------|
| [Hugging Face Transformers](https://github.com/huggingface/transformers) | The standard library for working with open-weight model architectures - see [Open-Weight vs. Closed Models](open-weight-vs-closed-models.md) |
| [LangChain](https://github.com/langchain-ai/langchain) | Framework for building LLM-powered applications and agents |
| [LlamaIndex](https://github.com/run-llama/llama_index) | Data-framework for connecting LLMs to retrieval/RAG pipelines - see [RAG Architecture](rag-architecture.md) |

## Blogs & Engineering Research

- [Anthropic Engineering Blog](https://www.anthropic.com/engineering) - applied context engineering, agent harness design, tool-use patterns
- [LangChain Blog](https://www.langchain.com/blog) - practitioner-level agent/context engineering writeups
- [Chip Huyen's Blog](https://huyenchip.com/blog/) - ML systems and AI engineering fundamentals

## Where to Go Next on This Site

- Start from the top: [AI Fundamentals Overview](index.md)
- Apply it to security: [AI Security Overview](../ai-security/ai-security-overview.md)
- Already comfortable with architecture? Jump to [LLM Security](../ai-security/llm-security.md) and [Agentic AI Security](../ai-security/agentic-ai-security.md) directly

## Credits/References

1. [OWASP GenAI Security Project](https://genai.owasp.org/)
2. [Anthropic Engineering Blog](https://www.anthropic.com/engineering)
3. [Hugging Face](https://huggingface.co/)
