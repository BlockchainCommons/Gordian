//
//  Installer.swift
//  StandUp
//
//  Created by Peter on 07/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Cocoa

class Installer: NSViewController {
    
    @IBOutlet var spinner: NSProgressIndicator!
    @IBOutlet var spinnerDescription: NSTextField!
    @IBOutlet var backButtonOutlet: NSButton!
    @IBOutlet var consoleOutput: NSTextView!
    var seeLog = Bool()
    var standingUp = Bool()
    var args = [String]()
    var standingDown = Bool()
    var upgrading = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScene()
        filterAction()
        
    }
    
    func showSpinner(description: String) {
        
        DispatchQueue.main.async {
            self.spinner.alphaValue = 1
            self.spinnerDescription.stringValue = description
            self.spinner.startAnimation(self)
            self.spinnerDescription.alphaValue = 1
        }
        
    }
    
    func getURLs() {
        
        showSpinner(description: "Fetching latest Bitcoin Core version and URL's...")
        let request = FetchJSON()
        request.getRequest { (dict, error) in
            
            if error != "" {
                
                self.hideSpinner()
                setSimpleAlert(message: "Error", info: "There was an error fetching the latest Bitcoin Core version number and related URL's, please check your internet connection and try again", buttonLabel: "OK")
                
            } else {
                
                let binaryName = dict!["macosBinary"] as! String
                let macosURL = dict!["macosURL"] as! String
                let shaURL = dict!["shaURL"] as! String
                let version = dict!["version"] as! String
                self.showSpinner(description: "Setting Up...")
                
                if self.upgrading {
                    
                    self.upgradeBitcoinCore(binaryName: binaryName, macosURL: macosURL, shaURL: shaURL, version: version)
                    
                } else {
                    
                    self.getSettings(binaryName: binaryName, macosURL: macosURL, shaURL: shaURL, version: version)
                    
                }
                
            }
            
        }
        
    }
    
    func getSettings(binaryName: String, macosURL: String, shaURL: String, version: String) {
        
        let ud = UserDefaults.standard
        var rpcpassword = getExisistingRPCCreds().rpcpassword
        var rpcuser = getExisistingRPCCreds().rpcuser
        if rpcpassword == "" { rpcpassword = randomString(length: 32) }
        if rpcuser == "" { rpcuser = randomString(length: 10) }
        let prune = ud.object(forKey: "pruned") as? Int ?? 0
        let txIndex = ud.object(forKey: "txIndex") as? Int ?? 1
        var dataDir = ud.object(forKey: "dataDir") as? String ?? ""
        if dataDir == "~/Library/Application Support/Bitcoin" {
            dataDir = ""
        }
        let testnet = ud.object(forKey: "testnet") as? Int ?? 1
        let mainnet = ud.object(forKey: "mainnet") as? Int ?? 0
        let regtest = ud.object(forKey: "regtest") as? Int ?? 0
        let walletDisabled = ud.object(forKey: "walletDisabled") as? Int ?? 0
        args.removeAll()
        args.append(rpcpassword)
        args.append(rpcuser)
        args.append(dataDir)
        args.append("\(prune)")
        args.append("\(mainnet)")
        args.append("\(testnet)")
        args.append("\(regtest)")
        args.append("\(txIndex)")
        args.append("\(walletDisabled)")
        showSpinner(description: "Standing Up (this can take awhile)...")
        standUp(binaryName: binaryName, macosURL: macosURL, shaURL: shaURL, version: version)
        
    }
    
    func filterAction() {
        
        var desc = ""
        
        if seeLog {
            
            spinner.alphaValue = 0
            seeLog = false
            showLog()
            
        } else if standingUp {
            
            standingUp = false
            getURLs()
            
        } else if standingDown {
            
            standingDown = false
            spinner.startAnimation(self)
            desc = "Standing Down..."
            standDown()
            
        } else if upgrading {
            
            getURLs()
            
        }
        
        DispatchQueue.main.async {
            
            self.spinnerDescription.stringValue = desc
            
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        goBack()
        
    }
    
    func goBack() {
        print("go back")
        
        DispatchQueue.main.async {
            
            self.hideSpinner()
            
            if let presenter = self.presentingViewController as? ViewController {
                
                presenter.standingUp = false
                presenter.checkBitcoindVersion()
                
            }
            
            DispatchQueue.main.async {
                
                self.dismiss(self)
                
            }
            
        }
        
    }
    
    func standDown() {
        
        let runBuildTask = RunBuildTask()
        runBuildTask.showLog = true
        runBuildTask.args = []
        runBuildTask.textView = consoleOutput
        runBuildTask.exitStrings = ["Finished"]
        runBuildTask.runScript(script: .standDown) {
            
            if !runBuildTask.errorBool {
                
                DispatchQueue.main.async {
                    
                    self.spinner.stopAnimation(self)
                    self.spinner.alphaValue = 0
                    self.spinnerDescription.stringValue = ""
                    self.setLog()
                    setSimpleAlert(message: "Success", info: "You have StoodDown", buttonLabel: "OK")
                    
                }
                
            } else {
                
                setSimpleAlert(message: "Error", info: runBuildTask.errorDescription, buttonLabel: "OK")
                
            }
            
        }
        
    }
    
    func standUp(binaryName: String, macosURL: String, shaURL: String, version: String) {
        
        DispatchQueue.main.async {
            
            let runBuildTask = RunBuildTask()
            runBuildTask.args = self.args
            runBuildTask.env = ["BINARY_NAME":binaryName, "MACOS_URL":macosURL, "SHA_URL":shaURL, "VERSION":version]
            runBuildTask.textView = self.consoleOutput
            runBuildTask.showLog = true
            runBuildTask.exitStrings = ["Successfully started `tor`", "Service `tor` already started", "Signatures do not match! Terminating..."]
            runBuildTask.runScript(script: .standUp) {
                
                if !runBuildTask.errorBool {
                    
                    DispatchQueue.main.async {
                        self.setLog()
                        self.goBack()
                    }
                    
                } else {
                    
                   setSimpleAlert(message: "Error", info: runBuildTask.errorDescription, buttonLabel: "OK")
                    
                }
                
            }
            
        }
        
    }
    
    func upgradeBitcoinCore(binaryName: String, macosURL: String, shaURL: String, version: String) {
        
        upgrading = false
        
        DispatchQueue.main.async {
            
            let runBuildTask = RunBuildTask()
            runBuildTask.args = []
            runBuildTask.env = ["BINARY_NAME":binaryName, "MACOS_URL":macosURL, "SHA_URL":shaURL, "VERSION":version]
            runBuildTask.textView = self.consoleOutput
            runBuildTask.showLog = true
            runBuildTask.exitStrings = ["You have upgraded to Bitcoin Core", "Signatures do not match! Terminating..."]
            runBuildTask.runScript(script: .standUp) {
                
                if !runBuildTask.errorBool {
                    
                    DispatchQueue.main.async {
                        self.setLog()
                        self.goBack()
                    }
                    
                } else {
                    
                   setSimpleAlert(message: "Error", info: runBuildTask.errorDescription, buttonLabel: "OK")
                    
                }
                
            }
            
        }
        
    }
    
    func hideSpinner() {
        
        DispatchQueue.main.async {
        
            self.spinnerDescription.stringValue = ""
            self.spinner.stopAnimation(self)
            
        }
        
    }
    
    func setScene() {
        
        consoleOutput.textColor = NSColor.green
        consoleOutput.isEditable = false
        consoleOutput.isSelectable = false
        spinnerDescription.stringValue = ""
        
    }
    
    func setLog() {
        
        let file = "log.txt"
        let text = self.consoleOutput.string
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            do {
                
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                
            } catch {
                
                print("error setting log")
                
            }
            
        }
        
    }
    
    func showLog() {
        
        seeLog = false
        let file = "log.txt"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            do {
                
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                
                DispatchQueue.main.async {
                    self.consoleOutput.string = text2
                }
                
            } catch {
                
                DispatchQueue.main.async {
                    self.consoleOutput.string = "Error getting log, possibly does not exist yet..."
                }
                
            }
            
        }
        
    }
    
    func getExisistingRPCCreds() -> (rpcuser: String, rpcpassword: String) {
        
        let runAppleScript = RunAppleScript()
        var user = ""
        var password = ""
        
        runAppleScript.runScript(script: .getRPCCredentials) {
            
            if !runAppleScript.errorBool {
                
                let conf = (runAppleScript.stringToReturn).components(separatedBy: "\r")
                
                for item in conf {
                    
                    if item.contains("rpcuser") {
                        
                        let arr = item.components(separatedBy: "rpcuser=")
                        user = arr[1]
                        
                    }
                    
                    if item.contains("rpcpassword") {
                        
                        let arr = item.components(separatedBy: "rpcpassword=")
                        password = arr[1]
                        
                    }
                    
                }
                
                
            } else {
                
                print("no existing rpc creds")
                
            }
            
        }
        
        return (user, password)
        
    }
    
}
