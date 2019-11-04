//
//  Installer.swift
//  FullyNoded
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
    var brewInstalled = Bool()
    var wgetInstalled = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScene()
        filterAction()
        
    }
    
    func filterAction() {
        
        // Checks which button was pressed and starts installation process depending on whether dependencies are insatalled or not, when one task finishes it will trigger the next in func centralStation()
        
        spinner.startAnimation(self)
        var desc = ""
        
        if wgetInstalled, brewInstalled {

            if isInstallingBitcoin {

                desc = "Getting signatures for Bitcoin Core..."
                runScript(script: .getPGPKeys)

            } else if isInstallingTor {

                desc = "Intsalling Tor..."
                runScript(script: .getTor)
            }

        } else if !brewInstalled {

            desc = "Installing brew..."
            runScript(script: .getBrew)

        }
        
        DispatchQueue.main.async {
            
            self.spinnerDescription.stringValue = desc
            
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        if let presenter = presentingViewController as? ViewController {
            
            presenter.bitcoinInstalled = bitcoinInstalled
            presenter.wgetInstalled = wgetInstalled
            presenter.brewInstalled = brewInstalled
            presenter.torInstalled = torInstalled
            
            DispatchQueue.main.async {
                
                if self.bitcoinInstalled {
                    
                    presenter.installBitcoindOutlet.isEnabled = false
                    presenter.bitcoinCoreStatusLabel.stringValue = "✅ Bitcoin Core installed"
                    
                }
                
                if self.torInstalled {
                    
                    presenter.installTorOutlet.isEnabled = false
                    presenter.torStatusLabel.stringValue = "✅ Tor installed"
                    
                }
                
            }
            
        }
        
        DispatchQueue.main.async {
        
            self.dismiss(self)
            
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
            //This never gets called becasue i never manually terminate the task
            
            print("finished with task")
            
            NotificationCenter.default.removeObserver(terminationObserver as Any)
            
        }
                
    }
    
    func centralStation(script: SCRIPT) {
        
        switch script {
            
        case .getBitcoinCore:
            
            bitcoinCoreInstallComplete()
            
        case .getTor:
            
            torInstallComplete()
            
        case .getBrew:
            
            brewInstallComplete()
            
        case .getWget:
            
            wgetInstallComplete()
            
        case .getPGPKeys:
            
            pgpKeysBitcoinCoreComplete()
            
        default:
            
            self.hideSpinner()
            
        }
        
    }
    
    func  bitcoinCoreInstallComplete() {
        
        self.bitcoinInstalled = true
        
        DispatchQueue.main.async {
            
            self.hideSpinner()
            self.dismiss(self)
            
        }
        
    }
    
    func torInstallComplete() {
        
        self.torInstalled = true
        self.hideSpinner()
        
    }
    
    func brewInstallComplete() {
        
        self.brewInstalled = true
        runScript(script: .getWget)
        
    }
    
    func wgetInstallComplete() {
        
        self.wgetInstalled = true
        
        if isInstallingBitcoin {
            
            DispatchQueue.main.async {
                
                self.spinnerDescription.stringValue = "Getting Bitcoin Core signatures and SHA..."
                
            }
            
            runScript(script: .getPGPKeys)
            
        } else if isInstallingTor {
            
            DispatchQueue.main.async {
                
                self.spinnerDescription.stringValue = "Getting Tor..."
                
            }
            
            runScript(script: .getTor)
            
        }
        
    }
    
    func pgpKeysBitcoinCoreComplete() {
        
        if isInstallingBitcoin {

            DispatchQueue.main.async {

                self.spinnerDescription.stringValue = "Downloading Bitcoin Core..."

            }

            runScript(script: .getBitcoinCore)

        }
        
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
