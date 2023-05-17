# Collaborative Seed Recovery (CSR) Overview

Collaborative Seed Recovery, or CSR, is a new system intended to automate the recovery of seeds and other sensitive digital data in a way that is safe, secure, and simple to use. It is not a methodology to prevent compromise, but simply to add resilience to recovery in the case of failure or loss.

This document outlines the core structures and principles of a first iteration of CSR that we believe could be developed by the end of 2023.

* **CSR Project:** [https://github.com/BlockchainCommons/Community/issues/149](https://github.com/BlockchainCommons/Community/issues/149)
* **CSR Use Cases:** [https://hackmd.io/ZbRiwvUfQSy-1RKM15bM8Q](https://hackmd.io/ZbRiwvUfQSy-1RKM15bM8Q#CSR-Focused-Use-Cases)
* **CSR Sequence Diagram:** [SequenceDiagram.md](SequenceDiagram.md)

## Overview

CSR allows for the recovery of seeds and other secrets by dividing responsibility for recovery up between multiple devices, some (but not all) of which will be necessary for recovery. Its baseline recovery mechanism uses self-sovereign recovery, while more advanced scenarios allow for social key recovery. Backup is meant to be largely automated, especially in the baseline scenario, while recovery may require some user intervention.

One of the advantages of CSR over traditional social key recovery is that you don't have to choose friends or family that you trust. Though you _can_ do so, you can also entrust fragments of keys to companies running special share servers. You don't have to worry about them stealing keys, because you're only giving them fragments, but you can trust that they'll likely still be around when you need to reconstruct your key.

CSR is built using _SSKR_ to lock _crypto-envelopes_ of data and to allow recovery using a variety of _authentication_ methods.

## Key Principles

The key principles of CSR are:

1. To allow for the resilient and secure recovery of data.
1. To place rational limits on what can be stored.
1. To allow recovery from a variety of sources.
1. To support a variety of methods for recovery.
   * This could include self-sovereign recovery (online or offline).
   * This could include social key recovery (friends/family/colleagues or trusted services).
   * This could include variations in-between.
1. To support a variety of methods for authenticating recovery.
   * Authentication should be appropriate and diverse.
   * Authentication should leverage existing authentication methods and processes.
   * Authentication can include physical possession.
   * Authentication can include other non-digital processes.
1. To make the security of the recovery a core goal.
1. To do all of this in a simple way that hides complex details from the user.
1. To do all of this in a standardardized way that allows for shared infrastructure.

## What CSR v1.0 Will Do

### CSR Secret Storage

CSR will:

* Support a default self-sovereign scenario where the user is set up with robust, self-sovereign storage of their seed (and other secrets) using 2-of-3 SSKR.
* Automate this baseline storage case without user intervention.

### CSR Secret Updates

CSR will:

* Allow a user to personally choose key-recovery services for storing their shares in more advanced storage cases.
* Allow a user to increase the size of their SSKR, to 3-of-5 or 4-of-9 or 2-of-3 of 2-of-3.
   * This will be done in a progressive way that does not require revisiting current key-recovery services.
* Properly rotate secrets when an older, smaller set of SSKR shares is deprecated.
* Automatically rotate secrets and rebuild shares if a key-recovery service is compromised or disappears.

### CSR Secret Recovery

CSR will:

* Automate recovery in the baseline storage cases, with information of additional shares stored with the foundational share.
* Ensure the security of seeds (and other secrets) as they are recovered.
* Require authentication for the recovery of shares.
* Support a variety of authentication options.
   * Federated Login
   * In-Person Verification
   * Password
   * Phone Call
   * Physical Possession
   * Biometric
* Enable progressive revelation of recovery location.
   * In baseline scenario, first recovery location reveals all other recovery locations.
   * In more advanced scenarios, each recovery location may breadcrumb to next recovery location.
* Progressively improve security for more complex scenarios by requiring a variety of authentications to restore various shares.

### What the Key Choice Points Are

CSR is designed such that a user has to make _no_ decisions in the baseline case. Instead, the process is fully automated. All the necessary information is stored on your platform cloud to contact and authenticate the return of additional shares.

Choice points then occur when a user decides to expand or modify their usage of the CSR system, either on their own or at the prompting of the system. These choice points include:

* User adds offline or social-recovery to their system.
* User chooses third parties who holds shares.
* User updates secrets.
* Users rotates up amount of shares, from 2-of-3 to 3-of-5 or 4-of-9 or 2-of-3 of 2-of-3.
* User revokes shares.

## CSR Technical Underpinnings

CSR is built on the following technical underpinnings:

**Crypto-Envelope.** Holder of secure data. A crypto-envelope consists of two parts: the payload data, which typically consists of one or more encrypted objects (originally focused on seeds, but possibly also containing web tokens and/or other secret digital data); and the permit, which decrypts the payload data if the proper key or other data is applied and which may include hints about how to enable the decryption.

**URs.** Uniform Resources. A standardized methodology for storing information that is self-identifying and self-certifying. Data held in Crypto-Envelopes is encoded as URs to ensure ability to restore. See [BCR-2020-05](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-005-ur.md). URs are in turn encoded as CBOR. See [CBOR Overview](https://cbor.io/).

**ChaChaPoly.** The ChaCha20-Poly1305 cipher. An encryption methodology, and the standard suggested for the first generation of crypto-envelope encryption. See [RFC 8439](https://datatracker.ietf.org/doc/html/rfc8439).

**Arbitrary Envelope Permits.** General methodology for opening envelopes based on a simple scripting language. However, the first iteration of CSR will recognize just a single sort of permit: the SSKR Permit. Future versions will recognize other specific permits, beginning with a public-key cryptography envelope. The ultimate long-term goal is to recognize arbitrary scripts to open envelopes.

**SSKR.** A secret-sharing scheme that currently focuses on Shamir's Secret Sharing but is expected to expand to also support VSS when it's sufficiently mature. It will be used by CSR to shard secrets for unlocking crypto-envelopes. See [UR definition for SSKR](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-011-sskr.md) and [SSKR Docs](https://github.com/BlockchainCommons/crypto-commons/blob/master/Docs/README.md#sharded-secret-key-reconstruction-sskr). The baseline scenario uses 2-of-3 SSKR, but more advanced scenarios will support 3-of-5, 4-of-9, and two-layer 2-of-3 of 2-of-3. The architecture will be designed to allow progressive expansion of sharding scenarios.

**SSKR Permits.** A crypto-envelope permit that allows for the opening of an envelope by combining the SSKR shares found in multiple envelopes, each of which contains the encrypted data and one of the SSKR shares. The SSKR shares are used to reconstruct a symmetric secret that was used to lock the crypto-envelope.

### CSR Technical Process

The overall technical process looks like this:

1. Seed (or other secret data) is revealed from where it's stored.
2. Metadata is collected including recovery metadata (such as Bitcoin descriptors or Lightning payment channels) or other metadata (such as seed creation data).
3. A payload is created by encrypting the secret data and metadata using ChaChaPoly with a unique, random, symmetric key.
4. The symmetric key is sharded using SSKR.
5. Three crypto-envelopes are constructed, each containing the encrypted payload plus one share of the symemtric key.
6. A second payload is added to the first crypto-envelope, containing hints about where the other two envelopes will be stored. This is not encrypted, but will be protected by the authentication implicit in the first envelope's storage.
7. A second unique, random symmetric key is created and sharded into five 3-of-5 shares. The original payload data is reencrypted with the second key. Both a unique 3-of-5 share and the second encrypted copy of the payload are also placed in the three envelopes.
8. First envelope is placed in Platform Cloud.
9. Second and third envelope are placed at locales specified by the first envelope.
10. Two more envelopes are created using the fourth and fifth copies of the 3-of-5 share and the second copy of the payload. They will be distributed if the user decides to upgrade from 2-of-3 to 3-of-5 sharding.

Afterward, the envelopes look as follows:

* **Envelope #1** (Platform Cloud)
   * PERMIT: Share #1 (Key #1: 2 of 3)
   * PERMIT: Share #1 (KEY #2: 3 of 5)
   * ENCRYPTED PAYLOAD (with KEY #1)
   * ENCRYPTED PAYLOAD (with KEY #2)
   * UNCRYPTED PAYLOAD (locale hints)
* **Envelope #2** (Service)
   * PERMIT: Share #2 (Key #1: 2 of 3)
   * PERMIT: Share #2 (KEY #2: 3 of 5)
   * ENCRYPTED PAYLOAD (with KEY #1)
   * ENCRYPTED PAYLOAD (with KEY #2)
* **Envelope #3** (Service)
   * PERMIT: Share #3 (Key #1: 2 of 3)
   * PERMIT: Share #3 (KEY #2: 3 of 5)
   * ENCRYPTED PAYLOAD (with KEY #1)
   * ENCRYPTED PAYLOAD (with KEY #2)
* **Envelope #4** (Unused)
   * PERMIT: Share #4 (KEY #2: 3 of 5)
   * ENCRYPTED PAYLOAD (with KEY #2)
* **Envelope #5** (Unused)
   * PERMIT: Share #5 (KEY #2: 3 of 5)
   * ENCRYPTED PAYLOAD (with KEY #2)

Assuming the destruction or loss (but not compromise) of the device holding the main seed, the user can then recover as follows:

1. User restores access to Platform Cloud on a new device.
1. CSR authenticates with Platform Cloud.
2. CSR retrieves first envelope from Platform Cloud.
3. CSR examines unencrypted payload to see where other envelopes are.
4. CSR authenticates with second server and retrieves second envelope.
5. If there is a problem, CSR authenticates with third server and retrieves third envelope.
6. CSR combines SSKR shares from two envelopes.
7. CSR unlocks symmetric key.
8. CSR uses symmetric key to unlock first payload in either envelope (they should be identical).

## CSR Development Path

Please see the [CSR Issue](https://github.com/BlockchainCommons/Community/issues/149) for development of the project.

## What CSR v1.0 Will Not Do

CSR v1.0 is just the first iteration of the CSR system, let alone the larger, more complex Collective Key Management (CKM) system. It needs to be carefully constrained to ensure the ability to release in 2023.

It does *not*:
* Support collaborative key generation.
* Support collaborative key usage.
* Protect your key before it's split.
* Protect your key once it's recovered.
* Support the usage of multisigs.
* Support Envelope Permits other than SSKR.
* Support Envelope Encryption other than ChaChaPoly.
* Cryptographically verify existence of shares.

## Appendix I: Defining CSR

The name "Collaborative Seed Recovery" was carefully selected for this project:

* **Collaborative**
   * We have not used the language of "social" seed recovery because the recovery could be entirely self-sovereign or the parties supporting the recovery might be entities outside of the holder's social network, including businesses.
   * The collaboration remains trustless because no individual can be a Single Point of Failure (SPOF) or Single Point of Compromise (SPOC). They are nonetheless parties that a key holder has confidence in.
* **Seed**
   * The CSR architecture is designed & focuses on the recovery of secrets, in particular SEEDS, not KEYS (though keys may also be recovered along with metadata).
   * This is to support a larger ecosystem, to include scenarios beyond cryptocurrencies such as Bitcoin and Ethereum seeds. It also provides resilience in the recovery of seeds for any app that uses persistent keys, such as U2F or Signal, and is future proofed to support recovery of seeds that can generate future curves or Zero-knowledge proofs, such as Chia's unique keys, BBS+ keys, and much more.
* **Recovery**
   * The goal is the resilience and recovery of a seed that the holder has lost, along with metadata, which then allows them to restore wallet functionality. It is NOT intended as a mechanism for the recovery of a seed or key that is compromised. Instead, the architecture is designed as the foundation of future Collaborative Key Management (~2023) multi-party cryptography techniques and features, which also allow for no single points of compromise.

## Appendix II: Defining SSKR

An [incomplete paper](https://docs.google.com/document/d/1rZJlFZcftrCM_KaxFnHUIskJKlSQzF0zFn4WIRQGDLU/edit#) from RWOT9 suggested the following terminology to standardaize the discussion of reconstruction techniques. As that paper says: "It is not necessarily complete, and it does not necessarily reflect the overall understanding of the cryptographic community, though best efforts have been applied to both issues."

One change has been made to the definitions from that paper: whereas it uses "share" and "shard" to differentiate shares based on their contents, the following applies the more standard usage of "shard" being _only_ a verb, describing how a "secret" is divided into "shares"

**Deck.** A collection of shares that can be combined together to reconstruct a sharded secret.

**Deck identifier.** The public key derived from the sharded secret, unmodified, with no derivation and no other modification. It uniquely identifies a deck. This key can sign each share.

**Derived Secret.** The private key derived from a sharded secret. It is used to decrypt the private data associated with each share.

**Private Data.** Encrypted data transferred with each share. The decryption key, or derived secret, can be computed by recombining all the shares, producing the sharded secret. Alternatively: encrypted blob or deck blob.

**Quorum.** Any set of shares sufficient to meet the script policy for reconstruction.

**Recovery.** The method by which one or more keys in a multisig are used to sweep forward funds after the loss of one or more keys in that multisig. Not to be confused with reconstruction.

**Reconstruction.** The method by which a sharded secret is restored from a threshold of shares created by a technique such as Shamir’s Secret Sharing. Not to be confused with recovery.

**Script Policy.** A script that specifies a policy for how a deck's sharded secret can be reconstructed from some combination of shares.

**Share Custodian.** A user that holds a number of shares, possibly from multiple decks.

**Share Dealer.** An individual that has a secret that is sharded using a secret sharing scheme. The user creates a number of shares that are dealt out to different users, turning each user into a share custodian.

**Share Pool.** A collection of shares that a share custodian is responsible for, usually implemented by a software application. The share pool allows for querying over the set of shares to find particular shares in response to a request.

**Share Value.** A mathematical or cryptographic value that can be used in a secret sharing scheme to reconstruct a shared secret. Alternatively: y value.

**Sharded secret.** A high entropy secret that is turned into shares by a share dealer. It can also be used to create a derived secret, in which case it is used as both a symmetric key and a private key.

**Share.** A split of a secret, created with Shamir’s Secret Sharing. May also have unencrypted metadata associated with it.

**Threshold.** The number of shares required to reconstruct a sharded secret.

**Unencrypted Metadata.**  Data associated with a shares that describes the share and the deck, among other things. This data can include birthdate, deck identifier information, and so on. Alternatively: public metadata.

## Appendix III: Detailing Crypto-Envelope

Blockchain Commons has designed a next-generation container structure called Crypto-Envelope. It is part of the [Secure Components](https://github.com/BlockchainCommons/BCSwiftSecureComponents) library, with a draft reference implementation in Swift. The [Documentation](https://github.com/BlockchainCommons/Gordian/tree/master/Envelope#articles) directory is a good place to start understanding what this library is capable of — particularly Crypto-Envelope.

Although Crypto-Envelope has many potential uses, a primary application of it relevant to CSR is the ability to shard payloads much larger than SSKR can handle. To assist implementors on other platforms, Blockchain Commons has published [test vectors](https://github.com/BlockchainCommons/BCSwiftSecureComponents/blob/master/Docs/14-C-ENVELOPE-SSKR-TEST-VECTORS.md) that show several different views of SSKR splits created using Crypto-Envelope.

**NOTE**: The Secure Components library, including Crypto-Envelope, is still in DRAFT stage and subject to change. Implementors should not release any products based on our reference implementation in Swift or based on their own implementations yet. Please contribute to our efforts to move these specifications toward an actual public release.
