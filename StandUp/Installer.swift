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
    var outputString = ""
    var bitcoinInstalled = Bool()
    var torInstalled = Bool()
    var standingUp = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScene()
        filterAction()
        
    }
    
    func filterAction() {
        
        var desc = ""
        spinner.startAnimation(self)
        
        if isInstallingBitcoin {
            
            desc = "Getting Bitcoin Core..."
            runScript(script: .getBitcoin)
            
        } else if isInstallingTor {
            
            desc = "Installing Tor..."
            runScript(script: .getTor)
            
        } else if standingUp {
            
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
        
        DispatchQueue.main.async {
            
            self.hideSpinner()
            
            if let presenter = self.presentingViewController as? ViewController {
                
                presenter.checkBitcoindVersion()
                
            }
            
            DispatchQueue.main.async {
            
                self.dismiss(self)
                
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
        
        outputPipe = Pipe()
        task.standardOutput = outputPipe
        let outHandle = outputPipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        
        var progressObserver : NSObjectProtocol!
        progressObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandle, queue: nil) {
            notification in
            
            self.outputString = ""
            let data = outHandle.availableData
            
            if data.count > 0 {
                
                if let str = String(data: data, encoding: String.Encoding.utf8) {
                    
                    let prevOutput = self.outputString
                    self.outputString = prevOutput + "\n" + str
                    
                    DispatchQueue.main.async {
                        self.consoleOutput.string = self.outputString
                        self.consoleOutput.scrollToEndOfDocument(self)
                    }
                    
                    if str.contains("==> Successfully started `tor`") {
                        
                        DispatchQueue.main.async {
                            self.goBack()
                        }
                        
                    }
                    
                }
                
                outHandle.waitForDataInBackgroundAndNotify()
                
            } else {
                
                // That means we've reached the end of the input.
                print("done with task")
                
                DispatchQueue.main.async {
                    
                    // On my PC this runs fine, on VMWare is does not trigger.. Why?
                    // Try terminating the task and creating a new one instead...
                    self.centralStation(script: script)
                    
                }
                
                NotificationCenter.default.removeObserver(progressObserver as Any)
                
            }
            
        }
                        
        var terminationObserver : NSObjectProtocol!
        terminationObserver = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: task, queue: nil) {
            
            notification -> Void in
            
            // Process was terminated. Hence, progress should be 100%
            print("task terminated")
            
            NotificationCenter.default.removeObserver(terminationObserver as Any)
            
        }
                
    }
    
    func centralStation(script: SCRIPT) {
        
        switch script {
        case .standUp: bitcoinInstalled = true; torInstalled = true; goBack()
        case .getTor: torInstallComplete()
        case .getBitcoin: bitcoinCoreInstallComplete()
        default: hideSpinner()
        }
        
    }
    
    func bitcoinCoreInstallComplete() {
        
        buildTask.terminate()
        isRunning = false
        self.bitcoinInstalled = true
        goBack()
        
    }
    
    func torInstallComplete() {
        
        buildTask.terminate()
        isRunning = false
        self.torInstalled = true
        goBack()
        
    }
    
    func hideSpinner() {
        
        DispatchQueue.main.async {
        
            self.spinnerDescription.stringValue = ""
            self.spinner.stopAnimation(self)
            
        }
        
    }
    
    func setScene() {
        
        spinner.startAnimation(self)
        consoleOutput.textColor = NSColor.green
        consoleOutput.isEditable = false
        consoleOutput.isSelectable = false
        spinnerDescription.stringValue = ""
        
    }
    
}
