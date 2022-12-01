# Gordian Envelope Use Cases

Gordian Envelopes can be used to store and transmit information in a structured, privacy preserving way. By what does that mean? Following are overviews of use cases that demonstrate the capabilities of Gordian Envelopes. Most of these use cases are ordered so that each step shows a progressively more complex (and less naive) situation. Many of these use cases show that progression through a single user story, though alternative user stories are also included, as needed.

## Educational Credentials

The advent of decentralized identifiers has created a foundation for verifiable credentials: digital attestations of skills, memberships, attendances, or other facts. Gordian Envelopes offer a new way to issue and sign credentials, but with several privacy preserving advantages, including:

* Any holder can elide content within a credential, without changing any signatures.
* Any holder can repackage a credential adding additional information or even new credentials.
* Credential issuing is not limited to centralized authorities: peer-to-peer issuing is also possible, with metadata providing context.
* Credentials can be bundled to create herd privacy.
* Bundled credentials can be carefully organized to reduce correlation.

See the [Educational Credentials Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md) for illustrated examples of these advantages.

## Self-Sovereign Control of Assets

Gordian Envelopes were originally conceived to hold important data such as seeds or private keys in a way that improves their resilience. Thus, Gordian Envelopes have a number of resilience advantages. They are further supported by various privacy advantages:

* Envelope data can be partially or fully encrypted for security.
* Unencrypted metadata can be used to improve resilience with "hints".
* Metadata can be elided when data needs to be partially revealed.
* Envelope data can be salted to reduce correlation when that data is elided.
* Encrypted data can be locked with sharded keys to further improve resilience.
* Encrypted data can be locked via multiple methods to even` further improve resilience.

See the [Self-Sovereign Control of Assets Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Assets.md) for illustrated examples of these advantages.

## Software Signing

Gordian Envelopes support signing of data and those signatures remain valid even when data is partially elided for privacy purposes. The combination of that and an Envelope's implicit structure can create powerful tools for use cases such as code signing. Advantages of using Gordian Envelope in code signing scenarios include:

* Envelope data can be precisely structured.
* Envelopes can be signed by multiple parties, and each signature can be individually verified.
* Envelopes can use metadata to chain back to previous envelopes, reducing validation costs.
* Envelopes can incorporate signer changes into their data chains, again reducing validation costs.

See the [Software Signing Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Software.md) for illustrated examples of these advantages.

## Private Data

Because of their focus on privacy, Gordian Envelopes can be used to store data that might be revealed to different people in different ways under different circumstances.

(Use Cases on this topic are in process.)
