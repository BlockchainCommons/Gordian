# Designing SSKR Share Scenarios

[SSKR](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-011-sskr.md) allows the sharding of secrets, such as cryptographic seeds, so that they can be reconstructed with a threshold number of the shares. It goes beyond traditional Shamir's Secret Sharing by also supporting a multi-level group methodology, where shares can be grouped, and reconstruction can then occur if a threshold of shares is recovered from a threshold of groups.

Using SSKR should not be considered an alternative to using multisigs. We consider multisigs an all-around more secure solution for #SmartCustody because they do not require key material to all be collected on the same machine, which creates a security risk. In conjunction with that, multisigs can offer similar levels of resilience with [careful construction of multisig scenarios](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Multisig.md). Nonetheless, SSKR has very powerful uses for protecting single-sig addresses, and can even be used to back up seeds that are part of a multisignature.

## #SmartCustody Scenarios

For SSKR to truly work as a part of a [#SmartCustody](https://www.smartcustody.com) solution requires careful thought as to what to do with the SSKR shares. Following are ways to secure shares for some standard SSKR scenarios, which match the default options in the [Gordian Seedtool reference app](https://github.com/blockchaincommons/GordianSeedTool-iOS).

These scenarios cover three different methodologies ofr using SSKR:

**Self-sovereign.** In this methodology, a single user keeps enough of the shares himself to allow reconstruction of the key, but partitions them such as they are unlikely to be destroyed all at once. This improves the resilience of the seed without meaningfully increasing the attack surface, as would occur if a complete seed were stored in multiple locations.

**Social recovery.** In this methodology, sufficient keys are predominantly given out to friends, family, business associates, etc. to allow reconstruction of the key. The social group or groups are then able to aid in the reconstruction of the key if it is lost. This increases the partitioning of the shares by ensuring they're much more disconnected, and if done carefully doesn't notably increase the attack surface, because recovering a threshold of shares from a variety of disconnected parties can be a very difficult proposition. It also allows for secret reconstruction in the case of the death or disability of the seed holder.

**Corporate recovery.** In this methodology, which is a variant of social recovery, the shares are given out to employees of a company, to enable the reconstruction of a business' cryptographic secrets.

### 1 of 1 Shares

This is a simple encoding of the seed as [Bytewords](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-012-bytewords.md), resulting in a single share that can be used to entirely recover the seed. It is not a true sharding. It may be somewhat more resilient than traditional BIP-39 words, because of the carefully methodology that was used to pick Bytewords, but it is less resilient than using some other methods, such as a QR of a `ur:crypto-seed`, which would be self-identifying.

**Self-sovereign.** To maintain safety of your seed, you should keept this share in an extremely secure location such as a safe that you personally control.

**Social or corporate recovery.** Anyone else with this share could entirely recover your seed, so you should only give it to someone with whom you have a fiduciary relationship, such as a lawyer or an accountant that is required to work in your best interest. You should also ensure that they store in an extremely secure location that only they have access to.

### 2 of 3 Shares

This is probably the most common use of SSKR, where three shares are created, any two of which can be used to retrieve the secret. No single share can be used to recover your secret, so you don't need the same extreme security required by a 1-of-1 share, but you nonetheless want to ensure that they're well divided, so that no one else can combine them, and that they're secure enough that they'll be available for recovery when required.

**Self-sovereign.** Here you simply need to place your shares in three different locations. Work and home are often two good choices. A bank safety deposit box is the ideal third choice, but barring that, the third share could instead be kept with close family members, such as parents (creating the first example of a hybrid solution, combining a self-sovereign methodology with a bit of social recovery). Ideally, these shares are always locked up, to prevent them from being stolen, which would deny your access to them. However barring that, it's most important to keep them somewhere where they'll be easy to find and not subject to being lost or accidentally thrown out.

**Social recovery.** At least two shares should be given to friends, family, or business associates when using a 2-of-3 social recovery scenario. Ideally these shares should be partitioned: the two recipients should not have a direct connection between each other. You should also ensure that they can store the share safely. [Gordian QR Tool](https://www.blockchaincommons.com/quarterlies/Q2-2021-Report/) is a great place to have them store shares that have been encoded as QRs. The owner of the seed can keep the third share, if they have a safe place to store it that separates it from the devices that contain the seed itself (such as at work or a bank). Alternatively, they can give it out to a third person.

**Corporate recovery.** Three shares can be given to three people who already have financial responsibility within the company. This create a dual-control situation for key reconstruction. Ideally, the three people are physically separated, such as in different offices. Some of these shares might be stored in safety deposit boxes associated with the company, others in safes or vaults at the company itself, or at worst locked and safe drawers. Places with logged access are also a good option. They should not be taken to personal domiciles.

### 3 of 5 Shares

A 3-of-5 scenario is an expansion of a 2-of-3 scenario that should be used if you have less belief in the stability of the recipients of shares: it allows two shares to be lost rather than just one. It might also be used if you have more places to securely store shares. 

**Self-sovereign/hybrid.** A single person is unlikely to have five distinct places to safely store shares, but you could use a hybrid model, storing 3 shares yourself (as with the 2-of-3 scenario) to ensure the _possibility_ of entirely self-sovereign reconstruction, but then giving out two shares to friends, family, or business associates.

**Social recovery.** While the 2-of-3 scenario is likely the most common, 3-of-5 might be a better scenario for social recovery. Keys can be given out to a wider number of friends and family, with the need to only recover three of them. There's also a little less concern about ensuring that every share-holder doesn't know the others. Though doing so is still ideal, a pair of shareholders who know each other but no one else, cannot reconstruct the original secret. In a 3-of-5 scenario, the seed owner might choose to hold on to one or even two of the shares, if they can be partioned from each other and the devices with the seed.

**Corporate recovery.** This is a fair alternative for corporate recovery. Increasing to five shares lessens the company's control over the seed, but increases the resilience, which is important in a corporate situation where employees might come or go.

### 4 of 9 Shares

The 4-of-9 scenario is likely the greatest extent that you'll ever go to in dividing up shares. It unleashes a large number of shares into the world, and lets you recover with any four of them.

**Self-sovereign/hybrid.** A 4-of-9 scenario is unlikely to be used for self-sovereign holdings, as no individual is going to reasonably have nine places that they can store shares safely. A person is even unlikely to have four secure locales, but if they did, they could keep four shares themselves, in those partitioned locales, and then give the other five shares out to friends, family, and business associates. Note that in this hybrid format, the seed owner _must_ keep four shares himself, else it is not truly self-sovereign.

**Social recovery.** Though somewhat unwieldy, a 4-of-9 could be used for a social-recovery situation. As with the 3-of-5, there's a little less concern for those people knowing each other, but you should ensure that they cluster together in groups no larger than two or three: the more separate the holders of the shares are, the more resistant the seed is to attack. Again, the seed owner might keep some of the shares himself, as long as he can keep them separated and separate from the original secret. But to ensure social recovery, at least four keys must be with other people.

**Corporate recovery.** A large scenario such as a 4-of-9 is mostly likely to be used for a corporate recovery methodology. In this situation it would be best for shares to be clearly linked to positions, to make them easy to track. In addition, at least six keys should be kept in the hands of people who make financial decisions for the company, either closely held or placed in safety deposit boxes, bank vaults, or other storage locales used by the company. This ensures that the funds stay with the company.

### 2 of 3 Shares of Two of Three Groups

Multilevel SSKR allows for much more sophisticated sharing scenarios. They can be somewhat more fragile, as you might need a larger number of keys before you initiate recovery, but they also make it much easier to partition the keys so as to deny to inappropriate reconstruction of the original secret.

A 2-of-3, 2-of-3 is the most basic multilevel SSKR share. It divides nine shares into three groups. To reconstruct the key requires that two keys be used each from two different groups. That means that as few as four keys can reconstruct the secret (e.g., `2-2-0` from the different groups), but as many as five cannot (e.g., `1-1-3` from the different groups). This is clear example of the fragility possible in this approach.

**Self-sovereign/Social hybrid.** The most likely use of a multilevel SSKR setup is to create a hybrid self-sovereign/social-recovery #SmartCustody solution, with more security than a single-level scenario. In this situation, you could give out two shares from the first group to one social group (such as friends) and two shares from the second group to another social group (such as family or a separate group of friends). Finally, you'd give out one share from the final group, possibly to someone already holding a share. The remaining four shares, one from each of the first two groups and two from the last group would be kept by the seed owner and partitioned as much as possible, with the two shares from group three a requirement to separate. This means that in a nearly self-sovereign situation, the seed owner could recover his seed by recovering just a single share from either group one or two. In a partial-loss near-self-sovereign situation, they could recover with four or less shares, depending on what they lost. Finally, in a situation where the seed owner was incapacitated or killed, their successors could recover the seed by retrieving four shares from the two social groups (providing the seed owner recorded what he did!).

   1. First Social Group
      * Held by Friend #1
      * Held by Friend #2
      * Held by Owner
   2. Second Social Group
      * Held by Friend #3
      * Held by Friend #4
      * Held by Owner
   3. Personal
      * Held by Owner
      * Held by Owner
      * Held by Friend #1, #2, #3, #4, or #5
 
 **Corporate recovery.** A company could use the same recovery methodology as the self-sovereign/social hybrid, with the role of "owner" taken by a CFO, CEO, or Owner, and the roles of "friends" taken by different offices or organizations within the company:
 
   1. First Remote Office
      * Held by Employee #1
      * Held by Employee #2
      * Held by CFO
   2. Second Remote Office
      * Held by Employee #3
      * Held by Employee #4
      * Held by CFO
   3. Personal
      * Held by CFO
      * Held by CFO
      * Held by Employee #1, #2, #3, #4, or #5

A more complex methdology could ensure dual-control by splitting responsibility between a CFO and President:

   1. First Remote Office
      * Held by Employee #1, Recoverable by CFO
      * Held by Employee #2, Recoverable by CFO
      * Held by CFO
   2. Second Remote Office
      * Held by Employee #3, Recoverably by President
      * Held by Employee #4, Recoverable by President
      * Held by President
   3. Personal
      * Held by CFO
      * Held by President
      * Held by Employee, Recoverable by Board of Directors

In this situation, neither the CFO nor the President has the ability or authority to reconstruct the key on their own, but if one of them left the company without ensuring continuity, the Board could still step in to reconstruct the seed.

## Combining Scenarios

Each set of SSKR shares is distinct and discrete from each other one. Just as no individual share gives you more information about the secret itself, it's also the case that collecting shares that were sharded independently does not reveal anything more about the secret. As a result, individual gave be given shares from different shardings, as part of different scenarios, without decreasing the overall security.

For example, an individual with only two save locales might create a self-sovereign scenario as follows:

   1. Home Safe
   2. Bank Safety Deposit Box
   3. Friend #1

The scenario remains self-sovereign, as the seed owner can recover the seed totally on his own, but he also has a backup if something unexpected happens such as a fire at his house.

Meanwhile, the individual might _also_ want to create a social recovery scenario, to ensure his secret can be reconstructed if there is some cataclysmic disaster in his home town, and so he creates a 3-of-5 social recovery as follows:
 
  1. Home Safe
  2. Friend #1
  3. Friend #2
  4. Dad
  5. Boss

Though Friend #1 is now holding two different shares, there is no overlap between the shardings, and so this gives no additional insight into the secret (nor does the fact that there are two different shares held in the same Home Safe).

## Maintaining #SmartCustody Scenarios

Creating a scenario is just the first step: it also needs to be maintained. As discussed in [the #SmartCustody book](https://bit.ly/SmartCustodyBookV101), you should be checking on your entire backup setup at least once a year (see Steps N to O of the #Smartcustody scenario, pages 71-72 of v1.01). So, for a SSKR scenario, you might check your self-sovereign shares in Spring, then your social-recovery shares in Fall, or something similar. The goal is to make sure that every year you know that every share still exists, and that it looks to still be in its complete form.

What you probably _don't_ want to do is test the reconstruction. That introduces a point of vulnerability, because your entire seed is suddenly available on one device. If you can do this on an entirely non-networked device, such as [Seed Tool on an iPod Touch](https://apps.apple.com/us/app/gordian-seed-tool/id1545088229), then the danger is perhaps worth it. Otherwise, you should only reconstruct your seed at the point that you're ready to sweep your funds on to a new address.
