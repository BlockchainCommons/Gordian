# Designing SSKR Share Methodologies

[SSKR](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-011-sskr.md) allows the sharding of secrets, such as cryptographic seeds, so that they can be reconstructed with a threshold number of the shares. It goes beyond traditional Shamir's Secret Sharing by also supporting a multi-level group methodology, where shares can be partitioned into groups, and reconstruction can then occur if a threshold of shares is recovered from a threshold of groups.

For SSKR to truly work as a part of a [#SmartCustody](https://www.smartcustody.com) solution requires careful thought as to what to do with the SSKR shares. Following are ways to secure shares for some standard SSKR scenarios, which match the default options in the [Gordian Seedtool reference app](https://github.com/blockchaincommons/GordianSeedTool-iOS).

These scenarios cover two different possibilities:

**Self-sovereign.** In this methodology, a single user keeps the shares himself, but partitions them such as they are unlikely to be destroyed all at once. This improves the resilience of the seed without meaningfully increasing the attack surface, as would occur if a complete seed were stored in multiple locations.

**Social recovery.** In this methodology, keys are predominantly given out to friends, family, business associates, employees, etc. The social group or groups are then able to aid in the reconstruction of the key if it is lost. This increases the partitioning of the shares by ensuring they're much more disconnected, and if done carefully doesn't notably increase the attack surface, because recovering a threshold of shares from a variety of disconnected parties can be a very difficult proposition.

## 1 of 1 SSKR

This is a simple encoding of the seed as [Bytewords](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-012-bytewords.md), resulting in a single share that can be used to entirely recover the seed. It is not a true sharding. It may be somewhat more resilient than traditional BIP-39 words, because of the carefully methodology that was used to pick Bytewords, but less than using another method, such as a QR of a `ur:crypto-seed`, which would be self-identifying.

**Self-sovereign.** Maintain the share in an extremely secure location such as a safe that you personally control.

**Social recovery.** Give the share to someone with whom you have a fiduciary relationship, such as a lawyer or an accountant, who is required to work in your best interest, and ensure that they store in an extremely secure location that only they have access to.

## 2 of 3 SSKR

