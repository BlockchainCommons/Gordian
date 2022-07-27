# The Gordian Architecture

The Gordian architecture is an overall plan for interoperable specifications and design patterns that support the [Gordian Principles](https://github.com/BlockchainCommons/Gordian#gordian-principles), ensuring the independence, privacy, resilience, and openness of digital assets. The ultimate goal is to prevent vendor lock-in and to remove the threats of single points of compromise, failure, and denial so that users can personally protect their self-sovereign digital assets without the fear of loss.

We suggest the use of our Macro-Architecture when designing applications, including Key Management Services, and the use of our Visual Specifications to support users in their recognition of seeds and other digital objects. However, it's our encoding specifications, including URs, that may be the most critical because they're what ensure interoperability among applications, so that they may easily talk to each other and exchange data, and so that in the future Gordian data may be recovered even if the application that generated it is no longer operable.

## Macro-Architecture

The Gordian Macro-architecture is built on a design pattern of functional partition.

Rather than following the design pattern of classic services, which group multiple services into singular applications, the Gordian Architecture instead separates both services and confidential data from each other, paritioning them with airgaps and torgaps. Doing so improves privacy and security by reducing the value of honeypots and also improves functional design by ensuring that each application is precisely and concisely able to perform a specific function. Many of the Gordian reference apps are actually microservices, intended to perform small and simple but necessary activities as part of the blockchain ecosystem.

Using functionally partitioned services, linked by airgaps and torgaps to minimize attacks in transit and to improve partitioning, the Gordian architecture creates a powerful and safe new methodology for financial, data, and information operations on the internet. It also creates an ecosystem that allows for the inclusion of multiple developers, each producing their own applications that are all interoperable thanks to usage of Gordian Encoding Specifications. This improves the overall architecture through these competitive designs and ensures survivability of the model as a whole.

* **Service.** A service that fulfills some large-scale need for digital-asset management, most commonly the ability to create transactions, sign transactions, and send transactions. *Examples:* [Gordian Seed Tool](https://github.com/BlockchainCommons/GordianSeedTool-iOS) (signing device), Gordian Coordinator (transaction coordinator).

* **Microservice.** A service that fulfills a small need in the overall Gordian ecosystem such as price lookups. *Examples:* [SpotBit](https://github.com/BlockchainCommons/spotbit).

* **AirGap.** A physical gap between services or microservices, where either side might not even be networked. A service protected by an AirGap is usually communicated with via the reading of QR Codes or through transmission of data on MicroSD cards, NFC tags, or other removable media.

* **TorGap.** A link between services or microservices that connect via [Tor](https://www.torproject.org/), maximizing their partitioning by ensuring mutual anonymity of the services.

### Key Management Services

Traditionally, digital-asset architectures have focused on multi-function wallets that act as both transaction coordinators and signing devices. Breaking apart features through the design pattern of functional partition reveals that there's much more. The Collaborative Seed Recovery (CSR) service and the future Collaborative Key Management (CKM) service demonstrate how a Gordian Macro-architecture can purposefully fulfill the Gordian Principles of independence, privacy, resilience, and openness.

* **Collaborative Seed Recovery (CSR).** CSR is a service that improves the resilience of seeds and other secrets by using SSKR to distribute shares of the secret to a variety of Share Servers. The goal is to automate the backup and reconstruction of secrets in order to protect the self-sovereign control of digital assets. See [Collaborative Seed Recovery Overview](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/CSR.md).

* **Collaborative Key Management.** CKM is a future technology that will introduce key-management servers that generate and use secrets without those secrets ever existing prior to their usage. It continues the pattern of resilience introduced by CSR but takes it to the next step by also offering strong protections against compromise.

## Visual Specifications

Visual Specifications are intended to improve the usability of digital assets by making it easy for the user to recognize one without having to memorize a long hex code.

* **Object Identity Block.** An Object Identity Block (OIB) is a collection of readable data and images which together make it easy to recognize the digital object being described. See [BCR-2021-02: Digests for Digital Objects](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2021-002-digest.md).

* **Lifehash.** A Lifehash appears as part of an OIB. It's a visual hash of a digital object that is intended to make it possible to recognize an object at a glance thanks to the patterning and coloring. See [Lifehash.info](https://lifehash.info/) and the [Lifehash.info README](https://github.com/BlockchainCommons/lifehash.info#lifehash-beautiful-visual-hashes).

## Encoding Specifications

* **ByteWords.**

* **CBOR.**

* **QR Codes.**

* **SSKR.**

* **UR.**

## UR Specifications

* **Crypto-Envelopes.**

* **Crypto-Request** & **Crypto-Response.**
