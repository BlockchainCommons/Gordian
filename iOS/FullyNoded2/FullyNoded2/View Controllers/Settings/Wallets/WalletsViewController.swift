//
//  WalletsViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 10/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class WalletsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var name = ""
    var node:NodeStruct!
    var wallets = [[String:Any]]()
    var sortedWallets = [[String:Any]]()
    let dateFormatter = DateFormatter()
    let creatingView = ConnectingView()
    var editButton = UIBarButtonItem()
    var addButton = UIBarButtonItem()
    let cd = CoreDataService()
    var nodes = [[String:Any]]()
    @IBOutlet var walletTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self
        walletTable.delegate = self
        walletTable.dataSource = self
        editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editWallets))
        addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(createWallet))
        self.navigationItem.setRightBarButtonItems([addButton, editButton], animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        refresh()
        
        if self.sortedWallets.count > 1 {
            
            displayAlert(viewController: self, isError: false, message: "Tap a wallet to activate it")
            
        }
        
    }
    
    @objc func editWallets() {
        
        walletTable.setEditing(!walletTable.isEditing, animated: true)
        
        if walletTable.isEditing {
            
            editButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(editWallets))
            
        } else {
            
            editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editWallets))
            
        }
        
        self.navigationItem.setRightBarButtonItems([addButton, editButton], animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if tableView.isEditing {
            
            return .delete
            
        }

        return .none
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let id = sortedWallets[indexPath.section]["id"] as! UUID
            cd.updateEntity(id: id, keyToUpdate: "isArchived", newValue: true, entityName: .wallets) {
                
                if !self.cd.errorBool {
                                        
                    DispatchQueue.main.async {
                        
                        self.sortedWallets.remove(at: indexPath.section)
                        tableView.deleteSections(IndexSet.init(arrayLiteral: indexPath.section), with: .fade)
                        
                    }
                    
                } else {
                    
                    displayAlert(viewController: self, isError: true, message: "error deleting node")
                    
                }
                
            }
            
//            cd.deleteEntity(id: id, entityName: .wallets) {
//
//                if !cd.errorBool {
//
//                    DispatchQueue.main.async {
//
//                        self.wallets.remove(at: indexPath.section)
//                        tableView.deleteSections(IndexSet.init(arrayLiteral: indexPath.section), with: .fade)
//
//                    }
//
//                } else {
//
//                    displayAlert(viewController: self, isError: true, message: "error deleting node")
//
//                }
//
//            }
                        
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func onionAddress(wallet: WalletStruct) -> String {
        
        var rpcOnion = ""
    
        for n in nodes {
            
            let s = NodeStruct(dictionary: n)
            
            if s.id == wallet.nodeId {
                
                rpcOnion = s.onionAddress
                
            }
            
        }
        
        return rpcOnion
        
    }
    
    func refresh() {
        print("refresh")
        
        sortedWallets.removeAll()
        
        let enc = Encryption()
        cd.retrieveEntity(entityName: .nodes) { (nodes, errorDescription) in
            
            if errorDescription == nil && nodes != nil {
                
                self.nodes = nodes!
                
                for (i, n) in nodes!.enumerated() {
                    
                    enc.decryptData(dataToDecrypt: (n["onionAddress"] as! Data)) { (decryptedOnionAddress) in
                        
                        if decryptedOnionAddress != nil {
                            
                            self.nodes[i]["onionAddress"] = String(bytes: decryptedOnionAddress!, encoding: .utf8)
                            
                        }
                        
                        enc.decryptData(dataToDecrypt: (n["label"] as! Data)) { (decryptedLabel) in
                        
                            if decryptedLabel != nil {
                                
                                self.nodes[i]["label"] = String(bytes: decryptedLabel!, encoding: .utf8)
                                
                            }
                            
                        }
                        
                        if i + 1 == nodes!.count {
                            
                            self.cd.retrieveEntity(entityName: .wallets) { (wallets, errorDescription) in
                                
                                if errorDescription == nil {
                                    
                                    for (i, w) in wallets!.enumerated() {
                                        
                                        let s = WalletStruct(dictionary: w)
                                        
                                        if !s.isArchived {
                                            
                                            self.sortedWallets.append(w)
                                            
                                        }
                                        
                                        if i + 1 == wallets!.count {
                                            
                                            self.sortedWallets = self.sortedWallets.sorted{ ($0["lastUsed"] as? Date ?? Date()) > ($1["lastUsed"] as? Date ?? Date()) }
                                            
                                            DispatchQueue.main.async {
                                                
                                                self.walletTable.reloadData()
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                } else {
                                    
                                    displayAlert(viewController: self, isError: true, message: errorDescription!)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                                        
                }
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedWallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath)
//        cell.selectionStyle = .none
//        let birthdateLabel = cell.viewWithTag(1) as! UILabel
//        let derivationLabel = cell.viewWithTag(2) as! UILabel
//        let typeLabel = cell.viewWithTag(5) as! UILabel
//        let isActive = cell.viewWithTag(6) as! UISwitch
//        let keyLocationLabel = cell.viewWithTag(8) as! UILabel
//        let lastUsedLabel = cell.viewWithTag(9) as! UILabel
//        let lastBalance = cell.viewWithTag(10) as! UILabel
//        isActive.isUserInteractionEnabled = false
//
//        let walletDict = sortedWallets[indexPath.section]
//        let wallet = WalletStruct.init(dictionary: walletDict)
//
//        lastUsedLabel.text = "Last used: \(formatDate(date: wallet.lastUsed))"
//        lastBalance.text = "Last balance: \(wallet.lastBalance)"
//
//        birthdateLabel.text = "Key birthdate \(getDate(unixTime: wallet.birthdate))"
//
//        var account = "0"
//
//        let derivation = wallet.derivation
//
//        if derivation.contains("1") {
//
//            account = "1"
//
//        }
//
//        if derivation.contains("84") {
//
//            derivationLabel.text = "Native Segwit Account \(account) (BIP84 \(derivation))"
//
//        } else if derivation.contains("44") {
//
//            derivationLabel.text = "Legacy Account \(account) (BIP44 \(derivation))"
//
//        } else if derivation.contains("49") {
//
//            derivationLabel.text = "P2SH Segwit Account \(account) (BIP49 \(derivation))"
//
//        }
//
//        if wallet.type == "DEFAULT" {
//
//            typeLabel.text = "Single Signature"
//            keyLocationLabel.text = "Signer on \(UIDevice.current.name) 📱"
//
//        } else {
//
//            typeLabel.text = "2 of 3 multi signature"
//            keyLocationLabel.text = "1 Signer on \(UIDevice.current.name), 1 on node, 1 offline"
//
//        }
//
//        if wallet.isActive {
//
//            isActive.isOn = true
//
//        } else if !wallet.isActive {
//
//            isActive.isOn = false
//
//        }
//
//        return cell
        //multiSigWalletCell
        let d = sortedWallets[indexPath.section]
        let wallet = WalletStruct.init(dictionary: d)
        
        switch wallet.type {
            
        case "DEFAULT":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleSigWalletCell", for: indexPath)
            cell.selectionStyle = .none
                        
                        let balanceLabel = cell.viewWithTag(1) as! UILabel
                        let isActive = cell.viewWithTag(2) as! UISwitch
            //            let exportKeysButton = cell.viewWithTag(3) as! UIButton
            //            let verifyAddresses = cell.viewWithTag(4) as! UIButton
            //            let refreshData = cell.viewWithTag(5) as! UIButton
            //            let showInvoice = cell.viewWithTag(6) as! UIButton
            //            let makeItCold = cell.viewWithTag(7) as! UIButton
                        let networkLabel = cell.viewWithTag(8) as! UILabel
                        let utxosButton = cell.viewWithTag(9) as! UIButton
                        //let getDerivationInfoButton = cell.viewWithTag(10) as! UIButton
                        let derivationLabel = cell.viewWithTag(11) as! UILabel
                        //let multisigButton = cell.viewWithTag(12) as! UIButton
                        let updatedLabel = cell.viewWithTag(13) as! UILabel
                        let createdLabel = cell.viewWithTag(14) as! UILabel
            //            let nodeSeedLabel = cell.viewWithTag(15) as! UILabel
            //            let shareSeedButton = cell.viewWithTag(16) as! UIButton
            //            let getNodeSeedInfo = cell.viewWithTag(17) as! UIButton
            //            let getOfflineSeedInfo = cell.viewWithTag(18) as! UIButton
                        let rpcOnionLabel = cell.viewWithTag(19) as! UILabel
                        let walletFileLabel = cell.viewWithTag(20) as! UILabel
                        let seedOnDeviceView = cell.viewWithTag(21)!
                        let seedOnNodeView = cell.viewWithTag(22)!
                        //let seedOfflineView = cell.viewWithTag(23)!
                        let isActiveLabel = cell.viewWithTag(24) as! UILabel
                        let stackView = cell.viewWithTag(25)!
                        let nodeView = cell.viewWithTag(26)!
                        let nodeLabel = cell.viewWithTag(27) as! UILabel
                        
                        isActive.addTarget(self, action: #selector(makeActive(_:)), for: .valueChanged)
                        isActive.restorationIdentifier = "\(indexPath.section)"
                        
                        nodeView.layer.cornerRadius = 8
                        stackView.layer.cornerRadius = 8
                        seedOnDeviceView.layer.cornerRadius = 8
                        seedOnNodeView.layer.cornerRadius = 8
                        //seedOfflineView.layer.cornerRadius = 8
                        networkLabel.layer.cornerRadius = 8
                        utxosButton.layer.cornerRadius = 8
                        
                        if wallet.isActive {
                            
                            isActive.isOn = true
                            isActiveLabel.text = "Active"
                            isActiveLabel.textColor = .lightGray
                            cell.contentView.alpha = 1
                            
                        } else if !wallet.isActive {
                            
                            isActive.isOn = false
                            isActiveLabel.text = "Inactive"
                            isActiveLabel.textColor = .darkGray
                            cell.contentView.alpha = 0.2
                            
                        }
                                    
                        let derivation = wallet.derivation
                        balanceLabel.adjustsFontSizeToFitWidth = true
                        balanceLabel.text = "\(wallet.lastBalance) BTC"
                        
                        if derivation.contains("1") {
                            
                            networkLabel.text = "Testnet"
                            balanceLabel.textColor = .systemOrange
                            
                        } else {
                            
                            networkLabel.text = "Mainnet"
                            balanceLabel.textColor = .systemGreen
                            
                        }
                        
                        if derivation.contains("84") {
                            
                            derivationLabel.text = "BIP84"
                            
                        } else if derivation.contains("44") {
                            
                            derivationLabel.text = "BIP44"
                            
                        } else if derivation.contains("49") {
                            
                            derivationLabel.text = "BIP49"
                            
                        }
                        
                        updatedLabel.text = "\(formatDate(date: wallet.lastUsed))"
                        createdLabel.text = "\(getDate(unixTime: wallet.birthdate))"
                        walletFileLabel.text = wallet.name + ".dat"
                        
                        for n in nodes {
                            
                            let s = NodeStruct(dictionary: n)
                            
                            if s.id == wallet.nodeId {
                                
                                let rpcOnion = s.onionAddress
                                let first10 = String(rpcOnion.prefix(5))
                                let last15 = String(rpcOnion.suffix(15))
                                rpcOnionLabel.text = "\(first10)*****\(last15)"
                                nodeLabel.text = s.label
                                
                            }
                            
                        }
            return cell
            
        case "MULTI":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "multiSigWalletCell", for: indexPath)
            cell.selectionStyle = .none
            
            let balanceLabel = cell.viewWithTag(1) as! UILabel
            let isActive = cell.viewWithTag(2) as! UISwitch
//            let exportKeysButton = cell.viewWithTag(3) as! UIButton
//            let verifyAddresses = cell.viewWithTag(4) as! UIButton
//            let refreshData = cell.viewWithTag(5) as! UIButton
//            let showInvoice = cell.viewWithTag(6) as! UIButton
//            let makeItCold = cell.viewWithTag(7) as! UIButton
            let networkLabel = cell.viewWithTag(8) as! UILabel
            let utxosButton = cell.viewWithTag(9) as! UIButton
            //let getDerivationInfoButton = cell.viewWithTag(10) as! UIButton
            let derivationLabel = cell.viewWithTag(11) as! UILabel
            //let multisigButton = cell.viewWithTag(12) as! UIButton
            let updatedLabel = cell.viewWithTag(13) as! UILabel
            let createdLabel = cell.viewWithTag(14) as! UILabel
//            let nodeSeedLabel = cell.viewWithTag(15) as! UILabel
//            let shareSeedButton = cell.viewWithTag(16) as! UIButton
//            let getNodeSeedInfo = cell.viewWithTag(17) as! UIButton
//            let getOfflineSeedInfo = cell.viewWithTag(18) as! UIButton
            let rpcOnionLabel = cell.viewWithTag(19) as! UILabel
            let walletFileLabel = cell.viewWithTag(20) as! UILabel
            let seedOnDeviceView = cell.viewWithTag(21)!
            let seedOnNodeView = cell.viewWithTag(22)!
            let seedOfflineView = cell.viewWithTag(23)!
            let isActiveLabel = cell.viewWithTag(24) as! UILabel
            let stackView = cell.viewWithTag(25)!
            let nodeView = cell.viewWithTag(26)!
            let nodeLabel = cell.viewWithTag(27) as! UILabel
            
            isActive.addTarget(self, action: #selector(makeActive(_:)), for: .valueChanged)
            isActive.restorationIdentifier = "\(indexPath.section)"
            
            nodeView.layer.cornerRadius = 8
            stackView.layer.cornerRadius = 8
            seedOnDeviceView.layer.cornerRadius = 8
            seedOnNodeView.layer.cornerRadius = 8
            seedOfflineView.layer.cornerRadius = 8
            networkLabel.layer.cornerRadius = 8
            utxosButton.layer.cornerRadius = 8
            
            if wallet.isActive {
                
                isActive.isOn = true
                isActiveLabel.text = "Active"
                isActiveLabel.textColor = .lightGray
                cell.contentView.alpha = 1
                
            } else if !wallet.isActive {
                
                isActive.isOn = false
                isActiveLabel.text = "Inactive"
                isActiveLabel.textColor = .darkGray
                cell.contentView.alpha = 0.2
                
            }
                        
            let derivation = wallet.derivation
            balanceLabel.adjustsFontSizeToFitWidth = true
            balanceLabel.text = "\(wallet.lastBalance) BTC"
            
            if derivation.contains("1") {
                
                networkLabel.text = "Testnet"
                balanceLabel.textColor = .systemOrange
                
            } else {
                
                networkLabel.text = "Mainnet"
                balanceLabel.textColor = .systemGreen
                
            }
            
            if derivation.contains("84") {
                
                derivationLabel.text = "BIP84"
                
            } else if derivation.contains("44") {
                
                derivationLabel.text = "BIP44"
                
            } else if derivation.contains("49") {
                
                derivationLabel.text = "BIP49"
                
            }
            
            updatedLabel.text = "\(formatDate(date: wallet.lastUsed))"
            createdLabel.text = "\(getDate(unixTime: wallet.birthdate))"
            walletFileLabel.text = wallet.name + ".dat"
            
            for n in nodes {
                
                let s = NodeStruct(dictionary: n)
                
                if s.id == wallet.nodeId {
                    
                    let rpcOnion = s.onionAddress
                    let first10 = String(rpcOnion.prefix(5))
                    let last15 = String(rpcOnion.suffix(15))
                    rpcOnionLabel.text = "\(first10)*****\(last15)"
                    nodeLabel.text = s.label
                    
                }
                
            }
            
            return cell
            
        default:
            
            let cell = UITableViewCell()
            return cell
            
        }
        
        
    }
    
    @objc func makeActive(_ sender: UISwitch) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            
        }
        
        let index = Int(sender.restorationIdentifier!)!
        let walletId = WalletStruct(dictionary: sortedWallets[index]).id
        
        if sender.isOn {
            
            activate(walletToActivate: walletId)
            
        } else {
            
            deactivate(walletToActivate: walletId, index: index)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let type = WalletStruct(dictionary: sortedWallets[indexPath.section]).type
        
        switch  type {
            
        case "DEFAULT":
            
            return 370
            
        case "MULTI":
            
            return 403
            
        default:
            
            return 0
            
        }
                
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //let name = WalletStruct.init(dictionary: sortedWallets[section]).name
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let dict = sortedWallets[indexPath.section]
//        let wallet = WalletStruct.init(dictionary: dict)
//
//        makeActive(walletToActivate: wallet.id)
//
//        DispatchQueue.main.async {
//
//            let impact = UIImpactFeedbackGenerator()
//            impact.impactOccurred()
//
//        }
        
    }
    
    func getDate(unixTime: Int32) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MMM-dd hh:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
        
    }
    
    func formatDate(date: Date) -> String {
        
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MMM-dd hh:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
        
    }
    
    func activate(walletToActivate: UUID) {
        
        for wallet in sortedWallets {
            
            let str = WalletStruct.init(dictionary: wallet)
            
            if str.id == walletToActivate {
                
                cd.updateEntity(id: walletToActivate, keyToUpdate: "isActive", newValue: true, entityName: .wallets) {
                    
                    if !self.cd.errorBool {
                                                
                       self.deactivateOtherWallets(walletToActivate: walletToActivate)
                        
                    } else {
                        
                        displayAlert(viewController: self, isError: true, message: "error deactivating wallet")
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func deactivate(walletToActivate: UUID, index: Int) {
        
        for wallet in sortedWallets {
            
            let str = WalletStruct.init(dictionary: wallet)
            
            if str.id == walletToActivate {
                
                cd.updateEntity(id: walletToActivate, keyToUpdate: "isActive", newValue: false, entityName: .wallets) {
                    
                    if !self.cd.errorBool {
                       
                        DispatchQueue.main.async {
                            
                            //self.walletTable.reloadSections(IndexSet(arrayLiteral: [index]), with: .fade)
                            self.refresh()
                            
                        }
                        
                    } else {
                        
                        displayAlert(viewController: self, isError: true, message: "error deactivating wallet")
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func deactivateOtherWallets(walletToActivate: UUID) {
        print("deactivateOtherWallets")
        
        for (i, wallet) in sortedWallets.enumerated() {
            
            let str = WalletStruct.init(dictionary: wallet)
            
            if str.id != walletToActivate {
                
                cd.updateEntity(id: str.id, keyToUpdate: "isActive", newValue: false, entityName: .wallets) {
                    
                    if !self.cd.errorBool {
                        
                        
                                                
                    } else {
                        
                        displayAlert(viewController: self, isError: true, message: self.cd.errorDescription)
                        
                    }
                    
                }
                
            }
            
            if i + 1 == self.sortedWallets.count {
                
                self.refresh()
                
            }
            
        }
        
    }
    
    @objc func createWallet() {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            
        }
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "To create a wallet, select a type below", message: "", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Single-Sig", style: .default, handler: { action in
                
                self.createSingleSig()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Multi-Sig", style: .default, handler: { action in
                
                self.createMultiSig()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Import Custom", style: .default, handler: { action in
                
                self.importCustom()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func importCustom() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "importCustom", sender: self)
            
        }
        
    }
    
    func createMultiSig() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "createMultiSigNow", sender: self)
            
        }
        
    }
    
    func createSingleSig() {
        
        creatingView.addConnectingView(vc: self, description: "Creating single-sig wallet")
        
        let enc = Encryption()
        let keyCreator = KeychainCreator()
        keyCreator.createKeyChain() { (mnemonic, error) in
            
            if !error {
                
                let dataToEncrypt = mnemonic!.dataUsingUTF8StringEncoding
                enc.encryptData(dataToEncrypt: dataToEncrypt) { (encryptedData, error) in
                    
                    if !error {
                        
                        let walletSaver = WalletSaver()
                        var newWallet = [String:Any]()
                        newWallet["birthdate"] = keyBirthday()
                        newWallet["id"] = UUID()
                        newWallet["derivation"] = "m/84'/1'/0'/0"
                        newWallet["isActive"] = false
                        newWallet["name"] = "\(randomString(length: 10))_StandUp"
                        newWallet["seed"] = encryptedData!
                        newWallet["lastUsed"] = Date()
                        newWallet["lastBalance"] = 0.0
                        newWallet["type"] = "DEFAULT"
                        newWallet["nodeId"] = self.node.id
                        newWallet["isArchived"] = false
                        
                        let walletCreator = WalletCreator()
                        walletCreator.walletDict = newWallet
                        walletCreator.node = self.node
                        
                        walletCreator.createStandUpWallet(derivation: "m/84'/1'/0'/0") { (success, errorDescription) in
                            
                            if success {
                                
                                walletSaver.save(walletToSave: newWallet) { (success) in
                                    
                                    if success {
                                        
                                        print("wallet saved")
                                        
                                        self.creatingView.removeConnectingView()
                                        
                                        self.refresh()
                                        
                                        displayAlert(viewController: self, isError: false, message: "wallet added! Tap it to activate it")
                                        
                                    } else {
                                        
                                        print("error saving wallet")
                                        displayAlert(viewController: self, isError: true, message: "There was an error saving your wallet")
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                self.creatingView.removeConnectingView()
                                displayAlert(viewController: self, isError: true, message: "There was an error creating your wallet: \(errorDescription!)")
                                
                            }
                            
                        }
                        
                    } else {
                        
                        self.creatingView.removeConnectingView()
                        displayAlert(viewController: self, isError: true, message: "There was an error encrypting your seed")
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "walletInfo":
            
            if let vc = segue.destination as? WalletInfoViewController {
                
                vc.walletname = name
                
            }
            
        default:
            
            break
            
        }
        
    }
    
}
