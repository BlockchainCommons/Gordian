# StandUp-iOS

### Status

StandUp-iOS is currently in the very early testing phase and should be considered as proof of concept or minimum viable product.

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

#### Everday Use

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

StandUp-iOS keeps thing simple by relying on Bitcoin Core for all wallet functionality. The app simply derives the private key necessary for signing whatever transaction you create then uses your node to sign the transaction with that key with `signrawtransactionwithkey`, this way we can keep your node cold and store the seed only on your device which is generally recognized to be more secure then general purpose computers.

### To do:

- Ability to import a BIP39 recovery phrase, descriptor or xprv/xpub.
- Cold mode?
- Custom derivation path?
- Make Tor auto reconnect after the background process is killed in the background.
- Kill switch code?
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

