# Policy Map

*Gordian System* utilizes what we refer to as an [*Account Map*](./Account-map.md) to allow users to seamlessly export and import accounts (aka wallets).

A *Policy Map* is a key-less (or incomplete) *Account Map* which can be utilized for the purpose of coordinating a multi-party/multi-signature account.

The *Policy Map* defines the total number of participants that may join, the number of required signatories to spend funds, the script type, and optionally derivation paths.

Other metadata may be added which is not yet described.

### Initiator

The initiator will create the initial *Policy Map*, the primary parameter is an incomplete [output descriptor](https://github.com/bitcoin/bitcoin/blob/master/doc/descriptors.md).

The initiator must decide on a script type, for our purposes we will stick with the most widely adopted standard which is `witness script hash`, denoted as `wsh` in an output descriptor.

The total number of participants for our example will be `3`.

The required number of signatories for our example will be `2`, creating a 2 of 3 multi-sig account.

This particular *Policy Map* will utilize [BIP67](https://github.com/bitcoin/bips/blob/master/bip-0067.mediawiki) by including the `sortedmulti` prefix.

The initiator, in this example, prefers to utilize the most widely adopted multi-sig derivation path which is `m/48'/0'/0'/2'`. This is optional, there is no requirement that the initiator must decide on this. Derivations can be added by each individual participant when they add their public key.

The *Policy Map* would look like this in the initiation stage as per our example:

`wsh(sortedmulti(2,[<fingerprint>/48h/0h/0h/2h]<xpub>,[<fingerprint>/48h/0h/0h/2h]<xpub>,[<fingerprint>/48h/0h/0h/2h]<xpub>))`

The initiator role is now complete, they may either update the *Policy Map* with their own `<fingerprint>` and `<xpub>` or simply pass it to the concerned parties.

### Updater

An updater is one of the concerned parties who will be invited to take part in the creation of the *Account Map*.

In order to take part they must update the *Policy Map* with their extended public key and master key fingerprint (`<fingerprint>`, `<xpub>`), at which point they either send it back to the initiator or to the next peer.

After being passed to one party who agrees to take part the *Policy Map* would look like:

`wsh(sortedmulti(2,[83hf9h94/48h/0h/0h/2h]xpub6CMZuJmP86KE8gaLyDNCQJWWzfGvWfDPhepzBG3keCLZPZ6XPXzsU82ms8BZwCUVR2UxrsDRa2YQ6nSmYbASTqadhRDp2qqd37UvFksA3wT,[<fingerprint>/48h/0h/0h/2h]<xpub>,[<fingerprint>/48h/0h/0h/2h]<xpub>))`

The master key fingerprint is described in [BIP32](https://en.bitcoin.it/wiki/BIP_0032), some offline signers require this metadata, others do not. Generally if the party does not know the master key fingerprint then wallet software can derive the fingerprint of the provided extended key and utilize that.

### Finalizer

Once all concerned parties have filled in their respective `fingerprint` and `xpub` the finalizer should ensure the validity of the output descriptor's keys and process it. For the purposes of *Gordian Wallet*, *Fully Noded* and *Specter* a standard has been discussed whereby the *Account Map's* `descriptor` is utilized as a cross application account identifier whereby the `wallet.dat` file created on Bitcoin Core is named deterministically as a derivate of the *Account Map's* `descriptor`.

This works by ensuring the xpub's in the `descriptor` are sorted lexicographically. Hardened derivation path components are denoted using `h` (not `H` or `'`). This way we can then run the processed `descriptor` through a sha256 hash function, the resulting hash acting as the `wallet.dat` filename for the wallet/account (or at least a portion of it). This is an example `wallet.dat` filename in GordianWallet: `Gordian-8268d751e68922956e6b3ee6ccbb469d18e8a158ee814aa47cb07d0259c1bbad.dat`.

Lexicographic sorting of the xpub's is important because a `sortedmulti` (BIP67) compatible `descriptor` will derive the same multi-sig addresses irregardless of the order of xpub's, however the hash of the descriptor would obviously change defeating the purpose of the use of the hash as a deterministic identifier.

This can be incredibly useful for client software during the process of importing an account. The client software can simply process the `descriptor`, hash it and then see if the Bitcoin Core backend already holds a matching account, if it does it can simply reuse that `wallet.dat` file without requiring a rescan or worse a reindex of the blockchain, if it does not exist it will create the account from scratch.

This works particularly well for users who utilize pruned nodes where wallet import/recovery can result in a very long and tedious process of "re-downloading the entire blockchain". In a multi-sig world it is likely a user will use multiple apps/wallets with one Bitcoin Core backend so as to reap the benefits of multi-sig by not relying on one application or operating system.

Once the *Policy Map* is complete it can be added as the `descriptor` parameter in an *Account Map* along with the other relevant metadata.

The finalized *Policy Map* should look like this:

`wsh(sortedmulti(2,[83hf9h94/48h/0h/0h/2h]xpub6CMZuJmP86KE8gaLyDNCQJWWzfGvWfDPhepzBG3keCLZPZ6XPXzsU82ms8BZwCUVR2UxrsDRa2YQ6nSmYbASTqadhRDp2qqd37UvFksA3wT,[9ihgte55/48h/0h/0h/2h]xpub6FJ6w4NAGLFuE6dN3kjbu3fzdfJgULEMpNVD1QacRvnBozrgy4tMMJtXweewEngBxrwR4Q6NwHqu15w2ALPsaUCyXDWUCKUV3WztzJYGZHw,[00yt3t6t/48h/0h/0h/2h]xpub6CcJQNxt2z7s1dPMCuR6CAtyoqc5xYkFPkyJbokjaiEjixcWZPx2huKc8BSBYqv3jya1SBeUfx6rRdLneGVgNCWsBghSiPNB7Vz3ZhWtCcD))`

See [*Account Map*](./Account-map.md) for complete examples. 
