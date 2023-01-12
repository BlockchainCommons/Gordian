# Diffing Envelopes

## Overview

Comparing two structures like text strings for the minimum number of changes necessary to convert one to the other is called the [edit distance problem](https://en.wikipedia.org/wiki/Edit_distance). The Unix `diff` command is used to compare two files (the "source" and "target") and produce a set of changes ("edits") that can be applied to the source (using the `patch` command) to reproduce the target. The set of edits is generally smaller than either the source or the target unless the source and/or target are very small, or the contents of the two are very different.

The reference implementation for Gordian Envelopes contains an implementation of diffing specifically for envelopes. This implementation uses the [Zhang-Shasha ordered tree edit distance algorithm](http://grantjenks.com/wiki/_media/ideas/simple_fast_algorithms_for_the_editing_distance_between_tree_and_related_problems.pdf) to produce a minimal set of edits needed to transform one envelope into the other. Note that while this is a general solution for diffing envelopes, it does not immediately lend itself to a solution for "merging" envelopes.

As an aside, it is interesting to note that `git` [does not store diffs](https://dev.to/shiva/git-does-not-store-diffs-3dbn).

## Comparing Envelopes: Semantic Equivalence and Structural Identicality

When comparing two envelopes, it is important to distinguish between two different ways of comparing them. *Semantic equivalence* is accomplished by comparing the digests of two envelopes. If they are equal, then it means that the two envelopes would contain the same information *in their unelided and unencrypted forms*. Since elision and encryption preserve the digest tree, envelopes that have been elided or encrypted are considered to be *semantically equivalent* to their unelided or unencrypted forms.

However, elided and encrypted envelopes are in fact different *structurally* from their unelided or unencrypted forms. When we're comparing envelopes for the purpose of finding a set of edits we can apply to transform one envelope into another, we want to consider not *semantic equivalence* but rather *structure identicality*.

In the reference implementation, envelopes can be compared for semantic equivalence by either comparing their `digest` attributes directly, or by using the `isEquivalent` method. Envelopes can be compared for structural identicality by comparing their `structuralDigest` attributes, or by using the `isIdentical` method. Generally the `isIdentical` method is preferred because accessing the `structuralDigest` attribute actually walks the envelope structure to compute it, while the `digest` field is always precomputed and cached. So the `isIdentical` method checks for semantic equivalence first, which is fast: if two envelopes are not *semantically* equivalent, then they cannot be *structurally* equivalent. If it turns out they are semantically equivalent, it then compares them for structural identicality.

```swift
func testExampleEquivalence() throws {
    let e1 = Envelope("Alice")
    let e2 = e1.elide()

    // Envelopes are equivalent
    XCTAssertEqual(e1.digest, e2.digest)
    XCTAssertTrue(e1.isEquivalent(to: e2))

    // ...but not identical
    XCTAssertNotEqual(e1.structuralDigest, e2.structuralDigest)
    XCTAssertFalse(e1.isIdentical(to: e2))
}
```

## Diffing Example 1

Consider the following two envelopes:

```
"Alice" [
    "knows": "Bob"
]
```

```
"Carol" [
    "knows": "Bob"
]
```

There is one edit required to change the first envelope into the second: changing the subject of the envelope from "Alice" to "Carol". Here is the Swift code to create these two envelopes, diff them to create the set of necessary edits, apply that set of edits to the first envelope, and then check to make sure that the result is structurally identical to the original:

```swift
func testExample1() throws {
    let e1 = Envelope("Alice")
        .addAssertion("knows", "Bob")
    let e2 = Envelope("Carol")
        .addAssertion("knows", "Bob")
    let edits = e1.diff(target: e2)
    let e3 = try e1.transform(edits: edits)
    XCTAssert(e3.isIdentical(to: e2))
}
```

Envelopes `e1` and `e2` are the source and target, `edits` is the list of edits needed, and `e3` is the result of applying the edits to `e1`. The function finishes by asserting that `e3` must be structurally identical to `e2`, the target.

The edits themselves are conveyed as an envelope. Generally speaking their contents aren't of interest to users, but here is what the edits for the above transformation looks like:

```
edits: [1, [3, [0, "Carol"]]]
```

The envelope is a bare assertion with the known value `edits` as its predicate and a CBOR array as its `object`. The first element of the array is the version number, each subsequent element of the array represents a deletion, renaming, or insert of a node into the tree. The specific format of the edits is considered opaque, and edits not starting with the version number `1` will be incompatible.

Because edits are themselves conveyed using an envelope, edits can be authenticated by signing, encrypted, or anything else that envelopes can do.

## Diffing Example 2

This is a somewhat more complex example that shows an initial envelope that already has one of its assertions encrypted and then which has several edits made to it, including deletion of some assertions, then being wrapped and signed, and then elided.

```swift
func testExample2() throws {
    let e1 = try Envelope("Alice")
        .addAssertion(Envelope("knows", "Bob").encryptSubject(with: SymmetricKey()))
        .addAssertion("knows", "Carol")
        .addAssertion("knows", "Edward")
        .addAssertion("knows", "Geraldine")
    let e2 = try e1
        .addAssertion("knows", "Frank")
        .removeAssertion(Envelope("knows", "Edward"))
        .removeAssertion(Envelope("knows", "Geraldine"))
        .wrap()
        .sign(with: PrivateKeyBase())
        .elideRemoving(Envelope("knows", "Carol").digest)
    let edits = e1.diff(target: e2)
    let e3 = try e1.transform(edits: edits)
    XCTAssert(e3.isIdentical(to: e2))
}
```

Source (encoded size, 188 bytes):

```
"Alice" [
    "knows": "Carol"
    "knows": "Edward"
    "knows": "Geraldine"
    ENCRYPTED
]
```

Target (encoded size, 258 bytes):

```
{
    "Alice" [
        "knows": "Frank"
        ELIDED
        ENCRYPTED
    ]
} [
    verifiedBy: Signature
]
```

Edits (encoded size, 174 bytes):

```
edits: [1, 5, 4, 3, [10, [1]], [1, [0, "Frank"]], [7, [2, verifiedBy]], [8, [0, Signature]], [21, [0, "Alice"], 10, 0, 2, [2, 0, 1, 6, 22]], [22, [5, Digest(71a30690)], 21, 2, 3]]
```
