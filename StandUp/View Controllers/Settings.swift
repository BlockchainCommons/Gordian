//
//  Settings.swift
//  StandUp
//
//  Created by Peter on 08/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Cocoa

class Settings: NSViewController {
    
    var filesList: [URL] = []
    var showInvisibles = false
    var selectedFolder:URL!
    var selectedItem:URL!
    let ud = UserDefaults.standard
    var seeLog = Bool()
    var standingDown = Bool()
    var args = [String]()
    
    @IBOutlet var directoryLabel: NSTextField!
    @IBOutlet var textInput: NSTextField!
    @IBOutlet var nodeLabelField: NSTextField!
    @IBOutlet var walletDisabled: NSButton!
    @IBOutlet var pruneOutlet: NSButton!
    @IBOutlet var mainnetOutlet: NSButton!
    @IBOutlet var testnetOutlet: NSButton!
    @IBOutlet var regtestOutlet: NSButton!
    @IBOutlet var txIndexOutlet: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSettings()
        
    }
    
    // MARK: User Actions
    
    @IBAction func seeStandUpLog(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.seeLog = true
            self.standingDown = false
            self.performSegue(withIdentifier: "seeLog", sender: self)
            
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.dismiss(self)
        }
        
    }
    
    @IBAction func removeStandUp(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            actionAlert(message: "Danger!", info: "This will remove the StandUp directory, remove tor config, tor hidden services and uninstall tor.\n\nAre you aure you want to do this?") { (response) in
                
                if response {
                    
                    self.seeLog = false
                    self.standingDown = true
                    self.performSegue(withIdentifier: "seeLog", sender: self)
                    
                } else {
                    
                    print("tapped no")
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func removeBitcoinCore(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            actionAlert(message: "Danger!", info: "This will remove the Bitcoin directory! All Bitcoin Core data including your wallets will be deleted!\n\nAre you sure you want to continue?") { (response) in
                
                let datadir = self.ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/Library/Application Support/Bitcoin"
                
                if response {
                    
                    let runBuildTask = RunBuildTask()
                    runBuildTask.args = []
                    runBuildTask.showLog = false
                    runBuildTask.env = ["DATADIR":datadir]
                    runBuildTask.exitStrings = ["Done"]
                    runBuildTask.runScript(script: .removeBitcoin) {
                        
                        if !runBuildTask.errorBool {
                            
                            setSimpleAlert(message: "Bitcoin directory and its contents were deleted", info: "", buttonLabel: "OK")
                            
                        } else {
                            
                            setSimpleAlert(message: "Error", info: runBuildTask.errorDescription, buttonLabel: "OK")
                            
                        }
                        
                    }
                    
                } else {
                    
                    print("tap no")
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func saveNodeLabel(_ sender: Any) {
        
        if nodeLabelField.stringValue != "" {
            
            ud.set(nodeLabelField.stringValue, forKey: "nodeLabel")
            
            setSimpleAlert(message: "Success", info: "Node label updated to: \(nodeLabelField.stringValue)", buttonLabel: "OK")
        }
        
    }
    
    @IBAction func didSetWalletDisabled(_ sender: Any) {
        
        let value = walletDisabled.state.rawValue
        updateBitcoinConf(keyToUpdate: .walletdisabled, newValue: value, outlet: walletDisabled)
        
    }
    
    @IBAction func didSetPrune(_ sender: Any) {
        
        let value = pruneOutlet.state.rawValue
        updateBitcoinConf(keyToUpdate: .pruned, newValue: value, outlet: pruneOutlet)
        
    }
    
    @IBAction func didSetTxIndex(_ sender: Any) {
        
        let value = txIndexOutlet.state.rawValue
        updateBitcoinConf(keyToUpdate: .txIndex, newValue: value, outlet: txIndexOutlet)
        
    }
    
    @IBAction func didSetMainnet(_ sender: Any) {
        
        let value = mainnetOutlet.state.rawValue
        updateBitcoinConf(keyToUpdate: .mainnet, newValue: value, outlet: mainnetOutlet)
    }
    
    @IBAction func didSetTestnet(_ sender: Any) {
        
        let value = testnetOutlet.state.rawValue
        updateBitcoinConf(keyToUpdate: .testnet, newValue: value, outlet: testnetOutlet)
        
    }
    
    @IBAction func didSetRegtest(_ sender: Any) {
        
        let value = regtestOutlet.state.rawValue
        updateBitcoinConf(keyToUpdate: .regtest, newValue: value, outlet: regtestOutlet)
        
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
                    self.directoryLabel.stringValue = self.selectedFolder?.path ?? "/Users/\(NSUserName())/Library/Application Support/Bitcoin"
                    self.ud.set(panel.urls[0], forKey: "dataDir")
                    //self.updateDataDir()
                }
            }
        }
        
    }
    
    @IBAction func addPubkey(_ sender: Any) {
        
        if textInput.stringValue != "" {
            
            let info = textInput.stringValue
            
            DispatchQueue.main.async {
                
                actionAlert(message: "Set V3 authorized_client pubkey?", info: info) { (response) in
                    
                    if response {
                        
                        self.authenticate()
                        
                    } else {
                        
                        print("tapped no")
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: Action Logic
    
    func updateBitcoinConf(keyToUpdate: BTCCONF, newValue: Any, outlet: NSButton) {
        print("updateBitcoinConf key:\(keyToUpdate.rawValue) value: \(newValue)")
        
        DispatchQueue.main.async {
            
            actionAlert(message: "Update bitcoin.conf?", info: "Do you want to update your bitcoin.conf with \(keyToUpdate.rawValue)=\(newValue)?\n\nThis will be updated in real time, in order for the changes to take effect you need to restart your node.\n\nPlease keep in mind this refreshes your bitcoin.conf to match the settings you have here, if you have customized your bitcoin.conf then you are better off making the changes manually.") { (response) in
                
                if response {
                    
                    self.updateBitcoinConfNow(outlet: outlet, keyOn: keyToUpdate)
                    
                } else {
                    
                    print("tapped no")
                    DispatchQueue.main.async {
                        switch keyToUpdate {
                        case .walletdisabled: self.walletDisabled.setNextState()
                        case .pruned: self.pruneOutlet.setNextState()
                        case .mainnet: self.mainnetOutlet.setNextState()
                        case .testnet: self.testnetOutlet.setNextState()
                        case .regtest: self.regtestOutlet.setNextState()
                        case .txIndex: self.txIndexOutlet.setNextState()
                        default: break}
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func updateBitcoinConfNow(outlet: NSButton, keyOn: BTCCONF) {
        print("updateBitcoinConfNow key:\(keyOn.rawValue)")
        
        setOutlet(outlet: outlet, keyOn: keyOn)
        getBitcoinConfSettings()
        let runBuildTask = RunBuildTask()
        runBuildTask.args = args
        runBuildTask.showLog = false
        runBuildTask.exitStrings = ["Done"]
        runBuildTask.runScript(script: .updateBTCConf) {
            
            if !runBuildTask.errorBool {
                
                DispatchQueue.main.async {
                    setSimpleAlert(message: "Success", info: "bitcoin.conf updated", buttonLabel: "OK")
                }
                
            } else {
                
                setSimpleAlert(message: "Error", info: runBuildTask.errorDescription, buttonLabel: "OK")
                
            }
            
        }
        
    }
    
    func authenticate() {
        
        let filename = randomString(length: 10)
        let pubkey = self.textInput.stringValue
        let runBuildScript = RunBuildTask()
        runBuildScript.args = [pubkey,filename]
        runBuildScript.exitStrings = ["Done"]
        runBuildScript.showLog = false
        runBuildScript.runScript(script: .authenticate) {
            
            if !runBuildScript.errorBool {
                
                DispatchQueue.main.async {
                    setSimpleAlert(message: "Success", info: "Added pubkey: \(pubkey)", buttonLabel: "OK")
                    self.textInput.stringValue = ""
                    self.textInput.resignFirstResponder()
                }
                
            } else {
                
               setSimpleAlert(message: "Error", info: "error authenticating", buttonLabel: "OK")
                
            }
            
        }
        
    }
    
    // MARK: Get bitcoin.conf and assign environment variables for script
    
    func getBitcoinConfSettings() {
        print("getBitcoinConfSettings")
        
        args.removeAll()
        
        getExisistingRPCCreds { (user, password) in
            
            let ud = UserDefaults.standard
            var rpcpassword = password
            var rpcuser = user
            if rpcpassword == "" { rpcpassword = randomString(length: 32) }
            if rpcuser == "" { rpcuser = randomString(length: 10) }
            let prune = ud.object(forKey: "pruned") as? Int ?? 0
            let txIndex = ud.object(forKey: "txIndex") as? Int ?? 1
            let dataDir = ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/Library/Application Support/Bitcoin"
            let testnet = ud.object(forKey: "testnet") as? Int ?? 1
            let mainnet = ud.object(forKey: "mainnet") as? Int ?? 0
            let regtest = ud.object(forKey: "regtest") as? Int ?? 0
            let walletDisabled = ud.object(forKey: "walletdisabled") as? Int ?? 0
            self.args.append(rpcpassword)
            self.args.append(rpcuser)
            self.args.append(dataDir)
            self.args.append("\(prune)")
            self.args.append("\(mainnet)")
            self.args.append("\(testnet)")
            self.args.append("\(regtest)")
            self.args.append("\(txIndex)")
            self.args.append("\(walletDisabled)")
            print("args = \(self.args)")
            
        }
        
    }
    
    func getExisistingRPCCreds(completion: @escaping ((user: String, password: String)) -> Void) {
        print("getExisistingRPCCreds")
        
        var user = ""
        var password = ""
        let runBuildTask = RunBuildTask()
        runBuildTask.args = []
        runBuildTask.showLog = false
        runBuildTask.exitStrings = ["Done"]
        runBuildTask.runScript(script: .getRPCCredentials) {
            
            if !runBuildTask.errorBool {
                
                let conf = (runBuildTask.stringToReturn).components(separatedBy: "\n")
                
                for item in conf {
                    
                    if item.contains("rpcuser") {
                        
                        let arr = item.components(separatedBy: "rpcuser=")
                        user = arr[1]
                        
                    }
                    
                    if item.contains("rpcpassword") {
                        
                        let arr = item.components(separatedBy: "rpcpassword=")
                        password = arr[1]
                        
                    }
                    
                    completion((user: user, password: password))
                    
                }
                
            } else {
                
                completion((user: "", password: ""))
                setSimpleAlert(message: "Error", info: runBuildTask.errorDescription, buttonLabel: "OK")
                
            }
            
        }
        
    }
    
    // MARK: Update User Interface
    
    func getSettings() {
        print("getSettings")
        
        getSetting(key: .pruned, button: pruneOutlet, def: 0)
        getSetting(key: .txIndex, button: txIndexOutlet, def: 1)
        getSetting(key: .mainnet, button: mainnetOutlet, def: 0)
        getSetting(key: .testnet, button: testnetOutlet, def: 1)
        getSetting(key: .regtest, button: regtestOutlet, def: 0)
        getSetting(key: .walletdisabled, button: walletDisabled, def: 0)
        
        if ud.object(forKey: "dataDir") != nil {
            
            let dd = ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/Library/Application Support/Bitcoin"
            
            DispatchQueue.main.async {
                self.directoryLabel.stringValue = dd
            }
            
        }
        
        if ud.object(forKey: "nodeLabel") != nil {
            
            DispatchQueue.main.async {
                self.nodeLabelField.stringValue = self.ud.object(forKey: "nodeLabel") as! String
            }
            
        }
        
    }
    
    func getSetting(key: BTCCONF, button: NSButton, def: Int) {
        print("getsetting")
        
        if ud.object(forKey: key.rawValue) == nil {
            ud.set(def, forKey: key.rawValue)
        } else {
            let raw = ud.integer(forKey: key.rawValue)
            if raw == 0 {
                DispatchQueue.main.async {
                    button.state = .off
                }
            } else {
                DispatchQueue.main.async {
                    button.state = .on
                }
            }
        }
        
    }
    
    func setOutlet(outlet: NSButton, keyOn: BTCCONF) {
        print("setoutlet")
        
        let b = outlet.state.rawValue
        let key = keyOn.rawValue
        ud.set(b, forKey: key)
        print("set key: \(key) to \(b)")
        let networkKeys = ["mainnet","testnet","regtest"]
        let blockchainKeys = ["txIndex","pruned"]
        var isNetwork = false
        var isWallet = false
        
        switch keyOn {
        case .mainnet, .testnet, .regtest: isNetwork = true
        case .txIndex, .pruned: isNetwork = false
        default: isWallet = true
        }
        
        if !isWallet {
            
            if b == 0 {
                
                ud.set(1, forKey: key)
                print("set key: \(key) to 1")
                
            } else {
                
                var isBlockchain = false
                
                if isNetwork {
                    
                    for k in networkKeys {
                        
                        if k != key {
                            
                            ud.set(0, forKey: k)
                            print("set key: \(k) to 0")
                            
                        }
                        
                    }
                                        
                } else {
                    
                    isBlockchain = true
                    
                    for k in blockchainKeys {
                        
                        if k != key {
                            
                            ud.set(0, forKey: k)
                            print("set key: \(k) to 0")
                            
                        }
                        
                    }
                                        
                }
                
                updateOutlets(activeOutlet: outlet, isBlockchain: isBlockchain)
                
            }
            
        }
        
    }
    
    func updateOutlets(activeOutlet: NSButton, isBlockchain: Bool) {
        
        var outlets:[NSButton]!
        
        if isBlockchain {
            
            outlets = [pruneOutlet, txIndexOutlet]
            
        } else {
            
            outlets = [regtestOutlet, testnetOutlet, mainnetOutlet]
            
        }
        
        DispatchQueue.main.async {
            for o in outlets {
                if o != activeOutlet {
                    let b = o.state
                    if b == .on {
                        DispatchQueue.main.async {
                            o.state = .off
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Miscellaneous
    
    func infoAbout(url: URL) -> String {
      return "No information available for \(url.path)"
    }
    
    func contentsOf(folder: URL) -> [URL] {
      return []
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "seeLog":
            
            if let vc = segue.destinationController as? Installer {
                
                vc.seeLog = seeLog
                vc.standingDown = standingDown
                
            }
            
        default:
            
            break
            
        }
        
    }
    
}
