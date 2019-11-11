//
//  Settings.swift
//  StandUp
//
//  Created by Peter on 08/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Cocoa

class Settings: NSViewController {
    
    var outputPipe:Pipe!
    var buildTask:Process!
    @IBOutlet var directoryLabel: NSTextField!
    @IBOutlet var textInput: NSTextField!
    var filesList: [URL] = []
    var showInvisibles = false
    var selectedFolder:URL!
    var selectedItem:URL!
    let ud = UserDefaults.standard
    
    @IBOutlet var pruneOutlet: NSButton!
    @IBOutlet var mainnetOutlet: NSButton!
    @IBOutlet var testnetOutlet: NSButton!
    @IBOutlet var regtestOutlet: NSButton!
    @IBOutlet var txIndexOutlet: NSButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        getSettings()
    }
    
    func getSettings() {
        
        getSetting(key: "pruned", button: pruneOutlet, def: 0)
        getSetting(key: "txIndex", button: txIndexOutlet, def: 1)
        getSetting(key: "mainnet", button: mainnetOutlet, def: 0)
        getSetting(key: "testnet", button: testnetOutlet, def: 1)
        getSetting(key: "regtest", button: regtestOutlet, def: 0)
        
        if ud.object(forKey: "dataDir") != nil {
            
            DispatchQueue.main.async {
                self.directoryLabel.stringValue = "\(self.ud.object(forKey: "dataDir") ?? "~/Library/Application Support/Bitcoin")"
            }
            
        }
        
    }
    
    func getSetting(key: String, button: NSButton, def: Int) {
        
        if ud.object(forKey: key) == nil {
            
            ud.set(def, forKey: key)
            
        } else {
            
            let raw = ud.integer(forKey: key)
            
            if raw == 0 {
                
                DispatchQueue.main.async {
                    
                    button.state = NSControl.StateValue.off
                    
                }
                
            } else {
               
                DispatchQueue.main.async {
                    
                    button.state = NSControl.StateValue.on
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.dismiss(self)
            
        }
        
    }
    
    @IBAction func didSetPrune(_ sender: Any) {
        
        setOutlet(outlet: pruneOutlet, keyOn: "pruned", keyOff: ["txIndex"])
        updateBlockchainOutlets(activeOutlet: pruneOutlet)
        
    }
    
    @IBAction func didSetTxIndex(_ sender: Any) {
        
        setOutlet(outlet: txIndexOutlet, keyOn: "txIndex", keyOff: ["pruned"])
        updateBlockchainOutlets(activeOutlet: txIndexOutlet)
        
    }
    
    func updateBlockchainOutlets(activeOutlet: NSButton) {
        
        let outlets = [pruneOutlet, txIndexOutlet]
        
        DispatchQueue.main.async {
            
            for o in outlets {
                
                if o != activeOutlet {
                    
                    let b = o?.state
                    
                    if b == NSControl.StateValue.on {
                        
                        DispatchQueue.main.async {
                            o?.state = NSControl.StateValue.off
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func didSetMainnet(_ sender: Any) {
        
        setOutlet(outlet: mainnetOutlet, keyOn: "mainnet", keyOff: ["testnet", "regtest"])
        
    }
    
    @IBAction func didSetTestnet(_ sender: Any) {
        
        setOutlet(outlet: testnetOutlet, keyOn: "testnet", keyOff: ["mainnet", "regtest"])
        updateNetworkOutlets(activeOutlet: testnetOutlet)
        
    }
    
    @IBAction func didSetRegtest(_ sender: Any) {
        
        setOutlet(outlet: regtestOutlet, keyOn: "regtest", keyOff: ["mainnet", "testnet"])
        updateNetworkOutlets(activeOutlet: regtestOutlet)
        
    }
    
    func setOutlet(outlet: NSButton, keyOn: String, keyOff: [String]) {
        
        let b = outlet.state.rawValue
        ud.set(b, forKey: keyOn)
        updateNetworkOutlets(activeOutlet: outlet)
        
        if b == 0 {
            
            ud.set(1, forKey: keyOn)
            
        } else {
            
            if keyOff.count == 2 {
                
                ud.set(0, forKey: keyOff[0])
                ud.set(0, forKey: keyOff[1])
                
            } else {
                
                ud.set(0, forKey: keyOff[0])
                
            }
            
        }
        
    }
    
    func updateNetworkOutlets(activeOutlet: NSButton) {
        
        let outlets = [regtestOutlet, testnetOutlet, mainnetOutlet]
        
        DispatchQueue.main.async {
            
            for o in outlets {
                
                if o != activeOutlet {
                    
                    let b = activeOutlet.state
                    
                    if b == NSControl.StateValue.on {
                        
                        DispatchQueue.main.async {
                            o?.state = NSControl.StateValue.off
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func chooseDirectory(_ sender: Any) {
        
        guard let window = view.window else { return }
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        panel.beginSheetModal(for: window) { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                self.selectedFolder = panel.urls[0]
                DispatchQueue.main.async {
                    self.directoryLabel.stringValue = self.selectedFolder?.path ?? "~/Library/Application Support/Bitcoin/"
                    self.ud.set(panel.urls[0], forKey: "dataDir")
                }
            }
        }
        
    }
    
    
    @IBAction func addPubkey(_ sender: Any) {
        
        if textInput.stringValue != "" {
            
            let str = textInput.stringValue
            showAlertMessage(message: "Set V3 authorized_client pubkey?", info: str)
            
        }
        
    }
    
    func showAlertMessage(message: String, info: String) {
        
        DispatchQueue.main.async {
            
            let a = NSAlert()
            a.messageText = message
            a.informativeText = info
            a.addButton(withTitle: "Yes")
            a.addButton(withTitle: "No")
            let response = a.runModal()
            
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                
                self.runLaunchScript(script: .authenticate)
                
            } else {
                
                print("tapped no")
                
            }
            
        }
        
    }
    
    func success(pk: String) {
        
        DispatchQueue.main.async {
            
            let a = NSAlert()
            a.messageText = "Succesfully added \(pk)"
            a.addButton(withTitle: "OK")
            a.runModal()
            
        }
        
    }
    
    func runLaunchScript(script: SCRIPT) {
        print("runlaunchscript")
        
        var pubkey = ""
        let filename = randomString(length: 10)
        
        DispatchQueue.main.async {
            
            pubkey = self.textInput.stringValue
            let resource = script.rawValue
                
                guard let path = Bundle.main.path(forResource: resource, ofType: "command") else {
                    print("Unable to locate \(resource).command")
                    return
                }

                self.buildTask = Process()
                self.buildTask.launchPath = path
                self.buildTask.arguments = [pubkey,filename]

                self.buildTask.terminationHandler = {

                    task in

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
                
                outHandle.waitForDataInBackgroundAndNotify()
                
            } else {
                
                // That means we've reached the end of the input.
                print("done with task")
                
                DispatchQueue.main.async {
                    let pk = self.textInput.stringValue
                    self.success(pk: pk)
                    self.textInput.stringValue = ""
                    self.textInput.resignFirstResponder()
                }
                
                NotificationCenter.default.removeObserver(progressObserver as Any)
                
            }
            
        }
                
    }
    
    func infoAbout(url: URL) -> String {
      return "No information available for \(url.path)"
    }
    
    func contentsOf(folder: URL) -> [URL] {
      return []
    }
    
}
