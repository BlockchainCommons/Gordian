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
    dynamic var isRunning = false
    var outputPipe:Pipe!
    var buildTask:Process!
    var seeLog = Bool()
    var bitcoinInstalled = Bool()
    var torInstalled = Bool()
    var standingUp = Bool()
    var args = [String]()
    var dismissing = Bool()

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
        args.append(rpcpassword)
        args.append(rpcuser)
        args.append(dataDir)
        args.append("\(prune)")
        args.append("\(mainnet)")
        args.append("\(testnet)")
        args.append("\(regtest)")
        args.append("\(txIndex)")
        
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
            runScript(script: .standUp)
            
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
        
        if !dismissing {
            
            DispatchQueue.main.async {
                
                self.hideSpinner()
                
                if let presenter = self.presentingViewController as? ViewController {
                    
                    presenter.seeLog = false
                    presenter.standingUp = false
                    presenter.checkBitcoindVersion()
                    print("checkBitcoindVersion")
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.dismissing = true
                    self.dismiss(self)
                    
                }
                
            }
            
        }
        
    }
    
    func runScript(script: SCRIPT) {

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
            self.buildTask.arguments = self.args

            self.buildTask.terminationHandler = {

                task in
                
                print("task did terminate")
                
                DispatchQueue.main.async {
                    self.isRunning = false
                    self.setLog()
                    self.goBack()
                }

            }

            self.captureStandardOutputAndRouteToTextView(task: self.buildTask, script: script)
            self.buildTask.launch()
            self.buildTask.waitUntilExit()

        }

    }
    
    func captureStandardOutputAndRouteToTextView(task:Process, script: SCRIPT) {
        
        let stdOut = Pipe()
        let stdErr = Pipe()
        task.standardOutput = stdOut
        task.standardError = stdErr
        
        let handler = { (file: FileHandle!) -> Void in
            
            let data = file.availableData
            
            if self.isRunning {
                
                guard let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                    return
                }
                
                DispatchQueue.main.async {
                    
                    let prevOutput = self.consoleOutput.string
                    let nextOutput = prevOutput + (output as String)
                    self.consoleOutput.string = nextOutput
                    
                    
                    if (output as String).contains("Successfully started `tor`") || (output as String).contains("Service `tor` already started") || (output as String).contains("Signatures do not match! Terminating...") {
                        
                        self.isRunning = false
                        self.buildTask.terminate()
                        
                        do {
                            
                            if #available(OSX 10.15, *) {
                                try file.close()
                                print("file closed")
                            } else {
                                // Fallback on earlier versions
                            }
                            
                            
                        } catch {
                            
                            print("failed closing file")
                            
                        }
                        
                    } else {
                        
                        if self.isRunning {
                            
                            self.consoleOutput.scrollToEndOfDocument(self)
                            
                        }
                        
                    }
                    
                    print("scroll down")
                    
                }
                
            }
            
        }
        
        stdErr.fileHandleForReading.readabilityHandler = handler
        stdOut.fileHandleForReading.readabilityHandler = handler
        
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
