# Why CBOR?

The Concise Binary Object Representation, or CBOR, was chosen as the foundational data structure for Gordian specifications such as Envelope and URs for a variety of reasons. These include:

1. **IETF Standardization.** CBOR is a mature open international [IETF standard](https://cbor.io/spec.html).
1. **IANA Registration.** CBOR is further standardized by the registration of common data types [through IANA](https://www.iana.org/assignments/cbor-tags/cbor-tags.xhtml).
1. **Fully Extensible.** Beyond that, CBOR is entirely extensible with any data types desired, such as our own [listing of UR tags](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-006-urtypes.md).
1. **Self-describing Descriptions.** Data is self-describing, so there are no requirements for pre-defined schemas nor more complex descriptions such as those found in ASN.1.
1. **Streaming Friendly.** CBOR works well with streaming without requirements for extra memory; its tagging system allows for data to be skipped if it is irrelevent or unknown.
1. **Constraint Friendly.** CBOR is built to be frugal with CPU and memory, so it works well in constrained environments such as on cryptographic silicon chips.
1. **Unambiguous Encoding.** Our use of Deterministic CBOR, combined with our own specification rules, such as the sorting of Envelopes by hash, results in a singular, unambiguous encoding.
1. **Multiple Implementations.** Implementation are available [in a variety of languages](http://cbor.io/impls.html).
1. **Compact Implementations.** Compactness of encoding and decoding is one of CBOR's core goals; implementations are built on headers or snippets of code, and do not require any external tools.

Also see [a comparison to Protocol Buffers](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-005-ur.md#qa), [a comparison to Flatbuffers](https://stackoverflow.com/questions/47799396/flatbuffers-vs-cbor), and [a comparison to other binary formats](https://www.rfc-editor.org/rfc/rfc8949#name-comparison-of-other-binary-).
