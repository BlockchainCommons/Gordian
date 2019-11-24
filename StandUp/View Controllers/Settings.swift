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
    @IBOutlet var txIndexOutlet: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let d = Defaults()
        d.setDefaults() {
            
            self.getSettings()
            
        }
        
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
        
        goBackAndRefresh()
        
    }
    
    @IBAction func removeStandUp(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            actionAlert(message: "Danger!", info: "This will remove the StandUp directory including all its contents!\n\nThis will remove tor config, tor hidden services and uninstall tor.\n\nAre you aure you want to do this?") { (response) in
                
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
                                
                if response {
                    
                    let runBuildTask = RunBuildTask()
                    let d = Defaults()
                    runBuildTask.args = []
                    runBuildTask.showLog = false
                    runBuildTask.env = ["DATADIR":d.dataDir()]
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
        getBitcoinConf { (conf, error) in
            
            if !error {
                
                self.parseBitcoinConf(conf: conf, keyToUpdate: .walletdisabled, outlet: self.walletDisabled, newValue: value)
                
            }
            
        }
        
    }
    
    @IBAction func didSetPrune(_ sender: Any) {
        
        let value = pruneOutlet.state.rawValue
        getBitcoinConf { (conf, error) in
            
            if !error {
                
                self.parseBitcoinConf(conf: conf, keyToUpdate: .prune, outlet: self.pruneOutlet, newValue: value)
                
            }
            
        }
    }
    
    @IBAction func didSetTxIndex(_ sender: Any) {
        
        let value = txIndexOutlet.state.rawValue
        getBitcoinConf { (conf, error) in
            
            if !error {
                
                self.parseBitcoinConf(conf: conf, keyToUpdate: .txindex, outlet: self.txIndexOutlet, newValue: value)
                
            }
            
        }
        
    }
    
    @IBAction func didSetMainnet(_ sender: Any) {
        
        setOutlet(outlet: mainnetOutlet, keyOn: .mainnet)
        let value = mainnetOutlet.state.rawValue
        if value == 1 {
            
            // change testnet in bitcoin.conf
            getBitcoinConf { (conf, error) in
                
                if !error {
                    
                    self.parseBitcoinConf(conf: conf, keyToUpdate: .testnet, outlet: self.testnetOutlet, newValue: 0)
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func didSetTestnet(_ sender: Any) {
        
        setOutlet(outlet: testnetOutlet, keyOn: .testnet)
        let value = testnetOutlet.state.rawValue
        getBitcoinConf { (conf, error) in
            
            if !error {
                
                self.parseBitcoinConf(conf: conf, keyToUpdate: .testnet, outlet: self.testnetOutlet, newValue: value)
                
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
                    self.directoryLabel.stringValue = self.selectedFolder?.path ?? Defaults().dataDir()
                    self.ud.set(self.directoryLabel.stringValue, forKey: "dataDir")
                    self.getSettings()
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
    
    func setLog(content: String) {
        
        let lg = Log()
        lg.writeToLog(content: content)
        
    }
    
    func setBitcoinConf(conf: String, activeOutlet: NSButton, newValue: Int, key: String) {
        print("setBitcoinConf")
        
        let runBuildTask = RunBuildTask()
        let d = Defaults()
        runBuildTask.args = args
        runBuildTask.env = ["CONF":conf,"DATADIR":d.dataDir()]
        runBuildTask.showLog = false
        runBuildTask.exitStrings = ["Done"]
        runBuildTask.runScript(script: .updateBTCConf) {
            
            if !runBuildTask.errorBool {
                
                self.ud.set(newValue, forKey: key)
                self.setLog(content: runBuildTask.stringToReturn)
                setSimpleAlert(message: "Success", info: "bitcoin.conf updated", buttonLabel: "OK")
                
            } else {
                
                setSimpleAlert(message: "Error Updating bitcoin.conf", info: runBuildTask.errorDescription, buttonLabel: "OK")
                
            }
            
        }
        
    }
    
    func parseBitcoinConf(conf: [String], keyToUpdate: BTCCONF, outlet: NSButton, newValue: Int) {
        print("parseBitcoinConf")
        print("conf = \(conf)")
        print("keytoupdate = \(keyToUpdate)")
        print("outlet = \(outlet)")
        print("newValue = \(newValue)")
        
        var isUpdatingCorrectNetwork = false
        var isSectioned = false
        var sectionToUpdate = ""
        var section = ""
        var network = ""
        let mainnet = ud.object(forKey: "mainnet") as! Int
        let testnet = ud.object(forKey: "testnet") as! Int
        
        if mainnet == 1 {
            network = "mainnet"
        }
        if testnet == 1 {
            network = "testnet"
        }
        
        func alertSettingNotForCurrentNetwork() {
            
            setSimpleAlert(message: "Error", info: "You are attempting to update a setting that is network specific. You must select the correct network first then update the setting.", buttonLabel: "OK")
            
        }
        
        func revert() {
            
            DispatchQueue.main.async {
                outlet.setNextState()
            }
            
        }
        
        func updateGlobalConfArray(conf: [String], oldValue: Int, newValue: Int, key: String) {
            print("updateGlobalConfArray")
            
            // assuming there will only ever be one global instance of any given setting in bitcoin.conf outside of sections
            
            for c in conf {
                
                if c.contains("=") {
                    
                    let arr = c.components(separatedBy: "=")
                    let k = arr[0]
                    let existingValue = arr[1]
                    print("k = \(k)")
                    print("key = \(key)")
                    
                    if k.contains(key) {
                        
                        print("same")
                        
                        if let ev = Int(existingValue) {
                            
                            if oldValue == ev {
                                
                                var stringConf = conf.joined(separator: "\n")
                                stringConf = stringConf.replacingOccurrences(of: "\(key + "=" + existingValue)", with: "\(key + "=")\(newValue)")
                                setBitcoinConf(conf: stringConf, activeOutlet: outlet, newValue: newValue, key: key)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        func updateSectionConfArray(conf: [String], oldValue: Int, newValue: Int, key: String, sectionToUpdate: String, network: String) {
            
            // manipulate the conf array then call setBitcoinConf()
            var isInOurSection = false
            var currentSection = ""
            
            for (index, c) in conf.enumerated() {
                
                // find the section first
                if c.contains(sectionToUpdate) {
                    
                    isInOurSection = true
                    print("c = \(c)")
                    currentSection = c
                    
                }
                
                if c.contains("=") && isInOurSection {
                    
                    print("these are the settings in our section")
                    let arr = c.components(separatedBy: "=")
                    let k = arr[0]
                    let existingValue = arr[1]
                    print("k = \(k)")
                    print("existingValue = \(existingValue)")
                    
                    if k == key {
                        
                        print("in section \(currentSection)")
                        print("this is the setting to update: \(k)=\(existingValue) to \(k)=\(newValue)")
                        var updatedConf = conf
                        updatedConf[index] = "\(k)=\(newValue)"
                        let stringConf = updatedConf.joined(separator: "\n")
                        print("stringConf = \(stringConf)")
                        setBitcoinConf(conf: stringConf, activeOutlet: outlet, newValue: newValue, key: key)
                    }
                    
                }
                
                if c.contains("[") && !c.contains(sectionToUpdate) {
                    
                    isInOurSection = false
                    
                }
                
            }
            
        }
        
        for setting in conf {
            
            if setting.contains("=") {
                print("contains =")
                
                let arr = setting.components(separatedBy: "=")
                let key = arr[0]
                let value = arr[1]
                print("key = \(key)")
                print("value = \(value)")
                print("keytoupdate = \(keyToUpdate.rawValue)")
                
                func confirmForNetworkSpecificChange() {
                    
                    actionAlert(message: "Update bitcoin.conf?", info: "You are attemtping to update \(key)=\(value) to \(key)=\(newValue) in the \(section) section of your bitcoin.conf.\n\nIn order for the changes to take effect you will need to restart Bitcoin Core.\n\nAre you sure you want to proceed?") { (response) in
                        
                        if response {
                            
                            print("do it")
                            
                            if let i = Int(value) {
                                
                                updateSectionConfArray(conf: conf, oldValue: i, newValue: newValue, key: key, sectionToUpdate: sectionToUpdate, network: network)
                                
                            } else {
                                
                                setSimpleAlert(message: "Error", info: "We had an error updating your bitcoin.conf file", buttonLabel: "OK")
                                
                            }
                            
                        } else {
                            
                            print("user said no")
                            revert()
                            
                        }
                        
                    }
                    
                }
                
                if keyToUpdate.rawValue == key {
                    
                    print("global setting")
                    print("this is the existing setting that we want to change")
                    print("key = \(key)")
                    print("existing value = \(value)")
                    print("new value = \(newValue)")
                    //prompt user that this is a global setting in the bitcoin.conf not network specific
                    
                    if isSectioned {
                        
                        //we are in a section
                        print("our key is in a section: \(section)")
                        print("key = \(key)")
                        print("value = \(value)")
                        
                        if network == "mainnet" {
                            
                            sectionToUpdate = "[main]"
                            
                        } else if network == "testnet" {
                            
                            sectionToUpdate = "[test]"
                            
                        } else if network == "regtest" {
                            
                            sectionToUpdate = "[regtest]"
                            
                        }
                        
                        print("sectionToUpdate = \(sectionToUpdate)")
                        
                        switch section {
                            
                        case "[main]", "[test]", "[regtest]":
                            
                            if sectionToUpdate == section {
                                
                                isUpdatingCorrectNetwork = true
                                confirmForNetworkSpecificChange()
                                
                            }
                            
                        default:
                            
                            break
                            
                        }
                        
                    } else {
                        
                        print("our key is global")
                        isUpdatingCorrectNetwork = true
                        
                        actionAlert(message: "Update bitcoin.conf?", info: "You are attemtping to update \(key)=\(value) to \(key)=\(newValue).\n\nThis is a global setting and will apply to all networks.\n\nIn order for the changes to take effect you will need to restart Bitcoin Core.\n\nAre you sure you want to proceed?") { (response) in
                            
                            if response {
                                
                                print("user said do it")
                                
                                if let i = Int(value) {
                                    
                                    updateGlobalConfArray(conf: conf, oldValue: i, newValue: newValue, key: key)
                                    
                                } else {
                                    
                                    setSimpleAlert(message: "Error", info: "We had an error updating your bitcoin.conf file", buttonLabel: "OK")
                                    
                                }
                                
                            } else {
                                
                                print("user said no")
                                revert()
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                // these vaues are the sections, can specify network specific settings here
                print("this should be a network section: \(setting)")
                section = setting
                isSectioned = true
                
            }
            
        }
        
        if !isUpdatingCorrectNetwork && section != "" {
            
            alertSettingNotForCurrentNetwork()
            revert()
            
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
                    self.setLog(content: runBuildScript.stringToReturn)
                    setSimpleAlert(message: "Success", info: "Added pubkey: \(pubkey)", buttonLabel: "OK")
                    self.textInput.stringValue = ""
                    self.textInput.resignFirstResponder()
                }
                
            } else {
                
               setSimpleAlert(message: "Error", info: "error authenticating", buttonLabel: "OK")
                
            }
            
        }
        
    }
    
    func getBitcoinConf(completion: @escaping ((conf: [String], error: Bool)) -> Void) {
        
        let runBuildTask = RunBuildTask()
        let d = Defaults()
        runBuildTask.args = []
        runBuildTask.env = ["DATADIR":d.dataDir()]
        runBuildTask.showLog = false
        runBuildTask.exitStrings = ["Done"]
        runBuildTask.runScript(script: .getRPCCredentials) {
            
            if !runBuildTask.errorBool {
                
                let conf = (runBuildTask.stringToReturn).components(separatedBy: "\n")
                completion((conf, false))
                
            } else {
                
                completion(([""], true))
                setSimpleAlert(message: "Error", info: runBuildTask.errorDescription, buttonLabel: "OK")
                
            }
            
        }
        
    }
        
    // MARK: Update User Interface
    
    func goBackAndRefresh() {
        
        DispatchQueue.main.async {
            
            if let presenter = self.presentingViewController as? ViewController {
                
                presenter.isBitcoinOn()
                
            }
            
            DispatchQueue.main.async {
                
                self.dismiss(self)
                
            }
            
        }
        
    }
    
    func setState(int: Int, outlet: NSButton) {
        
        print("int = \(int) outlet = \(outlet)")
        
        if int == 1 {
            
            DispatchQueue.main.async {
                outlet.state = .on
            }
                        
        } else if int == 0 {
            
            DispatchQueue.main.async {
                outlet.state = .off
            }
        }
        
    }
    
    func getSettings() {
        print("getSettings")
        
        getSetting(key: .mainnet, button: mainnetOutlet, def: 0)
        getSetting(key: .testnet, button: testnetOutlet, def: 1)
        
        let d = Defaults()
        setState(int: d.prune(), outlet: pruneOutlet)
        setState(int: d.txindex(), outlet: txIndexOutlet)
        setState(int: d.walletdisabled(), outlet: walletDisabled)
        
        if ud.object(forKey: "dataDir") != nil {
                        
            DispatchQueue.main.async {
                self.directoryLabel.stringValue = d.dataDir()
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
        let networkKeys = ["mainnet","testnet"]
        
        if b == 0 {
            
            ud.set(1, forKey: key)
            print("set key: \(key) to 1")
            
        } else {
            
            for k in networkKeys {
                
                if k != key {
                    
                    ud.set(0, forKey: k)
                    print("set key: \(k) to 0")
                    
                }
                
            }
            
        }
        
        updateOutlets(activeOutlet: outlet)
        
    }
    
    func updateOutlets(activeOutlet: NSButton) {

        let outlets = [testnetOutlet, mainnetOutlet]
        DispatchQueue.main.async {
            for o in outlets {
                if o != activeOutlet {
                    let b = o!.state
                    if b == .on {
                        DispatchQueue.main.async {
                            o!.state = .off
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
