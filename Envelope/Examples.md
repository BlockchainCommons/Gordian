# Examples

High-level examples of API usage.

## Overview

This article includes a set of high-level examples of API usage in Swift involving `Envelope`.

## Status

These examples are actual, running unit tests in this package. The document and implementation as a whole are considered a draft.

## Common structures used by the examples

The unit tests define a common plaintext, and `CID`s and `PrivateKeyBase` objects for *Alice*, *Bob*, *Carol*, *ExampleLedger*, and *The State of Example*, each with a corresponding `PublicKeyBase`.

```swift
let plaintextHello = "Hello."

let symmetricKey = SymmetricKey(‡"38900719dea655e9a1bc1682aaccf0bfcd79a7239db672d39216e4acdd660dc0")!

let aliceIdentifier = CID(‡"d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f")!
let aliceSeed = Seed(data: ‡"82f32c855d3d542256180810797e0073")!
let alicePrivateKeys = PrivateKeyBase(aliceSeed)
let alicePublicKeys = alicePrivateKeys.publicKeys

let bobIdentifier = CID(‡"24b5b23d8aed462c5a3c02cc4972315eb71a6c5fdfc0063de28603f467ae499c")!
let bobSeed = Seed(data: ‡"187a5973c64d359c836eba466a44db7b")!
let bobPrivateKeys = PrivateKeyBase(bobSeed)
let bobPublicKeys = bobPrivateKeys.publicKeys

let carolIdentifier = CID(‡"06c777262faedf49a443277474c1c08531efcff4c58e9cb3b04f7fc1c0e6d60d")!
let carolSeed = Seed(data: ‡"8574afab18e229651c1be8f76ffee523")!
let carolPrivateKeys = PrivateKeyBase(carolSeed)
let carolPublicKeys = carolPrivateKeys.publicKeys

let exampleLedgerIdentifier = CID(‡"0eda5ce79a2b5619e387f490861a2e7211559029b3b369cf98fb749bd3ba9a5d")!
let exampleLedgerPrivateKeys = PrivateKeyBase(Seed(data: ‡"d6737ab34e4e8bb05b6ac035f9fba81a")!)
let exampleLedgerPublicKeys = exampleLedgerPrivateKeys.publicKeys

let stateIdentifier = CID(‡"04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8")!
let statePrivateKeys = PrivateKeyBase(Seed(data: ‡"3e9271f46cdb85a3b584e7220b976918")!)
let statePublicKeys = statePrivateKeys.publicKeys
```

A `PrivateKeyBase` is derived from a source of key material such as a `Seed`, an `HDKey`, or a `Password` that produces key material using the Scrypt algorithm.

A `PrivateKeyBase` is kept secret, and can produce both private and public keys for signing and encryption. A `PublicKeyBase` is just the public keys extracted from a `PrivateKeyBase` and can be made public. Signing and public key encryption is performed using the `PrivateKeyBase` of one party and the `PublicKeyBase` from another.

**Note:** Due to the use of randomness in the cryptographic constructions, separate runs of the code are extremly unlikely to replicate the exact CBOR or URs.

## Example 1: Plaintext

In this example no signing or encryption is performed.

```swift
// Alice sends a plaintext message to Bob.
let envelope = try Envelope(plaintextHello)
let ur = envelope.ur

// Alice ➡️ ☁️ ➡️ Bob

// Bob receives the envelope and reads the message.
let receivedPlaintext = try Envelope(ur: ur)
    .extractSubject(String.self)
XCTAssertEqual(receivedPlaintext, plaintextHello)
```

### Envelope Notation

```
"Hello."
```

## Example 2: Signed Plaintext

This example demonstrates the signature of a plaintext message.

```swift
// Alice sends a signed plaintext message to Bob.
let envelope = try Envelope(plaintextHello)
    .sign(with: alicePrivateKeys)
let ur = envelope.ur

// Alice ➡️ ☁️ ➡️ Bob

// Bob receives the envelope.
let receivedEnvelope = try Envelope(ur: ur)

// Bob receives the message, verifies Alice's signature, and reads the message.
let receivedPlaintext = try receivedEnvelope.verifySignature(from: alicePublicKeys)
    .extractSubject(String.self)
XCTAssertEqual(receivedPlaintext, plaintextHello)

// Confirm that it wasn't signed by Carol.
XCTAssertThrowsError(try receivedEnvelope.verifySignature(from: carolPublicKeys))

// Confirm that it was signed by Alice OR Carol.
try receivedEnvelope.verifySignatures(from: [alicePublicKeys, carolPublicKeys], threshold: 1)

// Confirm that it was not signed by Alice AND Carol.
XCTAssertThrowsError(try receivedEnvelope.verifySignatures(from: [alicePublicKeys, carolPublicKeys], threshold: 2))
```

### Envelope Notation

```
"Hello." [
    verifiedBy: Signature
]
```

## Example 3: Multisigned Plaintext

This example demonstrates a plaintext message signed by more than one party.

```swift
// Alice and Carol jointly send a signed plaintext message to Bob.
let envelope = try Envelope(plaintextHello)
    .sign(with: [alicePrivateKeys, carolPrivateKeys])
let ur = envelope.ur

// Alice & Carol ➡️ ☁️ ➡️ Bob

// Bob receives the envelope and verifies the message was signed by both Alice and Carol.
let receivedPlaintext = try Envelope(ur: ur)
    .verifySignatures(from: [alicePublicKeys, carolPublicKeys])
    .extractSubject(String.self)

// Bob reads the message.
XCTAssertEqual(receivedPlaintext, plaintextHello)
```

### Envelope Notation

```
"Hello." [
    verifiedBy: Signature
    verifiedBy: Signature
]
```

## Example 4: Symmetric Encryption

This examples debuts the idea of an encrypted message, based on a symmetric key shared between two parties.

```swift
// Alice and Bob have agreed to use this key.
let key = SymmetricKey()

// Alice sends a message encrypted with the key to Bob.
let envelope = try Envelope(plaintextHello)
    .encryptSubject(with: key)
let ur = envelope.ur

// Alice ➡️ ☁️ ➡️ Bob

// Bob receives the envelope.
let receivedEnvelope = try Envelope(ur: ur)

// Bob decrypts and reads the message.
let receivedPlaintext = try receivedEnvelope
    .decryptSubject(with: key)
    .extractSubject(String.self)
XCTAssertEqual(receivedPlaintext, plaintextHello)

// Can't read with no key.
try XCTAssertThrowsError(receivedEnvelope.extractSubject(String.self))

// Can't read with incorrect key.
try XCTAssertThrowsError(receivedEnvelope.decryptSubject(with: SymmetricKey()))
```

### Envelope Notation

```
ENCRYPTED
```

## Example 5: Sign-Then-Encrypt

This example combines the previous ones, first signing, then encrypting a message with a symmetric key.

```swift
// Alice and Bob have agreed to use this key.
let key = SymmetricKey()

// Alice signs a plaintext message, then encrypts it.
let envelope = try Envelope(plaintext)
    .sign(with: alicePrivateKeys)
    .enclose()
    .encrypt(with: key)
let ur = envelope.ur

// Alice ➡️ ☁️ ➡️ Bob

// Bob receives the envelope, decrypts it using the shared key, and then verifies Alice's signature.
let receivedPlaintext = try Envelope(ur: ur)
    .decrypt(with: key)
    .extract()
    .verifySignature(from: alicePublicKeys)
    .extract(String.self)
// Bob reads the message.
XCTAssertEqual(receivedPlaintext, plaintext)
```

### Envelope Notation

```
ENCRYPTED
```

## Example 6: Encrypt-Then-Sign

It doesn't actually matter whether the `encrypt` or `sign` method comes first, as the `encrypt` method transforms the `subject` into its `.encrypted` form, which carries a `Digest` of the plaintext `subject`, while the `sign` method only adds an `Assertion` with the signature of the hash as the `object` of the `Assertion`.

Similarly, the `decrypt` method used below can come before or after the `verifySignature` method, as `verifySignature` checks the signature against the `subject`'s hash, which is explicitly present when the subject is in `.encrypted` form and can be calculated when the subject is in `.plaintext` form. The `decrypt` method transforms the subject from its `.encrypted` case to its `.plaintext` case, and also checks that the decrypted plaintext has the same hash as the one associated with the `.encrypted` subject.

The end result is the same: the `subject` is encrypted and the signature can be checked before or after decryption.

The main difference between this order of operations and the sign-then-encrypt order of operations is that with sign-then-encrypt, the decryption *must* be performed first before the presence of signatures can be known or checked. With this order of operations, the presence of signatures is known before decryption, and may be checked before or after decryption.

```swift
// Alice and Bob have agreed to use this key.
let key = SymmetricKey()

let envelope = try Envelope(plaintextHello)
    .encryptSubject(with: key)
    .sign(with: alicePrivateKeys)
let ur = envelope.ur

// Alice ➡️ ☁️ ➡️ Bob

// Bob receives the envelope, verifies Alice's signature, then decrypts the message.
let receivedPlaintext = try Envelope(ur: ur)
    .verifySignature(from: alicePublicKeys)
    .decryptSubject(with: key)
    .extractSubject(String.self)
// Bob reads the message.
XCTAssertEqual(receivedPlaintext, plaintextHello)
```

### Envelope Notation

```
ENCRYPTED [
    verifiedBy: Signature
]
```

## Example 7: Multi-Recipient Encryption

This example demonstrates an encrypted message sent to multiple parties.

```swift
// Alice encrypts a message so that it can only be decrypted by Bob or Carol.
let contentKey = SymmetricKey()
let envelope = try Envelope(plaintextHello)
    .encryptSubject(with: contentKey)
    .addRecipient(bobPublicKeys, contentKey: contentKey)
    .addRecipient(carolPublicKeys, contentKey: contentKey)
let ur = envelope.ur

// Alice ➡️ ☁️ ➡️ Bob
// Alice ➡️ ☁️ ➡️ Carol

// The envelope is received
let receivedEnvelope = try Envelope(ur: ur)

// Bob decrypts and reads the message
let bobReceivedPlaintext = try receivedEnvelope
    .decrypt(to: bobPrivateKeys)
    .extractSubject(String.self)
XCTAssertEqual(bobReceivedPlaintext, plaintextHello)

// Carol decrypts and reads the message
let carolReceivedPlaintext = try receivedEnvelope
    .decrypt(to: carolPrivateKeys)
    .extractSubject(String.self)
XCTAssertEqual(carolReceivedPlaintext, plaintextHello)

// Alice didn't encrypt it to herself, so she can't read it.
XCTAssertThrowsError(try receivedEnvelope.decrypt(to: alicePrivateKeys))
```

### Envelope Notation

```
ENCRYPTED [
    hasRecipient: SealedMessage
    hasRecipient: SealedMessage
]
```

## Example 8: Signed Multi-Recipient Encryption

This example demonstrates a signed, then encrypted message, sent to multiple parties.

```swift
// Alice signs a message, and then encrypts it so that it can only be decrypted by Bob or Carol.
let contentKey = SymmetricKey()
let envelope = try Envelope(plaintextHello)
    .sign(with: alicePrivateKeys)
    .encryptSubject(with: contentKey)
    .addRecipient(bobPublicKeys, contentKey: contentKey)
    .addRecipient(carolPublicKeys, contentKey: contentKey)
let ur = envelope.ur

// Alice ➡️ ☁️ ➡️ Bob
// Alice ➡️ ☁️ ➡️ Carol

// The envelope is received
let receivedEnvelope = try Envelope(ur: ur)

// Bob verifies Alice's signature, then decrypts and reads the message
let bobReceivedPlaintext = try receivedEnvelope
    .verifySignature(from: alicePublicKeys)
    .decrypt(to: bobPrivateKeys)
    .extractSubject(String.self)
XCTAssertEqual(bobReceivedPlaintext, plaintextHello)

// Carol verifies Alice's signature, then decrypts and reads the message
let carolReceivedPlaintext = try receivedEnvelope
    .verifySignature(from: alicePublicKeys)
    .decrypt(to: carolPrivateKeys)
    .extractSubject(String.self)
XCTAssertEqual(carolReceivedPlaintext, plaintextHello)

// Alice didn't encrypt it to herself, so she can't read it.
XCTAssertThrowsError(try receivedEnvelope.decrypt(to: alicePrivateKeys))
```

### Envelope Notation

```
ENCRYPTED [
    verifiedBy: Signature
    hasRecipient: SealedMessage
    hasRecipient: SealedMessage
]
```

## Example 9: Sharding a Secret using SSKR

This example demonstrates the use of SSKR to shard a symmetric key that encrypted a message. The shares are then enclosed in individual envelopes and the seed can be recovered from those shares, allowing the future decryption of the message.

```swift
// Dan has a cryptographic seed he wants to backup using a social recovery scheme.
// The seed includes metadata he wants to back up also, making it too large to fit
// into a basic SSKR share.
var danSeed = Seed(data: ‡"59f2293a5bce7d4de59e71b4207ac5d2")!
danSeed.name = "Dark Purple Aqua Love"
danSeed.creationDate = try! Date(iso8601: "2021-02-24")
danSeed.note = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

// Dan encrypts the seed and then splits the content key into a single group
// 2-of-3. This returns an array of arrays of Envelope, the outer arrays
// representing SSKR groups and the inner array elements each holding the encrypted
// seed and a single share.
let contentKey = SymmetricKey()
let seedEnvelope = Envelope(danSeed)
let encryptedSeedEnvelope = try seedEnvelope
    .encryptSubject(with: contentKey)

let envelopes = encryptedSeedEnvelope
    .split(groupThreshold: 1, groups: [(2, 3)], contentKey: contentKey)

// Flattening the array of arrays gives just a single array of all the envelopes
// to be distributed.
let sentEnvelopes = envelopes.flatMap { $0 }
let sentURs = sentEnvelopes.map { $0.ur }

// Dan sends one envelope to each of Alice, Bob, and Carol.

// Dan ➡️ ☁️ ➡️ Alice
// Dan ➡️ ☁️ ➡️ Bob
// Dan ➡️ ☁️ ➡️ Carol

// let aliceEnvelope = try Envelope(ur: sentURs[0]) // UNRECOVERED
let bobEnvelope = try Envelope(ur: sentURs[1])
let carolEnvelope = try Envelope(ur: sentURs[2])

// At some future point, Dan retrieves two of the three envelopes so he can recover his seed.
let recoveredEnvelopes = [bobEnvelope, carolEnvelope]
let a = try Envelope(shares: recoveredEnvelopes)
let recoveredSeed = try a
    .extractSubject(Seed.self)

// The recovered seed is correct.
XCTAssertEqual(danSeed.data, recoveredSeed.data)
XCTAssertEqual(danSeed.creationDate, recoveredSeed.creationDate)
XCTAssertEqual(danSeed.name, recoveredSeed.name)
XCTAssertEqual(danSeed.note, recoveredSeed.note)

// Attempting to recover with only one of the envelopes won't work.
XCTAssertThrowsError(try Envelope(shares: [bobEnvelope]))
```

### Envelope Notation

```
ENCRYPTED [
    sskrShare: SSKRShare
]
```

## Example 10: Complex Metadata

Complex, tiered metadata can be added to an envelope.

Assertions made about an CID are considered part of a distributed set. Which assertions are returned depends on who resolves the CID and when it is resolved. In other words, the referent of a CID is mutable.

In this example, we use CIDs to represent an author, whose known works may change over time, and a particular novel written by her, the data returned about which may change over time.

Start by creating an envelope that represents the author and what is known about her, including where to get more information using the author's CID.

```swift
let author = try Envelope(CID(‡"9c747ace78a4c826392510dd6285551e7df4e5164729a1b36198e56e017666c8")!)
    .addAssertion(.dereferenceVia, "LibraryOfCongress")
    .addAssertion(.hasName, "Ayn Rand")
```

Create two envelopes representing the name of the novel in two different languages, annotated with assertions that specify the language.

```swift
let name_en = Envelope("Atlas Shrugged")
    .addAssertion(.language, "en")

let name_es = Envelope("La rebelión de Atlas")
    .addAssertion(.language, "es")
```

Create an envelope that specifies known information about the novel. This envelope embeds the previous envelopes we created for the author and the names of the work.

```swift
let work = try Envelope(CID(‡"7fb90a9d96c07f39f75ea6acf392d79f241fac4ec0be2120f7c82489711e3e80")!)
    .addAssertion(.isA, "novel")
    .addAssertion("isbn", "9780451191144")
    .addAssertion("author", author)
    .addAssertion(.dereferenceVia, "LibraryOfCongress")
    .addAssertion(.hasName, name_en)
    .addAssertion(.hasName, name_es)
```

Create an envelope that refers to the digest of a particular digital embodiment of the novel, in EPUB format. Unlike CIDs, which refer to mutable objects, this digest can only refer to exactly one unique digital object.

```swift
let bookData = "This is the entire book “Atlas Shrugged” in EPUB format."
let bookDigestEnvelope = try Envelope(Digest(bookData))
```

Create the final metadata object, which provides information about the object to which it refers, both as a general work and as a specific digital embodiment of that work.

```swift
let bookMetadata = bookDigestEnvelope
    .addAssertion("work", work)
    .addAssertion("format", "EPUB")
    .addAssertion(.dereferenceVia, "IPFS")
```

### Envelope Notation

```
Digest(e8aa201db4044168d05b77d7b36648fb7a97db2d3e72f5babba9817911a52809) [
    "format": "EPUB"
    "work": CID(7fb90a9d96c07f39f75ea6acf392d79f241fac4ec0be2120f7c82489711e3e80) [
        "author": CID(9c747ace78a4c826392510dd6285551e7df4e5164729a1b36198e56e017666c8) [
            dereferenceVia: "LibraryOfCongress"
            hasName: "Ayn Rand"
        ]
        "isbn": "9780451191144"
        dereferenceVia: "LibraryOfCongress"
        hasName: "Atlas Shrugged" [
            language: "en"
        ]
        hasName: "La rebelión de Atlas" [
            language: "es"
        ]
        isA: "novel"
    ]
    dereferenceVia: "IPFS"
]
```

## Example 11: Distributed Identifier

This example offers an analogue of a DID document, which identifies an entity. The document itself can be referred to by its CID, while the signed document can be referred to by its digest.

```swift
let aliceUnsignedDocument = try Envelope(aliceIdentifier)
    .addAssertion(.controller, aliceIdentifier)
    .addAssertion(.publicKeys, alicePublicKeys)

let aliceSignedDocument = try aliceUnsignedDocument
    .wrap()
    .sign(with: alicePrivateKeys, note: "Made by Alice.")
```

### Envelope Notation

```
{
    CID(d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f) [
        controller: CID(d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f)
        publicKeys: PublicKeyBase
    ]
} [
    verifiedBy: Signature [
        note: "Made by Alice."
    ]
]
```

Signatures have a random component, so anything with a signature will have a non-deterministic digest. Therefore, the two results of signing the same object twice with the same private key will not compare as equal. This means that each signing is a particular event that can never be repeated.

```swift
let aliceSignedDocument2 = try aliceUnsignedDocument
    .wrap()
    .sign(with: alicePrivateKeys, note: "Made by Alice.")

XCTAssertNotEqual(aliceSignedDocument, aliceSignedDocument2)

// Alice ➡️ ☁️ ➡️ Registrar
```

A registrar checks the signature on Alice's submitted identifier document, performs any other necessary validity checks, and then extracts her CID from it.

```swift
let aliceCID = try aliceSignedDocument.verifySignature(from: alicePublicKeys)
    .unwrap()
    // other validity checks here
    .extractSubject(CID.self)
```

The registrar creates its own registration document using Alice's CID as the subject, incorporating Alice's signed document, and adding its own signature.

```swift
let aliceURL = URL(string: "https://exampleledger.com/cid/\(aliceCID.data.hex)")!
let aliceRegistration = try Envelope(aliceCID)
    .addAssertion(.entity, aliceSignedDocument)
    .addAssertion(.dereferenceVia, aliceURL)
    .wrap()
    .sign(with: exampleLedgerPrivateKeys, note: "Made by ExampleLedger.")
```

### Envelope Notation

```
{
    CID(d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f) [
        dereferenceVia: URI(https://exampleledger.com/cid/d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f)
        entity: {
            CID(d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f) [
                controller: CID(d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f)
                publicKeys: PublicKeyBase
            ]
        } [
            verifiedBy: Signature [
                note: "Made by Alice."
            ]
        ]
    ]
} [
    verifiedBy: Signature [
        note: "Made by ExampleLedger."
    ]
]
```

Alice receives the registration document back, verifies its signature, and extracts the URI that now points to her record.

```swift
let aliceURI = try aliceRegistration
    .verifySignature(from: exampleLedgerPublicKeys)
    .unwrap()
    .extractObject(URL.self, forPredicate: .dereferenceVia)
XCTAssertEqual(aliceURI†, "https://exampleledger.com/cid/d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f")
```

Alice wants to introduce herself to Bob, so Bob needs to know she controls her identifier. Bob sends a challenge:

```swift
let aliceChallenge = try Envelope(Nonce())
    .addAssertion(.note, "Challenge to Alice from Bob.")
```

### Envelope Notation

```
Nonce [
    note: "Challenge to Alice from Bob."
]
```

Alice responds by adding her registered URI to the nonce, and signing it.

```swift
let aliceChallengeResponse = try aliceChallenge
    .wrap()
    .addAssertion(.dereferenceVia, aliceURI)
    .wrap()
    .sign(with: alicePrivateKeys, note: "Made by Alice.")
```

### Envelope Notation

```
{
    {
        Nonce [
            note: "Challenge to Alice from Bob."
        ]
    } [
        dereferenceVia: URI(https://exampleledger.com/cid/d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f)
    ]
} [
    verifiedBy: Signature [
        note: "Made by Alice."
    ]
]
```

Bob receives Alice's response, and first checks that the nonce is the once he sent.

```swift
let responseNonce = try aliceChallengeResponse
    .unwrap()
    .unwrap()
XCTAssertEqual(aliceChallenge, responseNonce)
```

Bob then extracts Alice's registered URI

```swift
let responseURI = try aliceChallengeResponse
    .unwrap()
    .extractObject(URL.self, forPredicate: .dereferenceVia)
XCTAssertEqual(responseURI.absoluteString, "https://exampleledger.com/cid/d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f")
```

Bob uses the URI to ask ExampleLedger for Alice's identifier document, then checks ExampleLedgers's signature. Bob trusts ExampleLedger's validation of Alice's original document, so doesn't bother to check it for internal consistency, and instead goes ahead and extracts Alice's public keys from it.

```swift
let aliceDocumentPublicKeys = try aliceRegistration
    .verifySignature(from: exampleLedgerPublicKeys)
    .unwrap()
    .extractObject(forPredicate: .entity)
    .unwrap()
    .extractObject(PublicKeyBase.self, forPredicate: .publicKeys)
```

Finally, Bob uses Alice's public keys to validate the challenge he sent her.

```swift
try aliceChallengeResponse.verifySignature(from: aliceDocumentPublicKeys)
```

## Example 12: Verifiable Credential

Envelopes can also be built to support verifiable credentials, supporting the core functionality of DIDs.

John Smith's identifier:

```swift
let johnSmithIdentifier = CID(‡"78bc30004776a3905bccb9b8a032cf722ceaf0bbfb1a49eaf3185fab5808cadc")!
```

A photo of John Smith:

```swift
let johnSmithImage = Envelope(Digest("John Smith smiling"))
    .addAssertion(.note, "This is an image of John Smith.")
    .addAssertion(.dereferenceVia, "https://exampleledger.com/digest/36be30726befb65ca13b136ae29d8081f64792c2702415eb60ad1c56ed33c999")
```

John Smith's Permanent Resident Card issued by the State of Example:

```swift
let johnSmithResidentCard = try Envelope(CID(‡"174842eac3fb44d7f626e4d79b7e107fd293c55629f6d622b81ed407770302c8")!)
    .addAssertion(.isA, "credential")
    .addAssertion("dateIssued", Date(iso8601: "2022-04-27"))
    .addAssertion(.issuer, Envelope(stateIdentifier)
        .addAssertion(.note, "Issued by the State of Example")
        .addAssertion(.dereferenceVia, URL(string: "https://exampleledger.com/cid/04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8")!)
    )
    .addAssertion(.holder, Envelope(johnSmithIdentifier)
        .addAssertion(.isA, "Person")
        .addAssertion(.isA, "Permanent Resident")
        .addAssertion("givenName", "JOHN")
        .addAssertion("familyName", "SMITH")
        .addAssertion("sex", "MALE")
        .addAssertion("birthDate", Date(iso8601: "1974-02-18"))
        .addAssertion("image", johnSmithImage)
        .addAssertion("lprCategory", "C09")
        .addAssertion("lprNumber", "999-999-999")
        .addAssertion("birthCountry", Envelope("bs").addAssertion(.note, "The Bahamas"))
        .addAssertion("residentSince", Date(iso8601: "2018-01-07"))
    )
    .addAssertion(.note, "The State of Example recognizes JOHN SMITH as a Permanent Resident.")
    .wrap()
    .sign(with: statePrivateKeys, note: "Made by the State of Example.")

// Validate the state's signature
try johnSmithResidentCard.verifySignature(from: statePublicKeys)
```

### Envelope Notation

```
{
    CID(174842eac3fb44d7f626e4d79b7e107fd293c55629f6d622b81ed407770302c8) [
        "dateIssued": 2022-04-27
        holder: CID(78bc30004776a3905bccb9b8a032cf722ceaf0bbfb1a49eaf3185fab5808cadc) [
            "birthCountry": "bs" [
                note: "The Bahamas"
            ]
            "birthDate": 1974-02-18
            "familyName": "SMITH"
            "givenName": "JOHN"
            "image": Digest(36be30726befb65ca13b136ae29d8081f64792c2702415eb60ad1c56ed33c999) [
                dereferenceVia: "https://exampleledger.com/digest/36be30726befb65ca13b136ae29d8081f64792c2702415eb60ad1c56ed33c999"
                note: "This is an image of John Smith."
            ]
            "lprCategory": "C09"
            "lprNumber": "999-999-999"
            "residentSince": 2018-01-07
            "sex": "MALE"
            isA: "Permanent Resident"
            isA: "Person"
        ]
        isA: "credential"
        issuer: CID(04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8) [
            dereferenceVia: URI(https://exampleledger.com/cid/04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8)
            note: "Issued by the State of Example"
        ]
        note: "The State of Example recognizes JOHN SMITH as a Permanent Resident."
    ]
} [
    verifiedBy: Signature [
        note: "Made by the State of Example."
    ]
]
```

John wishes to identify himself to a third party using his government-issued credential, but does not wish to reveal more than his name, his photo, and the fact that the state has verified his identity.

Redaction is performed by building a set of digests that will be revealed. All digests not present in the reveal-set will be replaced with elision markers containing only the hash of what has been elided, thus preserving the hash tree including revealed signatures. If a higher-level object is elided, then everything it contains will also be elided, so if a deeper object is to be revealed, all of its parent objects also need to be revealed, even though not everything *about* the parent objects must be revealed.

```swift
// Start a target set
var target: Set<Digest> = []

// Reveal the card. Without this, everything about the card would be elided.
let top = johnSmithResidentCard
target.insert(top)

// Reveal everything about the state's signature on the card
try target.insert(top.assertion(withPredicate: .verifiedBy).deepDigests)

// Reveal the top level of the card.
target.insert(top.shallowDigests)

let card = try top.unwrap()
target.insert(card)
target.insert(card.subject)

// Reveal everything about the `isA` and `issuer` assertions at the top level of the card.
try target.insert(card.assertion(withPredicate: .isA).deepDigests)
try target.insert(card.assertion(withPredicate: .issuer).deepDigests)

// Reveal the `holder` assertion on the card, but not any of its sub-assertions.
let holder = try card.assertion(withPredicate: .holder)
target.insert(holder.shallowDigests)

// Within the `holder` assertion, reveal everything about just the `givenName`, `familyName`, and `image` assertions.
let holderObject = holder.object!
try target.insert(holderObject.assertion(withPredicate: "givenName").deepDigests)
try target.insert(holderObject.assertion(withPredicate: "familyName").deepDigests)
try target.insert(holderObject.assertion(withPredicate: "image").deepDigests)

// Perform the elision
let elidedCredential = try top.elideRevealing(target)

// Check that the elided credential compares equal to the original credential.
XCTAssertEqual(elidedCredential, johnSmithResidentCard)

// Check that the state's signature on the elided card still verifies.
try elidedCredential.verifySignature(from: statePublicKeys)
```

### Envelope Notation for Redacted Credential

```
{
    CID(174842eac3fb44d7f626e4d79b7e107fd293c55629f6d622b81ed407770302c8) [
        holder: CID(78bc30004776a3905bccb9b8a032cf722ceaf0bbfb1a49eaf3185fab5808cadc) [
            "familyName": "SMITH"
            "givenName": "JOHN"
            "image": Digest(36be30726befb65ca13b136ae29d8081f64792c2702415eb60ad1c56ed33c999) [
                dereferenceVia: "https://exampleledger.com/digest/36be30726befb65ca13b136ae29d8081f64792c2702415eb60ad1c56ed33c999"
                note: "This is an image of John Smith."
            ]
            ELIDED (8)
        ]
        isA: "credential"
        issuer: CID(04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8) [
            dereferenceVia: URI(https://exampleledger.com/cid/04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8)
            note: "Issued by the State of Example"
        ]
        ELIDED (2)
    ]
} [
    verifiedBy: Signature [
        note: "Made by the State of Example."
    ]
]
```
