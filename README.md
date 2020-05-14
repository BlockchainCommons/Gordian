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
3. [Security for Bitcoin-Standup](Docs/Security.md). Notes on ensuring the security of your *Bitcoin-Standup* node.

### Related Projects

The full node created by *Bitcoin-Standup* can also be interlinked with other projects from Blockchain Commons.

1. [iOS FullyNoded 2](https://github.com/BlockchainCommons/FullyNoded-2) is a state-of-the-art mobile wallet that was made to work with a *Bitcoin-Standup* full node.  You can scan the QuickConnect QR code from *Bitcoin-Standup* and easily create mutli-sig wallets where one key gets stored on your device, one on your node, and one in offline backup.
2. [Learning Bitcoin from the Command Line](https://github.com/ChristopherA/Learning-Bitcoin-from-the-Command-Line) is a tutorial for programming the `bitcoin-cli`, which can be run using a full node such as the one created by *Bitcoin-Standup*.

## Status — Work-in-Progress

*Bitcoin-Standup* is an early **Work-In-Progress**, so that we can prototype, discover additional requirements, and get feedback from the broader Bitcoin-Core Developer Community. ***It has not yet been peer-reviewed or audited. It is not yet ready for production uses. Use at your own risk.***

## Financial Support

*Bitcoin-Standup* is a project of [Blockchain Commons](https://www.blockchaincommons.com/). We are proudly a "not-for-profit" social benefit corporation committed to open source & open development. Our work is funded entirely by donations and collaborative partnerships with people like you. Every contribution will be spent on building open tools, technologies, and techniques that sustain and advance blockchain and internet security infrastructure and promote an open web.

To financially support further development of *Bitcoin-Standup* and other projects, please consider becoming a Patron of Blockchain Commons through ongoing monthly patronage as a [GitHub Sponsor](https://github.com/sponsors/BlockchainCommons). You can also support Blockchain Commons with bitcoins at our [BTCPay Server](https://btcpay.blockchaincommons.com/).

## Contributing

We encourage public contributions through issues and pull requests! Please review [CONTRIBUTING.md](./CONTRIBUTING.md) for details on our development process. All contributions to this repository require a GPG signed [Contributor License Agreement](./CLA.md).

### Questions & Support

As an open-source, open-development community, Blockchain Commons does not have the resources to provide direct support of our projects. If you have questions or problems, please use this repository's [issues](./issues) feature. Unfortunately, we can not make any promises on response time.

If your company requires support to use our projects, please feel free to contact us directly about options. We may be able to offer you a contract for support from one of our contributors, or we might be able to point you to another entity who can offer the contractual support that you need.

### Credits

The following people directly contributed to this repository. You can add your name here by getting involved. The first step is learning how to contribute from our [CONTRIBUTING.md](./CONTRIBUTING.md) documentation.

| Name              | Role                | Github                                            | Email                                                       | GPG Fingerprint                                    |
| ----------------- | ------------------- | ------------------------------------------------- | ----------------------------------------------------------- | -------------------------------------------------- |
| Christopher Allen | Principal Architect | [@ChristopherA](https://github.com/@ChristopherA) | \<ChristopherA@LifeWithAlacrity.com\>                       | FDFE 14A5 4ECB 30FC 5D22  74EF F8D3 6C91 3574 05ED |
| Peter Denton      | Project Lead        | [@Fonta1n3](https://github.com/Fonta1n3)          | <[fonta1n3@protonmail.com](mailto:fonta1n3@protonmail.com)> | 3B37 97FA 0AE8 4BE5 B440 6591 8564 01D7 121C 32FC  |

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

## Reporting a Vulnerability

To report security issues send an email to ChristopherA@LifeWithAlacrity.com (not for support).

The following keys may be used to communicate sensitive information to developers:

| Name              | Fingerprint                                        |
| ----------------- | -------------------------------------------------- |
| Christopher Allen | FDFE 14A5 4ECB 30FC 5D22  74EF F8D3 6C91 3574 05ED |

You can import a key by running the following command with that individual’s fingerprint: `gpg --recv-keys "<fingerprint>"` Ensure that you put quotes around fingerprints that contain spaces.
