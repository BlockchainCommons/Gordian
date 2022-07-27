## Overview: The Gordian Apps

The Gordian Reference Apps demonstrate the usage of the Gordian Reference Libraries to fulfill the Gordian Principles. They may also be combined into an ecosystem that demonstrates the Gordian Marco-Architecture and its theory of functional partition:

![](https://raw.githubusercontent.com/BlockchainCommons/Gordian/master/Images/appmap.png)

The Gordian Reference Apps are all linked by airgaps and torgaps, to demonstrate how privacy and security can be maximized while still maintaining a very usable ecosystem. However, transport specifics become less important when using the Gordian Architecture as a whole, and so in a real-life ecosystem, apps may be normally Networked.

### Networked Services

_Gordian Reference Apps can be fully networked if services are correctly partitioned:_

**[Gordian Server](https://github.com/BlockchainCommons/GordianServer-macOS).**<br>
**Roles:** Cosigner, Network Server, Seed Generator, Seed Vault (partial)

A full-node server, created by Blockchain Commons' Bitcoin Standup scripts, running on a Mac or Linux machine. It connects to Gordian Wallet via a _torgap_. In conjunction with Gordian Wallets, its transactions are signed with a 2-of-3 multi-sig, with one key secured by Gordian Wallet, one key used by Gordian Server, and one key saved offline.

### Airgapped Apps

_Closely held devices allow users to protect their confidential data with Airgaps. Gordian Seed Tool is our prime Reference App for demonstrating this functionality, while LetheKit offers another style of secure seed generation:_

**[Gordian Seed Tool](https://github.com/BlockchainCommons/GordianSeedTool-iOS)**<br>
**Roles:** Cosigner, Seed Generator, Seed Vault

A cryptographic seed manager for your iOS device. Allows the maintenance of seeds in a closely held device and the easy use of those seeds through `crypto-requests` for either specific keys or for the signature of PSBTs. This is our most developed app, and the one that best displays a variety of ways to achieve the Gordian Principles.

**[LetheKit](https://github.com/BlockchainCommons/bc-lethekit)**<br>
**Roles:** Seed Generator

A do-it-yourself hardware kit that can be used to generate secure seeds for Bitcoin. It shares functionality with Seed Tool, but functions as fully airgapped hardware rather than software on a closely held but potentially connected device. It's also more tightly partitioned, focusing exclusively on seed generation.

_We have previously offered other Reference Apps that also demonstrated the Gordian Principles with airgapped transport, but which are now deprecated:_

**[Gordian Cosigner](https://github.com/BlockchainCommons/GordianSigner-Catalyst).** <br>
**Roles:** Cosigner, Seed Vault

An offline PSBT and multi-sig signer. You can import keys and read PSBTs via QR code. After you sign the PSBT, you can then transfer it back to your Wallet across an airgap, which will coordinate the broadcast of the transaction. The current iteration supports Seed Generation, but the plan was to remove it to better partition the services. This app has never advanced to a full release, in large part because its functionality, and thus its reference examples, have been superceded by Seed Tool.

**[Gordian QRTool](https://github.com/BlockchainCommons/GordianQRTool-iOS)** <br>
**Roles:** Seed Vault

A more general data storage tool that displays how the Gordian Principles can apply to the protection of a variety of digital data that has been encoded as QRs. It also shows the tightest partitioning, allowing secure seed storage and nothing else. This is also a fully released app.


**[Gordian Wallet](https://github.com/BlockchainCommons/GordianWallet-iOS)** <br>
**Roles:** Cosigner, Policy Coordinator, Seed Vault (partial), Transaction Coordinator

Gordian Wallet is a mobile Bitcoin wallet that supports sophisticated [#SmartCustody](https://www.smartcustody.com/) features such as multi-sigs and PSBTs. It acts as: a policy coordinator, determining how you set up your accounts; a transaction coordinator, creating transactions based on your policies; and a broadcast coordinator, determining how to send our your transactions. Note that the Seed role of Gordian Wallet is limited because its multisig design shares Seeds with the linked [Gordian Server](https://github.com/BlockchainCommons/GordianServer-macOS).

### Microservices

_Blockchain Commons microservices demonstrate how services can be built for very specific functionality within the Gordian Architecture._

**[SpotBit](https://github.com/BlockchainCommons/spotbit)** <br>
**Roles:** Pricing Calculator

A price-info microservice, used by Gordian Wallet (and potentially other paritioned services) through a _torgap_. Spotbit can be used to aggregate Bitcoin pricing information from a variety of exchanges and to store that data.
