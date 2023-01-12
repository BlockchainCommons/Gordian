# Noncorrelation

A discussion of noncorrelation, salt, and related concepts.

## Overview

This document discusses noncorrelation and related concepts. It introduces terminology, then analyzes Secure Components from the standpoint of noncorrelation, then introduces the opt-in decorrelation capabilities built into the `Envelope` type.

## Definitions

### Image and Projection

This document uses the term *image* to mean the input to an algorithm *f* and *projection* to mean the result of *f(image)*:

```
let projection = f(image)
```

### Correlatability, Noncorrelatability

Bit sequences are said to be *correlatable* if by examining them there is a way to determine whether they are projections of the same image. If there is no practical way to learn whether a set of sequences are projections of a common image, they are said to be *noncorrelatable*.

### Quasicorrelatability

Between projections that are definitely correlatable and definitely noncorrelatable, there are projections that may leak a little information about their image, specifically: it's size.

If multiple projections of the same image produce entirely noncorrelatable bit sequences, but the size of the projections are dependent on the size of the image, then the sequences are said to be *quasicorrelatable*. For example, if a function *f* always produces a projection that is the same number of bits as the image, or some fixed number of bits greater than the image, then the images are quasicorrelatable.

### Decorrelation

*Decorrelation* is a correction for quasicorrelation through obfuscating the size of the image. By adding a pad of random bits to an image before projecting it, projections may be produced that may be of uniform size, or of sufficiently varying size. Either way the intent is that the size of a projection tells an observer nothing useful about the image, except that its size must be less than or equal to its projection.

## Signatures are Noncorrelatable

In Secure Components, a `Signature` is produced using:

* the Schnorr signature algorithm
* the original message (“image”)
* a private key, and
* entropy

Because of the use of entropy, two such `Signature`s produced from a single image will contain entirely different bit sequences, and yet both will still validate against the image. Furthermore, all signatures are the same size regardless of the size of the image: 64 bytes, so the size of the signature provides no clue as to the contents of the image. Therefore there is no way, without the image and the public key corresponding to the private key used to produce it, for a third-party to determine that the two signatures were derived from that image, or even that they were derived from the same image. Therefore, `Signature`s are noncorrelatable.

## Digests are Correlatable

Like `Signature`, a `Digest` in Secure Components is a *lossy* operation (BLAKE3): there is no way that the image or any information about the image can be recovered from the projection. However, unlike `Signature`,  `Digest` *is* correlatable by design: two `Digests` produced from the same image are always equal, and a specific `Digest` could *only* have been produced from a specific image. Therefore if one can determine the image used to produce one of the `Digest`s, then one knows that the same image must have produced the other.

## Encrypted Messages are Quasicorrelatable

In Secure Components, an `EncryptedMessage` is produced by a lossless operation that also uses entropy (IETF-ChaCha20-Poly1305). Because of the use of entropy, the bits of the ciphertext are noncorrelatable. But because the size of the ciphertext is always identical to the size of the plaintext, an `EncryptedMessage` is quasicorrelatable. This extends to constructs such as `SealedMessage` that incorporate `EncryptedMessage`.

Decorrelation of an `EncryptedMessage` could be accomplished by adding some number of bits to the plaintext before encryption. However the problem arises as to how to distinguish bits of the original plaintext from bits of the pad, which are to be thrown away upon decryption. In Secure Components, the `Envelope` type offers an elegant solution to this problem, described below.

## SSKRShares are Correlatable

SSKR breaks (*shards*) a fixed-length (32 byte) secret into a number of *shares*, a threshold of which can be used to recover the secret. Because the secret is always of a fixed, predermined length, the shares produced by SSKR are, by themselves, noncorrelatable. However, each SSKR share contains metadata that can be used for correlation, and in particular, a 16-bit session ID that identifies each share as having been produced by the same sharding operation.

This correlatability is inherited by the set of `Envelope`s produced by the `Envelope.split` function, as each envelope carries an assertion with an `SSKRShare` produced by sharding an ephemeral symmertric content key.

Furthermore, the payload itself is encrypted into an `EncryptedMessage` using this content key, and because the `EncryptedMessage` is the same in every envelope, every one of these envelopes is correlatable by both its SSKR share and its identical `EncryptedMessage`.

To mitigate this:

* The SSKR algorithm would have to be enhanced to make its shares non-correlatable. Removing the session ID is the obvious first step, but doing this has downsides. The session ID is a check on foreign shares being introduced into the recovery process, and removing the session ID would make it impossible for an SSKR decoder to reject a share interactively: only upon receiving a quorum of shares and performing the secret recovery could the secret be checked for validity, for example by attempting to use the possibly-recovered secret as a key for decoding the payload. Even if the session ID were removed, an SSKR share contains other metadata such as the share index, member threshold, group index, group count, and group threshold that could still be used to (more weakly) correlate a set of shares.
* Rather than including the identical `EncryptedMessage` in every `Envelope`, they would each contain a unique `EncryptedMessage`, produced by the same key, but from a plaintext that has undergone decorrelation.

Combining a noncorrelatable SSKR share with a decorrelated encrypted payload would maximize noncorrelation for sharded payloads of arbitrary size.

## Decorrelation in Secure Components

In Secure Components, an `Envelope` is a Merkle tree, where every element produces its own `Digest`:

* The `Envelope` as a whole,
* The `subject` of the `Envelope`, which *may* be an `Envelope`,
* Each `Assertion` on the `subject`, which is itself an `Envelope`,
* Each `predicate` of each `Assertion`, which is itself an `Envelope`,
* Each `object` of each `Assertion`, which is itself an `Envelope`.

Each of these element `Digest`s is rolled up into the next higher `Digest` in the tree:

* each `predicate` digest and `object` digest are used to form the `assertion` digest,
* All the assertion digests (in sorted order) and the `subject` digest are used to form the `Envelope` digest.

Therefore, a change to any element of an `Envelope` propagates upwards and impacts every digest up that branch of the tree.

The tree itself inherits the correlatability of its elememts. So an `Envelope` just containing a simple plaintext string will have the same envelope digest, and hence the same identity, as another `Envelope` containing just that same simple plaintext string.

On the other hand, envelopes containing only elements that are noncorrelatable, or quasicorrelatable, inherit those attributes. For example, consider a message that has been signed then encrypted:

```
ENCRYPTED [
    verifiedBy: Signature
]
```

In the above:

* the `EncryptedMessage` subject is quasicorrelatable, because it was constructed with entropy, but the ciphertext is the same length as the plaintext,
* the `verifiedBy` predicate is correlatable, because it is a well-known value, and
* the `Signature` is noncorrelatable, because it was constructed with entropy.

If the assertion is elided, we get:

```
ENCRYPTED [
    ELIDED
]
```

When elided, each element is replaced with its `Digest`, preserving the Merkle tree. `Digests` by themselves are noncorrelatable, but an attacker could infer certain things from the structure and positioning of the elements:

* the elided assertion's `Digest` is noncorrelatable because it includes a `Signature`, which was generated using entropy and so the `Digest` inherits its noncorrelatability.
* As described above, the `EncryptedMessage` is quasicorrelatable.

In general, a completely elided assertion (`ELIDED`) inherits the maximum noncorralatability of either its predicate or object. If only the predicate is elided (`ELIDED: object`) or only the object is elided (`predicate: ELIDED`), or both are individually elided but not the assertion as a whole (`ELIDED: ELIDED`), and noncorrelatability is desired, then each element must be analyzed separately.

## Opt-In Decorrelation in Secure Components

The `Envelope` type provides the `addSalt()` method that adds a `salt: Data` assertion, where the data is a random number of random bytes.

* For small objects, the number of bytes added will generally be from 8...16.
* For larger objects the number of bytes added will generally be from 5%...25% of the size of the object.

Adding salt to an element changes the `Digest` of the element and all elements up to the root of the Merkle tree. Therefore, when noncorralatability is desired, it should be added to the construction of the `Envelope` before other constructs like signatures that depend on the stability of the Merkle tree.

Code to create a simple envelope:

```swift
let e1 = Envelope("Alpha")
    .add(.note, "Beta")
```

The above in Envelope Notation:

```
"Alpha" [
    note: "Beta"
]
```

The same content, but with every element salted.

```swift
let e1 = Envelope(Envelope("Hello").addSalt())
    .addAssertion(Envelope(KnownValue.note).addSalt(), Envelope("Beta").addSalt())
```

```
{
    "Alpha" [
        salt: Salt
    ]
} [
    note [
        salt: Salt
    ]
    : "MyNote." [
        salt: Salt
    ]
]
```

Any or all elements of this salted `Envelope` could be elided with a high degree of noncorrelatability.
