# 🛠 Bitcoin-Standup

*Bitcoin-Standup* is a open source project and a suite of tools that helps users to install a [Bitcoin-Core](https://bitcoin.org/) full-node on a fresh computer or VPS and to add important privacy tools like onion services. It will eventually also support optional Bitcoin-related tools like [Electrum Personal Server](https://github.com/chris-belcher/electrum-personal-server), [C-Lightning](https://github.com/ElementsProject/lightning), [Esplora](https://github.com/Blockstream/esplora), and [BTCPay Server](https://github.com/btcpayserver/btcpayserver) as well as emerging technologies like Bitcoin-based Decentralized Identifiers. *Bitcoin-Standup* strives to provide the community with an easy to use "one-click" set up full-node complete with a purpose built remote app for securely connecting to your node over Tor from anywhere in the world, providing you with a powerful suite of tools.

This tool will also harden and secure your OS to current best practices and will add sufficient system tools to support basic Bitcoin development. After setup, *Bitcoin-Standup* will present a QR code and/or special URI that can be used to securely link your full-node to other devices, such as a remote desktop or a mobile phone using [FullyNoded 2](https://testflight.apple.com/join/OQHyL0a8) or [Fully Noded 1](https://github.com/FontaineDenton/iOS/FullyNoded) on iOS.

## Additional Information

*Bitcoin-Standup* Is currently available for installation on MacOS via an app or on Linux using scripts. Information on how to install and use each of these versions of *Bitcoin-Standup* is found in a separate repository:

1. [MacOS StandUp.app](https://github.com/BlockchainCommons/Bitcoin-StandUp-MacOS) is a personal one-click installer for Bitcoin Core and Tor that will present a QuickConnect QR code that can be used to pair mobile wallets for remote use over Tor V3.
2. [Linux Bitcoin-StandUp-Scripts](https://github.com/BlockchainCommons/Bitcoin-StandUp-Scripts) achieve the same thing as MacOS StandUp, but come in the form of Linux scripts.

This repo contains an overview of features in MacOS StandUp for individual installation instructions for MacOS or Linux, please see the appropriate repos.

### Further Docs

More information about the purpose and design of *Bitcoin-Standup* can be found in the following documents:

1. [Why Run a Full Node?](Docs/Why-Full.md) Why would you want to run a full node in the first place? There are advantages in validation, privacy, security, liquidity, and education.
2. [Quick Connect API](Docs/Quick-Connect-API.md). A description of the current format of the `btcstandup:` protocol, and some questions for the developer community.
3. [Security for Bitcoin-Standup](Docs/Security). Notes on ensuring the security of your *Bitcoin-Standup* node.

### Related Projects

The full node created by *Bitcoin-Standup* can also be interlinked with other projects from Blockchain Commons.

1. [iOS FullyNoded 2](https://github.com/BlockchainCommons/FullyNoded-2) is a state-of-the-art mobile wallet that was made to work with a *Bitcoin-Standup* full node.  You can scan the QuickConnect QR code from *Bitcoin-Standup* and easily create mutli-sig wallets where one key gets stored on your device, one on your node, and one in offline backup.
2. [Learning Bitcoin from the Command Line](https://github.com/ChristopherA/Learning-Bitcoin-from-the-Command-Line) is a tutorial for programming the `bitcoin-cli`, which can be run using a full node such as the one created by *Bitcoin-Standup*.

## Status — Work-in-Progress

*Bitcoin-Standup* is an early **Work-In-Progress**, so that we can prototype, discover additional requirements, and get feedback from the broader Bitcoin-Core Developer Community. ***It has not yet been peer-reviewed or audited. It is not yet ready for production uses. Use at your own risk.***

## Financial Support

*Bitcoin-Standup* is a project of [Blockchain Commons](https://www.blockchaincommons.com/). We are proudly a "not-for-profit" social benefit corporation committed to open source & open development. Our work is funded entirely by donations and collaborative partnerships with people like you. Every contribution will be spent on building open tools, technologies, and techniques that sustain and advance blockchain and internet security infrastructure and promote an open web.

To financially support further development of `$projectname` and other projects, please consider becoming a Patron of Blockchain Commons through ongoing monthly patronage as a [GitHub Sponsor](https://github.com/sponsors/BlockchainCommons); your pledges are currently matched by GitHub, up to $5,000. You can also support Blockchain Commons with bitcoins at our [BTCPay Server](https://btcpay.blockchaincommons.com/).

## Reporting a Vulnerability

To report security issues send an email to ChristopherA@LifeWithAlacrity.com (not for support).

The following keys may be used to communicate sensitive information to developers:

| Name              | Fingerprint                                        |
| ----------------- | -------------------------------------------------- |
| Christopher Allen | FDFE 14A5 4ECB 30FC 5D22  74EF F8D3 6C91 3574 05ED |

You can import a key by running the following command with that individual’s fingerprint: `gpg --recv-keys "<fingerprint>"` Ensure that you put quotes around fingerprints that contain spaces.

## Contributing

We encourage public contributions through issues and pull-requests! Please review [CONTRIBUTING.md](https://github.com/BlockchainCommons/Bitcoin-Standup/blob/master/CONTRIBUTING.md) for details on our development process. All contributions to this repository require a GPG signed [Contributor License Agreement](https://github.com/BlockchainCommons/Bitcoin-Standup/blob/master/CLA.md).

## Copyright & License

This code in this repository is Copyright © 2019 by Blockchain Commons, LLC, and is [licensed](https://github.com/BlockchainCommons/Bitcoin-Standup/blob/master/LICENSE) under the [spdx:BSD-2-Clause Plus Patent License](https://spdx.org/licenses/BSD-2-Clause-Patent.html).

## Maintainers

- Christopher Allen [@ChristopherA](https://github.com/@ChristopherA) \<ChristopherA@LifeWithAlacrity.com\> (lead)
- Peter Denton [@Fonta1n3](https://github.com/Fonta1n3)

## GitHub Codeowners

@ChristopherA
