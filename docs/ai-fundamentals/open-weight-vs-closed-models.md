# Open-Weight vs. Closed Models

## The Actual Distinction

**Open-weight** means the trained model's weights (parameters) are published and downloadable - you can run the model on your own infrastructure, inspect it, and fine-tune it directly. Examples: Llama, Mistral, DeepSeek, Qwen, Gemma. **Closed** (or "proprietary"/API-only) means you can only access the model through a vendor's hosted API - you send a request, you get a response, you never touch the weights. Examples: the flagship GPT, Claude, and Gemini models.

**Open-weight is not the same as open source.** A genuinely open-source project publishes its training data, training code, and methodology alongside the weights, so the whole pipeline is reproducible. Almost no open-weight model does this - you get the finished weights, not the recipe that produced them. This distinction matters practically: you can run and fine-tune an open-weight model freely, but you usually still can't verify what data went into it or fully reproduce it from scratch, which is directly relevant to the supply-chain and provenance concerns below.

Licensing varies more than "open-weight" implies and is worth checking per model, not assumed uniform:

| Model Family | License | Commercial Use |
|--------------|---------|------------------|
| Mistral | Apache 2.0 | Fully open |
| Qwen3 | Apache 2.0 (most variants) | Fully open |
| DeepSeek (V3/R1 and later) | MIT | Fully open |
| Gemma 4 | Apache 2.0 (Gemma 3 used a more restrictive source-available license) | Fully open as of Gemma 4 |
| Llama 4 | Meta Community License + Acceptable Use Policy | Open-weight but not OSI-recognized open source; carries usage restrictions (e.g. at very large scale) |

## Comparison

| Dimension | Open-Weight (self-hosted) | Closed (API-only) |
|-----------|------------------------------|------------------------|
| **Deployment control** | Full - run on-prem, air-gapped, or any cloud you choose | None - you depend entirely on the vendor's infrastructure and uptime |
| **Cost model** | Compute/hosting cost, scales with your own infrastructure efficiency | Per-token API pricing, scales directly with usage |
| **Customization** | Full fine-tuning, quantization, and architecture-level experimentation possible | Limited to prompting, and whatever fine-tuning API the vendor exposes (if any) |
| **Data residency/privacy** | Data never leaves your infrastructure if self-hosted | Data is sent to the vendor's servers - subject to their retention/training-on-your-data policy |
| **Security/support responsibility** | You own model security, patching, and infrastructure hardening end-to-end | Vendor handles model-level security; you still own your application layer around it |
| **Update cadence** | You choose when to adopt a new model version | Vendor controls versioning; a model can be deprecated or silently updated on their schedule |

## Security Tradeoffs

**Open-weight models put you in charge of the full supply chain** - which is more control, but also more responsibility. You're the one who has to verify the model file isn't tampered with (see [AI Supply Chain Security](../ai-security/ai-supply-chain-security.md) for the pickle/malicious-weights risk and tools like `weightguard` built specifically for this), vet the publisher, and maintain your own patching/update discipline. In exchange, you get real data-residency control - sensitive data can be processed entirely within infrastructure you control, which matters for regulated industries or genuinely air-gapped environments where sending data to any third-party API is a non-starter regardless of that vendor's security posture.

**Closed models shift model-level security to the vendor** - they handle infrastructure hardening, abuse monitoring, and (for the major providers) dedicated security research on their own models. The tradeoff: you have no visibility into training data provenance, you're trusting the vendor's data-retention and logging policies with whatever you send them, and you have zero control over when the underlying model changes behavior from an update. This is a trust decision, not a technical one - read the vendor's actual data-handling terms rather than assuming "closed = secure."

## The Managed-API Middle Ground

A growing third option: open-weight models served through a managed inference API - providers like **Together AI**, **Groq** (notable for very fast inference via custom LPU hardware), and **Fireworks AI** (focused on production reliability, function calling, structured output). This gives you model choice and the economics of open-weight models (often cheaper and faster than the closed-model equivalents) without the operational burden of running your own GPU infrastructure - but you're back to sending data to a third party, so the data-residency argument for self-hosting open-weight models doesn't apply here. Treat this as its own distinct risk profile, not simply "open-weight security" by association.

## Credits/References

1. [State of Open-Weight AI Models: gpt-oss, Llama, Qwen, DeepSeek, Gemma, and More](https://kingy.ai/blog/state-of-open-weight-ai-models/)
2. [Hugging Face: Best Open-Source LLM Models in 2026](https://huggingface.co/blog/daya-shankar/open-source-llms)
3. [AI Supply Chain Security](../ai-security/ai-supply-chain-security.md) - the model-file integrity risks that apply specifically to self-hosted open-weight models

## Practice Next

- [AI Supply Chain Security](../ai-security/ai-supply-chain-security.md) for model-file tampering, provenance, and SBOM practices
- [LLM Architecture](llm-architecture.md) for what you're actually getting when you download a model's weights
