//
//  ScriptEnum.swift
//  StandUp
//
//  Created by Peter on 31/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

public enum SCRIPT: String {
    
    // Run simple tasks like checking for existing files with NSAppleScript on ViewController.swift
    case checkForBitcoin = "(do shell script \"~/StandUp/BitcoinCore0.19.0/bitcoin-0.19.0rc3/bin/bitcoind --version\")"
    case checkForTor = "(do shell script \"/usr/local/bin/tor --version\")"
    case getTorrc = "(do shell script \"cat /usr/local/etc/tor/torrc\")"
    case getRPCCredentials = "(do shell script \"cat ~/Library/Application*Support/Bitcoin/bitcoin.conf\")"
    case getTorHostname = "(do shell script \"cat /usr/local/var/lib/tor/standup/hostname\")"
    case startBitcoinqt = "(do shell script \"~/StandUp/BitcoinCore0.19.0/bitcoin-0.19.0rc3/bin/bitcoin-qt\")"
    case isBitcoinOn = "(do shell script \"~/StandUp/BitcoinCore0.19.0/bitcoin-0.19.0rc3/bin/bitcoin-cli getblockchaininfo\")"
    
    // Run asynchronous tasks like downloading binaries with Process() on Installer.swift
    case getBitcoin = "GetPGPKeys"
    case getTor = "GetTor"
    case configureBitcoin = "ConfigureBitcoin"
    case configureTor = "ConfigureTor"
    case startTor = "StartTor"
    
}
