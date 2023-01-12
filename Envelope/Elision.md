# Elision and Redaction

Removing information without invalidating the digest tree.

## Overview

One common use case for a general hierarchical container structure such as `Envelope` is *data minimization*, which is the privacy-preserving practice of only revealing what is necessary and sufficient for parties to trust each other and transact together.

One way of providing data minimization is *selective disclosure*. For example, an employer may have an employee with a particular continuing education credential:

```
{
    CID(4676635a6e6068c2ef3ffd8ff726dd401fd341036e920f136a1d8af5e829496d) [
        "certificateNumber": "123-456-789"
        "continuingEducationUnits": 1.5
        "expirationDate": 2028-01-01
        "firstName": "James"
        "issueDate": 2020-01-01
        "lastName": "Maxwell"
        "photo": "This is James Maxwell's photo."
        "professionalDevelopmentHours": 15
        "subject": "RF and Microwave Engineering"
        "topics": CBOR
        controller: "Example Electrical Engineering Board"
        isA: "Certificate of Completion"
        issuer: "Example Electrical Engineering Board"
    ]
} [
    note: "Signed by Example Electrical Engineering Board"
    verifiedBy: Signature
]
```

Using elision, the employer of an employee with this credential could warrant to a third-party that their employee has such a credential, without revealing anything else about the employee. This is done as follows:

1. Elide privileged information from the certificate, while keeping only necessary information.
2. Enclose the envelope in another envelope to which the employer adds its own assertions that need to be non-repudiable; this is the employer's *warranty*.
3. Enclose the warranty in another envelope, which is then signed by the employer.

```
{
    {
        {
            CID(4676635a6e6068c2ef3ffd8ff726dd401fd341036e920f136a1d8af5e829496d) [
                "expirationDate": 2028-01-01
                "firstName": "James"
                "lastName": "Maxwell"
                "subject": "RF and Microwave Engineering"
                isA: "Certificate of Completion"
                issuer: "Example Electrical Engineering Board"
                ELIDED (7)
            ]
        } [
            note: "Signed by Example Electrical Engineering Board"
            verifiedBy: Signature
        ]
    } [
        "employeeHiredDate": 2022-01-01
        "employeeStatus": "active"
    ]
} [
    note: "Signed by Employer Corp."
    verifiedBy: Signature
]
```

Note that in this example the elision was performed by a the employer, who possesses a copy of the `Envelope`-based certificate, but who is neither the holder of the certificate (the employee), not the original issuer (the certification board). The ability for anyone to perform elision on any document is one of the major advantages of elision over more complex methodologies such as Zero-Knowledge Proofs.

The Blockchain Commons `Envelope` type is designed for the construction of verifiable digital documents that can be as long-lived as a blockchain transaction or government-issued credential, or as ephemeral as a function call. Among its capabilities, `Envelope` includes affordances for `elision`, which is the selective withholding of specified information in a document, while still maintaining its integrity and verifiability.

## Use Cases for Elision

The term *elide* means "to leave out." In an `Envelope`, elided items are replaced by their Merkle tree digest, therefore allowing the same digests to be calculated for the entire tree despite those absences.

The term *redaction* is often used interchangably with *elision*. There is, however, a crucial semantic difference between the two terms: elision is *what* is accomplished, while *redaction* is one purpose for which data might be elided.

In fact, when eliding data there are at least two major goals that can be accomplished:

* **Redaction.** When one *redacts*, one is choosing to withhold information with no affordance or expectation that the receiving party can or will recover it.
* **Referencing.** When one *references*, one withholds information with every affordance and expectation that the receiving party can and might choose to recover the elided information.

For example, my photo might be embedded as a JPG within a verifiable credential. Embedding has the advantage that it's right there to be interpreted by anyone who receives the document. In this case, there are two reasons I might want a version of my credential with the photo elided.

First, I might *redact* it because it is priviledged or irrelevant to the transaction I want to perform.

Alternatively, I might want the data to be smaller, while still allowing the retrieval of the photo by interested parties. In this case, a *dereferencing method* would need to be included that shows *how* to retrieve the information. This method can either be built into the verifiable credential by the issuer:

```
{
    ELIDED [
        "birthDate": 1970-01-01
        photo: ELIDED [
            dereferenceVia: "IPFS"
        ]
        ELIDED (8)
    ]
} [
    note: "Signed by the State of Example"
    verifiedBy: Signature
]
```

But note that this additional assertion is *inside* the signed part of the document, which means it would have to be "built in" to the document before it was signed.

But even if the issuer didn't provide a way to retrieve the photo, I can still elide it, and *also* add a new assertion outside of the signed part of the document that shows what was elided *and* how to retrieve it. And since the signed part of the envelope includes the digest of what was elided, *only* the exact photo that was elided will fit there, regardless of how it is retrieved:

```
{
    ELIDED [
        "birthDate": 1970-01-01
        "photo": ELIDED
        ELIDED (8)
    ]
} [
    note: "Signed by the State of Example"
    photo: ELIDED [
        dereferenceVia: "IPFS"
    ]
    verifiedBy: Signature
]
```

Either way, anyone who retrieves the photo can absolutely know it is correct because it exactly matches the elided element's digest in the document's signed Merkle tree. In this sense, elision and unelision are *isomorphic* and *reversible*.

Encryption might be seen as a special kind of redaction, where the original message is still present as ciphertext, and may only be "unredacted" (unencrypted) using the proper key. In this way, encryption is also isomorphic and reversible, and even interchangeable with elision.

### Immutable References

When an element of an `Envelope` is elided for the purpose of referencing, the only object that can be used to dereference it the identical image from which the digest was generated. This means that *a digest's referent is immutable*: every time a particular digest is dereferenced, the exact same referent must be returned.

It's important to realize that while information may be *elided* in in an envelope, no underlying information can have been *mutated* (i.e., added, removed, or altered). Furthermore, any elided document could still be transformed to the un-elided version if the elided parts can be retrieved.

So when referencing a document by digest, the referent must be considered to be an immutable "snapshot" of a document.

### Mutable References

Of course, many documents change over time, or may contain different information depending on who's doing the recordkeeping. Databases all have the concept of a "unique key" for a record, such as a drivers license or passport number. Different databases can use the same numbers as keys referencing different records, and the records they keep may change.

Secure Components provides the [Common Identifier (CID)](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2022-002-cid-common-identifier.md) as a universal way of identifying mutable objects. Relative to `Envelope` the use of CIDs is optional, but we feel they have some unique strengths (see the CID paper for more).

"Mutability" occurs when dereferencing an identifier might return a different set of information over time, or depending on who's database is being accessed, or depending on the priviledge level of who is doing the accessing.

So since CIDs are not tied to a specific binary object, dereferencing a CID may yield different versions of a document, or even completely disparate information.

## Performing Elision - A Worked Example

This section works through the example above: a continuing education credential that is redacted by an employer to reveal and warrant that their employee has such a credential, and which can still be verified.

### Creating the Credential

This is the Swift code to create our example credential:

```swift
// The subject of the envelope is a CID that represents the holder.
let credential = try Envelope(CID(‡"4676635a6e6068c2ef3ffd8ff726dd401fd341036e920f136a1d8af5e829496d")!)
    .addAssertion(.isA, "Certificate of Completion")
    .addAssertion(.issuer, "Example Electrical Engineering Board")
    .addAssertion(.controller, "Example Electrical Engineering Board")
    .addAssertion("firstName", "James")
    .addAssertion("lastName", "Maxwell")
    .addAssertion("issueDate", Date(iso8601: "2020-01-01"))
    .addAssertion("expirationDate", Date(iso8601: "2028-01-01"))
    .addAssertion("photo", "This is James Maxwell's photo.")
    .addAssertion("certificateNumber", "123-456-789")
    .addAssertion("subject", "RF and Microwave Engineering")
    .addAssertion("continuingEducationUnits", 1.5)
    .addAssertion("professionalDevelopmentHours", 15)
    .addAssertion("topics", ["Subject 1", "Subject 2"])
    .wrap()
    .sign(with: alicePrivateKeys)
    .addAssertion(.note, "Signed by Example Electrical Engineering Board")
```

If we print the credential in Envelope Notation, we get:

```
{
    CID(4676635a6e6068c2ef3ffd8ff726dd401fd341036e920f136a1d8af5e829496d) [
        "certificateNumber": "123-456-789"
        "continuingEducationUnits": 1.5
        "expirationDate": 2028-01-01
        "firstName": "James"
        "issueDate": 2020-01-01
        "lastName": "Maxwell"
        "photo": "This is James Maxwell's photo."
        "professionalDevelopmentHours": 15
        "subject": "RF and Microwave Engineering"
        "topics": CBOR
        controller: "Example Electrical Engineering Board"
        isA: "Certificate of Completion"
        issuer: "Example Electrical Engineering Board"
    ]
} [
    note: "Signed by Example Electrical Engineering Board"
    verifiedBy: Signature
]
```

### The Target Set

Every part of an envelope generates a digest, and these together form a Merkle tree. So when eliding a document, we can decide what to remove or reveal by identifying a subset of all the digests that make up the tree. This set is known as the *target*. Normally we would create the target and then perform the elision in a single operation, but in this example we are going to build up the target in increments, showing the result of each step.

### Creating the Empty Target

Here is the Swift code to create an empty set of digests:

```swift
var target: Set<Digest> = []
```

If we use this empty target to elide the target using the `elideRevealing` function:

```swift
let e2 = try credential.elideRevealing(target)
print(e2.format)
```

...then the entire envelope will be elided:

```
ELIDED
```

We've essentially said, "Elide everything." Obviously this isn't very useful, so we now start to work our way down the tree to the parts we want to reveal.

### Revealing the Top-Level Structure

The first digest we need is the top-level digest of the envelope. This reveals the "macro structure" of the envelope.

(From here on we'll just show the code that adds digests to the target, and the result of performing the elision on the original credential using that target.)

```swift
target.insert(credential)
```

```
ELIDED [
    ELIDED (2)
]
```

This shows us that the envelope has a subject, which is still elided, and two assertions, both of which are still elided. The subject is the actual credential, and the assertions are the signature and the note.

### Revealing the Signature

To reveal the two assertions, we iterate through them and add their "deep digests" to the target. Using `deepDigests` means that *everying* about the revealed assertions will be revealed, including any assertions they may have, recursively.

```swift
for assertion in credential.assertions {
    target.insert(assertion.deepDigests)
}
```

```
ELIDED [
    note: "Signed by Example Electrical Engineering Board"
    verifiedBy: Signature
]
```

At this point, if one had the proper public keys, the receiver of this redacted credential could verify the signature, even without knowing anything else about the contents of the credential.

### Revealing the Subject

The subject of the envelope, containing all the holder's information is still elided. So now we add the subject itself to the target:

```swift
target.insert(credential.subject)
```

```
{
    ELIDED
} [
    note: "Signed by Example Electrical Engineering Board"
    verifiedBy: Signature
]
```

Comparing to the results of the previous step, we see a new pair of braces has appeared. This is because the subject of the document is *another* envelope that has been wrapped in its entirety to be signed. Notice the call to the `.wrap()` function at the start of this example above.

### Revealing the Content

So now we need to reveal the unwrapped content:

```swift
let content = try credential.subject.unwrap()
target.insert(content)
```

```
{
    ELIDED [
        ELIDED (13)
    ]
} [
    note: "Signed by Example Electrical Engineering Board"
    verifiedBy: Signature
]
```

Now it looks like we're getting somewhere! The wrapped envelope has a still-elided subject (the holder's CID) and ten assertions, all of which are still currently elided.

### Revealing the CID

We want to reveal the CID representing the issuing authority's unique reference to the credential holder. This is because the warranty the employer is making is that a specific identifiable employee has the credential, *without* actually revealing their identity. This allows the entire document to be identified and unredacted should a dispute ever arise.

```swift
target.insert(content.subject)
```

```
{
    CID(4676635a6e6068c2ef3ffd8ff726dd401fd341036e920f136a1d8af5e829496d) [
        ELIDED (13)
    ]
} [
    note: "Signed by Example Electrical Engineering Board"
    verifiedBy: Signature
]
```

### Revealing the Claims

The only actual assertions we want to reveal are `firstName`, `lastName`, `.isA`, `issuer`, `subject` and `expirationDate`, so we do this by finding those specific assertions by their predicate. The `shallowDigests` attribute returns just a necessary set of attributes to reveal the assertion, its predicate, and its object (yes, all three of them need to be revealed) but *not* any deeper assertions on them.

```swift
target.insert(try content.assertion(withPredicate: "firstName").shallowDigests)
target.insert(try content.assertion(withPredicate: "lastName").shallowDigests)
target.insert(try content.assertion(withPredicate: .isA).shallowDigests)
target.insert(try content.assertion(withPredicate: .issuer).shallowDigests)
target.insert(try content.assertion(withPredicate: "subject").shallowDigests)
target.insert(try content.assertion(withPredicate: "expirationDate").shallowDigests)
```

```
{
    CID(4676635a6e6068c2ef3ffd8ff726dd401fd341036e920f136a1d8af5e829496d) [
        "expirationDate": 2028-01-01
        "firstName": "James"
        "lastName": "Maxwell"
        "subject": "RF and Microwave Engineering"
        isA: "Certificate of Completion"
        issuer: "Example Electrical Engineering Board"
        ELIDED (7)
    ]
} [
    note: "Signed by Example Electrical Engineering Board"
    verifiedBy: Signature
]
```

Finally, the employer wants to enclose this envelope, add some non-repudiable assertions of it's own, then sign it. This is the employer's *warranty*.

```swift
let warranty = try redactedCredential
    .wrap()
    .addAssertion("employeeHiredDate", Date(iso8601: "2022-01-01"))
    .addAssertion("employeeStatus", "active")
    .wrap()
    .addAssertion(.note, "Signed by Employer Corp.")
    .sign(with: bobPrivateKeys)
```

```
{
    {
        {
            CID(4676635a6e6068c2ef3ffd8ff726dd401fd341036e920f136a1d8af5e829496d) [
                "expirationDate": 2028-01-01
                "firstName": "James"
                "lastName": "Maxwell"
                "subject": "RF and Microwave Engineering"
                isA: "Certificate of Completion"
                issuer: "Example Electrical Engineering Board"
                ELIDED (7)
            ]
        } [
            note: "Signed by Example Electrical Engineering Board"
            verifiedBy: Signature
        ]
    } [
        "employeeHiredDate": 2022-01-01
        "employeeStatus": "active"
    ]
} [
    note: "Signed by Employer Corp."
    verifiedBy: Signature
]
```

Success! This warranty, including the redacted credential may now be provided to the receiver, who can use it to verify the signature of both the issuing authority and the corporation, and thus hold the warrantor accountable.

### Recap

If you were to perform the entire composition of the target in a single block of code, you'd write:

```swift
var target: Set<Digest> = []

target.insert(credential)

for assertion in credential.assertions {
    target.insert(assertion.deepDigests)
}

target.insert(credential.subject)

let content = try credential.subject.unwrap()
target.insert(content)

target.insert(content.subject)

target.insert(try content.assertion(withPredicate: "firstName").shallowDigests)
target.insert(try content.assertion(withPredicate: "lastName").shallowDigests)
target.insert(try content.assertion(withPredicate: .isA).shallowDigests)
target.insert(try content.assertion(withPredicate: .issuer).shallowDigests)
target.insert(try content.assertion(withPredicate: "subject").shallowDigests)
target.insert(try content.assertion(withPredicate: "expirationDate").shallowDigests)

let warranty = try redactedCredential
    .wrap()
    .addAssertion("employeeHiredDate", Date(iso8601: "2022-01-01"))
    .addAssertion("employeeStatus", "active")
    .wrap()
    .addAssertion(.note, "Signed by Employer Corp.")
    .sign(with: bobPrivateKeys)
```

In this example case, the target set would contain 28 digests.

## The Structure of an Envelope

Understanding the structure of `Envelope` is essential to understanding how to navigate it, including performing elision.

The essential structure is:

```
envelope {
    subject [
        assertion1(predicate1: object1)
        assertion2(predicate2: object2)
        ...
        assertionN(predicateN: objectN)
    ]
}
```

...where all of the symbols shown above, e.g. `envelope`, `subject`, `assertion1`, and `predicate2` are called *positions*. Each position is *itself* an `Envelope`, and therefore may carry its own assertions, recursively. Each position carries a digest, which may be used to refer to the object at that position.

### A Tour of the Positions

Let's take a tour of the positions of a simple `Envelope`, using elision to demonstrate each.

```swift
let envelope = Envelope("Alice")
    .addAssertion("knows", "Bob")
```

```
"Alice" [
    "knows": "Bob"
]
```

In each step below we'll start with the `Envelope` above and call `elideRemove(target)` with the target containing a single digest.

Unlike the previous credential example above, note that we're *removing* the target, not *revealing* it.

#### Elide the Entire Envelope

Starting at the top, we elide the entire `Envelope`:

```swift
let e1 = try envelope.elideRemoving(envelope)
```

```
ELIDED
```

#### Elide the Subject

```swift
let e2 = try envelope.elideRemoving(envelope.subject)
```

```
ELIDED [
    "knows": "Bob"
]
```

#### Elide the Assertion

```swift
let assertion = envelope.assertions.first!
let e3 = try envelope.elideRemoving(assertion)
```

```
"Alice" [
    ELIDED
]
```

#### Elide the Predicate

```swift
let e4 = try envelope.elideRemoving(assertion.predicate!)
```

```
"Alice" [
    ELIDED: "Bob"
]
```

#### Elide the Object

```swift
let e5 = try envelope.elideRemoving(assertion.object!)
```

```
"Alice" [
    "knows": ELIDED
]
```

## Duplicate Digests

If a digest in a target occurs more than once in an `Envelope`'s tree, then doing an elision on it will reveal (or remove) that object everywhere it occurs. Consider this document, where the "knows" predicte appears twice:

```
"Alice" [
    "knows": "Bob"
    "knows": "Carol"
]
```

If we execute these statements:

```swift
target.insert(Envelope("knows"))
let elided = try envelope.elideRemoving(target)
```

We would see that the "knows" predicate would be redacted everywhere it occurs:

```
"Alice" [
    ELIDED: "Bob"
    ELIDED: "Carol"
]
```

In practice this is not usually a problem, because if you wish to elide one of the assertions above, you would hide the *whole* assertion and not just the predicate. Since duplicate assertions are not allowed, each assertion in its `Envelope` has its own unique digest. So executing:

```swift
target.insert(Envelope("knows", "Carol"))
let elided = try envelope.elideRemoving(target)
```

...would yield:

```
"Alice" [
    "knows": "Bob"
    ELIDED
]
```

## Exploratory Uses

Due to its unique structure, `Envelope` provides for some novel workflows which may be quite useful. These possibilities should also be considered for potential points of vulnerability or abuse.

### Blinded Verification

As demonstrated above, any part of an `Envelope` may be elided, and any signatures on that document can still be verified. This allows the possessor of a document to elide any part of it before passing it on, possibly changing the semantics of the document by what has been omitted.

For example, receiving a properly signed, yet heavily-redacted document could result in a receiving party trusting out of context claims.

Elision should never be confused with deletion. No *actual* mutation (additions, deletions, or changes) of a document is possible without invalidating the Merkle tree, including any signatures.

The designer of an envelope structure should consider various privacy-preserving transformations of that structure, while ensuring that those transformations do not alter the intended semantics of the document.

Receivers of elided documents should ensure that all fields are present necessary to ensure a trusted transaction.

### Blind Signing

Just as it is possible to verify a signature on an elided document, it is also possible to sign an elided document.

Signers should always check a document for completeness and accuracy before signing it, and be particularly careful if the document contains elided elements.

Nonetheless, there may be interesting or useful cases for blind signing that might be investigated, including zero-knowledge proofs or other forms of cryptographic commitments.

### Blinded Retrieval

Consider the case of a photograph encoded as an Envelope and stored in a content addressible storage system using its digest as the key:

```
Digest(c5d6edb915682fea7cefeb6ae3822bb7430c3cb743c1ca3dd0895c3e9e367bf9) [
    "width": 640
    "height": 480
    "data": CBOR
    "date": Date(2022-08-22T09:09:08Z)
    "filename": "IMG-3718"
]
```

When returning this object as the result of a query, it is perfectly legal for the storage system to elide any or all of it, for example the metadata. This would still be the "same" object, but in partially-elided form:

```
Digest(c5d6edb915682fea7cefeb6ae3822bb7430c3cb743c1ca3dd0895c3e9e367bf9) [
    "width": 640
    "height": 480
    "data": CBOR
    ELIDED (2)
]
```

This may be frustrating if the metadata is expected and needed, but might also be quite useful for the retrival API to offer options for smaller transfer sizes/times using server-side elision, while still preserving the document's cryptographic identity.

### Parallel Semantics

Consider a secret agent issued an identity document by their governent. Elided this way, it looks like a perfectly normal identity document:

```
{
  CID(2ddf15aab0ff7d710db6bf5be5532fa1a4c171ad2a79c2df5f46199dfd0fbfa0) [
      "firstName": "James"
      "lastName": "Bond"
      "photo": "A photo of James Bond."
      ELIDED (3)
  ]
} [
    verifiedBy: Signature
]
```

But elided differently, the exact same document, signed with the same signature, could read:

```
{
  CID(2ddf15aab0ff7d710db6bf5be5532fa1a4c171ad2a79c2df5f46199dfd0fbfa0) [
      "firstName": "Jason"
      "lastName": "Bourne"
      "photo": "A photo of the same guy in a different costume."
      ELIDED (3)
  ]
} [
    verifiedBy: Signature
]
```

So what about those elided fields?

```
{
  CID(2ddf15aab0ff7d710db6bf5be5532fa1a4c171ad2a79c2df5f46199dfd0fbfa0) [
      "firstName": "James"
      "firstName": "Jason"
      "lastName": "Bond"
      "lastName": "Bourne"
      "photo": "A photo of James Bond."
      "photo": "A photo of the same guy in a different costume."
  ]
} [
    verifiedBy: Signature
]
```

Obviously all parties should be aware that elision can be used to reveal different semantics at different times, and decide what signatures, and what elisions, to require and trust.

## See Also

- <doc:Elision>
