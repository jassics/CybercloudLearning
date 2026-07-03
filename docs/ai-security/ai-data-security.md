# AI Data Security

## Overview

Data is the foundation of AI systems. Protecting training data, inference data, and model outputs is critical for maintaining security and privacy.

## Data Security Challenges in AI

| Challenge | Description |
|-----------|-------------|
| **Data Volume** | ML requires massive datasets, increasing attack surface |
| **Data Sensitivity** | Training data often contains PII or proprietary information |
| **Data Lineage** | Tracking data sources and transformations is complex |
| **Data Persistence** | Models retain information from training data |

## Securing the Data Lifecycle

### 1. Data Collection

- **Minimize collection** - Only collect data necessary for the task
- **Consent management** - Ensure proper consent for data usage
- **Source verification** - Validate data sources to prevent poisoning

### 2. Data Storage

- **Encryption at rest** - AES-256 for stored datasets
- **Access controls** - Role-based access to training data
- **Data isolation** - Separate environments for different sensitivity levels

### 3. Data Processing

- **Secure pipelines** - Encrypt data in transit during processing
- **Audit logging** - Track all data transformations
- **Data validation** - Check for anomalies and poisoning attempts

### 4. Data Retention & Disposal

- **Retention policies** - Define how long to keep training data
- **Secure deletion** - Cryptographic erasure when possible
- **Model unlearning** - Remove specific data influence from models

## Privacy-Preserving Techniques

### Differential Privacy

Add mathematical noise to protect individual records. A concrete example: you want to publish the average salary in a department without letting anyone reverse-engineer any one employee's salary by comparing query results before/after they joined.

```python
import numpy as np

def private_mean(values: np.ndarray, epsilon: float = 1.0) -> float:
    """Return a differentially private mean using the Laplace mechanism.

    epsilon controls the privacy/accuracy trade-off: lower epsilon = more
    noise = stronger privacy but a less accurate answer. Sensitivity here
    is the max amount one person's salary can change the mean, bounded by
    (max_salary - min_salary) / n.
    """
    true_mean = values.mean()
    sensitivity = (values.max() - values.min()) / len(values)
    noise = np.random.laplace(loc=0, scale=sensitivity / epsilon)
    return true_mean + noise

salaries = np.array([72000, 85000, 91000, 68000, 130000])
print(private_mean(salaries, epsilon=1.0))
# Real mean is 89200 - the noisy output will be close but not identical
# every time you run it, and specifically won't reveal whether removing
# any single salary from the dataset changed the answer meaningfully.
```

Running this twice gives two different (but close) numbers - that's the point. An attacker who queries "average salary" before and after one employee joins can no longer confidently back out that employee's exact salary from the difference.

### Federated Learning

Train models without centralizing data:

- Data stays on user devices
- Only model updates are shared
- Aggregated updates protect individual contributions

### Homomorphic Encryption

Perform computations on encrypted data:

- Data remains encrypted during inference
- Results are decrypted only by data owner
- Significant computational overhead

## Data Poisoning Prevention

!!! danger "Data Poisoning Attacks"
    Attackers inject malicious samples to manipulate model behavior.

**Detection Methods:**

- Statistical outlier detection
- Clustering analysis on training data
- Cross-validation with held-out data

**Prevention:**

- Data provenance tracking
- Multi-source data validation
- Anomaly detection in data pipelines

## Compliance Considerations

| Regulation | Data Requirements |
|------------|-------------------|
| **GDPR** | Right to erasure, data minimization |
| **CCPA** | Consumer data access and deletion rights |
| **HIPAA** | PHI protection in healthcare AI |
| **SOC 2** | Data security controls and monitoring |

## Best Practices

1. **Inventory all training data** - Know what data you have and where
2. **Implement data classification** - Label sensitivity levels
3. **Use synthetic data** - When possible, train on synthetic datasets
4. **Regular data audits** - Review data access and usage patterns
5. **Document data lineage** - Track data from source to model

## Credits/References

1. [NIST SP 800-188: De-Identification of Personal Information](https://csrc.nist.gov/pubs/sp/800/188/final)
2. [OWASP Top 10 for Large Language Model Applications](https://owasp.org/www-project-top-10-for-large-language-model-applications/) (LLM03: Training Data Poisoning)
3. Dwork & Roth, [The Algorithmic Foundations of Differential Privacy](https://www.cis.upenn.edu/~aaroth/Papers/privacybook.pdf)
4. [NIST AI Risk Management Framework (AI RMF 1.0)](https://www.nist.gov/itl/ai-risk-management-framework)
