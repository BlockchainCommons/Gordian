//
//  ViewController.swift
//  StandUp
//
//  Created by Peter on 31/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var taskDescription: NSTextField!
    @IBOutlet var spinner: NSProgressIndicator!
    @IBOutlet var torStatusLabel: NSTextField!
    @IBOutlet var bitcoinCoreStatusLabel: NSTextField!
    @IBOutlet var torConfLabel: NSTextField!
    @IBOutlet var bitcoinConfLabel: NSTextField!
    @IBOutlet var installTorOutlet: NSButton!
    @IBOutlet var configureTorOutlet: NSButton!
    @IBOutlet var installBitcoindOutlet: NSButton!
    @IBOutlet var configureBitcoindOutlet: NSButton!
    @IBOutlet var seeLogOutlet: NSButton!
    @IBOutlet var settingsOutlet: NSButton!
    @IBOutlet var showQuickConnectOutlet: NSButton!
    
    var rpcpassword = ""
    var rpcuser = ""
    var torHostname = ""
    var rpcport = ""
    var isInstallingBitcoin = Bool()
    var isInstallingTor = Bool()
    var isInstallingBrew = Bool()
    var bitcoinInstalled = Bool()
    var torInstalled = Bool()
    var brewInstalled = Bool()
    var wgetInstalled = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScene()
        checkForBrew()
        
    }
    
    //MARK: User Action Segues
    
    @IBAction func getPairingCode(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "showPairingCode", sender: self)
            
        }
        
    }
    
    @IBAction func seeLogAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "goInstall", sender: self)
            
        }
        
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "goToSettings", sender: self)
            
        }
        
    }
    
    //MARK: User Action Installers and Configurators
    
    @IBAction func installTorAction(_ sender: Any) {
        
        print("install tor")
        isInstallingTor = true
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "goInstall", sender: self)
            
        }
        
    }
    
    @IBAction func configureTorAction(_ sender: Any) {
        
        print("configure tor")
        //TO DO: add hidden service to torrc, right now it only enables control port
        //editTorrc()
        
    }
    
    @IBAction func installBitcoinAction(_ sender: Any) {
        
        print("install bitcoin core")
        isInstallingBitcoin = true
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "goInstall", sender: self)
            
        }
        
    }
    
    @IBAction func configureBitcoinAction(_ sender: Any) {
        
        print("configure bitcoin")
        
    }
    
    
    //MARK: Script Methods
    
    func checkForBrew() {
        
        DispatchQueue.main.async {

            self.taskDescription.stringValue = "checking dependencies..."
            self.runScript(script: .checkForBrew)

        }
        
    }
    
    func checkForWget() {
        
        DispatchQueue.main.async {

            self.taskDescription.stringValue = "checking dependencies..."
            self.runScript(script: .checkForWget)

        }
        
    }
    
    func checkForGPG() {
        
        DispatchQueue.main.async {

            self.taskDescription.stringValue = "checking dependencies..."
            self.runScript(script: .checkForGPG)

        }
        
    }
    
    func checkBitcoindVersion() {
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "checking if Bitcoin Core is installed..."
            self.runScript(script: .checkForBitcoind)
            
        }
        
    }
    
    func checkTorVersion() {
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "checking if Tor is installed..."
            self.runScript(script: .checkForTor)
            
        }
        
    }
    
    func getTorrcFile() {
        print("getTorrcFile")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "fetching torrc file..."
            self.runScript(script: .getTorrc)
            
        }
        
    }
    
    func editTorrc() {
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "configuring hidden service"
            self.runScript(script: .editTorrc)
            
        }
        
    }
    
    func checkBitcoinConfForRPCCredentials() {
        print("checkBitcoinConfForRPCCredentials")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "getting RPC credentials..."
            self.runScript(script: .getRPCCredentials)
            
        }
        
    }
    
    func getTorHostName() {
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "getting Tor hostname"
            self.runScript(script: .getTorHostname)
            
        }
        
    }
    
    //MARK: Run Script
    
    func runScript(script: SCRIPT) {
        
        print(script.rawValue)
        let appleScript = NSAppleScript(source: script.rawValue)!
        var errorDict:NSDictionary?
        let result = appleScript.executeAndReturnError(&errorDict).stringValue
        
        if errorDict != nil {
            
            print(errorDict!)
            parseError(script: script, error: errorDict!)
            
        } else {
            
            print("result = \(String(describing: result!))")
            parseScriptResult(script: script, result: result!)
            
        }
        
    }
    
    //MARK: Script Result Filters
    
    func parseScriptResult(script: SCRIPT, result: String) {
        
        switch script {
            
        case .checkForWget:
            
            wgetInstalled = true
            parseWgetResult(result: result)
            
        case .checkForBrew:
            
            brewInstalled = true
            parseBrewResult(result: result)
            
        case .checkForBitcoind:
            
            bitcoinInstalled = true
            parseBitcoindResponse(result: result)
            
        case .checkForTor:
            
            torInstalled = true
            parseTorVersion(result: result)
            
        case .getTorrc:
            
            checkIfTorIsConfigured(response: result)
            
        case .getRPCCredentials:
            
            checkForRPCCredentials(response: result)
            
        case .getTorHostname:
            
            parseHostname(response: result)
            
        case .editTorrc:
            
            checkIfTorIsConfigured(response: result)
            
        default:

            break
            
        }
        
    }
    
    func parseError(script: SCRIPT, error: NSDictionary) {
        
        print("error with script \(script) = \(error)")
        
        switch script {
            
        case .checkForWget:
            
            wgetInstalled = false
            checkBitcoindVersion()
            //hideSpinner()
            
        case .checkForBrew:
            
            brewInstalled = false
            checkForWget()
            
        case .checkForBitcoind:
            
            DispatchQueue.main.async {
                
                self.bitcoinInstalled = false
                self.bitcoinCoreStatusLabel.stringValue = "⛔️ Bitcoin Core not installed"
                self.bitcoinConfLabel.stringValue = "⛔️ Bitcoin Core not configured"
                self.installBitcoindOutlet.isEnabled = true
                self.checkTorVersion()
                
            }
            
        case .checkForTor:
            
            DispatchQueue.main.async {
                
                self.torInstalled = false
                self.torConfLabel.stringValue = "⛔️ Tor not configured"
                self.torStatusLabel.stringValue = "⛔️ Tor not installed"
                self.installTorOutlet.isEnabled = true
                self.hideSpinner()
                
            }
            
        case .getTorrc:
            
            DispatchQueue.main.async {
                
                self.torConfLabel.stringValue = "⛔️ Tor not configured"
                
            }
            
        case .getRPCCredentials:
            
            DispatchQueue.main.async {
                
                self.bitcoinConfLabel.stringValue = "⛔️ Bitcoin Core not configured"
                
            }
            //
            //            case .getTorHostname:
            //
            //                self.parseHostname(response: self.outputString)
            //
            //            case .editTorrc:
            //
            //                self.checkIfTorIsConfigured(response: self.outputString)
            
        default:
            
            break
            
        }
        
    }
    
    //MARK: Script Result Parsers
    
    func parseWgetResult(result: String) {
        
        print("result = \(result)")
        checkBitcoindVersion()
        
    }
    
    func parseBrewResult(result: String) {
        
        print("result = \(result)")
        checkForWget()
        
    }
    
    func parseGPGResult(result: String) {
        
        print("result = \(result)")
        checkForBrew()
        
    }
    
    func parseTorVersion(result: String) {
        
        print("result = \(result)")
        
        if result.contains("Tor version") {
            
            var version = (result.replacingOccurrences(of: "Tor version ", with: ""))
            
            if version.count == 8 {
                
                version = String(version.dropLast())
                
            }
            
            DispatchQueue.main.async {
                
                self.torStatusLabel.stringValue = "✅ Tor v\(version)"
                self.checkBitcoinConfForRPCCredentials()
                //self.getTorrcFile()
                
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.torStatusLabel.stringValue = "⛔️ Tor not installed"
                
            }
            
        }
        
    }
    
    func checkForRPCCredentials(response: String) {
        print("checkForRPCCredentials")
        
        print("bitcoin.conf = \(response)")
        
        let bitcoinConf = response.components(separatedBy: "\r")
        print("bitcoinConf = \(bitcoinConf)")
        
        for item in bitcoinConf {
            
            if item.contains("rpcuser") {
                
                let arr = item.components(separatedBy: "rpcuser=")
                rpcuser = arr[1]
                
            }
            
            if item.contains("rpcpassword") {
                
                let arr = item.components(separatedBy: "rpcpassword=")
                rpcpassword = arr[1]
                
            }
            
            if item.contains("rpcport") {
                
                let arr = item.components(separatedBy: "rpcport=")
                rpcport = arr[1]
                
            }
            
        }
        
        if rpcport != "" && rpcpassword != "" && rpcuser != "" {
            
            DispatchQueue.main.async {
                
                self.bitcoinConfLabel.stringValue = "✅ Bitcoin Core configured"
                
            }
            
            
        } else {
            
            DispatchQueue.main.async {
                
                self.bitcoinConfLabel.stringValue = "⛔️ Bitcoin Core not configured"
                self.configureBitcoindOutlet.isEnabled = true
                
            }
            
        }
        
        getTorrcFile()
        
    }
    
    func checkIfTorIsConfigured(response: String) {
        print("checkIfTorIsConfigured")
        
        print("torrc = \(response)")
        
        if response.contains("HiddenServiceDir /usr/local/var/lib/tor/bitcoinV3/") {
            
            // hidden service exists already
            DispatchQueue.main.async {
                
                self.torConfLabel.stringValue = "✅ Tor configured"
                self.configureTorOutlet.isEnabled = false
                self.getTorHostName()
                
            }
            
        } else {
            
            //create hidden service
            DispatchQueue.main.async {
                
                self.torConfLabel.stringValue = "⛔️ Tor not configured"
                self.configureTorOutlet.isEnabled = true
                self.hideSpinner()
                
            }
            
        }
        
        checkForGPG()
        
    }
    
    func parseBitcoindResponse(result: String) {
        print("parseBitcoindResponse")
        
        if result.contains("Bitcoin Core Daemon version") {
            
            print("bitcoind installed")
            
            let arr = result.components(separatedBy: "Copyright (C)")
            let version = (arr[0]).replacingOccurrences(of: "Bitcoin Core Daemon version ", with: "")
            
            DispatchQueue.main.async {
                
                self.bitcoinCoreStatusLabel.stringValue = "✅ Bitcoin Core \(version)"
                self.checkTorVersion()
                
            }
            
        } else {
            
            //bitcoin not installed
            print("bitcoind not installed")
            
            DispatchQueue.main.async {
                
                self.bitcoinCoreStatusLabel.stringValue = "⛔️ Bitcoin Core not installed"
                self.installBitcoindOutlet.isEnabled = true
                self.checkTorVersion()
                
            }
            
        }
        
    }
    
    func parseHostname(response: String) {
        print("parseHostname")
        
        torHostname = response
        
        DispatchQueue.main.async {
            
            self.showQuickConnectOutlet.isEnabled = true
            
        }
        
        hideSpinner()
        
    }
    
    //MARK: User Inteface
    
    func hideSpinner() {
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = ""
            self.spinner.stopAnimation(self)
            self.spinner.alphaValue = 0
            self.taskDescription.alphaValue = 0
            
        }
        
    }
    
    func setScene() {
        
        torStatusLabel.stringValue = ""
        bitcoinCoreStatusLabel.stringValue = ""
        torConfLabel.stringValue = ""
        bitcoinConfLabel.stringValue = ""
        
        showQuickConnectOutlet.isEnabled = false
        installTorOutlet.isEnabled = false
        installBitcoindOutlet.isEnabled = false
        configureTorOutlet.isEnabled = false
        configureBitcoindOutlet.isEnabled = false
        
        taskDescription.stringValue = "checking system..."
        spinner.startAnimation(self)
        
    }
    
    //MARK: Segue Prep
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "showPairingCode":
            
            if let vc = segue.destinationController as? QRDisplayer {
                
                vc.rpcport = rpcport
                vc.rpcpassword = rpcpassword
                vc.rpcuser = rpcuser
                vc.torHostname = torHostname
                
            }
            
        case "goInstall":
            
            if let vc = segue.destinationController as? Installer {
                
                vc.isInstallingBitcoin = isInstallingBitcoin
                vc.isInstallingTor = isInstallingTor
                vc.bitcoinInstalled = bitcoinInstalled
                vc.torInstalled = torInstalled
                vc.brewInstalled = brewInstalled
                vc.wgetInstalled = wgetInstalled
                
            }
            
        default:
            
            break
            
        }
        
    }
    
}

