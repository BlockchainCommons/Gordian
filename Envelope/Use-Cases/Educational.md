# Gordian Envelope Use Cases: Educational & Credential Industries

Gordian Envelopes can be used in educational credential-issuing industries to encode and transmit sensitive student  information. This allows authorized parties, such as potential employers or other educational institutions, to access only the information they are authorized to view while still preserving the privacy and security of the rest of the data.

For example, a student's transcript could be encoded and transmitted using a Gordian Envelope, with portions of that data elided, to allow potential employers to verify some of the student's educational qualifications without having access to the student's full transcript or other sensitive information. Similarly, a credential such as a certification or license could be encoded and transmitted using a Gordian Envelope, to allow employers or regulators to verify the credential without having access to irrelevant details.

An Envelope's routing instructions and seals can additionally be used to verify the authenticity and provenance of a student's credentials, ensuring that they have not been tampered with. This adds an extra layer of security and trust to the information transmitted using Gordian Envelopes. 

Overall, Gordian Envelopes offer a flexible and privacy-enhancing solution for the transmission and storage of sensitive educational credential information, creating opportunities to transmit sensitive information in restrictive ways.

## Educational Use Case Table of Contents

The following set of use cases demonstrates the use of Gordian Envelopes to store educational credentials. Individual categories are presented progressively: each use case builds on the previous one by demonstrating a new capability. The first set refers to Danika Kaschak, an electrical engineer, and her official credentials. A standalone use case then focuses on the more ad-hoc credentials possible through a Web of Trust. A final set of use cases then demonstrates the distribution of educational credentials with a different priority: herd privacy.

Gordian Envelopes are useful for credentials in large part because of their ability to support advanced features such as elision, peer-based attestation, and herd privacy. They go far beyond just presenting validatable credentials to allowing the individual holders to decide what gets shown, how, and in what context. They thus add self-sovereign control to the standard rubric of Verifiable Credentials.

* [Part One: Official Credentials](Educational.md#part-one-official-credentials)
   * #1: [Danika Proves Her Worth (Credentials, Signature)](Educational.md#1-danika-proves-her-worth-credentials-signature)
   * #2: [Danika Restricts Her Revelations (Elision)](Educational.md#2-danika-restricts-her-revelations-elision)
   * #3: [Thunder & Lightning Spotlights Danika (Third-Party Repackaging)](Educational.md#3-thunder--lightning-spotlights-danika-third-party--repackaging)
* [Part Two: Web of Trust Credentials](Educational.md#part-two-web-of-trust-credentials)
   * #4: [Omar Offers an Open Badge (Web of Trust Credentials)](Educational.md#4-omar-offers-an-open-badge-web-of-trust-credentials)
* [Part Three: Herd Privacy Credentials](Educational.md#part-three-herd-privacy-credentials)
   * #5: [Paul Private Proves Proficiency (Herd Privacy)](Educational.md#5-paul-privately-proves-proficiency-herd-privacy)
   * #6: [Paul Proves His Proficiency with Improved Privacy (Herd Privacy with Non-Correlation)](Educational.md#6-paul-proves-proficiency-with-improved-privacy-herd-privacy-with-non-correlation)
   * #7: [Burton Bank Avoids Toxicity (Herd Privacy with Selective Correlation)](Educational.md#7-burton-bank-avoids-toxicity-herd-privacy-with-selective-correlation)
 
_The Danika Kaschak examples in #1 through #3 are drawn directly from [07-Elision-Example](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/7-VC-ELISION-EXAMPLE.md), one of the documents for the [Envelope-CLI app](https://github.com/BlockchainCommons/envelope-cli-swift). The Burton Bank example is drawn from a use case in a [Selective Disclosure white paper](https://github.com/WebOfTrustInfo/rwot11-the-hague/blob/master/draft-documents/selective-correlation.md) in process from Rebooting the Web of Trust XI._

## Part One: Official Credentials

This first set of use cases demonstrates how to create (and sign) simple credentials, how the subject can elide data, how another holder can elide data, and how additional parties can add data and even new signatures to a credential.

### #1. Danika Proves Her Worth (Credentials, Signature)

> _Problem Solved:_ Danika needs to be able to prove her credentials as an electrical engineer without depending on a centralized authority.

Danika is a credentialed electrical engineer who maintains her certification through continuing education. In past years she would have listed her credentials and then potential employers would have had to go to the certification board to verify them. This was ideal for no one, because most employers didn't check certifications (leaving them vulnerable), and if they did, the check was beholden to the certification board, who might fail to verify valid credentials for any number of reasons.

Enter the new world of digital credentials. The certification board can now produce a signed version of Danika's credentials that lists all of her professional development and continuing employment using a Gordian Envelope. There's no need to contact the cerification board afterward because Danika can produce the credential and it can be validated by compared the signature to the board's public key, stored in Public Key Infrastructure (PKI). Danika can also prove that the credential belongs to her by signing something with the private key linked to the public key stored in the Envelope.

To create the credential, Danika submits information to the Electrical Engineering Board listing her experience:

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
The certification board validates the information submitted by Danika, and then wraps the Envelope and signs it before returning it to Danika. This is what gives the Envelope its power. Because it's signed, no one now needs to contact the board (as long as their public key is indeed stored in a PKI, or at some other well-known site, to allow for validation).
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
To make the validation process easier, additional hints for public-key look up could have been added, though a validator would have then needed to assess whether that information was itself valid or not.

### #2. Danika Restricts Her Revelations (Elision)

> _Problem Solved:_ Danika wants to avoid prejudice when using her credentials in job applications.

Danika is very confident in her prowess as an electrical engineer, but she fears prejudice when she seeks employment. Primarily, she is concerned about prejudice over her Eastern Europe name, but she also fears prejudice over the recent date of her certification. As a result, she wants to elide (omit) that information in her credential, as well as other details that she considers irrelevent to her application.

Gordian Envelope gives any holder of a credential the ability to elide information from a credential. Danika simply needs to use an application such as `envelope-cli` that removes specific content. Gordian Envelope is designed so that this removal of information doesn't affect any of the digital hashes within the Envelope. As a result, the signature on the Envelope remains valid. Danika can still present the information and someone examining it can then assess the remaining information and verify that it's been signed, in this case by the certification board.

When Danika elides her envelope, it shows that information has been removed:
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
After submitting her credentials, Danika supplements them with excellent scores in a third-party proctored test (producing another credential) and is hired by Thunder & Lightning Inc.

## 3. Thunder & Lightning Spotlights Danika (Third-Party  Repackaging)

> _Problem Solved:_ Thunder & Lightning Inc. needs to repackage Danika's credentials for their customers.

Thunder & Lightning Inc. is ready to send Danika to a job site! To do so they must both reveal and affirm her credentials to the job-site supervisors. Even though they are neither the issuer nor the subject of Danika's educational credentials, Thunder & Lightning is able to produce their own version of those credentials based on the copy of the Gordian Envelope that they hold.

They want Danika's name in the credentials, so they must ask her for a copy of the credentials containing that information, but then they elide the rest of the information just like she did, using an application such as `envelope-cli`. This is one of the strengths of Gordian Envelope: each party who holds the Envelope (or even an already-elided form of the Envelope) can choose how to further elide it to match their own requirements and their own risk models.

But a holder can do more than that: they can also add information. In this case, Thunder & Lightning wants to add details about Danika's work with them. They can do so by wrapping the original, signed information, adding content, and then putting another signature on top of that. The original certification information remains verified by the certification board, and the new employment information is verified by Thunder & Lightning.

Thunder & Lightning's elided version of Danika's certification reveals slightly different information than the previous version:
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
Thunder & Lightning Inc. wraps that envelope (to preserve the original signature) and then adds additional data on Danika's work with them:
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

In case the hashes have gotten too small to read, here's a look at the three stages of this use case using the `--tree` function from `envelope-cli`:

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

Jonathan has been doing technical writing on blockchains for a few years and wants to extend that into a freelance career. Unfortunately, most of his extant writing has been internal documents, and so he can't point potential employers to them. 

Omar, an expert in blockchain technical writing, has GitHub repos that are filled with examples of his own excellent writing, and that's led him to offer Open Badges for other people whose writing he thinks is up to spec. Omar can create a badge for Jonathan by writing a credential and signing it with his GitHub private key. Validators can then assess the validity of that peer-to-peer credential by looking at the contents of Omar's own GitHub and determining whether he has sufficient expertise to provide that credential.

After positively assessing Jonath's tech writing, Omar thus creates a credential that identifies Jonathan and certifies his expertise:
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
While creating the credential, Omar adds on information to identify himself by using a `certifiedBy` predicate that he places in the `certificate`:
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
The `githubID` is what acts as Omar's own credential. Validators can view it to decide the worth of Omar's certification, as is traditional in a web of trust. `pubkeyURL` is meant as a hint so that validators don't have to figure out where to look up the public key associated with the GitHub-ID, but obviously any validator will need to thoughtfully consider whether the hint is proper and links to the ID shown.

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

Educational credentials are usually presumed to be packaged in discrete Envelopes that identify a single user. However, some situations may benefit from conglomerating thousands of credentials in a single Envelope, giving each of those users privacy — even from the credential issuer! The following examples include a pair of progressive use cases showing how an internet user can benefit from herd privacy and then a single example demonstrating how a company can do so.

### 5. Paul Privately Proves Proficiency [Herd Privacy]

> _Problem Solved:_ Paul wants a credential, but he doesn't trust the organization giving out the credentials with his personal information!

Paul wants to get a credential showing proficiency in Gordian Envelope from Blockchain Commons, but he's a good Cypherpunk: he knows not to trust any organization. Fortunately, Blockchain Commons has privacy-protecting options.

Paul can take an online test in either Basic form (automated Q&A with a time limit) or Advanced form (Q&A with a live proctor on Zoom). He chooses the former, again for privacy reasons. After he succeeds at the test (50 out of 50, of course!), he needs to get his credential.

At this point, most credential issuers would require Paul to give up an email address and then mail them the personal credential, but Blockchain Commons' privacy preserving methodology simply requires Paul to give them a self certifying identifier or some sort (for which he presumably controls the private key). They'll then embed that identifier in a very large Envelope with the credentials of everyone who succeeded at the test that month. (Paul must wait until the Envelope is generated before he can prove anything!)

At the end of the month, Blockchain Commons will create a large Gordian Envelope that contains the identifiers of everyone who passed their test that month, with a statement as to whether each DID `isBasic` or `isAdvanced`. However, it will be largely elided to protect everyone's privacy! Paul will then be able to create a simple proof that shows he's a member of the class ... but remains relatively anonymous until he does so.

The following example shows a credential for a number of different participants. A real-life example would likely have hundreds of entries to ensure herd privacy, but that's reduced here for readability:
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
Note that each elided entry of certification still has its prior hash. All that Paul needs to do to prove participation in the class is to show that he can generate one of those hashes with his identifier. That will prove his certification!

Blockchain Commons publishes instructions for how to do so. Test takers just need to create an assertion with either the "isBasic" predicate or the "isAdvanced" predicate and their portable `ur:crypto-cid` identifier. When they hash that assertion with BLAKE3, they can then prove that the digest is part of the partially redacted list of credentials.

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
He then creates the hashed digest of that credential:
```
ur:crypto-digest/hdcxhdwnsntebthnrhzmzsjpvazttpzctlmhcwrffnlthhgdkptscsayzmcxndpdessabzjekbur
```
That's the Blake3 hash of his assertion in UR form. If converted to hex, it is:
```
58F1CDD30D60B9FFFA72E6FCD8FDD5901BBC3C875C5075D71808FF209BA839C2
```
As can be seen, that matches the third redacted hash in the Mermaid diagram above, which was the `isBasic` assertion for `ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts`.

Now, Paul can point to Blockchain Common's partially redacted tree of November 2022 certifications, reveal his CID, acknowledge that he passed the basic testing, and show his digest. Together these facts prove that his identifier is part of the tree. 

More notably, Paul can decide never to reveal his CID, in which case it is at least somewhat difficult for anyone else to prove that Paul is a member of the group. 

Mind you, because the tree is partially redacted, and because no particular attempt has been made to prevent correlation, it's possible that identifiers in the Envelope could be guessed (though someone would have to know a precise identifier to look for). There are several ways this could be prevented. They all require Blockchain Commons to provide additional information to Paul, increasing the communication requirements (and thus potentially impacting privacy), but they add strong non-correlation defenses.

1.) Blockchain Commons could choose to fully redact the Envelope, publishing only a top-level hash. They would then supply Paul with a path to his lower-level hash by partially redacting the tree when he supplied them with his CID. Paul could then prove his presence in the Envelope with his digest and that path. If that path were to be more widely released, there would be the same correlation problems, but obviously they'd be lesser because it probably would never be widely published.

2.) Alternatively, Blockchain Commons could restructure the Envelope so that every 5 or 10 or 20 CIDs were placed in a subenvelope. Their publicly published proof would only show the hashes of these subenvelopes, which will be relatively impossible to correlate. Paul would then be able to request a path to his own subenvelope. Even if this path were more widely released, there would only be a possibility of correlation for the other CIDs that happen to be in that subenvelope. (This example is shown in the next use case.)

3.) Finally, Blockchain Commons could choose to salt every CID in the Envelope. They would then have to supply Paul with his salt. (The twin limitations here are that salting everything dramatically increases the size of the Envelope and that Paul then has a piece of data that he can't lose).

### 6. Paul Proves Proficiency with Improved Privacy [Herd Privacy with Non-Correlation]

> _Problem Solved:_ Blockchain Commons wants to improve the herd privacy of its test takers by reducing correlation.

Blockchain Commons is aware of the correlation possibilities in their test-result Envelopes. They choose a middle road to dramatically reduce correlation: they store every 5 CIDs in a separate sub-Envelope. (A real-life example might instead have clumps of 10 or 20 CIDs, but again this one is reduced in size to make it manageable.) Paul will then be able to request a path to his specific envelope, which he can combine with an assertion and the published top-level hashes of the envelope to, once more, show his participation. However the published hashes, which just contain the subenvelope, are more-or-less impossible to correlate.

The envelope of certifications is bundled in a new, hierarchical manner:
```
"Blockchain Commons Certifactions #13A" [
    "certifiedBy": "Blockchain Commons" [
        "pubkeyURL": "https://www.blockchaincommons.com/certification.keys"
    ]
    "date": "11-01-2022"
    "isBundle": "13A-001" [
        "isAdvanced": "ur:crypto-cid/hdcxbetimuglwppshfqdsahsktgmnelsjnbdcanspmnshkpecxcfztlkiohgenytntmkaxjngadt"
        "isAdvanced": "ur:crypto-cid/hdcxjsdwaegrpfwmbkehhscwmshpchlnhhayadadwszcghhtmnzcgomhutcmytldfwpadmdlcwfe"
        "isAdvanced": "ur:crypto-cid/hdcxmhtnnlcshsjzhywyhgttsrgulstdwdnezesekosndnfxswzezolrfdcwlulacxeopdkghnht"
        "isBasic": "ur:crypto-cid/hdcxaepthffshppabkgydawmlftbpfrnaefzrdjehybwtskgmwveenwzntpyhdrpsfqzsgqdftnb"
        "isBasic": "ur:crypto-cid/hdcxdkmhpfathyyltnnboypsemehkimudnkgeyosgolncfmdnboypsecpsghtefzetkndpeylrfz"
    ]
    "isBundle": "13A-002" [
        "isBasic": "ur:crypto-cid/hdcxfnmdsrgdkbvekoecwevystbaztbwcshpqdbzkeatjlndlywepyctlkvwemhkiyhtenwnghda"
        "isBasic": "ur:crypto-cid/hdcxhnutcyktgtfxotvegrhllypakenlgoetmnnlimsktppkssloghpahsdeparktbkerebatyce"
        "isBasic": "ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts"
        "isBasic": "ur:crypto-cid/hdcxmnktvdgeettlfmbklytaseayoeplwynbsawdurmuuelbbsfxbbaxkkpsemjovybzswqdssva"
        "isBasic": "ur:crypto-cid/hdcxuykblalfdalsvaplrfzsoxqdvdclstmdtssfdatkmecwnsbzmseohswldaytdmsfbwaxvewp"
    ]
]
```
```mermaid
graph LR
    1(("27953cfd<br/>NODE"))
    2["88b3ff17<br/>#quot;Blockchain Commons Certifactions #13A#quot;"]
    3(["0e421d2e<br/>ASSERTION"])
    4["127a2386<br/>#quot;date#quot;"]
    5["c666f06c<br/>#quot;11-01-2022#quot;"]
    6(["12b89490<br/>ASSERTION"])
    7["2969c9d5<br/>#quot;isBundle#quot;"]
    8(("f51ac46f<br/>NODE"))
    9["c2719309<br/>#quot;13A-002#quot;"]
    10(["58f1cdd3<br/>ASSERTION"])
    11["2100a83d<br/>#quot;isBasic#quot;"]
    12["478112c2<br/>#quot;ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts#quot;"]
    13(["5b278116<br/>ASSERTION"])
    14["2100a83d<br/>#quot;isBasic#quot;"]
    15["262db130<br/>#quot;ur:crypto-cid/hdcxhnutcyktgtfxotvegrhllypakenlgoetmnnlimsktppkssloghpahsdeparktbkerebatyce#quot;"]
    16(["92f71067<br/>ASSERTION"])
    17["2100a83d<br/>#quot;isBasic#quot;"]
    18["37a1d85a<br/>#quot;ur:crypto-cid/hdcxfnmdsrgdkbvekoecwevystbaztbwcshpqdbzkeatjlndlywepyctlkvwemhkiyhtenwnghda#quot;"]
    19(["c2f3fe78<br/>ASSERTION"])
    20["2100a83d<br/>#quot;isBasic#quot;"]
    21["950f78c1<br/>#quot;ur:crypto-cid/hdcxuykblalfdalsvaplrfzsoxqdvdclstmdtssfdatkmecwnsbzmseohswldaytdmsfbwaxvewp#quot;"]
    22(["c3bd8189<br/>ASSERTION"])
    23["2100a83d<br/>#quot;isBasic#quot;"]
    24["a3c3105c<br/>#quot;ur:crypto-cid/hdcxmnktvdgeettlfmbklytaseayoeplwynbsawdurmuuelbbsfxbbaxkkpsemjovybzswqdssva#quot;"]
    25(["64e8fe1e<br/>ASSERTION"])
    26["7eb11472<br/>#quot;certifiedBy#quot;"]
    27(("55378d51<br/>NODE"))
    28["8ae1d503<br/>#quot;Blockchain Commons#quot;"]
    29(["b0a1cbca<br/>ASSERTION"])
    30["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    31["04d0d649<br/>#quot;https://www.blockchaincommons.com/certification.keys#quot;"]
    32(["bf0d2ed8<br/>ASSERTION"])
    33["2969c9d5<br/>#quot;isBundle#quot;"]
    34(("e60bed3c<br/>NODE"))
    35["6ded4d4c<br/>#quot;13A-001#quot;"]
    36(["0d31bdce<br/>ASSERTION"])
    37["2100a83d<br/>#quot;isBasic#quot;"]
    38["03e7479a<br/>#quot;ur:crypto-cid/hdcxdkmhpfathyyltnnboypsemehkimudnkgeyosgolncfmdnboypsecpsghtefzetkndpeylrfz#quot;"]
    39(["336f50d3<br/>ASSERTION"])
    40["d68d0704<br/>#quot;isAdvanced#quot;"]
    41["9fb97d91<br/>#quot;ur:crypto-cid/hdcxjsdwaegrpfwmbkehhscwmshpchlnhhayadadwszcghhtmnzcgomhutcmytldfwpadmdlcwfe#quot;"]
    42(["b22278f9<br/>ASSERTION"])
    43["d68d0704<br/>#quot;isAdvanced#quot;"]
    44["3410120d<br/>#quot;ur:crypto-cid/hdcxmhtnnlcshsjzhywyhgttsrgulstdwdnezesekosndnfxswzezolrfdcwlulacxeopdkghnht#quot;"]
    45(["ca13e82f<br/>ASSERTION"])
    46["2100a83d<br/>#quot;isBasic#quot;"]
    47["eb9d612b<br/>#quot;ur:crypto-cid/hdcxaepthffshppabkgydawmlftbpfrnaefzrdjehybwtskgmwveenwzntpyhdrpsfqzsgqdftnb#quot;"]
    48(["e67d3bb2<br/>ASSERTION"])
    49["d68d0704<br/>#quot;isAdvanced#quot;"]
    50["a285aabe<br/>#quot;ur:crypto-cid/hdcxbetimuglwppshfqdsahsktgmnelsjnbdcanspmnshkpecxcfztlkiohgenytntmkaxjngadt#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    8 -->|subj| 9
    8 --> 10
    10 -->|pred| 11
    10 -->|obj| 12
    8 --> 13
    13 -->|pred| 14
    13 -->|obj| 15
    8 --> 16
    16 -->|pred| 17
    16 -->|obj| 18
    8 --> 19
    19 -->|pred| 20
    19 -->|obj| 21
    8 --> 22
    22 -->|pred| 23
    22 -->|obj| 24
    1 --> 25
    25 -->|pred| 26
    25 -->|obj| 27
    27 -->|subj| 28
    27 --> 29
    29 -->|pred| 30
    29 -->|obj| 31
    1 --> 32
    32 -->|pred| 33
    32 -->|obj| 34
    34 -->|subj| 35
    34 --> 36
    36 -->|pred| 37
    36 -->|obj| 38
    34 --> 39
    39 -->|pred| 40
    39 -->|obj| 41
    34 --> 42
    42 -->|pred| 43
    42 -->|obj| 44
    34 --> 45
    45 -->|pred| 46
    45 -->|obj| 47
    34 --> 48
    48 -->|pred| 49
    48 -->|obj| 50
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:red,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:red,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    style 16 stroke:red,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
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
    style 44 stroke:#55f,stroke-width:3.0px
    style 45 stroke:red,stroke-width:3.0px
    style 46 stroke:#55f,stroke-width:3.0px
    style 47 stroke:#55f,stroke-width:3.0px
    style 48 stroke:red,stroke-width:3.0px
    style 49 stroke:#55f,stroke-width:3.0px
    style 50 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
    linkStyle 7 stroke:red,stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke:green,stroke-width:2.0px
    linkStyle 10 stroke:#55f,stroke-width:2.0px
    linkStyle 11 stroke-width:2.0px
    linkStyle 12 stroke:green,stroke-width:2.0px
    linkStyle 13 stroke:#55f,stroke-width:2.0px
    linkStyle 14 stroke-width:2.0px
    linkStyle 15 stroke:green,stroke-width:2.0px
    linkStyle 16 stroke:#55f,stroke-width:2.0px
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
    linkStyle 43 stroke-width:2.0px
    linkStyle 44 stroke:green,stroke-width:2.0px
    linkStyle 45 stroke:#55f,stroke-width:2.0px
    linkStyle 46 stroke-width:2.0px
    linkStyle 47 stroke:green,stroke-width:2.0px
    linkStyle 48 stroke:#55f,stroke-width:2.0px
```
Of course, it must still be signed. (This example uses a different signing key primarily because the former example key was no longer available due to a reboot resetting shell variables; practice #SmartCustody & keep your keys safe!)
```
{
    "Blockchain Commons Certifactions #13A" [
        "certifiedBy": "Blockchain Commons" [
            "pubkeyURL": "https://www.blockchaincommons.com/certification.keys"
        ]
        "date": "11-01-2022"
        "isBundle": "13A-001" [
            "isAdvanced": "ur:crypto-cid/hdcxbetimuglwppshfqdsahsktgmnelsjnbdcanspmnshkpecxcfztlkiohgenytntmkaxjngadt"
            "isAdvanced": "ur:crypto-cid/hdcxjsdwaegrpfwmbkehhscwmshpchlnhhayadadwszcghhtmnzcgomhutcmytldfwpadmdlcwfe"
            "isAdvanced": "ur:crypto-cid/hdcxmhtnnlcshsjzhywyhgttsrgulstdwdnezesekosndnfxswzezolrfdcwlulacxeopdkghnht"
            "isBasic": "ur:crypto-cid/hdcxaepthffshppabkgydawmlftbpfrnaefzrdjehybwtskgmwveenwzntpyhdrpsfqzsgqdftnb"
            "isBasic": "ur:crypto-cid/hdcxdkmhpfathyyltnnboypsemehkimudnkgeyosgolncfmdnboypsecpsghtefzetkndpeylrfz"
        ]
        "isBundle": "13A-002" [
            "isBasic": "ur:crypto-cid/hdcxfnmdsrgdkbvekoecwevystbaztbwcshpqdbzkeatjlndlywepyctlkvwemhkiyhtenwnghda"
            "isBasic": "ur:crypto-cid/hdcxhnutcyktgtfxotvegrhllypakenlgoetmnnlimsktppkssloghpahsdeparktbkerebatyce"
            "isBasic": "ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts"
            "isBasic": "ur:crypto-cid/hdcxmnktvdgeettlfmbklytaseayoeplwynbsawdurmuuelbbsfxbbaxkkpsemjovybzswqdssva"
            "isBasic": "ur:crypto-cid/hdcxuykblalfdalsvaplrfzsoxqdvdclstmdtssfdatkmecwnsbzmseohswldaytdmsfbwaxvewp"
        ]
    ]
} [
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("63be8b49<br/>NODE"))
    2[/"c5b7e587<br/>WRAPPED"\]
    3(("27953cfd<br/>NODE"))
    4["88b3ff17<br/>#quot;Blockchain Commons Certifactions #13A#quot;"]
    5(["0e421d2e<br/>ASSERTION"])
    6["127a2386<br/>#quot;date#quot;"]
    7["c666f06c<br/>#quot;11-01-2022#quot;"]
    8(["12b89490<br/>ASSERTION"])
    9["2969c9d5<br/>#quot;isBundle#quot;"]
    10(("f51ac46f<br/>NODE"))
    11["c2719309<br/>#quot;13A-002#quot;"]
    12(["58f1cdd3<br/>ASSERTION"])
    13["2100a83d<br/>#quot;isBasic#quot;"]
    14["478112c2<br/>#quot;ur:crypto-cid/hdcxiadtuowtsrynlfbslgplynrlonpfbaeolkbzztsngtasjpenwmdevojsgmplishhurkebnts#quot;"]
    15(["5b278116<br/>ASSERTION"])
    16["2100a83d<br/>#quot;isBasic#quot;"]
    17["262db130<br/>#quot;ur:crypto-cid/hdcxhnutcyktgtfxotvegrhllypakenlgoetmnnlimsktppkssloghpahsdeparktbkerebatyce#quot;"]
    18(["92f71067<br/>ASSERTION"])
    19["2100a83d<br/>#quot;isBasic#quot;"]
    20["37a1d85a<br/>#quot;ur:crypto-cid/hdcxfnmdsrgdkbvekoecwevystbaztbwcshpqdbzkeatjlndlywepyctlkvwemhkiyhtenwnghda#quot;"]
    21(["c2f3fe78<br/>ASSERTION"])
    22["2100a83d<br/>#quot;isBasic#quot;"]
    23["950f78c1<br/>#quot;ur:crypto-cid/hdcxuykblalfdalsvaplrfzsoxqdvdclstmdtssfdatkmecwnsbzmseohswldaytdmsfbwaxvewp#quot;"]
    24(["c3bd8189<br/>ASSERTION"])
    25["2100a83d<br/>#quot;isBasic#quot;"]
    26["a3c3105c<br/>#quot;ur:crypto-cid/hdcxmnktvdgeettlfmbklytaseayoeplwynbsawdurmuuelbbsfxbbaxkkpsemjovybzswqdssva#quot;"]
    27(["64e8fe1e<br/>ASSERTION"])
    28["7eb11472<br/>#quot;certifiedBy#quot;"]
    29(("55378d51<br/>NODE"))
    30["8ae1d503<br/>#quot;Blockchain Commons#quot;"]
    31(["b0a1cbca<br/>ASSERTION"])
    32["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    33["04d0d649<br/>#quot;https://www.blockchaincommons.com/certification.keys#quot;"]
    34(["bf0d2ed8<br/>ASSERTION"])
    35["2969c9d5<br/>#quot;isBundle#quot;"]
    36(("e60bed3c<br/>NODE"))
    37["6ded4d4c<br/>#quot;13A-001#quot;"]
    38(["0d31bdce<br/>ASSERTION"])
    39["2100a83d<br/>#quot;isBasic#quot;"]
    40["03e7479a<br/>#quot;ur:crypto-cid/hdcxdkmhpfathyyltnnboypsemehkimudnkgeyosgolncfmdnboypsecpsghtefzetkndpeylrfz#quot;"]
    41(["336f50d3<br/>ASSERTION"])
    42["d68d0704<br/>#quot;isAdvanced#quot;"]
    43["9fb97d91<br/>#quot;ur:crypto-cid/hdcxjsdwaegrpfwmbkehhscwmshpchlnhhayadadwszcghhtmnzcgomhutcmytldfwpadmdlcwfe#quot;"]
    44(["b22278f9<br/>ASSERTION"])
    45["d68d0704<br/>#quot;isAdvanced#quot;"]
    46["3410120d<br/>#quot;ur:crypto-cid/hdcxmhtnnlcshsjzhywyhgttsrgulstdwdnezesekosndnfxswzezolrfdcwlulacxeopdkghnht#quot;"]
    47(["ca13e82f<br/>ASSERTION"])
    48["2100a83d<br/>#quot;isBasic#quot;"]
    49["eb9d612b<br/>#quot;ur:crypto-cid/hdcxaepthffshppabkgydawmlftbpfrnaefzrdjehybwtskgmwveenwzntpyhdrpsfqzsgqdftnb#quot;"]
    50(["e67d3bb2<br/>ASSERTION"])
    51["d68d0704<br/>#quot;isAdvanced#quot;"]
    52["a285aabe<br/>#quot;ur:crypto-cid/hdcxbetimuglwppshfqdsahsktgmnelsjnbdcanspmnshkpecxcfztlkiohgenytntmkaxjngadt#quot;"]
    53(["90f9cd74<br/>ASSERTION"])
    54[/"d59f8c0f<br/>verifiedBy"/]
    55["b9f2cc21<br/>Signature"]
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
    10 --> 15
    15 -->|pred| 16
    15 -->|obj| 17
    10 --> 18
    18 -->|pred| 19
    18 -->|obj| 20
    10 --> 21
    21 -->|pred| 22
    21 -->|obj| 23
    10 --> 24
    24 -->|pred| 25
    24 -->|obj| 26
    3 --> 27
    27 -->|pred| 28
    27 -->|obj| 29
    29 -->|subj| 30
    29 --> 31
    31 -->|pred| 32
    31 -->|obj| 33
    3 --> 34
    34 -->|pred| 35
    34 -->|obj| 36
    36 -->|subj| 37
    36 --> 38
    38 -->|pred| 39
    38 -->|obj| 40
    36 --> 41
    41 -->|pred| 42
    41 -->|obj| 43
    36 --> 44
    44 -->|pred| 45
    44 -->|obj| 46
    36 --> 47
    47 -->|pred| 48
    47 -->|obj| 49
    36 --> 50
    50 -->|pred| 51
    50 -->|obj| 52
    1 --> 53
    53 -->|pred| 54
    53 -->|obj| 55
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
    style 29 stroke:red,stroke-width:3.0px
    style 30 stroke:#55f,stroke-width:3.0px
    style 31 stroke:red,stroke-width:3.0px
    style 32 stroke:#55f,stroke-width:3.0px
    style 33 stroke:#55f,stroke-width:3.0px
    style 34 stroke:red,stroke-width:3.0px
    style 35 stroke:#55f,stroke-width:3.0px
    style 36 stroke:red,stroke-width:3.0px
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
    style 53 stroke:red,stroke-width:3.0px
    style 54 stroke:#55f,stroke-width:3.0px
    style 55 stroke:#55f,stroke-width:3.0px
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
    linkStyle 28 stroke:red,stroke-width:2.0px
    linkStyle 29 stroke-width:2.0px
    linkStyle 30 stroke:green,stroke-width:2.0px
    linkStyle 31 stroke:#55f,stroke-width:2.0px
    linkStyle 32 stroke-width:2.0px
    linkStyle 33 stroke:green,stroke-width:2.0px
    linkStyle 34 stroke:#55f,stroke-width:2.0px
    linkStyle 35 stroke:red,stroke-width:2.0px
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
    linkStyle 51 stroke-width:2.0px
    linkStyle 52 stroke:green,stroke-width:2.0px
    linkStyle 53 stroke:#55f,stroke-width:2.0px
```
As before, Blockchain Commons publishes a partially elided Envelope with the foundational information about the test results.
```
{
    "Blockchain Commons Certifactions #13A" [
        "certifiedBy": "Blockchain Commons" [
            "pubkeyURL": "https://www.blockchaincommons.com/certification.keys"
        ]
        "date": "11-01-2022"
        ELIDED (2)
    ]
} [
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("a356dca2<br/>NODE"))
    2[/"c5b7e587<br/>WRAPPED"\]
    3(("27953cfd<br/>NODE"))
    4["88b3ff17<br/>#quot;Blockchain Commons Certifactions #13A#quot;"]
    5(["0e421d2e<br/>ASSERTION"])
    6["127a2386<br/>#quot;date#quot;"]
    7["c666f06c<br/>#quot;11-01-2022#quot;"]
    8{{"12b89490<br/>ELIDED"}}
    9(["64e8fe1e<br/>ASSERTION"])
    10["7eb11472<br/>#quot;certifiedBy#quot;"]
    11(("55378d51<br/>NODE"))
    12["8ae1d503<br/>#quot;Blockchain Commons#quot;"]
    13(["b0a1cbca<br/>ASSERTION"])
    14["29c0cd61<br/>#quot;pubkeyURL#quot;"]
    15["04d0d649<br/>#quot;https://www.blockchaincommons.com/certification.keys#quot;"]
    16{{"bf0d2ed8<br/>ELIDED"}}
    17(["59ab0d7d<br/>ASSERTION"])
    18[/"d59f8c0f<br/>verifiedBy"/]
    19["76510b9f<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    5 -->|pred| 6
    5 -->|obj| 7
    3 --> 8
    3 --> 9
    9 -->|pred| 10
    9 -->|obj| 11
    11 -->|subj| 12
    11 --> 13
    13 -->|pred| 14
    13 -->|obj| 15
    3 --> 16
    1 --> 17
    17 -->|pred| 18
    17 -->|obj| 19
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:red,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    style 16 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 17 stroke:red,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
    style 19 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
    linkStyle 5 stroke:#55f,stroke-width:2.0px
    linkStyle 6 stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke:green,stroke-width:2.0px
    linkStyle 9 stroke:#55f,stroke-width:2.0px
    linkStyle 10 stroke:red,stroke-width:2.0px
    linkStyle 11 stroke-width:2.0px
    linkStyle 12 stroke:green,stroke-width:2.0px
    linkStyle 13 stroke:#55f,stroke-width:2.0px
    linkStyle 14 stroke-width:2.0px
    linkStyle 15 stroke-width:2.0px
    linkStyle 16 stroke:green,stroke-width:2.0px
    linkStyle 17 stroke:#55f,stroke-width:2.0px
```
This time there's effectively zero chance of correlation because the two remaining `ELIDED` elements each contain several (5) identifiers, drawn from the set of all identifiers. There's no practical way to figure out what is in each bundle.

In order to prove his participation, Paul creates an assertion, just like before:
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
However, due to the fact that the contents of the bundles of identifiers remain hidden, that's not enough. Paul needs to hand his assertion to Blockchain Commons, and then they need to send back a proof that reveals just enough of the Envelope structure to open up the bundle that contains his identifier. Though this is more back-and-forth than in the previous Use Case, it can still be done in a privacy preserving way, such as Paul requesting the Proof over a Tor connection.

Here's what the proof looks like. 
```
{
    ELIDED [
        ELIDED: ELIDED [
            ELIDED (5)
        ]
        ELIDED (3)
    ]
} [
    ELIDED
]
```
```mermaid
graph LR
    1(("a356dca2<br/>NODE"))
    2[/"c5b7e587<br/>WRAPPED"\]
    3(("27953cfd<br/>NODE"))
    4{{"88b3ff17<br/>ELIDED"}}
    5{{"0e421d2e<br/>ELIDED"}}
    6(["12b89490<br/>ASSERTION"])
    7{{"2969c9d5<br/>ELIDED"}}
    8(("f51ac46f<br/>NODE"))
    9{{"c2719309<br/>ELIDED"}}
    10{{"58f1cdd3<br/>ELIDED"}}
    11{{"5b278116<br/>ELIDED"}}
    12{{"92f71067<br/>ELIDED"}}
    13{{"c2f3fe78<br/>ELIDED"}}
    14{{"c3bd8189<br/>ELIDED"}}
    15{{"64e8fe1e<br/>ELIDED"}}
    16{{"bf0d2ed8<br/>ELIDED"}}
    17{{"59ab0d7d<br/>ELIDED"}}
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    3 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    8 -->|subj| 9
    8 --> 10
    8 --> 11
    8 --> 12
    8 --> 13
    8 --> 14
    3 --> 15
    3 --> 16
    1 --> 17
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 5 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 8 stroke:red,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 10 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 11 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 12 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 13 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 14 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 15 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 16 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 17 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke:green,stroke-width:2.0px
    linkStyle 6 stroke:#55f,stroke-width:2.0px
    linkStyle 7 stroke:red,stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke-width:2.0px
    linkStyle 10 stroke-width:2.0px
    linkStyle 11 stroke-width:2.0px
    linkStyle 12 stroke-width:2.0px
    linkStyle 13 stroke-width:2.0px
    linkStyle 14 stroke-width:2.0px
    linkStyle 15 stroke-width:2.0px
```
A proof is the minimum path needed to reveal the hash that a user requires to demonstrate the existence of his assertion. As can be seen, one of the bundles (`f51ac46f`) has now been opened up. That reveals Paul's hash (`58F1CDD3`). 

To prove his inclusion, Paul would now have to reveal his assertion digest, the "proof" from Blockchain Commons, and the original publication from Blockchain Commons.

Through this methodology, the possibility of correlation is much reduced. The proof is the only thing that contains a hash that could theoretically be correlated if someone knew what to look for. They're not meant to be published, which greatly reduces their danger, but even if they were, only the other DIDs in the same bundle are subject to potential correlation. (Salted assertions still offer better correlation protection, but as noted previously, only at a cost in space, complexity, and required secrets. The bundled assertions of this example offer an excellent middle ground.)

### 7. Burton Bank Avoids Toxicity (Herd Privacy with Selective Correlation)

> _Problem Solved:_ Burton Bank needs to verify the success of its student loans without acquiring toxic data while doing so!

Personal data can be toxic! It can be a major liability for companies holding the data, especially in an age where online data breaches are becoming increasingly common and where laws such the GDPR and the CCPA are providing increasing protections to users (while simultaneously punishing companies who do not successfully protect user information).

Despite that, companies still need to work with personal information, and that's the case for Burton Bank. They fund student loans based on government backing, and as a result they have to follow a variety of regulations. One of them states that they may only offer funds to educational institutes whose loan holders maintain an 80% graduation rate within two years for professional schools and within four years for colleges. As a result, Burton Bank needs to receive information on the graduation of its loan holders, but this can be tricky as they sometimes buy loans from other banks or sell them to other banks: no one but Burton knows what loans they hold!

Acme Professional School thus prepares a general report on graduation for all of their students three times a year. To protect the recipients, they elide it so that no toxic data is transmitted. Burton Bank can then selectively correlate the elided data using the personal data they already have on hand, but without accepting any new responsibility for the data of students not associated with the bank!

Acme's yearly report lists the identifiers for their students, plus enough additional information to allow verification, all signed by Acme.
```
{
    "Acme Professional School 2022-12-24 Graduation" [
        "freedoniaID": "fasa-marx-1" [
            "dateOfBirth": "2002-12-06"
            "lastName": "Elsher"
        ]
        "socialSecurity": "000345678" [
            "dateOfBirth": "2001-07-04"
            "lastName": "Hansley"
        ]
        "socialSecurity": "078051120" [
            "dateOfBirth": "1984-03-21"
            "lastName": "Dawson"
        ]
        "socialSecurity": "123004567" [
            "dateOfBirth": "1999-12-31"
            "lastName": "Hayes"
        ]
        "socialSecurity": "123456789" [
            "dateOfBirth": "2004-02-29"
            "lastName": "Gray"
        ]
        "socialSecurity": "567890000" [
            "dateOfBirth": "2002-06-06"
            "lastName": "Wang"
        ]
        "socialSecurity": "666786543" [
            "dateOfBirth": "2001-10-31"
            "lastName": "Liu"
        ]
        "wakandaID": "W6368616420626f73656d616e" [
            "dateOfBirth": "1997-08-28"
            "lastName": "Challa"
        ]
    ]
} [
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("38e3f10e<br/>NODE"))
    2[/"6d68c797<br/>WRAPPED"\]
    3(("441bc0d3<br/>NODE"))
    4["1c42df20<br/>#quot;Acme Professional School 2022-12-24 Graduation#quot;"]
    5(["0fbe062c<br/>ASSERTION"])
    6["32f06bb1<br/>#quot;socialSecurity#quot;"]
    7(("68b165ed<br/>NODE"))
    8["3e7d4a32<br/>#quot;123456789#quot;"]
    9(["0d206284<br/>ASSERTION"])
    10["eb62836d<br/>#quot;lastName#quot;"]
    11["c8027fab<br/>#quot;Gray#quot;"]
    12(["e3ff7458<br/>ASSERTION"])
    13["06d2aaa3<br/>#quot;dateOfBirth#quot;"]
    14["c246b6c0<br/>#quot;2004-02-29#quot;"]
    15(["1a9d204c<br/>ASSERTION"])
    16["32f06bb1<br/>#quot;socialSecurity#quot;"]
    17(("db478b2f<br/>NODE"))
    18["71734aec<br/>#quot;666786543#quot;"]
    19(["71acbb68<br/>ASSERTION"])
    20["06d2aaa3<br/>#quot;dateOfBirth#quot;"]
    21["18886fb7<br/>#quot;2001-10-31#quot;"]
    22(["94f521bc<br/>ASSERTION"])
    23["eb62836d<br/>#quot;lastName#quot;"]
    24["a4304222<br/>#quot;Liu#quot;"]
    25(["1ccceace<br/>ASSERTION"])
    26["32f06bb1<br/>#quot;socialSecurity#quot;"]
    27(("2df44dd7<br/>NODE"))
    28["d436d93f<br/>#quot;078051120#quot;"]
    29(["19436235<br/>ASSERTION"])
    30["eb62836d<br/>#quot;lastName#quot;"]
    31["b0c5165e<br/>#quot;Dawson#quot;"]
    32(["dcd91ac9<br/>ASSERTION"])
    33["06d2aaa3<br/>#quot;dateOfBirth#quot;"]
    34["3b23c99a<br/>#quot;1984-03-21#quot;"]
    35(["301cb6f4<br/>ASSERTION"])
    36["0308a0ff<br/>#quot;wakandaID#quot;"]
    37(("986dfa41<br/>NODE"))
    38["a9d35651<br/>#quot;W6368616420626f73656d616e#quot;"]
    39(["4a7c4b11<br/>ASSERTION"])
    40["eb62836d<br/>#quot;lastName#quot;"]
    41["12184656<br/>#quot;Challa#quot;"]
    42(["4ef16b62<br/>ASSERTION"])
    43["06d2aaa3<br/>#quot;dateOfBirth#quot;"]
    44["e1636bfc<br/>#quot;1997-08-28#quot;"]
    45(["40e63258<br/>ASSERTION"])
    46["32f06bb1<br/>#quot;socialSecurity#quot;"]
    47(("40221b32<br/>NODE"))
    48["0e5442a4<br/>#quot;123004567#quot;"]
    49(["491aa1a4<br/>ASSERTION"])
    50["eb62836d<br/>#quot;lastName#quot;"]
    51["2168c1a1<br/>#quot;Hayes#quot;"]
    52(["f9436c96<br/>ASSERTION"])
    53["06d2aaa3<br/>#quot;dateOfBirth#quot;"]
    54["aa912b0c<br/>#quot;1999-12-31#quot;"]
    55(["8136bd53<br/>ASSERTION"])
    56["32f06bb1<br/>#quot;socialSecurity#quot;"]
    57(("a21cb4f5<br/>NODE"))
    58["c1e8e7c4<br/>#quot;000345678#quot;"]
    59(["4b5e029d<br/>ASSERTION"])
    60["06d2aaa3<br/>#quot;dateOfBirth#quot;"]
    61["1da89ba1<br/>#quot;2001-07-04#quot;"]
    62(["b0716075<br/>ASSERTION"])
    63["eb62836d<br/>#quot;lastName#quot;"]
    64["c658c290<br/>#quot;Hansley#quot;"]
    65(["df10fd36<br/>ASSERTION"])
    66["32f06bb1<br/>#quot;socialSecurity#quot;"]
    67(("8222c8ae<br/>NODE"))
    68["40d32d37<br/>#quot;567890000#quot;"]
    69(["07d1947b<br/>ASSERTION"])
    70["eb62836d<br/>#quot;lastName#quot;"]
    71["8e45fffa<br/>#quot;Wang#quot;"]
    72(["169cfb83<br/>ASSERTION"])
    73["06d2aaa3<br/>#quot;dateOfBirth#quot;"]
    74["901adfac<br/>#quot;2002-06-06#quot;"]
    75(["e79e2110<br/>ASSERTION"])
    76["a16163df<br/>#quot;freedoniaID#quot;"]
    77(("6bcbca2d<br/>NODE"))
    78["a4465da4<br/>#quot;fasa-marx-1#quot;"]
    79(["1852d5ed<br/>ASSERTION"])
    80["eb62836d<br/>#quot;lastName#quot;"]
    81["dd94ae7a<br/>#quot;Elsher#quot;"]
    82(["ba154096<br/>ASSERTION"])
    83["06d2aaa3<br/>#quot;dateOfBirth#quot;"]
    84["93eda65a<br/>#quot;2002-12-06#quot;"]
    85(["42815a8c<br/>ASSERTION"])
    86[/"d59f8c0f<br/>verifiedBy"/]
    87["0376c2bc<br/>Signature"]
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
    17 --> 22
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
    3 --> 35
    35 -->|pred| 36
    35 -->|obj| 37
    37 -->|subj| 38
    37 --> 39
    39 -->|pred| 40
    39 -->|obj| 41
    37 --> 42
    42 -->|pred| 43
    42 -->|obj| 44
    3 --> 45
    45 -->|pred| 46
    45 -->|obj| 47
    47 -->|subj| 48
    47 --> 49
    49 -->|pred| 50
    49 -->|obj| 51
    47 --> 52
    52 -->|pred| 53
    52 -->|obj| 54
    3 --> 55
    55 -->|pred| 56
    55 -->|obj| 57
    57 -->|subj| 58
    57 --> 59
    59 -->|pred| 60
    59 -->|obj| 61
    57 --> 62
    62 -->|pred| 63
    62 -->|obj| 64
    3 --> 65
    65 -->|pred| 66
    65 -->|obj| 67
    67 -->|subj| 68
    67 --> 69
    69 -->|pred| 70
    69 -->|obj| 71
    67 --> 72
    72 -->|pred| 73
    72 -->|obj| 74
    3 --> 75
    75 -->|pred| 76
    75 -->|obj| 77
    77 -->|subj| 78
    77 --> 79
    79 -->|pred| 80
    79 -->|obj| 81
    77 --> 82
    82 -->|pred| 83
    82 -->|obj| 84
    1 --> 85
    85 -->|pred| 86
    85 -->|obj| 87
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
    style 37 stroke:red,stroke-width:3.0px
    style 38 stroke:#55f,stroke-width:3.0px
    style 39 stroke:red,stroke-width:3.0px
    style 40 stroke:#55f,stroke-width:3.0px
    style 41 stroke:#55f,stroke-width:3.0px
    style 42 stroke:red,stroke-width:3.0px
    style 43 stroke:#55f,stroke-width:3.0px
    style 44 stroke:#55f,stroke-width:3.0px
    style 45 stroke:red,stroke-width:3.0px
    style 46 stroke:#55f,stroke-width:3.0px
    style 47 stroke:red,stroke-width:3.0px
    style 48 stroke:#55f,stroke-width:3.0px
    style 49 stroke:red,stroke-width:3.0px
    style 50 stroke:#55f,stroke-width:3.0px
    style 51 stroke:#55f,stroke-width:3.0px
    style 52 stroke:red,stroke-width:3.0px
    style 53 stroke:#55f,stroke-width:3.0px
    style 54 stroke:#55f,stroke-width:3.0px
    style 55 stroke:red,stroke-width:3.0px
    style 56 stroke:#55f,stroke-width:3.0px
    style 57 stroke:red,stroke-width:3.0px
    style 58 stroke:#55f,stroke-width:3.0px
    style 59 stroke:red,stroke-width:3.0px
    style 60 stroke:#55f,stroke-width:3.0px
    style 61 stroke:#55f,stroke-width:3.0px
    style 62 stroke:red,stroke-width:3.0px
    style 63 stroke:#55f,stroke-width:3.0px
    style 64 stroke:#55f,stroke-width:3.0px
    style 65 stroke:red,stroke-width:3.0px
    style 66 stroke:#55f,stroke-width:3.0px
    style 67 stroke:red,stroke-width:3.0px
    style 68 stroke:#55f,stroke-width:3.0px
    style 69 stroke:red,stroke-width:3.0px
    style 70 stroke:#55f,stroke-width:3.0px
    style 71 stroke:#55f,stroke-width:3.0px
    style 72 stroke:red,stroke-width:3.0px
    style 73 stroke:#55f,stroke-width:3.0px
    style 74 stroke:#55f,stroke-width:3.0px
    style 75 stroke:red,stroke-width:3.0px
    style 76 stroke:#55f,stroke-width:3.0px
    style 77 stroke:red,stroke-width:3.0px
    style 78 stroke:#55f,stroke-width:3.0px
    style 79 stroke:red,stroke-width:3.0px
    style 80 stroke:#55f,stroke-width:3.0px
    style 81 stroke:#55f,stroke-width:3.0px
    style 82 stroke:red,stroke-width:3.0px
    style 83 stroke:#55f,stroke-width:3.0px
    style 84 stroke:#55f,stroke-width:3.0px
    style 85 stroke:red,stroke-width:3.0px
    style 86 stroke:#55f,stroke-width:3.0px
    style 87 stroke:#55f,stroke-width:3.0px
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
    linkStyle 36 stroke:red,stroke-width:2.0px
    linkStyle 37 stroke-width:2.0px
    linkStyle 38 stroke:green,stroke-width:2.0px
    linkStyle 39 stroke:#55f,stroke-width:2.0px
    linkStyle 40 stroke-width:2.0px
    linkStyle 41 stroke:green,stroke-width:2.0px
    linkStyle 42 stroke:#55f,stroke-width:2.0px
    linkStyle 43 stroke-width:2.0px
    linkStyle 44 stroke:green,stroke-width:2.0px
    linkStyle 45 stroke:#55f,stroke-width:2.0px
    linkStyle 46 stroke:red,stroke-width:2.0px
    linkStyle 47 stroke-width:2.0px
    linkStyle 48 stroke:green,stroke-width:2.0px
    linkStyle 49 stroke:#55f,stroke-width:2.0px
    linkStyle 50 stroke-width:2.0px
    linkStyle 51 stroke:green,stroke-width:2.0px
    linkStyle 52 stroke:#55f,stroke-width:2.0px
    linkStyle 53 stroke-width:2.0px
    linkStyle 54 stroke:green,stroke-width:2.0px
    linkStyle 55 stroke:#55f,stroke-width:2.0px
    linkStyle 56 stroke:red,stroke-width:2.0px
    linkStyle 57 stroke-width:2.0px
    linkStyle 58 stroke:green,stroke-width:2.0px
    linkStyle 59 stroke:#55f,stroke-width:2.0px
    linkStyle 60 stroke-width:2.0px
    linkStyle 61 stroke:green,stroke-width:2.0px
    linkStyle 62 stroke:#55f,stroke-width:2.0px
    linkStyle 63 stroke-width:2.0px
    linkStyle 64 stroke:green,stroke-width:2.0px
    linkStyle 65 stroke:#55f,stroke-width:2.0px
    linkStyle 66 stroke:red,stroke-width:2.0px
    linkStyle 67 stroke-width:2.0px
    linkStyle 68 stroke:green,stroke-width:2.0px
    linkStyle 69 stroke:#55f,stroke-width:2.0px
    linkStyle 70 stroke-width:2.0px
    linkStyle 71 stroke:green,stroke-width:2.0px
    linkStyle 72 stroke:#55f,stroke-width:2.0px
    linkStyle 73 stroke-width:2.0px
    linkStyle 74 stroke:green,stroke-width:2.0px
    linkStyle 75 stroke:#55f,stroke-width:2.0px
    linkStyle 76 stroke:red,stroke-width:2.0px
    linkStyle 77 stroke-width:2.0px
    linkStyle 78 stroke:green,stroke-width:2.0px
    linkStyle 79 stroke:#55f,stroke-width:2.0px
    linkStyle 80 stroke-width:2.0px
    linkStyle 81 stroke:green,stroke-width:2.0px
    linkStyle 82 stroke:#55f,stroke-width:2.0px
    linkStyle 83 stroke-width:2.0px
    linkStyle 84 stroke:green,stroke-width:2.0px
    linkStyle 85 stroke:#55f,stroke-width:2.0px
```
Obviously, this is highly toxic information. Social security numbers are so toxic that a [reference](https://www.lexjansen.com/nesug/nesug07/ap/ap19.pdf) was used just to verify that invalid numbers were being used in this example. Worse, names and birthdates could aid in identity theft, especially if associated with a social security number (or other identifer). As a result, Acme doesn't want to transmit this bare information, and Burton Bank doesn't want to receive information on students not associated with the bank. But, a full set of information must be transmitted to support the governmental regulations!

Acme thus sends out the information in a fully elided form:
```
{
    "Acme Professional School 2022-12-24 Graduation" [
        ELIDED (8)
    ]
} [
    verifiedBy: Signature
]
```
```mermaid
graph LR
    1(("38e3f10e<br/>NODE"))
    2[/"6d68c797<br/>WRAPPED"\]
    3(("441bc0d3<br/>NODE"))
    4["1c42df20<br/>#quot;Acme Professional School 2022-12-24 Graduation#quot;"]
    5{{"0fbe062c<br/>ELIDED"}}
    6{{"1a9d204c<br/>ELIDED"}}
    7{{"1ccceace<br/>ELIDED"}}
    8{{"301cb6f4<br/>ELIDED"}}
    9{{"40e63258<br/>ELIDED"}}
    10{{"8136bd53<br/>ELIDED"}}
    11{{"df10fd36<br/>ELIDED"}}
    12{{"e79e2110<br/>ELIDED"}}
    13(["42815a8c<br/>ASSERTION"])
    14[/"d59f8c0f<br/>verifiedBy"/]
    15["0376c2bc<br/>Signature"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    3 --> 5
    3 --> 6
    3 --> 7
    3 --> 8
    3 --> 9
    3 --> 10
    3 --> 11
    3 --> 12
    1 --> 13
    13 -->|pred| 14
    13 -->|obj| 15
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 6 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 7 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 8 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 9 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 10 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 11 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 12 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke-width:2.0px
    linkStyle 5 stroke-width:2.0px
    linkStyle 6 stroke-width:2.0px
    linkStyle 7 stroke-width:2.0px
    linkStyle 8 stroke-width:2.0px
    linkStyle 9 stroke-width:2.0px
    linkStyle 10 stroke-width:2.0px
    linkStyle 11 stroke-width:2.0px
    linkStyle 12 stroke:green,stroke-width:2.0px
    linkStyle 13 stroke:#55f,stroke-width:2.0px
```
They also include precise information on how to form the elided assertions, with examples.

Using a tool such as `envelope-cli`, Burton can now use the exact format specified by Acme to form an assertion for each of their loan holders that combines their identifier, their last name, and their date of birth:
```
"socialSecurity": "123456789" [
    "dateOfBirth": "2004-02-29"
    "lastName": "Gray"
]
```
```
0fbe062c ASSERTION
    32f06bb1 pred "socialSecurity"
    68b165ed obj NODE
        3e7d4a32 subj "123456789"
        0d206284 ASSERTION
            eb62836d pred "lastName"
            c8027fab obj "Gray"
        e3ff7458 ASSERTION
            06d2aaa3 pred "dateOfBirth"
            c246b6c0 obj "2004-02-29"
```
```mermaid
graph LR
    1(["0fbe062c<br/>ASSERTION"])
    2["32f06bb1<br/>#quot;socialSecurity#quot;"]
    3(("68b165ed<br/>NODE"))
    4["3e7d4a32<br/>#quot;123456789#quot;"]
    5(["0d206284<br/>ASSERTION"])
    6["eb62836d<br/>#quot;lastName#quot;"]
    7["c8027fab<br/>#quot;Gray#quot;"]
    8(["e3ff7458<br/>ASSERTION"])
    9["06d2aaa3<br/>#quot;dateOfBirth#quot;"]
    10["c246b6c0<br/>#quot;2004-02-29#quot;"]
    1 -->|pred| 2
    1 -->|obj| 3
    3 -->|subj| 4
    3 --> 5
    5 -->|pred| 6
    5 -->|obj| 7
    3 --> 8
    8 -->|pred| 9
    8 -->|obj| 10
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:red,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:green,stroke-width:2.0px
    linkStyle 1 stroke:#55f,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke-width:2.0px
    linkStyle 4 stroke:green,stroke-width:2.0px
    linkStyle 5 stroke:#55f,stroke-width:2.0px
    linkStyle 6 stroke-width:2.0px
    linkStyle 7 stroke:green,stroke-width:2.0px
    linkStyle 8 stroke:#55f,stroke-width:2.0px
```
If the hash for the assertion (`0fbe062c` for `Gray`) appears in the elided Gordian Envelope, then the Bank knows that they can update their records to show that loan holder has graduated.

And, this was all done without exchanging toxic information, but instead _depending_ on selective correlation. Only someone who already held the information could possibly correlate the hash back to its original data!

### Related Files

* [Other Envelope Use Cases](https://www.blockchaincommons.com/introduction/Envelope-Intro/#usage-of-envelopes)

