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
    @IBOutlet var updateBitcoinlabel: NSTextField!
    
    @IBOutlet var installTorOutlet: NSButton!
    @IBOutlet var installBitcoindOutlet: NSButton!
    @IBOutlet var seeLogOutlet: NSButton!
    @IBOutlet var settingsOutlet: NSButton!
    @IBOutlet var showQuickConnectOutlet: NSButton!
    @IBOutlet var standUpOutlet: NSButton!
    @IBOutlet var verifyOutlet: NSButton!
    @IBOutlet var updateOutlet: NSButton!
    
    var rpcpassword = ""
    var rpcuser = ""
    var torHostname = ""
    
    var standingUp = Bool()
    var bitcoinInstalled = Bool()
    var torInstalled = Bool()
    var torIsOn = Bool()
    var bitcoinRunning = Bool()
    var upgrading = Bool()
    var isLoading = Bool()
    
    var env = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = UserDefaults.standard
        ud.removeObject(forKey: "dataDir")
        isLoading = true
        setScene()
        setDefaults()
        setEnv { self.isBitcoinOn() }
        
    }
    
    //MARK: Set default settings
    
    func setDefaults() {
        print("setDefaults")
        
        // TO DO: Ideally should fetch the actual bitcoin.conf first and if they exist set them in the app just incase user edits manually, otherwise the settings in the app will be out of sync
                
        let ud = UserDefaults.standard
        
        if ud.object(forKey: "pruned") == nil {
            
            ud.set(0, forKey: "pruned")
            
        }
        
        if ud.object(forKey: "txIndex") == nil {
            
            ud.set(1, forKey: "txIndex")
            
        }
        
        if ud.object(forKey: "dataDir") == nil {
            
            ud.set("/Users/\(NSUserName())/Library/Application Support/Bitcoin", forKey: "dataDir")
            
        } else {
            
            print("datadir=\(ud.object(forKey: "dataDir") as! String)")
        }
        
        if ud.object(forKey: "testnet") == nil {
            
            ud.set(1, forKey: "testnet")
            
        }
        
        if ud.object(forKey: "mainnet") == nil {
            
            ud.set(0, forKey: "mainnet")
            
        }
        
        if ud.object(forKey: "regtest") == nil {
            
            ud.set(0, forKey: "regtest")
            
        }
        
        if ud.object(forKey: "walletdisabled") == nil {
            
            ud.set(0, forKey: "walletdisabled")
            
        }
        
        if ud.object(forKey: "nodeLabel") == nil {
            
            ud.set("StandUp Node", forKey: "nodeLabel")
            
        }
    
    }
    
    //MARK: User Action Segues
    
    @IBAction func getPairingCode(_ sender: Any) {
        print("getPairingCode")
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showPairingCode", sender: self)
        }
        
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        print("gotosettings")
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToSettings", sender: self)
        }
        
    }
    
    @IBAction func updateBitcoin(_ sender: Any) {
        print("update bitcoin core")
        
        DispatchQueue.main.async {
            
            let request = FetchJSON()
            request.getRequest { (dict, err) in
                
                if err != "" {
                    
                    setSimpleAlert(message: "Error", info: "Error fetching json values: \(err ?? "unknown error")", buttonLabel: "OK")
                    
                } else {
                    
                    let version = dict!["version"] as! String
                    actionAlert(message: "Upgrade to Bitcoin Core \(version)?", info: "Upgrading removes the ~/StandUp directory and completley writes over it!\n\nAre you sure you would like to upgrade to Bitcoin Core version \(version)?") { (response) in
                        
                        if response {
                            
                            DispatchQueue.main.async {
                                self.upgrading = true
                                self.performSegue(withIdentifier: "goInstall", sender: self)
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    //MARK: User Action Installers, Starters and Configurators
    
    @IBAction func verifyAction(_ sender: Any) {
        print("verifyAction")
        
        runLaunchScript(script: .verifyBitcoin)
        
    }
    
    @IBAction func standUp(_ sender: Any) {
        print("standup")
        
        self.startSpinner(description: "Fetching latest Bitcoin Core version...")
        
        let request = FetchJSON()
        request.getRequest { (dict, error) in
            
            if error != "" {
                
                self.hideSpinner()
                print("error = \(String(describing: error))")
                setSimpleAlert(message: "Error", info: "We had an error fetching the latest version of Bitcoin Core, please check your internet connection and try again", buttonLabel: "OK")
                
            } else {
                
                let version = dict!["version"] as! String
                
                self.hideSpinner()
                
                self.showstandUpAlert(message: "Ready to StandUp?", info: "StandUp installs and configures a fully indexed Bitcoin Core v\(version) testnet node and Tor v0.4.1.6\n\n~30gb of space needed for testnet and ~300gb for mainnet\n\nIf you would like to install a different node go to \"Settings\" for pruning, network, data directory and tor related options, you can always adjust the settings and restart your node for the chagnes to take effect.")
                
            }
            
        }
        
    }
    
    @IBAction func installTorAction(_ sender: Any) {
        print("install tor action")
        
        if !torIsOn {
            
            DispatchQueue.main.async {
                
                self.startSpinner(description: "Starting Tor...")
                self.installTorOutlet.isEnabled = false
                
            }
            
            runLaunchScript(script: .startTor)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.startSpinner(description: "Stopping Tor...")
                self.installTorOutlet.isEnabled = false
                
            }
            
            runLaunchScript(script: .stopTor)
            
        }
                
    }
    
    @IBAction func installBitcoinAction(_ sender: Any) {
        print("installBitcoin")
        print("bitcoinRunning = \(bitcoinRunning)")
        
        isLoading = false
        
        if !bitcoinRunning {
            
            DispatchQueue.main.async {
                
                self.bitcoinRunning = true
                self.installBitcoindOutlet.title = "Stop Bitcoin"
                self.installBitcoindOutlet.isEnabled = true
                
            }
            
            runLaunchScript(script: .startBitcoinqt)
            
            
        } else {
            
            DispatchQueue.main.async {
                
                self.startSpinner(description: "stopping Bitcoin Core...")
                self.installBitcoindOutlet.isEnabled = false
                
            }
            
            runLaunchScript(script: .stopBitcoin)
            
        }
        
    }
    
    // MARK: Script Methods
    
    func isBitcoinOn() {
        print("isBitcoinOn")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "checking if Bitcoin Core is running..."
            self.runLaunchScript(script: .isBitcoinOn)
            
        }
        
    }
    
    func checkSigs() {
        print("checkSigs")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "verifying PGP signatures..."
            self.runLaunchScript(script: .verifyBitcoin)
            self.hideSpinner()
            
        }
        
    }
    
    func checkBitcoindVersion() {
        print("checkbitcoinversion")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "checking if Bitcoin Core is installed..."
            self.runLaunchScript(script: .checkForBitcoin)
            
        }
        
    }
    
    func checkTorVersion() {
        print("checktorversion")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "checking if Tor is installed..."
            self.runLaunchScript(script: .checkForTor)
            
        }
        
    }
    
    func getTorrcFile() {
        print("getTorrcFile")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "fetching torrc file..."
            self.runLaunchScript(script: .getTorrc)
            
        }
        
    }
    
    func checkBitcoinConfForRPCCredentials() {
        print("checkBitcoinConfForRPCCredentials")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "getting RPC credentials..."
            self.runLaunchScript(script: .getRPCCredentials)
            
        }
        
    }
    
    func getTorHostName() {
        print("gettorhostname")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "getting Tor hostname..."
            self.runLaunchScript(script: .getTorHostname)
            
        }
        
    }
    
    func isTorOn() {
        print("isTorOn")
        
        DispatchQueue.main.async {
            self.taskDescription.stringValue = "Checking Tor status..."
            self.runLaunchScript(script: .torStatus)
        }
        
    }
    
    //MARK: Run Scripts
    
    func runLaunchScript(script: SCRIPT) {
        print("runlaunchscript: \(script.rawValue)")
        
        switch script {
            
        case .startBitcoinqt:
            
            let ud = UserDefaults.standard
            self.env["DATADIR"] = "-datadir=" + "\(ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/Library/Application Support/Bitcoin")"
            
        case .getRPCCredentials:
            
            let ud = UserDefaults.standard
            self.env["DATADIR"] = "\(ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/Library/Application Support/Bitcoin")"
            
        default:
            
            break
            
        }
        
        let runBuildTask = RunBuildTask()
        runBuildTask.stringToReturn = ""
        runBuildTask.terminate = false
        runBuildTask.errorBool = false
        runBuildTask.errorDescription = ""
        runBuildTask.isRunning = false
        runBuildTask.args = []
        runBuildTask.env = self.env
        runBuildTask.exitStrings = ["Done"]
        runBuildTask.showLog = false
        runBuildTask.runScript(script: script) {
            
            if !runBuildTask.errorBool {
                
                let str = runBuildTask.stringToReturn
                print("str = \(str)")
                self.setLog(content: str)
                self.parseScriptResult(script: script, result: str)
                
            } else {
                
                setSimpleAlert(message: "Error running script", info: "script: \(script.rawValue)", buttonLabel: "OK")
                
            }
            
        }

    }
    
    //MARK: Script Result Filters
    
    func parseScriptResult(script: SCRIPT, result: String) {
        print("parsescriptresult")
        
        switch script {
        case .verifyBitcoin: parseVerifyResult(result: result)
        case .startBitcoinqt: bitcoinStarted()
        case .startTor, .stopTor: torStarted(result: result)
        case .stopBitcoin: parseBitcoinStoppedResponse(result: result)
        case .isBitcoinOn: parseIsBitcoinOnResponse(result: result)
        case .checkForBitcoin: bitcoinInstalled = true; parseBitcoindResponse(result: result)
        case .checkForTor: parseTorResult(result: result)
        case .getTorrc: checkIfTorIsConfigured(response: result)
        case .getRPCCredentials: checkForRPCCredentials(response: result)
        case .getTorHostname: parseHostname(response: result)
        case .torStatus: parseTorStatus(result: result)
        default: break
        }
        
    }
    
    func parseError(script: SCRIPT, error: String) {
        print("parseerror script: \(script) and error: \(error)")
        
        switch script {
            
        case .verifyBitcoin:
            
            parseVerifyResult(result: "error")
            
        case .torStatus:
            
            DispatchQueue.main.async {
                self.installTorOutlet.title = "Start Tor"
                self.installTorOutlet.isEnabled = false
                self.hideSpinner()
            }
            
        case .stopBitcoin:
            
            bitcoinStopped()
            
        case .isBitcoinOn:
            
            bitcoinRunning = false
            bitcoinStopped()
            checkBitcoindVersion()
            
        case .checkForBitcoin:
            
            DispatchQueue.main.async {
                
                self.bitcoinInstalled = false
                self.bitcoinCoreStatusLabel.stringValue = "⛔️ Bitcoin Core not installed"
                self.bitcoinConfLabel.stringValue = "⛔️ Bitcoin Core not configured"
                self.installBitcoindOutlet.isEnabled = false
                self.checkTorVersion()
                
            }
            
        case .checkForTor:
            
            DispatchQueue.main.async {
                
                self.torInstalled = false
                self.torConfLabel.stringValue = "⛔️ Tor not configured"
                self.torStatusLabel.stringValue = "⛔️ Tor not installed"
                self.checkBitcoinConfForRPCCredentials()
                
            }
            
        case .getTorrc:
            
            DispatchQueue.main.async {
                
                self.torConfLabel.stringValue = "⛔️ Tor not configured"
                self.hideSpinner()
                
            }
            
        case .getRPCCredentials:
            
            DispatchQueue.main.async {
                
                self.bitcoinConfLabel.stringValue = "⛔️ Bitcoin Core not configured"
                
            }
            
            getTorrcFile()
            
        default:
            
            break
            
        }
        
    }
    
    //MARK: Script Result Parsers
    
    func parseBitcoinStoppedResponse(result: String) {
        print("parseBitcoinStoppedResponse")
        
        if result.contains("Bitcoin server stopping") {
            
            bitcoinStopped()
            hideSpinner()
            
        } else {
            
            
        }
        
    }
    
    func parseIsBitcoinOnResponse(result: String) {
        print("parseIsBitcoinOnResponse")
        
        if result.contains("Could not connect to the server 127.0.0.1") {
            
            bitcoinStopped()
            
        } else if result.contains("chain") {
            
            bitcoinStarted()
            
        }
        
        if isLoading {
            
            checkBitcoindVersion()
            
        }
        
    }
    
    func parseTorStatus(result: String) {
        print("parseTorStatus")
        
        if result.contains("tor  started") {
            
            DispatchQueue.main.async {
                self.torIsOn = true
                self.installTorOutlet.title = "Stop Tor"
                self.installTorOutlet.isEnabled = true
            }
            
        } else if result.contains("tor  stopped") {
            
            DispatchQueue.main.async {
                self.torIsOn = false
                self.installTorOutlet.title = "Start Tor"
                self.installTorOutlet.isEnabled = true
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.torIsOn = false
                self.installTorOutlet.title = "Start Tor"
                self.installTorOutlet.isEnabled = false
            }
            
        }
        
        self.hideSpinner()
        
    }
    
    func bitcoinStopped() {
        print("bitcoin stopped")
        
        DispatchQueue.main.async {
            
            self.bitcoinRunning = false
            self.installBitcoindOutlet.title = "Start Bitcoin"
            self.installBitcoindOutlet.isEnabled = true
            
        }
        
    }
    
    func bitcoinStarted() {
        print("bitcoinstarted")
        
        DispatchQueue.main.async {
            
            self.bitcoinRunning = true
            self.installBitcoindOutlet.title = "Stop Bitcoin"
            self.installBitcoindOutlet.isEnabled = true
            
        }
        
    }
    
    func torStarted(result: String) {
        print("torstarted")
        
        var title = ""
        
        if result.contains("Successfully started") {
            
            torIsOn = true
            title = "Stop Tor"
            
        } else if result.contains("Successfully stopped") {
            
            torIsOn = false
            title = "Start Tor"
            
        } else if result.contains("already started") {
            
            torIsOn = true
            title = "Stop Tor"
            
        }
        
        DispatchQueue.main.async {
            
            self.hideSpinner()
            self.installTorOutlet.title = title
            self.installTorOutlet.isEnabled = true
            
        }
                
    }
    
    func startBitcoin() {
        print("startbitcoin")
        
        DispatchQueue.main.async {
            
            self.installBitcoindOutlet.isEnabled = false
            
        }
        
    }
    
    func parseTorResult(result: String) {
        print("parseTorResult")
        
        if result.contains("Tor version") {
            
            var version = (result.replacingOccurrences(of: "Tor version ", with: ""))
            
            if version.count == 8 {
                
                version = String(version.dropLast())
                
            }
            
            DispatchQueue.main.async {
                self.torStatusLabel.stringValue = "✅ Tor v\(version)"
                self.installTorOutlet.title = "Start Tor"
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.torStatusLabel.stringValue = "⛔️ Tor not installed"
            }
            
        }
        
        self.checkBitcoinConfForRPCCredentials()
        
    }
    
    func checkForRPCCredentials(response: String) {
        print("checkforrpccreds")
        
        let bitcoinConf = response.components(separatedBy: "\n")
        
        for item in bitcoinConf {
            
            if item.contains("rpcuser") {
                
                let arr = item.components(separatedBy: "rpcuser=")
                rpcuser = arr[1]
                
            }
            
            if item.contains("rpcpassword") {
                
                let arr = item.components(separatedBy: "rpcpassword=")
                rpcpassword = arr[1]
                
            }
            
        }
        
        if rpcpassword != "" && rpcuser != "" {
            
            DispatchQueue.main.async {
                
                self.bitcoinConfLabel.stringValue = "✅ Bitcoin Core configured"
                
            }
            
            
        } else {
            
            DispatchQueue.main.async {
                
                self.bitcoinConfLabel.stringValue = "⛔️ Bitcoin Core not configured"
                
            }
            
        }
        
        getTorrcFile()
        
    }
    
    func checkIfTorIsConfigured(response: String) {
        print("checkiftorisconfigured")
        
        if response.contains("HiddenServiceDir /usr/local/var/lib/tor/standup/") {
            
            // hidden service exists already
            DispatchQueue.main.async {
                
                self.torConfLabel.stringValue = "✅ Tor configured"
                
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.torConfLabel.stringValue = "⛔️ Tor not configured"
                
            }
            
        }
        
        getTorHostName()
                
    }
    
    func parseBitcoindResponse(result: String) {
        print("parsebitcoindresponse")
        
        if result.contains("Bitcoin Core Daemon version") {
            
            let arr = result.components(separatedBy: "Copyright (C)")
            let currentVersion = (arr[0]).replacingOccurrences(of: "Bitcoin Core Daemon version ", with: "")
            
            DispatchQueue.main.async {
                
                self.installBitcoindOutlet.isEnabled = true
                self.verifyOutlet.isEnabled = true
                self.bitcoinCoreStatusLabel.stringValue = "✅ Bitcoin Core \(currentVersion)"
                
                let req = FetchJSON()
                req.getRequest { (dict, error) in
                    
                    if error != "" {
                        
                        print("error getting supported version")
                        DispatchQueue.main.async {
                            self.updateBitcoinlabel.stringValue = "⛔️ Error getting latest version"
                        }
                        
                    } else {
                        
                        let version = dict!["version"] as! String
                        let binaryName = dict!["macosBinary"] as! String
                        let prefix = dict!["binaryPrefix"] as! String
                        self.env = ["BINARY_NAME":binaryName,"VERSION":version,"PREFIX":prefix]
                        let latestVersion = "v" + version.replacingOccurrences(of: "\n", with: "")
                        if currentVersion.contains(latestVersion) {
                            
                            print("up to date")
                            
                            DispatchQueue.main.async {
                                self.updateBitcoinlabel.stringValue = "✅ Bitcoin Core Up to Date"
                            }
                            
                        } else {
                            
                            print("not up to date")
                            DispatchQueue.main.async {
                                self.updateBitcoinlabel.stringValue = "⛔️ Bitcoin Core Out of Date"
                                self.updateOutlet.isEnabled = true
                            }
                            
                        }
                        
                    }
                    
                }
                                
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.bitcoinCoreStatusLabel.stringValue = "⛔️ Bitcoin Core not installed"
                self.installBitcoindOutlet.isEnabled = false
            }
            
        }
        
        checkTorVersion()
        
    }
    
    func parseHostname(response: String) {
        print("parsehostname")
        
        torHostname = response.components(separatedBy: "\n")[0]
        print("hostname = \(torHostname)")
        
        if rpcuser != "" && rpcpassword != "" && torHostname != "" && !torHostname.contains("cat: /usr/local/var/lib/tor/standup/hostname: No such file or directory") {
            
            DispatchQueue.main.async {
                self.showQuickConnectOutlet.isEnabled = true
                self.standUpOutlet.isEnabled = false
                self.isTorOn()
            }
            
        } else {
            
            self.hideSpinner()
            DispatchQueue.main.async {
                self.standUpOutlet.isEnabled = true
            }
            
        }
                
    }
    
    func parseVerifyResult(result: String) {
        print("parseVerifyResult: \(result)")
        
        let binaryName = self.env["BINARY_NAME"] ?? ""
        
        if result.contains("\(binaryName): OK") {
            
            print("results verified")
            showAlertMessage(message: "Success", info: "Signatures for \(binaryName) and Laanjw SHA256SUMS.asc match")
            
        } else {
            
            showAlertMessage(message: "DANGER!!! Invalid signatures...", info: "Please delete the ~/StandUp folder and app and report an issue on the github, PGP signatures are not valid")
            
        }
        
    }
    
    //MARK: User Inteface
    
    func setEnv(completion: @escaping () -> Void) {
        print("setenv")
        
        let req = FetchJSON()
        req.getRequest { (dict, error) in
            
            if error != "" {
                
                print("error getting supported version")
                self.hideSpinner()
                setSimpleAlert(message: "Error", info: "We could not get a response from github... error: \(error ?? "unknown")", buttonLabel: "OK")
                completion()
                
            } else {
                
                let version = dict!["version"] as! String
                let binaryName = dict!["macosBinary"] as! String
                let prefix = dict!["binaryPrefix"] as! String
                self.env = ["BINARY_NAME":binaryName,"VERSION":version,"PREFIX":prefix]
                completion()
                
            }
            
        }
        
    }
    
    func showAlertMessage(message: String, info: String) {
        print("showAlertMessage")
        
        setSimpleAlert(message: message, info: info, buttonLabel: "OK")
        
    }
    
    func startSpinner(description: String) {
        print("startspinner")
        
        DispatchQueue.main.async {
            
            self.spinner.startAnimation(self)
            self.taskDescription.stringValue = description
            self.spinner.alphaValue = 1
            self.taskDescription.alphaValue = 1
            
        }
        
    }
    
    func hideSpinner() {
        print("hidespinner")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = ""
            self.spinner.stopAnimation(self)
            self.spinner.alphaValue = 0
            self.taskDescription.alphaValue = 0
            
        }
        
    }
    
    func setScene() {
        print("setscene")
        
        updateOutlet.isEnabled = false
        updateBitcoinlabel.stringValue = ""
        torStatusLabel.stringValue = ""
        bitcoinCoreStatusLabel.stringValue = ""
        torConfLabel.stringValue = ""
        bitcoinConfLabel.stringValue = ""
        showQuickConnectOutlet.isEnabled = false
        installTorOutlet.isEnabled = false
        installBitcoindOutlet.isEnabled = false
        standUpOutlet.isEnabled = false
        verifyOutlet.isEnabled = false
        taskDescription.stringValue = "checking system..."
        spinner.startAnimation(self)
        
    }
    
    func showstandUpAlert(message: String, info: String) {
        print("showstandUpAlert")
        
        DispatchQueue.main.async {
            
            actionAlert(message: message, info: info) { (response) in
                
                if response {
                    
                    DispatchQueue.main.async {
                        
                        self.standingUp = true
                        self.performSegue(withIdentifier: "goInstall", sender: self)
                        
                    }
                    
                } else {
                    
                    print("tapped no")
                    
                }
                
            }
            
        }
        
    }
    
    func setLog(content: String) {
        
        let lg = Log()
        lg.writeToLog(content: content)
        
    }
    
    // MARK: Segue Prep
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        print("prepare for segue")
        
        switch segue.identifier {
            
        case "showPairingCode":
            
            if let vc = segue.destinationController as? QRDisplayer {
                
                //vc.rpcport = rpcport
                vc.rpcpassword = rpcpassword
                vc.rpcuser = rpcuser
                vc.torHostname = torHostname
                
            }
            
        case "goInstall":
            
            if let vc = segue.destinationController as? Installer {
                
                vc.standingUp = standingUp
                vc.upgrading = upgrading
                
            }
            
        default:
            
            break
            
        }
        
    }
    
}

