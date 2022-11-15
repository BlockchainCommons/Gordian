# An Introduction to Gordian Envelopes

Gordian Envelope is a specification for the achitecture of a “smart document". It supports the storage, backup, encryption, authentication, and transmission of data, with natively supported cryptography and explicit support for Merkle-based selective disclosure. It's designed to protect digital assets including seeds, keys, Decentralized Identifiers (DIDs), Verifiable Credentials (VCs), and Verifiable Presentations (VPs).

Blockchain Commons is currently working with multiple companies on the development and deployment of Gordian Envelopes via regular biweekly meetings; [contact us](mailto:team@blockchaincommons.com) if you'd like to be involved. We are also presenting Envelopes as a prospective Informational Draft for the IETF and engaging in discussions with the W3C Credentials Community Group.

## The Envelope as Metaphor

The name "envelope" was chosen for this smart-document architecture because that provides an excellent metaphor for its capabilities.

![](https://raw.githubusercontent.com/BlockchainCommons/Gordian/master/Images/Envelope-Examples.jpg)

These capabilities include:

* **Envelopes can have things written on them.** Plaintext parts of a Gordian Envelope can be read by anyone.
* **Envelopes can have routing instructions.** That plaintext information can include data on how to use the Gordian Envelope, such as how to open or close it.
* **Envelopes can contain things.** Things can be placed within the structure of a Gordian Envelope.
* **Envelopes can contain envelopes.** The Gordian Envelope structure is fully recursive: any part of an envelope can actually be another envelope.
* **Envelopes can have a seal.** A signature can be made for the contents of a Gordian Envelope, verifying their authenticity and that they haven't been changed.
* **Envelopes can be certified.** Beyond just guarding against changes, a Gordian Envelope signature can also act as a certification of the envelope's contents by some authority.
* **Envelopes can be closed.** Encryption allows any part of a Gordian Envelope to be protected from prying eyes.
* **Envelopes can have windows.** Selective disclosure allows for some parts of a Gordian Envelope to be readable while others have been redacted. Merkle proofs can proof that those parts were present in the original envelope.
* **Different recipients can open envelopes in different ways.** Just as people might use letter openers, their fingers, or a machine to open a normal envelope, special permits can grant people different ways to open a Gordian Envelope.

## Why Envelopes Are Important

The Gordian Envelope is intended as a more privacy-focused encoding architecture than existing data formats such as JWT and JSON-LD. We believe it has a better security architecture than JWT and that it doesn't fall victim to the barriers of canonicalization complexity found in JSON-LD — which should together permit better security reviews of the Gordian Envelope design.

However, new features of Gordian Envelope not available in JWT or JSON-LD offer some of the best arguments for using the Smart Document structure.

![](https://raw.githubusercontent.com/BlockchainCommons/Gordian/master/Images/Envelope-Examples-DO.jpg)

***Fundamental Structure:*** 

* **Sematic Triples.** Gordian Envelopes are built on powerful semantic triples, sometimes known as semantic graphs. (Semantic graphs are a feature of JSON-LD.)
* **Known Values.** A set of "known values" for regularly used predicates can reduce the size of content within a Gordian Envelope.
* **Structured Merkle Tree.** All parts of a Gordian Envelope can be hashed, creating a tree of digests that forms a structured Merkle Tree. (In this variant of Merkle Trees, all nodes contain both semantic content _and_ digests, rather than semantic content being limited to leaves.)
* **Bottom-Up Support.** Support for elision, privacy, and authentication is a fundamental element of Gordian Envelope, not an add-on.

***Elision Support:***

* **Elision of All Elements.** Gordian Envelopes innately support elision for all the elements of their triples: subjects, predicates, and objects.
* **Redaction, Compression, and Encryption.** Elision can be used for a variety of purposes including redaction (removing information), compression (removing duplicate information), and encryption (enciphering information).
* **Holder-initiated Redaction.** Elision can be performed by the Holder of a Gordian Envelope, not just the Issuer (which is a large advance over most redaction designs to date).
* **Granular Holder Control.** Elision can not only be performed by any Holder, but also for any data, allowing each entity to elide data as is appropriate for themselves or the rules of their business.
* **Progressive Trust.** The elision mechanics in Gordian Envelopes allow for progressive trust, where increasing amounts of data are revealed over time. It can even be combined with encryption to escrow data to later be revealed.
* **Consistent Hashing.** Even when elided or encrypted, hashes for those parts of the Gordian Envelope remain the same.

***Privacy Support:***

* **Proof of Inclusion.** As an alternative to presenting redactive structures, proofs of inclusion can be included in top-level hashes.
* **Herd Privacy.** Proofs of inclusion allow for herd privacy where all members of a class can share data such as a VC or DID without revealing individual information.
* **Non-Correlation.** Encrypted Gordian Envelope data can optionally be made less correlatable with the addition of salt.

***Authentication Support:***

* **Symmetric Key Permits.** Gordian Envelopes can be locked ("closed") using a symmetric key.
* **SSKR Permits.** Gordian Envelopes can alternatively be locked ("closed") using a symmetric key sharded with Shamir's Secret Sharing, with the shares stored with copies of the Envelope, and the whole enveloped thus openable if sufficient  copies of the Envelope with a quorum of different shares are gathered.
* **Public Key Permits.** Gordian Envelopes can alternatively be locked ("closed") with a public key and then be opened with the associated private key, or vice versa.
* **Multiple Permits.** Gordian Envelopes can simultaneously be locked ("closed") via a variety of means and then openable by any appropriate individual method, with different methods likely held by different people.
 
 ***Future Looking:***

* **Data Storage.** The initial inspiration for Gordian Envelopes was for secure data storage.
* **Credentials & Presentations** The usage of Gordian Envelope signing techniques allows for the creation of credentials and the ability to present them to different verifiers in different ways.
* **Distributed or Decentralized Identifiers.** Self-Certifying Identifiers (SCIDs) can be created and shared with peers, certified with a trust authority, or registered on blockchain.
* **Future Techniques.** Beyonds its technical specifics, Gordian Envelopes still allows for cl-sigs, bbs+, and other privacy-preserving techniques such as zk-proofs, differential privacy, etc.
* **Cryptography Agnostic.** Generally, the Gordian Envelope architecture is cryptography agnostic, allowing it to work with everything from older algorithms with silicon support through more modern algorithms suited to blockchains and to future zk-proof or quantum-attack resistent cryptographic choices. These choices are made in sets via ciphersuites.

## Usage of Envelopes

Gordian Envelopes are a foundational architecture that we expect to support many advanced projects involving self-sovereign control of digital assets.

Currently, it's being used in two major Blockchain Commons projects.

* **Crypto-request/response.** Requests and responses are specified ways to ask for and send information needed for self-sovereign operations, including when transmitting across an Airgap. Our second generation of requests and responses encodes those communications in Gordian Envelopes.
* **Collaborative Seed Recovery.** The [CSR system](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/CSR.md) requires the use of Smart Documents to store shares of seeds that have been sharded for backup and recovery. The Gordian Envelope is thus the heart of that system.

There are a broad swath of additional use cases, some of which can be found in our [Use Case Overview of Envelopes] (PENDING). These include:

* **Self-Sovereign Control of Assets.** There are many different use cases for helping users to resiliently control their digital assets, going beyond the specific design of CSR. These include the inclusion of metadata for resilience, the usage of salts to block correlation, and the creation of variable-use permits to allow multiple ways to open an envelope.
* **Educational Credential.** All sorts of credentials can be created in Gordian Envelopes, but certifications and other educational credentials are likely to be some of the most popular. These can be credentials signed by accredited institutions or by Web of Trust peers. Elision and third-party manipulation can allow these credentials to be safely passed around for a variety of purposes. Herd privacy features can create even greater anonymity.
* **Source-Control Signing.** The standardization of Gordian Envelopes is another of their strengths. Case studies involving source-control signing demonstrate how a field that is currently managed in a variety of different ways could allow for real improvements in security.

## Envelope Links

* [Doc: A Technical Overview of Envelopes](Envelope-Tech-Intro.md)
* Doc: A Use Case Overview of Envelopes (PENDING)
* [Video: Introduction to Envelopes](https://www.youtube.com/watch?v=tQ9SPek0mnI)
* [Video: Envelope MVA & Cipher Choices](https://www.youtube.com/watch?v=S0deyIHXukk)
* [Reference App: Envelope-CLI](https://github.com/BlockchainCommons/envelope-cli-swift)
* [Docs: Envelope-CLI Docs](https://github.com/BlockchainCommons/envelope-cli-swift/tree/master/Docs)
* [Video: Envelope-CLI Commands Overview](https://www.youtube.com/watch?v=K2gFTyjbiYk)
* [Videos: Envelope-CLI Complete Playlist](https://www.youtube.com/playlist?list=PLCkrqxOY1FbooYwJ7ZhpJ_QQk8Az1aCnG)
