# Designing SSKR Share Scenarios

[SSKR](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-011-sskr.md) allows the sharding of secrets, such as cryptographic seeds, so that they can be reconstructed with a threshold number of the shares. It goes beyond traditional Shamir's Secret Sharing by also supporting a multi-level group methodology, where shares can be partitioned into groups, and reconstruction can then occur if a threshold of shares is recovered from a threshold of groups.

For SSKR to truly work as a part of a [#SmartCustody](https://www.smartcustody.com) solution requires careful thought as to what to do with the SSKR shares. Following are ways to secure shares for some standard SSKR scenarios, which match the default options in the [Gordian Seedtool reference app](https://github.com/blockchaincommons/GordianSeedTool-iOS).

These scenarios cover two different possibilities:

**Self-sovereign.** In this methodology, a single user keeps the shares himself, but partitions them such as they are unlikely to be destroyed all at once. This improves the resilience of the seed without meaningfully increasing the attack surface, as would occur if a complete seed were stored in multiple locations.

**Social recovery.** In this methodology, keys are predominantly given out to friends, family, business associates, etc. The social group or groups are then able to aid in the reconstruction of the key if it is lost. This increases the partitioning of the shares by ensuring they're much more disconnected, and if done carefully doesn't notably increase the attack surface, because recovering a threshold of shares from a variety of disconnected parties can be a very difficult proposition.

**Corporate recovery.** This methodology is a variant of social recovery, where the shares are given out to employees of a company, to enable the recovery of a business' keys.

## 1 of 1 Shares

This is a simple encoding of the seed as [Bytewords](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-012-bytewords.md), resulting in a single share that can be used to entirely recover the seed. It is not a true sharding. It may be somewhat more resilient than traditional BIP-39 words, because of the carefully methodology that was used to pick Bytewords, but less than using another method, such as a QR of a `ur:crypto-seed`, which would be self-identifying.

**Self-sovereign.** Maintain the share in an extremely secure location such as a safe that you personally control.

**Social or corporate recovery.** Give the share to someone with whom you have a fiduciary relationship, such as a lawyer or an accountant, who is required to work in your best interest, and ensure that they store in an extremely secure location that only they have access to.

## 2 of 3 Shares

This is probably the most common use of SSKR, where three shares are created, any two of which can be used to retrieve the secret. No single share can be used to recover your secret, so you don't need the same extreme secret required by a 1-of-1 share, but you nonetheless want to ensure that they're well divided, so that no one else can combine them, and that they're secure enough that they're be able for recovery when required.

**Self-sovereign.** Place your shares in three different locations. Work and home are often two good choices. A bank safety deposit box is the ideal third choice, but barring that, the third share could instead be kept with close family members, such as parents. Ideally, these shares are always locked up, to prevent them from being stolen, which would deny your access to them. However barring that, it's most important to keep them somewhere where they'll be easy to find and not subject to being lost or accidentally thrown out.

**Social recovery.** At least two shares should be given to friends, family, or business associates. Ideally these shares should be partitioned: the two recipients should not have a direct connection between each other. It should also be ensured that they can store the share safely. [Gordian QR Tool](https://www.blockchaincommons.com/quarterlies/Q2-2021-Report/) is a great place to have them store shares that have been encoded as QRs. The owner of the seed can keep the third share, if they have a safe place to store it that separates it from the devices that contain the seed itself (such as a place or work or a bank). Alternatively, they can give it out to a third person.

**Corporate recovery.** Three shares can be given to three people who already have financial responsibility within the company. This create a dual-control situation for key reconstruction. Ideally, the three people are physically separated, such as in different offices. Some of these shares might be stored in safety deposit boxes associated with the company, others in safes or vaults at the company itself, or at worst locked and safe drawers. Places with logged access are also a good option. They should not be taken to personal domiciles.

## 3 of 5 Shares

A 3-of-5 is an expansion of a 2-of-3 that should be used if you have less belief in the stability of the recipients of shares. It might also be used if you have more places to securely store shares. 

**Self-sovereign/hybrid.** A single person is unlikely to have 5 distinct places to safely store shares, but they could use a hybrid model, storing 3 shares themselves (as with the 2-of-3 scenario) to ensure the _possibility_ of entirely self-sovereign reconstruction, but then giving out two shares to friends, family, or business associates.

**Social recovery.** While the 2-of-3 scenario is likely the most common, 3-of-5 might be better for a social recovery model. Keys can be given out to a wider number of friends and family, with the need to only recover three of them. There's also a little less concern about ensuring that every share-holder doesn't know the others. Though that's still ideal, a pair of shareholders who know each other but no one else, cannot reconstruct the original secret. In this situation, the seed owner might choose to hold on to one or even two of them, if they can be partioned from each other and the devices with the seed.

**Corporate recovery.** This is a fair alternative for corporate recovery. Increasing to 5 shares lessens the company's control over the seed, but increases the resilience, which is important in a corporate situation where employees might come or go.

## 4 of 9 Shares

The 4-of-9 scenario is likely the greatest extent that you'll ever go in dividing up shares. It unleashes a large number of shares into the world, and lets you recover with any four of them.

**Self-sovereign/hybrid.** A 4-of-9 scenario is unlikely to be used for self-sovereign holdings, as no individual is going to reasonably have 9 places that they can store shares safely. A person is even unlikely to have four secure locales, but if they did, they could keep four themselves, in those locale, and then give the other five out to friends, family, and business associates. However, in this hybrid format, the seed owner _must_ keep four shares himself, else it is not truly self-sovereign.

**Social recovery.** Though somewhat unwieldy, a 4-of-9 could be used for a social-recovery situation. As with the 3-of-5, there's a little less concern for those people knowing each other, but you should ensure that they cluster together in groups no larger than two or three: the more separate the holders of the shares are, the more resistant the seed is to attacks. Again, the seed owner might keep some of the shares himself, as long as he can keep them separated and separate from the original secret.

**Corporate recovery.** A large scenario such as a 4-of-9 is mostly likely to be used in a corporate recovery situation. In this situation it would be best for shares to be clearly linked to positions, to make them easy to track. In addition, at least six keys should be kept in the hands of people who make financial decisions for the company, either closely held or places in safety deposit boxes, bank vaults, or other storage locales used by the company. This ensures that the funds stay with the company.

## 2 of 3 Shares of two of three Groups

