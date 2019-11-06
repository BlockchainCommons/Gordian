//
//  ScriptEnum.swift
//  StandUp
//
//  Created by Peter on 31/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

public enum SCRIPT: String {
    
    // Run simple tasks like checking for existing files, editing configurations and unpacking with NSAppleScript on ViewController.swift
    case checkForBitcoin = "(do shell script \"~/FullyNoded/BitcoinCore0.19.0/bitcoin-0.19.0rc3/bin/bitcoind --version\")"
    case checkForTor = "(do shell script \"/usr/local/bin/tor --version\")"
    case checkForBrew = "(do shell script \"/usr/local/bin/brew --version\")"
    case checkForWget = "(do shell script \"/usr/local/bin/wget --version\")"
    case checkForGPG = "(do shell script \"/usr/local/bin/gpg --version\")"
    case getTorrc = "(do shell script \"cat /usr/local/etc/tor/torrc\")"
    case editTorrc = "(do shell script \"sed -i -e 's/#ControlPort 9051/ControlPort 9051/g' /usr/local/etc/tor/torrc\")"
    case getRPCCredentials = "(do shell script \"cat ~/Library/Application*Support/Bitcoin/bitcoin.conf\")"
    case getTorHostname = "(do shell script \"cat /usr/local/var/lib/tor/bitcoinV3/hostname\")"
    case startBitcoinqt = "(do shell script \"~/FullyNoded/BitcoinCore0.19.0/bitcoin-0.19.0rc3/bin/bitcoin-qt\")"
    case cdIntoBitcoin = "(do shell script \"cd ~/FullyNoded/BitcoinCore0.19.0\")"
    case unpackBtcoin = "(do shell script \"tar -zxvf bitcoin-0.19.0rc3-osx64.tar.gz\")"
    //case configureBitcoin = "(do shell script \"echo 'rpcuser=user\nrpcpassword=password\nserver=1\nprune=0\ntxindex=1\nregtest=1\n[regtest]\nrpcport=18443' >> ~/Library/Application*Support/Bitcoin/bitcoin.conf\")"
    
    // Run asynchronous tasks like downloading binaries with Process() on Installer.swift
    case getPGPKeys = "GetPGPKeys"
    case getBitcoinCore = "GetBitcoinCore"
    case getTor = "GetTor"
    case getBrew = "GetBrew"
    case getWget = "GetWget"
    case startBitcoin = "LaunchBitcoin"
    case configureBitcoin = "ConfigureBitcoin"
    
}
