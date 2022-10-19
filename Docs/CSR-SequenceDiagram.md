# Sequence Diagrams for CSR Share Servers

This set of exemplar sequence diagrams for a CSR Share Servers assumes the sample commands in [ExampleStore](https://github.com/BlockchainCommons/BCSwiftFoundation/blob/d355f0847d8bea9bac5fba8ddfdb8c29c281f9f7/Tests/BCFoundationTests/ExampleStore/ExampleStore.swift). It is not necessarily the only way to construct the flow of similar functions.

## I. Data Flow: Storing & Retrieving a Share

The standard data flow for a share server involves the storage of data and the later retrieval of that data.

```mermaid
sequenceDiagram
actor Alice
participant localAPI
participant storeShare
participant storage
Note over Alice,storage: Data Storage
Alice->>localAPI: request(ID,keyPair,storeShare,data)
localAPI->>storeShare: storeShare(data,pubKey,signature)
alt isPubKeyNew?
    storeShare->>storage: createAccount(pubKey)
end    
storeShare->>storage: addShare(pubKey,data)
storeShare->>localAPI: receipt
localAPI->>Alice: response(ID, receipt)

Note over Alice,storage: Data Retrieval
Alice->>localAPI: request(ID,keyPair,retrieveShares,receipts?)
localAPI->>storeShare: retrieveShares(receipts?,pubKey,signature)
storeShare->>storage: retrieveData(pubKey,receipts?)
alt Receipts? Yes
    storage->>storeShare: selectedShares
else Receipts? No
    storage->>storeShare: allShares
end    
storeShare->>localAPI: data
localAPI->>Alice: response(ID, data)
```

## II. Data Flow: Establishing & Using Fallbacks

One of the [Gordian Principles](https://github.com/BlockchainCommons/Gordian#gordian-principles) is "resilience". In particular, making it hard for a user to lose their data is a core architectural requirement. For our CSR model, this is done via a fallback. This creates an additional data flow: the user may establish a fallback, and if they do and later lose their keypair, they may use the fallback to reset the keypair. 

It's vitally important that a user establish a fallback shortly after storing their initial data, because until they do, their keypair remains a Single Point of Failure (SPOF). Requiring a fallback, though technically optional, should thus be considered a step in the Data Flow immediately after Data Storage.

```mermaid
sequenceDiagram
actor Alice
participant localAPI
participant storeShare
participant storage
participant auth

Note over Alice,auth: Fallback Creation
Alice->>localAPI: request(ID,keyPair,updateFallback,fallback)
localAPI->>storeShare: updateFallback(fallback,pubKey,signature)
storeShare->>storage: addFallback(pubKey,fallback)
storage->>storeShare: OK
storeShare->>localAPI: OK
localAPI->>Alice: response(ID,OK)

Note over Alice,auth: Fallback Retrieval
Alice->>localAPI: request(ID,keyPair,retrieveFallback)
localAPI->>storeShare: retrieveFallback(pubKey,signature)
storeShare->>storage: retrieveFallback(pubKey)
storage->>storeShare: fallback
storeShare->>localAPI: fallback
localAPI->>Alice: response(ID,fallback)

Note over Alice,auth: Fallback Usage
Alice->>localAPI: request(ID,newKeyPair,fallbackTransfer,fallback)
localAPI->>storeShare: fallbackTransfer(fallback,newPubKey,newSignature)
storeShare-->>auth: initiateFallback
auth-->>Alice: requestFallbackVerification
Alice-->>auth: verifyFallback
auth-->>storeShare: verifyFallback
storeShare->>storeShare: updatePublicKey(newPubKey,pubKey)
storeShare->>storage: updateAccount(pubKey,newPubKey)
storage->>storeShare: OK
storeShare->>localAPI: OK
localAPI->>Alice: response(ID,OK)
```
The `updatePublicKey` function can also be triggered directly by a user.

```mermaid
sequenceDiagram
actor Alice
participant localAPI
participant storeShare
participant storage

Note over Alice,storage: Key Update
Alice->>localAPI: request(ID,keyPair,updatePublicKey,newPubKey)
localAPI->>storeShare: updatePublicKey(newPubKey,pubKey,signature)
storeShare->>storage: updateAccount(pubKey,newPubKey)
storage->>storeShare: OK
storeShare->>localAPI: OK
localAPI->>Alice: response(ID,OK)
```

## IIIa. Data Flow: Deleting a Share

The lifecycle of a share in a share server usually ends with a deletion command.

This might be a deletion of some or all shares, which might occur prior to re-entry into the system with a new `storeShare` request.

```mermaid
sequenceDiagram
actor Alice
participant localAPI
participant storeShare
participant storage

Note over Alice,storage: Data Deletion
Alice->>localAPI: request(ID,keyPair,deleteShares,receipts)
localAPI->>storeShare: deleteShares(receipts,pubKey,signature)
alt Receipts? Yes
storeShare->>storage: deleteData(pubKey,receipts)
else Receipts? No
storeShare->>storage: deleteData(pubKey,ALL)
end    
storage->>storeShare: OK
storeShare->>localAPI: OK
localAPI->>Alice: response(ID,OK)
```

## IIIb. Data Flow: Deleting an Account

Alternatively, a user might decide to delete their account with a share server entirely.

```mermaid
sequenceDiagram
actor Alice
participant localAPI
participant storeShare
participant storage

Note over Alice,storage: Data Deletion
Alice->>localAPI: request(ID,keyPair,deleteAccount)
localAPI->>storeShare: deleteAccount(pubKey,signature)
storeShare->>storage: deleteAccount(pubKey)
storage->>storeShare: OK
storeShare->>localAPI: OK
localAPI->>Alice: response(ID,OK)
```


