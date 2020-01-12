# 🛠 Bitcoin-Standup

> *Bitcoin-Standup* is a open source project and a suite of tools that helps users to install a [Bitcoin-Core](https://bitcoin.org/) full-node on a fresh computer or VPS and to add important privacy tools like onion services and eventually optional Bitcoin-related tools like [Electrum Personal Server](https://github.com/chris-belcher/electrum-personal-server), [C-Lightning](https://github.com/ElementsProject/lightning), [Esplora](https://github.com/Blockstream/esplora), [BTCPay Server](https://github.com/btcpayserver/btcpayserver), etc., as well as emerging technologies like Bitcoin-based Decentralized Identifiers.
>
> This tool will also harden and secure your OS to current best practices, as well as adding sufficient system tools to support basic Bitcoin development. After setup, *Bitcoin-Standup* will present a QR code and/or special URI that can be used to securely link your full-node to other devices, such as your mobile phone (for instance using [Fully Noded](https://github.com/FontaineDenton/iOS *StandUp-Remote*) on iOS) or a remote desktop.
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
  - [Linode and Debian Linux Install](#linode-and-debian-linux-install)
  - [iOS Testflight](#ios-testflight)
- [API](#api)
  - [Quick Connect URL using btcstandup](#quick-connect-url-using-btcstandup)
- [Security](#security)
  - [Tor V3 Authentication using StandUp and iOS *StandUp-Remote*](#tor-v3-authentication-using-standup-and-iOS *StandUp-Remote*)
- [Maintainers](#maintainers)
- [Contributing](#contributing)
- [License](#license)

## Status

This project is an early **Work-In-Progress**, so that we can prototype, discover additional requirements, and get feedback from the broader Bitcoin-Core Developer Community. ***It has not yet been peer-reviewed or audited. It is not yet ready for production uses. Use at your own risk.***

### Disclaimer

*The information and files included in this repository are intended to inform a set of best practices. It may not address risks specific to your situation, and if it does not, you should modify appropriately. While this information may inform best practices, there is no guarantee that following this advice will sufficiently ensure the security of your digital assets. In addition, this information is only a window on best practices at a specific moment in time. Be aware that the Bitcoin and blockchain ecosystems may have evolved, and the risk assessments of specific solutions may have changed since the publication of this document. In other words: be cautious, be careful, and be aware of the current Bitcoin and blockchain landscape before you use this information.*

## Background

### Reasons to run a full node

1. Validation
    - The most important reason to operate a Bitcoin full node is validation. With a full node, Bitcoin users can check whether transactions are valid according to all of Bitcoin's rules. Users can verify that any bitcoins they receive are legitimately mined, correctly signed, and more. This is what makes Bitcoin a trustless solution. Without your own full node you are inheritantly trusting a third party to tell you how much Bitcoin you own and when it comes to spending it that it gets sent to the desired address, with your own full node you can verify with certainty that your bitcoins are real, yours, and get sent to the intended recipient.

2. Privacy
    - Generally speaking when you use a wallet or Bitcoin service you are relying on someone elses node, therefore they know all your addresses, spending habits, how much money you have etc, this is obviosuly not ideal. Utilizing your own node allows you to use Bitcoin in a much more private way whereby you do not necessarily have to leak all your spending habits to a third party.
    - *Bitcoin-Standup* uses Tor for enhanced privacy. Over the clearnet all of your devices network traffic is highly correlatable, meaning it is trivial for third parties to track which websites you visit and they could easily see the internet traffic related to your IP address that are Bitcoin related, considering IP addresses can be linked to physical locations it can pose certain risks to Bitcoin users. This is where Tor comes in, with *Bitcoin-Standup* all of your Bitcoin related internet traffic is obfuscated with Tor, for example you may use the *StandUp-Remote* iOS app over Tor to get information from your node and it would be very difficult for any third party to see that your device is speaking to a Bitcoin Core node, let alone what it is specifically doing.
    
3. Security
    - Bitcoin Core is the reference implementation of Bitcoin, when using *Bitcoin-Standup* you are utilizing one of the most highly peer reviewed and scrutinized peices of software in the world, the vast majority of the functionality for the *StandUp-Remote* app is powered by Bitcoin-Core so you can rest at ease that critical bugs should be minimized.
    - Self custody can be scary as running a node properly over Tor may not be something most people are comfortable with. The entire purpose of the *Bitcoin-Standup* suite of tools is to make this acheivable for anyone who can click a mouse and scan a QR code.
    - Native Tor V3 client authentication is integrated into the macOS and iOS StandUp apps, this is the most secure way of communicating with your node remotely ensuring that *only* your device has access to your node even if all other credentials were comrpomised by an attacker.
    - In short accessing your Bitcoins Core node over Tor with a remote client is the most secure way of doing it.
    
4. Liquidity
    - Access to funds is a critical component to storing your Bitcoin in a sovereign way. With *Bitcoin-StandUp* you can copy and paste a one line command and recover your entire wallet with your own node at any time with guaranteed compatibility. *StandUp-Remote* iOS app also allows you to import seeds which will allow you to access your Bitcoins stored on other wallets or apps. If you are not using your own node you may be encumbered by the third parties software limitations which may not allow you to export your seed, private keys or be interoperable with other Bitcoin software.
    
5. Testing and learning
    - Utilizing your own node allows you to test with the bitcoin network, simply run the node over testnet and you can expirament with fake money before commiting any real funds. A ridiculous percentage of circulating Bitcoins have been lost due to misuse or mistakes. *Bitcoin-Standup* suite of tools allows you test everything over testnet with your own node ensuring you are comfortable with how it works and that it does work before utilizing mainnet.

## Financial Support

*Bitcoin-Standup* is a project of [Blockchain Commons, LLC](https://www.blockchaincommons.com/) a “not-for-profit” benefit corporation founded with the goal of supporting blockchain infrastructure and the broader security industry through cryptographic research, cryptographic & privacy protocol implementations, architecture & code reviews, industry standards, and documentation.

To financially support further development of *Bitcoin-Standup*, please consider becoming Patron of Blockchain Commons by contributing Bitcoin at our [BTCPay Server](https://btcpay.blockchaincommons.com/) or through ongoing fiat patronage by becoming a [Github Sponsor](https://github.com/sponsors/ChristopherA/) or by clicking on the ❤️ above.

If you are a software developer you can join us by offering issues and pull requests in our [Bitcoin-Standup GitHub](https://github.com/BlockchainCommons/Bitcoin-Standup) or with other projects located in the [Blockchain Commons Community GitHub](https://github.com/BlockchainCommons/).

## Install

### macOS Install

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

#### Download *StandUp.app*

Download the `StandUp_Export.zip` from this [public google drive link](https://drive.google.com/open?id=1lXyl_zO6WPJN5tzWAVV3p42WPFtyesCR), unzip it and open the folder and you will see `StandUp.app`, if your mac has been strapped or has brew and xcode command line tools installed you will be good to go, just double click it the app to use it.

Peter Denton GPG fingerprint: `3B37 97FA 0AE8 4BE5 B440 6591 8564 01D7 121C 32FC` signed the `StandUp_Export.zip` which produced the following signature:

```
-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOzeX+groS+W0QGWRhWQB1xIcMvwFAl4Q8agACgkQhWQB1xIc
Mvy8Kg/8Dbw+Ju0LZhXtheauI43TqVkbh5XCAamDAtzRAKlKLhYjYW1XMFQ/y923
X+/+ld3ZjrlC8qQhEm+6cR21m5GgP2FsA1lKiAH92X2hpzv7taUkrAVjLdhn9KA0
BRFabRzL1720l9Q7IHbo2zMDUKnK3PC0zKDtmoSl/E7HbMomEXgldnFl3Vi6D9Ah
fMQnR36ECbTRPuBvuETS77XBnU27t9LHtFTcE9YyoikF4qvsDEtC6VkMjK+gHj0A
BQuJtC1q9/FS9JTv1goPYJjmERqFj7jadwqfct3AVSJy0W2bltzOUf3lQNAaMcZc
XsRZwnGcGVpxFo7YORlzwjGUxsz8jjBVl4IUOIi/6mW21gWAq7LZKUWvBOp5Soj0
xhTXO+04O2hd5/l4Nap5CNyxzKqkUl6f/cTVXHWrMVFQ6gn9EX1kiPDjdaWzlcHX
dGGOkscJwG+wPR5MJlyVkFQIUFzBMYMynZE/zU62H6FRtWUoobaZCB8k4+icIh2Z
kHCYygkfEZreI7c2aMs5sYsbkNJ/X22CQC+jdRC+V52aClC4OkR9QrJm+E4hTqmz
eYehwAF1LW0IrF/zM8mc45fpkHr+uCDjLZb6ctsUONPc7ARKt1vYZ+r1NM4sHq2m
SijIlxPUugawiAn90sGhaTGviTWg1A06l3hpjzhaEdyIY2UOD7g=
=V4d6
-----END PGP SIGNATURE-----
```

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

### *StandUp-Remote* iOS Testflight

We have a public link available for beta testing [here at this link](https://testflight.apple.com/join/OQHyL0a8), please bare in mind the app may change drastically and may not be backward compatible, please only use the app on testnet. You will need to first install the [Testflight app]() onto your device in order to be able to access the testflight beta of StandUp-Remote.

## Functionality

### macOS

The macOS application *Bitcoin Standup.app* currently installs, configures, and launches `tor stable v0.4.2.5` and `bitcoin-core v0.19.0.1`. The app is under development and as it stands will install and configure a Bitcoin Core full node, Tor as a service, a Tor V3 hidden service controlling each  `rpcport` with a GUI for native Tor V3 authentication. The app allows the user to set custom settings including `txindex`, `prune`, `walletdisabled`, `testnet`, `mainnet`,  and `datadir`. It offeres a simple `go private` option which closes off your node to the clearnet, only accepting connections over Tor. The user may refresh their hidden service at the push of a button. The user can start/stop Tor and Bitcoin Core from the GUI, adjust bitcoin.conf settings, see the status of Bitcoin Core and Tor, the app will configure a hidden service and you bitcoin.conf so that it can display a QuickConnect QR code to connect to with the StandUp-Remote iOS app.

Once the app has completely installed and launched Bitcoin Core, it will present a *Quick Connect QR code* which can be used to securely link your full node remotely over Tor to other devices, such as the iOS application [StandUp-Remote](https://testflight.apple.com/join/OQHyL0a8) and [Fully Noded](https://github.com/FontaineDenton/iOS *StandUp-Remote*).

The app currently relies on initial installation of [Strap.sh](https://github.com/MikeMcQuaid/strap/) to install basic development tools before installing `tor` and `bitcoin-core`. This tool also does some basic hardening of your Macintosh including turning on FileVault (the full-disk encryption services offered in macOS), turning on your Mac firewall, and turning off Java. Future versions of *Bitcoin Standup* will integrate *Strap.sh* features directly to offer additional macOS hardening configuration options.

To read more details about macos *StandUp.app* please see the dedicated github [readme here](https://github.com/BlockchainCommons/Bitcoin-Standup/blob/master/MacOS/README.md).

### iOS

The iOS application *StandUp-Remote* utilizes your Bitconi Core node as a backend, offering you a relatively secure, private, self sovereign means of accessing, spending, and receiving your Bitcoin on the go. Once you scan a QuickConnect QR code the app will automatically start firing off a carefully constructed list of RPC commands to your node to create a special type of wallet whereby no private keys are stored on your node. The iOS device holds your encrypted seed and simply derives the correct private keys to sign transactions with on demand whenever you go to spend, *never* reusing a private key or address. StandUp-Remote is a powerfiul but simple to use wallet that offers both advanced and basic functionality, giving users full control over their seed with the ability to import seeds.

Because the app is accessing your node over Tor you may put your Bitcoin Core machine completely behind a firewall with no port forwarding whatsoever to access your node anywhere in the world, self sovereignty at its finest.

- Full integrated Tor
- Full coin control
- Segwit, legacy and segwit wrapped addresses all compatible (BIP44, BIP84, BIP49)
- Import seeds
- Utilize your BIP39 recovery phrase with your own node
- Customize derivation paths

To see all the details please visit the dedicated github [readme here](https://github.com/BlockchainCommons/Bitcoin-Standup/tree/master/iOS/StandUp-Remote)

## API

### Quick Connect URL using btcstandup

This section defines the spec for a deep link URI and a scannable QR Code. These ideally would have the same format among a number of different software projects and hardware products to ensure universal compatibility.

The iOS application [Fully Noded](https://github.com/FontaineDenton/iOS *StandUp-Remote*) is a proof of concept of such a light client. The server side node manufacturers/providers supporting this protocol are [BTCPayServer](https://btcpayserver.org), [Nodl](https://www.nodl.it/), [MyNode](http://www.mynodebtc.com) and [RaspiBlitz](https://github.com/rootzoll/raspiblitz).

#### Current Format

This example URL follows the current format:

```
btcstandup://<your rpcuser>:<your rpcpassword>@<your tor hostname>.onion:<your hidden service port>/?label=<optional node label>
```

Example with `label` :

```
btcstandup://rpcuser:rpcpassword@kshcahsaihslalsichs78yb2ud8d.onion:8332/?label=Your%20Nodes%20Name
```

Example without `label` :

```
btcstandup://rpcuser:rpcpassword@kshcahsaihslalsichs78yb2ud8d.onion:8332/?
```

This allows node hardware manufacturers the option of hard coding a label for the node. Ideally, there would be a two-factor authentication where user inputs a V2 or V3 auth cookie into the client app manually, so that if the URL leaks somehow it would not give an attacker access to the node.

#### Questions for the Developer Community

We'd love to have more discussion with other developers about any additional requirements for this initial connection between a full node and a remote device. This could include a possible TOFU two-round auth so that the node can know that the specific remote device is the same one that requested it originally.

## Security

### Warning

Don’t configure a VPS with the Bitcoin wallet feature turned on with any significant real funds; see http://blog.thestateofme.com/2012/03/03/lessons-to-be-learned-from-the-linode-bitcoin-incident/ . A higher level of safety is required for significant funds. A VPS-based install can be a useful as a wallet-less full node connected remotely to a more secure wallet that signs the keys elsewhere.

### Tor V3 Authentication using StandUp and iOS *StandUp-Remote*
Think of your StandUp node as a server, and iOS *StandUp-Remote* or your iPhone as a client. Tor V3 hidden services have new and improved built in functionality for authenticating client connections to servers, whereby the client stores a private key that is kept secret to everyone only ever existing on the client and the public key is stored in a special directory called `authorized_clients` on your StandUp server which (in StandUp) lives in your `HiddenServiceDir`  > `/usr/local/var/lib/tor/standup/authorized_clients`.

#### The problem:
The QuickConnect QR code that StandUp produces for you contains very sensitive information. If you had a malicious maid in your house or a hacker was remotely recording your computer screen then they would have access to your node and your bitcoin as soon as they got an image of the QuickConnect QR code. If the `authorized_clients` directory is empty then anyone with the QR code has full access to your node.

#### The solution:
Prevent the existence of any single point of failure or "honey pot" (e.g. the QR code).

#### How?
 Two factor authentication whereby a trusted separate isolated device (e.g. the client) produces the private key and public key, which requires the owner of the server to physically add in the public key to the `authorized_clients` directory. In this way there is no "honey pot" which contains all the information necessary to obtain access to your node. Of course if someone has access to your node they can produce their own key pair and add the public key into the hidden service but then again they already have access to your node and hidden service so this attack vector is somewhat irrelevant. What we are trying to accomplish is a method to guarantee that your device (e.g. the client) is the *only* device in the world that is able to remotely access your node. It is highly recommended as an additional layer of security to also encrypt your nodes wallet so that even if someone somehow stole your phone they would still need to brute force your wallet.dat encryption.

 For a detailed guide see [this link](https://github.com/AnarchoTechNYC/meta/wiki/Connecting-to-an-authenticated-Onion-service#connecting-to-authenticated-version-3-onion-services), for a simple video tutorial using StandUp and iOS *StandUp-Remote* see [this link](https://youtu.be/pSm2VftTCBI) (TO DO create demo videos for StandUp-Remote)

**Assuming you have downloaded and installed macOS *StandUp.app* and iOS *StandUp-Remote* **

On *StandUp-Remote* go to settings and tap "Export Authentication Public Key" as pictured below:

<img src="https://github.com/Fonta1n3/Bitcoin-Standup/blob/master/Images/StandUp_Remote_Settings.PNG" alt="export authentication public key" width="250"/>

In *StandUp-Remote* the private key is stored encrypted locally on the device, the user can not access it and the encryption key for the private key is stored on your keychain. Whenever you connect to your node the key is decrypted and stored in your temporary torrc file which is integrated into the *StandUp-Remote* Tor thread.

The public key text which would look like `descriptor:x25519:JNEF892349FH24HF872H4FU2H387H3R982NFN238HF928` is automatically copied to your clipboard for easy copy and pasting or you may scan the QR code with your mac to input the key into the macOS *StandUp.app*.

<img src="https://github.com/Fonta1n3/Bitcoin-StandUp/blob/master/Images/StandUp_Remote_QR.PNG" alt="export the public key" width="250"/>

This public key is not sensitive as it only works in conjunction with the private key.

In this way you can also share access to your node with trusted family and friends. Tor V3 hidden services support up to ~330 different public keys stored in the `authorized_clients` directory (link to source). If you were doing this manually, you would go on your laptop which has StandUp installed and find your `HiddenServiceDir` which is `/usr/local/var/lib/tor/standup/authorized_clients`. You would then open the `authorized_clients` directory and add a file which contains only the public key exactly as *StandUp-Remote* exports it. The filename must have a `.auth` extension.

But of course you are using *Bitcoin-StandUp* so the process is as easy as a click. In macOS *StandUp.app* go to "Settings" and paste in the public key just as iOS *StandUp-Remote* exported it, then tap "Add".

<img src="https://github.com/Fonta1n3/Bitcoin-StandUp/blob/master/Images/paste.png" alt="paste the public key" width="750"/>

<img src="https://github.com/Fonta1n3/Bitcoin-StandUp/blob/master/Images/yes.png" alt="tap yes" width="750"/>

<img src="https://github.com/Fonta1n3/Bitcoin-StandUp/blob/master/Images/ok.png" alt="tap yes" width="750"/>

macOS *StandUp.app* then simply creates a random filename with a `.auth` extension, writes the public key to it, and saves it to `/usr/local/var/lib/tor/standup/authorized_clients/`.

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

# Contributing

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## We Develop with Github
We use GitHub to host code, to track issues and feature requests, as well as accept Pull Requests.

## Report bugs using Github's [issues](https://github.com/briandk/transcriptase-atom/issues)
We use GitHub issues to track public bugs.

If you find bugs, mistakes, inconsistencies in this project's code or documents, please let us know by [opening a new issue](./issues), but consider searching through existing issues first to check and see if the problem has already been reported. If it has, it never hurts to add a quick "+1" or "I have this problem too". This helps prioritize the most common problems and requests.

## Write bug reports with detail, background, and sample code
[This is an example](http://stackoverflow.com/q/12488905/180626) of a good bug report by @briandk. Here's [another example from craig.hockenberry](http://www.openradar.me/11905408).

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can. [The stackoverflow bug report](http://stackoverflow.com/q/12488905/180626) includes sample code that *anyone* with a base R setup can run to reproduce what I was seeing
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

People *love* thorough bug reports. I'm not even kidding.

## Submitting code changes through Pull Requests

Simple Pull Requests to fix typos, document, or fix small bugs are always welcome.

We ask that more significant improvements to the project be first proposed before anybody starts to code as an [issue](./issues) or as a [draft Pull Request](./pulls) (GitHub has a nice new feature for simple Pull Requests called [Draft Pull Requests](https://github.blog/2019-02-14-introducing-draft-pull-requests/). This gives other contributors a chance to point you in the right direction, give feedback on the design, and maybe point out if related work is already under way.

## We Use [Github Flow](https://guides.github.com/introduction/flow/index.html), So All Code Changes Happen Through Pull Requests
Pull Requests are the best way to propose changes to the codebase (we use [Github Flow](https://guides.github.com/introduction/flow/index.html)). We actively welcome your Pull Requests:

1. Fork the repo and create your branch from `master`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that Pull Request!

## Any code contributions you make will be under the BSD-2-Clause Plus Patent License
In short, when you submit code changes, your submissions are understood will be available under the same [BSD-2-Clause Plus Patent License](./LICENSE.md) that covers the project. We also ask all code contributors to GPG sign the [CONTRIBUTOR-LICENSE-AGREEMENT.md](./CONTRIBUTOR-LICENSE-AGREEMENT.md) to protect future users of this project. Feel free to contact the maintainers if that's a concern.

## Use a Consistent Coding Style
* We indent using two spaces (soft tabs)
* We ALWAYS put spaces after list items and method parameters ([1, 2, 3], not [1,2,3]), around operators (x += 1, not x+=1), and around hash arrows.
* This is open source software. Consider the people who will read your code, and make it look nice for them. It's sort of like driving a car: Perhaps you love doing donuts when you're alone, but with passengers the goal is to make the ride as smooth as possible.

## References

Portions of this CONTRIBUTING.md document were adopted from best practices of a number of open source projects, including:
* [Facebook's Draft](https://github.com/facebook/draft-js/blob/a9316a723f9e918afde44dea68b5f9f39b7d9b00/CONTRIBUTING.md)
* [IPFS Contributing](https://github.com/ipfs/community/blob/master/CONTRIBUTING.md)

## License

BSD-2-Clause Plus Patent License

SPDX-License-Identifier: [BSD-2-Clause-Patent](https://spdx.org/licenses/BSD-2-Clause-Patent.html)

Copyright © 2019 Blockchain Commons, LLC

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Subject to the terms and conditions of this license, each copyright holder and contributor hereby grants to those receiving rights under this license a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable (except for failure to satisfy the conditions of this license) patent license to make, have made, use, offer to sell, sell, import, and otherwise transfer this software, where such license applies only to those patent claims, already acquired or hereafter acquired, licensable by such copyright holder or contributor that are necessarily infringed by:

(a) their Contribution(s) (the licensed copyrights of copyright holders and non-copyrightable additions of contributors, in source or binary form) alone; or
(b) combination of their Contribution(s) with the work of authorship to which such Contribution(s) was added by such copyright holder or contributor, if, at the time the Contribution is added, such addition causes such combination to be necessarily infringed. The patent license shall not apply to any other combinations which include the Contribution.
Except as expressly stated above, no rights or licenses from any copyright holder or contributor is granted under this license, whether expressly, by implication, estoppel or otherwise.

DISCLAIMER

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## GitHub Codeowners

@ChristopherA
