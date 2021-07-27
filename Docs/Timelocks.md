# Using Timelocks to Protect Digital Assets

**WARNING:** :warning: This is an unedited preliminary draft that was written as an investigation of current Timelock integration. We expect to finalize it when Timelocks are better integrated into Bitcoin Core. This document has not been reviewed, so please consider it with care.

Timelocks are a simple Bitcoin tool that can be used to disallow coins from being spent until a certain time. 

In conjunction with other locking mechanisms, such as signatures and multisigs, timelocks can act as an escape hatch, allowing the recovery of coins even if the main locking mechanism becomes unusable.

## Creating a Simple Timelock Script

The `nlocktime` variable can be used on its own to prevent a transaction from being placed on the blockchain until the appropriate time. However, timelocks scripts are much more powerful because they can be applied not to transactions, but to UTXOs. They are the focus of this article.

Timelock scripts comes in two varieties, each of which can be used in two ways:

| Name | Type | Height | Time |
|----|---|---|---|
| CHECKLOCKTIMEVERIFY (CLTV) | Absolute | < 500M | >= 500M |
| CHECKSEQUENCEVERIFY (CSV) | Relative | < 500M | >= 500M |

This article focuses on `CHECKLOCKTIMEVERIFY`, where you either set an absolute block height (< 500M) or an absolute UNIX time (>= 500M), and the script can not be processed until that height or time is reached.

The alternative is `CHECKSEQUENCEVERIFY`, which instead lets you set a relative blockheight or UNIX time, but it's somewhat tricky to use, because it's relative to the mining of an input into a transaction.

A timelock script is very easy to create. It just looks as follows:
```
1737417600 OP_CHECKLOCKTIMEVERIFY
````
If converted into a script for a P2WSH transaction, this would not allow the transaction to spent until the morning of January 20, 2025.

However, that's obviously insufficient, because with no other additions, that transactions could be spent by _anyone_ at the appropriate time. So, a timelock is usually a part of a longer script.

The following adopts that simple timelock into the standard P2PKH script formulation:
```
1737417600 OP_CHECKLOCKTIMEVERIFY OP_DROP OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
```
The `1737417600 OP_CHECKLOCKTIMEVERIFY` checks the current time against January 20, 2025; the `OP_DROP` throws out the `1737417600` value, which would is left on the stack by `OP_CHECKLOCKTIMEVERIFY`, and then the `OP_DROP OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG` will check the included `PubKeyHash` against a public key and a related signature, via the standard methodology for [Running a P2PKH script](https://github.com/BlockchainCommons/Learning-Bitcoin-from-the-Command-Line/blob/master/09_4_Scripting_a_P2PKH.md#run-a-p2pkh-script) (and similarly, a P2WPKH script).

The purpose of a script like this is to prevent someone from spending assets until a certain time, which might be beneficial for creating a trust, a retirement account, or an annuity. However, timelocks can do a lot more than that.

> _:warning: **WARNING:** Timelocks should be relatively constrained to future proof against possible cryptographic hacks. Six months or less is what we suggest in this article. Going larger than that increases the odds that you might lose money because someone hacked an alogrithm and you were unable to retrieve your money quickly._

## Adding a Timelock to a Multisig

As noted in the introduction, one powerful use of timelocks is to create an "escape hatch", where you can make funds primarily accessible via one means, but then use a conditional statement in a script to additionally make them accessible via a single timelocked address after a certain amount of time. This allows for normal operation of a script, with the timelock only being used in an emergency, such as if a key were lost or a holder passed away.

One such usage might be with an [autonomous multisig](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Multisig.md#examples-autonomous-multisig), where a 2-of-3 multisig is used by a self-sovereign Bitcoin holder to protect his funds with minimal Single Points of Failure (SPOFs) or Single Points of Compromise (SPOCs). Because of the design, if a single key is lost or stolen, the funds aren't compromised, but there nonetheless remains one final SPOF: the holder himself. If he were to become incapacitated, the funds might no longer be accesesible. 

That's where a Timelock can come in: a timelock is set six months out as an alternate branch of the script. When that timelock expires, an alternate key, probably held by an executor or custodian, can unlock the funds by retrieving them from a timelocked beneficiary address.

Traditionally, this was done by creating an arbitrary script with a conditional such as `OP_IF` or `OP_NOTIF`. It was hard to do and even harder to verify.

### Using Minisig for Complex Signatures

Enter [miniscript](https://medium.com/blockstream/miniscript-bitcoin-scripting-3aeff3853620), a recent addition to Bitcoin that allows for the verifiable and readable creation of simple scripts.

The script being discussed here, allowing for a multisig or a timelocked beneficiary sig can be constructed in miniscript as follows:
```
or_d(multi(2,A,B,C), and_v(pkh(D),after(1737417600)))
```
This says that there are 

The [miniscript analyzer](http://bitcoin.sipa.be/miniscript/) converts this as follows:
```
2 <A> <B> <C> 3 OP_CHECKMULTISIG OP_IFDUP OP_NOTIF
  OP_DUP OP_HASH160 <HASH160(D)> OP_EQUALVERIFY OP_CHECKSIG <80e38e67>
  OP_CHECKLOCKTIMEVERIFY
OP_ENDIF
```

This money could then be retrieved with:
```
0 <SigABorC> <DiffSigABorC>
```

This is the initial test. The leading `0` is required due to a beck in `OP_CHECKMULTISIG`.

After the timelock it could also be retrieved with:
```
0 0 0 <sigD> <PubKeyD> 
```
This is the branch if the initial test fails. The `0 0 0` are needed to fill in the leading `0` and the two signatures for the `OP_CHECKMULTISIG` test (and could actually be anything). We then drop through to a standard P2PKH test, and if that succeeds, we additional test that the locktime set in `nlocktime` is greater or equal to `80e38e67`, which is `1737417600` in hex.

### Alternative Methods

This document focuses on using miniscript, because of its advantages of simplicity and verifiability.

If one were constructing this script by hand, there would be several alternative ways to create the script:

1. **Require a True/False.** A time-honored method for creating branching scripts is to use an OP_IF to detect a TRUE/FALSE at the top of the stack, and then to take a branch based on that choice.

2. **Decide Based on Stack Size.** In this specific example, we could check the size of the stack with `OP_DEPTH` and choose a branch based on that depth, which would be `3` for the multsig or `2` for the timelocked sig: `OP_DEPTH OP_2 OP_EQUAL OP_IF`. This allows for the simple entry of either the multisig or the single sig, without having to worrying about branches.

The main reason to avoid these alternatives is that they are not built using miniscript.

## Creating a Timelock Address

The other advantage of miniscripts is that they came out of work on output descriptors, and are quickly converging back into descriptor work. This means that in the near future they will be usable to create descriptor wallets that can generate an infinite number of addresses for some sorts of arbitrary scripts, something that was previously not doable.

This functionality has been integrated into Bitcoin Core as of 0.21.

However, there are two libraries that can be used to derive addresses from miniscript-style descriptors:

* [Rust-miniscript](https://github.com/rust-bitcoin/rust-miniscript) does so in Rust.
* [BDK](https://docs.rs/bdk/0.7.0/bdk/) also does so in Rust, but with [expansions](https://bitcoindevkit.org/descriptors/) for derivable keys such as xpubs and xprvs.

## Storing Script Information

Whenever you create a script you _must_ store the redeem script, as it will be necessary to recover the funds from the address. Tehcnically, the redeem script also contains all of the information that you need to update the script (as described below), because it contains all of the variables in either scripted or serialized form.

However, for clarity you'll also usually want to store your individual building blocks, which is to say the variables in the miniscript: the multisig public keys, the beneficiary public key hash, the timelock time, and the timelock length.

## Updating a Timelock Script

Once you've created a timelock script, _all_ of the information is baked in. That obviously includes the type of timelock, the time or block that it's locked to, and the timelocked beneficiary address. 

However a timelock will often be applied in conjunction with other scripting, in which case all of _that_ information is baked in too. In the example used in this article, that also means all of the multisig information.

A timelock script _cannot_ be simply regenerated or updated. Instead, a new script must be created that to vary any of this information — usually the timelock time or block, the timelocked recipient, or recipients in another branch of the script. The funds must then be swept forward to that address. 

## Renewing a Timelock Script

Addresses supported by timelocks _must_ be renewed before the timelock expires under normal situations. If you do not do so, whatever normal protections you have on the account will expire, and the funds will become immediately payable to timelocked beneficiary address. This is usually not desirable, because in the typical situation the timelocked address will be less secure than the normal address, such in this example where the normal address is a multisig and the timelocked beneficiary is single-sig address.

Since we've already noted that timelock addresses cannot simply be updated, this means that you must generate a new account and sweep all the funds from the old account to the new account.

## Sweeping Funds Regularly

The easiest way to sweep funds is to wait until shortly before the expiration of the timelock, then sweep all the funds into a new account at that time.

This has the benefit of simplicity and the deficit of having the highest potential cost.

## Sweeping Funds Progressively

An alternative method is to sweep funds forward progressively, as the result of standard transactions within an account. In this case, rather than just creating a single account with a timelock at time `current+n`, a second account should be created at time `current+2*n`.

In this case, whenever funds are spent, the account with timelock `n` is used, and change is sent to account with timelock `2*n`. 

* If there is insufficient funds in account `n` to make a purchase, then `2*n` is used instead, with change looping back to account `2*n`.
* If the last transactions are spent out of account `n`, then the account is abandoned, and a new account `current+2*n` is created, with a timelock set based on the then-current time.
* If there are still funds in the `n` account when that time nears, then all funds are transferred on to `2*n`, and a new account is created at `current+2*n`.

Obviously, there is more complexity here, and some tuning may be required to find a good value `n` (and thus `2*n`) for any user, so that `2*n` is short enough to be safe, but `n` is long enough that an account is liable to empty out before the timelock is reached.

## Future Thoughts

Because of the limitations currently present in the integration between timelocks, miniscript, and descriptor wallets, we may need to offer alternatives for the present.

Possibilities include:

1.) CLI integration. A Rust miniscript CLI tool could be built to generate addresses from a miniscript and pass them on to bitcoin-cli (or a wallet).

2.) Plain nLockTime. A methodology could be laid out for generating transactions with nTimeLock and then sweeping funds before the nTimeLock comes due.

3.) Other Techniques. We should consider other techniques such as [Practical Revault](https://github.com/revault/practical-revault) and [Delegated Signatures](https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2021-March/018615.html).
