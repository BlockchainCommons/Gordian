# Gordian Envelope Use Cases: Health Care

[intro]

## Health Care Use Case Table of Contents

[intro]

## Part One: Personal Sensor Data

[get rid of idea of Nadia as the programmer, it just makes the examples more complex than they should be]

This first set of use cases details engineer Nadia's work designing a
new wearable activity tracker, the ToneZone, which will focus on
keeping her data private.

### 1. Nadia Gets Fit (Metadata)

* **Use Case:** Nadia need a wearable activity tracker that can store her data.
* **Openness Benefits:** Nadia uses a self-describing format that ensures that her data will be readable in the far future.

Nadia has used wearable activity trackers for years, but she's slowly
become aware that she's playing with fire. She's storing away high
levels of very personal data about her health and her location, and
she has no assurance that any of the data is actually safe and
secure. As a result, Nadia decides to design her own data tracker, the
ToneZone. Its main priority will be securing data (and its secondary
priority will be sharing that data as its user sees fit, but that
issue is down the road a bit).

The first thing that Nadia has to do is to design her data
format. This is easy to do using Gordian Envelope, which allows for
the encoding of tiered data laid out as assertions.

While deciding how to lay out her info, Nadia has to think about not
just a simple-to-use structure, but also a structure that will allow
for the individual selection (and elision) of specific data. She
settles on the following:
```
"ur:cid/hdcxzoqzispesnbbkohddwbyhtbzzsssdldassamdeeofdtndsaazsjpdtnnvwfnatglbgbnehwe" [
    "account": {
        "00000001" [
            "birthdate": "19891109"
            "fullName": "Nadia Levedeva"
            "height": "65.1"
            "weight": "132.7"
        ]
    }
    "device": {
        "ToneZone 1.0" [
            "gpsInfoFor": "20230516" [
                "gpsQueue": "1684274400" [
                    "distance": "0"
                    "latitude": "2.122778"
                    "longitude": "41.380833"
                    "status": "0"
                ]
                "gpsQueue": "1684279978" [
                    "distance": "5230"
                    "latitude": "2.456944"
                    "length": "36000"
                    "longitude": "41.430278"
                    "status": "8"
                ]
            ]
            "heartInfoFor": "20230515" [
                "1684274400": "59"
                "1684274460": "60"
                "1684274520": "60"
                "1684274580": "59"
                "1684274640": "59"
            ]
            "heartInfoFor": "20230516" [
                "1684274400": "85"
                "1684274460": "87"
                "1684274520": "91"
                "1684274580": "90"
                "1684274640": "88"
            ]
            "serialNumber": "SN102313A"
            "statsFor": "20230515" [
                "floors": "3"
                "restingHeartRate": "55"
                "steps": "5703"
                "zoneMinutes": "0"
            ]
            "statsFor": "20230516" [
                "floors": "17"
                "restingHeartRate": "56"
                "steps": "10715"
                "zoneMinutes": "25"
            ]
            "stepInfoFor": "20230515" [
                "1684188000": "0"
                "1684188060": "0"
                "1684188120": "7"
                "1684188180": "2"
                "1684188240": "0"
            ]
            "stepInfoFor": "20230516" [
                "1684274400": "95"
                "1684274460": "99"
                "1684274520": "103"
                "1684274580": "103"
                "1684274640": "101"
            ]
            "tempInfoFor": "20230515" [
                "1684188000": "97"
                "1684188060": "97.1"
                "1684188120": "97.3"
                "1684188180": "97.2"
                "1684188240": "97.1"
            ]
            "tempInfoFor": "20230516" [
                "1684274400": "98.2"
                "1684274460": "98.2"
                "1684274520": "98.3"
                "1684274580": "98.2"
                "1684274640": "98.2"
            ]
        ]
    }
    "hasPubKey": "ur:crypto-pubkeys/lftaadfwhdcxtkzsswonghpdemptcpludkktialnnyzmadtldlbstabwwmecvtfghkckfztldemwtaaddmhdcxryptseesdrjpssbzwmoxwkvleyrnbgnszoatatqzglpaetdelfnbpyglaotlktcyfllubzeh"
]
```
See the [mermaid output](Healthcare-mermaid-1b.md).

This data structure includes not just device data from the tone zone,
but also personal account information that Nadia has entered, to help
provide context for her wearable data. 

Device data is divided out among several categories and also for
individual days. This will make it easy for Nadia in the future to
differentiate highly personal data (such as `gpsInfoFor` and
unfortunately `tempInfoFor`) and more general data (such as
`statsFor`) and also to do it on a granular, daily basis.  Obviously,
the actual ToneZone tracker will have _lots_ more data both total and
for each day. This is just a cut-down example intended to show some of
the functionality possible.

Notably, the entirely data structure is cleanly self-describing. The
Google Envelope assertions clearly denote each type of data, while
some data is additional stored as a [Uniform Resource
(UR)](https://github.com/BlockchainCommons/crypto-commons/blob/master/Docs/ur-1-overview.md),
which is also self-describing and built atop
[dCBOR](https://github.com/BlockchainCommons/crypto-commons/blob/master/dcbor.md),
yet another self-describing format.

Basically, it's self-describing all the way down, ensuring the data's
openness, which will be vital when Nadia goes beyond the protection she builds into the ToneZone to allow some sharing of data (in Part Two).

### 2. Nadia Protects Her Privacy (Encryption)

* **Use Case:** Nadia wants to make sure that her tracker data isn't
easily accessible by unauthorized parties.**
* **Privacy Benefits:** Encryption ensures that the data is closely protected on a few devices.

Of course, just formatting the data in a open manner isn't enough. For
Nadia's ToneZone to fulfill its core goal, the data has to be
protected.

This is simple with Gordian Envelope. All Nadia has to do is to
encrypt her wrapped envelopes for her device data and her account
info. Then, the data can only be encrypted or decrypted with her
symmetric key, which Nadia plans to store both in the ToneZone device
and on its mobile app, but nowhere else.

```
"ur:cid/hdcxzoqzispesnbbkohddwbyhtbzzsssdldassamdeeofdtndsaazsjpdtnnvwfnatglbgbnehwe" [
    "account": ENCRYPTED
    "device": ENCRYPTED
    "hasPubKey": "ur:crypto-pubkeys/lftaadfwhdcxtkzsswonghpdemptcpludkktialnnyzmadtldlbstabwwmecvtfghkckfztldemwtaaddmhdcxryptseesdrjpssbzwmoxwkvleyrnbgnszoatatqzglpaetdelfnbpyglaotlktcyfllubzeh"
]
```

```mermaid
graph LR
    1(("4f3ced9e<br/>NODE"))
    2["426f3f8a<br/>#quot;ur:cid/hdcxzoqzispesnbbkohddwbyhtbzzsssd…#quot;"]
    3(["38cadd4f<br/>ASSERTION"])
    4["bb751b0e<br/>#quot;hasPubKey#quot;"]
    5["2ada5820<br/>#quot;ur:crypto-pubkeys/lftaadfwhdcxtkzsswongh…#quot;"]
    6(["c75e3bff<br/>ASSERTION"])
    7["a05e2863<br/>#quot;account#quot;"]
    8>"f1bfd553<br/>ENCRYPTED"]
    9(["cac8aa12<br/>ASSERTION"])
    10["52b252a6<br/>#quot;device#quot;"]
    11>"a6e75627<br/>ENCRYPTED"]
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
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
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
```

[REDO THIS NUMBERS]
Note by comparing with the [unencrypted mermaid
diagram](Healthcare-mermaid-1a.md) that the checksums for the
encrypted data remains consistent. The device assertion is still
`b0499091`, the device assertion is still `c75e3bff` and the master
checksum is still `6ab5d383`. This is a crucial technique within
Gordian, because it ensures that data can still be validated even when
encrypted or elided.

Thus the first goal of Nadia's new tracker, ensuring privacy, is fulfilled!

### 3. Nadia Protects Her Key (SSKR)

* **Use Case:** Nadia needs to ensure that her private key isn't a
single point of failure for her data!
* **Openness Benefits:** Using an open-sharding system, Nadia ensures
that her key can be recovered easily.
* **Resilience Benefits:** SSKR allows Nadia to remove her SPOF while
keeping her key secure.

Though it's great that Nadia can protect her personal data with a key
that she holds, it can also be a Single Point of Failure (SPOF). If
she loses her key, she loses her data.

Fortunately, the solution is easy with Gordian Envelope: create an
envelope with the symmetric key, then lock that envelope with a
multipermit so that it can either be recovered by Nadia using her
private key or by putting together any two shares. She's now created a
robust storage mechanism for her key that could be improved any
further by a system such as
[CSR](https://github.com/BlockchainCommons/Gordian/blob/master/CSR/README.md)
that could be used to automate authentication and reconstruction.

Here's the original envelope:
```
"ur:crypto-key/hdcxvaftbypkwlstdsaabefgnbsfmnclctlohdhnplimdphyqdpakibejyemkofmyabtghftntfr"
```
```mermaid
graph LR
    1["e487b47f<br/>#quot;ur:crypto-key/hdcxvaftbypkwlstdsaabefgnb…#quot;"]
    style 1 stroke:#55f,stroke-width:3.0px
```
Here's what it looks like after it's been encrypted with her public
key and sharded:
```
ENCRYPTED [
    hasRecipient: SealedMessage
    sskrShare: SSKRShare
]

ENCRYPTED [
    hasRecipient: SealedMessage
    sskrShare: SSKRShare
]

ENCRYPTED [
    hasRecipient: SealedMessage
    sskrShare: SSKRShare
]

```

The `hasRecipient:` allows Nadia to recover from any of the three
shares using her private key. The `sskrShare:` allows anyone to
combine any two shares to recover the envelope.

```mermaid
graph LR
    1(("071dafc7<br/>NODE"))
    2>"304b2acb<br/>ENCRYPTED"]
    3(["37de4479<br/>ASSERTION"])
    4[/"7a4d6af9<br/>6"/]
    5["b971727b<br/>SSKRShare"]
    6(["9d790543<br/>ASSERTION"])
    7[/"e41178b8<br/>5"/]
    8["48208528<br/>SealedMessage"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
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

```mermaid
graph LR
    1(("ce3dd4da<br/>NODE"))
    2>"304b2acb<br/>ENCRYPTED"]
    3(["a556ce89<br/>ASSERTION"])
    4[/"7a4d6af9<br/>6"/]
    5["5a568dcc<br/>SSKRShare"]
    6(["c289fb91<br/>ASSERTION"])
    7[/"e41178b8<br/>5"/]
    8["7abac950<br/>SealedMessage"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
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

```mermaid
graph LR
    1(("a9ceae00<br/>NODE"))
    2>"304b2acb<br/>ENCRYPTED"]
    3(["2e15cd04<br/>ASSERTION"])
    4[/"e41178b8<br/>5"/]
    5["5ebdc118<br/>SealedMessage"]
    6(["47072fb8<br/>ASSERTION"])
    7[/"7a4d6af9<br/>6"/]
    8["2c01b8f1<br/>SSKRShare"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    1 --> 6
    6 -->|pred| 7
    6 -->|obj| 8
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
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

Nadia now has a fully functional store for her ToneZone that is
_independent_, _private_, _resilient_, and _open_, fulfilling the
[Gordian
Principles](https://github.com/BlockchainCommons/Gordian#gordian-principles). She's
ready to move on to the next step, using this setup to share her data
in meaningful ways.

## Part Two: Personal Shared Sensor Data

[Nadia has protected her data, but now she also wants to share her
data selectively, as she choses.]

### 4. Nadia Hearts Her Doctor (Elision)

* **Use Case:** Nadia wants to share a selection of her data with her doctor.
* **Independence Benefits:** Nadia can choose exactly what data to send.
* **Privacy Benefits:** Nadia can cut out data that she doesn't want to share.
* **Openness Benefits:** The self-describing format means that the doctor's app can easily unspool Nadia's data.

Ideally, Nadia would like to share all of her data with her doctor, to
maximize the efficacy of her care. Unfortunately, some of the data is
very private. For example, her doctor just doesn't need to know her
geo data.

Moreso, in the currently oppressive environment in parts of the United
States, some of her data could be personally dangerous if released,
such as her temperature data, which could provide insights into her
reproductive cycle and thus be weaponized by states that are
restricting womens' rights. Though she trusts her doctor, she doesn't
trust the state not to subpoena data of that sort.

Fortunately, Gordian Envelope allows her as the holder to elide her
data as she sees fit. She starts with her unencrypted envelope and
cuts it down as appropriate (something that's easy to do with the UI
that Nadia designed for her ToneZone software).

The elided data Nadia hands her doctor looks like this:
```
ELIDED [
    "account": {
        "00000001" [
            "birthdate": "19891109"
            "fullName": "Nadia Levedeva"
            "height": "65.1"
            "weight": "132.7"
        ]
    }
    "device": {
        "ToneZone 1.0" [
            "heartInfoFor": "20230515" [
                "1684274400": "59"
                "1684274460": "60"
                "1684274520": "60"
                "1684274580": "59"
                "1684274640": "59"
            ]
            "heartInfoFor": "20230516" [
                "1684274400": "85"
                "1684274460": "87"
                "1684274520": "91"
                "1684274580": "90"
                "1684274640": "88"
            ]
            "statsFor": "20230515" [
                "floors": "3"
                "restingHeartRate": "55"
                "steps": "5703"
                "zoneMinutes": "0"
            ]
            "statsFor": "20230516" [
                "floors": "17"
                "restingHeartRate": "56"
                "steps": "10715"
                "zoneMinutes": "25"
            ]
            "stepInfoFor": "20230515" [
                "1684188000": "0"
                "1684188060": "0"
                "1684188120": "7"
                "1684188180": "2"
                "1684188240": "0"
            ]
            "stepInfoFor": "20230516" [
                "1684274400": "95"
                "1684274460": "99"
                "1684274520": "103"
                "1684274580": "103"
                "1684274640": "101"
            ]
            ELIDED: ELIDED
            ELIDED: ELIDED
            ELIDED: ELIDED
            ELIDED: ELIDED
        ]
    }
    "hasPubKey": "ur:crypto-pubkeys/lftaadfwhdcxtkzsswonghpdemptcpludkktialnnyzmadtldlbstabwwmecvtfghkckfztldemwtaaddmhdcxryptseesdrjpssbzwmoxwkvleyrnbgnszoatatqzglpaetdelfnbpyglaotlktcyfllubzeh"
]
```
See the [mermaid output](Healthcare-mermaid-1b.md).

She can see heart rates and how that relates to exercise, but she
doesn't have unneccessary or potentially dangerous data. Nadia's goal of being able to share data in an independent, personal way is thus met.

### 5. Nadia is a Bit Remote (Multi-Permit)

* **Use Case:** Because of irregularities in her heart rate, Nadia wants to regularly share her data with a third-party health monitoring agency.
* **Privacy Benefits:** By creating multi-permits, Nadia can decide exactly what third-parties have access to her data.
* **Openness Benefits:** Like the doctor, the health monitoring agency can read the data because of its self-describing format.

Unfortunately, Nadia's ToneZone data helps to alert her doctor to a
potential heart condition, an arrhythmia, which is verified with
additional testing.

Nadia has been forming partnerships with health monitoring services
for situations exactly like this: they'll engage in automted
monitoring of a client's health data, to watch for dangerous events,
such as afib or a heart attack. Now Nadia takes advantage of the
service herself.

Nadia transfers data to the service using the same technique as
casually mentioned in the SSKR example above: she generates a
multipermit. This is a method by which she can encrypt the same data
with multiple keys. In this case, the monitoring service needs to see
her device data, so she re-encrypts that, once with her own symmetric
key, once with the public key that they supply her:
```     	     
"ur:cid/hdcxzoqzispesnbbkohddwbyhtbzzsssdldassamdeeofdtndsaazsjpdtnnvwfnatglbgbnehwe" [
    "account": ENCRYPTED
    "device": ENCRYPTED [
        hasRecipient: SealedMessage
    ]
    "hasPubKey": "ur:crypto-pubkeys/lftaadfwhdcxtkzsswonghpdemptcpludkktialnnyzmadtldlbstabwwmecvtfghkckfztldemwtaaddmhdcxryptseesdrjpssbzwmoxwkvleyrnbgnszoatatqzglpaetdelfnbpyglaotlktcyfllubzeh"
]
```
```mermaid
graph LR
    1(("60f74188<br/>NODE"))
    2["426f3f8a<br/>#quot;ur:cid/hdcxzoqzispesnbbkohddwbyhtbzzsssd…#quot;"]
    3(["38cadd4f<br/>ASSERTION"])
    4["bb751b0e<br/>#quot;hasPubKey#quot;"]
    5["2ada5820<br/>#quot;ur:crypto-pubkeys/lftaadfwhdcxtkzsswongh…#quot;"]
    6(["ab36b175<br/>ASSERTION"])
    7["52b252a6<br/>#quot;device#quot;"]
    8(("6403b427<br/>NODE"))
    9>"a6e75627<br/>ENCRYPTED"]
    10(["2c8a6cc3<br/>ASSERTION"])
    11[/"e41178b8<br/>5"/]
    12["bcfd1406<br/>SealedMessage"]
    13(["c75e3bff<br/>ASSERTION"])
    14["a05e2863<br/>#quot;account#quot;"]
    15>"f1bfd553<br/>ENCRYPTED"]
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
    1 --> 13
    13 -->|pred| 14
    13 -->|obj| 15
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:#55f,stroke-width:3.0px
    style 6 stroke:red,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px
    style 8 stroke:red,stroke-width:3.0px
    style 9 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 10 stroke:red,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:#55f,stroke-width:3.0px
    style 13 stroke:red,stroke-width:3.0px
    style 14 stroke:#55f,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
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
```

Now Nadia's data can be safely transmitted to her monitoring service,
but they can only access the exact data she allows (by encrypting it
with their public key). Meanwhile, Nadia also retains access to the
data herself.

Note that this _does_ change the hash, unlike simple encryption,
because a new assertion has been added (the `hasRecipient` sealed
message).

A similar technique could be used to allow parents to monitor their
children or to help their elderly parents through encrypted data being
regularly streamed, all thanks to the safeties that Nadia has built
using Gordian Envelope to allow for both encryption and multiple
access to that encrypted data.

### 6. Nadia Steps Up (Signature)

* **Use Case:** Nadia wants to submit validated step data to a stepping contest.
* **Privacy Benefits:** Multiple signatures assure everyone that the data is valid.
* **Openness Benefits:** This is another example of how self-describing data can open many doors.

Nadia is told to step up her steps for heart health, so she's now
working hard to get 10,000 steps a day. To encourage herself, she
enters a step contest. Her ToneZone will submit elided daily counts of
her steps, but the data must be validated since there are real prizes
in the contest! Fortunately, ToneZone has its own private key. Data
can be signed by them and submitted.

The data is heavily elided for this usage, something again
automatically managed by the ToneZone:
```
ELIDED [
    "device": {
        "ToneZone 1.0" [
            "statsFor": "20230515" [
                "steps": "5703"
                ELIDED (3)
            ]
            "statsFor": "20230516" [
                "steps": "10715"
                ELIDED (3)
            ]
            ELIDED: ELIDED
            ELIDED: ELIDED
            ELIDED: ELIDED
            ELIDED: ELIDED
            ELIDED: ELIDED
            ELIDED: ELIDED
            ELIDED: ELIDED
            ELIDED: ELIDED
        ]
    }
    "hasPubKey": "ur:crypto-pubkeys/lftaadfwhdcxtkzsswonghpdemptcpludkktialnnyzmadtldlbstabwwmecvtfghkckfztldemwtaaddmhdcxryptseesdrjpssbzwmoxwkvleyrnbgnszoatatqzglpaetdelfnbpyglaotlktcyfllubzeh"
    ELIDED
]
```
The document must then be wrapped (so that the signature will apply to
the entire Envelope) and signed.

The result looks like this:
```
{
    ELIDED [
        "device": {
            "ToneZone 1.0" [
                "statsFor": "20230515" [
                    "steps": "5703"
                    ELIDED (3)
                ]
                "statsFor": "20230516" [
                    "steps": "10715"
                    ELIDED (3)
                ]
                ELIDED: ELIDED
                ELIDED: ELIDED
                ELIDED: ELIDED
                ELIDED: ELIDED
                ELIDED: ELIDED
                ELIDED: ELIDED
                ELIDED: ELIDED
                ELIDED: ELIDED
            ]
        }
        "hasPubKey": "ur:crypto-pubkeys/lftaadfwhdcxtkzsswonghpdemptcpludkktialnnyzmadtldlbstabwwmecvtfghkckfztldemwtaaddmhdcxryptseesdrjpssbzwmoxwkvleyrnbgnszoatatqzglpaetdelfnbpyglaotlktcyfllubzeh"
        ELIDED
    ]
} [
    verifiedBy: Signature [
        note: "Signed by ToneZone Inc."
    ]
]
```
See the [mermaid output](Healthcare-mermaid-1c.md).


## Part Three: Clinically Shared Sensor Data

[Nadia has protected her data, but now she also wants to share her
data selectively, as she choses.]

### 7. Nadia Gets Clinical (Elision, Third-Party Encryption)

* **Use Case:** Nadia wants to submit data to a clinical trial.
* **Privacy Benefits:** Nadia's data is protected so that she can't be identified.
* **Openness Benefits:** Clinical trials are one of the most important communities that can benefit from open data.

Personal health is important, but so is public health, and wearable
activity trackers make it easy to support that type of research. Nadia
believes strongly is this type of public good, so she's made it easy
for ToneZone users to become part of clinical trials.

Via the ToneZone app, users can apply for trials. When they do so,
they agree exactly what data will be shared and also receive a public
key to encrypt the data.

This results in the creation of elided data, such as this one, for a
clinical trial relating steps to heart rate:
```
ELIDED [
    "device": {
        "ToneZone 1.0" [
            "heartInfoFor": "20230515" [
                "1684274400": "59"
                "1684274460": "60"
                "1684274520": "60"
                "1684274580": "59"
                "1684274640": "59"
            ]
            "heartInfoFor": "20230516" [
                "1684274400": "85"
                "1684274460": "87"
                "1684274520": "91"
                "1684274580": "90"
                "1684274640": "88"
            ]
            "statsFor": "20230515" [
                "restingHeartRate": "55"
                "steps": "5703"
                ELIDED (2)
            ]
            "statsFor": "20230516" [
                "restingHeartRate": "56"
                "steps": "10715"
                ELIDED (2)
            ]
            "stepInfoFor": "20230515" [
                "1684188000": "0"
                "1684188060": "0"
                "1684188120": "7"
                "1684188180": "2"
                "1684188240": "0"
            ]
            "stepInfoFor": "20230516" [
                "1684274400": "95"
                "1684274460": "99"
                "1684274520": "103"
                "1684274580": "103"
                "1684274640": "101"
            ]
            ELIDED: ELIDED
            ELIDED: ELIDED
            ELIDED: ELIDED
            ELIDED: ELIDED
        ]
    }
    ELIDED (2)
]
```
See the [mermaid output](Healthcare-mermaid-1d.md).

The clinical trial will require proof of provenance. This is managed
with a ToneZone signature, validating the date, just as with the step
contest that Nadia participated in.
```
{
    ELIDED [
        "device": {
            "ToneZone 1.0" [
                "heartInfoFor": "20230515" [
                    "1684274400": "59"
                    "1684274460": "60"
                    "1684274520": "60"
                    "1684274580": "59"
                    "1684274640": "59"
                ]
                "heartInfoFor": "20230516" [
                    "1684274400": "85"
                    "1684274460": "87"
                    "1684274520": "91"
                    "1684274580": "90"
                    "1684274640": "88"
                ]
                "statsFor": "20230515" [
                    "restingHeartRate": "55"
                    "steps": "5703"
                    ELIDED (2)
                ]
                "statsFor": "20230516" [
                    "restingHeartRate": "56"
                    "steps": "10715"
                    ELIDED (2)
                ]
                "stepInfoFor": "20230515" [
                    "1684188000": "0"
                    "1684188060": "0"
                    "1684188120": "7"
                    "1684188180": "2"
                    "1684188240": "0"
                ]
                "stepInfoFor": "20230516" [
                    "1684274400": "95"
                    "1684274460": "99"
                    "1684274520": "103"
                    "1684274580": "103"
                    "1684274640": "101"
                ]
                ELIDED: ELIDED
                ELIDED: ELIDED
                ELIDED: ELIDED
                ELIDED: ELIDED
            ]
        }
        ELIDED (2)
    ]
} [
    verifiedBy: Signature [
        note: "Signed by ToneZone Inc."
    ]
]
```
See the [mermaid output](Healthcare-mermaid-1e.md).

Finally, Nadia wraps the data and encrypts it with the clinical
trial's public key:
```
ENCRYPTED [
    hasRecipient: SealedMessage
]
```
```mermaid
graph LR
    1(("2278c769<br/>NODE"))
    2>"c3ad87c4<br/>ENCRYPTED"]
    3(["44645b4d<br/>ASSERTION"])
    4[/"e41178b8<br/>5"/]
    5["4db842bf<br/>SealedMessage"]
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

This last step is crucial, not just because the data should be
encrypted, despite the fact that it's largely been anonymized through
elision. It's also important because ToneZone is out of necessity the
carrier of the information: going through the ToneZone maker is the
only way to automatically and easily ensure this data is regularly
updated, which is the whole point, since it makes the clinical trials
more likely to succeed thanks to robust data collection.

But, Nadia doesn't want her data to go to ToneZone, and ToneZone
doesn't want data that could be potentially toxic, depending on how
personal and identifiable the data being collected is. Fortunately,
the use of third-party encryption through the clinical trial's own key
provides a perfect solution.

Overall:
* Administration has been dramatically simplified through automation.
* HIPAA requirements have been dramatically simplified through careful elision of data.
* Costs have been overall reduced.

As a result, clinical trials can be much more successful at dealing with the health questions at their core!

A more complex situation might have data being regularly uploaded to
ToneZone, some of which ToneZone keeps, to help Nadia with her health,
and some of which is passed on to the clinical trial. In this case,
multipermits are again used, designating which data goes to which
people via different encryption keys.

### 8. Nadia Proves her Worth (Proof of Inclusion)

* **Use Case:** Nadia wants to prove that she participated in a clinical study.
* **Privacy Benefits:** Nadia only reveals that her data is part of the clinical try when she chooses to do so.

Nadia learns that her health insurance company encourages
participation in clinical trials with a 2% discount on her insurance
rate. She has to think about whether she's willing to give her
insurance company this info, but ultimately decides that the dangers
are relatively low for them being able to discriminate against her as
a result, thanks to the ACA. She just needs to prove that she
participated.

This is done with a proof of inclusion.

Nadia's ToneZone extracts her `hasPubKey` info from her data:
```
ur:envelope/tpsolftpsptpcsinishsjkgdkpidgrihkktpsptpcskspfkpjpftiajpkkjojyjldpjokpidjeihkkjkdljziyjyhshsieiyktisieiaksjyjeknjkjkktjljtioisjoieihjnjojyiajojzkpiejejejyinhsjzjtjtkkknjnhsiejyjziejzidjkjyhsidktktjnihiakojyiyioisjeiajeiyknjyjzieihjnktjyhshsieiejnisieiaksjpkkjojyjkihihjkiejpimjojkjkidknktjnjlksktjekojzihkkjpjtidiojtjkknjlhsjyhsjyjskniojzjohsihjyieihjziyjtidjokkiojzhsjljyjzjejyiakkiyjzjzkpidknihiskgsnfyao
```
```
"hasPubKey": "ur:crypto-pubkeys/lftaadfwhdcxtkzsswonghpdemptcpludkktialnnyzmadtldlbstabwwmecvtfghkckfztldemwtaaddmhdcxryptseesdrjpssbzwmoxwkvleyrnbgnszoatatqzglpaetdelfnbpyglaotlktcyfllubzeh"
```
```mermaid
envelope --mermaid
graph LR
    1(["38cadd4f<br/>ASSERTION"])
    2["bb751b0e<br/>#quot;hasPubKey#quot;"]
    3["2ada5820<br/>#quot;ur:crypto-pubkeys/lftaadfwhdcxtkzsswongh…#quot;"]
    1 -->|pred| 2
    1 -->|obj| 3
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:green,stroke-width:2.0px
    linkStyle 1 stroke:#55f,stroke-width:2.0px
```

[sign it with private key]

[fully elided relase]
[prove it's the same]


[reveal data with hashed public key, and then later reveal public key in a message signed by private key]

[reveal data with hashed public key, and then later reveal public key in a message signed by private key]

### 9. Nadia Becomes a Demographic (Anonymization)

* **Use Case:** Nadia's data is further anonymized so that it can be part of large-scale demographics, but it still needs to retain its proof of provenance.
* **Privacy Benefits:** Nadia's data becomes even more anonymous.

* Aggregated Demographic Data [is what demographic trials use], thus herd privacy — need to demonstrate appropriate demographic spread without compromising information, may need to correlate data points with demographics with compromising individual's privacy
* Double-Blind Data Collection for Clinical Trials [no leakage of data between data acquiring & adminstering]

* Differential Data Set
   * "Blur" Data +/-5 or whatever
   * With some proofs back to original
   * DATA BRANCH

## Part Four: The COVID-19 Appenix

### 10. Nadia Goes Viral (Herd Privacy)

* **Use Case:** Nadia wants to Support the Public Health of COVID Contact Tracing without Revealing Her Location.
* **Privacy Benefits:** Nadia's location is never revealed.
* **Openness Benefits:** A large, discrete public-health system is able to share in data.

[Nadia's redacted location is uploaded; a private key can let her update it with a flag if she has COVID; a one-time contact lets her know if someone else does.]

Additional Examples:
* Health Insurance

Privacy Concerns:
* Data is SAFE and SOUND and NOT USED TO INCRIMINATING USERS
* Eliding info
* or Differentely Encrypting info so that only some of it
* SO WANT TO PEOPLE ABLE TO COLLECTING SOME ACTIVITY DATA FOR COACHING.
   * But some is removed or elided or opt-in from user.
   * So swap out Doctor for this?
* WANT TO OFFER TRIALS
   * With simplified admin (just ring/fitbit/tonezone)
   * With simplified HIPAA requirements
   * It's an economic approach.
* There may also be linked/non-sensor data
   * Such as age
   * That is attested to
