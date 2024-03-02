# 🛠 The Gordian System

### **Architect:** _[Christopher Allen](https://github.com/ChristopherA)_<br/>
**Developer:** _[Wolf McNally](https://github.com/WolfMcNally)_
* <img src="https://github.com/BlockchainCommons/Gordian/blob/master/Images/logos/gordian-icon.png" width=16 valign="bottom"> ***uses [gordian](https://github.com/BlockchainCommons/gordian/blob/master/README.md) technology***
* <img src="https://raw.githubusercontent.com/BlockchainCommons/torgap/master/images/logos/torgap.png" width=30 valign="bottom"> ***uses [torgap](https://github.com/BlockchainCommons/torgap/blob/master/README.md) technology***

![](/Images/logos/gordian-logo-white.png)

The Gordian system is all about user agency & security. It's intended to support the self-sovereign control of digital assets in a way that's safe, secure, and private by enabling responsible key management, [cutting through a traditionally knotty problem in Bitcoin development.](Architecture/Why-Gordian.md). The Gordian system is built on a foundation of Principles that have been fulfilled in an Architecture that is embodied in Reference Apps and supported by Reference Libraries.

* **Gordian Principles.** A mission statement of four core principles that support self-sovereign control of digital assets.
* **Gordian Architecture.** The design for both the overall architecture and the individual specifications that make it possible.
* **Gordian Reference Apps.** A set of applications that demonstrate the Gordian Architecture, its Principles, its specifications, and its Libraries.
* **Gordian Reference Libraries.** A set of libraries that allow developers to incorporate Gordian specifications and expand the Gordian ecosystem.
* **#SmartCustody.** Educational programs meant to support the Gordian Principles.

The ultimate goal of the Gordian System is to create a community of developers who have followed the examples of the Gordian Reference Apps and used the Gordian Reference Libraries to build their own applications that embody the Gordian Architecture and fulfill the Gordian Principles.

*This repo contains a table of contents for various the Gordian system projects and features. Please see individual repos and pages for more information.*

*You can also join our [Signal Group, GitHub Discussions, or low-volume announcement list for Gordian Developers](https://www.blockchaincommons.com/subscribe.html#gordian-developers).*

## Gordian Principles

Blockchain Commons' interoperable specifications are meant to support four core principles that put the user first and that enable responsible key management:

* **Independence.** Gordian improves user freedom from involuntary oversight or external control.
* **Privacy.** Gordian protects against coercion with non-correlation, privacy, and pseudonymity.
* **Resilience.** Gordian protects users to decrease the likelihood of them losing their funds via any means.
* **Openness.** Gordian supports open infrastructure that allows developers to create their own applications.

Look at individual Blockchain Commons reference apps for guidance on how each acts as a model for these principles and [#SmartCustody Case Studies](https://github.com/BlockchainCommons/SmartCustody/blob/master/Docs/Case-Studies-Overview.md) for how professional hardware & software apps do so.

## Gordian Architecture

The Gordian Architecture puts the Gordian Principles into use through an overall design that covers everything that from the high-level architecture of a Gordian ecosystem through the specification and UX best practices that make it possible.

* **Gordian Macro-Architecture.** The ecosystem architecture depends on functional partition, separating services and confidential data.
   * The Macro-Architecture is built primarily to support _Privacy_ through these features.
   * It is also built on a concept of _Openness_ where different Services from different developers will interoperate freely.
* **Data Format.** [CBOR](https://www.blockchaincommons.com/introduction/Why-CBOR/) is used as the canonical data structure for the Gordian Architecture.
* **Encoding Specifications.** Bytewords, URs, and (optionally) [Animated](https://www.blockchaincommons.com/devs/animated-qrs.html) or Static QRs ensure that Gordian services are interoperable.
   * The Encoding Specifications are how the Gordian System ensures _Openness_ in its Macro-Architure.
* **Backup Specifications.** UR specifications make it easy to backup confidential data.
  * Supporting backups of data improves the _Resilience_ of that data.
* **Communication Specifications.** Further UR specifications such as [Gordian Envelope](https://www.blockchaincommons.com/introduction/Envelope-Intro/) and request/responses aid interoperable communication.
   * Like the Encoding Specifications, Communication Specifications help to suport the _Openness_ of the architecture.
   * They also ensure _Independence_ because they assure the portability of data.
* **Secure UX Designs.** UX best practices form another layer of support for the Gordian Principles.
   * Good UX designs help _Resilience_ by proofing a user against mistake or con-men attacks of various sorts.
   * They also improve _Independence_ by making it easier for a user to control their own destiny.

Please see [The Gordian Architecture](/Architecture/README.md) for more in-depth discussion of all the architectural elements and [Gordian Architecture Roles](/Architecture/Roles.md) for examples of functions that can be partitioned within the Macro-architecture. Also see [Collaborative Seed Recovery (CSR) Overview](CSR/README.md) for our largest current architectual project in 2022 and [Collaborative Key Management (CKM) Overview](CKM/README.md) for our planned next step in 2023-2024.

Together, these elements (in particular: a network coordinator such as Gordian Coordinator; a signing device such as Gordian Seed Tool; encoding specifications such URs; and communication specifications such as envelope, request, and response) comprise what we consider a Minimal Viable Architecture (MVA) for Gordian, and thus for safe, self-sovereign architecture. They're the minimum that's needed to properly support users.

### Use Cases

Use Cases further describe the intent of Blockchain Commons' architecture.

**Gordian Envelope:**

* [**Use Case Overview**](https://github.com/BlockchainCommons/Gordian/blob/master/Envelope/Use-Cases/README.md)
   * [**Educational & Credential Industry Use Cases**](https://github.com/BlockchainCommons/Gordian/blob/master/Envelope/Use-Cases/Educational.md) — Using Envelopes to store & transmit credentials.
   * [**Wellness Use Cases**](https://github.com/BlockchainCommons/Gordian/blob/master/Envelope/Use-Cases/Wellness.md) — Using Envelopes to share very sensitive data.
   * [**Data Distribution Use Cases**](https://github.com/BlockchainCommons/Gordian/blob/master/Envelope/Use-Cases/Data.md) — Using Envelopes for user-related data releases.
   * [**Software & AI Industry Use Cases**](https://github.com/BlockchainCommons/Gordian/blob/master/Envelope/Use-Cases/Software.md) — Using Gordian Envelopes to release software.
   * [**Financial Industry Use Cases**](https://github.com/BlockchainCommons/Gordian/blob/master/Envelope/Use-Cases/Financial.md) — Using Envelopes to store assets.

**Collaborative Seed Recovery:**
* [**Use Cases**](https://hackmd.io/ZbRiwvUfQSy-1RKM15bM8Q#CSR-Focused-Use-Cases) — A short listing of CSR-focused use cases.

**Collaborative Key Management:**
* [**Use Cases**](https://hackmd.io/ZbRiwvUfQSy-1RKM15bM8Q#Secret-Sharing-Use-Cases) — More future-looking use cases that span CSR and CKM.

### Video Overview

This video overview covers many of the technologies found in the Gordian Architecture:
<center>
  <a href="https://www.youtube.com/watch?v=RYgOFSdUqWY"><img src="/Images/video-tech-overview.png"></a>
</center>

## Gordian Reference Apps

Gordian Reference Apps demonstrate the elements of how the Gordian Architecture and how they can be used to fulfill the Gordian Principles. Our Gordian Reference Apps undergoing the most development currently include:

* **Gordian Coordinator.** A Networked transaction coordinator.
   * Demonstrates _Independence_ and _Privacy_ by empowering users to create their own transactions, potentially in a non-Networked way.
   * Demonstrates _Openness_ through use of Communication Specifications such as URs.
   * Improves _Resilience_ through support for multi-sigs.
* **Gordian Seed Tool.** An Airgapped seed vault & signing device.
   * Allows for _Independence_ and _Resilience_ by storing user assets in a Closely Held device.
   * Demonstrates _Openness_ through the use of Communication Specifications such as URs.
   * Improves _Resilience_ through Sharding and Backup Specifications.
* **SpotBit.** A Micro-pricing service.
   * Demonstrates the _Openness_ of a digital-asset ecosystem that supports Microservices.
   * Improves _Privacy_ through the user of a Torgap.
   * Improves _Independence_ by removing centralization of price-lookups.

Please see [The Gordian Reference Apps](/Architecture/Apps.md) for a complete list of past and present reference apps, links to their repos, and an example of how they can be combined into a Macro-Architecture. Links to CLI apps are also included.

## Gordian Reference Libraries

The Gordian Reference Libraries allow you to easily use many of the specifications that lay the foundation for the Gordian Architecture. Our foundational libraries are usually written in C or C++, but many have many converted in other languages such as Java, Python, and Swift.

The core libraries are:

* **bc-bytewords.** A library for encoding binary data into Bytewords. A Gordian _Encoding Specification_.
* **bc-lifehash.** A library for creating Lifehash visual hashes. A Gordian _UX Design_.
* **bc-sskr.** A library for sharding a secret and converting it to Bytewords or URs. A Gordian _Backup Specification_.
* **bc-ur.** A library for encoding binary data as URs. A Gordian _Encoding Specification_.

Please see [The Gordian Reference Libraries](https://github.com/BlockchainCommons/crypto-commons#gordian-reference-libraries) for a complete list of libraries in a variety of languages.

## Module Dependencies

* [This document](SwiftDependencies.md) details the dependencies between many of our reference libraries and apps in the Swift/iOS/macOS ecosystem. Many of the higher-level libraries are written in Swift, while there are a number of important lower-level libraries that are written in C or C++.

## #SmartCustody Articles

Please see the [SmartCustody repo](https://github.com/BlockchainCommons/SmartCustody) for articles on Multisigs, Timelocks, and other SmartCustody topics.

## Gordian Lexicon

The following words & phrased are used in Gordian documents:

* **Airgap.** A _Partition_ between two _Services_, such that they are not _Networked_ on the same network. (Often, at least one _Service_ is not _Networked_ at all). See [Airgap (Wikpedia)](https://en.wikipedia.org/wiki/Air_gap_(networking)).
* **Animated QRs.** An animation of a QR made up of several frames. Used for transmitting data larger than the max possible with _Quick Response (QR) Codes_. See [Animated QRs Page](https://www.blockchaincommons.com/devs/animated-qrs.html).
* **ByteWords.** An _Encoding Specification_ that represents binary data as English words. Used in the _Gordian System_ primarily to represent _CBOR_ in _URs_. See [ByteWords Spec](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-012-bytewords.md).
* **CBOR.** A _Data Format_, the canonical data representation for the _Gordian System_. It represents data in a binary format. See [RFC 8949](https://cbor.io/).
* **Closely Held Device.** A hardware device such as a phone or a hardware wallet that is privately held by an individual, that has a small attack surface due to careful and consistent sandboxing, and that is not constantly _Networked_ in the way that a full computer tends to be.
* **Collaborative Key Management (CKM).** A _Service_ for the collaborative generation and usage of keys. See [CKM Overview](CKM/README.md).
* **Collaborative Seed Recovery (CSR).** A _Service_ to improve _Resilience_ by storing _Shares_ of keys or seeds that are created by _Sharding_. See [CSR Overview](CSR/README.md).
* **Data Format.** A _Specification_ for a structure to store data.
* **Encoding.** A conversion of data into a specific form. See [Encoding (Techopedia)](https://www.techopedia.com/definition/948/encoding).
* **Encoding Specification.** A _Specification_ for _Encoding_. See [Gordian Encoding Specifications](https://github.com/BlockchainCommons/Gordian/blob/master/Architecture/README.md#encoding-specifications).
* **Envelope.** A communication _Specification_ for a Smart Document that supports the storage, backup, encryption & authentication of data, with explicit support for Merkle-based selective disclosure.
* **Functional Partition.** The philosophy of separating different functions as different parts of an interoperable ecosystem, and also dividing data up into different locations, all to improve _Resilience_. This is done with _Partitions_ and could include _Airgaps_ or _Torgaps_.
* **Gordian Architecture.** A suggested design for a data-asset ecosystem using _The Gordian System_. It incudes _Macro-Architecture_, _Data Formats_, _Specifications_, and _UX Designs_. See [Gordian Architecture Overview](https://github.com/BlockchainCommons/Gordian/blob/master/Architecture/README.md).
* **Gordian Macro-Architecture.** The interoperable design of a system of _Services_, applications, and hardware devices that builds upon the _Gordian Principles_. The macro-architectural is built upon a foundational idea of _Functional Partition_. Part of teh _Gordian System_. See [Gordian Macro-Architecture Overview](https://github.com/BlockchainCommons/Gordian/blob/master/Architecture/README.md#macro-architecture).
* **Gordian Principles.** Four fundamental precepts at the heart of the _Gordian System_: _Independence_, _Privacy_, _Resilience_, and _Openness_. See [Gordian Principles Overview (Above)](https://github.com/BlockchainCommons/Gordian#gordian-principles).
   * **Independence.** The ability to work in a self-sovereign way without centralization. A _Gordian Principle_.
   * **Privacy.** Protection of personal data and usage against correlation and censorship. A _Gordian Principle_.
   * **Resilience.** The ability to prevent loss of assets or data, including resilience against theft and resilience against accidental loss. A _Gordian Principle_.
   * **Openness.** Interoperability of systems and easy portability of data. A _Gordian Principle_.
* **Gordian System.** An overall design for a data ecosystem that includes _Architecture_, _Reference Apps_, _Libraries_, and _Specifications_ that are intended to support the _Gordian Principles_. See [Gordian System Overview (This Page)](https://github.com/BlockchainCommons/Gordian#-the-gordian-system).
* **Lifehash.** A _UX Design_ that creates a visual hash as part of an _OIB_ to allow for visual identification of data. See [Lifehash.info](https://lifehash.info/).
* **Microservice.** A _Service_ that provides a capability which is very specific and/or infrequently used. See [Gordian Macro-Architecture Overview](https://github.com/BlockchainCommons/Gordian/blob/master/Architecture/README.md#macro-architecture).
* **Networked.** Directly connected to an online network.
* **Object Identity Block (OIB).** A _UX Design_ for an array of data that can together allow a user to easily and uniquely identify data. Can include a _Lifehash_. See [Digests for Digital Objects Paper](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2021-002-digest.md).
* **Partition.** A division between two or more _Services_. A partition could be as simple as ensuring those _Services_ are on different machines, but can also include an _Airgap_ or _Torgap_.
* **Progressive Trust.** The concept of gradually building trust over time. See [Musings of a Trust Architect: Progressive Trust](https://www.blockchaincommons.com/musings/musings-progressive-trust/).
* **Quick Connect.** A _UX Design_ for a _URI_ or _QR Code_ that can be used to securely connect together two devices that are separated by a _Partition_. See [Quick Connect API](https://github.com/BlockchainCommons/Gordian/blob/master/QuickConnect/README.md).
* **Quick Response (QR) Code.** An _Encoding Specification_ that represents data in a graphical format. _URs_ are built to allow for efficient encoding as a QR Code. With them, Gordian [Animated QRs](https://www.blockchaincommons.com/devs/animated-qrs.html) can support animation of larger data sets using foundation codes. See [QR Code (Wikipedia)](https://en.wikipedia.org/wiki/QR_code) & [UR Spec](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-005-ur.md)
* **Reference App.** An application that shows an example of the usage of a _Specification_, usually built with a _Reference Library_. Gordian Reference Apps are part of the _Gordian System_. See [Gordian Reference Apps](https://github.com/BlockchainCommons/Gordian/blob/master/Architecture/Apps.md).
* **Reference Library.** A library that provides an API for using a _Specification_. Gordian Reference Libraries are part of the _Gordian System_. See [Gordian Reference Libraries](https://github.com/BlockchainCommons/crypto-commons#gordian-reference-libraries).
* **Service.** An application providing a specific capability as part of the _Functional Partition_ of a digital-asset ecosystem. Includes _Microservices_.
* **Share.** A fraction of a seed or a key created by an algorithm such as Shamir's Secret Sharing or VSS. Intended to improve _Resilience_ of data. See [UR Definition for SSKR](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-011-sskr.md).
* **Sharding.** The process of creating _Shares_ from seeds or keys. See [UR Definition for SSKR](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-011-sskr.md).
* **SmartCustody.** Documents, instructions, and _Specifications_ intended to improve the _Resilience_ of digital assets, either at the personal or the ecosystem level. See [SmartCustody Repo](https://github.com/BlockchainCommons/SmartCustody/blob/master/README.md).
* **Specification.** A specific design intended to support communication, data, or backup _Encoding_ and backup, to ensure the _Openness_ of interoperability, to support _UX Design_, or to ensure other _Gordian Principles_. Part of the _Gordian System_. See Gordian Specifications in [Blockchain Commons Research Repo](https://github.com/BlockchainCommons/Research/blob/master/README.md) & [Crypto Commons Docs](https://github.com/BlockchainCommons/crypto-commons/blob/master/Docs/README.md).
* **Torgap.** A _Partition_ between two _Services_, created to ensure that they are anonymous to each other. See [Torgap Repo](https://github.com/BlockchainCommons/torgap#readme).
* **Uniform Resources (URs).** An _Encoding Specification_ of a _URI_ for data. It is created by representating data as _CBOR_ and then encoding it with minimal _Bytewords_. URs are also built to allow efficient _Encoding_ as _QR Codes_. URs allow for interoperable communication. See [UR Spec](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-005-ur.md).
* **Uniform Resource Identifier (URI).** A unique sequence for identifying a resource. A _UR_ is a URI. See [URI (Wikipedia)](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier).
* **UX Design.** A methodology for presenting data to a user. See [Secure UX Designs](https://github.com/BlockchainCommons/Gordian/blob/master/Architecture/README.md#secure-ux-designs).

## Gordian Discussions

All of these Gordian topics can be discussed in our two Gordian discussion areas:

[**Gordian Developer Community**](https://github.com/BlockchainCommons/Gordian-Developer-Community/discussions). For standards and open-source developers who want to talk about interoperable wallet specifications, please use the Discussions area of the [Gordian Developer Community repo](https://github.com/BlockchainCommons/Gordian-Developer-Community/discussions). This is where you talk about Gordian specifications such as [Gordian Envelope](https://github.com/BlockchainCommons/Gordian/tree/master/Envelope#articles), [bc-shamir](https://github.com/BlockchainCommons/bc-shamir), [Sharded Secret Key Reconstruction](https://github.com/BlockchainCommons/bc-sskr), and [bc-ur](https://github.com/BlockchainCommons/bc-ur) as well as the larger [Gordian Architecture](https://github.com/BlockchainCommons/Gordian/blob/master/Architecture/README.md), its [Principles](https://github.com/BlockchainCommons/Gordian#gordian-principles) of independence, privacy, resilience, and openness, and its macro-architectural ideas such as functional partition (including airgapping, the original name of this community).

## Status - Varied

Please see individual projects for current status.

## Origin, Authors, Copyright & Licenses

Unless otherwise noted (either in this [/README.md](./README.md) or in the file's header comments) the contents of this repository are Copyright © 2020 by Blockchain Commons, LLC, and are [licensed](./LICENSE) under the [spdx:BSD-2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html).

In most cases, the authors, copyright, and license for each file reside in header comments in the source code. When it does not, we have attempted to attribute it accurately in the table below.

This table below also establishes provenance (repository of origin, permalink, and commit id) for files included from repositories that are outside of this repo. Contributors to these files are listed in the commit history for each repository, first with changes found in the commit history of this repo, then in changes in the commit history of their repo of their origin.

| File      | From                                                         | Commit                                                       | Authors & Copyright (c)                                | License                                                     |
| --------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------ | ----------------------------------------------------------- |


## Financial Support

The Gordian system is a project of [Blockchain Commons](https://www.blockchaincommons.com/). We are proudly a "not-for-profit" social benefit corporation committed to open source & open development. Our work is funded entirely by donations and collaborative partnerships with people like you. Every contribution will be spent on building open tools, technologies, and techniques that sustain and advance blockchain and internet security infrastructure and promote an open web.

To financially support further development of the Gordian system and other projects, please consider becoming a Patron of Blockchain Commons through ongoing monthly patronage as a [GitHub Sponsor](https://github.com/sponsors/BlockchainCommons). You can also support Blockchain Commons with bitcoins at our [BTCPay Server](https://btcpay.blockchaincommons.com/).

## Contributing

We encourage public contributions through issues and pull requests! Please review [CONTRIBUTING.md](./CONTRIBUTING.md) for details on our development process. All contributions to this repository require a GPG signed [Contributor License Agreement](./CLA.md).


### Other Questions & Problems

As an open-source, open-development community, Blockchain Commons does not have the resources to provide direct support of our projects. Please consider the discussions area as a locale where you might get answers to questions. Alternatively, please use this repository's [issues](./issues) feature. Unfortunately, we can not make any promises on response time.

If your company requires support to use our projects, please feel free to contact us directly about options. We may be able to offer you a contract for support from one of our contributors, or we might be able to point you to another entity who can offer the contractual support that you need.

### Credits

The following people directly contributed to this repository. You can add your name here by getting involved. The first step is learning how to contribute from our [CONTRIBUTING.md](./CONTRIBUTING.md) documentation.

| Name              | Role                | Github                                            | Email                                 | GPG Fingerprint                                    |
| ----------------- | ------------------- | ------------------------------------------------- | ------------------------------------- | -------------------------------------------------- |
| Christopher Allen | Principal Architect | [@ChristopherA](https://github.com/ChristopherA) | \<ChristopherA@LifeWithAlacrity.com\> | FDFE 14A5 4ECB 30FC 5D22  74EF F8D3 6C91 3574 05ED |

## Responsible Disclosure

We want to keep all of our software safe for everyone. If you have discovered a security vulnerability, we appreciate your help in disclosing it to us in a responsible manner. We are unfortunately not able to offer bug bounties at this time.

We do ask that you offer us good faith and use best efforts not to leak information or harm any user, their data, or our developer community. Please give us a reasonable amount of time to fix the issue before you publish it. Do not defraud our users or us in the process of discovery. We promise not to bring legal action against researchers who point out a problem provided they do their best to follow the these guidelines.

### Reporting a Vulnerability

Please report suspected security vulnerabilities in private via email to ChristopherA@BlockchainCommons.com (do not use this email for support). Please do NOT create publicly viewable issues for suspected security vulnerabilities.

The following keys may be used to communicate sensitive information to developers:

| Name              | Fingerprint                                        |
| ----------------- | -------------------------------------------------- |
| Christopher Allen | FDFE 14A5 4ECB 30FC 5D22  74EF F8D3 6C91 3574 05ED |

You can import a key by running the following command with that individual’s fingerprint: `gpg --recv-keys "<fingerprint>"` Ensure that you put quotes around fingerprints that contain spaces.
