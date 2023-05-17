# Gordian Envelope Use Cases: Health Care

[intro]

## Health Care Use Case Table of Contents

[intro]

## Part One: Personal Sensor Data

This first set of use cases details engineer Nadia's work designing a
new wearable activity tracker, the ToneZone, which will focus on
keeping her data private.

### 1. Nadia Gets Fit (Metadata)

* **Use Case:** Nadia need a wearable activity tracker that can store her data.
* **Openness Benefits:** Nadia uses a self-describing format that ensures that her data will be readable in the far future.

Nadia has used a wearable activity tracker for years, but she's slowly
become aware that she's playing with fire. She's storing away high
levels of very personal data about her health and her location, and
she has no assurance that any of the data is actually safe and
secure. As a result, Nadia decides to design her own data tracker, the
ToneZone. Its not priority will be securing data (and its secondary
priority will be sharing that data as its user sees fit, but that
issue will be down the road a bit).

The first thing that Nadia has to do is to design her data
format. This is easy to do using Gordian Envelope, which allows for
the encoding of tiered data laid out as assertions.

While deciding how to lay out her info, Nadia has to think about not
just a simple-to-use structure, but also a structure that will allow
for the individual selection (and elision) of specific data. She
settles on the following:
```
"ur:cid/hdcxzoqzispesnbbkohddwbyhtbzzsssdldassamdeeofdtndsaazsjpdtnnvwfnatglbgbnehwe" [
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
    "hasPubKey": "ur:crypto-pubkeys/lftaadfwhdcxtkzsswonghpdemptcpludkktialnnyzmadtldlbstabwwmecvtfghkckfztldemwtaaddmhdcxryptseesdrjpssbzwmoxwkvleyrnbgnszoatatqzglpaetdelfnbpyglaotlktcyfllubzeh"
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
        "1684274460": "0"
        "1684274520": "7"
        "1684274580": "2"
        "1684274640": "0"
    ]
    "stepInfoFor": "20230516" [
        "1684274400": "95"
        "1684274460": "99"
        "1684274520": "103"
        "1684274580": "103"
        "1684274640": "101"
    ]
]
```
[see the mermaid diagram](Healthcare-mermaid-1a.md)

(Obviously, the actual ToneZone tracker will have _lots_ more data
both total and for each day. This is just a cut-down example intended
to show some of the functionality possible.)

Data is divided out among several categories and also for individual
days. This will make it easy for Nadia in the future to differentiate
highly personal data (such as `gpsInfoFor`) and more general data
(such as `statsFor`) and also to do it on a granular, daily basis.

More importantly, the whole data structure is cleanly
self-describing. The Google Envelope assertions clearly denote each
type of data, while some data is additional stored as a [Uniform
Resource
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

[This is where she really starts to differentiate her tracker from
others on the market]

### 3. Nadia Protects Her Key (SSKR)

* **Use Case:** Nadia needs to ensure that her private key isn't a
single point of failure for her data!
* **Openness Benefits:** Using an open-sharding system, Nadia ensures
that her key can be recovered easily.
* **Resilience Benefits:** SSKR allows Nadia to remove her SPOF while
keeping her key secure.

## Part Two: Shared Sensor Data

[Nadia has protected her data, but now she also wants to share her
data selectively, as she choses.]

### 4. Nadia Hearts Her Doctor (Elision)

* **Use Case:** Nadia wants to share a selection of her data with her doctor.
* **Independence Benefits:** Nadia can choose exactly what data to send.
* **Privacy Benefits:** Nadia can cut out data that she doesn't want to share.
* **Openness Benefits:** The self-describing format means that the doctor's app can easily unspool Nadia's data.

[Nada shares just her heartrate info with her doctor]

### 5. Nadia is a Bit Remote (Multi-Permit)

* **Use Case:** Because of irregularities in her heart rate, Nadia wants to regularly share her data with a third-party health monitoring agency.
* **Privacy Benefits:** By creating multi-permits, Nadia can decide exactly what third-parties have access to her data.
* **Openness Benefits:** Like the doctor, the health monitoring agency can read the data because of its self-describing format.

[heart condition, keeps someone remote up to date using SSKR]

### 6. Nadia Steps Up (Signature)

* **Use Case:** Nadia wants to submit validated step data to a stepping contest.
* **Privacy Benefits:** Multiple signatures assure everyone that the data is valid.
* **Openness Benefits:** This is another example of how self-describing data can open many doors.

[step contest; signed by Nadia and signed by ToneZone.]]

### 7. Nadia Gets Clinical (Proof of Inclusion)

* **Use Case:** Nadia wants to submit data to a clinical try, and to later prove that she did.
* **Privacy Benefits:** Nadia only reveals that her data is part of the clinical try when she chooses to do so.
* **Openness Benefits:** Clinical trials are one of the most important communities that can benefit from open data.

[reveal data with hashed public key, and then later reveal public key in a message signed by private key]

### 8. Nadia Goes Viral (Herd Privacy)

* **Use Case:** Nadia wants to Support the Public Health of COVID Contact Tracing without Revealing Her Location.
* **Privacy Benefits:** Nadia's location is never revealed.
* **Openness Benefits:** A large, discrete public-health system is able to share in data.

[Nadia's redacted location is uploaded; a private key can let her update it with a flag if she has COVID; a one-time contact lets her know if someone else does.]

