# Gordian Envelope Use Cases

Gordian Envelopes can be used to store and transmit information in a structured, privacy preserving way. By what does that mean? Following are overviews of use cases that demonstrate the capabilities of Gordian Envelopes. Most of these use cases are ordered so that each step shows a progressively more complex (and less naive) situation. Many of these use cases show that progression through a single user story, though alternative user stories are also included, as needed.

## Educational Credential Use Cases

Gordian Envelopes can be used in the education sector to securely and privately transmit and store student records such as transcripts, test scores, and other sensitive information. This can help educational institutions maintain the privacy and security of student data, and ensure that only authorized parties can access the information they are authorized to view. The ability of a Gordian Envelope to elide specific information without invalidating the seal on the Envelope is particularly useful in the education industry (as well as other credential-issuing industries) because it allows different parties such as employers or regulators to access only the information they need for their specific purposes, while still preserving the privacy and security of the rest of the data.

The following privacy-preserving advantages are demonstrated in educational use cases:

* Any holder can elide content within a credential, without changing any signatures.
* Any holder can repackage a credential by adding additional information or even new credentials.
* Credential issuing is not limited to centralized authorities: peer-to-peer issuing is also possible, with metadata providing context.
* Credentials can be bundled to create herd privacy.
* Bundled credentials can be carefully organized to reduce correlation.

See the [Educational Credentials Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md) for illustrated examples of these advantages.

## Software & AI Industry Use Cases

Software and AI: Gordian Envelopes can be used in the software and AI industry to securely and privately transmit complex data structures, such as software source code, AI training sets, and model data. This helps to ensure that only authorized individuals have access to potentially sensitive information, and that the integrity of the code or models is maintained throughout the software development life-cycle. Gordian Envelopes can also improve the security of the software supply chain by securely transmitting software packages and updates between different parties. This can be particularly useful for the signing of software releases, with support for multiple signatures, dynamically changing signatures, and even anonymous signatures. Finally, Gordian Envelopes can support the reliability and availability of software infrastructure by securely transmitting configuration data and cryptographic keys.

The following signing & release advantages are demonstrated in software use cases:

* Envelope data can be precisely structured.
* Envelopes can be signed by multiple parties, and each signature can be individually verified.
* Envelopes can use metadata to chain back to previous envelopes, reducing validation costs.
* Envelopes can incorporate signer changes into their data chains, again reducing validation costs.

See the [Software Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Software.md) for illustrated examples of these advantages.

## Self-Sovereign Control of Assets

Gordian Envelopes were originally conceived to hold important data such as seeds or private keys in a way that improves their resilience. Thus, Gordian Envelopes have a number of resilience advantages. They are further supported by various privacy advantages:

* Envelope data can be partially or fully encrypted for security.
* Unencrypted metadata can be used to improve resilience with "hints".
* Metadata can be elided when data needs to be partially revealed.
* Envelope data can be salted to reduce correlation when that data is elided.
* Encrypted data can be locked with sharded keys to further improve resilience.
* Encrypted data can be locked via multiple methods to even` further improve resilience.

See the [Self-Sovereign Control of Assets Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Assets.md) for illustrated examples of these advantages.


## Private Data

Because of their focus on privacy, Gordian Envelopes can be used to store data that might be revealed to different people in different ways under different circumstances.

(Use Cases on this topic are in process.)
