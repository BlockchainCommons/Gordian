# Gordian Envelope<br/>A Flexible Container for Structured Data

## Overview

The envelope protocol specifies a structured format for hierarchical binary data focused on the ability to transmit it in a privacy-focused way. Envelopes are designed to facilitate "smart documents" and have a number of unique features including: easy representation of a variety of semantic structures, a built-in Merkle-like digest tree, deterministic representation using CBOR, and the ability for the holder of a document to selectively encrypt or elide specific parts of a document without invalidating the document structure including the digest tree, or any cryptographic signatures that rely on it.

## Implementations

Language|Type|Repo|API Docs
-|-|-|-
Swift|Reference|[BCSwiftEnvelope](https://github.com/blockchaincommons/BCSwiftEnvelope)|[📔](https://blockchaincommons.github.io/BCSwiftEnvelope/documentation/envelope/)
Rust|Reference|Forthcoming
Python|Reference|Forthcoming

## Resources

- [IETF Draft Specification: The Envelope Structured Data Format](https://datatracker.ietf.org/doc/draft-mcnally-envelope/)
- [Video: Introduction to Gordian Envelope](https://www.youtube.com/watch?v=kQm7irWFi5U)
- [Video: Gordian Architecture: Why CBOR?](https://www.youtube.com/watch?v=uoD5_Vr6qzw)
- [Video: Diffing with Gordian Envelope](https://www.youtube.com/watch?v=kXk_XTACqh8)

## Topics

* [Overview](Overview.md)
* [Examples](Examples.md)
* [Envelope Notation](Notation.md)
* [Output Formats](OutputFormats.md)
* [Elision/Redaction](Elision.md)
* [Noncorrelation](Noncorrelation.md)
* [Existence Proofs](ExistenceProofs.md)
* [Diffing Envelopes](Diffing.md)
* [Envelope Expressions](Expressions.md)

_Please see our published [Gordian Envelope Introduction](https://www.blockchaincommons.com/introduction/Envelope-Intro/)._
