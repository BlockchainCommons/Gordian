# 🛠 Bitcoin-Standup

*Bitcoin-Standup* is a open source tool to help users install a [Bitcoin-Core](https://bitcoin.org/) full-node on a fresh computer or VPS, add important privacy tools like onion services, and eventually optional Bitcoin-related tools like [C-Lightning](https://github.com/ElementsProject/lightning), [Esplora](https://github.com/Blockstream/esplora), [BTCPay Server](https://github.com/btcpayserver/btcpayserver), and emerging technologies like Bitcoin-Based Decentralized Identifiers.

This tool also will harden and secure your OS to current best-practices, as well as adding sufficient system tools to support basic Bitcoin development. After setup, *Bitcoin-Standup* will present a QR code or special URI that can be used to securely link your full-node to other devices, such as your mobile phone or desktop.

Once installed and fully synced, a *Bitcoin-Standup* full node can also be used with developer education courses like [Learning Bitcoin from the Command Line](https://github.com/ChristopherA/Learning-Bitcoin-from-the-Command-Line).

**NOTE:** *At this time Bitcoin-Standup only supports installation on macOS Mojave or Catalina. Future versions will include installation on Debian Linux, Linode, Digital Ocean, etc.*

*Bitcoin-Standup* is a project of [Blockchain Commons, LLC](https://www.blockchaincommons.com/) a “not-for-profit” benefit corporation founded with the goal of supporting blockchain infrastructure and the broader security industry through cryptographic research, cryptographic & privacy protocol implementations, architecture & code reviews, industry standards, and documentation. To financially support further development of Bitcoin-Standup, please consider becoming Patron of Blockchain Commons by contributing Bitcoin at our [BTCPay Server](https://btcpay.blockchaincommons.com/) or ongoing fiat patronage by becoming a [Github Sponsor](https://github.com/sponsors/ChristopherA/).

If you are a software developer you can join us by offering issues and pull requests in our [Bitcoin-Standup GitHub](https://github.com/BlockchainCommons/Bitcoin-Standup) or with other projects located in the [Blockchain Commons Community Github](https://github.com/BlockchainCommons/).

## MacOS

### What does it do?

The application *Bitcoin Standup.app* currently installs, configures and launches `tor stable v0.4.1.6` and `bitcoin-qt v0.19.0`. The app is under active development and as it stands will install and configure a Bitcoin Core full node.

Once the app has completely installed and launched Bitcoin it will display a *Quick Connect QR code* to the user which can be scanned by the iOS application [Fully Noded](https://github.com/FontaineDenton/FullyNoded) to connect to the node remotely over Tor.

The app currently relies on initial installation of [Strap.sh](https://github.com/MikeMcQuaid/strap/) to install basic development tools before installing tor and bitcoin-qt. This tool also does some basic hardening of your Macintosh including turning on FileVault, the full-disk encryption services offered in macOS. Future versions of *Bitcoin Standup* will integrate *Strap.sh* to offer additional macOS hardening configuration options.

### Dependencies

- MacOS v10.15 Catalina (may work on earlier versions, not tested yet)
- *Strap* by Mike McQuaid

### Instructions

*WARNING:* Be careful about using GitHub bash scripts on existing systems as they can compromise your system. Use on new systems only. We also suggest you view the [script](https://github.com/MikeMcQuaid/strap/blob/master/bin/strap.sh) in advance, and only execute it if you trust the source. [@MikeMcQuaid](https://github.com/MikeMcQuaid) is the open source [Homebrew](https://brew.sh) Project's lead maintainer and also a senior member of the GitHub staff.

1. The first step is to "strap" your mac. Either:
   - Execute *Strap* directly from your Mac's CLI (command line interface)
     1. Execute these commands via the *Terminal* app's command line interface (to start *Terminal* type command + space + "terminal"):
     ```bash
     curl -L https://raw.githubusercontent.com/MikeMcQuaid/strap/master/bin/strap.sh > ~/Downloads/strap.sh
     bash ~/Downloads/strap.sh
     ```
   - OR Clone the repo to your mac and execute the script.
     1. Execute this command via the *Terminal* app's command line interface (to start *Terminal* type command + space + "terminal"):
     ```bash
     bash
     git clone https://github.com/MikeMcQuaid/strap
     cd strap
     bash bin/strap.sh
     # or `bash bin/strap.sh --debug` for more debugging output
     ```
   - OR Use the *Strap* heroku web app. This offers a web page to request a temporary Github access token for you, allowing you use the *strap.sh* script to automatically install and download from your personal GitHub repository your `.dotfiles` and install additional apps from a `.Brewfile`. This token is solely used to add the GitHub access token to your strap.sh download and is not otherwise used by this web application or stored anywhere.
     1. Open https://macos-strap.herokuapp.com/ in your web browser.
     2. Login to your GitHub account.
     Execute this command via the *Terminal* app's command line interface (to start *Terminal* type command + space + "terminal"):
     ```bash
     bash ~/Downloads/strap.sh
     ```
     3. After *strap.sh* has finished processing, delete the customized `strap.sh` (it has a GitHub token in it) by executing:
     ```bash
     rm ~/Downloads/strap.sh
     ```
2. Download and run the *Bitcoin Standup.app* (COMING SOON - for now use the [Build From Source](#build-from-source) instructions.

### Build from source

- Install [Xcode](https://itunes.apple.com/id/app/xcode/id497799835?mt=12)
- You will need a free Apple developer account [create one here](https://developer.apple.com/programs/enroll/)
- In XCode, click "XCode" -> "preferences" -> "Accounts" -> add your github account
- On the github repo click "Clone and Download" > "Open in XCode", when XCode launches just press the "play" button in the top left

# Quick Connect URL using btcstandup:

This section will define the spec for the deep link URI and QR Code which ideally would have the same format to ensure universal compatibility with either deep links or QR code scanning.

The iOS application [Fully Noded](https://github.com/FontaineDenton/FullyNoded) is a proof of concept of such light client. The only server side node manufacturer supporting this protocol is [Nodl](https://www.nodl.it/) (release is imminent)

## Current Format

An example URL following the current format is:

```
btcstandup://rpcuser:rpcpassword@torHostname.onion:rpcport/?label=Stand%20Up%20Node
```

Example with label and v2password:

```
btcstandup://rpcuser:rpcpassword@kjhfefe.onion:8332/?label=nodeName&v2password=uenfieufnuf4
```

Example without label and v2password:

```
btcstandup://rpcuser:rpcpassword@kjhfefe.onion:8332/?
```

This allows node hardware manufacturers the option of hard coding a label for the node. There ideally would be a two factor authentication where user inputs the V2 or V3 auth cookie into the client app manually so that if the URL leaks somehow it would not give an attacker access to the node.
