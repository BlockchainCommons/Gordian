# 🛠 Gordian Products & Technologies

### **Architect:** _[Christopher Allen](https://github.com/ChristopherA)_<br/>**Developers:** _[Peter Denton](https://github.com/Fonta1n3) and [Wolf McNally](https:github.com/WolfMcNally)_
* <img src="https://github.com/BlockchainCommons/Gordian/blob/master/Images/logos/gordian-icon.png" width=16 valign="bottom"> ***uses [gordian](https://github.com/BlockchainCommons/gordian/blob/master/README.md) technology***
* <img src="https://raw.githubusercontent.com/BlockchainCommons/torgap/master/images/logos/torgap.png" width=30 valign="bottom"> ***uses [torgap](https://github.com/BlockchainCommons/torgap/blob/master/README.md) technology***

![](Images/logos/gordian-overview-screen.png)

Gordian offers a new approach to managing digital assets based on a set of principles and best practices that put the user first. It enhances independence and resilience by granting users the ability to robustly control their own digital assets using responsible key management and creates openness so that users won't be locked into anyone else's system. ([It's meant to cut through a traditionally knotty problem in Bitcoin development.](Docs/Why-Gordian.md))

The Gordian system supports these principles with a number of interoperable specifications such as [Bytewords](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-012-bytewords.md), [Lifehash](https://github.com/BlockchainCommons/LifeHash), [SSKR](https://github.com/BlockchainCommons/crypto-commons/blob/master/Docs/README.md#sharded-secret-key-reconstruction-sskr), and [UR](https://github.com/BlockchainCommons/crypto-commons/blob/master/Docs/ur-1-overview.md) as well architectural elements such as Airgaps and [Torgaps](https://github.com/BlockchainCommons/torgap). 

Blockchain Commons provides a number of reference libraries and reference implementations intended as examples for these specifications and architectures that display how they can be used in real-life. We invite developers to use these references based on our open licenses, as detailed in our individual repos, as guides for creating your own software that will support the Gordian Principles.

*This repo contains a table of contents for various the Gordian system projects and features. Please see individual repos and pages for more information.*

## Gordian Principles

Blockchain Commons' interoperable specifications are meant to support four core principles that put the user first and that enable responsible key management:

* **Independence.** Gordian improves user freedom from involuntary oversight or external control.
* **Privacy.** Gordian protects against coercion with non-correlation, privacy, and pseudonymity.
* **Resilience.** Gordian protects users to decrease the likelihood of them losing their funds via any means.
* **Openness.** Gordian supports open infrastructure that allows developers to create their own applications.

Look at our individual reference apps for guidance on how each acts as a model for these principles.

## Quick Links for App Repos

* [GordianWallet-iOS](https://github.com/BlockchainCommons/GordianWallet-iOS)
   * [Install in Testflight](https://testflight.apple.com/join/OQHyL0a8)
* [GordianServer-macOS.app](https://github.com/BlockchainCommons/GordianServer-macOS)
   * [Install from DMG](https://github.com/BlockchainCommons/GordianServer-macOS/blob/master/GordianServer-macOS-v0.1.3.dmg)
   * [Linux Bitcoin-StandUp-Scripts](https://github.com/BlockchainCommons/Bitcoin-StandUp-Scripts)
* GordianCosigner
   * [GordianCosigner-Android](https://github.com/BlockchainCommons/GordianSigner-Android)
   * [GordianCosigner-catalyst (iOS)](https://github.com/BlockchainCommons/GordianSigner-Catalyst)
   * [GordianCosigner-MacOS](https://github.com/BlockchainCommons/GordianSigner-macOS)
* [GordianQRTool-iOS](https://github.com/BlockchainCommons/GordianQRTool-iOS)
   * [Download from Appstore](https://apps.apple.com/us/app/gordian-qr-tool/id1506851070)
* [GordianSeedTool-iOS](https://github.com/BlockchainCommons/GordianSeedTool-iOS)
   * [Download from Appstore](https://apps.apple.com/us/app/gordian-seed-tool/id1545088229)
* [LetheKit](https://github.com/BlockchainCommons/bc-lethekit)
* [SpotBit](https://github.com/BlockchainCommons/spotbit)

## Quick Links for #SmartCustody Articles

Please see the [SmartCustody repo](https://github.com/BlockchainCommons/SmartCustody) for articles on Multisigs, Timelocks, and other SmartCustody topics.

## Overview: Gordian Architectural Model

The Gordian reference architecture, supporting the Gordian principles, is based on a theory of functional partition. 

Rather than following the design pattern of classic services, which group multiple services into singular applications, Blockchain Commons instead separates services from each other. Doing so improves both privacy and security by reducing the value of honeypots and also improves functional design by ensuring that each application is precisely and concisely able to perform a specific function. 

Many of the Gordian reference apps are actually microservices, intended to perform small and simple but necessary activities as part of the blockchain ecosystem.

In order to maximize the utility of its functional partitions, the Gordian system also introduces gaps between services, which further the privacy and security capabilities of the architectural model.

<img src="https://raw.githubusercontent.com/BlockchainCommons/Gordian/master/Images/airgap.png" width=30> ***Airgaps.***  The traditional manner for segregating services within a cryptographic network is to use an airgap. This is a physical gap that keeps the segregated services from talking via any sort of connected network. Instead, data flow between the services occurs via QR codes or other methods of small-scale data-only transfer. An airgap is often used to protect private keys on a non-networked device. The [UR specification](https://github.com/BlockchainCommons/crypto-commons/blob/master/Docs/ur-1-overview.md) was built explicitly to enable safe, secure airgapping. Airgaps are built into some of Blockchain Commons' reference apps, but are optional.

<img src="https://raw.githubusercontent.com/BlockchainCommons/Gordian/master/Images/torgap.png"  width=30>***Torgaps.***  This is a new methodology for segregating cryptographic services, used when the services must be networked. As the name suggests, it places an onion link between the two services, enabling privacy and security while still allowing connectivity. Its power can be increased further with quorum computing, which aggregates services across different providers.

Using functionally partitioned services, linked by airgaps and torgaps, the Gordian architecture creates a powerful and safe new methodology for financial, data, and information operations on the internet. It also creates an interoperable market for cooperative competition, where various creators can introduce their own services, improving the overall architecture through their competitive designs and ensuring survivability of the model as a whole.

### Enabling the Gordian Principles with the Gordian Architecture

As a reference architecture, the Gordian Architecture also demonstrates the Gordian Principles.

* **Independence.** Users can choose which applications to use within an open ecosystem.
* **Privacy.** Airgaps provide data with strong protection, while torgaps do the same for networked interactions.
* **Resilience.** The paritioned design minimizes Single Points of Compromise.
* **Openness.** Airgaps and torgaps are connected via standard specifications such as URs, which allow anyone to add apps to the ecosystem.

## Overview: Gordian App Map

The Gordian architecture model is demonstrated through the Gordian reference apps, all linked by airgaps and torgaps, as laid out in the following diagram.

![](https://raw.githubusercontent.com/BlockchainCommons/Gordian/master/Images/appmap.png)

_The core of the Gordian system is our Wallet and Server reference apps:_

### Wallet & Server

***[Gordian Wallet](https://github.com/BlockchainCommons/GordianWallet-iOS).*** The central reference app for the Gordian system, the Gordian Wallet is a mobile Bitcoin wallet that supports sophisticated [#SmartCustody](https://www.smartcustody.com/) features such as multi-sigs and PSBTs. It acts as: a policy coordinator, determining how you set up your accounts; a transaction coordinator, creating transactions based on your policies; and a broadcast coordinator, determining how to send our your transactions. The Gordian Wallet is also self-sovereign, which fulfills the Gordian Principles by giving you total control over it and how it interacts with the rest of the Bitcoin network, including choosing your full node and your pricing service. (Also see the spotlight on Gordian Wallet, below.)

***[Gordian Server](https://github.com/BlockchainCommons/GordianServer-macOS).*** A full-node server, created by Blockchain Commons' Bitcoin Standup scripts, running on a Mac or Linux machine. It connects to Gordian Wallet via a _torgap_. In the standard Gordian system setup, all transactions are signed with a 2-of-3 multi-sig, with one key secured by Gordian Wallet, one key used by Gordian Server, and one key saved offline. (Of course, since the Gordian system is self-sovereign, you can choose to use any other full-node server.) (Also see the spotlight on Gordian Server, below.)

### Airgapped Services

_For higher security, the Gordian system may optionally be used with airgapped services that ensure that your private keys never touch a network. The following reference apps and hardware devices demonstrate how this high level of Resilience can be created:_

***[Gordian Cosigner](https://github.com/BlockchainCommons/GordianSigner-Catalyst).*** An offline PSBT and multi-sig signer. You can import keys and read PSBTs via QR code. After you sign the PSBT, you can then move it back to your Wallet, which will coordinate the broadcast of the transaction.

***[Gordian SeedTool](https://github.com/BlockchainCommons/GordianSeedTool-iOS).*** A cryptographic seed manager for your iOS device.

***[LetheKit](https://github.com/BlockchainCommons/bc-lethekit).*** A do-it-yourself hardware kit that can be used to generate secure seeds for Bitcoin. It shares functionality with [Seedtool](https://github.com/BlockchainCommons/bc-seedtool-cli), but functions as airgapped hardware rather than potentially connected software.

### Microservices

_Blockchain Commons also also produced reference apps to demonstrate microservices within its architecture:_

***[SpotBit](https://github.com/BlockchainCommons/spotbit).*** A price-info microservice, used by Gordian Wallet (and potentially other Gordian services) through a _torgap_. Spotbit can be used to aggregate Bitcoin pricing information from a variety of exchanges and to store that data.

## Overview: Gordian Specifications

The Gordian system of course uses standard protocols for Bitcoin, to interact with the trustless network. We are also developing specifications of our own and expanding those created for other technology categories, to better fulfill the Gordian Principles. These specifications are demonstrated in many of our reference apps, to show how they can be used to full Gordian's requirements for Independent, Privacy, Resilience, and Openness. 

***[Bytewords](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-012-bytewords.md).*** Blockchain Commons developed its own binary-to-text format because of flaws in current ones, such as the variants that exist for base-64, and the fact that none of them convert efficiently to the QR codes used widely in Bitcoin applications. Bytewords stays within the 31 characters that are well supported by QR codes (that's letters plus numbers minus URL-breaking characters), allowing more efficient and safe usage.

***[CBOR](https://cbor.io/).*** Blockchain Commons represents binary data as CBOR, or 
Concise Binary Object Representation, which is RFC 7049. We feel that this self-descriptive language overcomes some of the flaws in pure JSON, while still retaining solid compatibility.

***[Quick Connect API](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Quick-Connect-API.md).*** A spec for a deep link URI and a scannable QR Code, used to connect a wallet and server across a gap.

***[SSKR](9https://github.com/BlockchainCommons/bc-sskr).*** A replacement for SLIP-39 to resolve issues where SLIP-39 and BIP-39 do not round-trip.

***[URs](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-005-ur.md).*** The objective of many of our protocol expansions was to create a more robust system for encoding PSBTs, which were otherwise limited by the maximimum size of QR codes and the inefficient ways in which current text formats interacted with them. Much of that comes together in our Uniform Resource (UR) encoding, which is built upon Byteword and CBOR structures. It creates a methodology for encoding PSBTs as QR codes, either using sequential or animated QRs.

Please see the [Airgapped Wallet repo](https://github.com/BlockchainCommons/Airgapped-Wallet-Community), especially its [discussions](https://github.com/BlockchainCommons/Airgapped-Wallet-Community/discussions), for more on our work with the community to advance wallet state of the art.

## Overview: Gordian Crypto Commons

To further support Gordian's principles and best practices, Blockchain Commons has created a number of Gordian reference libraries, which embody our specifications, as well as reference apps and command-line programs. 

These are fully described in the [Crypto Commons Overview](https://github.com/BlockchainCommons/crypto-commons/blob/master/README.md).

Blockchain Commons is also happy to use libraries from other sources, if they're stabled and well-supported.

## Spotlight: GordianWallet on iOS (and macOS)

[GordianWallet-iOS](https://github.com/BlockchainCommons/GordianWallet-iOS) is a reference app demonstrating how to securely connect to your node over Tor from anywhere in the world. Combined with your *GordianServer*, it demonstrates a powerful suite of tools for managing Bitcoin. You can scan the QuickConnect QR code from *GordianServer-macOS* and easily create mutli-sig wallets where one key gets stored on your device, one on your node, and one in offline backup.

<img src="https://raw.githubusercontent.com/BlockchainCommons/GordianWallet-iOS/master/Images/home_screen_collapsed.PNG" alt="Gordian Wallet app Home Screen" width="250"/> <img src="https://raw.githubusercontent.com/BlockchainCommons/GordianWallet-iOS/master/Images/home_screen_expanded.PNG" alt="Gordian Wallet app Home Screen" width="250"/>

*GordianWallet-iOS* is a macCatalyst app and can therefore be used on either iOS devices or macOS.

**[Install iOS Testflight](https://testflight.apple.com/join/OQHyL0a8)**

**[Install for macOS](https://github.com/BlockchainCommons/GordianWallet-iOS/blob/master/GordianWallet-macOS.dmg)**

### Other Wallet Options: FullyNoded for iOS

GordianWallet author Peter Denton also provides an alternative app: [FullyNoded-iOS](https://fullynoded.app/), a feature-rich Bitcoin wallet.

## Spotlight: Gordian Server on MacOS

[GordianServer-macOS.app](https://github.com/BlockchainCommons/GordianServer-macOS) provides personal one-click installation for Bitcoin Core and Tor. It's built on Bitcoin Standup technology that presents a QuickConnect QR code that can be used to pair mobile wallets for remote use over Tor V3.

<img src="./Images/0_standup_mac.png" alt="" width="500"/>

<img src="./Images/1_standup_mac.png" alt="" width="1000"/>

<img src="./Images/3_standup_mac.png" alt="" width="800"/>

*GordianServer-macOS* has been developed and tested on "Mojave" and "Catalina", it can be installed via a DMG or an Xcode compilation

**[Install from DMG](https://github.com/BlockchainCommons/GordianServer-macOS/blob/master/GordianServer-macOS-v0.1.2.dmg)**

### Other Node Options: Bitcoin Standup for Linux

[Linux Bitcoin-StandUp-Scripts](https://github.com/BlockchainCommons/Bitcoin-StandUp-Scripts) achieves the same thing as GordianServer-macOS, but comes in the form of Linux scripts rather than a central app.

The easiest-to-use version of the Linux scripts run through the StackScript system at Linode, but you can alternatively use Linux scripts that have been tested with Debian Stretch and Ubuntu 18.04.

## Spotlight: Gordian Cosigner on Android, MacOS, or iOS

The multi-platform GordianCosigner reference app for [Android](https://github.com/BlockchainCommons/GordianSigner-Android), [iOS](https://github.com/BlockchainCommons/GordianSigner-Catalyst), and [MacOS](https://github.com/BlockchainCommons/GordianSigner-macOS) demonstrates how a PSBT can be signed by the input of a xprv, 12-word mnemonic word set, or QR-UR. It does not transmit the PSBT, but just updates it, for finalization on another node.

This is our first example of a rapid multi-platform deployment, and also our first example of one of patrons (Bitmark) directly working with us to release an app for the Commons.

## Additional Information

### Further Docs

More information about the purpose and design of the Gordian architecture can be found in the following documents:

1. [Why Run a Full Node?](Docs/Why-Full.md) Why would you want to run a full node in the first place? There are advantages in validation, privacy, security, liquidity, and education.
2. [Security for Your Gordian system](Docs/Security.md). Notes on ensuring the security of your GordianServer.
3. [Why Gordian?](Docs/Why-Gordian.md) What the Gordian name means to us.

### Discussions

The best place to talk about Blockchain Commons and its projects is in our GitHub Discussions areas.

[**Gordian System Discussions**](https://github.com/BlockchainCommons/Gordian/discussions). For users and developers of the Gordian system, including the Gordian Server, Bitcoin Standup technology, QuickConnect, and the Gordian Wallet. If you want to talk about our linked full-node and wallet technology, suggest new additions to our Bitcoin Standup standards, or discuss the implementation our standalone wallet, the Discussions area of the [main Gordian repo](https://github.com/BlockchainCommons/Gordian) is the place.

[**Blockchain Commons Discussions**](https://github.com/BlockchainCommons/Community/discussions). For developers, interns, and patrons of Blockchain Commons, please use the discussions area of the [Community repo](https://github.com/BlockchainCommons/Community) to talk about general Blockchain Commons issues, the intern program, or topics other than the [Gordian System](https://github.com/BlockchainCommons/Gordian/discussions) or the [wallet standards](https://github.com/BlockchainCommons/AirgappedSigning/discussions), each of which have their own discussion areas.

### Related Projects

The full node created by the Gordian system can also be interlinked with other projects from Blockchain Commons.

1. [Learning Bitcoin from the Command Line](https://github.com/BlockchainCommons/Learning-Bitcoin-from-the-Command-Line) is a tutorial for programming the `bitcoin-cli`, which can be run using a full node such as the one created by the Gordian system.

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

### Discussions

The best place to talk about Blockchain Commons and its projects is in our GitHub Discussions areas.

[**Gordian System Discussions**](https://github.com/BlockchainCommons/Gordian/discussions). For users and developers of the Gordian system, including the Gordian Server, Bitcoin Standup technology, QuickConnect, and the Gordian Wallet. If you want to talk about our linked full-node and wallet technology, suggest new additions to our Bitcoin Standup standards, or discuss the implementation our standalone wallet, the Discussions area of the [main Gordian repo](https://github.com/BlockchainCommons/Gordian) is the place.

[**Wallet Standard Discussions**](https://github.com/BlockchainCommons/AirgappedSigning/discussions). For standards and open-source developers who want to talk about wallet standards, please use the Discussions area of the [Airgapped Signing repo](https://github.com/BlockchainCommons/AirgappedSigning). This is where you can talk about projects like our [LetheKit](https://github.com/BlockchainCommons/bc-lethekit) and command line tools such as [seedtool](https://github.com/BlockchainCommons/bc-seedtool-cli), both of which are intended to testbed wallet technologies, plus the libraries that we've built to support your own deployment of wallet technology such as [bc-bip39](https://github.com/BlockchainCommons/bc-bip39), [bc-slip39](https://github.com/BlockchainCommons/bc-slip39), [bc-shamir](https://github.com/BlockchainCommons/bc-shamir), [Shamir Secret Key Recovery](https://github.com/BlockchainCommons/bc-sskr), [bc-ur](https://github.com/BlockchainCommons/bc-ur), and the [bc-crypto-base](https://github.com/BlockchainCommons/bc-crypto-base). If it's a wallet-focused technology or a more general discussion of wallet standards,discuss it here.

[**Blockchain Commons Discussions**](https://github.com/BlockchainCommons/Community/discussions). For developers, interns, and patrons of Blockchain Commons, please use the discussions area of the [Community repo](https://github.com/BlockchainCommons/Community) to talk about general Blockchain Commons issues, the intern program, or topics other than the [Gordian System](https://github.com/BlockchainCommons/Gordian/discussions) or the [wallet standards](https://github.com/BlockchainCommons/AirgappedSigning/discussions), each of which have their own discussion areas.

### Other Questions & Problems

As an open-source, open-development community, Blockchain Commons does not have the resources to provide direct support of our projects. Please consider the discussions area as a locale where you might get answers to questions. Alternatively, please use this repository's [issues](./issues) feature. Unfortunately, we can not make any promises on response time.

If your company requires support to use our projects, please feel free to contact us directly about options. We may be able to offer you a contract for support from one of our contributors, or we might be able to point you to another entity who can offer the contractual support that you need.

### Credits

The following people directly contributed to this repository. You can add your name here by getting involved. The first step is learning how to contribute from our [CONTRIBUTING.md](./CONTRIBUTING.md) documentation.

| Name              | Role                | Github                                            | Email                                 | GPG Fingerprint                                    |
| ----------------- | ------------------- | ------------------------------------------------- | ------------------------------------- | -------------------------------------------------- |
| Christopher Allen | Principal Architect | [@ChristopherA](https://github.com/ChristopherA) | \<ChristopherA@LifeWithAlacrity.com\> | FDFE 14A5 4ECB 30FC 5D22  74EF F8D3 6C91 3574 05ED |
| Peter Denton      | Project Lead        | [@Fonta1n3](https://github.com/Fonta1n3)          | <[FontaineDenton@gmail.com](mailto:FontaineDenton@gmail.com)> | 1C72 2776 3647 A221 6E02  E539 025E 9AD2 D3AC 0FCA  |

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
