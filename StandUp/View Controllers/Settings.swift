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
        
        setScene()
        
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
            
            actionAlert(message: "Danger!", info: "This will remove the StandUp directory including all its contents!\n\nIt may hold Bitcoin wallets and blockchain data!\n\nThis will remove tor config, tor hidden services and uninstall tor.\n\nAre you aure you want to do this?") { (response) in
                
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
                
                let datadir = self.ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/StandUp/BitcoinCore/Data"
                
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
        setSimpleAlert(message: "Updated", info: "In order for these changes to take effect you need to restart Bitcoin Core", buttonLabel: "OK")
        
    }
    
    @IBAction func didSetTestnet(_ sender: Any) {
        
        setOutlet(outlet: testnetOutlet, keyOn: .testnet)
        setSimpleAlert(message: "Updated", info: "In order for these changes to take effect you need to restart Bitcoin Core", buttonLabel: "OK")
        
    }
    
    @IBAction func didSetRegtest(_ sender: Any) {
        
        setOutlet(outlet: regtestOutlet, keyOn: .regtest)
        setSimpleAlert(message: "Updated", info: "In order for these changes to take effect you need to restart Bitcoin Core", buttonLabel: "OK")
        
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
                    self.directoryLabel.stringValue = self.selectedFolder?.path ?? "/Users/\(NSUserName())/StandUp/BitcoinCore/Data"
                    self.ud.set(self.directoryLabel.stringValue, forKey: "dataDir")
                    self.setScene()
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
        
        let dataDir = ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/StandUp/BitcoinCore/Data"
        let runBuildTask = RunBuildTask()
        runBuildTask.args = args
        runBuildTask.env = ["CONF":conf,"DATADIR":dataDir]
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
        let regtest = ud.object(forKey: "regtest") as! Int
        
        if mainnet == 1 {
            network = "mainnet"
        }
        if testnet == 1 {
            network = "testnet"
        }
        if regtest == 1 {
            network = "regtest"
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
        
        if !isUpdatingCorrectNetwork {
            
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
            let prune = ud.object(forKey: "prune") as? Int ?? 0
            let txindex = ud.object(forKey: "txindex") as? Int ?? 1
            let dataDir = ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/StandUp/BitcoinCore/Data"
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
            self.args.append("\(txindex)")
            self.args.append("\(walletDisabled)")
            print("args = \(self.args)")
            
        }
        
    }
    
    func setScene() {
        print("setscene")
        
        let compatibleSettings:[BTCCONF] = [.txindex,.prune,.walletdisabled]
        let incompatibleSettings:[BTCCONF] = [.mainnet,.testnet,.regtest,.datadir]
                
        getBitcoinConf { (conf, error) in
            
            if !error {
                
                if conf.count > 0 {
                    
                    for setting in conf {
                        
                        if setting.contains("=") {
                            
                            let arr = setting.components(separatedBy: "=")
                            let key = arr[0]
                            let value = arr[1]
                            
                            for c in compatibleSettings {
                                
                                if key == c.rawValue {
                                    
                                    //set the scene and the default
                                    print("set \(c.rawValue) outlet to \(value)")
                                    
                                    if key == "prune" {
                                        
                                        if value == "1" {
                                            DispatchQueue.main.async {
                                                self.pruneOutlet.state = .on
                                                self.ud.set(1, forKey: "prune")
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.pruneOutlet.state = .off
                                                self.ud.set(0, forKey: "prune")
                                            }
                                        }
                                        
                                    }
                                    
                                    if key == "walletdisabled" {
                                        
                                        if value == "1" {
                                            DispatchQueue.main.async {
                                                self.walletDisabled.state = .on
                                                self.ud.set(1, forKey: "walletdisabled")
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.walletDisabled.state = .off
                                                self.ud.set(0, forKey: "walletdisabled")
                                            }
                                        }
                                        
                                    }
                                    
                                    if key == "txindex" {
                                        
                                        if value == "1" {
                                            DispatchQueue.main.async {
                                                self.txIndexOutlet.state = .on
                                                self.ud.set(1, forKey: "txindex")
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.txIndexOutlet.state = .off
                                                self.ud.set(0, forKey: "txindex")
                                            }
                                        }
                                        
                                    }
                                                                        
                                }
                                
                            }
                            
                            for x in incompatibleSettings {
                                
                                if key == x.rawValue {
                                    
                                    // warn user this setting is not compatible with their exisiting bitcoin.conf, from what I can tell you can not specify a datdir when launching bitcoind and also specify a datadir in your bitcoin.conf, same goes for networks
                                    
                                    print("incompatible setting warning \(key)")
                                    
                                    setSimpleAlert(message: "Warning!", info: "Your bitcoin.conf has settings in it which are not compatible with StandUp, you can not specifiy a network or a datadir in your bitcoin.conf if you want to use it with StandUp.\n\nTo fix it you need to delete either the datadir, testnet or regtest setting from your bitcoin.conf and instead select the datadir or network here in StandUp\n\nIf you do not do this you will get errors when trying to use StandUp.", buttonLabel: "OK")
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    self.getSettings()
                    
                } else {
                    
                    self.getSettings()
                    
                }
                
            } else {
                
               setSimpleAlert(message: "Error", info: "We had an error fetching the bitcoin.conf file", buttonLabel: "OK")
                
            }
            
        }
        
    }
    
    func getBitcoinConf(completion: @escaping ((conf: [String], error: Bool)) -> Void) {
        
        let datadir = ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/StandUp/BitcoinCore/Data"
        let runBuildTask = RunBuildTask()
        runBuildTask.args = []
        runBuildTask.env = ["DATADIR":datadir]
        runBuildTask.showLog = false
        runBuildTask.exitStrings = ["Done"]
        runBuildTask.runScript(script: .getRPCCredentials) {
            
            if !runBuildTask.errorBool {
                
                var conf = (runBuildTask.stringToReturn).components(separatedBy: "\n")
                print("conf = \(conf)")
//                for (i, c) in conf.enumerated() {
//                    if c == "" {
//                        conf.remove(at: i)
//                    }
//                }
                
                completion((conf, false))
                
            } else {
                
                completion(([""], true))
                setSimpleAlert(message: "Error", info: runBuildTask.errorDescription, buttonLabel: "OK")
                
            }
            
        }
        
    }
    
    func getExisistingRPCCreds(completion: @escaping ((user: String, password: String)) -> Void) {
        print("getExisistingRPCCreds")
        
        var user = ""
        var password = ""
        let datadir = ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/StandUp/BitcoinCore/Data"
        let runBuildTask = RunBuildTask()
        runBuildTask.args = []
        runBuildTask.env = ["DATADIR":datadir]
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
    
    func getSettings() {
        print("getSettings")
        
        getSetting(key: .prune, button: pruneOutlet, def: 0)
        getSetting(key: .txindex, button: txIndexOutlet, def: 1)
        getSetting(key: .mainnet, button: mainnetOutlet, def: 0)
        getSetting(key: .testnet, button: testnetOutlet, def: 1)
        getSetting(key: .regtest, button: regtestOutlet, def: 0)
        getSetting(key: .walletdisabled, button: walletDisabled, def: 0)
        
        if ud.object(forKey: "dataDir") != nil {
            
            let dd = ud.object(forKey: "dataDir") as? String ?? "/Users/\(NSUserName())/StandUp/BitcoinCore/Data"
            
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

        let outlets = [regtestOutlet, testnetOutlet, mainnetOutlet]
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
