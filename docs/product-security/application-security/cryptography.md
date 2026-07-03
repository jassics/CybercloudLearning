# Cryptography

## Why Application Developers Need to Understand Cryptography

Cryptography underpins confidentiality, integrity, and authenticity across nearly every application - TLS, password storage, tokens, digital signatures, and encrypted data at rest. Most real-world "crypto failures" are not broken algorithms; they are misuse: weak modes, hardcoded keys, missing verification, or rolling your own crypto instead of using a vetted library.

**Golden rule: never implement your own cryptographic primitives.** Use well-reviewed, widely-adopted libraries and follow their recommended (usually highest-level) APIs.

## Core Concepts

### Symmetric Encryption

One key encrypts and decrypts. Fast, used for bulk data encryption.

- **Recommended:** AES-256 in GCM mode (provides both confidentiality and integrity/authentication - an AEAD cipher).
- **Avoid:** AES in ECB mode (patterns leak through), DES/3DES (weak/deprecated), custom stream ciphers.

```python
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import os

key = AESGCM.generate_key(bit_length=256)
aesgcm = AESGCM(key)
nonce = os.urandom(12)  # Never reuse a nonce with the same key
ciphertext = aesgcm.encrypt(nonce, b"secret data", associated_data=None)
```

### Asymmetric (Public-Key) Encryption

A key pair - public key encrypts/verifies, private key decrypts/signs. Used for key exchange, digital signatures, and certificates.

- **Recommended:** RSA-3072+ or, preferably, elliptic curve (ECDSA/Ed25519, X25519 for key exchange) - smaller keys, faster, equally strong.
- Used in TLS handshakes, SSH, code signing, and JWT signing (RS256/ES256).

### Hashing

One-way function producing a fixed-size digest. Used for integrity checks, not for storing passwords.

- **Recommended:** SHA-256 or SHA-3 for general-purpose hashing/integrity.
- **Never** use MD5 or SHA-1 for security purposes (collision attacks are practical).

### Password Hashing (Different from General Hashing)

Passwords need slow, salted, memory-hard hashing to resist brute-force/GPU cracking - fast hashes like SHA-256 are the *wrong* tool here.

- **Recommended:** Argon2id - the hybrid variant of Argon2, the algorithm family that won the 2015 Password Hashing Competition, and now OWASP's default recommendation. Use bcrypt/scrypt if Argon2 isn't available in your stack.
- Always use a unique, random salt per password (most libraries handle this automatically).

```python
from argon2 import PasswordHasher

ph = PasswordHasher()
hash = ph.hash("user_password")
ph.verify(hash, "user_password")  # raises on mismatch
```

### Message Authentication Codes (MAC) & Digital Signatures

- **HMAC** (e.g., HMAC-SHA256) - verifies integrity and authenticity when both parties share a secret key.
- **Digital signatures** (RSA/ECDSA/Ed25519) - verifies integrity and authenticity when only the signer has the private key; anyone with the public key can verify.

## Key Management

Cryptography is only as strong as key management. Common failure modes:

| Failure | Risk | Mitigation |
|---------|------|-----------|
| Hardcoded keys in source | Key exposure via repo/leak | Use a secrets/KMS (AWS KMS, GCP KMS, HashiCorp Vault) |
| No key rotation | Long-lived compromise window | Rotate keys periodically and on suspected compromise |
| Same key across environments | Dev leak compromises prod | Separate keys per environment |
| No access control on keys | Any compromised service can decrypt everything | Apply least-privilege IAM policies to key usage |
| Keys never revoked | Compromised keys stay valid | Maintain revocation/rotation runbooks |

## Transport Layer Security (TLS)

- Enforce **TLS 1.2 minimum**, prefer **TLS 1.3**.
- Disable weak cipher suites (RC4, export ciphers, NULL ciphers).
- Use certificates from a trusted CA; validate certificate chains and hostnames - never disable certificate verification in production code.
- Enable HSTS (`Strict-Transport-Security`) to prevent downgrade attacks.

```python
# Insecure - never do this in production
requests.get(url, verify=False)

# Secure
requests.get(url, verify=True)
```

## Common Cryptographic Mistakes

1. **Rolling your own crypto** - even small deviations from a spec create exploitable weaknesses.
2. **Reusing nonces/IVs** with the same key in AEAD/stream ciphers - can fully break confidentiality.
3. **Using ECB mode** - identical plaintext blocks produce identical ciphertext blocks (visible patterns).
4. **Weak randomness** - using `random` instead of a cryptographically secure RNG (`secrets` module in Python, `crypto/rand` in Go).
5. **Storing passwords with fast hashes** (MD5, SHA-256 alone) instead of Argon2/bcrypt.
6. **Not verifying signatures** - e.g., accepting a JWT without checking its signature, or accepting `alg: none`.
7. **Mixing up encoding and encryption** - Base64 is not encryption; it provides no confidentiality.

## Post-Quantum Considerations

Quantum computers, once sufficiently mature, threaten RSA and ECC (via Shor's algorithm). NIST has standardized post-quantum algorithms (e.g., ML-KEM/CRYSTALS-Kyber for key exchange, ML-DSA/CRYSTALS-Dilithium for signatures) under FIPS 203/204/205. Organizations with long data-confidentiality requirements should begin crypto-agility planning now - abstracting cryptographic primitives so they can be swapped without a full rewrite.

## Credits/References

1. [OWASP Cryptographic Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html)
2. [NIST Cryptographic Standards and Guidelines](https://csrc.nist.gov/projects/cryptographic-standards-and-guidelines)
3. [NIST Post-Quantum Cryptography Project](https://csrc.nist.gov/projects/post-quantum-cryptography)
4. [Python `cryptography` library documentation](https://cryptography.io/)
