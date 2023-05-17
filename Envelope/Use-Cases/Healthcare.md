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

```mermaid
graph LR
    1(("7ee81185<br/>NODE"))
    2["426f3f8a<br/>#quot;ur:cid/hdcxzoqzispesnbbkohddwbyhtbzzsssd…#quot;"]
    3(["0c431bf4<br/>ASSERTION"])
    4["e6d5fe1d<br/>#quot;gpsInfoFor#quot;"]
    5(("c0b6010b<br/>NODE"))
    6["d1395bd4<br/>#quot;20230516#quot;"]
    7(["48ea0308<br/>ASSERTION"])
    8["c38babe3<br/>#quot;gpsQueue#quot;"]
    9(("1001f564<br/>NODE"))
    10["351bd108<br/>#quot;1684279978#quot;"]
    11(["2fd9a9f6<br/>ASSERTION"])
    12["c744b414<br/>#quot;longitude#quot;"]
    13["0ba21e8c<br/>#quot;41.430278#quot;"]
    14(["73c65070<br/>ASSERTION"])
    15["6cb3c6c3<br/>#quot;latitude#quot;"]
    16["1c649117<br/>#quot;2.456944#quot;"]
    17(["9ed9ae09<br/>ASSERTION"])
    18["3d9de635<br/>#quot;distance#quot;"]
    19["16ab2005<br/>#quot;5230#quot;"]
    20(["afbf62d1<br/>ASSERTION"])
    21["b832c640<br/>#quot;length#quot;"]
    22["bd8d2cf1<br/>#quot;36000#quot;"]
    23(["e5d796a2<br/>ASSERTION"])
    24["2daa2a8c<br/>#quot;status#quot;"]
    25["ce609b5b<br/>#quot;8#quot;"]
    26(["9680b1f0<br/>ASSERTION"])
    27["c38babe3<br/>#quot;gpsQueue#quot;"]
    28(("2faf07eb<br/>NODE"))
    29["2f1526b7<br/>#quot;1684274400#quot;"]
    30(["724dd25c<br/>ASSERTION"])
    31["6cb3c6c3<br/>#quot;latitude#quot;"]
    32["652edf08<br/>#quot;2.122778#quot;"]
    33(["7ca5c4fa<br/>ASSERTION"])
    34["2daa2a8c<br/>#quot;status#quot;"]
    35["4e1195df<br/>#quot;0#quot;"]
    36(["d1b3e563<br/>ASSERTION"])
    37["3d9de635<br/>#quot;distance#quot;"]
    38["4e1195df<br/>#quot;0#quot;"]
    39(["dbeb4907<br/>ASSERTION"])
    40["c744b414<br/>#quot;longitude#quot;"]
    41["7209d09c<br/>#quot;41.380833#quot;"]
    42(["38cadd4f<br/>ASSERTION"])
    43["bb751b0e<br/>#quot;hasPubKey#quot;"]
    44["2ada5820<br/>#quot;ur:crypto-pubkeys/lftaadfwhdcxtkzsswongh…#quot;"]
    45(["54fdeb6b<br/>ASSERTION"])
    46["92f9c9f7<br/>#quot;statsFor#quot;"]
    47(("1e37f086<br/>NODE"))
    48["33241d8f<br/>#quot;20230515#quot;"]
    49(["1cc98900<br/>ASSERTION"])
    50["f16e83e2<br/>#quot;steps#quot;"]
    51["42f3a37b<br/>#quot;5703#quot;"]
    52(["35cd3369<br/>ASSERTION"])
    53["f23f3bfc<br/>#quot;zoneMinutes#quot;"]
    54["4e1195df<br/>#quot;0#quot;"]
    55(["40a7bef0<br/>ASSERTION"])
    56["f7f7e4bc<br/>#quot;restingHeartRate#quot;"]
    57["80a8581f<br/>#quot;55#quot;"]
    58(["61bfb33e<br/>ASSERTION"])
    59["a0650bba<br/>#quot;floors#quot;"]
    60["f46dd28a<br/>#quot;3#quot;"]
    61(["68aa258a<br/>ASSERTION"])
    62["11d623e4<br/>#quot;heartInfoFor#quot;"]
    63(("9023f4a8<br/>NODE"))
    64["33241d8f<br/>#quot;20230515#quot;"]
    65(["6e4f82e5<br/>ASSERTION"])
    66["cd64b3b2<br/>#quot;1684274580#quot;"]
    67["b60123eb<br/>#quot;59#quot;"]
    68(["741f931f<br/>ASSERTION"])
    69["2f1526b7<br/>#quot;1684274400#quot;"]
    70["b60123eb<br/>#quot;59#quot;"]
    71(["862e39c2<br/>ASSERTION"])
    72["6b914b62<br/>#quot;1684274460#quot;"]
    73["a22828e1<br/>#quot;60#quot;"]
    74(["8a49cf0d<br/>ASSERTION"])
    75["50d21476<br/>#quot;1684274520#quot;"]
    76["a22828e1<br/>#quot;60#quot;"]
    77(["faf69fa5<br/>ASSERTION"])
    78["8712e00c<br/>#quot;1684274640#quot;"]
    79["b60123eb<br/>#quot;59#quot;"]
    80(["6d10f367<br/>ASSERTION"])
    81["92f9c9f7<br/>#quot;statsFor#quot;"]
    82(("3cacd1b4<br/>NODE"))
    83["d1395bd4<br/>#quot;20230516#quot;"]
    84(["098da37b<br/>ASSERTION"])
    85["f16e83e2<br/>#quot;steps#quot;"]
    86["1111a5a3<br/>#quot;10715#quot;"]
    87(["307680cd<br/>ASSERTION"])
    88["f7f7e4bc<br/>#quot;restingHeartRate#quot;"]
    89["4975d480<br/>#quot;56#quot;"]
    90(["5929a395<br/>ASSERTION"])
    91["a0650bba<br/>#quot;floors#quot;"]
    92["17bb42fe<br/>#quot;17#quot;"]
    93(["9c1f47ee<br/>ASSERTION"])
    94["f23f3bfc<br/>#quot;zoneMinutes#quot;"]
    95["fd2d4cab<br/>#quot;25#quot;"]
    96(["70dab175<br/>ASSERTION"])
    97["11d623e4<br/>#quot;heartInfoFor#quot;"]
    98(("561906da<br/>NODE"))
    99["d1395bd4<br/>#quot;20230516#quot;"]
    100(["162a512b<br/>ASSERTION"])
    101["2f1526b7<br/>#quot;1684274400#quot;"]
    102["95b2a1ed<br/>#quot;85#quot;"]
    103(["8303ec5a<br/>ASSERTION"])
    104["8712e00c<br/>#quot;1684274640#quot;"]
    105["52397972<br/>#quot;88#quot;"]
    106(["855cab99<br/>ASSERTION"])
    107["6b914b62<br/>#quot;1684274460#quot;"]
    108["9794c2ca<br/>#quot;87#quot;"]
    109(["ab890f24<br/>ASSERTION"])
    110["cd64b3b2<br/>#quot;1684274580#quot;"]
    111["708fa63f<br/>#quot;90#quot;"]
    112(["b5b8fb50<br/>ASSERTION"])
    113["50d21476<br/>#quot;1684274520#quot;"]
    114["8ad66d3a<br/>#quot;91#quot;"]
    115(["7b5d58b3<br/>ASSERTION"])
    116["f0b86b19<br/>#quot;stepInfoFor#quot;"]
    117(("8d9567bc<br/>NODE"))
    118["d1395bd4<br/>#quot;20230516#quot;"]
    119(["27d14831<br/>ASSERTION"])
    120["6b914b62<br/>#quot;1684274460#quot;"]
    121["3fb7eaa9<br/>#quot;99#quot;"]
    122(["43a49bc0<br/>ASSERTION"])
    123["cd64b3b2<br/>#quot;1684274580#quot;"]
    124["c1be0983<br/>#quot;103#quot;"]
    125(["b024b855<br/>ASSERTION"])
    126["2f1526b7<br/>#quot;1684274400#quot;"]
    127["ea096567<br/>#quot;95#quot;"]
    128(["bcfc9179<br/>ASSERTION"])
    129["50d21476<br/>#quot;1684274520#quot;"]
    130["c1be0983<br/>#quot;103#quot;"]
    131(["e6fb9011<br/>ASSERTION"])
    132["8712e00c<br/>#quot;1684274640#quot;"]
    133["3e64ff30<br/>#quot;101#quot;"]
    134(["e3a0d6bf<br/>ASSERTION"])
    135["f0b86b19<br/>#quot;stepInfoFor#quot;"]
    136(("fd518b9b<br/>NODE"))
    137["33241d8f<br/>#quot;20230515#quot;"]
    138(["3d3dbd15<br/>ASSERTION"])
    139["50d21476<br/>#quot;1684274520#quot;"]
    140["20377cec<br/>#quot;7#quot;"]
    141(["45c5674b<br/>ASSERTION"])
    142["cd64b3b2<br/>#quot;1684274580#quot;"]
    143["2c3a4249<br/>#quot;2#quot;"]
    144(["6382d762<br/>ASSERTION"])
    145["2946850e<br/>#quot;1684188000#quot;"]
    146["4e1195df<br/>#quot;0#quot;"]
    147(["74856b9f<br/>ASSERTION"])
    148["6b914b62<br/>#quot;1684274460#quot;"]
    149["4e1195df<br/>#quot;0#quot;"]
    150(["d1d5c733<br/>ASSERTION"])
    151["8712e00c<br/>#quot;1684274640#quot;"]
    152["4e1195df<br/>#quot;0#quot;"]
    1 -->|subj| 2
    1 --> 3
    3 -->|pred| 4
    3 -->|obj| 5
    5 -->|subj| 6
    5 --> 7
    7 -->|pred| 8
    7 -->|obj| 9
    9 -->|subj| 10
    9 --> 11
    11 -->|pred| 12
    11 -->|obj| 13
    9 --> 14
    14 -->|pred| 15
    14 -->|obj| 16
    9 --> 17
    17 -->|pred| 18
    17 -->|obj| 19
    9 --> 20
    20 -->|pred| 21
    20 -->|obj| 22
    9 --> 23
    23 -->|pred| 24
    23 -->|obj| 25
    5 --> 26
    26 -->|pred| 27
    26 -->|obj| 28
    28 -->|subj| 29
    28 --> 30
    30 -->|pred| 31
    30 -->|obj| 32
    28 --> 33
    33 -->|pred| 34
    33 -->|obj| 35
    28 --> 36
    36 -->|pred| 37
    36 -->|obj| 38
    28 --> 39
    39 -->|pred| 40
    39 -->|obj| 41
    1 --> 42
    42 -->|pred| 43
    42 -->|obj| 44
    1 --> 45
    45 -->|pred| 46
    45 -->|obj| 47
    47 -->|subj| 48
    47 --> 49
    49 -->|pred| 50
    49 -->|obj| 51
    47 --> 52
    52 -->|pred| 53
    52 -->|obj| 54
    47 --> 55
    55 -->|pred| 56
    55 -->|obj| 57
    47 --> 58
    58 -->|pred| 59
    58 -->|obj| 60
    1 --> 61
    61 -->|pred| 62
    61 -->|obj| 63
    63 -->|subj| 64
    63 --> 65
    65 -->|pred| 66
    65 -->|obj| 67
    63 --> 68
    68 -->|pred| 69
    68 -->|obj| 70
    63 --> 71
    71 -->|pred| 72
    71 -->|obj| 73
    63 --> 74
    74 -->|pred| 75
    74 -->|obj| 76
    63 --> 77
    77 -->|pred| 78
    77 -->|obj| 79
    1 --> 80
    80 -->|pred| 81
    80 -->|obj| 82
    82 -->|subj| 83
    82 --> 84
    84 -->|pred| 85
    84 -->|obj| 86
    82 --> 87
    87 -->|pred| 88
    87 -->|obj| 89
    82 --> 90
    90 -->|pred| 91
    90 -->|obj| 92
    82 --> 93
    93 -->|pred| 94
    93 -->|obj| 95
    1 --> 96
    96 -->|pred| 97
    96 -->|obj| 98
    98 -->|subj| 99
    98 --> 100
    100 -->|pred| 101
    100 -->|obj| 102
    98 --> 103
    103 -->|pred| 104
    103 -->|obj| 105
    98 --> 106
    106 -->|pred| 107
    106 -->|obj| 108
    98 --> 109
    109 -->|pred| 110
    109 -->|obj| 111
    98 --> 112
    112 -->|pred| 113
    112 -->|obj| 114
    1 --> 115
    115 -->|pred| 116
    115 -->|obj| 117
    117 -->|subj| 118
    117 --> 119
    119 -->|pred| 120
    119 -->|obj| 121
    117 --> 122
    122 -->|pred| 123
    122 -->|obj| 124
    117 --> 125
    125 -->|pred| 126
    125 -->|obj| 127
    117 --> 128
    128 -->|pred| 129
    128 -->|obj| 130
    117 --> 131
    131 -->|pred| 132
    131 -->|obj| 133
    1 --> 134
    134 -->|pred| 135
    134 -->|obj| 136
    136 -->|subj| 137
    136 --> 138
    138 -->|pred| 139
    138 -->|obj| 140
    136 --> 141
    141 -->|pred| 142
    141 -->|obj| 143
    136 --> 144
    144 -->|pred| 145
    144 -->|obj| 146
    136 --> 147
    147 -->|pred| 148
    147 -->|obj| 149
    136 --> 150
    150 -->|pred| 151
    150 -->|obj| 152
    style 1 stroke:red,stroke-width:3.0px
    style 2 stroke:#55f,stroke-width:3.0px
    style 3 stroke:red,stroke-width:3.0px
    style 4 stroke:#55f,stroke-width:3.0px
    style 5 stroke:red,stroke-width:3.0px
    style 6 stroke:#55f,stroke-width:3.0px
    style 7 stroke:red,stroke-width:3.0px
    style 8 stroke:#55f,stroke-width:3.0px
    style 9 stroke:red,stroke-width:3.0px
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
    style 28 stroke:red,stroke-width:3.0px
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
    style 57 stroke:#55f,stroke-width:3.0px
    style 58 stroke:red,stroke-width:3.0px
    style 59 stroke:#55f,stroke-width:3.0px
    style 60 stroke:#55f,stroke-width:3.0px
    style 61 stroke:red,stroke-width:3.0px
    style 62 stroke:#55f,stroke-width:3.0px
    style 63 stroke:red,stroke-width:3.0px
    style 64 stroke:#55f,stroke-width:3.0px
    style 65 stroke:red,stroke-width:3.0px
    style 66 stroke:#55f,stroke-width:3.0px
    style 67 stroke:#55f,stroke-width:3.0px
    style 68 stroke:red,stroke-width:3.0px
    style 69 stroke:#55f,stroke-width:3.0px
    style 70 stroke:#55f,stroke-width:3.0px
    style 71 stroke:red,stroke-width:3.0px
    style 72 stroke:#55f,stroke-width:3.0px
    style 73 stroke:#55f,stroke-width:3.0px
    style 74 stroke:red,stroke-width:3.0px
    style 75 stroke:#55f,stroke-width:3.0px
    style 76 stroke:#55f,stroke-width:3.0px
    style 77 stroke:red,stroke-width:3.0px
    style 78 stroke:#55f,stroke-width:3.0px
    style 79 stroke:#55f,stroke-width:3.0px
    style 80 stroke:red,stroke-width:3.0px
    style 81 stroke:#55f,stroke-width:3.0px
    style 82 stroke:red,stroke-width:3.0px
    style 83 stroke:#55f,stroke-width:3.0px
    style 84 stroke:red,stroke-width:3.0px
    style 85 stroke:#55f,stroke-width:3.0px
    style 86 stroke:#55f,stroke-width:3.0px
    style 87 stroke:red,stroke-width:3.0px
    style 88 stroke:#55f,stroke-width:3.0px
    style 89 stroke:#55f,stroke-width:3.0px
    style 90 stroke:red,stroke-width:3.0px
    style 91 stroke:#55f,stroke-width:3.0px
    style 92 stroke:#55f,stroke-width:3.0px
    style 93 stroke:red,stroke-width:3.0px
    style 94 stroke:#55f,stroke-width:3.0px
    style 95 stroke:#55f,stroke-width:3.0px
    style 96 stroke:red,stroke-width:3.0px
    style 97 stroke:#55f,stroke-width:3.0px
    style 98 stroke:red,stroke-width:3.0px
    style 99 stroke:#55f,stroke-width:3.0px
    style 100 stroke:red,stroke-width:3.0px
    style 101 stroke:#55f,stroke-width:3.0px
    style 102 stroke:#55f,stroke-width:3.0px
    style 103 stroke:red,stroke-width:3.0px
    style 104 stroke:#55f,stroke-width:3.0px
    style 105 stroke:#55f,stroke-width:3.0px
    style 106 stroke:red,stroke-width:3.0px
    style 107 stroke:#55f,stroke-width:3.0px
    style 108 stroke:#55f,stroke-width:3.0px
    style 109 stroke:red,stroke-width:3.0px
    style 110 stroke:#55f,stroke-width:3.0px
    style 111 stroke:#55f,stroke-width:3.0px
    style 112 stroke:red,stroke-width:3.0px
    style 113 stroke:#55f,stroke-width:3.0px
    style 114 stroke:#55f,stroke-width:3.0px
    style 115 stroke:red,stroke-width:3.0px
    style 116 stroke:#55f,stroke-width:3.0px
    style 117 stroke:red,stroke-width:3.0px
    style 118 stroke:#55f,stroke-width:3.0px
    style 119 stroke:red,stroke-width:3.0px
    style 120 stroke:#55f,stroke-width:3.0px
    style 121 stroke:#55f,stroke-width:3.0px
    style 122 stroke:red,stroke-width:3.0px
    style 123 stroke:#55f,stroke-width:3.0px
    style 124 stroke:#55f,stroke-width:3.0px
    style 125 stroke:red,stroke-width:3.0px
    style 126 stroke:#55f,stroke-width:3.0px
    style 127 stroke:#55f,stroke-width:3.0px
    style 128 stroke:red,stroke-width:3.0px
    style 129 stroke:#55f,stroke-width:3.0px
    style 130 stroke:#55f,stroke-width:3.0px
    style 131 stroke:red,stroke-width:3.0px
    style 132 stroke:#55f,stroke-width:3.0px
    style 133 stroke:#55f,stroke-width:3.0px
    style 134 stroke:red,stroke-width:3.0px
    style 135 stroke:#55f,stroke-width:3.0px
    style 136 stroke:red,stroke-width:3.0px
    style 137 stroke:#55f,stroke-width:3.0px
    style 138 stroke:red,stroke-width:3.0px
    style 139 stroke:#55f,stroke-width:3.0px
    style 140 stroke:#55f,stroke-width:3.0px
    style 141 stroke:red,stroke-width:3.0px
    style 142 stroke:#55f,stroke-width:3.0px
    style 143 stroke:#55f,stroke-width:3.0px
    style 144 stroke:red,stroke-width:3.0px
    style 145 stroke:#55f,stroke-width:3.0px
    style 146 stroke:#55f,stroke-width:3.0px
    style 147 stroke:red,stroke-width:3.0px
    style 148 stroke:#55f,stroke-width:3.0px
    style 149 stroke:#55f,stroke-width:3.0px
    style 150 stroke:red,stroke-width:3.0px
    style 151 stroke:#55f,stroke-width:3.0px
    style 152 stroke:#55f,stroke-width:3.0px
    linkStyle 0 stroke:red,stroke-width:2.0px
    linkStyle 1 stroke-width:2.0px
    linkStyle 2 stroke:green,stroke-width:2.0px
    linkStyle 3 stroke:#55f,stroke-width:2.0px
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
    linkStyle 27 stroke:red,stroke-width:2.0px
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
    linkStyle 56 stroke-width:2.0px
    linkStyle 57 stroke:green,stroke-width:2.0px
    linkStyle 58 stroke:#55f,stroke-width:2.0px
    linkStyle 59 stroke-width:2.0px
    linkStyle 60 stroke:green,stroke-width:2.0px
    linkStyle 61 stroke:#55f,stroke-width:2.0px
    linkStyle 62 stroke:red,stroke-width:2.0px
    linkStyle 63 stroke-width:2.0px
    linkStyle 64 stroke:green,stroke-width:2.0px
    linkStyle 65 stroke:#55f,stroke-width:2.0px
    linkStyle 66 stroke-width:2.0px
    linkStyle 67 stroke:green,stroke-width:2.0px
    linkStyle 68 stroke:#55f,stroke-width:2.0px
    linkStyle 69 stroke-width:2.0px
    linkStyle 70 stroke:green,stroke-width:2.0px
    linkStyle 71 stroke:#55f,stroke-width:2.0px
    linkStyle 72 stroke-width:2.0px
    linkStyle 73 stroke:green,stroke-width:2.0px
    linkStyle 74 stroke:#55f,stroke-width:2.0px
    linkStyle 75 stroke-width:2.0px
    linkStyle 76 stroke:green,stroke-width:2.0px
    linkStyle 77 stroke:#55f,stroke-width:2.0px
    linkStyle 78 stroke-width:2.0px
    linkStyle 79 stroke:green,stroke-width:2.0px
    linkStyle 80 stroke:#55f,stroke-width:2.0px
    linkStyle 81 stroke:red,stroke-width:2.0px
    linkStyle 82 stroke-width:2.0px
    linkStyle 83 stroke:green,stroke-width:2.0px
    linkStyle 84 stroke:#55f,stroke-width:2.0px
    linkStyle 85 stroke-width:2.0px
    linkStyle 86 stroke:green,stroke-width:2.0px
    linkStyle 87 stroke:#55f,stroke-width:2.0px
    linkStyle 88 stroke-width:2.0px
    linkStyle 89 stroke:green,stroke-width:2.0px
    linkStyle 90 stroke:#55f,stroke-width:2.0px
    linkStyle 91 stroke-width:2.0px
    linkStyle 92 stroke:green,stroke-width:2.0px
    linkStyle 93 stroke:#55f,stroke-width:2.0px
    linkStyle 94 stroke-width:2.0px
    linkStyle 95 stroke:green,stroke-width:2.0px
    linkStyle 96 stroke:#55f,stroke-width:2.0px
    linkStyle 97 stroke:red,stroke-width:2.0px
    linkStyle 98 stroke-width:2.0px
    linkStyle 99 stroke:green,stroke-width:2.0px
    linkStyle 100 stroke:#55f,stroke-width:2.0px
    linkStyle 101 stroke-width:2.0px
    linkStyle 102 stroke:green,stroke-width:2.0px
    linkStyle 103 stroke:#55f,stroke-width:2.0px
    linkStyle 104 stroke-width:2.0px
    linkStyle 105 stroke:green,stroke-width:2.0px
    linkStyle 106 stroke:#55f,stroke-width:2.0px
    linkStyle 107 stroke-width:2.0px
    linkStyle 108 stroke:green,stroke-width:2.0px
    linkStyle 109 stroke:#55f,stroke-width:2.0px
    linkStyle 110 stroke-width:2.0px
    linkStyle 111 stroke:green,stroke-width:2.0px
    linkStyle 112 stroke:#55f,stroke-width:2.0px
    linkStyle 113 stroke-width:2.0px
    linkStyle 114 stroke:green,stroke-width:2.0px
    linkStyle 115 stroke:#55f,stroke-width:2.0px
    linkStyle 116 stroke:red,stroke-width:2.0px
    linkStyle 117 stroke-width:2.0px
    linkStyle 118 stroke:green,stroke-width:2.0px
    linkStyle 119 stroke:#55f,stroke-width:2.0px
    linkStyle 120 stroke-width:2.0px
    linkStyle 121 stroke:green,stroke-width:2.0px
    linkStyle 122 stroke:#55f,stroke-width:2.0px
    linkStyle 123 stroke-width:2.0px
    linkStyle 124 stroke:green,stroke-width:2.0px
    linkStyle 125 stroke:#55f,stroke-width:2.0px
    linkStyle 126 stroke-width:2.0px
    linkStyle 127 stroke:green,stroke-width:2.0px
    linkStyle 128 stroke:#55f,stroke-width:2.0px
    linkStyle 129 stroke-width:2.0px
    linkStyle 130 stroke:green,stroke-width:2.0px
    linkStyle 131 stroke:#55f,stroke-width:2.0px
    linkStyle 132 stroke-width:2.0px
    linkStyle 133 stroke:green,stroke-width:2.0px
    linkStyle 134 stroke:#55f,stroke-width:2.0px
    linkStyle 135 stroke:red,stroke-width:2.0px
    linkStyle 136 stroke-width:2.0px
    linkStyle 137 stroke:green,stroke-width:2.0px
    linkStyle 138 stroke:#55f,stroke-width:2.0px
    linkStyle 139 stroke-width:2.0px
    linkStyle 140 stroke:green,stroke-width:2.0px
    linkStyle 141 stroke:#55f,stroke-width:2.0px
    linkStyle 142 stroke-width:2.0px
    linkStyle 143 stroke:green,stroke-width:2.0px
    linkStyle 144 stroke:#55f,stroke-width:2.0px
    linkStyle 145 stroke-width:2.0px
    linkStyle 146 stroke:green,stroke-width:2.0px
    linkStyle 147 stroke:#55f,stroke-width:2.0px
    linkStyle 148 stroke-width:2.0px
    linkStyle 149 stroke:green,stroke-width:2.0px
    linkStyle 150 stroke:#55f,stroke-width:2.0px
```

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


