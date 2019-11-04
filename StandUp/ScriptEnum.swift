//
//  ScriptEnum.swift
//  StandUp
//
//  Created by Peter on 31/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

public enum SCRIPT: String {
    
    // Run simple tasks like checking for existiting files and editing configurations with NSAppleScript on ViewController.swift
    case checkForTor = "(do shell script \"/usr/local/bin/tor --version\")"
    case checkForBrew = "(do shell script \"/usr/local/bin/brew --version\")"
    case checkForWget = "(do shell script \"/usr/local/bin/wget --version\")"
    case checkForGPG = "(do shell script \"/usr/local/bin/gpg --version\")"
    case getTorrc = "(do shell script \"cat /usr/local/etc/tor/torrc\")"
    case editTorrc = "(do shell script \"sed -i -e 's/#ControlPort 9051/ControlPort 9051/g' /usr/local/etc/tor/torrc\")"
    case getRPCCredentials = "(do shell script \"cat ~/Library/Application*Support/Bitcoin/bitcoin.conf\")"
    case getTorHostname = "(do shell script \"cat /usr/local/var/lib/tor/bitcoinV3/hostname\")"
    case checkForBitcoind = "(do shell script \"/usr/local/bin/bitcoind --version\")"
    
    // Run asyncronous task like downloading and installing binaries with Process() on Installer.swift
    case getPGPKeys = "GetPGPKeys"
    case getBitcoinCore = "GetBitcoinCore"
    case getTor = "GetTor"
    case getBrew = "GetBrew"
    case getWget = "GetWget"
    
}
