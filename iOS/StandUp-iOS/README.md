# StandUp-iOS

### Status

StandUp-iOS is currently under active development and in the early testing phase. It should be considered as proof of concept or minimum viable product.

In order to use it you need to scan a `btcstandup://` uri which you can read about [here](https://github.com/BlockchainCommons/Bitcoin-Standup#quick-connect-url-using-btcstandup).

StandUp-iOS is designed to work with the [MacOS StandUp.app](https://github.com/BlockchainCommons/Bitcoin-Standup/tree/master/StandUp) and [Linux scripts](https://github.com/BlockchainCommons/Bitcoin-Standup/tree/master/LinuxScript), but will work with any properly configured Bitcoin Core node with a hidden service controlling `rpcport`.

### What does it do?

#### Initial Setup

Upon scanning a QuickConnect QR code StandUp-iOS will:

- Create a seed that is used to derive a BIP39 recovery phrase, extended keys and private keys.
- Encrypt and store the seed to Core Data on your device locally.
- Create a x25519 keypair, encrypting the private key and storing it locally to be used for Tor V3 authentication to your node. The user may export the public key by tapping the lock button in the top left of the home screen. In order to authenticate your devices connection to your node you need to add the public key as StandUp-iOS exports it to your `authorized_clients` directory, for a more detailed guide see these [instructions](https://github.com/BlockchainCommons/Bitcoin-Standup#tor-v3-authentication-using-standup-and-fullynoded).
- Start an integrated Tor thread running Tor version 0.4.0.6
- Once Tor is connected it will create wallet on your node with the following command `createwallet "StandUp", true, true, "", true"`, this creates a wallet with private keys disabled, which holds no keys, will not reuse addresses and an empty passphrase.
- It then fetches the BIP32 xpub, using BIP84 derivation, and utilizes the `importmulti` command to import 2,000 native segwit addresses into your node, adding the first thousand address to the keypool and the second thousand addresses as change.

#### Everyday use

After the above process completes you will be able to:

- Create BIP21 invoices
- Spend your Bitcoin either using Bitcoin Core's coin selection algorithm by default or for advanced users the app also allows full coin control by tapping the list button on the "Out" tab.
- Transaction batching.
- BIP39 seed exporting, descriptor exporting and instructions on issuing a one line command to recover your wallet with Bitcoin Core should you lose your device.
- Custom fee preference.
- See statistics about the Bitcoin network straight from your node.
- See your balance in BTC or fiat (tap the blance to toggle).
- See you last 50 transactions, tap a transaction to see full details.

### How does it work?

StandUp-iOS keeps thing simple by relying on Bitcoin Core for all wallet functionality. The app simply derives the private keys necessary for signing whatever transaction you create then uses your node to sign the transaction with that key with `signrawtransactionwithkey`, this way we can keep your node cold and store the seed only on your device which is generally recognized to be more secure then general purpose computers.

### To do:

- Add biometrics and lock screen and 2fa
- Ability to import a BIP39 recovery phrase, descriptor or xprv/xpub.
- Cold mode?
- Custom derivation path?
- Different wallet templates
- Make Tor auto reconnect after the background process is killed.
- Kill switch?
- Add birthdate for the seed so a user can easily recover their wallet by scanning another `btcstandup://` uri.
- Add an alert when your node rejects a connnection because you have not authenticated the device yet.
- Replace Core Bitcoin with iOS-Bitcoin.
- Improve the confirmation screen for transactions.
- Add multisig capability.
- Improve the UI and the intro tutorial screen.

### Requirements
iOS 13

### Author
Peter Denton, fontainedenton@gmail.com

### Bulit with
- [Tor.framework](https://github.com/iCepa/Tor.framework) by the [iCepa project](https://github.com/iCepa) - for communicating with your nodes hidden service
- [Core Bitcoin](https://github.com/oleganza/CoreBitcoin) built by @oleganza - for mnemonic creation and keychain derivation
- [Base32](https://github.com/norio-nomura/Base32/tree/master/Sources/Base32) built by @norio-nomura - for Tor V3 authentication key creation

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

