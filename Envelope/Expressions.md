# Envelope Expressions

Envelope Expressions are a method for encoding machine-evaluatable expressions using ``Envelope``.

## Overview

This is an early draft specification.

We provide a method for encoding machine-evaluatable expressions using `Envelope`. Evaluating expressions produces results that can substitute in-place for the original unevaluated expression, although the replacement may have a different digest.

Ideally the method of encoding expressions would have the following traits:

* Allow any mathematical or algorithmic expressions, including the evalution of spending conditions and smart contracts.
* Be easy for humans to read.
* Leverage the existing Envelope notation.
* Support easy [composition](https://en.wikipedia.org/wiki/Function_composition).
* Support scoped variable substitution.
* Be [homoiconic](https://en.wikipedia.org/wiki/Homoiconicity).

Evaluating expressions produces results that can substitute in-place for the original unevaluated expression, although the replacement may have a different digest.

## Well-Known Expressions

Since every Envelope has a unique digest, any Envelope expression can be replaced by its digest as long as the expression can be found that matches it. In some cases, certain expressions may be so common as to be designated "well known". In this case they can be represented by their digest alone or even a small tagged integer, trusting that the recipient of an Envelope can resolve the expression should they wish to evaluate it. Expressions that solve problems in specific domains and include placeholders for their arguments may be good candidates for this, one example being common cryptocurrency spending conditions.

Even for expressions that are not "well known," like any other `Envelope`, an expression could appear as a reference to a `Digest` with one or more `dereferenceVia` assertions that tell the evaluator how to retrieve the expression that belongs in that place.

## Example Expressions

All of these examples are in envelope notation.

### Constants

Constants like numbers, strings, and even compound data types like `EncryptedMessage` are directly encodable as an Envelope whose subject is an instance of the constant's CBOR type. Obviously, they evaluate to themselves.

```
2
```

```
"Hello"
```

```
ENCRYPTED
```

### Errors

An expression evaluation that fails for syntactical or semantic reasons results in an error that may include assertions providing diagnostic information:

```
Error [
    note: "Index out of range."
]
```

### Binary Operator

The subject of an `Envelope` that may be evaluated as an expression is tagged `func`, and each parameter to the function is a predicate tagged `param` with the object that supplies the argument. The Envelope expression language therefore uses a form of named parameters, although it is not limited to this paradigm. The purpose of tagging functions and parameters is to make them easily machine-distinguishable from other metadata.

Assertions that are not tagged as parameters are ignored by the expression evaluator. Assertions that are tagged as parameters but are either not expected by the function, or have duplicate predicates are an error. Functions may have parameters that are required or optional, and not supplying all required parameters is an error.

So the expression `2 + 3` might be encoded:

```
func(add) [
    param(lhs): 2
    param(rhs): 3
    note: "The result of adding two numbers."
]
```

When evaluated, the result is an Envelope that may be substituted for the original expression:

```
5
```

**NOTE:** In the remainder of this document, `func(name)` is denoted as `«name»` and `param(name)` is denoted as `❰name❱`

### Unary Operator

Unary operators are simply functions of arity one. One parameter name may be blank, denoted `❰_❱`. This is most frequently seen with unary operators.

```
«negate» [
    ❰_❱: 10
]
```

```
-10
```

### Function Composition

The composition `f(g(x))`:

```
«f» [
    ❰_❱: «g» [
        ❰_❱: $x
    ]
]
```

### Logical Predicates

Operators that evaluate to boolean values are often known as "predicates". To avoid confusing them with the "predicate" role in the Envelope type and in the nomenclature of semantic triples, we refer to these operations as "logical predicates" and where further clarification is needed, the other type as "semantic predicates".

`5 > 2` may be encoded as:

```
«greaterThan» [
    ❰lhs❱: 5
    ❰rhs❱: 10
]
```

```
false
```

### Function Call (N-ary Operator)

Function calls of any arity may be encoded:

```
verifySignature(key: pubkey, sig: signature, digest: sha256(message)) -> Bool
```

```
«verifySignature» [
    ❰key❱: SigningPublicKey
    ❰sig❱: Signature
    ❰digest❱: «sha256» [
        ❰_❱: Data
    ]
]
```

The `verifySignature` function is a logical predicate. The result of this expression is a boolean value that would typically be used as the object of an assertion.

### Structured Parameters

Functions may take parameters that are sequences encoded as CBOR arrays, or dictionaries encoded as CBOR maps.

```
«concatenate» [
    ❰_❱: ["Foo", "Bar", "Baz"]
]
```

```
FooBarBaz
```

### Distributed Function Calls

A distributed function call (also known as a "remote procedure call") is a call invoked on systems that do not reside in the same process as the caller.

Due to latency and availability, all distributed function calls are by nature asynchronous, and any distributed function call may fail. The caller of a function may expect a particular result of that call, and that result needs to be routed back to the calling process.

To facilitate this, we generate a unique CID and tag it `request`. This becomes the subject of an envelope that must contain an assertion with `body` as the `predicate`, and the `object` must be an envelope expression as described herein. The wrapping `request(CID)` provides a unique identifier used to route the result of the request back to the caller:

```
request(CID(a5d19014d54d40a9ed03ca9bc487a2729271c43811a4d5a4247e704f2c61ae3e)) [
    body: «add» [
        ❰lhs❱: 2
        ❰rhs❱: 3
    ]
]
```

Once the expression has been evaluated, its result is returned in an envelope with `response(CID)` as the subject. The response CID must match the request CID. The returned envelope must contain an assertion with the predicate `result` and the object being the result of the evaluation, which may be an Error as described above.

```
response(CID(a5d19014d54d40a9ed03ca9bc487a2729271c43811a4d5a4247e704f2c61ae3e)) [
    result: 5
]
```

Any party to a request/response may use the CID as a way of discarding duplicates, avoiding replays, or as input to a cryptographic algorithm. See the [CID specification](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2022-002-cid-common-identifier.md) for more information.

Because the functionality of envelope is composable, the outer envelope of a request or a response can be signed as a way of authenticating the request, and if necessary the request and/or response can be encrypted by any of the available methods.

A request may contain further instructions on the channels via which it may be responded to. For example, a request may be scanned with a QR code, and that request may include a URL with a REST endpoint via which to return the result:

```
request(CID(a5d19014d54d40a9ed03ca9bc487a2729271c43811a4d5a4247e704f2c61ae3e)) [
    body: «add» [
        ❰lhs❱: 2
        ❰rhs❱: 3
    ]
    respondVia: URI(https://example.com/api/receive-response)
]
```

### Variable Substitution and Partially-Applied Expressions

Envelope expressions support scoped variable substitution.

Subjects that are CBOR unsigned integers or CBOR strings and tagged `placeholder` (`$`) identify the targets of subtitutions.

Corresponding predicates that are CBOR unsigned integers or CBOR strings and tagged `replacement` (`/`) identify the sources of substutions, which can themselves be arbitrarily complex.

```
{
    «verifySignature» [
        ❰key❱: $key
        ❰sig❱: $sig
        ❰digest❱: «sha256» [
            ❰_❱: $message
        ]
    ]
} [
    /key: SigningPublicKey
    /sig: Signature
    /message: Data
]
```

#### Complete Replacement

The scope of replacement is recursive, but stops at any separately enclosed envelopes.

In this example, there is only a top set of replacements, so all variables are substituted. The result of evaluating this expression is `610`:

```
{
    «add» [
        ❰lhs❱: $a
        ❰rhs❱: «multiply» [
            ❰lhs❱: $b
            ❰rhs❱: $c
        ]
    ]
} [
    /a: 10
    /b: 20
    /c: 30
]
```

#### Scoped Replacement

In this case, the `rhs` argument of the top-level function has been enclosed, so the enclosed substitutions are considered to be in a different scope:

```
{
    «add» [
        ❰lhs❱: $a
        ❰rhs❱: {
            «multiply» [
                ❰lhs❱: $b
                ❰rhs❱: $c
            ]
        }
    ]
} [
    /a: 10
    /b: 20
    /c: 30
]
```

Because of this, when the above expression is evaluated only the `$a` substitution is made, and the expression result is only partially applied:

```
«add» [
    ❰lhs❱: 10
    ❰rhs❱: {
        «add» [
            ❰lhs❱: $b
            ❰rhs❱: $c
        ]
    }
]
```

#### Replacement with Rescoping

In this version, the inner expression has its own `replacement` assertions that pass the outer replacements inward under different names. One of these replacements is itself an expression:

```
{
    «add» [
        ❰lhs❱: $a
        ❰rhs❱: {
            «multiply» [
                ❰lhs❱: $d
                ❰rhs❱: $e
            ]
        } [
            /d: $c
            /e: «add» [
                ❰lhs❱: $b
                ❰rhs❱: 2
            ]
        ]
    ]
} [
    /a: 10
    /b: 20
    /c: 30
]
```

By successive substitution, this expression evaluates to:

1. `$a + $d * $e`
2. `$a + $c * ($b + 2)`
3. `10 + 30 * (20 + 2)`
4. `10 + 30 * 22`
5. `10 + 660`
6. `670`

### Higher-Ordered Functions

Functions may take functions as parameters.

```
«map» [
    ❰_❱ : [3, 4, 5]
    ❰transform❱: «mul» [
        ❰lhs❱: $0
        ❰rhs❱: $0
    ]
]
```

This expression evaluates to:

```
[9, 16, 25]
```

Each application of the `❰transform❱` expression to an element of the `❰_❱` argument results in a replacement expression:

```
{
    «mul» [
        ❰lhs❱: $0
        ❰rhs❱: $0
    ]
} [
    /0: 4
]
```

By substitution:

```
«mul» [
    ❰lhs❱: 4
    ❰rhs❱: 4
]
```

And finally:

```
16
```

### Structured Programming

Functions may perform tests yielding different evaluation paths. For example the conditional expression in C-like languages: `20 > 10 ? "Big" : "Small"` may be encoded as:


```
«if» [
    ❰test❱: «greaterThan» [
        ❰lhs❱: 20
        ❰rhs❱: 10
    ]
    ❰true❱: "Big"
    ❰false❱: "Small"
]
```

```
"Big"
```

### Atomic Swap

In this example an [adaptor signature](https://bitcoinops.org/en/topics/adaptor-signatures/) is represented by the type `EncryptedSignature`, and a "hidden value" or "tweak" is represented by the type `DecryptionKey`.

Alice and Bob wish to execute an atomic coin swap.

First, Alice gives Bob an unsigned transaction that promises to pay him 1 BTC. The transaction includes a `signature` assertion that when evaluated correctly will yield a valid signature for Alice's transaction.

The `encryptedSignature` parameter of the `decryptSignature` function is already filled out by Alice with her `EncryptedSignature`. An `EncryptedSignature` by itself can’t be used as a BIP-340 signature, so Alice hasn’t paid Bob yet:

```
Transaction(Alice) [
    signature: «decryptSignature» [
        ❰encryptedSignature❱: EncryptedSignature(Alice)
        ❰decryptionKey❱: «recoverDecryptionKey» [
            ❰message❱: «digest» [
                ❰_❱: $transaction
            ]
            ❰encryptedSignature❱: $encryptedSignature
            ❰signature❱: $signature
        ]
    ]
]
```

What Alice's `EncryptedSignature` does provide Bob is a commitment to Alice’s `DecryptionKey`. This commitment includes a parameter Bob can use to create a second `EncryptedSignature` that commits to the same `DecryptionKey` as Alice’s `EncryptedSignature`. Bob can make that commitment even without knowing Alice’s `DecryptionKey` or his own signature for that commitment.

Bob gives Alice his unsigned transaction that promises to pay her 1 BTC, along with a `signature` assertion containing his `EncryptedSignature`. Unlike Alice's `signature` assertion, which requires Bob to know the signature for Alice's transaction (which she hasn't placed on the network yet), this expression requires Alice to know the `DecryptionKey`:

```
Transaction(Bob) [
    signature: «recoverSignature» [
        ❰message❱: «digest» [
            ❰_❱: $transaction
        ]
        ❰encryptedSignature❱: EncryptedSignature(Bob)
        ❰decryptionKey❱: $decryptionKey
    ]
]
```

Alice has always known the `DecryptionKey`, so she can use it to decrypt Bob’s `EncryptedSignature` to get his signature for the transaction that pays her:

```
{
    Transaction(Bob) [
        signature: «recoverSignature» [
            ❰message❱: «digest» [
                ❰_❱: $transaction
            ]
            ❰encryptedSignature❱: EncryptedSignature(Bob)
            ❰decryptionKey❱: $decryptionKey
        ]
    ]
} [
    /transaction: Transaction(Bob)
    /decryptionKey: DecryptionKey
]
```

After the replacements are performed:

```
Transaction(Bob) [
    signature: «recoverSignature» [
        ❰message❱: «digest» [
            ❰_❱: Transaction(Bob)
        ]
        ❰encryptedSignature❱: EncryptedSignature(Bob)
        ❰decryptionKey❱: DecryptionKey
    ]
]
```

After the expression is evaluated:

```
Transaction(Bob) [
    signature: Signature(Bob)
]
```

Alice broadcasts the transaction and receives Bob’s payment. When Bob sees that transaction onchain, he can combine its signature with the adaptor he gave Alice, allowing him to derive the hidden value. Then he can combine that hidden value with the adaptor Alice gave him earlier.

```
{
    Transaction(Alice) [
        signature: «decryptSignature» [
            ❰encryptedSignature❱: EncryptedSignature(Alice)
            ❰decryptionKey❱: «recoverDecryptionKey» [
                ❰message❱: «digest» [
                    ❰_❱: $transaction
                ]
                ❰encryptedSignature❱: $encryptedSignature
                ❰signature❱: $signature
            ]
        ]
    ]
} [
    /transaction: Transaction(Alice)
    /encryptedSignature: EncryptedSignature(Bob)
    /signature: Signature(Bob)
]
```

After the replacements:

```
Transaction(Alice) [
    signature: «decryptSignature» [
        ❰encryptedSignature❱: EncryptedSignature(Alice)
        ❰decryptionKey❱: «recoverDecryptionKey» [
            ❰message❱: «digest» [
                ❰_❱: Transaction(Alice)
            ]
            ❰encryptedSignature❱: EncryptedSignature(Bob)
            ❰signature❱: Signature(Bob)
        ]
    ]
]
```

After the expression is evaluated:

```
Transaction(Alice) [
    signature: Signature(Alice)
]
```

Bob broadcasts that transaction to receive Alice’s payment, completing the coinswap.

## See Also

- <doc:Expressions>
