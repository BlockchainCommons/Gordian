# Gordian Envelope Use Cases

Gordian Envelopes can be used to store and transmit information in a structured, privacy preserving way. By what does that mean? Following are overviews of use cases that demonstrate the capabilities of Gordian Envelopes. Most of these use cases are ordered so that each step shows a progressively more complex (and less naive) situation. Many of these use cases show that progression through a single user story, though alternative user stories are also included, as needed.

## Educational & Credential Industry Use Cases

Gordian Envelopes can be used in the education sector to securely and privately transmit and store student records such as transcripts, test scores, and other sensitive information. This can help educational institutions to maintain the privacy and security of student data and to ensure that third parties can only access the information they are authorized to view. The ability of a Gordian Envelope to elide specific information without invalidating the seal on the Envelope is particularly useful in the education industry (as well as other credential-issuing industries) because it allows different parties such as employers or regulators to access only the information they need for their specific purposes, while still preserving the privacy and security of the rest of the data.

The following privacy-preserving advantages are demonstrated in educational use cases:

* Any holder can elide content within a credential, without changing any signatures.
* Any holder can repackage a credential by adding additional information or even new credentials.
* Credential issuing is not limited to centralized authorities: peer-to-peer issuing is also possible, with metadata providing context.
* Credentials can be bundled to create herd privacy.
* Bundled credentials can be carefully organized to reduce correlation.
* Entities can use selective correlation of bundled credential to verify known information without acquiring new, toxic data.

See the [Educational & Credential Industry Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md) for illustrated examples of these advantages.

## Data Distribution Use Cases

Because of their focus on privacy, Gordian Envelopes can be used to store data that requires security and might be revealed to different people in different ways under different circumstances. The data distribution use cases focus on how a simple user-data program such as `finger` could benefit from this new paradigm.

The following data distribution advantages are demonstrated in use cases:

* Envelope data can be structured.
* Envelope data can be made verifiable through signatures.
* Envelope data can include additional metadata, such as timestamps, which itself can be verified.
* Elision can allow envelopes to be released in different ways to different viewers.
* Selective correlation can enable data lookup without widespread release.
* Selective correlation can automate progressive releases of data.

See the [Data Distribution Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Data.md) for illustrated examples of these advantages.

## Software & AI Industry Use Cases

Gordian Envelopes can be used in the software and AI industry to securely and privately transmit complex data structures such as software source code, AI training sets, and model data. This helps to ensure the integrity of the code or models is maintained throughout the software development life-cycle. Gordian Envelopes can also improve the security of the software supply chain by securely transmitting software packages and updates between different parties. This can be particularly useful for the signing of software releases, with Gordian Envelopes supporting multiple signatures, dynamically changing signatures, and even anonymous signatures. Finally, Gordian Envelopes can support the reliability and availability of software infrastructure by securely transmitting configuration data and cryptographic keys.

The following signing & release advantages are demonstrated in software use cases:

* Envelope data can be precisely structured.
* Envelopes can be signed by multiple parties, and each signature can be individually verified.
* Envelopes can be further signed by third parties, allowing for a variety of validation.
* Envelopes can use metadata to chain back to previous envelopes, reducing validation costs.
* Envelopes can include attestations or other types of verifiable metadata.
* Envelopes can incorporate signer changes into their data chains, again reducing validation costs.
* Envelopes can be signed anonymously, depending on a Web of Trust for validation.
* Anonymous signers can later provably come forward, if thoughtful Envelope design was used from the start.

See the [Software Industry Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Software.md) for illustrated examples of these advantages.

## Financial Industry Use Cases

Gordian Envelopes can be used to securely and privately transmit and store financial records, such as bank statements and transaction records, as well as digital assets, such as seeds and private keys. This can help financial institutions to maintain the privacy and security of their customers' data and ensure that only authorized parties can access the information they need, and it can help individuals to protect their assets. Gordian Envelopes can also be used to securely transmit financial data between institutions, helping to prevent tampering and to ensure the trustworthiness of the data. The ability to use permits to allow multiple useres to open Envelopes in multiple ways can allow for collaboration of corporate data and resilience for personal data alike. 

The following privacy advantages are demonstrated in financial use cases, which are focused on the self-sovereign control of assets:

* Envelope data can be partially or fully encrypted for security.
* Unencrypted metadata can be used to improve resilience with "hints".
* Metadata can be elided when data needs to be partially revealed.
* Envelope data can be salted to reduce correlation when that data is elided.
* Encrypted data can be locked with sharded keys to further improve resilience.
* Encrypted data can be locked via multiple methods to even` further improve resilience.

See the [Financial Industry Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Assets.md) for illustrated examples of these advantages.

## Other Data Distribution Use Cases

A number of additional industries can benefit from the data-distribution possibilities of Gordian Envelopes.

**Agriculture Industry Use Cases.** Gordian Envelopes could be used to securely transmit data related to agriculture such as crop yields, soil quality data, and weather data, between different parties. This could help to prevent tampering or other security breaches, and ensure that only verified, trustworthy data is transmitted.

**Energy Industry Use Cases.** Gordian Envelopes could also be used to securely transmit data related to the energy industry such as electricity usage data and grid configuration data between different parties.

**Environmental Industry Use Cases.** Gordian Envelopes could also be used to securely transmit data related to the environment such as water quality data, air quality data, and weather data between different parties.

**Healthcare Industry Use Cases.** Gordian Envelopes can be used in the healthcare industry to securely and privately transmit and store patient health records, allowing authorized parties to access only the information they are authorized to view. This can help healthcare organizations comply with privacy regulations, such as HIPAA in the United States. The use of Gordian Envelopes in the healthcare industry allows for decentralized access to medical information while still preserving the privacy and security of the data.

**Law, Government, and Public Sector Industry Use Cases.** In the legal, government, and public sector, Gordian Envelopes can be used to encode and transmit sensitive legal documents such as contracts and court orders, while preserving their complex data structures and ensuring personal privacy. The ability of Gordian Envelopes to offer selective disclosure of information is useful in this sector where only certain parties may be authorized to view certain information. This can help to protect the human rights of individuals by ensuring that personal data is not misused. Additionally, the use of Gordian Envelopes can support transparency and accountability in government by allowing for the selective disclosure of public data to authorized parties, helping to prevent the misuse of government power.

**Supply Chain Use Cases.** Gordian Envelopes can be used to encode and transmit sensitive information, such as production schedules, inventory levels, shipping records, and quality control data, while preserving their complex data structures and ensuring privacy. The ability of Gordian Envelopes to elide or externally reference certain parts of the envelope allows for cooperation among diverse supply chain parties and promotes fair trade by preventing unfair competition. 

**Telecommunications Use Cases.** Gordian Envelopes could also be used to securely transmit data related to telecommunications networks, such as network configuration data and customer data, between different parties in the telecommunications industry.

**Transportation Use Cases.** Gordian Envelopes could also be used to securely transmit data related to the movement of people and goods, such as flight plans and cargo manifests, between different parties in the transportation industry. 

## The Common Thread of Use Cases

The common thread among the use cases for Gordian Envelopes is the need for secure and privacy-enhancing solutions for transmitting and storing complex, sensitive data. This data may be related to a wide range of industries, have cross-industry contexts, or cross international borders. It often involves diverse parties with different business models, risk models, and trust boundaries.

When you have a diversity of individuals, groups, or organizations with different needs, business requirements, legal requirements, and risk-management requirements, Gordian Envelopes are at their strongest. They offer a flexible, privacy-enhancing solution for transmitting and storing data in different ways for different entities.

Supporting data that is complex and sensitive is another particular strength of Gordian Envelopes. They can help to prevent tampering or other security breaches and ensure that only verified, trustworthy data is transmitted. This can be particularly important in industries such as healthcare, finance, and government, where the verifiability of personal data is of utmost concern.

Finally, Envelopes are particularly strong when they are protecting human rights. The core value proposition of the privacy features of Gordian Envelopes cannot be overstated: through its support for selective disclosure and [progressive trust](https://www.blockchaincommons.com/musings/musings-progressive-trust/), Gordian Envelopes allow for disclosure of only specific parts of the data, and only to only authorized parties, enforcing that the privacy rights of individuals are respected.

