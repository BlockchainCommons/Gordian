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
    @IBOutlet var installBitcoindOutlet: NSButton!
    @IBOutlet var seeLogOutlet: NSButton!
    @IBOutlet var settingsOutlet: NSButton!
    @IBOutlet var showQuickConnectOutlet: NSButton!
    @IBOutlet var standUpOutlet: NSButton!
    @IBOutlet var verifyOutlet: NSButton!
    var rpcpassword = ""
    var rpcuser = ""
    var torHostname = ""
    var rpcport = ""
    var standingUp = Bool()
    var isInstallingBitcoin = Bool()
    var isInstallingTor = Bool()
    var isInstallingBrew = Bool()
    var bitcoinInstalled = Bool()
    var torInstalled = Bool()
    var torIsOn = Bool()
    var bitcoinRunning = Bool()
    var seeLog = Bool()
    dynamic var isRunning = false
    var outputPipe:Pipe!
    var buildTask:Process!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScene()
        setDefaults()
        isBitcoinOn()
        
    }
    
    //MARK: Set default settings
    
    func setDefaults() {
        
        let ud = UserDefaults.standard
        
        if ud.object(forKey: "pruned") == nil {
            
            ud.set(0, forKey: "pruned")
            
        }
        
        if ud.object(forKey: "txIndex") == nil {
            
            ud.set(1, forKey: "txIndex")
            
        }
        
        if ud.object(forKey: "dataDir") == nil {
            
            ud.set("~/Library/Application Support/Bitcoin", forKey: "dataDir")
            
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
    
    }
    
    //MARK: User Action Segues
    
    @IBAction func getPairingCode(_ sender: Any) {
        print("getPairingCode")
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "showPairingCode", sender: self)
            
        }
        
    }
    
    @IBAction func seeLog(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.seeLog = true
            self.performSegue(withIdentifier: "goInstall", sender: self)
            
        }
        
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        print("gotosettings")
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "goToSettings", sender: self)
            
        }
        
    }
    
    //MARK: User Action Installers, Starters and Configurators
    
    @IBAction func verifyAction(_ sender: Any) {
        
        checkSigs()
        
    }
    
    
    @IBAction func standUp(_ sender: Any) {
        print("standup")
        
        showstandUpAlert(message: "Ready to StandUp?", info: "StandUp installs and configures a fully indexed Bitcoin Core v0.19.0rc3 testnet node and Tor v0.4.1.6\n\n~25gb of space needed for testnet and ~270gb for mainnet\n\nGo to \"Settings\" for pruning, network, data directory and tor related bitcoin.conf options")
        
    }
    
    @IBAction func refreshView(_ sender: Any) {
        print("refreshview")
        
        isBitcoinOn()
        
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
            
            runScript(script: .stopBitcoin)
            
        }
        
    }
    
    // MARK: Script Methods
    
    func isBitcoinOn() {
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "checking if Bitcoin Core is running..."
            self.runScript(script: .isBitcoinOn)
            
        }
        
    }
    
    func checkSigs() {
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "verifying PGP signatures..."
            self.runLaunchScript(script: .verifySigs)
            self.hideSpinner()
            
        }
        
    }
    
    func checkBitcoindVersion() {
        print("checkbitcoinversion")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "checking if Bitcoin Core is installed..."
            self.runScript(script: .checkForBitcoin)
            
        }
        
    }
    
    func checkTorVersion() {
        print("checktorversion")
        
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
    
    func checkBitcoinConfForRPCCredentials() {
        print("checkBitcoinConfForRPCCredentials")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "getting RPC credentials..."
            self.runScript(script: .getRPCCredentials)
            
        }
        
    }
    
    func getTorHostName() {
        print("gettorhostname")
        
        DispatchQueue.main.async {
            
            self.taskDescription.stringValue = "getting Tor hostname..."
            self.runScript(script: .getTorHostname)
            
        }
        
    }
    
    //MARK: Run Apple Script
    
    func runScript(script: SCRIPT) {
        print("run script")
        
        let appleScript = NSAppleScript(source: script.rawValue)!
        var errorDict:NSDictionary?
        let result = appleScript.executeAndReturnError(&errorDict).stringValue
        
        if errorDict != nil {
            
            print(errorDict!)
            parseError(script: script, error: errorDict!)
            
        } else {
            
            parseScriptResult(script: script, result: result!)
            
        }
        
    }
    
    //MARK: Script Result Filters
    
    func parseScriptResult(script: SCRIPT, result: String) {
        print("parsescriptresult")
        
        switch script {
        case .stopBitcoin: bitcoinRunning = false; bitcoinStopped()
        case .isBitcoinOn: bitcoinRunning = true; bitcoinStarted()
        case .checkForBitcoin: bitcoinInstalled = true; parseBitcoindResponse(result: result)
        case .checkForTor: torInstalled = true; parseTorVersion(result: result)
        case .getTorrc: checkIfTorIsConfigured(response: result)
        case .getRPCCredentials: checkForRPCCredentials(response: result)
        case .getTorHostname: parseHostname(response: result)
        default: break
        }
        
    }
    
    func parseError(script: SCRIPT, error: NSDictionary) {
        print("parseerror")
        
        switch script {
            
        case .stopBitcoin:
            
            bitcoinStopped()
            
        case .isBitcoinOn:
            
            if let errorDescription = error["NSAppleScriptErrorBriefMessage"] as? String {
                
                if errorDescription.contains("Could not connect to the server") {
                    
                    bitcoinRunning = true
                    bitcoinStarted()
                    runLaunchScript(script: .startBitcoinqt)
                    
                } else {
                    
                    bitcoinRunning = false
                    checkBitcoindVersion()
                }
                
            } else {
                
                bitcoinRunning = false
                checkBitcoindVersion()
                
            }
            
        case .checkForBitcoin:
            
            DispatchQueue.main.async {
                
                self.bitcoinInstalled = false
                self.bitcoinCoreStatusLabel.stringValue = "⛔️ Bitcoin Core not installed"
                self.bitcoinConfLabel.stringValue = "⛔️ Bitcoin Core not configured"
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
                self.standUpOutlet.isEnabled = true
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
    
    func bitcoinStopped() {
        print("bitcoin stopped")
        
        DispatchQueue.main.async {
            
            self.installBitcoindOutlet.title = "Start Bitcoin"
            self.installBitcoindOutlet.isEnabled = true
            self.hideSpinner()
            
        }
        
    }
    
    func bitcoinStarted() {
        print("bitcoinstarted")
        
        DispatchQueue.main.async {
            
            self.installBitcoindOutlet.title = "Stop Bitcoin"
            self.installBitcoindOutlet.isEnabled = true
            self.checkBitcoindVersion()
            
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
    
    func parseTorVersion(result: String) {
        print("parsetorversion")
        
        if result.contains("Tor version") {
            
            var version = (result.replacingOccurrences(of: "Tor version ", with: ""))
            
            if version.count == 8 {
                
                version = String(version.dropLast())
                
            }
            
            DispatchQueue.main.async {
                
                self.torStatusLabel.stringValue = "✅ Tor v\(version)"
                self.checkBitcoinConfForRPCCredentials()
                self.installTorOutlet.title = "Start Tor"
                
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.torStatusLabel.stringValue = "⛔️ Tor not installed"
                
            }
            
        }
        
    }
    
    func checkForRPCCredentials(response: String) {
        print("checkforrpccreds")
        
        let bitcoinConf = response.components(separatedBy: "\r")
        
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
                self.getTorHostName()
                
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.torConfLabel.stringValue = "⛔️ Tor not configured"
                self.hideSpinner()
                
            }
            
        }
                
    }
    
    func parseBitcoindResponse(result: String) {
        print("parsebitcoindresponse")
        
        if result.contains("Bitcoin Core version") {
            
            let arr = result.components(separatedBy: "Copyright (C)")
            let version = (arr[0]).replacingOccurrences(of: "Bitcoin Core version ", with: "")
            
            DispatchQueue.main.async {
                
                self.installBitcoindOutlet.isEnabled = true
                self.verifyOutlet.isEnabled = true
                self.bitcoinCoreStatusLabel.stringValue = "✅ Bitcoin Core \(version)"
                self.checkTorVersion()
                
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.bitcoinCoreStatusLabel.stringValue = "⛔️ Bitcoin Core not installed"
                self.installBitcoindOutlet.isEnabled = true
                self.checkTorVersion()
                
            }
            
        }
        
    }
    
    func parseHostname(response: String) {
        print("parsehostname")
        
        torHostname = response
        
        if rpcuser != "", rpcpassword != "", rpcport != "", torHostname != "" {
            
            DispatchQueue.main.async {
                
                self.showQuickConnectOutlet.isEnabled = true
                self.standUpOutlet.isEnabled = false
                self.taskDescription.stringValue = "Starting Tor..."
                self.runLaunchScript(script: .startTor)
                
            }
            
        } else {
            
            showstandUpAlert(message: "Ready to StandUp?", info: "Installs a fully indexed Bitcoin Core v0.19.0rc3 testnet node. ~25gb of space needed for testnet and ~270gb for mainnet. You can set custmizable options in \"Settings\" for pruning, network, data directory and tor related bitcoin.conf options.")
            
        }
                
    }
    
    func parseVerifyResult(result: String) {
        
        if result.contains("bitcoin-0.19.0rc3-osx64.tar.gz: OK") {
            
            print("results verified")
            showAlertMessage(message: "PGP signatures for bitcoin-0.19.0rc3-osx64.tar.gz and Laanjw SHA256SUMS.asc match", info: "")
            
        } else {
            
            showAlertMessage(message: "DANGER!!! Invalid signatures...", info: "Please delete the ~/StandUp folder and app and report an issue on the github, PGP signatures are not valid")
            
        }
        
    }
    
    //MARK: User Inteface
    
    func showAlertMessage(message: String, info: String) {
        
        DispatchQueue.main.async {
            
            let a = NSAlert()
            a.messageText = message
            a.informativeText = info
            a.addButton(withTitle: "OK")
            a.runModal()
            
        }
        
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
        
        DispatchQueue.main.async {
            
            let a = NSAlert()
            a.messageText = message
            a.informativeText = info
            a.addButton(withTitle: "StandUp")
            a.addButton(withTitle: "Cancel")
            let response = a.runModal()
            
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                
                DispatchQueue.main.async {
                    
                    self.standingUp = true
                    self.performSegue(withIdentifier: "goInstall", sender: self)
                    
                }
                
            } else {
                
                print("tapped no")
                
            }
            
        }
        
    }
    
    // MARK: For launching bitcoinqt etc...
    
    func runLaunchScript(script: SCRIPT) {
        print("runlaunchscript")

        isRunning = true
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        let resource = script.rawValue

        taskQueue.async {
            
            guard let path = Bundle.main.path(forResource: resource, ofType: "command") else {
                print("Unable to locate \(resource).command")
                return
            }

            self.buildTask = Process()
            self.buildTask.launchPath = path
            self.buildTask.terminationHandler = {

                task in
                self.isRunning = false

            }

            self.captureStandardOutputAndRouteToTextView(task: self.buildTask, script: script)
            self.buildTask.launch()
            self.buildTask.waitUntilExit()

        }

    }
    
    func captureStandardOutputAndRouteToTextView(task:Process, script: SCRIPT) {
        print("captureStandardOutputAndRouteToTextView")
        
        outputPipe = Pipe()
        task.standardOutput = outputPipe
        let outHandle = outputPipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        
        var progressObserver : NSObjectProtocol!
        progressObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandle, queue: nil) {
            notification in
            
            let data = outHandle.availableData
            
            if data.count > 0 {
                
                if let str = String(data: data, encoding: String.Encoding.utf8) {
                    
                    print("output = \(str)")
                    switch script {
                    case .verifySigs: self.parseVerifyResult(result: str)
                    case .startBitcoinqt: self.bitcoinStarted()
                    case .startTor, .stopTor: self.torStarted(result: str)
                    default: break
                    }
                    
                }
                
                outHandle.waitForDataInBackgroundAndNotify()
                
            } else {
                
                // That means we've reached the end of the input.
                print("done with task")
                NotificationCenter.default.removeObserver(progressObserver as Any)
                
            }
            
        }
                
    }
    
    // MARK: Segue Prep
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        print("prepare for segue")
        
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
                
                vc.seeLog = seeLog
                vc.standingUp = standingUp
                vc.isInstallingBitcoin = isInstallingBitcoin
                vc.isInstallingTor = isInstallingTor
                vc.bitcoinInstalled = bitcoinInstalled
                vc.torInstalled = torInstalled
                
            }
            
        default:
            
            break
            
        }
        
    }
    
}

