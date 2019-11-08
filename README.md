# 🛠 Bitcoin-Standup

> *Bitcoin-Standup* is a open source project and a suite of tools that helps users to install a [Bitcoin-Core](https://bitcoin.org/) full-node on a fresh computer or VPS and to add important privacy tools like onion services and eventually optional Bitcoin-related tools like [Electrum Personal Server](https://github.com/chris-belcher/electrum-personal-server), [C-Lightning](https://github.com/ElementsProject/lightning), [Esplora](https://github.com/Blockstream/esplora), [BTCPay Server](https://github.com/btcpayserver/btcpayserver), etc., as well as emerging technologies like Bitcoin-based Decentralized Identifiers.
>
> This tool will also harden and secure your OS to current best practices, as well as adding sufficient system tools to support basic Bitcoin development. After setup, *Bitcoin-Standup* will present a QR code and/or special URI that can be used to securely link your full-node to other devices, such as your mobile phone (for instance using [Fully Noded](https://github.com/FontaineDenton/FullyNoded) on iOS) or a remote desktop.
>
> Once installed and fully synced, a *Bitcoin-Standup* full node can also be used with developer education courses like [Learning Bitcoin from the Command Line](https://github.com/ChristopherA/Learning-Bitcoin-from-the-Command-Line).

### Official Links

* GitHub Repository: https://github.com/BlockchainCommons/Bitcoin-Standup

## Table of Contents

- [Status](#status)
  - [Disclaimer](#disclaimer)
- [Background](#background)
- [Financial Support](#financial-support)
- [Install](#install)
  - [macOS Install](#macos-install)
  - [Linode and Debian Linux Install](linode-and-debian-linux-install)
- [API](#api)
  - [Quick Connect URL using btcstandup](#quick-connect-url-using-btcstandup)
- [Security](#security)
- [Maintainers](#maintainers)
- [Contributing](#contributing)
- [License](#license)

## Status

This project is an early **Work-In-Progress**, so that we can prototype, discover additional requirements, and get feedback from the broader Bitcoin-Core Developer Community. ***It has not yet been peer-reviewed or audited. It is not yet ready for production uses. Use at your own risk.***

### Disclaimer

*The information and files included in this repository are intended to inform a set of best practices. It may not address risks specific to your situation, and if it does not, you should modify appropriately. While this information may inform best practices, there is no guarantee that following this advice will sufficiently ensure the security of your digital assets. In addition, this information is only a window on best practices at a specific moment in time. Be aware that the Bitcoin and blockchain ecosystems may have evolved, and the risk assessments of specific solutions may have changed since the publication of this document. In other words: be cautious, be careful, and be aware of the current Bitcoin and blockchain landscape before you use this information.*

## Background

The most important reason to operate a Bitcoin full node is validation. With a full node, Bitcoin users can check whether transactions are valid according to all of Bitcoin's rules. Users can verify that any bitcoins they receive are legitimately mined, correctly signed, and more. This is what makes Bitcoin a trustless solution. 

(TODO: Rewrite this paragraph, add other basic reasons why having your own full node rather than relying on others is powerful.)

## Financial Support

*Bitcoin-Standup* is a project of [Blockchain Commons, LLC](https://www.blockchaincommons.com/) a “not-for-profit” benefit corporation founded with the goal of supporting blockchain infrastructure and the broader security industry through cryptographic research, cryptographic & privacy protocol implementations, architecture & code reviews, industry standards, and documentation.

To financially support further development of *Bitcoin-Standup*, please consider becoming Patron of Blockchain Commons by contributing Bitcoin at our [BTCPay Server](https://btcpay.blockchaincommons.com/) or through ongoing fiat patronage by becoming a [Github Sponsor](https://github.com/sponsors/ChristopherA/) or by clicking on the ❤️ above.

If you are a software developer you can join us by offering issues and pull requests in our [Bitcoin-Standup GitHub](https://github.com/BlockchainCommons/Bitcoin-Standup) or with other projects located in the [Blockchain Commons Community GitHub](https://github.com/BlockchainCommons/).

## Install

**NOTE:** *At this time Bitcoin-Standup only supports installation on macOS Mojave or Catalina. Future versions will include installation on Debian Linux, Linode, Digital Ocean, etc.*

### macOS Install

#### What does it do?

The application *Bitcoin Standup.app* currently installs, configures, and launches `tor stable v0.4.1.6` and `bitcoin-qt v0.19.0`. The app is under development and as it stands will install and configure a Bitcoin Core full node.

Once the app has completely installed and launched Bitcoin, it will present a *Quick Connect QR code* which can be used to securely link your full node remotely over Tor to other devices, such as the iOS application [Fully Noded](https://github.com/FontaineDenton/FullyNoded).

The app currently relies on initial installation of [Strap.sh](https://github.com/MikeMcQuaid/strap/) to install basic development tools before installing `tor` and `bitcoin-qt`. This tool also does some basic hardening of your Macintosh including turning on FileVault (the full-disk encryption services offered in macOS), turning on your Mac firewall, and turning off Java. Future versions of *Bitcoin Standup* will integrate *Strap.sh* features directly to offer additional macOS hardening configuration options.

#### Mac Dependencies

- macOS v10.15 Catalina (may work on earlier versions, not tested yet)
- ~300 GB of free space if you want to have a full node with txindex. ~20 GB for a testnet3 full node. Both can be substantially less if the full-node is pruned.
- Install [Strap](https://github.com/MikeMcQuaid/strap) by [@MikeMcQuaid](https://github.com/MikeMcQuaid)

#### Instructions for installation on macOS

Start by installing *Strap*, a script hosted on Github for bootstrapping a minimal development environment, intended for a new Mac or a fresh install of macOS. *Bitcoin-Standup* currently relies on *Strap* to bootstrap a macOS system before installing Bitcoin and tools.

***WARNING:*** Be careful about using GitHub bash scripts on existing systems as they can compromise your computer. Use these scripts on new systems only. We also suggest you view the [script](https://github.com/MikeMcQuaid/strap/blob/master/bin/strap.sh) in advance, and only execute it if you trust the source. [@MikeMcQuaid](https://github.com/MikeMcQuaid) is the open source [Homebrew](https://brew.sh) Project's lead maintainer and also a senior member of the GitHub staff.

1. Run the *Strap* script on your Mac. After a fresh macOS install either:
   - Execute the *Strap* script directly from your Mac's CLI (command line interface)
     1. Execute these commands to install *Strap* via the *Terminal* app's command line interface (to start *Terminal* type command + space + "terminal"):
     ```bash
     curl -L https://raw.githubusercontent.com/MikeMcQuaid/strap/master/bin/strap.sh > ~/Downloads/strap.sh
     bash ~/Downloads/strap.sh
     ```
   - OR Clone the *Strap* repo to your Mac and then execute the script.
     1. Execute these commands to clone *Strap*'s GitHub repository via the *Terminal* app's command line interface (to start *Terminal* type command + space + "terminal"):
     ```bash
     git clone https://github.com/MikeMcQuaid/strap
     cd strap
     bash bin/strap.sh
     # or `bash bin/strap.sh --debug` for more debugging output
     ```
   - OR Use the [*Strap* heroku web app](https://macos-strap.herokuapp.com/). This web application will request a temporary Github secure access token for your use, allowing you use the *strap.sh* script to automatically install and download from your own personal GitHub repository `.dotfiles` and install additional apps from a `.Brewfile`. This token is solely used to add the GitHub access token to your `strap.sh` download and is not otherwise used by this web application or stored anywhere.
     1. Open https://macos-strap.herokuapp.com/ in your web browser. Click on the `strap.sh` button.
     2. Login to your GitHub account.
     3. Download `strap.sh` to your `~/Downloads/` folder
     4. Execute this command via the *Terminal* app's command line interface (to start *Terminal* type command + space + "terminal"):
     ```bash
     bash ~/Downloads/strap.sh
     ```
     5. After *strap.sh* has finished processing, delete the customized `strap.sh` (it has a GitHub acces token in it) by executing:
     ```bash
     rm ~/Downloads/strap.sh
     ```
2. After running the *Strap* script, download and run the *Bitcoin Standup.app* 

(COMING SOON - for now use the [Build From Source](#build-from-source) instructions.

#### Build Mac App from source using Xcode

Instead of downloading binaries through *Strap*, you can build *Bitcoin-Standup* by hand using Apple's Xcode.

- Install [Xcode](https://itunes.apple.com/id/app/xcode/id497799835?mt=12)
- You will need a free Apple developer account; [create one here](https://developer.apple.com/programs/enroll/)
- In XCode, click "XCode" -> "preferences" -> "Accounts" -> add your github account
- On the github repo click "Clone and Download" > "Open in XCode"; when XCode launches, just press the "play" button in the top left

### Linode and Debian Linux Installs

This is currently a work in progress (there is no Quick Connect URI at the end of install yet), but these instructions and scripts from the [Learning Bitcoin from the Command Line](https://github.com/ChristopherA/Learning-Bitcoin-from-the-Command-Line) course will install Bitcoin-Core on a VPS or on Debian Linux.

- [Section One: Setting Up a Bitcoin Core VPS by Hand](https://github.com/ChristopherA/Learning-Bitcoin-from-the-Command-Line/blob/master/02_1_Setting_Up_a_Bitcoin-Core_VPS_by_Hand.md)
- [Section Two: Setting Up a Bitcoin Core VPS with StackScript](https://github.com/ChristopherA/Learning-Bitcoin-from-the-Command-Line/blob/master/02_2_Setting_Up_a_Bitcoin-Core_VPS_with_StackScript.md)

## API

### Quick Connect URL using btcstandup

This section defines the spec for a deep link URI and a scannable QR Code. These ideally would have the same format among a number of different software projects and hardware products to ensure universal compatibility.

The iOS application [Fully Noded](https://github.com/FontaineDenton/FullyNoded) is a proof of concept of such a light client. The only server side node manufacturer supporting this protocol is [Nodl](https://www.nodl.it/) (release is imminent).

#### Current Format

This example URL follows the current format:

```
btcstandup://:@:?label=&v2password=
```

Example with `label` and `v2password`:

```
btcstandup://rpcuser:rpcpassword@kjhfefe.onion:8332?label=Node%20Name&v2password=uenfieufnuf4
```

Example without `label` and `v2password`:

```
btcstandup://rpcuser:rpcpassword@kjhfefe.onion:8332
```

This allows node hardware manufacturers the option of hard coding a label for the node. Ideally, there would be a two-factor authentication where user inputs a V2 or V3 auth cookie into the client app manually, so that if the URL leaks somehow it would not give an attacker access to the node.

## Security

### Warning

Don’t configure a VPS with the Bitcoin wallet feature turned on with any significant real funds; see http://blog.thestateofme.com/2012/03/03/lessons-to-be-learned-from-the-linode-bitcoin-incident/ . A higher level of safety is required for significant funds. A VPS-based install can be a useful as a wallet-less full node connected remotely to a more secure wallet that signs the keys elsewhere.

### Supported Versions

None yet.

### Reporting a Vulnerability

To report security issues send an email to ChristopherA@LifeWithAlacrity.com (not for support).

The following keys may be used to communicate sensitive information to developers:

| Name              | Fingerprint                                        |
| ----------------- | -------------------------------------------------- |
| Christopher Allen | FDFE 14A5 4ECB 30FC 5D22  74EF F8D3 6C91 3574 05ED |

You can import a key by running the following command with that individual’s fingerprint: `gpg --recv-keys "<fingerprint>"` Ensure that you put quotes around fingerprints that contain spaces.

## Maintainers

- Christopher Allen [@ChristopherA](https://github.com/@ChristopherA) \<ChristopherA@LifeWithAlacrity.com\> (lead)
- Peter Denton [@Fonta1n3](https://github.com/Fonta1n3)

## Contributing

PRs are accepted. See CONTRIBUTING.md

## License

MIT © 2019 Blockchain Commons, LLC

