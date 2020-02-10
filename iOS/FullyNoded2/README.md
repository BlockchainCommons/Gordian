# StandUp-Remote

### Status

StandUp-Remote is currently under active development and in the early testing phase. Future versions may include breaking changes which aren't backward compatible, use only on testnet.

In order to use it you need to scan a `btcstandup://` uri which you can read about [here](https://github.com/BlockchainCommons/Bitcoin-Standup#quick-connect-url-using-btcstandup).

### Testflight

We have a public link available for beta testing [here at this link](https://testflight.apple.com/join/OQHyL0a8), please bare in mind the app may change drastically and may not be backward compatible, please only use the app on testnet.

- [ ] Wallet Functions
  - [x] Spend and Receive
  - [x] Segwit
  - [x] Non-custodial
  - [x] Coin Control
  - [x] BIP44
  - [x] BIP84
  - [x] BIP49
  - [x] BIP32
  - [x] BIP21
  - [x] Custom mining fee
  - [ ] Multisig
  - [ ] Cold storage
  - [x] Multiwalletrpc
  
- [ ] Security
  - [x] Seed created with Apple's cryptographically secure random number generator
  - [x] Seed encrypted with a private key stored on the devices keychain which is itself encrypted
  - [x] Seed encrypted with native iOS code
  - [x] Tor V3 Authentication
  - [ ] Passphrase support
  - [ ] Wallet.dat encryption
  - [ ] Disable all networking before importing/exporting seed 
  - [ ] Automated Tor authentication
 
- [ ] Compatible Nodes
  - [x] Your own Bitcoin Core node
  - [x] MacOS - [StandUp.app](https://github.com/BlockchainCommons/Bitcoin-Standup/tree/master/StandUp)
  - [x] Linux - [StandUp.sh](https://github.com/BlockchainCommons/Bitcoin-Standup/tree/master/LinuxScript)
  - [x] Nodl
  - [x] myNode
  - [x] BTCPayServer
  - [x] RaspiBlitz
  - [ ] Wasabi
  - [ ] CasaHodl
  
StandUp-Remote is designed to work with the [MacOS StandUp.app](https://github.com/BlockchainCommons/Bitcoin-Standup/tree/master/StandUp) and [Linux scripts](https://github.com/BlockchainCommons/Bitcoin-Standup/tree/master/LinuxScript), but will work with any properly configured Bitcoin Core node with a hidden service controlling `rpcport` via localhost. Supporting nodes are [myNode](http://www.mynodebtc.com), [Nodl](https://www.nodl.it/), [BTCPayServer](https://btcpayserver.org) and [RaspiBlitz](https://github.com/rootzoll/raspiblitz), these nodes can be connected by clicking a link or scanning a qr code. Please refer to their telegram groups for simple instructions: 

- [Nodl Telegram](https://t.me/nodl_support)
- [myNode Telegram](https://t.me/mynode_btc)
- [BTCPayServer](https://t.me/btcpayserver)
- [RaspiBlitz Telegram](https://t.me/raspiblitz)

### What does it do?

#### Initial Setup

Everything below happens automatically after you scan the QuickConnect QR code.

When you open StandUp the first time it will create a seed for you, encrypt it, save it locally. Once the seed is created you can connect to your node by scanning a [QuickConnect QR code](https://github.com/BlockchainCommons/Bitcoin-Standup#quick-connect-url-using-btcstandup) or by clicking it as a deeplink.  Upon scanning a valid QuickConnect QR code the app will create a private/public keypair which is used for authenticating your tor connection. The app then goes through a series of Bitcoin Core RPC calls over Tor to your node. The app will create a new wallet on your node, import the first 2,000 addresses from your xpub deriving the addresses as m/84'/1'/0'/0 by default and m/84'/0'/0'/0 if the node is on mainnet. Advanced users may set different derivation paths and import seeds. Altering the derivation path or adding a seed will always create a new wallet so that nothing is ever overwritten or deleted, simply go to advanced settings to see your wallets and switch them on and off. Altering the derivation path will always create a new wallet with the existing seed, if you want to import a new seed simply go to advanced settings and tap import seed.

#### Everyday use

After the above process completes you will be able to:

- spend and receive using BIP44, BIP84, BIP49 compatible keys
- breakdown of your raw transaction before broadcasting to ensure piece of mind
- import/export BIP39 seeds
- customize derivation schemes
- create and pay BIP21 invoices
- coin control
- transaction batching
- descriptor exporting
- one line exportable command to recover your wallet with Bitcoin Core should you lose your device
- export/verify your addresses
- custom fee preference
- statistics about the Bitcoin network straight from your node
- balance in BTC or fiat (tap the balance to toggle)
- your last 50 transactions, tap a transaction to see full details

### How does it work?

StandUp-Remote keeps thing simple by relying on Bitcoin Core for the majority of wallet functions related to building/signing of transactions. StandUp-Remote is responsible for passing the appropriate private key to Bitcoin Core (your node) to sign transactions with. We create wallets with `avoidaddressreuse` set to `true` so that private keys will only every be used once. As the app is designed it is a hot wallet with keys stored locally onto your device. Your seed is fully encrypted and stored as raw data. The private key for decrypting your seed is stored securely on the keychain. We believe that storing private keys on your device is generally safer then an all purpose computer. You should never store more bitcoins then you are willing to lose on a hot wallet just as you would never carry more cash than necessary when going out.

### Requirements
- iOS 13
- a Bitcoin Core full-node v0.18.0 (at minimum) which is running on Tor with `rpcport` exposed to a Tor V3 hidden service

### Author
Peter Denton, fontainedenton@gmail.com

### Built with
- [Tor.framework](https://github.com/iCepa/Tor.framework) by the [iCepa project](https://github.com/iCepa) - for communicating with your nodes hidden service
- [LibWally-Swift](https://github.com/blockchain/libwally-swift) built by @sjors - for BIP39 mnemonic creation and HD key derivation
- [Base32](https://github.com/norio-nomura/Base32/tree/master/Sources/Base32) built by @norio-nomura - for Tor V3 authentication key encoding
- [Keychain-Swift](https://github.com/evgenyneu/keychain-swift) built by @evgenyneu for securely storing sensitive data on your devices keychain

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


