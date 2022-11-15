# A Technical Introduction to Gordian Envelopes

Please see our [Introduction to Gordian Envelopes](Envelope-Intro.md) for our introductory discussion of what Gordian Envelopes are, why they're useful, and how they're used.

> Gordian Envelope is a specification for the achitecture of a “smart document". It supports the storage, backup, encryption, authentication, and transmission of data, with natively supported cryptography and explicit support for Merkle-based selective disclosure. It's designed to protect digital assets including seeds, keys, Decentralized Identifiers (DIDs), Verifiable Credentials (VCs), and Verifiable Presentations (VPs).

This document outlines the most important technical features of Gordian Envelopes in abstract Alice and Bob form. See our [Use Case Intro](Envelope-Use-Case-Intro.md) for more real-world focused designs.

## Envelope Structure

The Gordian Envelope is organized with semantic triples: subject-predicate-object. These are essentially statements such as "Alice Knows Bob". Given that Gordian Envelopes are designed to store and transmit digital assets they might actually be storage statements such as "Seed is XXX", credential statements such as "Bob is certified as a welder", or certification statements such as "This statement is certified by the Welder's Guild of Normal, Illinois".

Each envelope has one subject, but can have zero or more predicate-object pairs, which are called assertions.

_All examples in this overview are generated with [envelope-cli-swift](https://github.com/BlockchainCommons/envelope-cli-swift), using the `--mermaid` flag. The Reference App is suggested as an excellent way to further explore the technical details of Gordian Envelope. Please see the [Envelope-CLI Docs](https://github.com/BlockchainCommons/envelope-cli-swift/tree/master/Docs) for its usage._

Though an envelope can include just a Subject, the most basic example of a full semantic triple is:
```
"Alice" [
    "knows": "Bob"
]
```
In this case, "Alice" is the subject, while the predicate of "knows" and the object of "Bob" form an assertion.

Using `envelope-cli`, all Gordian Envelope output can be displayed in three forms. The standard text output is shown above. 

The `--tree` text output uses a different text formatting that also includes hashes:
```
e54d6fd3 NODE
    27840350 subj "Alice"
    55560bdf ASSERTION
        7092d620 pred "knows"
        9a771715 obj "Bob"
```
Finally the graphical `--mermaid` output also includes hashes, but it can get very large (and the text can get very tiny) for big trees:
```mermaid
graph LR
    1(("e54d6fd3<br/>NODE"))
    2["27840350<br/>#quot;Alice#quot;"]
    3(["55560bdf<br/>ASSERTION"])
    4["7092d620<br/>#quot;knows#quot;"]
    5["9a771715<br/>#quot;Bob#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
```
(Most examples here and in the Use Cases doc that follows will use the default and mermaid outputs.)

Multiple assertions are possible:
```
"Alice" [
    "likes": "Bob"
    "hates": "Charlie"
]
```
```mermaid
graph LR
    1(("dfe1b6bc<br/>NODE"))
    2["27840350<br/>#quot;Alice#quot;"]
    3(["0ded3ac1<br/>ASSERTION"])
    4["490cfb03<br/>#quot;likes#quot;"]
    5["9a771715<br/>#quot;Bob#quot;"]
    6(["709b5749<br/>ASSERTION"])
    7["4850740d<br/>#quot;hates#quot;"]
    8["266d128b<br/>#quot;Charlie#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
```
However the abstract examples in this techinical overview will largely constrain themselves to a simple single-assertion envelope.

> _See the [Envelope Docs](https://github.com/BlockchainCommons/BCSwiftSecureComponents/tree/master/Docs) for more information on basic envelope structure, especially [02-Envelope](https://github.com/BlockchainCommons/BCSwiftSecureComponents/blob/master/Docs/02-ENVELOPE.md) and [03-Envelope-Notation](https://github.com/BlockchainCommons/BCSwiftSecureComponents/blob/master/Docs/03-ENVELOPE-NOTATION.md). Also see the [Envelope-CLI Docs](https://github.com/BlockchainCommons/envelope-cli-swift/tree/master/Docs), especially [01-Overview](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/1-OVERVIEW.md)._

## Sub Envelopes

Each element of a semantic triple can itself be an envelope. This allows for an infinitely recursive structure. 

One purpose of doing so is to allow for the inclusion of more metadata about any individual element (usually the subject or the object)

For example, the following shows a slightly more realistic usage of our abstract example, where Alice and Bob are actually represented by DIDs, which each contain more info on the user, including a user name and public keys that can be used to identify them:
```
{
    CID(d44c5e0a) [
        "userName": "Lil Alice"
        controller: CID(d44c5e0a)
        publicKeys: PublicKeyBase
    ]
} [
    "knows": CID(24b5b23d) [
        "userName": "Bob Bobbery"
        controller: CID(24b5b23d)
        publicKeys: PublicKeyBase
    ]
]
```

Obviously, this can grow increasingly complex:
```mermaid
graph LR
    1(("fc03ea52<br/>NODE"))
    2[/"298fb641<br/>WRAPPED"\]
    3(("82a3effa<br/>NODE"))
    4["e002f28a<br/>CID(d44c5e0a)"]
    5(["3b59d039<br/>ASSERTION"])
    6[/"642917d0<br/>publicKeys"/]
    7["5de2a1fa<br/>PublicKeyBase"]
    8(["e716c487<br/>ASSERTION"])
    9[/"2f9bee2f<br/>controller"/]
    10["e002f28a<br/>CID(d44c5e0a)"]
    11(["fea5d530<br/>ASSERTION"])
    12["62c8b067<br/>#quot;userName#quot;"]
    13["166d5ed7<br/>#quot;Lil Alice#quot;"]
    14(["d16fe185<br/>ASSERTION"])
    15["7092d620<br/>#quot;knows#quot;"]
    16(("755feb90<br/>NODE"))
    17["7bf30050<br/>CID(24b5b23d)"]
    18(["03f0e800<br/>ASSERTION"])
    19[/"2f9bee2f<br/>controller"/]
    20["7bf30050<br/>CID(24b5b23d)"]
    21(["0d7534f2<br/>ASSERTION"])
    22[/"642917d0<br/>publicKeys"/]
    23["778215f3<br/>PublicKeyBase"]
    24(["7e4d16d2<br/>ASSERTION"])
    25["62c8b067<br/>#quot;userName#quot;"]
    26["ab4d524e<br/>#quot;Bob Bobbery#quot;"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    5 -->|pred| 6
    5 -->|obj| 7
    3 --> 8
    8 -->|pred| 9
    8 -->|obj| 10
    3 --> 11
    11 -->|pred| 12
    11 -->|obj| 13
    1 --> 14
    14 -->|pred| 15
    14 -->|obj| 16
    16 -->|subj| 17
    16 --> 18
    18 -->|pred| 19
    18 -->|obj| 20
    16 --> 21
    21 -->|pred| 22
    21 -->|obj| 23
    16 --> 24
    24 -->|pred| 25
    24 -->|obj| 26
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:red,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:red,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:red,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    style 16 stroke:red,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
    style 18 stroke:red,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    style 20 stroke:#55f,stroke-width:3.0px
    style 21 stroke:red,stroke-width:3.0px
    style 22 stroke:#55f,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px
    style 24 stroke:red,stroke-width:3.0px
    style 25 stroke:#55f,stroke-width:3.0px
    style 26 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
    linkStyle 5 stroke:#55f,stroke-width:2.0px
    linkStyle 6 stroke-width:2.0px
    linkStyle 7 stroke:green,stroke-width:2.0px
    linkStyle 8 stroke:#55f,stroke-width:2.0px
    linkStyle 9 stroke-width:2.0px
    linkStyle 10 stroke:green,stroke-width:2.0px
    linkStyle 11 stroke:#55f,stroke-width:2.0px
    linkStyle 12 stroke-width:2.0px
    linkStyle 13 stroke:green,stroke-width:2.0px
    linkStyle 14 stroke:#55f,stroke-width:2.0px
    linkStyle 15 stroke:red,stroke-width:2.0px
    linkStyle 16 stroke-width:2.0px
    linkStyle 17 stroke:green,stroke-width:2.0px
    linkStyle 18 stroke:#55f,stroke-width:2.0px
    linkStyle 19 stroke-width:2.0px
    linkStyle 20 stroke:green,stroke-width:2.0px
    linkStyle 21 stroke:#55f,stroke-width:2.0px
    linkStyle 22 stroke-width:2.0px
    linkStyle 23 stroke:green,stroke-width:2.0px
    linkStyle 24 stroke:#55f,stroke-width:2.0px
```

> _Complex metadata offers the best examples of sub-envelopes. See [the Metadata Example in the Envelope Docs](https://github.com/BlockchainCommons/BCSwiftSecureComponents/blob/master/Docs/07-EXAMPLES.md#example-10-complex-metadata) and [04-Metadata-Example](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/4-METADATA-EXAMPLE.md) in the Envelope-CLI docs._

## Wrapped Envelopes

In a semantic triple the assertion always refers to the subject. Multiple assertions _all_ refer to the same subject, such as the above example of Alice both liking Bob and hating Charlie. But what if you wanted an assertion to apply to an entire triple? For example, what if you wanted to say that Alice's knowing Bob was a fact that was known by Victor?

This **does not** do the job:
```
"Alice" [
    "knows": "Bob"
    "knownBy": "Victor"
]
```
That actually says that Alice knows Bob and that Alice is knownBy Victor. That's not the same thing at all!

In order to instead allow Victor to known about the other semantic triple requires the enclosure of the Alice-knows-Bob triple in a new envelope, which is then used as a subject that Victor can known. (As you should recall, _everything_, including the Subject, can be an envelope).

This is the other major use of sub-envelopes, but it's a common enough pattern that it has its own name: it's a "wrapped envelope".

Here's what that looks like:
```
{
    "Alice" [
        "knows": "Bob"
    ]
} [
    "knownBy": "Victor"
]
```
The use of wrapped envelopes makes Mermaid markup increasingly helpful:
```mermaid
graph LR
    1(("91c1b91f<br/>NODE"))
    2[/"26251b37<br/>WRAPPED"\]
    3(("e54d6fd3<br/>NODE"))
    4["27840350<br/>#quot;Alice#quot;"]
    5(["55560bdf<br/>ASSERTION"])
    6["7092d620<br/>#quot;knows#quot;"]
    7["9a771715<br/>#quot;Bob#quot;"]
    8(["9697280f<br/>ASSERTION"])
    9["c50842d3<br/>#quot;knownBy#quot;"]
    10["167d7e19<br/>#quot;Victor#quot;"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    5 -->|pred| 6
    5 -->|obj| 7
    1 --> 8
    8 -->|pred| 9
    8 -->|obj| 10
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:red,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
    linkStyle 5 stroke:#55f,stroke-width:2.0px
    linkStyle 6 stroke-width:2.0px
    linkStyle 7 stroke:green,stroke-width:2.0px
    linkStyle 8 stroke:#55f,stroke-width:2.0px

```
Because this makes it clear that the entire Alice-knows-Bob statement has been wrapped and that's what's `knownBy` Victor.

There are many different cases where applying an assertion to not just a subject but a full triple (that's been made into an envelope and then _used_ as a subject) is useful. One of those uses is a very common use case: signing.

## Signing Envelopes

One of the biggest advantages of wrapped envelopes is that you can use to allow someone to verify the entire assertion (or set of assertions) by using the wrapped envelope as a subject and applying a signature as an object using the "known" predicate of `verifiedBy`.

This is what that would look like:
```
{
    "Alice" [
        "knows": "Bob"
    ]
} [
    verifiedBy: Signature
]
```
Or alternatively:
```mermaid
graph LR
    1(("dafe540b<br/>NODE"))
    2[/"26251b37<br/>WRAPPED"\]
    3(("e54d6fd3<br/>NODE"))
    4["27840350<br/>#quot;Alice#quot;"]
    5(["55560bdf<br/>ASSERTION"])
    6["7092d620<br/>#quot;knows#quot;"]
    7["9a771715<br/>#quot;Bob#quot;"]
    8(["bec5b4b6<br/>ASSERTION"])
    9[/"d59f8c0f<br/>verifiedBy"/]
    10["42ce256f<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    5 -->|pred| 6
    5 -->|obj| 7
    1 --> 8
    8 -->|pred| 9
    8 -->|obj| 10
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:red,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
    linkStyle 5 stroke:#55f,stroke-width:2.0px
    linkStyle 6 stroke-width:2.0px
    linkStyle 7 stroke:green,stroke-width:2.0px
    linkStyle 8 stroke:#55f,stroke-width:2.0px
```
These verifications can later be checked to ensure that the subject envelope is what was actually signed by the `verifiedBy` assertion.

More complexity is possible, for example by attaching additional information on who is doing the verifying:
```
{
    {
        "Alice" [
            "knows": "Bob"
        ]
    } [
        "verifierInfo": CID(d44c5e0a) [
            "trustedSource": "https://www.blockchaincommons.com/pki/d44c5e0a"
            "userName": "Lil Alice"
            controller: CID(d44c5e0a)
            publicKeys: PublicKeyBase
        ]
    ]
} [
    verifiedBy: Signature
]
```

```mermaid
graph LR
    1(("8c4f3f0a<br/>NODE"))
    2[/"274f0982<br/>WRAPPED"\]
    3(("d86e0de6<br/>NODE"))
    4[/"26251b37<br/>WRAPPED"\]
    5(("e54d6fd3<br/>NODE"))
    6["27840350<br/>#quot;Alice#quot;"]
    7(["55560bdf<br/>ASSERTION"])
    8["7092d620<br/>#quot;knows#quot;"]
    9["9a771715<br/>#quot;Bob#quot;"]
    10(["700be255<br/>ASSERTION"])
    11["7e84d1a9<br/>#quot;verifierInfo#quot;"]
    12(("a3b77fbe<br/>NODE"))
    13["e002f28a<br/>CID(d44c5e0a)"]
    14(["3b59d039<br/>ASSERTION"])
    15[/"642917d0<br/>publicKeys"/]
    16["5de2a1fa<br/>PublicKeyBase"]
    17(["b2c213e3<br/>ASSERTION"])
    18["27980711<br/>#quot;trustedSource#quot;"]
    19["199092f0<br/>#quot;https://www.blockchaincommons.com/pki/d44c5e0a#quot;"]
    20(["e716c487<br/>ASSERTION"])
    21[/"2f9bee2f<br/>controller"/]
    22["e002f28a<br/>CID(d44c5e0a)"]
    23(["fea5d530<br/>ASSERTION"])
    24["62c8b067<br/>#quot;userName#quot;"]
    25["166d5ed7<br/>#quot;Lil Alice#quot;"]
    26(["8fc98ec3<br/>ASSERTION"])
    27[/"d59f8c0f<br/>verifiedBy"/]
    28["cd582abc<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    4 -->|subj| 5
    5 -->|subj| 6
    5 --> 7
    7 -->|pred| 8
    7 -->|obj| 9
    3 --> 10
    10 -->|pred| 11
    10 -->|obj| 12
    12 -->|subj| 13
    12 --> 14
    14 -->|pred| 15
    14 -->|obj| 16
    12 --> 17
    17 -->|pred| 18
    17 -->|obj| 19
    12 --> 20
    20 -->|pred| 21
    20 -->|obj| 22
    12 --> 23
    23 -->|pred| 24
    23 -->|obj| 25
    1 --> 26
    26 -->|pred| 27
    26 -->|obj| 28
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:red,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:red,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:red,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:red,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:red,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    style 20 stroke:red,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:#55f,stroke-width:3.0px
    style 23 stroke:red,stroke-width:3.0px
    style 24 stroke:#55f,stroke-width:3.0px
    style 25 stroke:#55f,stroke-width:3.0px
    style 26 stroke:red,stroke-width:3.0px
    style 27 stroke:#55f,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke:red,stroke-width:2.0px
    linkStyle 4 stroke:red,stroke-width:2.0px
    linkStyle 5 stroke-width:2.0px
    linkStyle 6 stroke:green,stroke-width:2.0px
    linkStyle 7 stroke:#55f,stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke:green,stroke-width:2.0px
    linkStyle 10 stroke:#55f,stroke-width:2.0px
    linkStyle 11 stroke:red,stroke-width:2.0px
    linkStyle 12 stroke-width:2.0px
    linkStyle 13 stroke:green,stroke-width:2.0px
    linkStyle 14 stroke:#55f,stroke-width:2.0px
    linkStyle 15 stroke-width:2.0px
    linkStyle 16 stroke:green,stroke-width:2.0px
    linkStyle 17 stroke:#55f,stroke-width:2.0px
    linkStyle 18 stroke-width:2.0px
    linkStyle 19 stroke:green,stroke-width:2.0px
    linkStyle 20 stroke:#55f,stroke-width:2.0px
    linkStyle 21 stroke-width:2.0px
    linkStyle 22 stroke:green,stroke-width:2.0px
    linkStyle 23 stroke:#55f,stroke-width:2.0px
    linkStyle 24 stroke-width:2.0px
    linkStyle 25 stroke:green,stroke-width:2.0px
    linkStyle 26 stroke:#55f,stroke-width:2.0px
```
Here we see that the core Alice-knows-Bob information has been wrapped and `verifierInfo` has been attached to it, and then that has been wrapped and signed. Whew! 

(Obviously, care still needs to be taken, with the verifier having a high degree of responsibility: they need to make sure the verifierInfo is correct to know that the signature is meaningful! A `trustedSource` has been suggested as a root of truth, but even that needs to be taken with a grain of salt!)

> _Further examples of Signing, including Multi-Signing, can be found in the [Examples of the Envelope Docs](https://github.com/BlockchainCommons/BCSwiftSecureComponents/blob/master/Docs/07-EXAMPLES.md#example-2-signed-plaintext) and the [Examples of the Envelope-CLI Docs](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/2-BASIC-EXAMPLES.md#example-2-signed-plaintext)._

## Hashing Envelopes

The Mermaid examples in this introduction all include the first four bytes of a hash digest for each node. This is a standard feature of Gordian Envelope: its nested triples form a structured Merkle Tree. 

We use the phrase "structured Merkle Tree" because the structure is not quite the same as a pure Merkle Tree:

In a pure Merkle Tree, leaves are ordered sequence of objects (such as Bitcoin Transactions) that carry semantic content, with intenal nodes then being hashes of their child nodes. In Gordian Envelopes, each element in the tree instead has a digest made from its semantic content and the content of its children. 

In other words, every point in a Gordian Envelope that carries a digest *also* carries semantic content, while in a Merkle tree, *only* the leaves carry semantic content.

Hashes can be used to prove the contents of an Envelope and its sub-envelopes without necessarily revealing the contents. This becomes important for the last two major capabilities of Gordian Envelopes: elision and encryption.

## Eliding Envelopes

One of the biggest advances of Gordian Envelope is that it includes elision as a fundamental principle. Any element of an Envelope may be elided; the elision may be done by the Holder (not just an Issuer, as is the case with most extant credential data structures); and elision does not change the hashes of the Envelope.

Take as an example the signed Alice Knows Bob example:
```mermaid
graph LR
    1(("42042a40<br/>NODE"))
    2[/"26251b37<br/>WRAPPED"\]
    3(("e54d6fd3<br/>NODE"))
    4["27840350<br/>#quot;Alice#quot;"]
    5(["55560bdf<br/>ASSERTION"])
    6["7092d620<br/>#quot;knows#quot;"]
    7["9a771715<br/>#quot;Bob#quot;"]
    8(["82fc5394<br/>ASSERTION"])
    9[/"d59f8c0f<br/>verifiedBy"/]
    10["899b3e05<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    5 -->|pred| 6
    5 -->|obj| 7
    1 --> 8
    8 -->|pred| 9
    8 -->|obj| 10
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:red,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
    linkStyle 5 stroke:#55f,stroke-width:2.0px
    linkStyle 6 stroke-width:2.0px
    linkStyle 7 stroke:green,stroke-width:2.0px
    linkStyle 8 stroke:#55f,stroke-width:2.0px
```

Note the hashes: `27840350` for Alice, `55560bdf` for the Knows-Bob Assertion, `e54d6fd3` for the overall Node, and `26251b37` for the Wrapped Envelope of that Node. (We're ignoring the `verifiedBy` assertion and also the overall node because signature hashes _will_ change every time they're signed, as a natural characteristic of how signing works: it has a random factor.)

We can elide everything but the signature and see that the hashing holds up:
```mermaid
graph LR
    1(("e254c912<br/>NODE"))
    2{{"26251b37<br/>ELIDED"}}
    3(["22f775c6<br/>ASSERTION"])
    4[/"d59f8c0f<br/>verifiedBy"/]
    5["890246c3<br/>Signature"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
```
That `26251b37` was indeed the hash of the signed envelope that is currently elided.

As we reveal things step-by-step, known hashes appear, allowing for selective disclosure of exactly the material we want to reveal, while maintaining verifiability:
```mermaid
graph LR
    1(("e254c912<br/>NODE"))
    2[/"26251b37<br/>WRAPPED"\]
    3{{"e54d6fd3<br/>ELIDED"}}
    4(["22f775c6<br/>ASSERTION"])
    5[/"d59f8c0f<br/>verifiedBy"/]
    6["890246c3<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    1 --> 4
    4 -->|pred| 5
    4 -->|obj| 6
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 4 stroke:red,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke-width:2.0px
    linkStyle 3 stroke:green,stroke-width:2.0px
    linkStyle 4 stroke:#55f,stroke-width:2.0px
```

```mermaid
graph LR
    1(("e254c912<br/>NODE"))
    2[/"26251b37<br/>WRAPPED"\]
    3(("e54d6fd3<br/>NODE"))
    4{{"27840350<br/>ELIDED"}}
    5{{"55560bdf<br/>ELIDED"}}
    6(["22f775c6<br/>ASSERTION"])
    7[/"d59f8c0f<br/>verifiedBy"/]
    8["890246c3<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 5 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
```
In this case, we might reveal that Alice is the subject of an assertion, without having to reveal the other half of the equation:
```mermaid
graph LR
    1(("e254c912<br/>NODE"))
    2[/"26251b37<br/>WRAPPED"\]
    3(("e54d6fd3<br/>NODE"))
    4["27840350<br/>#quot;Alice#quot;"]
    5{{"55560bdf<br/>ELIDED"}}
    6(["22f775c6<br/>ASSERTION"])
    7[/"d59f8c0f<br/>verifiedBy"/]
    8["890246c3<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
```
However, this example is obviously abstract, and intended mainly for its simplicity. In a more realistic case, a Gordian Envelope with multiple assertions would be partially elided to only reveal some of what it contains.

Remember Alice's two-part Envelope?

```mermaid
graph LR
    1(("dfe1b6bc<br/>NODE"))
    2["27840350<br/>#quot;Alice#quot;"]
    3(["0ded3ac1<br/>ASSERTION"])
    4["490cfb03<br/>#quot;likes#quot;"]
    5["9a771715<br/>#quot;Bob#quot;"]
    6(["709b5749<br/>ASSERTION"])
    7["4850740d<br/>#quot;hates#quot;"]
    8["266d128b<br/>#quot;Charlie#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
```
In this example, she might want to reveal that she likes Bob without revealing that she hates Charlie!
```mermaid
graph LR
    1(("dfe1b6bc<br/>NODE"))
    2["27840350<br/>#quot;Alice#quot;"]
    3(["0ded3ac1<br/>ASSERTION"])
    4["490cfb03<br/>#quot;likes#quot;"]
    5["9a771715<br/>#quot;Bob#quot;"]
    6{{"709b5749<br/>ELIDED"}}
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
```
Again, note that all the hashes have stayed the same, even for the Elided branch and its parent.

To make this abstract example even more realistic, in the case of credentials the Holder could choose which credentials to share and which not to.

> _Further examples of redaction may be found in [09-Elision-Redaction](https://github.com/BlockchainCommons/BCSwiftSecureComponents/blob/master/Docs/09-ELISION-REDACTION.md) in the Envelope Docs and [07-VC-Elision-Example](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/7-VC-ELISION-EXAMPLE.md) in the Envelope-CLI docs._

## Encrypting Envelopes

Obviously, the critical tool in the Gordian-Envelope toolbox is encryption, as it allows for the protection of contents.

This penultimate example uses the old favorite:
```
"Alice" [
    "knows": "Bob"
]
```
```mermaid
graph LR
    1(("e54d6fd3<br/>NODE"))
    2["27840350<br/>#quot;Alice#quot;"]
    3(["55560bdf<br/>ASSERTION"])
    4["7092d620<br/>#quot;knows#quot;"]
    5["9a771715<br/>#quot;Bob#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
```

Just as with any assertion, encryption applies to the Subject. So the default application of Encryption on Alice-Knows-Bob would result in the following:
```
ENCRYPTED [
    "knows": "Bob"
]
```
```mermaid
graph LR
    1(("e54d6fd3<br/>NODE"))
    2>"27840350<br/>ENCRYPTED"]
    3(["55560bdf<br/>ASSERTION"])
    4["7092d620<br/>#quot;knows#quot;"]
    5["9a771715<br/>#quot;Bob#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
```
(Note once more than the hash of the root node stayed the same!)

The fact that only the subject is encrypted means that wrapping is again required if you want to encrypt the entire contents of an Envelope.

Wrapping results in:
```
{
    "Alice" [
        "knows": "Bob"
    ]
}
```
```mermaid
graph LR
    1[/"26251b37<br/>WRAPPED"\]
    2(("e54d6fd3<br/>NODE"))
    3["27840350<br/>#quot;Alice#quot;"]
    4(["55560bdf<br/>ASSERTION"])
    5["7092d620<br/>#quot;knows#quot;"]
    6["9a771715<br/>#quot;Bob#quot;"]
    1 -->|subj| 2
    2 -->|subj| 3
    2 --> 4
    4 -->|pred| 5
    4 -->|obj| 6
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:#55f,stroke-width:3.0px
    style 4 stroke:red,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
```
Then encrypting reduces that to:
```
ENCRYPTED
```
```mermaid
graph LR
    1>"26251b37<br/>ENCRYPTED"]
    style 1 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
```

Which is probably what was intended in the first place!

There is a change in the hash from the standard Alice-Knows-Bob envelope, but that's because we're now seeing the hash of the wrapped envelope:


A wrapped, encrypted envelope can continue to be layered, for example by signing the encrypted data:
```
ENCRYPTED [
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("1cb67ce6<br/>NODE"))
    2>"26251b37<br/>ENCRYPTED"]
    3(["c36a040c<br/>ASSERTION"])
    4[/"d59f8c0f<br/>verifiedBy"/]
    5["aac82a4a<br/>Signature"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
```
Once more, it's envelopes all the way down!

> _For further examples see [Symmetric Encryption](https://github.com/BlockchainCommons/BCSwiftSecureComponents/blob/master/Docs/07-EXAMPLES.md#example-4-symmetric-encryption) and additional examples in the Envelope Docs and [Symmetric Encryption](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/2-BASIC-EXAMPLES.md#example-4-symmetric-encryption) and additional examples in the Envelope-CLI docs._

## Salting Envelopes

The above examples on hashing, eliding, and encrypting all depend on selective correlation: we're using hashes to purposefully allow correlation, in order to suport the use of inclusion proofs or other means of selective disclosure.

This is _not_ always a desirable characteristic. If guesses can be made about the contents of elided or encrypted data, they can be solved! In situations where that is an issue, Gordian Envelope supports salting.

The methodology behind salting is simple: add a new assertion to an Envelope that contains `salt` as a predicate and a random number as an object.

This is particularly useful when adding it to a subject, predicate, or object that might be easily guessable and that you don't _want_ to be easily guessable. The subject, predicate, or object becomes an evelope containing salt as an assertion.

The following example shows a salt of the subject "Alice":
```
{
    "Alice" [
        salt: Salt
    ]
} [
    "knows": "Bob"
```
```mermaid
graph LR
    1(("f528392b<br/>NODE"))
    2[/"b2878630<br/>WRAPPED"\]
    3(("747c7893<br/>NODE"))
    4["27840350<br/>#quot;Alice#quot;"]
    5(["ed1f2a9b<br/>ASSERTION"])
    6[/"3fb4814d<br/>salt"/]
    7["ef62bb64<br/>Salt"]
    8(["55560bdf<br/>ASSERTION"])
    9["7092d620<br/>#quot;knows#quot;"]
    10["9a771715<br/>#quot;Bob#quot;"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    5 -->|pred| 6
    5 -->|obj| 7
    1 --> 8
    8 -->|pred| 9
    8 -->|obj| 10
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:red,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
    linkStyle 5 stroke:#55f,stroke-width:2.0px
    linkStyle 6 stroke-width:2.0px
    linkStyle 7 stroke:green,stroke-width:2.0px
    linkStyle 8 stroke:#55f,stroke-width:2.0px
```
The standard hash of "Alice", `27840350`, is now replaced with a wrapped Envelope hash of `c0f5df62` thanks to the inclusion of salt. Where a brute-force search might be able to determine that Alice were `27840350` even when Alice was elided or encrypted, the same would not be true for the salted hash of `c0f5df62`.

Different use cases might require that selective correlation should either be used or foiled; salt is what makes the latter happen.

> For further examples see [08-Noncorrelation](https://github.com/BlockchainCommons/BCSwiftSecureComponents/blob/master/Docs/08-NONCORRELATION.md) in the Gordian Envelope docs.

## Final Notes

This technical introduction is intended to give a broad overview of the major capabilities of Gordian Envelopes with diagrams demonstrating what those Envelopes actually look like.

For further details please see the [Envelope Docs](https://github.com/BlockchainCommons/BCSwiftSecureComponents/tree/master/Docs) and if you are able, follow-along with the [Envelope-CLI Docs](https://github.com/BlockchainCommons/envelope-cli-swift/tree/master/Docs). Those documents provide _much_ more detail on all the examples here. In some cases the examples here were drawn from those docs.



