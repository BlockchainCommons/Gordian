# Gordian Envelope Use Case: Educational Credentials

The following set of use cases demonstrate the use of Gordian Envelopes to store educational credentials. Individual categories are presented progressively: each use case builds on the previous one by demonstrating a new capability. The first set refers to Danika Kaschak, an electrical engineer and her official credentials. A standalone use case then focuses on the more ad-hoc credentials possible through a Web of Trust. Finally, another set of use cases demonstrates the distribution of credentials with a different priority: herd privacy.

Gordian Envelopes are useful for credentials in large part because of their ability to support advanced features such as elision, peer-based attestation, and herd privacy. They go far beyond just presenting validatable credentials to allowing the individual holders to decide what gets credentialed, what gets shown, how, and in what context. They thus add self-sovereign control to the standard rubric of Verifiable Credentials.

* [Part One: Official Credentials](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md#part-one-official-credentials)
   * #1: [Danika Proves Her Worth (Credentials, Signature)](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md#1-danika-proves-her-worth-credentials-signature)
   * #2: [Danika Restricts Her Revelations (Elision)](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md#2-danika-restricts-her-revelations-elision)
   * #3: [Thunder & Lightning Spotlights Danika (Third-Party Repackaging)](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md#3-thunder--lightning-spotlights-danika-third-party--repackaging)
* [Part Two: Web of Trust Credentials](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md#part-two-web-of-trust-credentials)
   * #4: [Omar Offers an Open Badge (Web of Trust Credentials)](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md#4-omar-offers-an-open-badge-web-of-trust-credentials)
* [Part Three: Herd Privacy Credentials](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md#part-three-herd-privacy-credentials)
   * #5: [Paul Private Proves Proficiency (Herd Privacy)](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Use-Cases-Educational.md#5-paul-privately-proves-proficiency-herd-privacy)

_The Danika Kaschak examples in #1 through #3 are drawn directly from [07-Elision-Example](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/7-VC-ELISION-EXAMPLE.md), one of the documents for the [Envelope-CLI app](https://github.com/BlockchainCommons/envelope-cli-swift)._

## Part One: Official Credentials

This first set of use cases demonstrates how to create (and sign) simple credentials, how the subject can elide data, how another holder can elide data, and how additional parties can add data and even new signatures to a credential.

### #1. Danika Proves Her Worth (Credentials, Signature)

> _Problem Solved:_ Danika needs to be able to prove her credentials as an electrical engineer without depending on a centralized authority.

Danika is a credentialed electrical engineer who maintains her certification through continuing education. In past years she would have listed her credentials and then potential employers would have had to go to the certification board to verify them. This was ideal for no one, because most employers didn't check certifications (leaving them vulnerable), and if they did, the check was beholden to the certification board, who might fail to verify valid credentials for any number of reasons.

Enter the new world of digital credentials. Danika is now able to show a single Gordian Envelope which lists her exact credentials:

```
CID(4676635a) [
    "certificateNumber": "123-456-789"
    "continuingEducationUnits": 1.5
    "expirationDate": 2028-01-01
    "firstName": "Danika"
    "issueDate": 2022-09-01
    "lastName": "Kaschak"
    "photo": "This is Danika Kaschak's photo."
    "professionalDevelopmentHours": 15
    "subject": "RF and Microwave Engineering"
    "topics": CBOR
    "ur:pub": "ur:crypto-pubkeys/lftaaosehdcxztpl..."
    controller: "Example Electrical Engineering Board"
    isA: "Certificate of Completion"
    issuer: "Example Electrical Engineering Board"
]
```
```mermaid
graph LR
    1(("b891373a<br/>NODE"))
    2["3b888f3c<br/>CID(4676635a)"]
    3(["3d00d64f<br/>ASSERTION"])
    4[/"2f9bee2f<br/>controller"/]
    5["4035b4bd<br/>#quot;Example Electrical Engineering Board#quot;"]
    6(["44736993<br/>ASSERTION"])
    7["05651934<br/>#quot;topics#quot;"]
    8["264aec65<br/>CBOR"]
    9(["46d6cfea<br/>ASSERTION"])
    10[/"8982354d<br/>isA"/]
    11["112e2cdb<br/>#quot;Certificate of Completion#quot;"]
    12(["4a69fca3<br/>ASSERTION"])
    13["b6d5ea01<br/>#quot;continuingEducationUnits#quot;"]
    14["02a61366<br/>1.5"]
    15(["5545f6e2<br/>ASSERTION"])
    16[/"954c8356<br/>issuer"/]
    17["4035b4bd<br/>#quot;Example Electrical Engineering Board#quot;"]
    18(["5e75ff3b<br/>ASSERTION"])
    19["1a11300a<br/>#quot;ur:pub#quot;"]
    20["fee4d010<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxztpl...#quot;"]
    21(["61689bb7<br/>ASSERTION"])
    22["e6c2932d<br/>#quot;expirationDate#quot;"]
    23["b91eea18<br/>2028-01-01"]
    24(["82825e3e<br/>ASSERTION"])
    25["eb62836d<br/>#quot;lastName#quot;"]
    26["86236e63<br/>#quot;Kaschak#quot;"]
    27(["a0274d1c<br/>ASSERTION"])
    28["62c0a26e<br/>#quot;certificateNumber#quot;"]
    29["ac0b465a<br/>#quot;123-456-789#quot;"]
    30(["e0070876<br/>ASSERTION"])
    31["0eb38394<br/>#quot;subject#quot;"]
    32["b059b0f2<br/>#quot;RF and Microwave Engineering#quot;"]
    33(["e96b24d9<br/>ASSERTION"])
    34["c8c1a6dd<br/>#quot;professionalDevelopmentHours#quot;"]
    35["0bf6b955<br/>15"]
    36(["eb1f3ba0<br/>ASSERTION"])
    37["a791d0c7<br/>#quot;photo#quot;"]
    38["20e5fb6f<br/>#quot;This is Danika Kaschak's photo.#quot;"]
    39(["f57c11a8<br/>ASSERTION"])
    40["c4d5323d<br/>#quot;firstName#quot;"]
    41["03ead475<br/>#quot;Danika#quot;"]
    42(["fcb3d37a<br/>ASSERTION"])
    43["b1e12d58<br/>#quot;issueDate#quot;"]
    44["c8bd5658<br/>2022-09-01"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    1 --> 9
    9 -->|pred| 10
    9 -->|obj| 11
    1 --> 12
    12 -->|pred| 13
    12 -->|obj| 14
    1 --> 15
    15 -->|pred| 16
    15 -->|obj| 17
    1 --> 18
    18 -->|pred| 19
    18 -->|obj| 20
    1 --> 21
    21 -->|pred| 22
    21 -->|obj| 23
    1 --> 24
    24 -->|pred| 25
    24 -->|obj| 26
    1 --> 27
    27 -->|pred| 28
    27 -->|obj| 29
    1 --> 30
    30 -->|pred| 31
    30 -->|obj| 32
    1 --> 33
    33 -->|pred| 34
    33 -->|obj| 35
    1 --> 36
    36 -->|pred| 37
    36 -->|obj| 38
    1 --> 39
    39 -->|pred| 40
    39 -->|obj| 41
    1 --> 42
    42 -->|pred| 43
    42 -->|obj| 44
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:red,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
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
    style 27 stroke:red,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    style 29 stroke:#55f,stroke-width:3.0px
    style 30 stroke:red,stroke-width:3.0px
    style 31 stroke:#55f,stroke-width:3.0px
    style 32 stroke:#55f,stroke-width:3.0px
    style 33 stroke:red,stroke-width:3.0px
    style 34 stroke:#55f,stroke-width:3.0px
    style 35 stroke:#55f,stroke-width:3.0px
    style 36 stroke:red,stroke-width:3.0px
    style 37 stroke:#55f,stroke-width:3.0px
    style 38 stroke:#55f,stroke-width:3.0px
    style 39 stroke:red,stroke-width:3.0px
    style 40 stroke:#55f,stroke-width:3.0px
    style 41 stroke:#55f,stroke-width:3.0px
    style 42 stroke:red,stroke-width:3.0px
    style 43 stroke:#55f,stroke-width:3.0px
    style 44 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke:green,stroke-width:2.0px
    linkStyle 9 stroke:#55f,stroke-width:2.0px
    linkStyle 10 stroke-width:2.0px
    linkStyle 11 stroke:green,stroke-width:2.0px
    linkStyle 12 stroke:#55f,stroke-width:2.0px
    linkStyle 13 stroke-width:2.0px
    linkStyle 14 stroke:green,stroke-width:2.0px
    linkStyle 15 stroke:#55f,stroke-width:2.0px
    linkStyle 16 stroke-width:2.0px
    linkStyle 17 stroke:green,stroke-width:2.0px
    linkStyle 18 stroke:#55f,stroke-width:2.0px
    linkStyle 19 stroke-width:2.0px
    linkStyle 20 stroke:green,stroke-width:2.0px
    linkStyle 21 stroke:#55f,stroke-width:2.0px
    linkStyle 22 stroke-width:2.0px
    linkStyle 23 stroke:green,stroke-width:2.0px
    linkStyle 24 stroke:#55f,stroke-width:2.0px
    linkStyle 25 stroke-width:2.0px
    linkStyle 26 stroke:green,stroke-width:2.0px
    linkStyle 27 stroke:#55f,stroke-width:2.0px
    linkStyle 28 stroke-width:2.0px
    linkStyle 29 stroke:green,stroke-width:2.0px
    linkStyle 30 stroke:#55f,stroke-width:2.0px
    linkStyle 31 stroke-width:2.0px
    linkStyle 32 stroke:green,stroke-width:2.0px
    linkStyle 33 stroke:#55f,stroke-width:2.0px
    linkStyle 34 stroke-width:2.0px
    linkStyle 35 stroke:green,stroke-width:2.0px
    linkStyle 36 stroke:#55f,stroke-width:2.0px
    linkStyle 37 stroke-width:2.0px
    linkStyle 38 stroke:green,stroke-width:2.0px
    linkStyle 39 stroke:#55f,stroke-width:2.0px
    linkStyle 40 stroke-width:2.0px
    linkStyle 41 stroke:green,stroke-width:2.0px
    linkStyle 42 stroke:#55f,stroke-width:2.0px

```
Of course a credential like this only has real value if it's signed; this is what ensures that no one has to reach out to the certification board, because they've issued a signed certificate in advance. 

Now, checking Danika's credentials is easy, because the signature just needs to be validated against a PKI, and that shouldn't depend on the certification board responding in a timely and appropriate way.
```
{
    CID(4676635a) [
        "certificateNumber": "123-456-789"
        "continuingEducationUnits": 1.5
        "expirationDate": 2028-01-01
        "firstName": "Danika"
        "issueDate": 2022-09-01
        "lastName": "Kaschak"
        "photo": "This is Danika Kaschak's photo."
        "professionalDevelopmentHours": 15
        "subject": "RF and Microwave Engineering"
        "topics": CBOR
        "ur:pub": "ur:crypto-pubkeys/lftaaosehdcxztpl..."
        controller: "Example Electrical Engineering Board"
        isA: "Certificate of Completion"
        issuer: "Example Electrical Engineering Board"
    ]
} [
    note: "Signed by Example Electrical Engineering Board"
    verifiedBy: Signature
]

```
```mermaid
graph LR
    1(("820fcb63<br/>NODE"))
    2[/"d8f990a1<br/>WRAPPED"\]
    3(("b891373a<br/>NODE"))
    4["3b888f3c<br/>CID(4676635a)"]
    5(["3d00d64f<br/>ASSERTION"])
    6[/"2f9bee2f<br/>controller"/]
    7["4035b4bd<br/>#quot;Example Electrical Engineering Board#quot;"]
    8(["44736993<br/>ASSERTION"])
    9["05651934<br/>#quot;topics#quot;"]
    10["264aec65<br/>CBOR"]
    11(["46d6cfea<br/>ASSERTION"])
    12[/"8982354d<br/>isA"/]
    13["112e2cdb<br/>#quot;Certificate of Completion#quot;"]
    14(["4a69fca3<br/>ASSERTION"])
    15["b6d5ea01<br/>#quot;continuingEducationUnits#quot;"]
    16["02a61366<br/>1.5"]
    17(["5545f6e2<br/>ASSERTION"])
    18[/"954c8356<br/>issuer"/]
    19["4035b4bd<br/>#quot;Example Electrical Engineering Board#quot;"]
    20(["5e75ff3b<br/>ASSERTION"])
    21["1a11300a<br/>#quot;ur:pub#quot;"]
    22["fee4d010<br/>#quot;ur:crypto-pubkeys/lftaaosehdcxztpl...#quot;"]
    23(["61689bb7<br/>ASSERTION"])
    24["e6c2932d<br/>#quot;expirationDate#quot;"]
    25["b91eea18<br/>2028-01-01"]
    26(["82825e3e<br/>ASSERTION"])
    27["eb62836d<br/>#quot;lastName#quot;"]
    28["86236e63<br/>#quot;Kaschak#quot;"]
    29(["a0274d1c<br/>ASSERTION"])
    30["62c0a26e<br/>#quot;certificateNumber#quot;"]
    31["ac0b465a<br/>#quot;123-456-789#quot;"]
    32(["e0070876<br/>ASSERTION"])
    33["0eb38394<br/>#quot;subject#quot;"]
    34["b059b0f2<br/>#quot;RF and Microwave Engineering#quot;"]
    35(["e96b24d9<br/>ASSERTION"])
    36["c8c1a6dd<br/>#quot;professionalDevelopmentHours#quot;"]
    37["0bf6b955<br/>15"]
    38(["eb1f3ba0<br/>ASSERTION"])
    39["a791d0c7<br/>#quot;photo#quot;"]
    40["20e5fb6f<br/>#quot;This is Danika Kaschak's photo.#quot;"]
    41(["f57c11a8<br/>ASSERTION"])
    42["c4d5323d<br/>#quot;firstName#quot;"]
    43["03ead475<br/>#quot;Danika#quot;"]
    44(["fcb3d37a<br/>ASSERTION"])
    45["b1e12d58<br/>#quot;issueDate#quot;"]
    46["c8bd5658<br/>2022-09-01"]
    47(["040e7274<br/>ASSERTION"])
    48[/"d59f8c0f<br/>verifiedBy"/]
    49["3f1752a0<br/>Signature"]
    50(["afe231cc<br/>ASSERTION"])
    51[/"61fb6a6b<br/>note"/]
    52["f4bf011f<br/>#quot;Signed by Example Electrical Engineering Board#quot;"]
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
    3 --> 14
    14 -->|pred| 15
    14 -->|obj| 16
    3 --> 17
    17 -->|pred| 18
    17 -->|obj| 19
    3 --> 20
    20 -->|pred| 21
    20 -->|obj| 22
    3 --> 23
    23 -->|pred| 24
    23 -->|obj| 25
    3 --> 26
    26 -->|pred| 27
    26 -->|obj| 28
    3 --> 29
    29 -->|pred| 30
    29 -->|obj| 31
    3 --> 32
    32 -->|pred| 33
    32 -->|obj| 34
    3 --> 35
    35 -->|pred| 36
    35 -->|obj| 37
    3 --> 38
    38 -->|pred| 39
    38 -->|obj| 40
    3 --> 41
    41 -->|pred| 42
    41 -->|obj| 43
    3 --> 44
    44 -->|pred| 45
    44 -->|obj| 46
    1 --> 47
    47 -->|pred| 48
    47 -->|obj| 49
    1 --> 50
    50 -->|pred| 51
    50 -->|obj| 52
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
    style 41 stroke:red,stroke-width:3.0px
    style 42 stroke:#55f,stroke-width:3.0px
    style 43 stroke:#55f,stroke-width:3.0px
    style 44 stroke:red,stroke-width:3.0px
    style 45 stroke:#55f,stroke-width:3.0px
    style 46 stroke:#55f,stroke-width:3.0px
    style 47 stroke:red,stroke-width:3.0px
    style 48 stroke:#55f,stroke-width:3.0px
    style 49 stroke:#55f,stroke-width:3.0px
    style 50 stroke:red,stroke-width:3.0px
    style 51 stroke:#55f,stroke-width:3.0px
    style 52 stroke:#55f,stroke-width:3.0px
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
    linkStyle 39 stroke-width:2.0px
    linkStyle 40 stroke:green,stroke-width:2.0px
    linkStyle 41 stroke:#55f,stroke-width:2.0px
    linkStyle 42 stroke-width:2.0px
    linkStyle 43 stroke:green,stroke-width:2.0px
    linkStyle 44 stroke:#55f,stroke-width:2.0px
    linkStyle 45 stroke-width:2.0px
    linkStyle 46 stroke:green,stroke-width:2.0px
    linkStyle 47 stroke:#55f,stroke-width:2.0px
    linkStyle 48 stroke-width:2.0px
    linkStyle 49 stroke:green,stroke-width:2.0px
    linkStyle 50 stroke:#55f,stroke-width:2.0px

```
The new envelope wraps the original credentials and both signs them and adds a note describing the signature. Additional hints for PKI to lookup the signature could also have been added.

### #2. Danika Restricts Her Revelations (Elision)

> _Problem Solved:_ Danika wants to avoid prejudice when using her credentials in job applications.

Danika is very confident in her prowess as an electrical engineer, but she fears prejudice when she seeks employment. Primarily, she is concerned about prejudice over her Eastern Europe name, but she also fears prejudice over the recent date of her certification. As a result, she produces a new, elided version of her credential that omits that information as well as other details that she considers irrelevent to her application.
```
{
    CID(4676635a) [
        "expirationDate": 2028-01-01
        "subject": "RF and Microwave Engineering"
        isA: "Certificate of Completion"
        issuer: "Example Electrical Engineering Board"
        ELIDED (10)
    ]
} [
    note: "Signed by Example Electrical Engineering Board"
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("820fcb63<br/>NODE"))
    2[/"d8f990a1<br/>WRAPPED"\]
    3(("b891373a<br/>NODE"))
    4["3b888f3c<br/>CID(4676635a)"]
    5{{"3d00d64f<br/>ELIDED"}}
    6{{"44736993<br/>ELIDED"}}
    7(["46d6cfea<br/>ASSERTION"])
    8[/"8982354d<br/>isA"/]
    9["112e2cdb<br/>#quot;Certificate of Completion#quot;"]
    10{{"4a69fca3<br/>ELIDED"}}
    11(["5545f6e2<br/>ASSERTION"])
    12[/"954c8356<br/>issuer"/]
    13["4035b4bd<br/>#quot;Example Electrical Engineering Board#quot;"]
    14{{"5e75ff3b<br/>ELIDED"}}
    15(["61689bb7<br/>ASSERTION"])
    16["e6c2932d<br/>#quot;expirationDate#quot;"]
    17["b91eea18<br/>2028-01-01"]
    18{{"82825e3e<br/>ELIDED"}}
    19{{"a0274d1c<br/>ELIDED"}}
    20(["e0070876<br/>ASSERTION"])
    21["0eb38394<br/>#quot;subject#quot;"]
    22["b059b0f2<br/>#quot;RF and Microwave Engineering#quot;"]
    23{{"e96b24d9<br/>ELIDED"}}
    24{{"eb1f3ba0<br/>ELIDED"}}
    25{{"f57c11a8<br/>ELIDED"}}
    26{{"fcb3d37a<br/>ELIDED"}}
    27(["040e7274<br/>ASSERTION"])
    28[/"d59f8c0f<br/>verifiedBy"/]
    29["3f1752a0<br/>Signature"]
    30(["afe231cc<br/>ASSERTION"])
    31[/"61fb6a6b<br/>note"/]
    32["f4bf011f<br/>#quot;Signed by Example Electrical Engineering Board#quot;"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    3 --> 6
    3 --> 7
    7 -->|pred| 8
    7 -->|obj| 9
    3 --> 10
    3 --> 11
    11 -->|pred| 12
    11 -->|obj| 13
    3 --> 14
    3 --> 15
    15 -->|pred| 16
    15 -->|obj| 17
    3 --> 18
    3 --> 19
    3 --> 20
    20 -->|pred| 21
    20 -->|obj| 22
    3 --> 23
    3 --> 24
    3 --> 25
    3 --> 26
    1 --> 27
    27 -->|pred| 28
    27 -->|obj| 29
    1 --> 30
    30 -->|pred| 31
    30 -->|obj| 32
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 6 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 11 stroke:red,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 19 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 20 stroke:red,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:#55f,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 24 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 25 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 26 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 27 stroke:red,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    style 29 stroke:#55f,stroke-width:3.0px
    style 30 stroke:red,stroke-width:3.0px
    style 31 stroke:#55f,stroke-width:3.0px
    style 32 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke-width:2.0px
    linkStyle 6 stroke:green,stroke-width:2.0px
    linkStyle 7 stroke:#55f,stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke-width:2.0px
    linkStyle 10 stroke:green,stroke-width:2.0px
    linkStyle 11 stroke:#55f,stroke-width:2.0px
    linkStyle 12 stroke-width:2.0px
    linkStyle 13 stroke-width:2.0px
    linkStyle 14 stroke:green,stroke-width:2.0px
    linkStyle 15 stroke:#55f,stroke-width:2.0px
    linkStyle 16 stroke-width:2.0px
    linkStyle 17 stroke-width:2.0px
    linkStyle 18 stroke-width:2.0px
    linkStyle 19 stroke:green,stroke-width:2.0px
    linkStyle 20 str
```
Danika can now get a prejudice-free review of her credentials while still verifying that they're hers by proving ownership of her CID.

Note that all of the hashes in the Structured Merkle Tree stay the same despite the elision. That means that the certification board's signature remains valid as well.

Danika supplements her certification with excellent scores in a third-party proctored test (producing another credential), and is hired by Thunder & Lightning Inc.

## 3. Thunder & Lightning Spotlights Danika (Third-Party  Repackaging)

> _Problem Solved:_ Thunder & Lightning Inc. needs to repackage Danika's credentials for their customers.

Thunder & Lightning Inc. is ready to send Danika to a job site! To do so they must both reveal and affirm her credentials to the job-site supervisors. Even though they are neither the issuer nor the holder of Danika's educational credentials, Thunder & Lightning is able to produce their own version of Danika's credentials.

They want Danika's name in the credentials, so they must ask her for a new copy, but then they elide the rest of the information just like she did. This is one of the strengths of Gordian Envelope: each party who holds the Envelope (or even an already-elided form of the Envelope) can choose how to further elide it to match their own requirements and their own risk models.
```
{
    CID(4676635a) [
        "expirationDate": 2028-01-01
        "firstName": "Danika"
        "lastName": "Kaschak"
        "subject": "RF and Microwave Engineering"
        isA: "Certificate of Completion"
        issuer: "Example Electrical Engineering Board"
        ELIDED (8)
    ]
} [
    note: "Signed by Example Electrical Engineering Board"
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("820fcb63<br/>NODE"))
    2[/"d8f990a1<br/>WRAPPED"\]
    3(("b891373a<br/>NODE"))
    4["3b888f3c<br/>CID(4676635a)"]
    5{{"3d00d64f<br/>ELIDED"}}
    6{{"44736993<br/>ELIDED"}}
    7(["46d6cfea<br/>ASSERTION"])
    8[/"8982354d<br/>isA"/]
    9["112e2cdb<br/>#quot;Certificate of Completion#quot;"]
    10{{"4a69fca3<br/>ELIDED"}}
    11(["5545f6e2<br/>ASSERTION"])
    12[/"954c8356<br/>issuer"/]
    13["4035b4bd<br/>#quot;Example Electrical Engineering Board#quot;"]
    14{{"5e75ff3b<br/>ELIDED"}}
    15(["61689bb7<br/>ASSERTION"])
    16["e6c2932d<br/>#quot;expirationDate#quot;"]
    17["b91eea18<br/>2028-01-01"]
    18(["82825e3e<br/>ASSERTION"])
    19["eb62836d<br/>#quot;lastName#quot;"]
    20["86236e63<br/>#quot;Kaschak#quot;"]
    21{{"a0274d1c<br/>ELIDED"}}
    22(["e0070876<br/>ASSERTION"])
    23["0eb38394<br/>#quot;subject#quot;"]
    24["b059b0f2<br/>#quot;RF and Microwave Engineering#quot;"]
    25{{"e96b24d9<br/>ELIDED"}}
    26{{"eb1f3ba0<br/>ELIDED"}}
    27(["f57c11a8<br/>ASSERTION"])
    28["c4d5323d<br/>#quot;firstName#quot;"]
    29["03ead475<br/>#quot;Danika#quot;"]
    30{{"fcb3d37a<br/>ELIDED"}}
    31(["040e7274<br/>ASSERTION"])
    32[/"d59f8c0f<br/>verifiedBy"/]
    33["3f1752a0<br/>Signature"]
    34(["afe231cc<br/>ASSERTION"])
    35[/"61fb6a6b<br/>note"/]
    36["f4bf011f<br/>#quot;Signed by Example Electrical Engineering Board#quot;"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    3 --> 6
    3 --> 7
    7 -->|pred| 8
    7 -->|obj| 9
    3 --> 10
    3 --> 11
    11 -->|pred| 12
    11 -->|obj| 13
    3 --> 14
    3 --> 15
    15 -->|pred| 16
    15 -->|obj| 17
    3 --> 18
    18 -->|pred| 19
    18 -->|obj| 20
    3 --> 21
    3 --> 22
    22 -->|pred| 23
    22 -->|obj| 24
    3 --> 25
    3 --> 26
    3 --> 27
    27 -->|pred| 28
    27 -->|obj| 29
    3 --> 30
    1 --> 31
    31 -->|pred| 32
    31 -->|obj| 33
    1 --> 34
    34 -->|pred| 35
    34 -->|obj| 36
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 6 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 11 stroke:red,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
    style 18 stroke:red,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    style 20 stroke:#55f,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 22 stroke:red,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px
    style 24 stroke:#55f,stroke-width:3.0px
    style 25 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 26 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 27 stroke:red,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    style 29 stroke:#55f,stroke-width:3.0px
    style 30 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 31 stroke:red,stroke-width:3.0px
    style 32 stroke:#55f,stroke-width:3.0px
    style 33 stroke:#55f,stroke-width:3.0px
    style 34 stroke:red,stroke-width:3.0px
    style 35 stroke:#55f,stroke-width:3.0px
    style 36 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke-width:2.0px
    linkStyle 6 stroke:green,stroke-width:2.0px
    linkStyle 7 stroke:#55f,stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke-width:2.0px
    linkStyle 10 stroke:green,stroke-width:2.0px
    linkStyle 11 stroke:#55f,stroke-width:2.0px
    linkStyle 12 stroke-width:2.0px
    linkStyle 13 stroke-width:2.0px
    linkStyle 14 stroke:green,stroke-width:2.0px
    linkStyle 15 stroke:#55f,stroke-width:2.0px
    linkStyle 16 stroke-width:2.0px
    linkStyle 17 stroke:green,stroke-width:2.0px
    linkStyle 18 stroke:#55f,stroke-width:2.0px
    linkStyle 19 stroke-width:2.0px
    linkStyle 20 stroke-width:2.0px
    linkStyle 21 stroke:green,stroke-width:2.0px
    linkStyle 22 stroke:#55f,stroke-width:2.0px
    linkStyle 23 stroke-width:2.0px
    linkStyle 24 stroke-width:2.0px
    linkStyle 25 stroke-width:2.0px
    linkStyle 26 stroke:green,stroke-width:2.0px
    linkStyle 27 stroke:#55f,stroke-width:2.0px
    linkStyle 28 stroke-width:2.0px
    linkStyle 29 stroke-width:2.0px
    linkStyle 30 stroke:green,stroke-width:2.0px
    linkStyle 31 stroke:#55f,stroke-width:2.0px
    linkStyle 32 stroke-width:2.0px
    linkStyle 33 stroke:green,stroke-width:2.0px
    linkStyle 34 stroke:#55f,stroke-width:2.0px
```
However, Thunder & Lightning Inc. also needs to add details of Danika's work with them. They do that by wrapping the original envelope and adding information on Danika's employment.
```
{
    {
        CID(4676635a) [
            "expirationDate": 2028-01-01
            "firstName": "Danika"
            "lastName": "Kaschak"
            "subject": "RF and Microwave Engineering"
            isA: "Certificate of Completion"
            issuer: "Example Electrical Engineering Board"
            ELIDED (8)
        ]
    } [
        note: "Signed by Example Electrical Engineering Board"
        verifiedBy: Signature
    ]
} [
    "employeeHiredDate": 2022-10-01
    "employeeStatus": "active"
]
```
```mermaid
graph LR
    1(("abdedfa9<br/>NODE"))
    2[/"41c818e9<br/>WRAPPED"\]
    3(("820fcb63<br/>NODE"))
    4[/"d8f990a1<br/>WRAPPED"\]
    5(("b891373a<br/>NODE"))
    6["3b888f3c<br/>CID(4676635a)"]
    7{{"3d00d64f<br/>ELIDED"}}
    8{{"44736993<br/>ELIDED"}}
    9(["46d6cfea<br/>ASSERTION"])
    10[/"8982354d<br/>isA"/]
    11["112e2cdb<br/>#quot;Certificate of Completion#quot;"]
    12{{"4a69fca3<br/>ELIDED"}}
    13(["5545f6e2<br/>ASSERTION"])
    14[/"954c8356<br/>issuer"/]
    15["4035b4bd<br/>#quot;Example Electrical Engineering Board#quot;"]
    16{{"5e75ff3b<br/>ELIDED"}}
    17(["61689bb7<br/>ASSERTION"])
    18["e6c2932d<br/>#quot;expirationDate#quot;"]
    19["b91eea18<br/>2028-01-01"]
    20(["82825e3e<br/>ASSERTION"])
    21["eb62836d<br/>#quot;lastName#quot;"]
    22["86236e63<br/>#quot;Kaschak#quot;"]
    23{{"a0274d1c<br/>ELIDED"}}
    24(["e0070876<br/>ASSERTION"])
    25["0eb38394<br/>#quot;subject#quot;"]
    26["b059b0f2<br/>#quot;RF and Microwave Engineering#quot;"]
    27{{"e96b24d9<br/>ELIDED"}}
    28{{"eb1f3ba0<br/>ELIDED"}}
    29(["f57c11a8<br/>ASSERTION"])
    30["c4d5323d<br/>#quot;firstName#quot;"]
    31["03ead475<br/>#quot;Danika#quot;"]
    32{{"fcb3d37a<br/>ELIDED"}}
    33(["040e7274<br/>ASSERTION"])
    34[/"d59f8c0f<br/>verifiedBy"/]
    35["3f1752a0<br/>Signature"]
    36(["afe231cc<br/>ASSERTION"])
    37[/"61fb6a6b<br/>note"/]
    38["f4bf011f<br/>#quot;Signed by Example Electrical Engineering Board#quot;"]
    39(["0001c9c5<br/>ASSERTION"])
    40["134a1704<br/>#quot;employeeHiredDate#quot;"]
    41["a3687c5b<br/>2022-10-01"]
    42(["310b027f<br/>ASSERTION"])
    43["f942ee55<br/>#quot;employeeStatus#quot;"]
    44["919eb85d<br/>#quot;active#quot;"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    4 -->|subj| 5
    5 -->|subj| 6
    5 --> 7
    5 --> 8
    5 --> 9
    9 -->|pred| 10
    9 -->|obj| 11
    5 --> 12
    5 --> 13
    13 -->|pred| 14
    13 -->|obj| 15
    5 --> 16
    5 --> 17
    17 -->|pred| 18
    17 -->|obj| 19
    5 --> 20
    20 -->|pred| 21
    20 -->|obj| 22
    5 --> 23
    5 --> 24
    24 -->|pred| 25
    24 -->|obj| 26
    5 --> 27
    5 --> 28
    5 --> 29
    29 -->|pred| 30
    29 -->|obj| 31
    5 --> 32
    3 --> 33
    33 -->|pred| 34
    33 -->|obj| 35
    3 --> 36
    36 -->|pred| 37
    36 -->|obj| 38
    1 --> 39
    39 -->|pred| 40
    39 -->|obj| 41
    1 --> 42
    42 -->|pred| 43
    42 -->|obj| 44
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:red,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 8 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 17 stroke:red,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    style 20 stroke:red,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:#55f,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 24 stroke:red,stroke-width:3.0px
    style 25 stroke:#55f,stroke-width:3.0px
    style 26 stroke:#55f,stroke-width:3.0px
    style 27 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 28 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 29 stroke:red,stroke-width:3.0px
    style 30 stroke:#55f,stroke-width:3.0px
    style 31 stroke:#55f,stroke-width:3.0px
    style 32 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 33 stroke:red,stroke-width:3.0px
    style 34 stroke:#55f,stroke-width:3.0px
    style 35 stroke:#55f,stroke-width:3.0px
    style 36 stroke:red,stroke-width:3.0px
    style 37 stroke:#55f,stroke-width:3.0px
    style 38 stroke:#55f,stroke-width:3.0px
    style 39 stroke:red,stroke-width:3.0px
    style 40 stroke:#55f,stroke-width:3.0px
    style 41 stroke:#55f,stroke-width:3.0px
    style 42 stroke:red,stroke-width:3.0px
    style 43 stroke:#55f,stroke-width:3.0px
    style 44 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke:red,stroke-width:2.0px
    linkStyle 4 stroke:red,stroke-width:2.0px
    linkStyle 5 stroke-width:2.0px
    linkStyle 6 stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke:green,stroke-width:2.0px
    linkStyle 9 stroke:#55f,stroke-width:2.0px
    linkStyle 10 stroke-width:2.0px
    linkStyle 11 stroke-width:2.0px
    linkStyle 12 stroke:green,stroke-width:2.0px
    linkStyle 13 stroke:#55f,stroke-width:2.0px
    linkStyle 14 stroke-width:2.0px
    linkStyle 15 stroke-width:2.0px
    linkStyle 16 stroke:green,stroke-width:2.0px
    linkStyle 17 stroke:#55f,stroke-width:2.0px
    linkStyle 18 stroke-width:2.0px
    linkStyle 19 stroke:green,stroke-width:2.0px
    linkStyle 20 stroke:#55f,stroke-width:2.0px
    linkStyle 21 stroke-width:2.0px
    linkStyle 22 stroke-width:2.0px
    linkStyle 23 stroke:green,stroke-width:2.0px
    linkStyle 24 stroke:#55f,stroke-width:2.0px
    linkStyle 25 stroke-width:2.0px
    linkStyle 26 stroke-width:2.0px
    linkStyle 27 stroke-width:2.0px
    linkStyle 28 stroke:green,stroke-width:2.0px
    linkStyle 29 stroke:#55f,stroke-width:2.0px
    linkStyle 30 stroke-width:2.0px
    linkStyle 31 stroke-width:2.0px
    linkStyle 32 stroke:green,stroke-width:2.0px
    linkStyle 33 stroke:#55f,stroke-width:2.0px
    linkStyle 34 stroke-width:2.0px
    linkStyle 35 stroke:green,stroke-width:2.0px
    linkStyle 36 stroke:#55f,stroke-width:2.0px
    linkStyle 37 stroke-width:2.0px
    linkStyle 38 stroke:green,stroke-width:2.0px
    linkStyle 39 stroke:#55f,stroke-width:2.0px
    linkStyle 40 stroke-width:2.0px
    linkStyle 41 stroke:green,stroke-width:2.0px
    linkStyle 42 stroke:#55f,stroke-width:2.0px
```
There's one final step. Since Thunder & Lightning Inc. added what are essentially new credentials, they need to wrap the envelope one more time, then sign it, to make their new claims verifiable.
```
{
    {
        {
            CID(4676635a) [
                "expirationDate": 2028-01-01
                "firstName": "Danika"
                "lastName": "Kaschak"
                "subject": "RF and Microwave Engineering"
                isA: "Certificate of Completion"
                issuer: "Example Electrical Engineering Board"
                ELIDED (8)
            ]
        } [
            note: "Signed by Example Electrical Engineering Board"
            verifiedBy: Signature
        ]
    } [
        "employeeHiredDate": 2022-10-01
        "employeeStatus": "active"
    ]
} [
    note: "Signed by Thunder & Lightning Inc."
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("275ac4ea<br/>NODE"))
    2[/"a7bf95d5<br/>WRAPPED"\]
    3(("abdedfa9<br/>NODE"))
    4[/"41c818e9<br/>WRAPPED"\]
    5(("820fcb63<br/>NODE"))
    6[/"d8f990a1<br/>WRAPPED"\]
    7(("b891373a<br/>NODE"))
    8["3b888f3c<br/>CID(4676635a)"]
    9{{"3d00d64f<br/>ELIDED"}}
    10{{"44736993<br/>ELIDED"}}
    11(["46d6cfea<br/>ASSERTION"])
    12[/"8982354d<br/>isA"/]
    13["112e2cdb<br/>#quot;Certificate of Completion#quot;"]
    14{{"4a69fca3<br/>ELIDED"}}
    15(["5545f6e2<br/>ASSERTION"])
    16[/"954c8356<br/>issuer"/]
    17["4035b4bd<br/>#quot;Example Electrical Engineering Board#quot;"]
    18{{"5e75ff3b<br/>ELIDED"}}
    19(["61689bb7<br/>ASSERTION"])
    20["e6c2932d<br/>#quot;expirationDate#quot;"]
    21["b91eea18<br/>2028-01-01"]
    22(["82825e3e<br/>ASSERTION"])
    23["eb62836d<br/>#quot;lastName#quot;"]
    24["86236e63<br/>#quot;Kaschak#quot;"]
    25{{"a0274d1c<br/>ELIDED"}}
    26(["e0070876<br/>ASSERTION"])
    27["0eb38394<br/>#quot;subject#quot;"]
    28["b059b0f2<br/>#quot;RF and Microwave Engineering#quot;"]
    29{{"e96b24d9<br/>ELIDED"}}
    30{{"eb1f3ba0<br/>ELIDED"}}
    31(["f57c11a8<br/>ASSERTION"])
    32["c4d5323d<br/>#quot;firstName#quot;"]
    33["03ead475<br/>#quot;Danika#quot;"]
    34{{"fcb3d37a<br/>ELIDED"}}
    35(["040e7274<br/>ASSERTION"])
    36[/"d59f8c0f<br/>verifiedBy"/]
    37["3f1752a0<br/>Signature"]
    38(["afe231cc<br/>ASSERTION"])
    39[/"61fb6a6b<br/>note"/]
    40["f4bf011f<br/>#quot;Signed by Example Electrical Engineering Board#quot;"]
    41(["0001c9c5<br/>ASSERTION"])
    42["134a1704<br/>#quot;employeeHiredDate#quot;"]
    43["a3687c5b<br/>2022-10-01"]
    44(["310b027f<br/>ASSERTION"])
    45["f942ee55<br/>#quot;employeeStatus#quot;"]
    46["919eb85d<br/>#quot;active#quot;"]
    47(["36367ff6<br/>ASSERTION"])
    48[/"d59f8c0f<br/>verifiedBy"/]
    49["edca9a73<br/>Signature"]
    50(["829934e2<br/>ASSERTION"])
    51[/"61fb6a6b<br/>note"/]
    52["0dca250c<br/>#quot;Signed by Thunder & Lightning Inc.#quot;"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    4 -->|subj| 5
    5 -->|subj| 6
    6 -->|subj| 7
    7 -->|subj| 8
    7 --> 9
    7 --> 10
    7 --> 11
    11 -->|pred| 12
    11 -->|obj| 13
    7 --> 14
    7 --> 15
    15 -->|pred| 16
    15 -->|obj| 17
    7 --> 18
    7 --> 19
    19 -->|pred| 20
    19 -->|obj| 21
    7 --> 22
    22 -->|pred| 23
    22 -->|obj| 24
    7 --> 25
    7 --> 26
    26 -->|pred| 27
    26 -->|obj| 28
    7 --> 29
    7 --> 30
    7 --> 31
    31 -->|pred| 32
    31 -->|obj| 33
    7 --> 34
    5 --> 35
    35 -->|pred| 36
    35 -->|obj| 37
    5 --> 38
    38 -->|pred| 39
    38 -->|obj| 40
    3 --> 41
    41 -->|pred| 42
    41 -->|obj| 43
    3 --> 44
    44 -->|pred| 45
    44 -->|obj| 46
    1 --> 47
    47 -->|pred| 48
    47 -->|obj| 49
    1 --> 50
    50 -->|pred| 51
    50 -->|obj| 52
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:red,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 10 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 11 stroke:red,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 19 stroke:red,stroke-width:3.0px
    style 20 stroke:#55f,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:red,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px
    style 24 stroke:#55f,stroke-width:3.0px
    style 25 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 26 stroke:red,stroke-width:3.0px
    style 27 stroke:#55f,stroke-width:3.0px
    style 28 stroke:#55f,stroke-width:3.0px
    style 29 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 30 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 31 stroke:red,stroke-width:3.0px
    style 32 stroke:#55f,stroke-width:3.0px
    style 33 stroke:#55f,stroke-width:3.0px
    style 34 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 35 stroke:red,stroke-width:3.0px
    style 36 stroke:#55f,stroke-width:3.0px
    style 37 stroke:#55f,stroke-width:3.0px
    style 38 stroke:red,stroke-width:3.0px
    style 39 stroke:#55f,stroke-width:3.0px
    style 40 stroke:#55f,stroke-width:3.0px
    style 41 stroke:red,stroke-width:3.0px
    style 42 stroke:#55f,stroke-width:3.0px
    style 43 stroke:#55f,stroke-width:3.0px
    style 44 stroke:red,stroke-width:3.0px
    style 45 stroke:#55f,stroke-width:3.0px
    style 46 stroke:#55f,stroke-width:3.0px
    style 47 stroke:red,stroke-width:3.0px
    style 48 stroke:#55f,stroke-width:3.0px
    style 49 stroke:#55f,stroke-width:3.0px
    style 50 stroke:red,stroke-width:3.0px
    style 51 stroke:#55f,stroke-width:3.0px
    style 52 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke:red,stroke-width:2.0px
    linkStyle 4 stroke:red,stroke-width:2.0px
    linkStyle 5 stroke:red,stroke-width:2.0px
    linkStyle 6 stroke:red,stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke-width:2.0px
    linkStyle 10 stroke:green,stroke-width:2.0px
    linkStyle 11 stroke:#55f,stroke-width:2.0px
    linkStyle 12 stroke-width:2.0px
    linkStyle 13 stroke-width:2.0px
    linkStyle 14 stroke:green,stroke-width:2.0px
    linkStyle 15 stroke:#55f,stroke-width:2.0px
    linkStyle 16 stroke-width:2.0px
    linkStyle 17 stroke-width:2.0px
    linkStyle 18 stroke:green,stroke-width:2.0px
    linkStyle 19 stroke:#55f,stroke-width:2.0px
    linkStyle 20 stroke-width:2.0px
    linkStyle 21 stroke:green,stroke-width:2.0px
    linkStyle 22 stroke:#55f,stroke-width:2.0px
    linkStyle 23 stroke-width:2.0px
    linkStyle 24 stroke-width:2.0px
    linkStyle 25 stroke:green,stroke-width:2.0px
    linkStyle 26 stroke:#55f,stroke-width:2.0px
    linkStyle 27 stroke-width:2.0px
    linkStyle 28 stroke-width:2.0px
    linkStyle 29 stroke-width:2.0px
    linkStyle 30 stroke:green,stroke-width:2.0px
    linkStyle 31 stroke:#55f,stroke-width:2.0px
    linkStyle 32 stroke-width:2.0px
    linkStyle 33 stroke-width:2.0px
    linkStyle 34 stroke:green,stroke-width:2.0px
    linkStyle 35 stroke:#55f,stroke-width:2.0px
    linkStyle 36 stroke-width:2.0px
    linkStyle 37 stroke:green,stroke-width:2.0px
    linkStyle 38 stroke:#55f,stroke-width:2.0px
    linkStyle 39 stroke-width:2.0px
    linkStyle 40 stroke:green,stroke-width:2.0px
    linkStyle 41 stroke:#55f,stroke-width:2.0px
    linkStyle 42 stroke-width:2.0px
    linkStyle 43 stroke:green,stroke-width:2.0px
    linkStyle 44 stroke:#55f,stroke-width:2.0px
    linkStyle 45 stroke-width:2.0px
    linkStyle 46 stroke:green,stroke-width:2.0px
    linkStyle 47 stroke:#55f,stroke-width:2.0px
    linkStyle 48 stroke-width:2.0px
    linkStyle 49 stroke:green,stroke-width:2.0px
    linkStyle 50 stroke:#55f,stroke-width:2.0px
```

In case the checksums have gotten too small to read, here's a look at the three stages of this use case using the `--tree` function from `envelope-cli`:

**Redacted Credential:**
```
820fcb63 NODE
    d8f990a1 subj WRAPPED
        b891373a subj NODE
            3b888f3c subj CID(4676635a)
            3d00d64f ELIDED
            44736993 ELIDED
            46d6cfea ASSERTION
                8982354d pred isA
                112e2cdb obj "Certificate of Completion"
            4a69fca3 ELIDED
            5545f6e2 ASSERTION
                954c8356 pred issuer
                4035b4bd obj "Example Electrical Engineering Board"
            5e75ff3b ELIDED
            61689bb7 ASSERTION
                e6c2932d pred "expirationDate"
                b91eea18 obj 2028-01-01
            82825e3e ASSERTION
                eb62836d pred "lastName"
                86236e63 obj "Kaschak"
            a0274d1c ELIDED
            e0070876 ASSERTION
                0eb38394 pred "subject"
                b059b0f2 obj "RF and Microwave Engineering"
            e96b24d9 ELIDED
            eb1f3ba0 ELIDED
            f57c11a8 ASSERTION
                c4d5323d pred "firstName"
                03ead475 obj "Danika"
            fcb3d37a ELIDED
    040e7274 ASSERTION
        d59f8c0f pred verifiedBy
        3f1752a0 obj Signature
    afe231cc ASSERTION
        61fb6a6b pred note
        f4bf011f obj "Signed by Example Electrical Engineering Board"
```
**Redacted Credential with Employment Credentials:**
```
abdedfa9 NODE
    41c818e9 subj WRAPPED
        820fcb63 subj NODE
            d8f990a1 subj WRAPPED
                b891373a subj NODE
                    3b888f3c subj CID(4676635a)
                    3d00d64f ELIDED
                    44736993 ELIDED
                    46d6cfea ASSERTION
                        8982354d pred isA
                        112e2cdb obj "Certificate of Completion"
                    4a69fca3 ELIDED
                    5545f6e2 ASSERTION
                        954c8356 pred issuer
                        4035b4bd obj "Example Electrical Engineering Board"
                    5e75ff3b ELIDED
                    61689bb7 ASSERTION
                        e6c2932d pred "expirationDate"
                        b91eea18 obj 2028-01-01
                    82825e3e ASSERTION
                        eb62836d pred "lastName"
                        86236e63 obj "Kaschak"
                    a0274d1c ELIDED
                    e0070876 ASSERTION
                        0eb38394 pred "subject"
                        b059b0f2 obj "RF and Microwave Engineering"
                    e96b24d9 ELIDED
                    eb1f3ba0 ELIDED
                    f57c11a8 ASSERTION
                        c4d5323d pred "firstName"
                        03ead475 obj "Danika"
                    fcb3d37a ELIDED
            040e7274 ASSERTION
                d59f8c0f pred verifiedBy
                3f1752a0 obj Signature
            afe231cc ASSERTION
                61fb6a6b pred note
                f4bf011f obj "Signed by Example Electrical Engineering Board"
    0001c9c5 ASSERTION
        134a1704 pred "employeeHiredDate"
        a3687c5b obj 2022-10-01
    310b027f ASSERTION
        f942ee55 pred "employeeStatus"
        919eb85d obj "active"
```
**Redacted Credentials with Employment Warranty:**
```
275ac4ea NODE
    a7bf95d5 subj WRAPPED
        abdedfa9 subj NODE
            41c818e9 subj WRAPPED
                820fcb63 subj NODE
                    d8f990a1 subj WRAPPED
                        b891373a subj NODE
                            3b888f3c subj CID(4676635a)
                            3d00d64f ELIDED
                            44736993 ELIDED
                            46d6cfea ASSERTION
                                8982354d pred isA
                                112e2cdb obj "Certificate of Completion"
                            4a69fca3 ELIDED
                            5545f6e2 ASSERTION
                                954c8356 pred issuer
                                4035b4bd obj "Example Electrical Engineering Board"
                            5e75ff3b ELIDED
                            61689bb7 ASSERTION
                                e6c2932d pred "expirationDate"
                                b91eea18 obj 2028-01-01
                            82825e3e ASSERTION
                                eb62836d pred "lastName"
                                86236e63 obj "Kaschak"
                            a0274d1c ELIDED
                            e0070876 ASSERTION
                                0eb38394 pred "subject"
                                b059b0f2 obj "RF and Microwave Engineering"
                            e96b24d9 ELIDED
                            eb1f3ba0 ELIDED
                            f57c11a8 ASSERTION
                                c4d5323d pred "firstName"
                                03ead475 obj "Danika"
                            fcb3d37a ELIDED
                    040e7274 ASSERTION
                        d59f8c0f pred verifiedBy
                        3f1752a0 obj Signature
                    afe231cc ASSERTION
                        61fb6a6b pred note
                        f4bf011f obj "Signed by Example Electrical Engineering Board"
            0001c9c5 ASSERTION
                134a1704 pred "employeeHiredDate"
                a3687c5b obj 2022-10-01
            310b027f ASSERTION
                f942ee55 pred "employeeStatus"
                919eb85d obj "active"
    36367ff6 ASSERTION
        d59f8c0f pred verifiedBy
        edca9a73 obj Signature
    829934e2 ASSERTION
        61fb6a6b pred note
        0dca250c obj "Signed by Thunder & Lightning Inc."
```

## Part Two: Web of Trust Credentials

It can be relatively easy to validate official credentials from centralized authorities. However, Gordian Envelopes also allow for the issuance of peer-to-peer credentials by incorporating metadata that can aid in their validation.

### 4. Omar Offers an Open Badge [Web of Trust Credentials]

> _Problem Solved:_ Jonathan wants to prove his expertise in blockchain tech writing, but there are no official credentials. 

Jonathan has been doing technical writing on blockchains for a few years and wants to extend that into a freelance career. Unfortunately, most of his extant writing has been internal documents and so he can't point potential employers to them. 

Omar, an expert in blockchain technical writing, has GitHub repos that are filled with examples of his own excellent writing, and that's led him to offer Open Badges for other people whose writing he thinks is up to spec. He creates credentials for them signed with his GitHub private key.

After positively assessing Jonath's tech writing, Omar creates a credential that identifies Jonathan and certifies his expertise.
```
"Jonathan Jakes" [
    "certificate": "2022-037" [
        isA: "Assessment of Blockchain Tech Writing Expertise"
    ]
    "githubID": "jojokes"
    "pubkey": "ur:crypto-hdkey/onaxhdclaohldlmdrtlacxhnfpptplfyltwelafsnezslyndhllnvdimmwlpylkbwzjltbdmenaahdcxlejt…"
]
```
```mermaid
graph LR
    1(("890c7f8e<br/>NODE"))
    2["2c140637<br/>#quot;Jonathan Jakes#quot;"]
    3(["3abce517<br/>ASSERTION"])
    4["57c6b19e<br/>#quot;githubID#quot;"]
    5["5be46279<br/>#quot;jojokes#quot;"]
    6(["476105b1<br/>ASSERTION"])
    7["d52596f8<br/>#quot;pubkey#quot;"]
    8["b25d41f3<br/>#quot;ur:crypto-hdkey/onaxhdclaohldlmd...#quot;"]
    9(["e814cf8a<br/>ASSERTION"])
    10["c94ddd29<br/>#quot;certificate#quot;"]
    11(("c7f812f6<br/>NODE"))
    12["455a611f<br/>#quot;2022-037#quot;"]
    13(["23b7e1d5<br/>ASSERTION"])
    14[/"8982354d<br/>isA"/]
    15["92a65996<br/>#quot;Assessment of Blockchain Tech Writing Expertise#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    1 --> 9
    9 -->|pred| 10
    9 -->|obj| 11
    11 -->|subj| 12
    11 --> 13
    13 -->|pred| 14
    13 -->|obj| 15
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:red,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke:green,stroke-width:2.0px
    linkStyle 9 stroke:#55f,stroke-width:2.0px
    linkStyle 10 stroke:red,stroke-width:2.0px
    linkStyle 11 stroke-width:2.0px
    linkStyle 12 stroke:green,stroke-width:2.0px
    linkStyle 13 stroke:#55f,stroke-width:2.0px

```
Omar then adds on information to identify himself by using a `certifiedBy` predicate that he places in the `certificate`:
```
"Jonathan Jakes" [
    "certificate": "2022-037" [
        "certifiedBy": "Omar Chaim" [
            "githubID": "omarc-bc-guy"
            "pubkeyURL": "https://github.com/omarc-bc-guy.keys"
        ]
        isA: "Assessment of Blockchain Tech Writing Expertise"
    ]
    "githubID": "jojokes"
    "pubkey": "ur:crypto-hdkey/onaxhdclaohldlmdrtlacxhnfpptplfyltwelafsnezslyndhllnvdimmwlpylkbwzjltbdmenaahdcxlejt…"
]
```
```mermaid
graph LR
    1(("1e8dd312<br/>NODE"))
    2["2c140637<br/>#quot;Jonathan Jakes#quot;"]
    3(["3abce517<br/>ASSERTION"])
    4["57c6b19e<br/>#quot;githubID#quot;"]
    5["5be46279<br/>#quot;jojokes#quot;"]
    6(["476105b1<br/>ASSERTION"])
    7["d52596f8<br/>#quot;pubkey#quot;"]
    8["b25d41f3<br/>#quot;ur:crypto-hdkey/onaxhdclaohldlmd...#quot;"]
    9(["93a06fff<br/>ASSERTION"])
    10["c94ddd29<br/>#quot;certificate#quot;"]
    11(("d885a1ee<br/>NODE"))
    12["455a611f<br/>#quot;2022-037#quot;"]
    13(["23b7e1d5<br/>ASSERTION"])
    14[/"8982354d<br/>isA"/]
    15["92a65996<br/>#quot;Assessment of Blockchain Tech Writing Expertise#quot;"]
    16(["73691a34<br/>ASSERTION"])
    17["7eb11472<br/>#quot;certifiedBy#quot;"]
    18(("c3a22f99<br/>NODE"))
    19["6759e148<br/>#quot;Omar Chaim#quot;"]
    20(["03aee188<br/>ASSERTION"])
    21["57c6b19e<br/>#quot;githubID#quot;"]
    22["34e0c09c<br/>#quot;omarc-bc-guy#quot;"]
    23(["9bc4beec<br/>ASSERTION"])
    24["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    25["78d7942e<br/>#quot;https://github.com/omarc-bc-guy.keys#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    1 --> 9
    9 -->|pred| 10
    9 -->|obj| 11
    11 -->|subj| 12
    11 --> 13
    13 -->|pred| 14
    13 -->|obj| 15
    11 --> 16
    16 -->|pred| 17
    16 -->|obj| 18
    18 -->|subj| 19
    18 --> 20
    20 -->|pred| 21
    20 -->|obj| 22
    18 --> 23
    23 -->|pred| 24
    23 -->|obj| 25
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:red,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    style 16 stroke:red,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
    style 18 stroke:red,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    style 20 stroke:red,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:#55f,stroke-width:3.0px
    style 23 stroke:red,stroke-width:3.0px
    style 24 stroke:#55f,stroke-width:3.0px
    style 25 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke:green,stroke-width:2.0px
    linkStyle 9 stroke:#55f,stroke-width:2.0px
    linkStyle 10 stroke:red,stroke-width:2.0px
    linkStyle 11 stroke-width:2.0px
    linkStyle 12 stroke:green,stroke-width:2.0px
    linkStyle 13 stroke:#55f,stroke-width:2.0px
    linkStyle 14 stroke-width:2.0px
    linkStyle 15 stroke:green,stroke-width:2.0px
    linkStyle 16 stroke:#55f,stroke-width:2.0px
    linkStyle 17 stroke:red,stroke-width:2.0px
    linkStyle 18 stroke-width:2.0px
    linkStyle 19 stroke:green,stroke-width:2.0px
    linkStyle 20 stroke:#55f,stroke-width:2.0px
    linkStyle 21 stroke-width:2.0px
    linkStyle 22 stroke:green,stroke-width:2.0px
    linkStyle 23 stroke:#55f,stroke-width:2.0px

```
The `githubID` acts as Omar's own credentials. Validators can view it to decide the worth of Omar's certification, as is traditional in a web of trust. `pubkeyURL` is meant as a hint so that validators don't have to figure out where to look up the public key associated with the GitHub-ID, but obviously any validator will need to thoughtfully consider whether the hint is proper and links to the ID shown.

To finalize the Open Badge, Omar must then wrap the envelope and sign it with the private key associated with the public key he has registered on GitHub.
```
{
    "Jonathan Jakes" [
        "certificate": "2022-037" [
            "certifiedBy": "Omar Chaim" [
                "githubID": "omarc-bc-guy"
                "pubkeyURL": "https://github.com/omarc-bc-guy.keys"
            ]
            isA: "Assessment of Blockchain Tech Writing Expertise"
        ]
        "githubID": "jojokes"
        "pubkey": "ur:crypto-hdkey/onaxhdclaohldlmdrtlacxhnfpptplfyltwelafsnezslyndhllnvdimmwlpylkbwzjltbdmenaahdcxlejt…"
    ]
} [
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("c038c4f0<br/>NODE"))
    2[/"a2e3be2a<br/>WRAPPED"\]
    3(("1e8dd312<br/>NODE"))
    4["2c140637<br/>#quot;Jonathan Jakes#quot;"]
    5(["3abce517<br/>ASSERTION"])
    6["57c6b19e<br/>#quot;githubID#quot;"]
    7["5be46279<br/>#quot;jojokes#quot;"]
    8(["476105b1<br/>ASSERTION"])
    9["d52596f8<br/>#quot;pubkey#quot;"]
    10["b25d41f3<br/>#quot;ur:crypto-hdkey/onaxhdclaohldlmd...#quot;"]
    11(["93a06fff<br/>ASSERTION"])
    12["c94ddd29<br/>#quot;certificate#quot;"]
    13(("d885a1ee<br/>NODE"))
    14["455a611f<br/>#quot;2022-037#quot;"]
    15(["23b7e1d5<br/>ASSERTION"])
    16[/"8982354d<br/>isA"/]
    17["92a65996<br/>#quot;Assessment of Blockchain Tech Writing Expertise#quot;"]
    18(["73691a34<br/>ASSERTION"])
    19["7eb11472<br/>#quot;certifiedBy#quot;"]
    20(("c3a22f99<br/>NODE"))
    21["6759e148<br/>#quot;Omar Chaim#quot;"]
    22(["03aee188<br/>ASSERTION"])
    23["57c6b19e<br/>#quot;githubID#quot;"]
    24["34e0c09c<br/>#quot;omarc-bc-guy#quot;"]
    25(["9bc4beec<br/>ASSERTION"])
    26["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    27["78d7942e<br/>#quot;https://github.com/omarc-bc-guy.keys#quot;"]
    28(["3b53237e<br/>ASSERTION"])
    29[/"d59f8c0f<br/>verifiedBy"/]
    30["fc5bb849<br/>Signature"]
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
    13 -->|subj| 14
    13 --> 15
    15 -->|pred| 16
    15 -->|obj| 17
    13 --> 18
    18 -->|pred| 19
    18 -->|obj| 20
    20 -->|subj| 21
    20 --> 22
    22 -->|pred| 23
    22 -->|obj| 24
    20 --> 25
    25 -->|pred| 26
    25 -->|obj| 27
    1 --> 28
    28 -->|pred| 29
    28 -->|obj| 30
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
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
    style 18 stroke:red,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    style 20 stroke:red,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:red,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px
    style 24 stroke:#55f,stroke-width:3.0px
    style 25 stroke:red,stroke-width:3.0px
    style 26 stroke:#55f,stroke-width:3.0px
    style 27 stroke:#55f,stroke-width:3.0px
    style 28 stroke:red,stroke-width:3.0px
    style 29 stroke:#55f,stroke-width:3.0px
    style 30 stroke:#55f,stroke-width:3.0px
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
    linkStyle 12 stroke:red,stroke-width:2.0px
    linkStyle 13 stroke-width:2.0px
    linkStyle 14 stroke:green,stroke-width:2.0px
    linkStyle 15 stroke:#55f,stroke-width:2.0px
    linkStyle 16 stroke-width:2.0px
    linkStyle 17 stroke:green,stroke-width:2.0px
    linkStyle 18 stroke:#55f,stroke-width:2.0px
    linkStyle 19 stroke:red,stroke-width:2.0px
    linkStyle 20 stroke-width:2.0px
    linkStyle 21 stroke:green,stroke-width:2.0px
    linkStyle 22 stroke:#55f,stroke-width:2.0px
    linkStyle 23 stroke-width:2.0px
    linkStyle 24 stroke:green,stroke-width:2.0px
    linkStyle 25 stroke:#55f,stroke-width:2.0px
    linkStyle 26 stroke-width:2.0px
    linkStyle 27 stroke:green,stroke-width:2.0px
    linkStyle 28 stroke:#55f,stroke-width:2.0px
```

## Part Three: Herd Privacy Credentials

Educational credentials are usually presumed to be packaged in discrete Envelopes that identify a single user. However, some situations may benefit from conglomerating thousands of credentials in a single Envelope, giving each of those users privacy — even from the credential issuer!

### 5. Paul Privately Proves Proficiency [Herd Privacy]

> _Problem Solved:_ Paul wants a credential, but he doesn't trust the organization giving out the credentials with his personal information!

Paul wants to get a credential showing proficiency in Gordian Envelope from Blockchain Commons, but he's a good Cypherpunk: he knows not to trust any organization. Fortunately, Blockchain Commons has privacy-protecting options.

Paul can take an online test in either Basic form (automated Q&A with a time limit) or Advanced form (Q&A with a live proctor on Zoom). He chooses the former, again for privacy reasons. After he succeeds at the test (50 out of 50, of course!), he needs to get his credential.

At this point, more credential issuers would require Paul to give up an email address and then mail them the personal credential, but Blockchain Commons' privacy preserving methodology simply requires Paul to give them a DID (for which he presumably controls the private key). They'll then embed that DID in a very large Envelope with the credentials of everyone who succeeded at the test that month. (Paul must wait until the Envelope is generated before he can prove anything!)

At the end of the month, Blockchain Commons creates a large Gordian Envelope that contains the DIDs of everyone who passed their test that month, with a statement as to whether each DID `isBasic` or `isAdvanced`.

(An actual example would likely have hundreds of entries to ensure herd privacy. The following examples notably reduce that for readability.)
```
"Blockchain Commons Certifactions #13" [
    "certifiedBy": "Blockchain Commons" [
        "pubkeyURL": "https://www.blockchaincommons.com/certification.keys"
    ]
    "date": "11-01-2022"
    "isAdvanced": "ur:crypto-cid/hdcxbetimuglwppshfqdsahsktgmnelsjnbdcanspmnshkpecxcfztlkiohgenytntmkaxjngadt"
    "isAdvanced": "ur:crypto-cid/hdcxjsdwaegrpfwmbkehhscwmshpchlnhhayadadwszcghhtmnzcgomhutcmytldfwpadmdlcwfe"
    "isAdvanced": "ur:crypto-cid/hdcxmhtnnlcshsjzhywyhgttsrgulstdwdnezesekosndnfxswzezolrfdcwlulacxeopdkghnht"
    "isBasic": "ur:crypto-cid/hdcxaepthffshppabkgydawmlftbpfrnaefzrdjehybwtskgmwveenwzntpyhdrpsfqzsgqdftnb"
    "isBasic": "ur:crypto-cid/hdcxdkmhpfathyyltnnboypsemehkimudnkgeyosgolncfmdnboypsecpsghtefzetkndpeylrfz"
    "isBasic": "ur:crypto-cid/hdcxfnmdsrgdkbvekoecwevystbaztbwcshpqdbzkeatjlndlywepyctlkvwemhkiyhtenwnghda"
    "isBasic": "ur:crypto-cid/hdcxhnutcyktgtfxotvegrhllypakenlgoetmnnlimsktppkssloghpahsdeparktbkerebatyce"
    "isBasic": "ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts"
    "isBasic": "ur:crypto-cid/hdcxmnktvdgeettlfmbklytaseayoeplwynbsawdurmuuelbbsfxbbaxkkpsemjovybzswqdssva"
    "isBasic": "ur:crypto-cid/hdcxuykblalfdalsvaplrfzsoxqdvdclstmdtssfdatkmecwnsbzmseohswldaytdmsfbwaxvewp"
]

```
```mermaid
graph LR
    1(("8454109e<br/>NODE"))
    2["7d0782b8<br/>#quot;Blockchain Commons Certifactions #13#quot;"]
    3(["0d31bdce<br/>ASSERTION"])
    4["2100a83d<br/>#quot;isBasic#quot;"]
    5["03e7479a<br/>#quot;ur:crypto-cid/hdcxdkmhpfathyyltnnboypsemehkimudnkgeyosgolncfmdnboypsecpsghtefzetkndpeylrfz#quot;"]
    6(["0e421d2e<br/>ASSERTION"])
    7["127a2386<br/>#quot;date#quot;"]
    8["c666f06c<br/>#quot;11-01-2022#quot;"]
    9(["336f50d3<br/>ASSERTION"])
    10["d68d0704<br/>#quot;isAdvanced#quot;"]
    11["9fb97d91<br/>#quot;ur:crypto-cid/hdcxjsdwaegrpfwmbkehhscwmshpchlnhhayadadwszcghhtmnzcgomhutcmytldfwpadmdlcwfe#quot;"]
    12(["58f1cdd3<br/>ASSERTION"])
    13["2100a83d<br/>#quot;isBasic#quot;"]
    14["478112c2<br/>#quot;ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts#quot;"]
    15(["5b278116<br/>ASSERTION"])
    16["2100a83d<br/>#quot;isBasic#quot;"]
    17["262db130<br/>#quot;ur:crypto-cid/hdcxhnutcyktgtfxotvegrhllypakenlgoetmnnlimsktppkssloghpahsdeparktbkerebatyce#quot;"]
    18(["64e8fe1e<br/>ASSERTION"])
    19["7eb11472<br/>#quot;certifiedBy#quot;"]
    20(("55378d51<br/>NODE"))
    21["8ae1d503<br/>#quot;Blockchain Commons#quot;"]
    22(["b0a1cbca<br/>ASSERTION"])
    23["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    24["04d0d649<br/>#quot;https://www.blockchaincommons.com/certification.keys#quot;"]
    25(["92f71067<br/>ASSERTION"])
    26["2100a83d<br/>#quot;isBasic#quot;"]
    27["37a1d85a<br/>#quot;ur:crypto-cid/hdcxfnmdsrgdkbvekoecwevystbaztbwcshpqdbzkeatjlndlywepyctlkvwemhkiyhtenwnghda#quot;"]
    28(["b22278f9<br/>ASSERTION"])
    29["d68d0704<br/>#quot;isAdvanced#quot;"]
    30["3410120d<br/>#quot;ur:crypto-cid/hdcxmhtnnlcshsjzhywyhgttsrgulstdwdnezesekosndnfxswzezolrfdcwlulacxeopdkghnht#quot;"]
    31(["c2f3fe78<br/>ASSERTION"])
    32["2100a83d<br/>#quot;isBasic#quot;"]
    33["950f78c1<br/>#quot;ur:crypto-cid/hdcxuykblalfdalsvaplrfzsoxqdvdclstmdtssfdatkmecwnsbzmseohswldaytdmsfbwaxvewp#quot;"]
    34(["c3bd8189<br/>ASSERTION"])
    35["2100a83d<br/>#quot;isBasic#quot;"]
    36["a3c3105c<br/>#quot;ur:crypto-cid/hdcxmnktvdgeettlfmbklytaseayoeplwynbsawdurmuuelbbsfxbbaxkkpsemjovybzswqdssva#quot;"]
    37(["ca13e82f<br/>ASSERTION"])
    38["2100a83d<br/>#quot;isBasic#quot;"]
    39["eb9d612b<br/>#quot;ur:crypto-cid/hdcxaepthffshppabkgydawmlftbpfrnaefzrdjehybwtskgmwveenwzntpyhdrpsfqzsgqdftnb#quot;"]
    40(["e67d3bb2<br/>ASSERTION"])
    41["d68d0704<br/>#quot;isAdvanced#quot;"]
    42["a285aabe<br/>#quot;ur:crypto-cid/hdcxbetimuglwppshfqdsahsktgmnelsjnbdcanspmnshkpecxcfztlkiohgenytntmkaxjngadt#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    1 --> 9
    9 -->|pred| 10
    9 -->|obj| 11
    1 --> 12
    12 -->|pred| 13
    12 -->|obj| 14
    1 --> 15
    15 -->|pred| 16
    15 -->|obj| 17
    1 --> 18
    18 -->|pred| 19
    18 -->|obj| 20
    20 -->|subj| 21
    20 --> 22
    22 -->|pred| 23
    22 -->|obj| 24
    1 --> 25
    25 -->|pred| 26
    25 -->|obj| 27
    1 --> 28
    28 -->|pred| 29
    28 -->|obj| 30
    1 --> 31
    31 -->|pred| 32
    31 -->|obj| 33
    1 --> 34
    34 -->|pred| 35
    34 -->|obj| 36
    1 --> 37
    37 -->|pred| 38
    37 -->|obj| 39
    1 --> 40
    40 -->|pred| 41
    40 -->|obj| 42
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:red,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:red,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
    style 18 stroke:red,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    style 20 stroke:red,stroke-width:3.0px
    style 21 stroke:#55f,stroke-width:3.0px
    style 22 stroke:red,stroke-width:3.0px
    style 23 stroke:#55f,stroke-width:3.0px
    style 24 stroke:#55f,stroke-width:3.0px
    style 25 stroke:red,stroke-width:3.0px
    style 26 stroke:#55f,stroke-width:3.0px
    style 27 stroke:#55f,stroke-width:3.0px
    style 28 stroke:red,stroke-width:3.0px
    style 29 stroke:#55f,stroke-width:3.0px
    style 30 stroke:#55f,stroke-width:3.0px
    style 31 stroke:red,stroke-width:3.0px
    style 32 stroke:#55f,stroke-width:3.0px
    style 33 stroke:#55f,stroke-width:3.0px
    style 34 stroke:red,stroke-width:3.0px
    style 35 stroke:#55f,stroke-width:3.0px
    style 36 stroke:#55f,stroke-width:3.0px
    style 37 stroke:red,stroke-width:3.0px
    style 38 stroke:#55f,stroke-width:3.0px
    style 39 stroke:#55f,stroke-width:3.0px
    style 40 stroke:red,stroke-width:3.0px
    style 41 stroke:#55f,stroke-width:3.0px
    style 42 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke:green,stroke-width:2.0px
    linkStyle 9 stroke:#55f,stroke-width:2.0px
    linkStyle 10 stroke-width:2.0px
    linkStyle 11 stroke:green,stroke-width:2.0px
    linkStyle 12 stroke:#55f,stroke-width:2.0px
    linkStyle 13 stroke-width:2.0px
    linkStyle 14 stroke:green,stroke-width:2.0px
    linkStyle 15 stroke:#55f,stroke-width:2.0px
    linkStyle 16 stroke-width:2.0px
    linkStyle 17 stroke:green,stroke-width:2.0px
    linkStyle 18 stroke:#55f,stroke-width:2.0px
    linkStyle 19 stroke:red,stroke-width:2.0px
    linkStyle 20 stroke-width:2.0px
    linkStyle 21 stroke:green,stroke-width:2.0px
    linkStyle 22 stroke:#55f,stroke-width:2.0px
    linkStyle 23 stroke-width:2.0px
    linkStyle 24 stroke:green,stroke-width:2.0px
    linkStyle 25 stroke:#55f,stroke-width:2.0px
    linkStyle 26 stroke-width:2.0px
    linkStyle 27 stroke:green,stroke-width:2.0px
    linkStyle 28 stroke:#55f,stroke-width:2.0px
    linkStyle 29 stroke-width:2.0px
    linkStyle 30 stroke:green,stroke-width:2.0px
    linkStyle 31 stroke:#55f,stroke-width:2.0px
    linkStyle 32 stroke-width:2.0px
    linkStyle 33 stroke:green,stroke-width:2.0px
    linkStyle 34 stroke:#55f,stroke-width:2.0px
    linkStyle 35 stroke-width:2.0px
    linkStyle 36 stroke:green,stroke-width:2.0px
    linkStyle 37 stroke:#55f,stroke-width:2.0px
    linkStyle 38 stroke-width:2.0px
    linkStyle 39 stroke:green,stroke-width:2.0px
    linkStyle 40 stroke:#55f,stroke-width:2.0px

```
As usual, a signature is required to verify credentials. The credentials are thus wrapped and signed. This signature should match the `pubkeyURL` provided.
```
{
    "Blockchain Commons Certifactions #13" [
        "certifiedBy": "Blockchain Commons" [
            "pubkeyURL": "https://www.blockchaincommons.com/certification.keys"
        ]
        "date": "11-01-2022"
        "isAdvanced": "ur:crypto-cid/hdcxbetimuglwppshfqdsahsktgmnelsjnbdcanspmnshkpecxcfztlkiohgenytntmkaxjngadt"
        "isAdvanced": "ur:crypto-cid/hdcxjsdwaegrpfwmbkehhscwmshpchlnhhayadadwszcghhtmnzcgomhutcmytldfwpadmdlcwfe"
        "isAdvanced": "ur:crypto-cid/hdcxmhtnnlcshsjzhywyhgttsrgulstdwdnezesekosndnfxswzezolrfdcwlulacxeopdkghnht"
        "isBasic": "ur:crypto-cid/hdcxaepthffshppabkgydawmlftbpfrnaefzrdjehybwtskgmwveenwzntpyhdrpsfqzsgqdftnb"
        "isBasic": "ur:crypto-cid/hdcxdkmhpfathyyltnnboypsemehkimudnkgeyosgolncfmdnboypsecpsghtefzetkndpeylrfz"
        "isBasic": "ur:crypto-cid/hdcxfnmdsrgdkbvekoecwevystbaztbwcshpqdbzkeatjlndlywepyctlkvwemhkiyhtenwnghda"
        "isBasic": "ur:crypto-cid/hdcxhnutcyktgtfxotvegrhllypakenlgoetmnnlimsktppkssloghpahsdeparktbkerebatyce"
        "isBasic": "ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts"
        "isBasic": "ur:crypto-cid/hdcxmnktvdgeettlfmbklytaseayoeplwynbsawdurmuuelbbsfxbbaxkkpsemjovybzswqdssva"
        "isBasic": "ur:crypto-cid/hdcxuykblalfdalsvaplrfzsoxqdvdclstmdtssfdatkmecwnsbzmseohswldaytdmsfbwaxvewp"
    ]
} [
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("c15f15a6<br/>NODE"))
    2[/"4e177a1e<br/>WRAPPED"\]
    3(("8454109e<br/>NODE"))
    4["7d0782b8<br/>#quot;Blockchain Commons Certifactions #13#quot;"]
    5(["0d31bdce<br/>ASSERTION"])
    6["2100a83d<br/>#quot;isBasic#quot;"]
    7["03e7479a<br/>#quot;ur:crypto-cid/hdcxdkmhpfathyyltnnboypsemehkimudnkgeyosgolncfmdnboypsecpsghtefzetkndpeylrfz#quot;"]
    8(["0e421d2e<br/>ASSERTION"])
    9["127a2386<br/>#quot;date#quot;"]
    10["c666f06c<br/>#quot;11-01-2022#quot;"]
    11(["336f50d3<br/>ASSERTION"])
    12["d68d0704<br/>#quot;isAdvanced#quot;"]
    13["9fb97d91<br/>#quot;ur:crypto-cid/hdcxjsdwaegrpfwmbkehhscwmshpchlnhhayadadwszcghhtmnzcgomhutcmytldfwpadmdlcwfe#quot;"]
    14(["58f1cdd3<br/>ASSERTION"])
    15["2100a83d<br/>#quot;isBasic#quot;"]
    16["478112c2<br/>#quot;ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts#quot;"]
    17(["5b278116<br/>ASSERTION"])
    18["2100a83d<br/>#quot;isBasic#quot;"]
    19["262db130<br/>#quot;ur:crypto-cid/hdcxhnutcyktgtfxotvegrhllypakenlgoetmnnlimsktppkssloghpahsdeparktbkerebatyce#quot;"]
    20(["64e8fe1e<br/>ASSERTION"])
    21["7eb11472<br/>#quot;certifiedBy#quot;"]
    22(("55378d51<br/>NODE"))
    23["8ae1d503<br/>#quot;Blockchain Commons#quot;"]
    24(["b0a1cbca<br/>ASSERTION"])
    25["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    26["04d0d649<br/>#quot;https://www.blockchaincommons.com/certification.keys#quot;"]
    27(["92f71067<br/>ASSERTION"])
    28["2100a83d<br/>#quot;isBasic#quot;"]
    29["37a1d85a<br/>#quot;ur:crypto-cid/hdcxfnmdsrgdkbvekoecwevystbaztbwcshpqdbzkeatjlndlywepyctlkvwemhkiyhtenwnghda#quot;"]
    30(["b22278f9<br/>ASSERTION"])
    31["d68d0704<br/>#quot;isAdvanced#quot;"]
    32["3410120d<br/>#quot;ur:crypto-cid/hdcxmhtnnlcshsjzhywyhgttsrgulstdwdnezesekosndnfxswzezolrfdcwlulacxeopdkghnht#quot;"]
    33(["c2f3fe78<br/>ASSERTION"])
    34["2100a83d<br/>#quot;isBasic#quot;"]
    35["950f78c1<br/>#quot;ur:crypto-cid/hdcxuykblalfdalsvaplrfzsoxqdvdclstmdtssfdatkmecwnsbzmseohswldaytdmsfbwaxvewp#quot;"]
    36(["c3bd8189<br/>ASSERTION"])
    37["2100a83d<br/>#quot;isBasic#quot;"]
    38["a3c3105c<br/>#quot;ur:crypto-cid/hdcxmnktvdgeettlfmbklytaseayoeplwynbsawdurmuuelbbsfxbbaxkkpsemjovybzswqdssva#quot;"]
    39(["ca13e82f<br/>ASSERTION"])
    40["2100a83d<br/>#quot;isBasic#quot;"]
    41["eb9d612b<br/>#quot;ur:crypto-cid/hdcxaepthffshppabkgydawmlftbpfrnaefzrdjehybwtskgmwveenwzntpyhdrpsfqzsgqdftnb#quot;"]
    42(["e67d3bb2<br/>ASSERTION"])
    43["d68d0704<br/>#quot;isAdvanced#quot;"]
    44["a285aabe<br/>#quot;ur:crypto-cid/hdcxbetimuglwppshfqdsahsktgmnelsjnbdcanspmnshkpecxcfztlkiohgenytntmkaxjngadt#quot;"]
    45(["2729c308<br/>ASSERTION"])
    46[/"d59f8c0f<br/>verifiedBy"/]
    47["19644509<br/>Signature"]
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
    3 --> 14
    14 -->|pred| 15
    14 -->|obj| 16
    3 --> 17
    17 -->|pred| 18
    17 -->|obj| 19
    3 --> 20
    20 -->|pred| 21
    20 -->|obj| 22
    22 -->|subj| 23
    22 --> 24
    24 -->|pred| 25
    24 -->|obj| 26
    3 --> 27
    27 -->|pred| 28
    27 -->|obj| 29
    3 --> 30
    30 -->|pred| 31
    30 -->|obj| 32
    3 --> 33
    33 -->|pred| 34
    33 -->|obj| 35
    3 --> 36
    36 -->|pred| 37
    36 -->|obj| 38
    3 --> 39
    39 -->|pred| 40
    39 -->|obj| 41
    3 --> 42
    42 -->|pred| 43
    42 -->|obj| 44
    1 --> 45
    45 -->|pred| 46
    45 -->|obj| 47
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
    style 32 stroke:#55f,stroke-width:3.0px
    style 33 stroke:red,stroke-width:3.0px
    style 34 stroke:#55f,stroke-width:3.0px
    style 35 stroke:#55f,stroke-width:3.0px
    style 36 stroke:red,stroke-width:3.0px
    style 37 stroke:#55f,stroke-width:3.0px
    style 38 stroke:#55f,stroke-width:3.0px
    style 39 stroke:red,stroke-width:3.0px
    style 40 stroke:#55f,stroke-width:3.0px
    style 41 stroke:#55f,stroke-width:3.0px
    style 42 stroke:red,stroke-width:3.0px
    style 43 stroke:#55f,stroke-width:3.0px
    style 44 stroke:#55f,stroke-width:3.0px
    style 45 stroke:red,stroke-width:3.0px
    style 46 stroke:#55f,stroke-width:3.0px
    style 47 stroke:#55f,stroke-width:3.0px
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
    linkStyle 31 stroke-width:2.0px
    linkStyle 32 stroke:green,stroke-width:2.0px
    linkStyle 33 stroke:#55f,stroke-width:2.0px
    linkStyle 34 stroke-width:2.0px
    linkStyle 35 stroke:green,stroke-width:2.0px
    linkStyle 36 stroke:#55f,stroke-width:2.0px
    linkStyle 37 stroke-width:2.0px
    linkStyle 38 stroke:green,stroke-width:2.0px
    linkStyle 39 stroke:#55f,stroke-width:2.0px
    linkStyle 40 stroke-width:2.0px
    linkStyle 41 stroke:green,stroke-width:2.0px
    linkStyle 42 stroke:#55f,stroke-width:2.0px
    linkStyle 43 stroke-width:2.0px
    linkStyle 44 stroke:green,stroke-width:2.0px
    linkStyle 45 stroke:#55f,stroke-width:2.0px
```
However, to create herd privacy, Blockchain Commons doesn't release the full Envelope. Instead, they release an elided version that only contains the certification information and signature.
```
{
    "Blockchain Commons Certifactions #13" [
        "certifiedBy": "Blockchain Commons" [
            "pubkeyURL": "https://www.blockchaincommons.com/certification.keys"
        ]
        "date": "11-01-2022"
        ELIDED (10)
    ]
} [
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("c15f15a6<br/>NODE"))
    2[/"4e177a1e<br/>WRAPPED"\]
    3(("8454109e<br/>NODE"))
    4["7d0782b8<br/>#quot;Blockchain Commons Certifactions #13#quot;"]
    5{{"0d31bdce<br/>ELIDED"}}
    6(["0e421d2e<br/>ASSERTION"])
    7["127a2386<br/>#quot;date#quot;"]
    8["c666f06c<br/>#quot;11-01-2022#quot;"]
    9{{"336f50d3<br/>ELIDED"}}
    10{{"58f1cdd3<br/>ELIDED"}}
    11{{"5b278116<br/>ELIDED"}}
    12(["64e8fe1e<br/>ASSERTION"])
    13["7eb11472<br/>#quot;certifiedBy#quot;"]
    14(("55378d51<br/>NODE"))
    15["8ae1d503<br/>#quot;Blockchain Commons#quot;"]
    16(["b0a1cbca<br/>ASSERTION"])
    17["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    18["04d0d649<br/>#quot;https://www.blockchaincommons.com/certification.keys#quot;"]
    19{{"92f71067<br/>ELIDED"}}
    20{{"b22278f9<br/>ELIDED"}}
    21{{"c2f3fe78<br/>ELIDED"}}
    22{{"c3bd8189<br/>ELIDED"}}
    23{{"ca13e82f<br/>ELIDED"}}
    24{{"e67d3bb2<br/>ELIDED"}}
    25(["2729c308<br/>ASSERTION"])
    26[/"d59f8c0f<br/>verifiedBy"/]
    27["19644509<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    3 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    3 --> 9
    3 --> 10
    3 --> 11
    3 --> 12
    12 -->|pred| 13
    12 -->|obj| 14
    14 -->|subj| 15
    14 --> 16
    16 -->|pred| 17
    16 -->|obj| 18
    3 --> 19
    3 --> 20
    3 --> 21
    3 --> 22
    3 --> 23
    3 --> 24
    1 --> 25
    25 -->|pred| 26
    25 -->|obj| 27
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 10 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 11 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 12 stroke:red,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:red,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    style 16 stroke:red,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 20 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 21 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 22 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 23 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 24 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 25 stroke:red,stroke-width:3.0px
    style 26 stroke:#55f,stroke-width:3.0px
    style 27 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke-width:2.0px
    linkStyle 10 stroke-width:2.0px
    linkStyle 11 stroke:green,stroke-width:2.0px
    linkStyle 12 stroke:#55f,stroke-width:2.0px
    linkStyle 13 stroke:red,stroke-width:2.0px
    linkStyle 14 stroke-width:2.0px
    linkStyle 15 stroke:green,stroke-width:2.0px
    linkStyle 16 stroke:#55f,stroke-width:2.0px
    linkStyle 17 stroke-width:2.0px
    linkStyle 18 stroke-width:2.0px
    linkStyle 19 stroke-width:2.0px
    linkStyle 20 stroke-width:2.0px
    linkStyle 21 stroke-width:2.0px
    linkStyle 22 stroke-width:2.0px
    linkStyle 23 stroke-width:2.0px
    linkStyle 24 stroke:green,stroke-width:2.0px
    linkStyle 25 stroke:#55f,stroke-width:2.0px
```
Note that each elided entry of certification still has its prior hash. All that Paul needs to do is prove that he can generate one of those hashes with his CID, and he proves his certification!

Blockchain Commons publishes instructions for how to do so. Test takers just need to create an assertion with either the "isBasic" predicate or the "isAdvanced" predicate and their portable `ur:crypto-cid`. When they hash that assertion with BLAKE3, they can then prove that the digest is part of the partially redacted list of credentials.

Paul creates his assertion based on the instructions:
```
"isBasic": "ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts"
```
```mermaid
graph LR
    1(["58f1cdd3<br/>ASSERTION"])
    2["2100a83d<br/>#quot;isBasic#quot;"]
    3["478112c2<br/>#quot;ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts#quot;"]
    1 -->|pred| 2
    1 -->|obj| 3
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:green,stroke-width:2.0px
    linkStyle 1 stroke:#55f,stroke-width:2.0px
```
He then creates the digest of that credential:
```
ur:crypto-digest/hdcxhdwnsntebthnrhzmzsjpvazttpzctlmhcwrffnlthhgdkptscsayzmcxndpdessabzjekbur
```
That's the Blake3 hash of his assertion in UR form. If converted to hex, it is:
```
58F1CDD30D60B9FFFA72E6FCD8FDD5901BBC3C875C5075D71808FF209BA839C2
```
As can be seen, that matches the third redacted hash in the Mermaid diagram above, which was the `isBasic` assertion for `ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts`.

Now, Paul can point to Blockchain Common's partially redacted tree of November 2022 certifications, reveal his CID, acknowledge that he passed the basic testing, and show his digest. Together these facts prove that the CID is part of the tree. 

More notably, Paul can decide never to reveal his CID, and then it's more difficult to prove that it's a member of this group.

Mind you, because the tree is partially redacted, and because no particular attempt has been made to prevent correlation, its possible that CIDs in the Envelope could be guessed. There are several ways this could be prevented. They all require Blockchain Commons to provide additional information to Paul, increasing the communication requirements (and thus potentially impacting privacy), but they add strong non-correlation defenses.

1.) Blockchain Commons could choose to fully redact the Envelope, publishing only a top-level hash. They would then supply Paul with a path to his lower-level hash by partially redacting the tree when he supplied them with his CID. Paul could then prove his presence in the Envelope with his digest and that path. If that path were to be more widely released, there would be the same correlation problems, but obviously they'd be lesser because it probably would never be widely published.

2.) Alternatively, Blockchain Commons could restructure the Envelope so that every 5 or 10 or 20 CIDs are placed in a subenvelope. Their publicly published proof would only show the hashes of these subenvelopes, which will be relatively impossible to correlate. Paul would then be able to request a path to his own subenvelope. Even if this path were more widely released, there would only be a possibility of correlation for the other CIDs that happen to be in that subenvelope.

3.) Finally, Blockchain Commons could choose to salt every CID in the Envelope. They would then have to supply Paul with his salt. (The twin limitations here are that salting everything dramatically increases the size of the Envelope and that Paul has a piece of data that he can't lose).

_Herd privacy is one of the strong, unique features of Gordian Envelope. We plan to extend these Educational examples with a few more looks at it, either extending the alternative methodologies discussed here or offering other features._

### Related Files

* [Other Envelope Use Cases](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Envelope-Intro.md#usage-of-envelopes)

