# Quick Connect API

This section defines the spec for a deep link URI and a scannable QR Code. These ideally would have the same format among a number of different software projects and hardware products to ensure universal compatibility.

## Quick Connect 1.0

Server-side node manufacturers or providers supporting this protocol include [BTCPayServer](https://btcpayserver.org), [Nodl](https://www.nodl.it/), [MyNode](http://www.mynodebtc.com), [RaspiBlitz](https://github.com/rootzoll/raspiblitz), and of course [GordianServer](https://github.com/BlockchainCommons/GordianServer-macOS). The iOS application [GordianWallet](https://github.com/BlockchainCommons/GordianWallet-iOS) offers proof of concept of a light client built to use this protocol.

### Current Format

This example URL follows the current format:

```
btcstandup://<your rpcuser>:<your rpcpassword>@<your tor hostname>.onion:<your hidden service port>/?label=<optional node label>
```

The optional argument allows node hardware manufacturers the choice of hard coding a label for the node.

Example with `label` :

```
btcstandup://rpcuser:rpcpassword@kshcahsaihslalsichs78yb2ud8d.onion:8332/?label=Your%20Nodes%20Name
```

Example without `label` :

```
btcstandup://rpcuser:rpcpassword@kshcahsaihslalsichs78yb2ud8d.onion:8332/?
```

Ideally, there would be a two-factor authentication where a user inputs a V2 or V3 auth cookie into the client app manually, so that if the URL leaks somehow it would not give an attacker access to the node.


## Quick Connect 2.0

There is a need to be able to offer multiple services from a single server, for instance Bitcoin mainnet, testnet, Lightning, Spotbit, etc. The primary goal of Quick Connect 2.0 is a single QR from a server that can offfer a client a list of all services available to it.

A secondary requirement is that some servers may be able to use Web camera APIs to scan QRs from clients, and we'd like a QR with Tor v3 client information in it that can be passed back to the server.

### 

We'd love to have more discussion with other developers about any additional requirements for this initial connection between a full node and a remote device. This could include a possible TOFU two-round auth so that the node can know that the specific remote device is the same one that requested it originally.
