# 🛠 Bitcoin-Standup

*Bitcoin-Standup* is a open source project and a suite of tools that helps users to install a [Bitcoin-Core](https://bitcoin.org/) full-node on a fresh computer or VPS and to add important privacy tools like onion services. It will eventually also support optional Bitcoin-related tools like [Electrum Personal Server](https://github.com/chris-belcher/electrum-personal-server), [C-Lightning](https://github.com/ElementsProject/lightning), [Esplora](https://github.com/Blockstream/esplora), and [BTCPay Server](https://github.com/btcpayserver/btcpayserver) as well as emerging technologies like Bitcoin-based Decentralized Identifiers. *Bitcoin-Standup* strives to provide the community with an easy to use "one-click" set up full-node complete with a purpose built remote app for securely connecting to your node over Tor from anywhere in the world, providing you with a powerful suite of tools.

This tool will also harden and secure your OS to current best practices and will add sufficient system tools to support basic Bitcoin development. After setup, *Bitcoin-Standup* will present a QR code and/or special URI that can be used to securely link your full-node to other devices, such as a remote desktop or a mobile phone using [FullyNoded 2](https://testflight.apple.com/join/OQHyL0a8) or [Fully Noded 1](https://github.com/FontaineDenton/iOS/FullyNoded) on iOS.

This repo contains a table of contents for various *Standup* projects and features. Please see individual repos and pages for more information.

## MacOs Standup

[MacOS StandUp.app](https://github.com/BlockchainCommons/Bitcoin-StandUp-MacOS) is a personal one-click installer for Bitcoin Core and Tor that will present a QuickConnect QR code that can be used to pair mobile wallets for remote use over Tor V3.

<img src="./Images/0_standup_mac.png" alt="" width="1000"/>

<img src="./Images/1_standup_mac.png" alt="" width="1000"/>

<img src="./Images/3_standup_mac.png" alt="" width="800"/> 

*MacOS Standup* has been developed and tested on "Mojave" and "Catalina", it can be installed via a DMG or an Xcode compilation

## Linux Standup

[Linux Bitcoin-StandUp-Scripts](https://github.com/BlockchainCommons/Bitcoin-StandUp-Scripts) achieve the same thing as MacOS StandUp, but come in the form of Linux scripts.

The easiest-to-use Linux scripts run through the StackScript system at Linode, but you can alternatively use Linux scripts that have been tested with Debian Stretch and Ubuntu 18.04.

## Quick Connect

[Quick Connect API](Docs/Quick-Connect-API.md) defines the spec for a deep link URI and a scannable QR Code. It is used by *Bitcoin-Standup* as well as by several server-side node manufacturers.

<img src="./Images/3_standup_mac.png" alt="" width="800"/> <img src="./Images/scanQuickConnect.PNG" alt="" width="400"/>

## Additional Information

### Further Docs

More information about the purpose and design of *Bitcoin-Standup* can be found in the following documents:

1. [Why Run a Full Node?](Docs/Why-Full.md) Why would you want to run a full node in the first place? There are advantages in validation, privacy, security, liquidity, and education.
3. [Security for Bitcoin-Standup](Docs/Security.md). Notes on ensuring the security of your *Bitcoin-Standup* node.

### Related Projects

The full node created by *Bitcoin-Standup* can also be interlinked with other projects from Blockchain Commons.

1. [iOS FullyNoded 2](https://github.com/BlockchainCommons/FullyNoded-2) is a state-of-the-art mobile wallet that was made to work with a *Bitcoin-Standup* full node.  You can scan the QuickConnect QR code from *Bitcoin-Standup* and easily create mutli-sig wallets where one key gets stored on your device, one on your node, and one in offline backup.
2. [Learning Bitcoin from the Command Line](https://github.com/ChristopherA/Learning-Bitcoin-from-the-Command-Line) is a tutorial for programming the `bitcoin-cli`, which can be run using a full node such as the one created by *Bitcoin-Standup*.

## Financial Support

*Bitcoin-Standup* is a project of [Blockchain Commons](https://www.blockchaincommons.com/). We are proudly a "not-for-profit" social benefit corporation committed to open source & open development. Our work is funded entirely by donations and collaborative partnerships with people like you. Every contribution will be spent on building open tools, technologies, and techniques that sustain and advance blockchain and internet security infrastructure and promote an open web.

To financially support further development of *Bitcoin-Standup* and other projects, please consider becoming a Patron of Blockchain Commons through ongoing monthly patronage as a [GitHub Sponsor](https://github.com/sponsors/BlockchainCommons). You can also support Blockchain Commons with bitcoins at our [BTCPay Server](https://btcpay.blockchaincommons.com/).
