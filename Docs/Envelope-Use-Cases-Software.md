## Gordian Envelope Use Case: Software Signing

Envelopes can be used in a variety of collaborative forms. Following are examples of collaborative signing, where a group of individuals jointly declare the validity of an envelope to ensure the trustworthiness of a software release.  The three use cases are presented progressively, demonstrating how a group of users can jointly validate the contents of an envelope, even as the group evolves over time.

Gordian Envelopes are useful for signing applications in large part because of their ability to combine signatures with metadata and to chain that information over time through multiple signed documents. This allows for the creation of a history of signatures, which can have a variety of applications.

* #1: [Casey Codifies Software Releases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Software.md#1-casey-codifies-software-releases-multiple-signatures-structured-data)
* #2: [Casey Chains His Software Releases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Software.md#2-casey-chains-his-software-releases-chained-data)
* #3: [Casey Changes Up His Software Releases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Software.md#3-casey-changes-up-his-software-releases-chained-changes)

## Software Signing

This set of use cases describes how a user can structure and sign data, how he can chain envelopes of data over time, and how he can change up signers over time. They demonstrate how well-structured envelopes can decrease validation costs and improve trust.

### 1. Casey Codifies Software Releases [Multiple Signatures, Structured Data]

> _Problem:_ Casey needs to produce multi-signed software releases using structured files that are easily checkable by automated means.

The possibility of malicious actors injecting code into software is a [prime attack vector](https://github.com/WebOfTrustInfo/rwot11-the-hague/blob/master/final-documents/taking-out-the-crud-five-fabulous-did-attacks.md#1-create-the-did-creation-switcharoo), especially on the modern internet with its open-source repositories. Thus, checksumming and signing sotware releases has become increasingly important. Unfortunately, it remains very ad hoc, with styles of release varying widely and information often split among many files.

Casey decides on a methodology where he'll store all of the information in a single Gordian Envelope with regularized data. He fills in an Envelope with a list of all the files, a list of all the signers, data on each, and some additional notes:

```
"Gordian Envelope 1.0.0" [
    "fileInfo": "gordian-envelope-1.0.0.dm" [
        "sha256": "6b41b0d9d9bff2c23ad9bd66b054fda36e3494ec"
        "timestamp": "1668062209"
    ]
    "isSigner": "bill-not-the-science-guy" [
        "pubkey": "ur:crypto-pubkeys/lftaaosehdcxnnvapylszmcwmowzjlkifrktpftnamrdpdjkcfetfskoimeolfcywnloptaswsvltpvahd…"
    ]
    "isSigner": "omarc-bc-guy" [
        "pubkey": "ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…"
    ]
    note: "initial release"
]
```

```mermaid
graph LR
    1(("ac65545b<br/>NODE"))
    2["de7e544e<br/>#quot;Gordian Envelope 1.0.0#quot;"]
    3(["41db7106<br/>ASSERTION"])
    4["628ac8d9<br/>#quot;fileInfo#quot;"]
    5(("10561183<br/>NODE"))
    6["03c3e8cf<br/>#quot;gordian-envelope-1.0.0.dm#quot;"]
    7(["26cdea4a<br/>ASSERTION"])
    8["fd9d5aed<br/>#quot;timestamp#quot;"]
    9["928e86de<br/>#quot;1668062209#quot;"]
    10(["b25bf99e<br/>ASSERTION"])
    11["108dbfb1<br/>#quot;sha256#quot;"]
    12["b895faae<br/>#quot;6b41b0d9d9bff2c23ad9bd66b054fda36e3494ec#quot;"]
    13(["484da754<br/>ASSERTION"])
    14["67d69bd7<br/>#quot;isSigner#quot;"]
    15(("0ae65c77<br/>NODE"))
    16["61aece1e<br/>#quot;bill-not-the-science-guy#quot;"]
    17(["0ad198e4<br/>ASSERTION"])
    18["d52596f8<br/>#quot;pubkey#quot;"]
    19["e82d6b98<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxnnvapylszmcwmowzjlkifrktpftnamrdpdjkcfetfskoimeolfcywnloptaswsvltpvahd…#quot;"]
    20(["72d6fac6<br/>ASSERTION"])
    21[/"61fb6a6b<br/>note"/]
    22["fa62ba29<br/>#quot;initial release#quot;"]
    23(["90e799be<br/>ASSERTION"])
    24["67d69bd7<br/>#quot;isSigner#quot;"]
    25(("c833b577<br/>NODE"))
    26["34e0c09c<br/>#quot;omarc-bc-guy#quot;"]
    27(["0b8d474f<br/>ASSERTION"])
    28["d52596f8<br/>#quot;pubkey#quot;"]
    29["929e99e7<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    5 -->|subj| 6
    5 --> 7
    7 -->|pred| 8
    7 -->|obj| 9
    5 --> 10
    10 -->|pred| 11
    10 -->|obj| 12
    1 --> 13
    13 -->|pred| 14
    13 -->|obj| 15
    15 -->|subj| 16
    15 --> 17
    17 -->|pred| 18
    17 -->|obj| 19
    1 --> 20
    20 -->|pred| 21
    20 -->|obj| 22
    1 --> 23
    23 -->|pred| 24
    23 -->|obj| 25
    25 -->|subj| 26
    25 --> 27
    27 -->|pred| 28
    27 -->|obj| 29
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:red,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:red,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    style 20 stroke:red,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:#55f,stroke-width:3.0px
    style 23 stroke:red,stroke-width:3.0px
    style 24 stroke:#55f,stroke-width:3.0px
    style 25 stroke:red,stroke-width:3.0px
    style 26 stroke:#55f,stroke-width:3.0px
    style 27 stroke:red,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    style 29 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke:red,stroke-width:2.0px
    linkStyle 5 stroke-width:2.0px
    linkStyle 6 stroke:green,stroke-width:2.0px
    linkStyle 7 stroke:#55f,stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke:green,stroke-width:2.0px
    linkStyle 10 stroke:#55f,stroke-width:2.0px
    linkStyle 11 stroke-width:2.0px
    linkStyle 12 stroke:green,stroke-width:2.0px
    linkStyle 13 stroke:#55f,stroke-width:2.0px
    linkStyle 14 stroke:red,stroke-width:2.0px
    linkStyle 15 stroke-width:2.0px
    linkStyle 16 stroke:green,stroke-width:2.0px
    linkStyle 17 stroke:#55f,stroke-width:2.0px
    linkStyle 18 stroke-width:2.0px
    linkStyle 19 stroke:green,stroke-width:2.0px
    linkStyle 20 stroke:#55f,stroke-width:2.0px
    linkStyle 21 stroke-width:2.0px
    linkStyle 22 stroke:green,stroke-width:2.0px
    linkStyle 23 stroke:#55f,stroke-width:2.0px
    linkStyle 24 stroke:red,stroke-width:2.0px
    linkStyle 25 stroke-width:2.0px
    linkStyle 26 stroke:green,stroke-width:2.0px
    linkStyle 27 stroke:#55f,stroke-width:2.0px

```
Since this is the initial release of the Envelope, no one knows whether the signers can be trusted or not. Casey bootstraps the envelope by adding `signerInfo` hints, which tell validators where they can go to get more information about the included public keys. As usual, validators will then have to thoughtfully address the trustworthiness of that information.

```
"Gordian Envelope 1.0.0" [
    "fileInfo": "gordian-envelope-1.0.0.dm" [
        "sha256": "6b41b0d9d9bff2c23ad9bd66b054fda36e3494ec"
        "timestamp": "1668062209"
    ]
    "isSigner": "bill-not-the-science-guy" [
        "pubkey": "ur:crypto-pubkeys/lftaaosehdcxnnvapylszmcwmowzjlkifrktpftnamrdpdjkcfetfskoimeolfcywnloptaswsvltpvahd…"
    ]
    "isSigner": "omarc-bc-guy" [
        "pubkey": "ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…"
    ]
    "signerInfo": "bill-not-the-science-guy" [
        "pubkeyURL": "https://github.com/bill-not-the-science-guy.keys"
    ]
    "signerInfo": "omarc-bc-guy" [
        "pubkeyURL": "https://github.com/omarc-bc-guy.keys"
    ]
    note: "initial release"
]
```

```mermaid
graph LR
    1(("d19ef9e7<br/>NODE"))
    2["de7e544e<br/>#quot;Gordian Envelope 1.0.0#quot;"]
    3(["41db7106<br/>ASSERTION"])
    4["628ac8d9<br/>#quot;fileInfo#quot;"]
    5(("10561183<br/>NODE"))
    6["03c3e8cf<br/>#quot;gordian-envelope-1.0.0.dm#quot;"]
    7(["26cdea4a<br/>ASSERTION"])
    8["fd9d5aed<br/>#quot;timestamp#quot;"]
    9["928e86de<br/>#quot;1668062209#quot;"]
    10(["b25bf99e<br/>ASSERTION"])
    11["108dbfb1<br/>#quot;sha256#quot;"]
    12["b895faae<br/>#quot;6b41b0d9d9bff2c23ad9bd66b054fda36e3494ec#quot;"]
    13(["484da754<br/>ASSERTION"])
    14["67d69bd7<br/>#quot;isSigner#quot;"]
    15(("0ae65c77<br/>NODE"))
    16["61aece1e<br/>#quot;bill-not-the-science-guy#quot;"]
    17(["0ad198e4<br/>ASSERTION"])
    18["d52596f8<br/>#quot;pubkey#quot;"]
    19["e82d6b98<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxnnvapylszmcwmowzjlkifrktpftnamrdpdjkcfetfskoimeolfcywnloptaswsvltpvahd…#quot;"]
    20(["4ef0d8f2<br/>ASSERTION"])
    21["dbc1553d<br/>#quot;signerInfo#quot;"]
    22(("d77c0291<br/>NODE"))
    23["34e0c09c<br/>#quot;omarc-bc-guy#quot;"]
    24(["9bc4beec<br/>ASSERTION"])
    25["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    26["78d7942e<br/>#quot;https://github.com/omarc-bc-guy.keys#quot;"]
    27(["72d6fac6<br/>ASSERTION"])
    28[/"61fb6a6b<br/>note"/]
    29["fa62ba29<br/>#quot;initial release#quot;"]
    30(["90e799be<br/>ASSERTION"])
    31["67d69bd7<br/>#quot;isSigner#quot;"]
    32(("c833b577<br/>NODE"))
    33["34e0c09c<br/>#quot;omarc-bc-guy#quot;"]
    34(["0b8d474f<br/>ASSERTION"])
    35["d52596f8<br/>#quot;pubkey#quot;"]
    36["929e99e7<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…#quot;"]
    37(["b5c9129a<br/>ASSERTION"])
    38["dbc1553d<br/>#quot;signerInfo#quot;"]
    39(("67a2f813<br/>NODE"))
    40["61aece1e<br/>#quot;bill-not-the-science-guy#quot;"]
    41(["8f4c7eec<br/>ASSERTION"])
    42["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    43["0b240880<br/>#quot;https://github.com/bill-not-the-science-guy.keys#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    5 -->|subj| 6
    5 --> 7
    7 -->|pred| 8
    7 -->|obj| 9
    5 --> 10
    10 -->|pred| 11
    10 -->|obj| 12
    1 --> 13
    13 -->|pred| 14
    13 -->|obj| 15
    15 -->|subj| 16
    15 --> 17
    17 -->|pred| 18
    17 -->|obj| 19
    1 --> 20
    20 -->|pred| 21
    20 -->|obj| 22
    22 -->|subj| 23
    22 --> 24
    24 -->|pred| 25
    24 -->|obj| 26
    1 --> 27
    27 -->|pred| 28
    27 -->|obj| 29
    1 --> 30
    30 -->|pred| 31
    30 -->|obj| 32
    32 -->|subj| 33
    32 --> 34
    34 -->|pred| 35
    34 -->|obj| 36
    1 --> 37
    37 -->|pred| 38
    37 -->|obj| 39
    39 -->|subj| 40
    39 --> 41
    41 -->|pred| 42
    41 -->|obj| 43
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:red,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:red,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    style 20 stroke:red,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:red,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px
    style 24 stroke:red,stroke-width:3.0px
    style 25 stroke:#55f,stroke-width:3.0px
    style 26 stroke:#55f,stroke-width:3.0px
    style 27 stroke:red,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    style 29 stroke:#55f,stroke-width:3.0px
    style 30 stroke:red,stroke-width:3.0px
    style 31 stroke:#55f,stroke-width:3.0px
    style 32 stroke:red,stroke-width:3.0px
    style 33 stroke:#55f,stroke-width:3.0px
    style 34 stroke:red,stroke-width:3.0px
    style 35 stroke:#55f,stroke-width:3.0px
    style 36 stroke:#55f,stroke-width:3.0px
    style 37 stroke:red,stroke-width:3.0px
    style 38 stroke:#55f,stroke-width:3.0px
    style 39 stroke:red,stroke-width:3.0px
    style 40 stroke:#55f,stroke-width:3.0px
    style 41 stroke:red,stroke-width:3.0px
    style 42 stroke:#55f,stroke-width:3.0px
    style 43 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke:red,stroke-width:2.0px
    linkStyle 5 stroke-width:2.0px
    linkStyle 6 stroke:green,stroke-width:2.0px
    linkStyle 7 stroke:#55f,stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke:green,stroke-width:2.0px
    linkStyle 10 stroke:#55f,stroke-width:2.0px
    linkStyle 11 stroke-width:2.0px
    linkStyle 12 stroke:green,stroke-width:2.0px
    linkStyle 13 stroke:#55f,stroke-width:2.0px
    linkStyle 14 stroke:red,stroke-width:2.0px
    linkStyle 15 stroke-width:2.0px
    linkStyle 16 stroke:green,stroke-width:2.0px
    linkStyle 17 stroke:#55f,stroke-width:2.0px
    linkStyle 18 stroke-width:2.0px
    linkStyle 19 stroke:green,stroke-width:2.0px
    linkStyle 20 stroke:#55f,stroke-width:2.0px
    linkStyle 21 stroke:red,stroke-width:2.0px
    linkStyle 22 stroke-width:2.0px
    linkStyle 23 stroke:green,stroke-width:2.0px
    linkStyle 24 stroke:#55f,stroke-width:2.0px
    linkStyle 25 stroke-width:2.0px
    linkStyle 26 stroke:green,stroke-width:2.0px
    linkStyle 27 stroke:#55f,stroke-width:2.0px
    linkStyle 28 stroke-width:2.0px
    linkStyle 29 stroke:green,stroke-width:2.0px
    linkStyle 30 stroke:#55f,stroke-width:2.0px
    linkStyle 31 stroke:red,stroke-width:2.0px
    linkStyle 32 stroke-width:2.0px
    linkStyle 33 stroke:green,stroke-width:2.0px
    linkStyle 34 stroke:#55f,stroke-width:2.0px
    linkStyle 35 stroke-width:2.0px
    linkStyle 36 stroke:green,stroke-width:2.0px
    linkStyle 37 stroke:#55f,stroke-width:2.0px
    linkStyle 38 stroke:red,stroke-width:2.0px
    linkStyle 39 stroke-width:2.0px
    linkStyle 40 stroke:green,stroke-width:2.0px
    linkStyle 41 stroke:#55f,stroke-width:2.0px
```
Of course, one more thing is necessary to make the `fileInfo` trustworthy: the envelope must be signed. Casey's lead developers, Bill and Omar, each provide a signature, creating a group verification that can be checked against either signature (or both).

In order for those signatures to apply to the entire envelope, the envelope must first be wrapped; because signatures are assertions, they'd otherwise just apply to the subject, "Gordian Envelope 1.0.0", which wouldn't be that useful! After wrapping the envelope, both Bill and Omar can sign.
```
{
    "Gordian Envelope 1.0.0" [
        "fileInfo": "gordian-envelope-1.0.0.dm" [
            "sha256": "6b41b0d9d9bff2c23ad9bd66b054fda36e3494ec"
            "timestamp": "1668062209"
        ]
        "isSigner": "bill-not-the-science-guy" [
            "pubkey": "ur:crypto-pubkeys/lftaaosehdcxnnvapylszmcwmowzjlkifrktpftnamrdpdjkcfetfskoimeolfcywnloptaswsvltpvahd…"
        ]
        "isSigner": "omarc-bc-guy" [
            "pubkey": "ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…"
        ]
        "signerInfo": "bill-not-the-science-guy" [
            "pubkeyURL": "https://github.com/bill-not-the-science-guy.keys"
        ]
        "signerInfo": "omarc-bc-guy" [
            "pubkeyURL": "https://github.com/omarc-bc-guy.keys"
        ]
        note: "initial release"
    ]
} [
    verifiedBy: Signature
    verifiedBy: Signature
]
```

```mermaid
graph LR
    1(("6dd37ee9<br/>NODE"))
    2[/"1502aebf<br/>WRAPPED"\]
    3(("d19ef9e7<br/>NODE"))
    4["de7e544e<br/>#quot;Gordian Envelope 1.0.0#quot;"]
    5(["41db7106<br/>ASSERTION"])
    6["628ac8d9<br/>#quot;fileInfo#quot;"]
    7(("10561183<br/>NODE"))
    8["03c3e8cf<br/>#quot;gordian-envelope-1.0.0.dm#quot;"]
    9(["26cdea4a<br/>ASSERTION"])
    10["fd9d5aed<br/>#quot;timestamp#quot;"]
    11["928e86de<br/>#quot;1668062209#quot;"]
    12(["b25bf99e<br/>ASSERTION"])
    13["108dbfb1<br/>#quot;sha256#quot;"]
    14["b895faae<br/>#quot;6b41b0d9d9bff2c23ad9bd66b054fda36e3494ec#quot;"]
    15(["484da754<br/>ASSERTION"])
    16["67d69bd7<br/>#quot;isSigner#quot;"]
    17(("0ae65c77<br/>NODE"))
    18["61aece1e<br/>#quot;bill-not-the-science-guy#quot;"]
    19(["0ad198e4<br/>ASSERTION"])
    20["d52596f8<br/>#quot;pubkey#quot;"]
    21["e82d6b98<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxnnvapylszmcwmowzjlkifrktpftnamrdpdjkcfetfskoimeolfcywnloptaswsvltpvahd…#quot;"]
    22(["4ef0d8f2<br/>ASSERTION"])
    23["dbc1553d<br/>#quot;signerInfo#quot;"]
    24(("d77c0291<br/>NODE"))
    25["34e0c09c<br/>#quot;omarc-bc-guy#quot;"]
    26(["9bc4beec<br/>ASSERTION"])
    27["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    28["78d7942e<br/>#quot;https://github.com/omarc-bc-guy.keys#quot;"]
    29(["72d6fac6<br/>ASSERTION"])
    30[/"61fb6a6b<br/>note"/]
    31["fa62ba29<br/>#quot;initial release#quot;"]
    32(["90e799be<br/>ASSERTION"])
    33["67d69bd7<br/>#quot;isSigner#quot;"]
    34(("c833b577<br/>NODE"))
    35["34e0c09c<br/>#quot;omarc-bc-guy#quot;"]
    36(["0b8d474f<br/>ASSERTION"])
    37["d52596f8<br/>#quot;pubkey#quot;"]
    38["929e99e7<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…#quot;"]
    39(["b5c9129a<br/>ASSERTION"])
    40["dbc1553d<br/>#quot;signerInfo#quot;"]
    41(("67a2f813<br/>NODE"))
    42["61aece1e<br/>#quot;bill-not-the-science-guy#quot;"]
    43(["8f4c7eec<br/>ASSERTION"])
    44["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    45["0b240880<br/>#quot;https://github.com/bill-not-the-science-guy.keys#quot;"]
    46(["10799807<br/>ASSERTION"])
    47[/"d59f8c0f<br/>verifiedBy"/]
    48["a61ca537<br/>Signature"]
    49(["d491128c<br/>ASSERTION"])
    50[/"d59f8c0f<br/>verifiedBy"/]
    51["7720bb5b<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    5 -->|pred| 6
    5 -->|obj| 7
    7 -->|subj| 8
    7 --> 9
    9 -->|pred| 10
    9 -->|obj| 11
    7 --> 12
    12 -->|pred| 13
    12 -->|obj| 14
    3 --> 15
    15 -->|pred| 16
    15 -->|obj| 17
    17 -->|subj| 18
    17 --> 19
    19 -->|pred| 20
    19 -->|obj| 21
    3 --> 22
    22 -->|pred| 23
    22 -->|obj| 24
    24 -->|subj| 25
    24 --> 26
    26 -->|pred| 27
    26 -->|obj| 28
    3 --> 29
    29 -->|pred| 30
    29 -->|obj| 31
    3 --> 32
    32 -->|pred| 33
    32 -->|obj| 34
    34 -->|subj| 35
    34 --> 36
    36 -->|pred| 37
    36 -->|obj| 38
    3 --> 39
    39 -->|pred| 40
    39 -->|obj| 41
    41 -->|subj| 42
    41 --> 43
    43 -->|pred| 44
    43 -->|obj| 45
    1 --> 46
    46 -->|pred| 47
    46 -->|obj| 48
    1 --> 49
    49 -->|pred| 50
    49 -->|obj| 51
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:red,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:red,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
    style 19 stroke:red,stroke-width:3.0px
    style 20 stroke:#55f,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:red,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px
    style 24 stroke:red,stroke-width:3.0px
    style 25 stroke:#55f,stroke-width:3.0px
    style 26 stroke:red,stroke-width:3.0px
    style 27 stroke:#55f,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    style 29 stroke:red,stroke-width:3.0px
    style 30 stroke:#55f,stroke-width:3.0px
    style 31 stroke:#55f,stroke-width:3.0px
    style 32 stroke:red,stroke-width:3.0px
    style 33 stroke:#55f,stroke-width:3.0px
    style 34 stroke:red,stroke-width:3.0px
    style 35 stroke:#55f,stroke-width:3.0px
    style 36 stroke:red,stroke-width:3.0px
    style 37 stroke:#55f,stroke-width:3.0px
    style 38 stroke:#55f,stroke-width:3.0px
    style 39 stroke:red,stroke-width:3.0px
    style 40 stroke:#55f,stroke-width:3.0px
    style 41 stroke:red,stroke-width:3.0px
    style 42 stroke:#55f,stroke-width:3.0px
    style 43 stroke:red,stroke-width:3.0px
    style 44 stroke:#55f,stroke-width:3.0px
    style 45 stroke:#55f,stroke-width:3.0px
    style 46 stroke:red,stroke-width:3.0px
    style 47 stroke:#55f,stroke-width:3.0px
    style 48 stroke:#55f,stroke-width:3.0px
    style 49 stroke:red,stroke-width:3.0px
    style 50 stroke:#55f,stroke-width:3.0px
    style 51 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
    linkStyle 5 stroke:#55f,stroke-width:2.0px
    linkStyle 6 stroke:red,stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke:green,stroke-width:2.0px
    linkStyle 9 stroke:#55f,stroke-width:2.0px
    linkStyle 10 stroke-width:2.0px
    linkStyle 11 stroke:green,stroke-width:2.0px
    linkStyle 12 stroke:#55f,stroke-width:2.0px
    linkStyle 13 stroke-width:2.0px
    linkStyle 14 stroke:green,stroke-width:2.0px
    linkStyle 15 stroke:#55f,stroke-width:2.0px
    linkStyle 16 stroke:red,stroke-width:2.0px
    linkStyle 17 stroke-width:2.0px
    linkStyle 18 stroke:green,stroke-width:2.0px
    linkStyle 19 stroke:#55f,stroke-width:2.0px
    linkStyle 20 stroke-width:2.0px
    linkStyle 21 stroke:green,stroke-width:2.0px
    linkStyle 22 stroke:#55f,stroke-width:2.0px
    linkStyle 23 stroke:red,stroke-width:2.0px
    linkStyle 24 stroke-width:2.0px
    linkStyle 25 stroke:green,stroke-width:2.0px
    linkStyle 26 stroke:#55f,stroke-width:2.0px
    linkStyle 27 stroke-width:2.0px
    linkStyle 28 stroke:green,stroke-width:2.0px
    linkStyle 29 stroke:#55f,stroke-width:2.0px
    linkStyle 30 stroke-width:2.0px
    linkStyle 31 stroke:green,stroke-width:2.0px
    linkStyle 32 stroke:#55f,stroke-width:2.0px
    linkStyle 33 stroke:red,stroke-width:2.0px
    linkStyle 34 stroke-width:2.0px
    linkStyle 35 stroke:green,stroke-width:2.0px
    linkStyle 36 stroke:#55f,stroke-width:2.0px
    linkStyle 37 stroke-width:2.0px
    linkStyle 38 stroke:green,stroke-width:2.0px
    linkStyle 39 stroke:#55f,stroke-width:2.0px
    linkStyle 40 stroke:red,stroke-width:2.0px
    linkStyle 41 stroke-width:2.0px
    linkStyle 42 stroke:green,stroke-width:2.0px
    linkStyle 43 stroke:#55f,stroke-width:2.0px
    linkStyle 44 stroke-width:2.0px
    linkStyle 45 stroke:green,stroke-width:2.0px
    linkStyle 46 stroke:#55f,stroke-width:2.0px
    linkStyle 47 stroke-width:2.0px
    linkStyle 48 stroke:green,stroke-width:2.0px
    linkStyle 49 stroke:#55f,stroke-width:2.0px

```
### 2. Casey Chains His Software Releases [Chained Data]

> _Problem Solved:_ Casey wants to be able to continuously rerelease his software, while reducing validation cost over time.

Because Casey has now established a root of trust with his initial release he can make a new release without having to reestablish his signers. 

```
"Gordian Envelope 1.0.1" [
    "fileInfo": "gordian-envelope-1.0.1.dm" [
        "sha256": "2c11c2c9c38b18ac12ab0880447f72b4739385c3a03ad65b765d426ecea1ad48"
        "timestamp": "1668026209"
    ]
    "isSigner": "bill-not-the-science-guy" [
        "pubkey": "ur:crypto-pubkeys/lftaaosehdcxnnvapylszmcwmowzjlkifrktpftnamrdpdjkcfetfskoimeolfcywnloptaswsvltpvahd…"
    ]
    "isSigner": "omarc-bc-guy" [
        "pubkey": "ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…"
    ]
    "previousRelease": "https://github.com/BlockchainCommons/GordianEnvelope-Experiment/releases/download/v1.0.0/gordian-env…"
    note: "improved documentation"
]
```
```mermaid
graph LR
    1(("42712f3e<br/>NODE"))
    2["70788a53<br/>#quot;Gordian Envelope 1.0.1#quot;"]
    3(["484da754<br/>ASSERTION"])
    4["67d69bd7<br/>#quot;isSigner#quot;"]
    5(("0ae65c77<br/>NODE"))
    6["61aece1e<br/>#quot;bill-not-the-science-guy#quot;"]
    7(["0ad198e4<br/>ASSERTION"])
    8["d52596f8<br/>#quot;pubkey#quot;"]
    9["e82d6b98<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxnnvapylszmcwmowzjlkifrktpftnamrdpdjkcfetfskoimeolfcywnloptaswsvltpvahd…#quot;"]
    10(["8c13a688<br/>ASSERTION"])
    11[/"61fb6a6b<br/>note"/]
    12["3671dd52<br/>#quot;improved documentation#quot;"]
    13(["90e799be<br/>ASSERTION"])
    14["67d69bd7<br/>#quot;isSigner#quot;"]
    15(("c833b577<br/>NODE"))
    16["34e0c09c<br/>#quot;omarc-bc-guy#quot;"]
    17(["0b8d474f<br/>ASSERTION"])
    18["d52596f8<br/>#quot;pubkey#quot;"]
    19["929e99e7<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…#quot;"]
    20(["d31238a4<br/>ASSERTION"])
    21["10d67046<br/>#quot;previousRelease#quot;"]
    22["348c0715<br/>#quot;https://github.com/BlockchainCommons/GordianEnvelope-Experiment/releases/download/v1.0.0/gordian-env…#quot;"]
    23(["ebe4d16f<br/>ASSERTION"])
    24["628ac8d9<br/>#quot;fileInfo#quot;"]
    25(("96628076<br/>NODE"))
    26["ed14cf80<br/>#quot;gordian-envelope-1.0.1.dm#quot;"]
    27(["a9f4eb26<br/>ASSERTION"])
    28["108dbfb1<br/>#quot;sha256#quot;"]
    29["cd5979c9<br/>#quot;2c11c2c9c38b18ac12ab0880447f72b4739385c3a03ad65b765d426ecea1ad48#quot;"]
    30(["f3a0597e<br/>ASSERTION"])
    31["fd9d5aed<br/>#quot;timestamp#quot;"]
    32["61b2ca73<br/>#quot;1668026209#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    5 -->|subj| 6
    5 --> 7
    7 -->|pred| 8
    7 -->|obj| 9
    1 --> 10
    10 -->|pred| 11
    10 -->|obj| 12
    1 --> 13
    13 -->|pred| 14
    13 -->|obj| 15
    15 -->|subj| 16
    15 --> 17
    17 -->|pred| 18
    17 -->|obj| 19
    1 --> 20
    20 -->|pred| 21
    20 -->|obj| 22
    1 --> 23
    23 -->|pred| 24
    23 -->|obj| 25
    25 -->|subj| 26
    25 --> 27
    27 -->|pred| 28
    27 -->|obj| 29
    25 --> 30
    30 -->|pred| 31
    30 -->|obj| 32
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:red,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:red,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    style 20 stroke:red,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:#55f,stroke-width:3.0px
    style 23 stroke:red,stroke-width:3.0px
    style 24 stroke:#55f,stroke-width:3.0px
    style 25 stroke:red,stroke-width:3.0px
    style 26 stroke:#55f,stroke-width:3.0px
    style 27 stroke:red,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    style 29 stroke:#55f,stroke-width:3.0px
    style 30 stroke:red,stroke-width:3.0px
    style 31 stroke:#55f,stroke-width:3.0px
    style 32 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke:red,stroke-width:2.0px
    linkStyle 5 stroke-width:2.0px
    linkStyle 6 stroke:green,stroke-width:2.0px
    linkStyle 7 stroke:#55f,stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke:green,stroke-width:2.0px
    linkStyle 10 stroke:#55f,stroke-width:2.0px
    linkStyle 11 stroke-width:2.0px
    linkStyle 12 stroke:green,stroke-width:2.0px
    linkStyle 13 stroke:#55f,stroke-width:2.0px
    linkStyle 14 stroke:red,stroke-width:2.0px
    linkStyle 15 stroke-width:2.0px
    linkStyle 16 stroke:green,stroke-width:2.0px
    linkStyle 17 stroke:#55f,stroke-width:2.0px
    linkStyle 18 stroke-width:2.0px
    linkStyle 19 stroke:green,stroke-width:2.0px
    linkStyle 20 stroke:#55f,stroke-width:2.0px
    linkStyle 21 stroke-width:2.0px
    linkStyle 22 stroke:green,stroke-width:2.0px
    linkStyle 23 stroke:#55f,stroke-width:2.0px
    linkStyle 24 stroke:red,stroke-width:2.0px
    linkStyle 25 stroke-width:2.0px
    linkStyle 26 stroke:green,stroke-width:2.0px
    linkStyle 27 stroke:#55f,stroke-width:2.0px
    linkStyle 28 stroke-width:2.0px
    linkStyle 29 stroke:green,stroke-width:2.0px
    linkStyle 30 stroke:#55f,stroke-width:2.0px

```
After wrapping and signing, the final envelope is:
```    
{
    "Gordian Envelope 1.0.1" [
        "fileInfo": "gordian-envelope-1.0.1.dm" [
            "sha256": "2c11c2c9c38b18ac12ab0880447f72b4739385c3a03ad65b765d426ecea1ad48"
            "timestamp": "1668026209"
        ]
        "isSigner": "bill-not-the-science-guy" [
            "pubkey": "ur:crypto-pubkeys/lftaaosehdcxnnvapylszmcwmowzjlkifrktpftnamrdpdjkcfetfskoimeolfcywnloptaswsvltpvahd…"
        ]
        "isSigner": "omarc-bc-guy" [
            "pubkey": "ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…"
        ]
        "previousRelease": "https://github.com/BlockchainCommons/GordianEnvelope-Experiment/releases/download/v1.0.0/gordian-env…"
        note: "improved documentation"
    ]
} [
    verifiedBy: Signature
    verifiedBy: Signature
]
```

```mermaid
graph LR
    1(("f6336886<br/>NODE"))
    2[/"b4c23e49<br/>WRAPPED"\]
    3(("42712f3e<br/>NODE"))
    4["70788a53<br/>#quot;Gordian Envelope 1.0.1#quot;"]
    5(["484da754<br/>ASSERTION"])
    6["67d69bd7<br/>#quot;isSigner#quot;"]
    7(("0ae65c77<br/>NODE"))
    8["61aece1e<br/>#quot;bill-not-the-science-guy#quot;"]
    9(["0ad198e4<br/>ASSERTION"])
    10["d52596f8<br/>#quot;pubkey#quot;"]
    11["e82d6b98<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxnnvapylszmcwmowzjlkifrktpftnamrdpdjkcfetfskoimeolfcywnloptaswsvltpvahd…#quot;"]
    12(["8c13a688<br/>ASSERTION"])
    13[/"61fb6a6b<br/>note"/]
    14["3671dd52<br/>#quot;improved documentation#quot;"]
    15(["90e799be<br/>ASSERTION"])
    16["67d69bd7<br/>#quot;isSigner#quot;"]
    17(("c833b577<br/>NODE"))
    18["34e0c09c<br/>#quot;omarc-bc-guy#quot;"]
    19(["0b8d474f<br/>ASSERTION"])
    20["d52596f8<br/>#quot;pubkey#quot;"]
    21["929e99e7<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…#quot;"]
    22(["d31238a4<br/>ASSERTION"])
    23["10d67046<br/>#quot;previousRelease#quot;"]
    24["348c0715<br/>#quot;https://github.com/BlockchainCommons/GordianEnvelope-Experiment/releases/download/v1.0.0/gordian-env…#quot;"]
    25(["ebe4d16f<br/>ASSERTION"])
    26["628ac8d9<br/>#quot;fileInfo#quot;"]
    27(("96628076<br/>NODE"))
    28["ed14cf80<br/>#quot;gordian-envelope-1.0.1.dm#quot;"]
    29(["a9f4eb26<br/>ASSERTION"])
    30["108dbfb1<br/>#quot;sha256#quot;"]
    31["cd5979c9<br/>#quot;2c11c2c9c38b18ac12ab0880447f72b4739385c3a03ad65b765d426ecea1ad48#quot;"]
    32(["f3a0597e<br/>ASSERTION"])
    33["fd9d5aed<br/>#quot;timestamp#quot;"]
    34["61b2ca73<br/>#quot;1668026209#quot;"]
    35(["4eb7fae2<br/>ASSERTION"])
    36[/"d59f8c0f<br/>verifiedBy"/]
    37["1bb8f0ca<br/>Signature"]
    38(["afd1e527<br/>ASSERTION"])
    39[/"d59f8c0f<br/>verifiedBy"/]
    40["e25fb646<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    5 -->|pred| 6
    5 -->|obj| 7
    7 -->|subj| 8
    7 --> 9
    9 -->|pred| 10
    9 -->|obj| 11
    3 --> 12
    12 -->|pred| 13
    12 -->|obj| 14
    3 --> 15
    15 -->|pred| 16
    15 -->|obj| 17
    17 -->|subj| 18
    17 --> 19
    19 -->|pred| 20
    19 -->|obj| 21
    3 --> 22
    22 -->|pred| 23
    22 -->|obj| 24
    3 --> 25
    25 -->|pred| 26
    25 -->|obj| 27
    27 -->|subj| 28
    27 --> 29
    29 -->|pred| 30
    29 -->|obj| 31
    27 --> 32
    32 -->|pred| 33
    32 -->|obj| 34
    1 --> 35
    35 -->|pred| 36
    35 -->|obj| 37
    1 --> 38
    38 -->|pred| 39
    38 -->|obj| 40
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:red,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:red,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
    style 19 stroke:red,stroke-width:3.0px
    style 20 stroke:#55f,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:red,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px
    style 24 stroke:#55f,stroke-width:3.0px
    style 25 stroke:red,stroke-width:3.0px
    style 26 stroke:#55f,stroke-width:3.0px
    style 27 stroke:red,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    style 29 stroke:red,stroke-width:3.0px
    style 30 stroke:#55f,stroke-width:3.0px
    style 31 stroke:#55f,stroke-width:3.0px
    style 32 stroke:red,stroke-width:3.0px
    style 33 stroke:#55f,stroke-width:3.0px
    style 34 stroke:#55f,stroke-width:3.0px
    style 35 stroke:red,stroke-width:3.0px
    style 36 stroke:#55f,stroke-width:3.0px
    style 37 stroke:#55f,stroke-width:3.0px
    style 38 stroke:red,stroke-width:3.0px
    style 39 stroke:#55f,stroke-width:3.0px
    style 40 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
    linkStyle 5 stroke:#55f,stroke-width:2.0px
    linkStyle 6 stroke:red,stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke:green,stroke-width:2.0px
    linkStyle 9 stroke:#55f,stroke-width:2.0px
    linkStyle 10 stroke-width:2.0px
    linkStyle 11 stroke:green,stroke-width:2.0px
    linkStyle 12 stroke:#55f,stroke-width:2.0px
    linkStyle 13 stroke-width:2.0px
    linkStyle 14 stroke:green,stroke-width:2.0px
    linkStyle 15 stroke:#55f,stroke-width:2.0px
    linkStyle 16 stroke:red,stroke-width:2.0px
    linkStyle 17 stroke-width:2.0px
    linkStyle 18 stroke:green,stroke-width:2.0px
    linkStyle 19 stroke:#55f,stroke-width:2.0px
    linkStyle 20 stroke-width:2.0px
    linkStyle 21 stroke:green,stroke-width:2.0px
    linkStyle 22 stroke:#55f,stroke-width:2.0px
    linkStyle 23 stroke-width:2.0px
    linkStyle 24 stroke:green,stroke-width:2.0px
    linkStyle 25 stroke:#55f,stroke-width:2.0px
    linkStyle 26 stroke:red,stroke-width:2.0px
    linkStyle 27 stroke-width:2.0px
    linkStyle 28 stroke:green,stroke-width:2.0px
    linkStyle 29 stroke:#55f,stroke-width:2.0px
    linkStyle 30 stroke-width:2.0px
    linkStyle 31 stroke:green,stroke-width:2.0px
    linkStyle 32 stroke:#55f,stroke-width:2.0px
    linkStyle 33 stroke-width:2.0px
    linkStyle 34 stroke:green,stroke-width:2.0px
    linkStyle 35 stroke:#55f,stroke-width:2.0px
    linkStyle 36 stroke-width:2.0px
    linkStyle 37 stroke:green,stroke-width:2.0px
    linkStyle 38 stroke:#55f,stroke-width:2.0px
```

If the validator kept the envelope that he previously validated, now all that he has to do is see that the users and public keys in this new envelope match the old one, and then validate the signature. It should be entirely automatable.

More complexity is required only if the previous envelope were not kept. In this case, the validator uses the `previousRelease` metadata to backtrack until he finds the foundational `signerInfo`, which he can validate with more effort (as he did originally).

### 3. Casey Changes Up His Software Releases [Chained Changes]

> _Problem Solved:_ Casey wants to change signers over time in a way that's organic and continues to allow for simple validation.

A few years on, Bill leaves software programming for a lucrative career in television and lectures. Though Omar is maintaining the software on his own at this point, Casey wants to ensure that the software still is signed by multiple parties to allow for more robust validation. So he takes over as release manager, checking the software prior to release and adding his own signature.
 
```
{
    "Gordian Envelope 1.7.3" [
        "fileInfo": "gordian-envelope-1.7.3.dm" [
            "sha256": "c2121d1c7b82607fb289282020c6c7f73cb0aaa8e02e5f0529165a4c46591413"
            "timestamp": "1668026209"
        ]
        "fileInfo": "gordian-ttools-1.7.3.dm" [
            "sha256": "7e6865b88d62b1d2bb7864fc7eb73fe74c99a773d2d224adebdd18d679c023f2"
            "timestamp": "1668032076"
        ]
        "isSigner": "casey-the-boss" [
            "pubkey": "ur:crypto-pubkeys/lftaaosehdcxwehehymwkbiolglpnbeevtvttlaafgpdspntrpserplblbgrstwmswjpkkmwdwbatpvahd…"
        ]
        "isSigner": "omarc-bc-guy" [
            "pubkey": "ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…"
        ]
        "previousRelease": "https://github.com/BlockchainCommons/GordianEnvelope-Experiment/releases/download/v1.7.2/gordian-env…"
        "signerInfo": "casey-the-boss" [
            "pubkeyURL": "https://pki.blockchaincommons.com/casey-the-boss"
        ]
        note: "the latest glorious revision"
    ]
} [
    verifiedBy: Signature
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("8442ccb3<br/>NODE"))
    2[/"660c90b7<br/>WRAPPED"\]
    3(("8cdff684<br/>NODE"))
    4["af3c537d<br/>#quot;Gordian Envelope 1.7.3#quot;"]
    5(["4c86919f<br/>ASSERTION"])
    6["10d67046<br/>#quot;previousRelease#quot;"]
    7["a4a99c3c<br/>#quot;https://github.com/BlockchainCommons/GordianEnvelope-Experiment/releases/download/v1.7.2/gordian-env…#quot;"]
    8(["6e7fcb1c<br/>ASSERTION"])
    9["67d69bd7<br/>#quot;isSigner#quot;"]
    10(("34f411d0<br/>NODE"))
    11["c7e775ab<br/>#quot;casey-the-boss#quot;"]
    12(["b2d580a4<br/>ASSERTION"])
    13["d52596f8<br/>#quot;pubkey#quot;"]
    14["769da384<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxwehehymwkbiolglpnbeevtvttlaafgpdspntrpserplblbgrstwmswjpkkmwdwbatpvahd…#quot;"]
    15(["71bbe4c2<br/>ASSERTION"])
    16["dbc1553d<br/>#quot;signerInfo#quot;"]
    17(("b28b7b74<br/>NODE"))
    18["c7e775ab<br/>#quot;casey-the-boss#quot;"]
    19(["a31bfd80<br/>ASSERTION"])
    20["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    21["361430aa<br/>#quot;https://pki.blockchaincommons.com/casey-the-boss#quot;"]
    22(["90e799be<br/>ASSERTION"])
    23["67d69bd7<br/>#quot;isSigner#quot;"]
    24(("c833b577<br/>NODE"))
    25["34e0c09c<br/>#quot;omarc-bc-guy#quot;"]
    26(["0b8d474f<br/>ASSERTION"])
    27["d52596f8<br/>#quot;pubkey#quot;"]
    28["929e99e7<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxzojlrltejneykkzcfdaowkcwlbguvtmhsegdwpttwdadrnjtpmchlbrswkbwkivwtpvahd…#quot;"]
    29(["922bf933<br/>ASSERTION"])
    30[/"61fb6a6b<br/>note"/]
    31["540dd49b<br/>#quot;the latest glorious revision#quot;"]
    32(["adc524d7<br/>ASSERTION"])
    33["628ac8d9<br/>#quot;fileInfo#quot;"]
    34(("daa0cdad<br/>NODE"))
    35["f0cece42<br/>#quot;gordian-ttools-1.7.3.dm#quot;"]
    36(["53087955<br/>ASSERTION"])
    37["fd9d5aed<br/>#quot;timestamp#quot;"]
    38["abd7ee4e<br/>#quot;1668032076#quot;"]
    39(["be287f81<br/>ASSERTION"])
    40["108dbfb1<br/>#quot;sha256#quot;"]
    41["39f15278<br/>#quot;7e6865b88d62b1d2bb7864fc7eb73fe74c99a773d2d224adebdd18d679c023f2#quot;"]
    42(["f6b0290b<br/>ASSERTION"])
    43["628ac8d9<br/>#quot;fileInfo#quot;"]
    44(("2dff440a<br/>NODE"))
    45["2d7eea6f<br/>#quot;gordian-envelope-1.7.3.dm#quot;"]
    46(["71094acb<br/>ASSERTION"])
    47["108dbfb1<br/>#quot;sha256#quot;"]
    48["12c5f463<br/>#quot;c2121d1c7b82607fb289282020c6c7f73cb0aaa8e02e5f0529165a4c46591413#quot;"]
    49(["f3a0597e<br/>ASSERTION"])
    50["fd9d5aed<br/>#quot;timestamp#quot;"]
    51["61b2ca73<br/>#quot;1668026209#quot;"]
    52(["55ba3222<br/>ASSERTION"])
    53[/"d59f8c0f<br/>verifiedBy"/]
    54["9fd67dec<br/>Signature"]
    55(["ac321ebe<br/>ASSERTION"])
    56[/"d59f8c0f<br/>verifiedBy"/]
    57["ce294f99<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    5 -->|pred| 6
    5 -->|obj| 7
    3 --> 8
    8 -->|pred| 9
    8 -->|obj| 10
    10 -->|subj| 11
    10 --> 12
    12 -->|pred| 13
    12 -->|obj| 14
    3 --> 15
    15 -->|pred| 16
    15 -->|obj| 17
    17 -->|subj| 18
    17 --> 19
    19 -->|pred| 20
    19 -->|obj| 21
    3 --> 22
    22 -->|pred| 23
    22 -->|obj| 24
    24 -->|subj| 25
    24 --> 26
    26 -->|pred| 27
    26 -->|obj| 28
    3 --> 29
    29 -->|pred| 30
    29 -->|obj| 31
    3 --> 32
    32 -->|pred| 33
    32 -->|obj| 34
    34 -->|subj| 35
    34 --> 36
    36 -->|pred| 37
    36 -->|obj| 38
    34 --> 39
    39 -->|pred| 40
    39 -->|obj| 41
    3 --> 42
    42 -->|pred| 43
    42 -->|obj| 44
    44 -->|subj| 45
    44 --> 46
    46 -->|pred| 47
    46 -->|obj| 48
    44 --> 49
    49 -->|pred| 50
    49 -->|obj| 51
    1 --> 52
    52 -->|pred| 53
    52 -->|obj| 54
    1 --> 55
    55 -->|pred| 56
    55 -->|obj| 57
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:red,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:red,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:red,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:red,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
    style 19 stroke:red,stroke-width:3.0px
    style 20 stroke:#55f,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:red,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px
    style 24 stroke:red,stroke-width:3.0px
    style 25 stroke:#55f,stroke-width:3.0px
    style 26 stroke:red,stroke-width:3.0px
    style 27 stroke:#55f,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    style 29 stroke:red,stroke-width:3.0px
    style 30 stroke:#55f,stroke-width:3.0px
    style 31 stroke:#55f,stroke-width:3.0px
    style 32 stroke:red,stroke-width:3.0px
    style 33 stroke:#55f,stroke-width:3.0px
    style 34 stroke:red,stroke-width:3.0px
    style 35 stroke:#55f,stroke-width:3.0px
    style 36 stroke:red,stroke-width:3.0px
    style 37 stroke:#55f,stroke-width:3.0px
    style 38 stroke:#55f,stroke-width:3.0px
    style 39 stroke:red,stroke-width:3.0px
    style 40 stroke:#55f,stroke-width:3.0px
    style 41 stroke:#55f,stroke-width:3.0px
    style 42 stroke:red,stroke-width:3.0px
    style 43 stroke:#55f,stroke-width:3.0px
    style 44 stroke:red,stroke-width:3.0px
    style 45 stroke:#55f,stroke-width:3.0px
    style 46 stroke:red,stroke-width:3.0px
    style 47 stroke:#55f,stroke-width:3.0px
    style 48 stroke:#55f,stroke-width:3.0px
    style 49 stroke:red,stroke-width:3.0px
    style 50 stroke:#55f,stroke-width:3.0px
    style 51 stroke:#55f,stroke-width:3.0px
    style 52 stroke:red,stroke-width:3.0px
    style 53 stroke:#55f,stroke-width:3.0px
    style 54 stroke:#55f,stroke-width:3.0px
    style 55 stroke:red,stroke-width:3.0px
    style 56 stroke:#55f,stroke-width:3.0px
    style 57 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
    linkStyle 5 stroke:#55f,stroke-width:2.0px
    linkStyle 6 stroke-width:2.0px
    linkStyle 7 stroke:green,stroke-width:2.0px
    linkStyle 8 stroke:#55f,stroke-width:2.0px
    linkStyle 9 stroke:red,stroke-width:2.0px
    linkStyle 10 stroke-width:2.0px
    linkStyle 11 stroke:green,stroke-width:2.0px
    linkStyle 12 stroke:#55f,stroke-width:2.0px
    linkStyle 13 stroke-width:2.0px
    linkStyle 14 stroke:green,stroke-width:2.0px
    linkStyle 15 stroke:#55f,stroke-width:2.0px
    linkStyle 16 stroke:red,stroke-width:2.0px
    linkStyle 17 stroke-width:2.0px
    linkStyle 18 stroke:green,stroke-width:2.0px
    linkStyle 19 stroke:#55f,stroke-width:2.0px
    linkStyle 20 stroke-width:2.0px
    linkStyle 21 stroke:green,stroke-width:2.0px
    linkStyle 22 stroke:#55f,stroke-width:2.0px
    linkStyle 23 stroke:red,stroke-width:2.0px
    linkStyle 24 stroke-width:2.0px
    linkStyle 25 stroke:green,stroke-width:2.0px
    linkStyle 26 stroke:#55f,stroke-width:2.0px
    linkStyle 27 stroke-width:2.0px
    linkStyle 28 stroke:green,stroke-width:2.0px
    linkStyle 29 stroke:#55f,stroke-width:2.0px
    linkStyle 30 stroke-width:2.0px
    linkStyle 31 stroke:green,stroke-width:2.0px
    linkStyle 32 stroke:#55f,stroke-width:2.0px
    linkStyle 33 stroke:red,stroke-width:2.0px
    linkStyle 34 stroke-width:2.0px
    linkStyle 35 stroke:green,stroke-width:2.0px
    linkStyle 36 stroke:#55f,stroke-width:2.0px
    linkStyle 37 stroke-width:2.0px
    linkStyle 38 stroke:green,stroke-width:2.0px
    linkStyle 39 stroke:#55f,stroke-width:2.0px
    linkStyle 40 stroke-width:2.0px
    linkStyle 41 stroke:green,stroke-width:2.0px
    linkStyle 42 stroke:#55f,stroke-width:2.0px
    linkStyle 43 stroke:red,stroke-width:2.0px
    linkStyle 44 stroke-width:2.0px
    linkStyle 45 stroke:green,stroke-width:2.0px
    linkStyle 46 stroke:#55f,stroke-width:2.0px
    linkStyle 47 stroke-width:2.0px
    linkStyle 48 stroke:green,stroke-width:2.0px
    linkStyle 49 stroke:#55f,stroke-width:2.0px
    linkStyle 50 stroke-width:2.0px
    linkStyle 51 stroke:green,stroke-width:2.0px
    linkStyle 52 stroke:#55f,stroke-width:2.0px
    linkStyle 53 stroke-width:2.0px
    linkStyle 54 stroke:green,stroke-width:2.0px
    linkStyle 55 stroke:#55f,stroke-width:2.0px
```
An ordinary validator can now verify that one of the signatures matches a public key he has in his saved Envelope from release 1.7.2. Automatic validation! This will then allow for a continued chain of validation going forward. If Casey produces 1.7.4 on his own, because Omar is out sick, validators can see that Casey's public key was in 1.7.3, signed by Omar, so they know the new release is safe.

A more strict validator might instead validate the `signerInfo` for Casey themselves. Even if they miss 1.7.3, they'll be able to chain back from any later release until they find the initial one with the `signerInfo`.

Casey is happy that he's achieved his goal: creating software releases that are easily validatable in automated ways, even as engineers change over time.
