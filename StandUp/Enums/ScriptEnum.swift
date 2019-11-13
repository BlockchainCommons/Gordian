//
//  ScriptEnum.swift
//  StandUp
//
//  Created by Peter on 31/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

public enum SCRIPT: String {
    
    case checkForBitcoin = "(do shell script \"~/StandUp/BitcoinCore0.19.0/bitcoin-0.19.0rc3/bin/bitcoind --version\")"
    case checkForTor = "(do shell script \"/usr/local/bin/tor --version\")"
    case getTorrc = "(do shell script \"cat /usr/local/etc/tor/torrc\")"
    case getRPCCredentials = "(do shell script \"cat ~/Library/Application*Support/Bitcoin/bitcoin.conf\")"
    case getTorHostname = "(do shell script \"cat /usr/local/var/lib/tor/standup/hostname\")"
    case isBitcoinOn = "(do shell script \"~/StandUp/BitcoinCore0.19.0/bitcoin-0.19.0rc3/bin/bitcoin-cli getblockchaininfo\")"
    case stopBitcoin = "(do shell script \"~/StandUp/BitcoinCore0.19.0/bitcoin-0.19.0rc3/bin/bitcoin-cli stop\")"
    case removeBitcoin = "(do shell script \"rm -R ~/Library/Application*Support/Bitcoin\")"
    
    case standUp = "StandUp"
    case startTor = "StartTor"
    case stopTor = "StopTor"
    case startBitcoinqt = "LaunchBitcoin"
    case verifySigs = "Verify"
    case authenticate = "Authenticate"
    case standDown = "StandDown"
    
}
