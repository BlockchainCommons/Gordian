//
//  ScriptEnum.swift
//  StandUp
//
//  Created by Peter on 31/10/19.
//  Copyright © 2019 Blockchain Commons, LLC
//

import Foundation

public enum SCRIPT: String {
    
    case removeBitcoin = "RemoveBitcoin"
    case torStatus = "TorStatus"
    case getTorHostname = "GetHostname"
    case getRPCCredentials = "GetBitcoinConf"
    case getTorrc = "GetTorrc"
    case checkForTor = "CheckForTor"
    case verifyBitcoin = "Verify"
    case stopBitcoin = "StopBitcoin"
    case isBitcoinOn = "IsBitcoinOn"
    case checkForBitcoin = "CheckForBitcoinCore"
    case standUp = "StandUp"
    case startTor = "StartTor"
    case stopTor = "StopTor"
    case startBitcoinqt = "LaunchBitcoin"
    case authenticate = "Authenticate"
    case standDown = "StandDown"
    case updateBTCConf = "UpdateBTCConf"
    case upgradeBitcoin = "UpgradeBitcoin"
    case refreshHS = "RefreshHS"
    case showBitcoinLog = "ShowBitcoinCoreLog"
    case showTorLog = "ShowTorLog"
    case checkStandUp = "CheckStandUp"
    
}

public enum BTCCONF: String {
    
    case prune = "prune"
    case txindex = "txindex"
    case mainnet = "mainnet"
    case testnet = "testnet"
    case regtest = "regtest"
    case disablewallet = "disablewallet"
    case datadir = "datadir"
    
}
