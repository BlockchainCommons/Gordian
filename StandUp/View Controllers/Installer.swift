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
    var isInstallingBitcoin = Bool()
    var isInstallingTor = Bool()
    var seeLog = Bool()
    var standingUp = Bool()
    var args = [String]()
    var standingDown = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScene()
        getSettings()
        filterAction()
        
    }
    
    func getSettings() {
        
        let ud = UserDefaults.standard
        let rpcpassword = randomString(length: 32)
        let rpcuser = randomString(length: 10)
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
        args.append(rpcpassword)
        args.append(rpcuser)
        args.append(dataDir)
        args.append("\(prune)")
        args.append("\(mainnet)")
        args.append("\(testnet)")
        args.append("\(regtest)")
        args.append("\(txIndex)")
        args.append("\(walletDisabled)")
        
    }
    
    func filterAction() {
        
        var desc = ""
        
        if seeLog {
            
            spinner.alphaValue = 0
            seeLog = false
            showLog()
            
        } else if standingUp {
            
            standingUp = false
            spinner.startAnimation(self)
            desc = "Standing Up (this can take awhile)..."
            standUp()
            
        } else if standingDown {
            
            standingDown = false
            spinner.startAnimation(self)
            desc = "Standing Down..."
            standDown()
            
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
                print("checkBitcoindVersion")
                
            }
            
            DispatchQueue.main.async {
                
                self.dismiss(self)
                
            }
            
        }
        
    }
    
    func standDown() {
        
        let runBuildTask = RunBuildTask.sharedInstance
        runBuildTask.args = []
        runBuildTask.textView = consoleOutput
        runBuildTask.exitStrings = ["Finished"]
        
        func completed() {
            
            if !runBuildTask.errorBool {
                
                DispatchQueue.main.async {
                    
                    self.spinner.stopAnimation(self)
                    self.spinner.alphaValue = 0
                    self.spinnerDescription.stringValue = ""
                    self.setLog()
                    let a = NSAlert()
                    a.messageText = "Success"
                    a.informativeText = "You have StoodDown"
                    a.addButton(withTitle: "OK")
                    a.runModal()
                    
                }
                
            } else {
                
                DispatchQueue.main.async {
                    
                    let a = NSAlert()
                    a.messageText = "Error"
                    a.addButton(withTitle: runBuildTask.errorDescription)
                    a.runModal()
                    
                }
                
            }
            
        }
        
        runBuildTask.runScript(script: .standDown, completion: completed)
        
    }
    
    func standUp() {
        
        let runBuildTask = RunBuildTask.sharedInstance
        runBuildTask.args = args
        runBuildTask.textView = consoleOutput
        runBuildTask.exitStrings = ["Successfully started `tor`", "Service `tor` already started", "Signatures do not match! Terminating..."]
        
        func completed() {
            
            if !runBuildTask.errorBool {
                
                DispatchQueue.main.async {
                    self.setLog()
                    self.goBack()
                }
                
            } else {
                
                DispatchQueue.main.async {
                    
                    let a = NSAlert()
                    a.messageText = "Error"
                    a.addButton(withTitle: runBuildTask.errorDescription)
                    a.runModal()
                    
                }
                
            }
            
        }
        
        runBuildTask.runScript(script: .standUp, completion: completed)
        
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
    
}
