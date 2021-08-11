# The Dangers of Secret-Sharing Schemes
## V0.2.0 [8/11/21] (Preliminary)

Though SSKR, Shamir's Secret Sharing, and other secret-sharing schemes can offer powerful resilience for digital-asset systems, they also come with dangers that must be carefully considered. Part of that has been traditionally related to poor coding of Shamir libraries, a problem that we've hopefully resolved with the Blockchain Commons [bc-sskr](https://github.com/BlockchainCommons/bc-sskr) and [bc-shamir](https://github.com/blockchaincommons/bc-shamir) libraries. 

However, there can also be considerable dangers attached to actually using a secret-sharing scheme to reconstruct a seed or other secret, at least in the situation where that secret is all that's needed to access digital assets.

## The Dangers of Reconstruction

Reconstruction of a seed from shards usually occurs in three steps:

1. **Authentication.** The seed holder requests the return of shards, and the shard holders verify that they believe it's the original seed holder who is making the request.
2. **Transmission.** Shard holders send seeds to the original seed holder, hopefully via secure means.
3. **Reconstruction.** Upon receipt of the shards, the seed holder reconstructs their secret.

The danger of reconstruction comes from the fact that the result of these three steps is a complete seed (or other secret) that can be used to claim digital assets. If any step is corrupted, it becomes a Single Point of Compromise (SPOC) that can be used to steal those assets.

To be specific:

_Authentication._ If an adversary can convince the shard holders to send him the shards, he will be able to recreate the seed.

_Transmission._ If an adversary is listening in on the transmission mechanism, then they may be able reconstruct the seed before the original seed holder.

_Reconstruction._ If an adversary has trojan-horsed the original seed holder's machine to be used for reconstruction, then they may be able to use the reconsted seed before the original seed holder.

A meticulously careful reconstruction process can resolve all of these problems: an in-person meeting to request shards can resolve _authentication_ attacks; the transmission of shards only as QRs from one device to another's camera can mostly deter _transmission_ attacks; and the use of a app such as [Gordian Seed Tool](https://github.com/blockchaincommons/GordianSeedTool-iOS) on an offline device such as an iPod Touch can resolve _reconstruction_ attacks. But, we're well aware that users will often put convenience ahead of security: these meticulous measures will not usually be followed.

This means that reconstructing a seed using a secret-sharing scheme should _always_ be considered a danger, at least in the case of a single-sig situation where the secret is all that's needed to access assets. That doesn't mean that secret-sharing is worthless. Far from it. It can obviously be a valuable tool if you are forced to use single-sig.

However, a secret-sharing system can be even more helpful, and much less dangerous, when applied to other SmartCustody tools such as multisig.

## Improving Secret-Sharing Safety with Multisigs

Though reconstruction can be dangerous when a single-sig secret is sharded, that danger is largely alleviated if instead secret-sharing systems are combined with [multisig design scenarios](https://github.com/BlockchainCommons/SmartCustody/blob/master/Docs/Multisig.md). In this situation, a single key is sharded from an m-of-n multisig that has an `m >= 2`. Then, even if the reconstruction of the key succumbs to compromise at the authentication, transmission, or reconstruction stage, the assets protected by the key likely remain safe, because an adversary would also have to steal other keys from hetergeneous environments.

Because multisig design scenarios are relatively young, especially for self-sovereign methodologies, the use of a secret-sharing system as a backup can offer strong resilience to protect the digital assets, as Shamir's Secret Sharing is quite well understood and analyzed.

### An Autonomous Example

One of our contributing patrons, [Bitmark](https://bitmark.com/), has worked with us on an autonomous design that combines multisig and SSKR technology to provide strong resilience for digital assets by minimizing SPOFs and SPOCs.

The core of the design is a 2-of-3 multisig, with one key kept on a mobile device and another kept on an online server, exactly as with our [Gordian Wallet](https://github.com/BlockchainCommons/GordianWallet-iOS) reference app. The merging with Shamir's Secret Sharing occurs in the third key. Whereas the Gordian Wallet suggests that you keep that key offline, preferably etched in metal, this autonomous example instead protects it in an automated manner using SSKR.

That third key is the recovery key, which is used to sweep funds forward if either of the other two keys is lost. It is sharded into three parts with a threshold of two. One shard is kept by the user in his cloud backup, a second by the company providing the service, and a third by a trusted friend. None of these entities can do anything with their single shard, and in addition the act of reconstructing the key doesn't introduce new danger since two keys are needed for usage. But, if a user ever loses a primary key, he can reconstuct this recovery key to ensure he doesn't lose his funds.

