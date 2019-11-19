//
//  ScriptEnum.swift
//  StandUp
//
//  Created by Peter on 31/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

public enum SCRIPT: String {
    
    case checkForBitcoin = "(do shell script \"~/StandUp/BitcoinCore/bitcoin-0.19.0rc3/bin/bitcoind --version; exit\")"
    case checkForTor = "(do shell script \"/usr/local/bin/tor --version; exit\")"
    case getTorrc = "(do shell script \"cat /usr/local/etc/tor/torrc; exit\")"
    case getRPCCredentials = "(do shell script \"cat ~/Library/Application*Support/Bitcoin/bitcoin.conf; exit\")"
    case getTorHostname = "(do shell script \"cat /usr/local/var/lib/tor/standup/hostname; exit\")"
    case isBitcoinOn = "(do shell script \"~/StandUp/BitcoinCore/bitcoin-0.19.0rc3/bin/bitcoin-cli getblockchaininfo; exit\")"
    case stopBitcoin = "(do shell script \"~/StandUp/BitcoinCore/bitcoin-0.19.0rc3/bin/bitcoin-cli stop; exit\")"
    case removeBitcoin = "(do shell script \"rm -R ~/Library/Application*Support/Bitcoin; exit\")"
    case torStatus = "(do shell script \"/usr/local/bin/brew services list; exit\")"
    case verifyBitcoin = "(do shell script \"cd ~/StandUp/BitcoinCore; shasum -c SHA256SUMS.asc 2<&1 | grep bitcoin-0.19.0rc3-osx64.tar.gz; exit\")"
    
    case standUp = "StandUp"
    case startTor = "StartTor"
    case stopTor = "StopTor"
    case startBitcoinqt = "LaunchBitcoin"
    case verifySigs = "Verify"
    case authenticate = "Authenticate"
    case standDown = "StandDown"
    case updateBTCConf = "UpdateBTCConf"
    
}

public enum BTCCONF: String {
    
    case pruned = "pruned"
    case txIndex = "txIndex"
    case mainnet = "mainnet"
    case testnet = "testnet"
    case regtest = "regtest"
    case walletdisabled = "walletdisabled"
    case datadir = "datadir"
    
}
