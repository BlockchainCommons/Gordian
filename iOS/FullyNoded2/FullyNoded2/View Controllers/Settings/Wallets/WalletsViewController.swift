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
                                    
                                    print("wallets count = \(wallets!.count)")
                                    
                                    for (i, w) in wallets!.enumerated() {
                                        
                                        print("wallet = \(w)")
                                        
                                        let s = WalletStruct(dictionary: w)
                                        
                                        if !s.isArchived {
                                            
                                            self.sortedWallets.append(w)
                                            
                                        }
                                        
                                        if i + 1 == wallets!.count {
                                            
                                            self.sortedWallets = self.sortedWallets.sorted{ ($0["lastUsed"] as? Date ?? Date()) > ($1["lastUsed"] as? Date ?? Date()) }
                                            
                                            DispatchQueue.main.async {
                                                
                                                self.walletTable.reloadData()
                                                self.walletTable.setContentOffset(.zero, animated: true)
                                                
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
    
        let d = sortedWallets[indexPath.section]
        let wallet = WalletStruct.init(dictionary: d)
        
        switch wallet.type {
            
        case "DEFAULT":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleSigWalletCell", for: indexPath)
            cell.selectionStyle = .none
            
            let balanceLabel = cell.viewWithTag(1) as! UILabel
            let isActive = cell.viewWithTag(2) as! UISwitch
            let exportKeysButton = cell.viewWithTag(3) as! UIButton
            let verifyAddresses = cell.viewWithTag(4) as! UIButton
            let refreshData = cell.viewWithTag(5) as! UIButton
            let showInvoice = cell.viewWithTag(6) as! UIButton
            let makeItCold = cell.viewWithTag(7) as! UIButton
            let networkLabel = cell.viewWithTag(8) as! UILabel
            let utxosButton = cell.viewWithTag(9) as! UIButton
            //let getDerivationInfoButton = cell.viewWithTag(10) as! UIButton
            let derivationLabel = cell.viewWithTag(11) as! UILabel
            let getWalletInfoButton = cell.viewWithTag(12) as! UIButton
            let updatedLabel = cell.viewWithTag(13) as! UILabel
            let createdLabel = cell.viewWithTag(14) as! UILabel
            //            let nodeSeedLabel = cell.viewWithTag(15) as! UILabel
            let shareSeedButton = cell.viewWithTag(16) as! UIButton
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
            
            if wallet.isActive {
                
                isActive.isOn = true
                isActiveLabel.text = "Active"
                isActiveLabel.textColor = .lightGray
                cell.contentView.alpha = 1
                
            } else if !wallet.isActive {
                
                isActive.isOn = false
                isActiveLabel.text = "Inactive"
                isActiveLabel.textColor = .darkGray
                cell.contentView.alpha = 0.6
                
            }
            
            isActive.addTarget(self, action: #selector(makeActive(_:)), for: .valueChanged)
            isActive.restorationIdentifier = "\(indexPath.section)"
            
            //rescanButton.addTarget(self, action: #selector(rescan(_:)), for: .touchUpInside)
            //rescanButton.restorationIdentifier = "\(indexPath.section)"
            
            if isActive.isOn {
                
                makeItCold.addTarget(self, action: #selector(makeCold(_:)), for: .touchUpInside)
                showInvoice.addTarget(self, action: #selector(invoice(_:)), for: .touchUpInside)
                shareSeedButton.addTarget(self, action: #selector(export(_:)), for: .touchUpInside)
                exportKeysButton.addTarget(self, action: #selector(exportKeys(_:)), for: .touchUpInside)
                getWalletInfoButton.addTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                verifyAddresses.addTarget(self, action: #selector(verifyAddresses(_:)), for: .touchUpInside)
                refreshData.addTarget(self, action: #selector(refreshData(_:)), for: .touchUpInside)
                
            } else {
                
                makeItCold.removeTarget(self, action: #selector(makeCold(_:)), for: .touchUpInside)
                showInvoice.removeTarget(self, action: #selector(invoice(_:)), for: .touchUpInside)
                shareSeedButton.removeTarget(self, action: #selector(export(_:)), for: .touchUpInside)
                exportKeysButton.removeTarget(self, action: #selector(exportKeys(_:)), for: .touchUpInside)
                getWalletInfoButton.removeTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                verifyAddresses.removeTarget(self, action: #selector(verifyAddresses(_:)), for: .touchUpInside)
                refreshData.removeTarget(self, action: #selector(refreshData(_:)), for: .touchUpInside)
                
            }
            
            makeItCold.restorationIdentifier = "\(indexPath.section)"
            shareSeedButton.restorationIdentifier = "\(indexPath.section)"
            exportKeysButton.restorationIdentifier = "\(indexPath.section)"
            getWalletInfoButton.restorationIdentifier = "\(indexPath.section)"
            verifyAddresses.restorationIdentifier = "\(indexPath.section)"
            refreshData.restorationIdentifier = "\(indexPath.section)"
            
            nodeView.layer.cornerRadius = 8
            stackView.layer.cornerRadius = 8
            seedOnDeviceView.layer.cornerRadius = 8
            seedOnNodeView.layer.cornerRadius = 8
            networkLabel.layer.cornerRadius = 8
            utxosButton.layer.cornerRadius = 8
            
            let derivation = wallet.derivation
            balanceLabel.adjustsFontSizeToFitWidth = true
            balanceLabel.text = "\(wallet.lastBalance.avoidNotation) BTC"
            
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
            let exportKeysButton = cell.viewWithTag(3) as! UIButton
            let verifyAddresses = cell.viewWithTag(4) as! UIButton
            let refreshData = cell.viewWithTag(5) as! UIButton
            let showInvoice = cell.viewWithTag(6) as! UIButton
            let makeItCold = cell.viewWithTag(7) as! UIButton
            let networkLabel = cell.viewWithTag(8) as! UILabel
            let utxosButton = cell.viewWithTag(9) as! UIButton
            //let getDerivationInfoButton = cell.viewWithTag(10) as! UIButton
            let derivationLabel = cell.viewWithTag(11) as! UILabel
            let getWalletInfoButton = cell.viewWithTag(12) as! UIButton
            let updatedLabel = cell.viewWithTag(13) as! UILabel
            let createdLabel = cell.viewWithTag(14) as! UILabel
            //            let nodeSeedLabel = cell.viewWithTag(15) as! UILabel
            let shareSeedButton = cell.viewWithTag(16) as! UIButton
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
            //let rescanButton = cell.viewWithTag(28) as! UIButton
            
            isActive.addTarget(self, action: #selector(makeActive(_:)), for: .valueChanged)
            isActive.restorationIdentifier = "\(indexPath.section)"
            
            if wallet.isActive {
                
                isActive.isOn = true
                isActiveLabel.text = "Active"
                isActiveLabel.textColor = .lightGray
                cell.contentView.alpha = 1
                
            } else if !wallet.isActive {
                
                isActive.isOn = false
                isActiveLabel.text = "Inactive"
                isActiveLabel.textColor = .darkGray
                cell.contentView.alpha = 0.6
                
            }
            
            if isActive.isOn {
                
                makeItCold.addTarget(self, action: #selector(makeCold(_:)), for: .touchUpInside)
                showInvoice.addTarget(self, action: #selector(invoice(_:)), for: .touchUpInside)
                //rescanButton.addTarget(self, action: #selector(rescan(_:)), for: .touchUpInside)
                shareSeedButton.addTarget(self, action: #selector(export(_:)), for: .touchUpInside)
                exportKeysButton.addTarget(self, action: #selector(exportKeys(_:)), for: .touchUpInside)
                getWalletInfoButton.addTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                verifyAddresses.addTarget(self, action: #selector(verifyAddresses(_:)), for: .touchUpInside)
                refreshData.addTarget(self, action: #selector(refreshData(_:)), for: .touchUpInside)
                
                
            } else {
                
                makeItCold.removeTarget(self, action: #selector(makeCold(_:)), for: .touchUpInside)
                showInvoice.removeTarget(self, action: #selector(invoice(_:)), for: .touchUpInside)
                //rescanButton.removeTarget(self, action: #selector(rescan(_:)), for: .touchUpInside)
                shareSeedButton.removeTarget(self, action: #selector(export(_:)), for: .touchUpInside)
                exportKeysButton.removeTarget(self, action: #selector(exportKeys(_:)), for: .touchUpInside)
                getWalletInfoButton.removeTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                verifyAddresses.removeTarget(self, action: #selector(verifyAddresses(_:)), for: .touchUpInside)
                refreshData.removeTarget(self, action: #selector(refreshData(_:)), for: .touchUpInside)
                
            }
            
            makeItCold.restorationIdentifier = "\(indexPath.section)"
            //rescanButton.restorationIdentifier = "\(indexPath.section)"
            shareSeedButton.restorationIdentifier = "\(indexPath.section)"
            exportKeysButton.restorationIdentifier = "\(indexPath.section)"
            getWalletInfoButton.restorationIdentifier = "\(indexPath.section)"
            verifyAddresses.restorationIdentifier = "\(indexPath.section)"
            refreshData.restorationIdentifier = "\(indexPath.section)"
            
            nodeView.layer.cornerRadius = 8
            stackView.layer.cornerRadius = 8
            seedOnDeviceView.layer.cornerRadius = 8
            seedOnNodeView.layer.cornerRadius = 8
            seedOfflineView.layer.cornerRadius = 8
            networkLabel.layer.cornerRadius = 8
            utxosButton.layer.cornerRadius = 8
            
            let derivation = wallet.derivation
            balanceLabel.adjustsFontSizeToFitWidth = true
            balanceLabel.text = "\(wallet.lastBalance.avoidNotation) BTC"
            
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
            
        case "CUSTOM":
            
            let cell = walletTable.dequeueReusableCell(withIdentifier: "coldWalletCell", for: indexPath)
            cell.selectionStyle = .none
            
            let balanceLabel = cell.viewWithTag(1) as! UILabel
            let isActive = cell.viewWithTag(2) as! UISwitch
            let exportKeysButton = cell.viewWithTag(3) as! UIButton
            let verifyAddresses = cell.viewWithTag(4) as! UIButton
            let refreshData = cell.viewWithTag(5) as! UIButton
            let showInvoice = cell.viewWithTag(6) as! UIButton
            let makeItCold = cell.viewWithTag(7) as! UIButton
            let networkLabel = cell.viewWithTag(8) as! UILabel
            let utxosButton = cell.viewWithTag(9) as! UIButton
            //let getDerivationInfoButton = cell.viewWithTag(10) as! UIButton
            let derivationLabel = cell.viewWithTag(11) as! UILabel
            let getWalletInfoButton = cell.viewWithTag(12) as! UIButton
            let updatedLabel = cell.viewWithTag(13) as! UILabel
            let createdLabel = cell.viewWithTag(14) as! UILabel
            //            let nodeSeedLabel = cell.viewWithTag(15) as! UILabel
            //let shareSeedButton = cell.viewWithTag(16) as! UIButton
            let exportSeedButton = cell.viewWithTag(17) as! UIButton
            //            let getOfflineSeedInfo = cell.viewWithTag(18) as! UIButton
            let rpcOnionLabel = cell.viewWithTag(19) as! UILabel
            let walletFileLabel = cell.viewWithTag(20) as! UILabel
            //let seedOnDeviceView = cell.viewWithTag(21)!
            let seedOnNodeView = cell.viewWithTag(22)!
            //let seedOfflineView = cell.viewWithTag(23)!
            let isActiveLabel = cell.viewWithTag(24) as! UILabel
            let stackView = cell.viewWithTag(25)!
            let nodeView = cell.viewWithTag(26)!
            let nodeLabel = cell.viewWithTag(27) as! UILabel
            
            if wallet.isActive {
                
                isActive.isOn = true
                isActiveLabel.text = "Active"
                isActiveLabel.textColor = .lightGray
                cell.contentView.alpha = 1
                
            } else if !wallet.isActive {
                
                isActive.isOn = false
                isActiveLabel.text = "Inactive"
                isActiveLabel.textColor = .darkGray
                cell.contentView.alpha = 0.6
                
            }
            
            isActive.addTarget(self, action: #selector(makeActive(_:)), for: .valueChanged)
            isActive.restorationIdentifier = "\(indexPath.section)"
            
            //rescanButton.addTarget(self, action: #selector(rescan(_:)), for: .touchUpInside)
            //rescanButton.restorationIdentifier = "\(indexPath.section)"
            
            if isActive.isOn {
                
                exportSeedButton.addTarget(self, action: #selector(export(_:)), for: .touchUpInside)
                makeItCold.addTarget(self, action: #selector(rescan(_:)), for: .touchUpInside)
                showInvoice.addTarget(self, action: #selector(invoice(_:)), for: .touchUpInside)
                //shareSeedButton.addTarget(self, action: #selector(export(_:)), for: .touchUpInside)
                exportKeysButton.addTarget(self, action: #selector(exportKeys(_:)), for: .touchUpInside)
                getWalletInfoButton.addTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                verifyAddresses.addTarget(self, action: #selector(verifyAddresses(_:)), for: .touchUpInside)
                refreshData.addTarget(self, action: #selector(refreshData(_:)), for: .touchUpInside)
                
            } else {
                
                exportSeedButton.removeTarget(self, action: #selector(export(_:)), for: .touchUpInside)
                makeItCold.removeTarget(self, action: #selector(rescan(_:)), for: .touchUpInside)
                showInvoice.removeTarget(self, action: #selector(invoice(_:)), for: .touchUpInside)
                //shareSeedButton.removeTarget(self, action: #selector(export(_:)), for: .touchUpInside)
                exportKeysButton.removeTarget(self, action: #selector(exportKeys(_:)), for: .touchUpInside)
                getWalletInfoButton.removeTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                verifyAddresses.removeTarget(self, action: #selector(verifyAddresses(_:)), for: .touchUpInside)
                refreshData.removeTarget(self, action: #selector(refreshData(_:)), for: .touchUpInside)
                
            }
            
            makeItCold.restorationIdentifier = "\(indexPath.section)"
            exportSeedButton.restorationIdentifier = "\(indexPath.section)"
            exportKeysButton.restorationIdentifier = "\(indexPath.section)"
            getWalletInfoButton.restorationIdentifier = "\(indexPath.section)"
            verifyAddresses.restorationIdentifier = "\(indexPath.section)"
            refreshData.restorationIdentifier = "\(indexPath.section)"
            
            nodeView.layer.cornerRadius = 8
            stackView.layer.cornerRadius = 8
            //seedOnDeviceView.layer.cornerRadius = 8
            seedOnNodeView.layer.cornerRadius = 8
            networkLabel.layer.cornerRadius = 8
            utxosButton.layer.cornerRadius = 8
            
            let derivation = wallet.derivation
            balanceLabel.adjustsFontSizeToFitWidth = true
            balanceLabel.text = "\(wallet.lastBalance.avoidNotation) BTC"
            
            if derivation.contains("1") {
                
                networkLabel.text = "Testnet"
                balanceLabel.textColor = .systemOrange
                
            } else {
                
                networkLabel.text = "Mainnet"
                balanceLabel.textColor = .systemGreen
                
            }
            
            derivationLabel.text = "P2WSH"
            
//            if derivation.contains("84") {
//
//                derivationLabel.text = "BIP84"
//
//            } else if derivation.contains("44") {
//
//                derivationLabel.text = "BIP44"
//
//            } else if derivation.contains("49") {
//
//                derivationLabel.text = "BIP49"
//
//            }
            
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
    
    @objc func makeCold(_ sender: UIButton) {
        
        let index = Int(sender.restorationIdentifier!)!
        let wallet = WalletStruct(dictionary: self.sortedWallets[index])
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            
            let alert = UIAlertController(title: "⚠︎ WARNING!", message: "This button WILL DELETE the devices seed FOREVER, and make this wallet a watch-only wallet, there is no going back after this! Make sure you have securely recorded your words, descriptors and recovery command before deleting the seed otherwise you will NOT be able to spend from this wallet.", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "⚠︎ DELETE SEED", style: .destructive, handler: { action in
                
                let cd = CoreDataService()
                cd.updateEntity(id: wallet.id, keyToUpdate: "seed", newValue: "no seed".dataUsingUTF8StringEncoding, entityName: .wallets) {
                    
                    if !cd.errorBool {
                        
                        cd.updateEntity(id: wallet.id, keyToUpdate: "type", newValue: "CUSTOM", entityName: .wallets) {}
                        
                        showAlert(vc: self, title: "Seed deleted", message: "")
                        
                        DispatchQueue.main.async {
                            
                            self.walletTable.reloadSections(IndexSet(arrayLiteral: index), with: .fade)
                            
                        }
                        
                    } else {
                        
                        showAlert(vc: self, title: "Error", message: "\(cd.errorDescription)")
                        
                    }
                    
                }

            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in }))
                    
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func invoice(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            self.performSegue(withIdentifier: "invoice", sender: self)
            
        }
        
    }
    
    @objc func refreshData(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            sender.tintColor = .clear
            sender.loadingIndicator(show: true)
            
        }
        
        let index = Int(sender.restorationIdentifier!)!
        let wallet = WalletStruct(dictionary: self.sortedWallets[index])
        
        let nodeLogic = NodeLogic()
        nodeLogic.wallet = wallet
        nodeLogic.loadSectionZero {
            
            if !nodeLogic.errorBool {
                
                let dict = nodeLogic.dictToReturn
                print("dict = \(dict)")
                let s = HomeStruct(dictionary: dict)
                print("s.coldbalance = \(s.coldBalance)")
                
                let cd = CoreDataService()
                cd.updateEntity(id: wallet.id, keyToUpdate: "lastBalance", newValue: Double(s.coldBalance)!, entityName: .wallets) {
                    
                    self.sortedWallets[index]["lastBalance"] = Double(s.coldBalance)!
                    self.sortedWallets[index]["lastUsed"]  = Date()
                    
                    DispatchQueue.main.async {
                        
                        sender.loadingIndicator(show: false)
                        sender.tintColor = .systemBlue
                        self.walletTable.reloadSections(IndexSet(arrayLiteral: index), with: .fade)
                        
                    }
                    
                    cd.updateEntity(id: wallet.id, keyToUpdate: "lastUsed", newValue: Date(), entityName: .wallets) {}
                    
                }
                
            }
            
        }
        
    }
    
    @objc func verifyAddresses(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            self.performSegue(withIdentifier: "verifyAddresses", sender: self)
            
        }
        
    }
    
    @objc func exportKeys(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            self.performSegue(withIdentifier: "exportKeys", sender: self)
            
        }
        
    }
    
    @objc func export(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            self.performSegue(withIdentifier: "exportSeed", sender: self)
            
        }
        
    }
    
    @objc func getWalletInfo(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "getWalletInfo", sender: self)
                
            }
            
        }
        
    }
    
    @objc func rescan(_ sender: UIButton) {
        
        let index = Int(sender.restorationIdentifier!)!
        let walletName = WalletStruct(dictionary: self.sortedWallets[index]).name
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            
            let alert = UIAlertController(title: "Rescan the blockchain?", message: "This button will start a blockchain rescan for your current wallet. This is useful if you imported the wallet and do not see balances yet. If you want to check the status of your rescan this button will also let you know the % completion.", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Rescan", style: .default, handler: { action in
                
                self.creatingView.addConnectingView(vc: self, description: "initiating rescan")
                            
                let reducer = Reducer()
                reducer.makeCommand(walletName: walletName, command: .rescanblockchain, param: "") {
                    
                    DispatchQueue.main.async {
                        
                        self.creatingView.label.text = "confirming rescan status"
                        
                    }
                    
                    reducer.errorBool = false
                    reducer.errorDescription = ""
                    
                    reducer.makeCommand(walletName: walletName, command: .getwalletinfo, param: "") {
                        
                        if !reducer.errorBool || reducer.errorDescription.description.contains("abort") {
                            
                            let result = reducer.dictToReturn
                            if let scanning = result["scanning"] as? NSDictionary {
                                
                                if let _ = scanning["duration"] as? Int {
                                    
                                    self.creatingView.removeConnectingView()
                                    let progress = (scanning["progress"] as! Double)
                                    showAlert(vc: self, title: "Rescanning", message: "Wallet is rescanning with current progress: \((progress * 100).rounded())%")
                                    
                                }
                                
                            } else if (result["scanning"] as? Int) == 0 {
                                
                                self.creatingView.removeConnectingView()
                                displayAlert(viewController: self, isError: true, message: "wallet not rescanning")
                                
                            } else {
                                
                                self.creatingView.removeConnectingView()
                                displayAlert(viewController: self, isError: true, message: "unable to determine if wallet is rescanning")
                                
                            }
                            
                        } else {
                            
                            self.creatingView.removeConnectingView()
                            displayAlert(viewController: self, isError: true, message: reducer.errorDescription)
                            
                        }
                        
                    }
                    
                }

            }))
            
            alert.addAction(UIAlertAction(title: "Check Scan Status", style: .default, handler: { action in
                
                self.creatingView.addConnectingView(vc: self, description: "checking scan status")
                
                let reducer = Reducer()
                reducer.makeCommand(walletName: walletName, command: .getwalletinfo, param: "") {
                    
                    if !reducer.errorBool || reducer.errorDescription.description.contains("abort") {
                        
                        let result = reducer.dictToReturn
                        if let scanning = result["scanning"] as? NSDictionary {
                            
                            if let _ = scanning["duration"] as? Int {
                                
                                self.creatingView.removeConnectingView()
                                let progress = (scanning["progress"] as! Double)
                                showAlert(vc: self, title: "Rescanning", message: "Wallet is rescanning with current progress: \((progress * 100).rounded())%")
                                
                            }
                            
                        } else if (result["scanning"] as? Int) == 0 {
                            
                            self.creatingView.removeConnectingView()
                            displayAlert(viewController: self, isError: true, message: "wallet not rescanning")
                            
                        } else {
                            
                            self.creatingView.removeConnectingView()
                            displayAlert(viewController: self, isError: true, message: "unable to determine if wallet is rescanning")
                            
                        }
                        
                    } else {
                        
                        self.creatingView.removeConnectingView()
                        displayAlert(viewController: self, isError: true, message: reducer.errorDescription)
                        
                    }
                    
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in }))
                    
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func makeActive(_ sender: UIButton) {
        
        let index = Int(sender.restorationIdentifier!)!
        let wallet = WalletStruct(dictionary: self.sortedWallets[index])
        
        if !wallet.isActive {
            
            activateNow(wallet: wallet, index: index)
            
        } else {
            
            deactivateNow(wallet: wallet, index: index)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let type = WalletStruct(dictionary: sortedWallets[indexPath.section]).type
        
        switch  type {
            
        case "DEFAULT":
            
            return 370
            
        case "MULTI":
            
            return 403
            
        case "CUSTOM":
            
            return 310
            
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
        
        let dict = sortedWallets[indexPath.section]
        let wallet = WalletStruct.init(dictionary: dict)
        
        if !wallet.isActive {
            
            activateNow(wallet: wallet, index: indexPath.section)
            
        }
        
    }
    
    func activateNow(wallet: WalletStruct, index: Int) {
        
        if !wallet.isActive {
            
            DispatchQueue.main.async {
                
                let impact = UIImpactFeedbackGenerator()
                impact.impactOccurred()
                
            }
            
            // update the views
            for (i, _) in sortedWallets.enumerated() {
                
                if index == i {
                    
                    // wallet to activate
                    self.sortedWallets[i]["lastUsed"]  = Date()
                    self.sortedWallets[i]["isActive"] = true
                    
                    DispatchQueue.main.async {
                        
                        self.walletTable.reloadSections(IndexSet(arrayLiteral: i), with: .fade)
                                            
                    }
                    
                } else {
                    
                    self.sortedWallets[i]["isActive"] = false
                    
                    DispatchQueue.main.async {
                        
                        self.walletTable.reloadSections(IndexSet(arrayLiteral: i), with: .none)
                                            
                    }
                    
                }
                
                if i + 1 == sortedWallets.count {
                    
                    // update the actual data
                    let cd = CoreDataService()
                    cd.updateEntity(id: wallet.id, keyToUpdate: "lastUsed", newValue: Date(), entityName: .wallets) {
                        
                        self.activate(walletToActivate: wallet.id, index: index)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func deactivateNow(wallet: WalletStruct, index: Int) {
        
        if wallet.isActive {
            
            DispatchQueue.main.async {
                
                let impact = UIImpactFeedbackGenerator()
                impact.impactOccurred()
                
            }
            
            // update the views
            for (i, _) in sortedWallets.enumerated() {
                
                if index == i {
                    
                    // wallet to deactivate
                    self.sortedWallets[i]["isActive"] = false
                    
                    DispatchQueue.main.async {
                        
                        self.walletTable.reloadSections(IndexSet(arrayLiteral: i), with: .fade)
                                            
                    }
                    
                    let cd = CoreDataService()
                    cd.updateEntity(id: wallet.id, keyToUpdate: "isActive", newValue: false, entityName: .wallets) {}
                    
                }
                
            }
            
        }
        
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
    
    func activate(walletToActivate: UUID, index: Int) {
        
        cd.updateEntity(id: walletToActivate, keyToUpdate: "isActive", newValue: true, entityName: .wallets) {
            
            if !self.cd.errorBool {
                                        
                self.deactivate(walletToActivate: walletToActivate, index: index)
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error deactivating wallet")
                
            }
            
        }
        
    }
    
    func deactivate(walletToActivate: UUID, index: Int) {
        
        for (i, wallet) in sortedWallets.enumerated() {
            
            let str = WalletStruct.init(dictionary: wallet)
            
            if str.id != walletToActivate {
                
                cd.updateEntity(id: str.id, keyToUpdate: "isActive", newValue: false, entityName: .wallets) {
                    
                    if !self.cd.errorBool {
                        
                        self.sortedWallets[i]["isActive"] = false
                        
                        if i != index {
                            
                            DispatchQueue.main.async {
                                
                                self.walletTable.reloadSections(IndexSet(arrayLiteral: i), with: .none)
                                
                            }
                            
                        }
                        
                    } else {
                        
                        displayAlert(viewController: self, isError: true, message: "error deactivating wallet")
                        
                    }
                    
                }
                
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
        
        enc.getNode { (node, error) in
            
            if !error && node != nil {
                
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
                                newWallet["nodeId"] = node!.id
                                newWallet["isArchived"] = false
                                
                                let walletCreator = WalletCreator()
                                walletCreator.walletDict = newWallet
                                walletCreator.node = node!
                                
                                walletCreator.createStandUpWallet(derivation: "m/84'/1'/0'/0") { (success, errorDescription, descriptor) in
                                    
                                    if success {
                                        
                                        newWallet["descriptor"] = descriptor!
                                        
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
                
            } else {
                
                self.creatingView.removeConnectingView()
                displayAlert(viewController: self, isError: true, message: "no active node")
                
            }
            
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "createMultiSigNow":
            
            if let vc = segue.destination as? CreateMultiSigViewController {
                
                vc.onDoneBlock1 = { result in
                    
                    showAlert(vc: self, title: "Success!", message: "Multisig wallet created successfully")
                    self.refresh()
                    
                }
                
            }
            
        case "walletInfo":
            
            if let vc = segue.destination as? WalletInfoViewController {
                
                vc.walletname = name
                
            }
            
        case "verifyAddresses":
            
            if let vc = segue.destination as? VerifyKeysViewController {
                
                vc.comingFromSettings = true
                
            }
            
        default:
            
            break
            
        }
        
    }
    
}

extension UIButton {
    func loadingIndicator(show: Bool) {
        if show {
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            for view in self.subviews {
                if let indicator = view as? UIActivityIndicatorView {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            }
        }
    }
}
