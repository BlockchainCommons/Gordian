# CKM (Collaborative Key Management) Overview

## What is CKM?

Collaborative Key Management (CKM) is a Blockchain Commons architecture for generating, storing, and using keys in a collaborative way, where several different devices or entities come together and use their individual secrets to generate and regenerate keys solely for the brief instant that they're needed. Our roadmap target for deployment of solutions leveraging this CKM architecture is 2023-24.

CKM expands upon [Collaborative Seed Recovery (CSR)](/CSR/README.md), our existing architecture (begun in 2019 with SSKR), which supports the resilience and recovery of seeds (not keys) using well-reviewed cryptographic code and which is thus deployable in 2022. 

One of the main purposes of releasing this document at this time is to create a touchstone for CSR work, so that it's appropriately future-proofed against prospective CKM development.

## What Problems Does CKM Solve?

Current methodologies for protecting digital assets require that you either give all of the keys underlying your assets to a third party, allowing an exchange such as Binance or Coinbase to hold your coins; or else take full responsibility for personally holding those keys yourself in a self-sovereign way, using desktop apps such as Electrum or Sparrow, browser-based apps like Metamask, hardware such as Ledger or Passport, or physical offline approaches such as inscribing seed words into metal plates.

All of these current methods have flaws. 

* They're all threatened by **Single Points of Compromise (SPOCs)** where someone can steal your key. Third parties are particularly vulnerable because they're big targets, such as when the Poly Network had [$600M in cryptocurrency stolen by hackers](https://www.coindesk.com/markets/2021/08/10/cross-chain-defi-site-poly-network-hacked-hundreds-of-millions-potentially-lost/). 
* They're all threatened by **Single Points of Failure (SPOFs)** where a key is lost. Personal holdings are particularly vulnerable because an invidual holder might not have the expertise or means to protect their keys, such that [forgetting a PIN for a hardware wallet can lead to the loss of its funds](https://www.wired.com/story/i-forgot-my-pin-an-epic-tale-of-losing-dollar30000-in-bitcoin/). 
* They're all threatened by **Single Points of Denial (SPODs)**, where centralized servers can refuse to process transactions. This is particularly a concern when working with a third party who could arbitrarily decide to block anything a crypto-owner is doing. Canada tried to exert financial censorship of this type over crypto-wallets associated with the ["Freedom" Convoy](https://www.coindesk.com/policy/2022/02/16/canada-sanctions-34-crypto-wallets-tied-to-trucker-freedom-convoy/).

The solution offered by CKM is that we secure each other. Using Collaborative Key Management, we can spread out the responsibility of protecting the keys underlying digital assets among a variety of parties, each inspired by self-interest, by community spirit, or by a desire to protect the assets themselves. Because no one party ever has access to all the key material, we remove SPOFs, SPOCs, and SPODs, creating a better and safer way to access the digital world.

CKM improves upon self-custody methods by better securing against SPOFs, and offers even larger protections compared to third-party custody solutions:

| | CKM |  CSR | Self Custody | Third-party Custody |
| --- | --- | -------- | -------- | -------- |
| **SPOF** | Asset loss only with multiple server failures. | Asset (Seed) loss only with multiple server failures. | Asset loss is top failure condition. | Asset loss is lesser failure condition  thanks to professional protections. |
| **SPOC** | Key compromise only with multiple server compromises. Key doesn't exist until used. | Recovery compromise only after multiple server compromises. _(Does not protect against key compromise.)_ | Key compromise is lesser failure condition thanks to being smaller target. | System compromise of key storage is top failure condition. |
| **SPOD** | Ease of variant key creation. Denial only with multiple server collusion.  | Denial only with multiple server collusion. | Denial only with global collusion. | Denial if custodian or third party blocks transactions. |

For other problems that CKM solves, which go beyond just protecting keys, see **Appendix I**.

## Why Is CKM Important?

Digital assets are an emerging asset class in the 21st century economy. Unlike physical assets, they require a secure digital custody solution. However, in order to protect digital assets, we need someone in the physical world who will protect the keys underlying the digital assets — acting as an interface to the digital landscape.

CKM resolves the current problems of centralization and of self-custody solutions by providing a new solution that is not endangered by the lossage possibilities of self-custody or the censorship and compromise dangers of third-party custody. It also improves on CSR by creating a system much less prone to compromise and incrementally less vulnerable to censorship.

## Why Now for CKM?

CKM has been enabled by the incorporation of new cryptography into Bitcoin, in particular the availabilty of Schnorr after the Taproot softfork. For the first time, thanks to some special characteristics of Bitcoin's secp256k1 elliptic curve, we can make use of the special advantages of Schnorr, such as signature aggregation and adapter signatures and support the use of quorum threshold-signature schemes such as FROST to leverage SMPC (Secure Multi Party Computation).

Each of these new technologies have specific advantages that can be applied to a CKM system:
* Schnorr allows for smaller multisigs than current technologies, and also improves privacy by not revealing who signed a transaction (nor even if it was a single signature or a multisignature).
* Taproot fully integrates Schnorr signatures into Bitcoin, improves the privacy of Bitcoin scripts, and allows for more complex scripting.
* SMPC allows for keys to be collaboratively generated and used such that no individual ever sees the full key.

By improving the use of multisigs and of Bitcoin scripts, and by allowing for SMPC to generate and use keys together, we can engage in wide-scale collaboration on the Bitcoin blockchain, which can then be extended to other digital-asset classes. 

## What is the Vision/Goal of CKM?

The ultimate vision of CKM is to create a collaborative infastructure that is sufficiently robust to largely eradicate the loss of assets due to the loss of critical keys and sufficiently secure and well-administered to largely eliminate the loss of assets due to the theft of keys. Thie infrastructure is intended to work even with blockchains such as Ethereum that have technological or cultural obstacles that otherwise have prevented the deployment of these type of safeguards.

The obstacles on Ethereum are large enough that current methodologies may not be salvageable. This is especially true for the architecture of Metamask-style software wallets, which are built on a fundamentally insecure foundation as web extensions that makes overuse of a single key. The CKM methodology creates a new way to secure individual keys of this sort. 

Even on the Bitcoin blockchain, which has more possibilities for collaborative key usage, the [process of doing so](https://github.com/BlockchainCommons/SmartCustody/blob/master/Docs/Scenario-Multisig.md) is sufficiently complex that it's beyond the average user. CKM endeavors to resolve these issues by refactoring the fundamental thought processes underlying the management of keys used by cryptography and by making more complex methodologies easy to use.

The ultimate goal of CKM is to bring better key management solutions to enough of the digital asset space to make it a potential option for any user. We believe that embedding CKM in as little as 15% of digital wallets will create a tipping point that will ensure that other wallet manufacturers cannot afford to ignore it.

## What is the Business Model for CKM?

CKM is of immediate interest to current holders of keys for digital assets ("key managers") because it changes their responsibility from holding keys to holding fractional keys ("shares"). 

This allows them to:

* Reduce cost of securing keys, eliminating need for custom storage solutions.
* Reduce or remove liability associated with storage of keys.
* Plausibly deny control of keys.

Obviously, this requires new key managers to appear to hold other fractions of these keys. We feel that two fundamental goals will bootstrap this initial community:

* Current key managers may exchange responsibilities with each other, each agreeing to secure a fractional key for all clients of the other. This creates a selling point for the key managers because they can advertise an automated experience where CKM support is guaranteed. (It should also be a tried-and-true method when we roll out CKM, because it is already the intended methodology for CSR ramp-up.)
* Interested third-parties may offer fractional key management to fulfill a larger mission. Museums may desire to protect digital artwork; universities may want to improve innovation; civil-rights organizations may be interested in ensuring the self-sovereignty of internet users; and the open-source community has proven that they will take on tasks of this sort for the public good. 

Afterward, we expect to see the emergence of commercial options:

* Commercial interests will likely charge for fractional key management by value-adding other services that improve upon the deployments offered by existing key managers and interested third parties. Because of the long tail guaranteed by the quickly exploding digital asset category, fees can be low while still returning high grosses, and payments of low amounts can be simply made through any cryptocurrencies being protected.

Key managers will ultimately be part of a larger infrastructure, which may also include storage providers (see "Gordian Envelopes" in ***Appendix III***), specialized key managers such as insured fiduciaries, and servers that can look up, rate, and reference providers. Most of these additions to the infrastructure will appear as value-adds from companies interested in charging for fractional key management by offering more than the initial public or partnered services that appear.

The network effect between these different parties should also accelerate the adoption of CKM.

### What Roles Do Various Parties Play?

Various parties will likely take on the following rules in the CKM infrastructure.

**Hardware Wallet Manufacturers**
* ***Examples:*** Foundation Devices, Keystone
* ***Current Problems:*** Lack of differentiation in market; devices that are SPOFs; requirement of individual integration from software wallets.
* ***Solutions:*** Incorporate Gordian Envelope and CKM specifications.
 
By supporting the Gordian Envelope specifications and participating in collaborative key generation, usage, and recovery, hardware wallet will future-proof their products because they will be offering next-generation key resilience. They'll also open up their hardware devices to a multitude of software wallets without the need for individual integration. Finally, they can advertise their meeting high standards for key resilience and security.

**Chip Manufacturers**

* ***Examples:*** CrossBar, Tropic Square
* ***Current Problems:*** Not in crypto market, barriers to entry due to vast numbers of hardware and software solutions.
* ***Solutions:*** Incorporate specifications desired by crypto market and usable in an interoperable way.

There is a large void in silicon support for the cryptographic market. The first chip manufacturer into that market will be able to quickly multiply its success with this newly opened market. The biggest problem with entering the market is integrating with a large number of different hardware and software solutions. Interoperable specifications such as `crypto-envelope` are the way to do so, without having to craft integrations for each manufacturer. CKM also offers strong future-proofing for any chip manufacturer, ensuring that they will remain very relevant as the crypto-market changes and grows.

(We have already begun work with Chip Manufacturers through our [Silicon Salons](https://www.siliconsalon.info/).)

**Software Wallet Manufacturers**

* ***Examples:*** Sparrow Wallet
* ***Current Problems:*** Wallets that are vulnerable SPOFs or alternatively multisigs that require multiple linked devices and suffer from The NASCAR Problem (having to individually support different vendors).
* ***Solutions:*** Incorporate specifications that support interoperable, networked multisigs.
 
The current state of the art for software-wallet manufacturers is using them to create single-sig wallets or to link to single-sig hardware devices — which is horribly vulnerable. If the device containing the keys is compromised or lost, any digital assets are lost.

The next generation of software wallets, which are now appearing, offer support for multisigs, but they do so by requiring individual integrations to many different hardware and software designs. The user then has to juggle multiple signing devices to access his funds.

By integrating CKM, software wallet manufacturers can have access to all hardware wallet manufacturers who support inteoperable specifications such as Gordian Envelope and they can provide better user experiences where a user usually will manage at most one hardware signing device.

**Galleries**

* ***Examples:*** Feral File
* ***Current Problems:*** Liability from holding keys for NFTs, potentially worsened by being a SPOF.
* ***Solutions:*** Give out shares of keys to CKM servers, potentially holding on to one of those shares themselves.

Online galleries can reduce their liability by handing off custodianship of NFTs or other digital assets to other key managers via partnered exchanges or through user-selected menus of free or paid services. They might hold one fraction of the keys themselves, or they might get out of the key business entirely.

**Museums**

* ***Examples:*** MOMA
* ***Current Problems:*** Poor integration with digital world of art, no way to preserve digital art, potential of loss for digital art that they hold as a SPOF.
* ***Solutions:*** Become a CKM server, share CKM responsibilities

Museums can improve their integration with digital art by becoming a CKM server. This can allow them to better preserve their own digital art and also to better preserve other digital art in the world, which they may not have a personal stake in, but which they may wish to protect as part of their overall mission. They may trade-off with other CKM servers to offer in-kind services, they may charge for CKM services especially extra-value services such as the storage of larger Gordian Envelopes, or they may consider the costs part of their core mission.

**Rights Organizations**

* ***Examples:*** EFF
* ***Current Problems:*** Peoples' keys, and thus their assets and identities, are often held by centralized corporations who might violate their users rights or allow government entities to do so.
* ***Solutions:*** Become a CKM Server, support the CKM specs.
 
Rights organizations will be interested in hosting CKM servers because of the focus on self-sovereign ownership of digital assets that is implict with CKM, as it ensures rights remain with people.

**Web Services**

* ***Examples:*** New Companies
* ***Current Problems:*** Want to enter the market with a clearly differentiated and value-add product and to make money selling it.
* ***Solutions:*** Become a CKM Server with value-add services.

New companies will see value in joining the growing CKM infrastructure because of the ability to value-add services such as secure storage of Gordian Envelopes or look-up or rating services. They will offer these in addition to taking over key-management responsibility from existing servers such as galleries, museums, or rights organizations. Users will choose them because they feel their value adds are worth a small regular fee. (LastPass may be a good example, as it offers a simple security service, it does so for a yearly charge of $3 a month, and it benefits from the long-tail of users needing this service.)

## Conclusion

CKM is a new architecture that solves fundamental problems in the current management of the quickly growing class of digital assets by allowing us all to secure each other. It does so by creating a web of key managers and other services, each driven by individual interests and goals. By building the fundamentals of this architecture and deploying its initial wallets, we believe we can quickly hit a tipping point where it becomes the dominant paradigm for the industry. 

## Appendix I: Problems & CKM Solution

Obviously, the collaborative generation and usage of keys solves a number of problems with SPOFs and SPOCs. Following are some deeper solutions offered by the system.

**Problem #1: All Keys Are Easy to Lose**

Losing a fragile master key is one of the biggest problems with cryptographic storage, resulting in the loss of digital currencies and more; this can be even more problematic if a user dies or becomes incapacitated, as many digital assets will never pass down to heirs.

___Solution: Improved Resilience for Key Storage___

CKM's `crypto-envelopes` are stored using a `permit` system that allows different keys to be used in different ways to unlock the same data, further improving resilience by creating multiple ways to access the information

**Problem #2: Ethereum Keys Are Especially Vulnerable**

Keys on Ethereum (and other state-based blockchains such as Tezos) are more subject to attack and lossage than most because of the high costs for multisigs on the blockchain and because of the cultural use of master keys for everything.

___Solution: Ethereum Smart Custody___

CKM's collaborative key usage offers an alternative to traditional multisigs, allowing for improved key resilience and security, even for accounts that are fundamentally single-sig.

**Problem #3: Transactions Are Correlatable**

Digital transactions are often correlatable, allowing for the collection of ever larger sets of information, particularly when DIDs and (some versions of) Verifiable Credentials are involved. This can turn master keys and seeds into honeypots that become targets for criminals.

___Solution: Correlation Protections___

The CKM system reduces correlation at several points, beginning with its core CKM functions, which can collaboratively generate many different keys, all built upon the new privacy options available through Schnorr signatures. CKM also allows many objects to be identified by salted hashes that are never reused and supports SCIDs (see below) as a new sort of digital identifier that can be used offline and that allows for minimal disclosure.
 
**Problem #4: Metadata is Hard to Store Securely**

Current secret-sharing schemes have low upper limits for how much data can be stored. This makes the storage of larger amounts of data difficult if it needs to be stored in a way that's secure and resilient — especially if decentralized storage is preferred.

___Solution: Secure Metadata Storage___

CKM's methodology for storing additional data in a `crypto-envelope` allows for the storage of unbounded amounts of secret material, meeting the needs of secure, collaborative, and decentralized secret storage.

**Problem #5: Existing DIDs Are Not Rotatable or Revokable**

Existing methodologies for Decentralized Identifiers (DIDs) such as `did:key` are not rotatable or revokable by the user, creating a potential liability for anyone helping to control the DIDs.

___Solution: User-Controlled Identifiers___

The CKM system includes Self-Certifying Identifiers (SCIDs), which are derived from the public key it generates and which are thus not locked to a specific blockchain. These SCIDs are rotatable and revokable, putting their control entirely in the hands of the user.

# Appendix II: An Overview of CKM Principles

The prime goal of the CKM architecture is to protect digital assets with no Single Points of Failure (SPOFs), no Single Points of Compromise (SPOCs), and no Single Points of Denial (SPODs). 

The principles of the CKM architecture are all in furtherance of this goal:

1. **Multi-Key First.**
   * Keys can be generated via _Collaborative Key Generation_.
   * Keys can be restored via _Collaborative Key Recovery_.
   * Keys can be used via _Collaborative Key Signing_.
   * Collaborative key managers do not have to be people, but can also be organizations, hardware devices, computers, or other entities.
1. **Forward-Looking Design.**
   * The architecture must be proactively built for security & resilience.
   * Mature emerging technologies should be used when appropriate.
   * The design should be future-proofed, so that more functionality and new technologies can be integrated without changing the architecture.
1. **No Gods, No Masters.**
   * There must be no single source of authority in the architecture.
   * There must be no option for vendor lock-in within the system.
1. **Privacy Protection.**
   * The system does not reveal if any signature is from an individual or a group.
   * The system does not reveal who within a group has signed.
   * Any information disclosure from the system is minimal for what is required.
   * Any information evaulation within the system is redacted with minimal disclosure of only what is required for the business purpose or to minimize risk.
1. **An Open System.**
   * Code for the system must be open source.
   * Work on the system must be open development & must be transparent.
   * Real opportunity must be available for public input on the system's design.
   * Approaches and security decisions must be codified and documented.
1. **A Referenced System.**
   * Specifications within the system must be available as reference docs.
   * Specifications within the system must be available as reference libraries.
   * The system must be security reviewed and the review must be open & transparent.

## Appendix III: An Overview of CKM Architecture

The CKM architecture is built upon the following major elements:

* **Collaborative Key Generation.** A system for generating keys collaboratively.
* **Collaborative Key Recovery.** A system for recovering lost keys collaboratively.
* **Crypto-Envelope.** A data-type that can store secrets such as keys and other data.
* **Permits.** An authentication system that allows multiple methods for opening those envelopes.
* **Scripting.** A permit-scripting system to support more complex authentication in the future.
* **SCIDs.** A DID-like identifier integrated with CKMs.

The Crypto-Envelopes and derivative systems are already present in [CSR](/CSR/README.md), but will continue to expand and mature as CSR is completed and development begins on CKM.

The following offers a broad overview of these architectural points:

**Collaborative Key Generation.** This is the fundamental linchpin of CKM. When keys are collaboratively generated, no one person is responsible for creating the entropy underlying the keys. Further, the key may never exist in its collected form until the instant it is used. [FROST](https://crysp.uwaterloo.ca/software/frost/) and [Torus](https://tor.us/) both demonstrate practical methods for collaborative key generation. In CKM, the core concept is that entities holding secrets will generate a variety of keys as they are required. Ideally, this is managed by an [SMPC system](https://en.wikipedia.org/wiki/Secure_multi-party_computation), such that any key is generated (or regenerated) from secrets held by different machines in the instant it's required. However, reconstruction of keys from shares may be required for legacy CSR systems or in the case of emergencies.

**Collaborative Key Recovery.** A sharding system allows shares of a key to be stored without the full key existing anywhere. Shamir's Secret Sharing is the traditional sharding system, but [Verifiable Secret Sharing (VSS)](https://ieeexplore.ieee.org/document/4568297) improves upon Shamir by allowing the ability to verify that someone holds a share without reconstructing the key. A VSS variation used by FROST will be incorporated as a second option for sharding in [SSKR](https://github.com/BlockchainCommons/bc-sskr) in order to support this functionality. Use of a Collaborative Key Rescovery System is somewhat of a legacy for CKM, but it's a fundamental step between CSR and SKM development.

**Crypto-Envelope.** A second linchpin of the CKM system is the `crypto-envelope` specficiation, which stores data as CBOR and which is potentially encrypted, with the encryption unlockable using a permit system. The `crypto-envelope` will often hold cryptocurrency keys for legacy CSR systems and/or metadata. (Keys for full CKM systems may instead be spontaneously generated or regenerated by the Collaborative Key Generation system.)

**Permits.** Crypto-envelopes can be entirely unencrypted, but more often they'll be locked with a combination of symmetric (currently [ChaCha-Poly](https://pycryptodome.readthedocs.io/en/latest/src/cipher/chacha20_poly1305.html)) and asymmetric public & private keys generated by the aforementioned collaborative methods. Theses keys can then be regenerated from an SMPC system, held as shares in multiple copies of the envelope, hinted at by a public keys, or linked (or not) to the envelope in some other manner.

**Scripting.** The permit system is a self-describing authentication system, where a script, potentially with secret information, is used to unlock the envelope. The first iteration will just support standardized scripting methodologies, such as the aforementioned regenerated private key, sharded key, and keypair options. However, future versions could allow for entirely arbitrary scripts.

**SCIDs.** The third major element of the CKM system is the ability to create self-certifying identifiers (SCIDs), which are built off of public keys (and the related scripting information) and which allow the creation of a source of trust for material stored in a `crypto-envelope`. SCIDs are by default offline, but keys appropriate to a blockchain, commitments to a blockchain, and proofs for a blockchain can be derived if needs warrant it. Some ideas are inherited from [KERI](https://keri.one/), which offered an example of some of this functionality, but with some limitations.

### Legacy CSR Architectural Use Cases

_The following use case focus on legacy approaches that are rooted in CSR: keys are usually generated and then stored by traditional means, with additional security offered by CKM._

**#1. Digital Union.** Connell has NFTs on Bitmark, Tezos, and Ethereum that he wishes to unite. He brings together their keys in a single `crypto-envelope` which he stores with UCLA and SF-MOMA as key managers. He can now feel confident that he won't lose them even if he loses access to his own copy of the envelope. [encryption.]

**#2. Liability Insurance.** Ned's Nifty NFT Co. holds custody of its customers' NFTs, which means that a single security breach could cause immense loss. Ned reduces his liability by moving all of his customers over to CKM. Though he still holds one `crypto-envelope` for them, it's not enough to cause loss, since another `crypto-envelope` would be required, with his 2 of 3 VSS setup. [2-of-3 sharding.]

_Note that though this use case imagines a simple 2-of-3 setup, it is more likely that sophisticated quorums will be used, with a mix of hardware, social, and networked shared keys, to meet the needs of the user._

**#3. Monkey Business.** Bruce has a very expensive Bored Ape NFT. He secures it with a master key spun off of a seed he keeps in a `crypto-envelope`. He keeps other NFTs on other keys generated by that seed, which prevents them from being correlated, which might otherwise make his entire collection, and even his cryptocurrencies, a target. [multiple key generation.]

**#4. Identity Insurance.** Vince has used his SCID as the source of trust for an NFT art business. When Ned's Nifty NFT Co. has a security breach, Vince realizes that either of his other `crypto-envelopes` now represents a SPOC for his system, so resets his use of the CKM system with new keys. In the process, he also needs to rotate his SCID. [key rotation, SCID.]

### Full Architecture Example: Legacy CSR System

_The following offers a more precise example of the extent of a legacy CSR system, where keys are generated outside of the system and then secured by CKM._

* Bob owns an Ethereum key that holds considerable value, including several NFTs of historic significance.
* Bob also holds a Tezos key with additional NFTs.
* Bob places those keys as well as related metadata as the payload of a `crypto-envelope`.
* Bob collaboratively generates a new key with the aid of Feral File and the MOMA.
* The private key of the key pair is used to lock the envelope holding Bob's keys and data.
* The public key of the key pair is signed by the private key to generate a SCID. 
* The key is sharded into three parts using VSS, any two of which can reconstruct the envelope's permit key.
   * For a more modern system, the individual systems would maintain their secrets to regenerate the key whenever was necessary using SMPC .
* Three `crypto-envelopes` are created, each containing the payload data as well as one of the three VSS shares. They are held by Bob, by Feral File, and by MOMA. 
* Any two `crypto-envelopes` can be brought together to restore the permit key and thus unlock the payload containing the Ethereum key, the Tezos key, and the metadata. This is done whenever Bob wishes to manipulate his digital assets.
* If one `crypto-envelope` is lost or stolen, there is no immediate threat to Bob's holdings, dramatically reducing liability for Feral File and MOMA as key holders. However, Bob should obviously rotate his data into a new `crypto-envelope` with a newly generated key if that occurs, destroying all old shares afterward.
* Bob uses his SCID to make verifiable claims that he is the owner of the artwork.

### Full Architecture Example: Full CKM System

_The following offers a different precise example that is entirely rooted in CKM._

* Bob prepares an address for storing his NFTs by activating a Collaborative Key Generation system.
* Bob chooses three SMPC Systems to generate his keys: his home system, Feral File, and Nifty NFT. The latter two have an in-kind agreement. Since Bob is working with Feral File, that means he gets the Nifty NFT server for free and knows that Feral File considers them reliable.
* The three servers use their individual secrets to generate a Feral File key. Bob moves his Feral File NFTs there.
* Bob later decides to move an NFT across Feral FIle's Ethereum Bridge. The three servers again use their individual secrets and this time generate an Ethereum key. Bob then moves one Feral File NFT across the Bridge to that new address.
* Notably, none of the servers has the full secret underlying the keys. In fact, since all that's happened to date is the transferring of NFTs to addresses, nothing but a public key has even been generated: the private key has never been held by any individual server on the internet, creating powerful proof against compromise.
* As he grows increasingly confident with the system, Bob generates other keys, for Tezos, for Signal, for the signing of Apple Apps, and for other purposes. 
* Bob also stores data in `crypto-envelopes`, with the keys again generated by the Collaborative Key Generation system. Bob keeps the only copies of these, but considers going to a value-add NFT service such as Vicki's Vault to ensure they're backed up too. Maybe in the future, depending on what he needs to store.
* When Bob upgrades his computer, he manages to lose the secret held by his home machine because it was specially protected and so needed to be migrated by hand. (He forgot to do so.) No problem, his keys can be generated by any two of the three servers.
* With just two key-generating secrets left, Bob is now vulnerable to SPOFs. He thus has his new home computer work with the Feral File and Nifty NFT servers to generate a series of new keys. He then migrates his various assets and services to the new keys he's created.


