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
    "hasPubKey": ELIDED
    ELIDED
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
        "hasPubKey": ELIDED
        ELIDED
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
    1(("1b5666c8<br/>NODE"))
    2>"acab46a2<br/>ENCRYPTED"]
    3(["a0ad65d5<br/>ASSERTION"])
    4[/"e41178b8<br/>5"/]
    5["5e6cc846<br/>SealedMessage"]
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

Obviously, the clinic trial needs to make a publication to support
this, but it's something that they want to do anyway, to offer support
for the validity of their publication.

One possibility is for them to release further elided versions of the
unencrypted, signed data packets that they receive. That's one of the
advantages of Gordian Envelope: each holder can further elide or
repackage data as they see fit.

The following shows a further elided envelope that only contained the
validation info for the data: the ToneZone signature and the
`hasPubKey` statement (though the clinical trial doesn't actually know
what the public key is!)

```
{
    ELIDED [
        "hasPubKey": ELIDED
        ELIDED: ELIDED
        ELIDED
    ]
} [
    verifiedBy: Signature [
        note: "Signed by ToneZone Inc."
    ]
]
```
```mermaid
graph LR
    1(("0410cc94<br/>NODE"))
    2[/"80134e1e<br/>WRAPPED"\]
    3(("4f3ced9e<br/>NODE"))
    4{{"426f3f8a<br/>ELIDED"}}
    5(["38cadd4f<br/>ASSERTION"])
    6["bb751b0e<br/>#quot;hasPubKey#quot;"]
    7{{"2ada5820<br/>ELIDED"}}
    8{{"c75e3bff<br/>ELIDED"}}
    9(["cac8aa12<br/>ASSERTION"])
    10{{"52b252a6<br/>ELIDED"}}
    11{{"a6e75627<br/>ELIDED"}}
    12(["2bcddfb6<br/>ASSERTION"])
    13[/"9d7ba9eb<br/>3"/]
    14(("0a7ab794<br/>NODE"))
    15["1073a477<br/>Signature"]
    16(["1462e1a7<br/>ASSERTION"])
    17[/"49a5f41b<br/>4"/]
    18["5f9a1df7<br/>#quot;Signed by ToneZone Inc.#quot;"]
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
    1 --> 12
    12 -->|pred| 13
    12 -->|obj| 14
    14 -->|subj| 15
    14 --> 16
    16 -->|pred| 17
    16 -->|obj| 18
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 8 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 11 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 12 stroke:red,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:red,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    style 16 stroke:red,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
    style 18 stroke:#55f,stroke-width:3.0px
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
    linkStyle 10 stroke-width:2.0px
    linkStyle 11 stroke:green,stroke-width:2.0px
    linkStyle 12 stroke:#55f,stroke-width:2.0px
    linkStyle 13 stroke:red,stroke-width:2.0px
    linkStyle 14 stroke-width:2.0px
    linkStyle 15 stroke:green,stroke-width:2.0px
    linkStyle 16 stroke:#55f,stroke-width:2.0px
```
The other option would be for the clinical trial to create a totally
new Gordian Envelope, which contains only the (elided) public key
data. This would have the benefit of there being just a single publication.

In either case, the clinical trial publishes data that contains
Nadia's public key in elided form. Nadia can now prove her
participation.  She does this by having her ToneZone extract her
`hasPubKey` info from her data:
```
ur:envelope/tpsolftpsptpcsinishsjkgdkpidgrihkktpsptpcskspfkpjpftiajpkkjojyjldpjokpidjeihkkjkdljziyjyhshsieiyktisieiaksjyjeknjkjkktjljtioisjoieihjnjojyiajojzkpiejejejyinhsjzjtjtkkknjnhsiejyjziejzidjkjyhsidktktjnihiakojyiyioisjeiajeiyknjyjzieihjnktjyhshsieiejnisieiaksjpkkjojyjkihihjkiejpimjojkjkidknktjnjlksktjekojzihkkjpjtidiojtjkknjlhsjyhsjyjskniojzjohsihjyieihjziyjtidjokkiojzhsjljyjzjejyiakkiyjzjzkpidknihiskgsnfyao
```

```
"hasPubKey": "ur:crypto-pubkeys/lftaadfwhdcxtkzsswonghpdemptcpludkktialnnyzmadtldlbstabwwmecvtfghkckfztldemwtaaddmhdcxryptseesdrjpssbzwmoxwkvleyrnbgnszoatatqzglpaetdelfnbpyglaotlktcyfllubzeh"
```

```mermaid
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

if she reveals that anyone can then compared the hash of the assertion
(`38cadd4f`) with the `ELIDED` assertion in the published, but elided
clinical trial assertion. They match up! Since collisions are nearly
impossible in strong hashes such as the one used with Gordian
Envelope, that's sufficient proof that Nadia was a participant —
though it would have been impossible for anyone to figure out without
Nadia's revelation, as hashes are also one-way funcitons.

### 9. Nadia Becomes a Number (Anonymization, Provenance)

* **Use Case:** Clinical trials sometimes need to further de-identify data but want to maintain its provenance.
* **Privacy Benefits:** Nadia's data becomes even more anonymous.

There is a submarket for further de-identifying clinical data. Some of
this must be done by hand, which overall results in higher costs and
lower efficiences in trials.

Gordian Envelopes allow Nadia's data to be further de-identified while
still maintaining their provenance. This is done by maintaining the
original data in deep data silos, but fully eliding used in the trial:
only the master hash and the signature data are maintained, the first
to allow for lookup of the original data if its existence ever needs
to be proven, the second to maintain easy lookup of the data's
validation, in case any validator is ever proven to be untrustworthy.

The clinical trial then wraps that provenance information and creates
a new set of data with five-minute averages from the previous data,
making it less identifiable. (Even more extreme data blurring
techniques could be used, if required, provided that the same
technique is used, which links the new data with the provenance for
its origin.)

```
{
    ELIDED [
        verifiedBy: Signature [
            note: "Signed by ToneZone Inc."
        ]
    ]
} [
    "heartInfoBlur": "20230515" [
        "1684188000": "59.4"
        "1684188300": "59.6"
    ]
    "heartInfoBlur": "20230516" [
        "1684274400": "88.2"
        "1684274700": "87.4"
    ]
    "stepInfoBlur": "20230515" [
        "1684188000": "9"
        "1684188300": "67"
    ]
    "stepInfoBlur": "20230516" [
        "1684188300": "470"
        "1684274400": "502"
    ]
]
```
```mermaid
graph LR
    1(("4dbe61aa<br/>NODE"))
    2[/"acab46a2<br/>WRAPPED"\]
    3(("0410cc94<br/>NODE"))
    4{{"80134e1e<br/>ELIDED"}}
    5(["2bcddfb6<br/>ASSERTION"])
    6[/"9d7ba9eb<br/>3"/]
    7(("0a7ab794<br/>NODE"))
    8["1073a477<br/>Signature"]
    9(["1462e1a7<br/>ASSERTION"])
    10[/"49a5f41b<br/>4"/]
    11["5f9a1df7<br/>#quot;Signed by ToneZone Inc.#quot;"]
    12(["2a2e6d3c<br/>ASSERTION"])
    13["57e0b082<br/>#quot;heartInfoBlur#quot;"]
    14(("989eafca<br/>NODE"))
    15["d1395bd4<br/>#quot;20230516#quot;"]
    16(["a76528b0<br/>ASSERTION"])
    17["cf7b4592<br/>#quot;1684274700#quot;"]
    18["c0f588df<br/>#quot;87.4#quot;"]
    19(["e39d6d7e<br/>ASSERTION"])
    20["2f1526b7<br/>#quot;1684274400#quot;"]
    21["43107349<br/>#quot;88.2#quot;"]
    22(["6c1c9479<br/>ASSERTION"])
    23["44b6e7a7<br/>#quot;stepInfoBlur#quot;"]
    24(("a737c4df<br/>NODE"))
    25["d1395bd4<br/>#quot;20230516#quot;"]
    26(["2df0a5cc<br/>ASSERTION"])
    27["2f1526b7<br/>#quot;1684274400#quot;"]
    28["7c885771<br/>#quot;502#quot;"]
    29(["604028fc<br/>ASSERTION"])
    30["6a85544b<br/>#quot;1684188300#quot;"]
    31["4ad8ba7a<br/>#quot;470#quot;"]
    32(["d34d3e9e<br/>ASSERTION"])
    33["44b6e7a7<br/>#quot;stepInfoBlur#quot;"]
    34(("f3be2a5c<br/>NODE"))
    35["33241d8f<br/>#quot;20230515#quot;"]
    36(["e7984694<br/>ASSERTION"])
    37["2946850e<br/>#quot;1684188000#quot;"]
    38["2b12242f<br/>#quot;9#quot;"]
    39(["f741f132<br/>ASSERTION"])
    40["6a85544b<br/>#quot;1684188300#quot;"]
    41["626e242b<br/>#quot;67#quot;"]
    42(["fc3075d7<br/>ASSERTION"])
    43["57e0b082<br/>#quot;heartInfoBlur#quot;"]
    44(("f869cea1<br/>NODE"))
    45["33241d8f<br/>#quot;20230515#quot;"]
    46(["5102c67e<br/>ASSERTION"])
    47["6a85544b<br/>#quot;1684188300#quot;"]
    48["0b1d9a73<br/>#quot;59.6#quot;"]
    49(["9de9f69a<br/>ASSERTION"])
    50["2946850e<br/>#quot;1684188000#quot;"]
    51["e975becd<br/>#quot;59.4#quot;"]
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
    1 --> 12
    12 -->|pred| 13
    12 -->|obj| 14
    14 -->|subj| 15
    14 --> 16
    16 -->|pred| 17
    16 -->|obj| 18
    14 --> 19
    19 -->|pred| 20
    19 -->|obj| 21
    1 --> 22
    22 -->|pred| 23
    22 -->|obj| 24
    24 -->|subj| 25
    24 --> 26
    26 -->|pred| 27
    26 -->|obj| 28
    24 --> 29
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
    1 --> 42
    42 -->|pred| 43
    42 -->|obj| 44
    44 -->|subj| 45
    44 --> 46
    46 -->|pred| 47
    46 -->|obj| 48
    44 --> 49
    49 -->|pred| 50
    49 -->|obj| 51
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:red,stroke-width:3.0px
    style 10 stroke:#55f,stroke-width:3.0px
    style 11 stroke:#55f,stroke-width:3.0px
    style 12 stroke:red,stroke-width:3.0px
    style 13 stroke:#55f,stroke-width:3.0px
    style 14 stroke:red,stroke-width:3.0px
    style 15 stroke:#55f,stroke-width:3.0px
    style 16 stroke:red,stroke-width:3.0px
    style 17 stroke:#55f,stroke-width:3.0px
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
    linkStyle 13 stroke:red,stroke-width:2.0px
    linkStyle 14 stroke-width:2.0px
    linkStyle 15 stroke:green,stroke-width:2.0px
    linkStyle 16 stroke:#55f,stroke-width:2.0px
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
```
Note that even in the heavily elided root data, the root hash
(`0410cc94`) continues to be visible. That's what connects this elided
data to the original if the clinical trial's data ever needs to be
further validated. 

To further validate everything, the Clinical Trial would of course
sign this blurred data as well, verifying the standards by which the
blurring had occurred:
```
{
    {
        ELIDED [
            verifiedBy: Signature [
                note: "Signed by ToneZone Inc."
            ]
        ]
    } [
        "heartInfoBlur": "20230515" [
            "1684188000": "59.4"
            "1684188300": "59.6"
        ]
        "heartInfoBlur": "20230516" [
            "1684274400": "88.2"
            "1684274700": "87.4"
        ]
        "stepInfoBlur": "20230515" [
            "1684188000": "9"
            "1684188300": "67"
        ]
        "stepInfoBlur": "20230516" [
            "1684188300": "470"
            "1684274400": "502"
        ]
    ]
} [
    verifiedBy: Signature [
        note: "Signed by Clinical Trial Inc."
    ]
]
```
```mermaid
graph LR
    1(("2d9e18b8<br/>NODE"))
    2[/"76825215<br/>WRAPPED"\]
    3(("4dbe61aa<br/>NODE"))
    4[/"acab46a2<br/>WRAPPED"\]
    5(("0410cc94<br/>NODE"))
    6{{"80134e1e<br/>ELIDED"}}
    7(["2bcddfb6<br/>ASSERTION"])
    8[/"9d7ba9eb<br/>3"/]
    9(("0a7ab794<br/>NODE"))
    10["1073a477<br/>Signature"]
    11(["1462e1a7<br/>ASSERTION"])
    12[/"49a5f41b<br/>4"/]
    13["5f9a1df7<br/>#quot;Signed by ToneZone Inc.#quot;"]
    14(["2a2e6d3c<br/>ASSERTION"])
    15["57e0b082<br/>#quot;heartInfoBlur#quot;"]
    16(("989eafca<br/>NODE"))
    17["d1395bd4<br/>#quot;20230516#quot;"]
    18(["a76528b0<br/>ASSERTION"])
    19["cf7b4592<br/>#quot;1684274700#quot;"]
    20["c0f588df<br/>#quot;87.4#quot;"]
    21(["e39d6d7e<br/>ASSERTION"])
    22["2f1526b7<br/>#quot;1684274400#quot;"]
    23["43107349<br/>#quot;88.2#quot;"]
    24(["6c1c9479<br/>ASSERTION"])
    25["44b6e7a7<br/>#quot;stepInfoBlur#quot;"]
    26(("a737c4df<br/>NODE"))
    27["d1395bd4<br/>#quot;20230516#quot;"]
    28(["2df0a5cc<br/>ASSERTION"])
    29["2f1526b7<br/>#quot;1684274400#quot;"]
    30["7c885771<br/>#quot;502#quot;"]
    31(["604028fc<br/>ASSERTION"])
    32["6a85544b<br/>#quot;1684188300#quot;"]
    33["4ad8ba7a<br/>#quot;470#quot;"]
    34(["d34d3e9e<br/>ASSERTION"])
    35["44b6e7a7<br/>#quot;stepInfoBlur#quot;"]
    36(("f3be2a5c<br/>NODE"))
    37["33241d8f<br/>#quot;20230515#quot;"]
    38(["e7984694<br/>ASSERTION"])
    39["2946850e<br/>#quot;1684188000#quot;"]
    40["2b12242f<br/>#quot;9#quot;"]
    41(["f741f132<br/>ASSERTION"])
    42["6a85544b<br/>#quot;1684188300#quot;"]
    43["626e242b<br/>#quot;67#quot;"]
    44(["fc3075d7<br/>ASSERTION"])
    45["57e0b082<br/>#quot;heartInfoBlur#quot;"]
    46(("f869cea1<br/>NODE"))
    47["33241d8f<br/>#quot;20230515#quot;"]
    48(["5102c67e<br/>ASSERTION"])
    49["6a85544b<br/>#quot;1684188300#quot;"]
    50["0b1d9a73<br/>#quot;59.6#quot;"]
    51(["9de9f69a<br/>ASSERTION"])
    52["2946850e<br/>#quot;1684188000#quot;"]
    53["e975becd<br/>#quot;59.4#quot;"]
    54(["f77b895c<br/>ASSERTION"])
    55[/"9d7ba9eb<br/>3"/]
    56(("19f337dc<br/>NODE"))
    57["713b9bb9<br/>Signature"]
    58(["7d615ea2<br/>ASSERTION"])
    59[/"49a5f41b<br/>4"/]
    60["a64543c3<br/>#quot;Signed by Clinical Trial Inc.#quot;"]
    1 -->|subj| 2
    2 -->|subj| 3
    3 -->|subj| 4
    4 -->|subj| 5
    5 -->|subj| 6
    5 --> 7
    7 -->|pred| 8
    7 -->|obj| 9
    9 -->|subj| 10
    9 --> 11
    11 -->|pred| 12
    11 -->|obj| 13
    3 --> 14
    14 -->|pred| 15
    14 -->|obj| 16
    16 -->|subj| 17
    16 --> 18
    18 -->|pred| 19
    18 -->|obj| 20
    16 --> 21
    21 -->|pred| 22
    21 -->|obj| 23
    3 --> 24
    24 -->|pred| 25
    24 -->|obj| 26
    26 -->|subj| 27
    26 --> 28
    28 -->|pred| 29
    28 -->|obj| 30
    26 --> 31
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
    3 --> 44
    44 -->|pred| 45
    44 -->|obj| 46
    46 -->|subj| 47
    46 --> 48
    48 -->|pred| 49
    48 -->|obj| 50
    46 --> 51
    51 -->|pred| 52
    51 -->|obj| 53
    1 --> 54
    54 -->|pred| 55
    54 -->|obj| 56
    56 -->|subj| 57
    56 --> 58
    58 -->|pred| 59
    58 -->|obj| 60
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:red,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:red,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px,stroke-dasharray:5.0 5.0
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:red,stroke-width:3.0px
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
    style 26 stroke:red,stroke-width:3.0px
    style 27 stroke:#55f,stroke-width:3.0px
    style 28 stroke:red,stroke-width:3.0px
    style 29 stroke:#55f,stroke-width:3.0px
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
    style 46 stroke:red,stroke-width:3.0px
    style 47 stroke:#55f,stroke-width:3.0px
    style 48 stroke:red,stroke-width:3.0px
    style 49 stroke:#55f,stroke-width:3.0px
    style 50 stroke:#55f,stroke-width:3.0px
    style 51 stroke:red,stroke-width:3.0px
    style 52 stroke:#55f,stroke-width:3.0px
    style 53 stroke:#55f,stroke-width:3.0px
    style 54 stroke:red,stroke-width:3.0px
    style 55 stroke:#55f,stroke-width:3.0px
    style 56 stroke:red,stroke-width:3.0px
    style 57 stroke:#55f,stroke-width:3.0px
    style 58 stroke:red,stroke-width:3.0px
    style 59 stroke:#55f,stroke-width:3.0px
    style 60 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke:red,stroke-width:2.0px
    linkStyle 2 stroke:red,stroke-width:2.0px
    linkStyle 3 stroke:red,stroke-width:2.0px
    linkStyle 4 stroke:red,stroke-width:2.0px
    linkStyle 5 stroke-width:2.0px
    linkStyle 6 stroke:green,stroke-width:2.0px
    linkStyle 7 stroke:#55f,stroke-width:2.0px
    linkStyle 8 stroke:red,stroke-width:2.0px
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
    linkStyle 25 stroke:red,stroke-width:2.0px
    linkStyle 26 stroke-width:2.0px
    linkStyle 27 stroke:green,stroke-width:2.0px
    linkStyle 28 stroke:#55f,stroke-width:2.0px
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
    linkStyle 45 stroke:red,stroke-width:2.0px
    linkStyle 46 stroke-width:2.0px
    linkStyle 47 stroke:green,stroke-width:2.0px
    linkStyle 48 stroke:#55f,stroke-width:2.0px
    linkStyle 49 stroke-width:2.0px
    linkStyle 50 stroke:green,stroke-width:2.0px
    linkStyle 51 stroke:#55f,stroke-width:2.0px
    linkStyle 52 stroke-width:2.0px
    linkStyle 53 stroke:green,stroke-width:2.0px
    linkStyle 54 stroke:#55f,stroke-width:2.0px
    linkStyle 55 stroke:red,stroke-width:2.0px
    linkStyle 56 stroke-width:2.0px
    linkStyle 57 stroke:green,stroke-width:2.0px
    linkStyle 58 stroke:#55f,stroke-width:2.0px
```

Additional validation could be done ascertaining that specific
protocols such as double-blind data collection had been followed,
signed either by the clinical trial or some third-party verifier.

## Part Four: The COVID-19 Appenix

### 10. Nadia Goes Viral (Herd Privacy)

* **Use Case:** Nadia wants to Support the Public Health of COVID Contact Tracing without Revealing Her Location.
* **Privacy Benefits:** Nadia's location is never revealed.
* **Openness Benefits:** A large, discrete public-health system is able to share in data.

Contact tracing became critically important during the height of the
COVID-19 pandemic. Some of this was analog, such as recordings of
names and phone numbers at restaurants, so that everyone could be
contacted if a COVID case was discovered. More automated, digital
tracing occurred through use the mobile phones and GPS records.

The problem, a recurring one throughout the pandemic, is that there
was no consideration for privacy. Hashed elision of data provide one
way to create that privacy ...

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
