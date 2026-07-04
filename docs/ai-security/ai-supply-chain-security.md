# AI Supply Chain Security

## Why This Is Different From Regular Software Supply Chain Security

You already know the general discipline from [SCA](../product-security/application-security/sca.md): track your dependencies, scan for known CVEs, generate an SBOM. AI systems have that exact same problem, plus several that don't exist in regular software:

| Regular Software Supply Chain | AI/ML Supply Chain (adds) |
|-------------------------------|----------------------------|
| Code dependencies (npm, pip, Maven) | Pretrained model weights, often pulled from Hugging Face Hub or similar with little to no vetting |
| Build pipeline integrity | Training data provenance - often unverifiable, sometimes scraped from the open web |
| Vendor code review | Third-party fine-tuning services that touch your data *and* your model |
| Package registries | Model registries/hubs with weaker publisher verification than most package registries |

The core problem: a "dependency" in AI isn't just code anymore - it's a multi-gigabyte binary artifact (the model weights) that you can't read, that can execute code just by being **loaded**, and whose training history you usually can't fully audit.

## The Pickle Problem: Malicious Model Files

PyTorch's traditional save format (`.pt`/`.pth`) is Python's `pickle` serialization under the hood. Pickle's `load()` function doesn't just deserialize data - it can execute arbitrary Python code embedded in the file, as part of deserialization. This means **loading** a model file can compromise your system before you ever run inference on it.

This isn't theoretical. In February 2025, ReversingLabs identified malicious Pickle-based models hosted on Hugging Face - nicknamed **nullifAI** - that used broken or 7z-wrapped pickle files specifically crafted to evade Picklescan (Hugging Face's built-in scanner) while still executing on load, delivering a reverse shell in the researchers' proof-of-concept.

**The fix: use `safetensors` instead of pickle-based formats.** Hugging Face's `safetensors` format stores only tensor data - no executable code path exists in its loader, by design.

```python
# Risky: pickle-based load can execute arbitrary code embedded in the file
import torch
model_state = torch.load("downloaded_model.pt")  # don't do this with an untrusted source

# Safer: safetensors has no code-execution path in its loader
from safetensors.torch import load_file
model_state = load_file("downloaded_model.safetensors")
```

Most popular models on Hugging Face now ship a `safetensors` variant alongside the legacy `.bin`/`.pt` file - prefer it whenever it's available, and treat any model that's *only* available as a raw pickle file as a stronger reason to scan before loading.

## Model Provenance and Verification

Treat a downloaded model exactly like any other untrusted third-party artifact you'd never load from source unknown:

- **Verify the publisher** - is this the actual model author's official Hugging Face org/account, or a re-upload with a similar name? Typosquatting and impersonation happen on model hubs just like package registries.
- **Check for a model card** - a legitimate, actively-maintained model usually documents its training data, intended use, and known limitations. A model with no card, no discussion, and a brand-new account is a red flag.
- **Verify checksums/signatures where the publisher provides them.**
- **Scan before loading**, using real tools built for exactly this:
    - [**ModelScan**](https://github.com/protectai/modelscan) - scans for serialization attacks (pickle, Keras, etc.)
    - [**Fickling**](https://github.com/trailofbits/fickling) (Trail of Bits) - decompiler, static analyzer, and safety scanner specifically for malicious pickle/PyTorch files
    - [**ModelAudit**](https://github.com/promptfoo/modelaudit) - static scanner covering 40+ ML model file formats for malicious code/backdoors

## AI/ML SBOM ("ML-BOM")

A regular [SBOM](../product-security/application-security/sca.md) inventories your code dependencies. An AI/ML system needs that plus model-specific provenance metadata:

- **Base model lineage** - what foundation model was this fine-tuned or distilled from?
- **Training/fine-tuning data sources** - what data went into it, and under what license/consent terms?
- **ML framework and library versions** - PyTorch, TensorFlow, `transformers`, `diffusers`, etc. - these have their own CVEs like any other dependency.
- **Model license terms** - many open-weight models carry usage restrictions (research-only, no-commercial-use, attribution requirements) that a standard software SBOM has no field for.

[**AIsbom**](https://aisbom.io/) is a real, purpose-built tool here - a CLI that scans model files for embedded malware and generates CycloneDX/SPDX-format AI SBOMs covering this model-specific metadata, so "are we affected by the next nullifAI-style incident" becomes a query instead of a fire drill.

## SLSA: Applying Build-Provenance Thinking to Models

[**SLSA**](https://slsa.dev/) (Supply-chain Levels for Software Artifacts) is a framework - originally incubated at Google, now governed under the Open Source Security Foundation (OpenSSF) and the Linux Foundation - that defines graduated levels of confidence in *how verifiably an artifact's build process can be trusted*, rather than just scanning the artifact after the fact.

The current SLSA specification (v1.x) defines a **Build track** with four levels:

| Level | Requirement |
|-------|-------------|
| **L0** | No guarantees - no SLSA controls in place |
| **L1** | Provenance exists - you can see how the artifact was built (build platform, process, top-level inputs), which helps catch mistakes but doesn't prevent tampering |
| **L2** | Hosted build platform - the provenance is cryptographically signed and tied to that build infrastructure, so it can't be silently forged after the fact |
| **L3** | Hardened builds - strong isolation between build runs, and build secrets aren't accessible to user-defined build steps, protecting against tampering *during* the build itself |

**Applying this to AI artifacts is an emerging practice, not a finished standard.** The question SLSA-style thinking asks of a model file is: *can you prove this model came from the training/build pipeline you expect, with no tampering in between - and can you prove it cryptographically, not just by trusting a filename?* Full SLSA compliance tooling for ML training pipelines is far less mature than it is for traditional software builds (where GitHub Actions attestations, Sigstore, and similar tooling are common), but the same core principle - verifiable provenance over blind trust - is exactly what an AI/ML SBOM and model-signing practice is reaching toward. Don't present this as a solved problem in an interview; present it as the direction the industry is moving, with SLSA as the vocabulary for describing *how much* provenance guarantee you actually have.

## Dependency Risks: Malicious Packages in the ML Ecosystem

The Python packaging ecosystem that AI/ML tooling depends on is just as exposed to supply-chain compromise as any other. In 2025, **LiteLLM** - a widely-used library for calling multiple LLM providers through one interface - had its PyPI package compromised, illustrating that the risk isn't limited to model files; it extends to every library in your AI stack, exactly the class of risk [SCA](../product-security/application-security/sca.md) already exists to catch. Run SCA scanning against your AI/ML dependencies with the same rigor as the rest of your stack - don't treat `pip install` for an AI library as lower-risk just because the ecosystem is newer.

## Third-Party Fine-Tuning and Vendor Risk

Sending your data to a third-party service to fine-tune a model introduces risks that don't exist when you're just calling a hosted inference API:

- **Data leakage** - your fine-tuning data (which may include proprietary or sensitive information) now lives with a third party, potentially retained beyond the engagement.
- **Model backdooring** - a malicious or compromised fine-tuning provider can poison the resulting model with a backdoor (behavior that only triggers on a specific hidden input pattern), and you'd have no visibility into training internals to catch it.
- **Contractual due diligence matters as much as the technical review** - data handling terms, retention/deletion guarantees, and whether the vendor trains its *own* models on your data, need to be nailed down in the contract, not assumed.

## Checklist

- [ ] Prefer `safetensors` over pickle-based (`.pt`/`.pth`) model formats wherever available
- [ ] Scan every downloaded model file before loading it (ModelScan, Fickling, or ModelAudit)
- [ ] Verify model source/publisher and check for a real, maintained model card
- [ ] Maintain an AI/ML SBOM covering base-model lineage, training data sources, and framework versions (e.g. via AIsbom)
- [ ] Run standard SCA against your ML framework and library dependencies, same as any other code
- [ ] Pin ML framework/library versions rather than floating on `latest`
- [ ] Vet third-party fine-tuning vendors' data handling, retention, and training-on-your-data policies contractually
- [ ] Apply SLSA-style provenance thinking to your own model training/build pipeline - can you prove what went into your model, cryptographically, not just by filename?

## Practice Next

- [AI Model Security](ai-model-security.md) for the broader model-lifecycle threats (extraction, inversion, adversarial attacks)
- [SCA](../product-security/application-security/sca.md) for the general dependency-scanning and SBOM concepts this page extends
- [AI Security Incidents](ai-security-incidents.md) for real-world cases including nullifAI and the LiteLLM compromise
- [AI Security Resources](ai-security-resources.md) for more tools and further reading

## Credits/References

1. [SLSA (Supply-chain Levels for Software Artifacts)](https://slsa.dev/)
2. [ReversingLabs: nullifAI - Malicious ML Model Hosted on Hugging Face](https://www.reversinglabs.com/blog/rl-identifies-malware-ml-model-hosted-on-hugging-face)
3. [LiteLLM on PyPI Was Compromised](https://www.penligent.ai/hackinglabs/litellm-on-pypi-was-compromised-what-the-attack-changed-and-what-defenders-should-do-now/)
4. [Hugging Face safetensors](https://github.com/huggingface/safetensors)
5. [ModelScan (Protect AI)](https://github.com/protectai/modelscan)
6. [Fickling (Trail of Bits)](https://github.com/trailofbits/fickling)
7. [ModelAudit (promptfoo)](https://github.com/promptfoo/modelaudit)
8. [AIsbom](https://aisbom.io/)
