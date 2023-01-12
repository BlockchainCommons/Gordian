# Existence Proofs

## Introduction

Because each element of an envelope provides a unique digest, and because changing an element in an envelope changes the digest of all elements upwards towards its root, the structure of an envelope is comparable to a [Merkle tree](https://en.wikipedia.org/wiki/Merkle_tree).

In a Merkle Tree, all semantically significant information is carried by the tree's leaves (for example, the transactions in a block of Bitcoin transactions) while the internal nodes of the tree are nothing but digests computed from combinations of pairs of lower nodes, all the way up to the root of the tree (the "Merkle root".)

In an envelope, every digest points at some potentially useful semantic information: at the subject of the envelope, at one of the assertions in the envelope, or at the predicate or object of a given assertion. Of course, those object are all envelopes themselves, so by using salt, the digest of the element can be decorrelated from its content.

In a merkle tree, the minumum subset of hashes necessary to confirm that a specific leaf node (the "target") must be present is called a "Merkle proof." For envelopes, an analogous proof would be a transformation of the envelope that is entirely elided but preserves the structure necesssary to reveal the target.

## Example 1: Alice's Friends

This document contains a list of people Alice knows. Each "knows" assertion has been salted so if the assertions have been elided one can't merely guess at who she knows by pairing the "knows" predicate with the names of possibly-known associates and comparing the resulting digests to the elided digests in the document.

```swift
let aliceFriends = Envelope("Alice")
    .addAssertion("knows", "Bob", salted: true)
    .addAssertion("knows", "Carol", salted: true)
    .addAssertion("knows", "Dan", salted: true)
```

```
"Alice" [
    {
        "knows": "Bob"
    } [
        salt: Salt
    ]
    {
        "knows": "Carol"
    } [
        salt: Salt
    ]
    {
        "knows": "Dan"
    } [
        salt: Salt
    ]
]
```

Alice provides just the root digest of her document to a third party. This is simply an envelope in which everything has been elided and nothing revealed.

```swift
let aliceFriendsRoot = try aliceFriends.elideRevealing([])
```

```
ELIDED
```

Now Alice wants to prove to the third party that her document contains a "knows Bob" assertion. To do this, she produces a proof that is an envelope with the minimal structure of digests included so that the proof envelope has the same digest as the completely elided envelope, but also exposes the digest of the target of the proof.

Note that in the proof the digests of the two other elided "knows" assertions are present, but because they have been salted, the third party cannot easily guess who else she knows.

```swift
let knowsBobAssertion = Envelope("knows", "Bob")
let aliceKnowsBobProof = aliceFriends.proof(contains: knowsBobAssertion)!
```

```
ELIDED [
    ELIDED [
        ELIDED
    ]
    ELIDED (2)
]
```

The third party then uses the previously known and trusted root to confirm that the envelope does indeed contain a "knows bob" assertion.

```swift
XCTAssertTrue(aliceFriendsRoot.confirm(contains: knowsBobAssertion, using: aliceKnowsBobProof))
```

## Example 2: Verifiable Credential

A verifiable credential is constructed such that elements that might be elided are also salted, making correlation between digest and message much more difficult. Other assertions like `.issuer` and `.controller` are left unsalted.

```swift
let cid = Envelope(CID(‡"4676635a6e6068c2ef3ffd8ff726dd401fd341036e920f136a1d8af5e829496d")!)
let credential = try cid
    .addAssertion("firstName", "John", salted: true)
    .addAssertion("lastName", "Smith", salted: true)
    .addAssertion("address", "123 Main St.", salted: true)
    .addAssertion("birthDate", Date(iso8601: "1970-01-01"), salted: true)
    .addAssertion("photo", "This is John Smith's photo.", salted: true)
    .addAssertion("dlNumber", "123-456-789", salted: true)
    .addAssertion("nonCommercialVehicleEndorsement", true, salted: true)
    .addAssertion("motorocycleEndorsement", true, salted: true)
    .addAssertion(.issuer, "State of Example")
    .addAssertion(.controller, "State of Example")
    .wrap()
    .sign(with: alicePrivateKeys)
    .addAssertion(.note, "Signed by the State of Example")

let credentialRoot = try credential.elideRevealing([])
```

In this case the holder of a credential wants to prove a single assertion from it: the address.

```swift
let addressAssertion = Envelope("address", "123 Main St.")
let addressProof = credential.proof(contains: addressAssertion)!
```

The proof includes digests from all the elided assertions.

```
{
    ELIDED [
        ELIDED [
            ELIDED
        ]
        ELIDED (9)
    ]
} [
    ELIDED (2)
]
```

The proof confirms the address, as intended.

```swift
XCTAssertTrue(credentialRoot.confirm(contains: addressAssertion, using: addressProof))
```

Assertions without salt can be guessed at, and confirmed if the the guess is correct.

```swift
let issuerAssertion = Envelope(.issuer, "State of Example")
XCTAssertTrue(credentialRoot.confirm(contains: issuerAssertion, using: addressProof))
```

The proof cannot be used to confirm salted assertions.

```swift
let firstNameAssertion = Envelope("firstName", "John")
XCTAssertFalse(credentialRoot.confirm(contains: firstNameAssertion, using: addressProof))
```
