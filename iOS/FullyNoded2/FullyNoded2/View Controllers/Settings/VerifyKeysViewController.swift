//
//  VerifyKeysViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 07/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit
import LibWally

class VerifyKeysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var address = ""
    var words = ""
    var derivation = ""
    var keys = [String]()
    var comingFromSettings = Bool()
    let connectingView = ConnectingView()
    var wallet:WalletStruct!
    @IBOutlet var table: UITableView!
    @IBOutlet var saveButtonOutlet: UIButton!
    @IBOutlet var derivationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if comingFromSettings {
            
            saveButtonOutlet.alpha = 0
            
        }
        
        saveButtonOutlet.clipsToBounds = true
        saveButtonOutlet.layer.cornerRadius = 8
        
        derivationLabel.adjustsFontSizeToFitWidth = true
        derivationLabel.text = ""
        
        if comingFromSettings {
            
            loadActiveWallet()
            
        } else {
            
            derivationLabel.text = labelText(derivation: derivation)
            loadProposedWallet()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if comingFromSettings {
            
            table.translatesAutoresizingMaskIntoConstraints = true
            table.frame = CGRect(x: table.frame.origin.x, y: table.frame.origin.y, width: table.frame.width, height: view.frame.height)
            
        }
        
    }
    
    func addExistingDerivationLabel() {
        
        let derivation = wallet.derivation
        derivationLabel.text = labelText(derivation: derivation)
        derivationLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    func labelText(derivation: String) -> String {
        
//        var account = "0"
//        
//        if derivation.contains("1") {
//            
//            account = "1"
//            
//        }
        
        if derivation.contains("84") {
            
            return "Native Segwit Account 0 (BIP84 \(derivation))"
            
        } else if derivation.contains("44") {
            
            return "Legacy Account 0 (BIP44 \(derivation))"
            
        } else if derivation.contains("49") {
            
            return "P2SH Nested Segwit Account 0 (BIP49 \(derivation))"
            
        } else {
            
            return ""
            
        }
        
    }
    
    func loadProposedWallet() {
        
        getKeysFromLibWally()
        
    }
    
    func loadActiveWallet() {
        
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                self.wallet = wallet!
                
                if wallet!.type == "MULTI" || wallet!.type == "CUSTOM" {
                    
                    self.getKeysFromBitcoinCore()
                    
                } else {
                    
                    let enc = Encryption()
                    
                    if let encryptedSeed = wallet?.seed {
                        
                        enc.decryptData(dataToDecrypt: encryptedSeed) { (decryptedSeed) in
                            
                            if decryptedSeed != nil {
                                
                                self.words = String(data: decryptedSeed!, encoding: .utf8)!
                                self.getKeysFromLibWally()
                                
                            }
                            
                        }
                        
                    } else {
                        
                        // to do use libwally for key generation of cold wallets and multisig
                        self.getKeysFromBitcoinCore()
                        
                    }
                    
                }
                
                self.addExistingDerivationLabel()
                
            }
            
        }
        
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        print("saveButtonAction")
        
        connectingView.addConnectingView(vc: self, description: "confirming derived keys with bitcoin core")
        
        let mnemonicCreator = MnemonicCreator()
        mnemonicCreator.convert(words: words) { (mnemonic, error) in
            
            if !error {
                
                let masterKey = HDKey((mnemonic!.seedHex("")), self.network(path: "m/84'/1'/0'/0"))!
                let path = BIP32Path("m/84'/1'/0'/0")!
                let account = try! masterKey.derive(path)
                let xpub = account.xpub
                self.getDescriptorInfo(xpub: xpub)
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error converting those words into a seed")
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 77
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return keys.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Index #\(section)"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "keyCell", for: indexPath)
        cell.selectionStyle = .none
        
        let keyLabel = cell.viewWithTag(2) as! UILabel
        let pathLabel = cell.viewWithTag(3) as! UILabel
        
        pathLabel.text = "m/84'/1'/0'/0/\(indexPath.section)"
        keyLabel.text = "\(keys[indexPath.section])"
        
        keyLabel.adjustsFontSizeToFitWidth = true
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.section
        address = keys[index]
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "verifyAddress", sender: self)
            
        }
        
    }
    
    func getKeysFromBitcoinCore() {
        
        connectingView.addConnectingView(vc: self, description: "getting the addresses from your node")
        
        let reducer = Reducer()
        reducer.makeCommand(walletName: wallet.name, command: .deriveaddresses, param: "\"\(wallet.descriptor)\", ''[0,1999]''") {
            
            if !reducer.errorBool {
                
                let result = reducer.arrayToReturn
                self.keys = result as! [String]
                
                DispatchQueue.main.async {
                    
                    self.table.reloadData()
                    
                }
                
                self.connectingView.removeConnectingView()
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error getting addresses from your node")
                
                self.connectingView.removeConnectingView()
                
            }
            
        }
        
    }

    func getKeysFromLibWally() {
        
        let mnemonicCreator = MnemonicCreator()
        mnemonicCreator.convert(words: words) { (mnemonic, error) in
            
            if !error {
                
                self.getKeys(mnemonic: mnemonic!)
                
                if !self.comingFromSettings {
                    
                    displayAlert(viewController: self, isError: false, message: "please verify that these keys match your expected keys, if they don't then do not save your wallet as something is wrong!")
                    
                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error converting those words into a seed")
                
            }
            
        }
        
    }
    
    func getKeys(mnemonic: BIP39Mnemonic) {
        
        let path = BIP32Path("m/84'/1'/0'/0")!
        let masterKey = HDKey((mnemonic.seedHex("")), network(path: "m/84'/1'/0'/0"))!
        let account = try! masterKey.derive(path)
        
        for i in 0 ... 1999 {
            
            let key1 = try! account.derive(BIP32Path("\(i)")!)
            var addressType:AddressType!
            addressType = .payToWitnessPubKeyHash
            
//            if derivation.contains("84") {
//
//                addressType = .payToWitnessPubKeyHash
//
//            } else if derivation.contains("44") {
//
//                addressType = .payToPubKeyHash
//
//            } else if derivation.contains("49") {
//
//                addressType = .payToScriptHashPayToWitnessPubKeyHash
//
//            }
            
            let address = key1.address(addressType)
            keys.append("\(address)")
            
            if i == 1999 {
                
                DispatchQueue.main.async {
                    
                    self.table.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
    func getDescriptorInfo(xpub: String) {
        
        let reducer = Reducer()
        var param = ""
        
        switch self.derivation {
            
        case "m/84'/1'/0'/0", "m/84'/0'/0'/0":
            
            param = "\"wpkh(\(xpub)/*)\""
            
        case "m/44'/1'/0'/0", "m/44'/0'/0'/0":
            
            param = "\"pkh(\(xpub)/*)\""
            
        case "m/49'/1'/0'/0", "m/49'/0'/0'/0":
            
            param = "\"sh(wpkh(\(xpub)/*))\""
            
        default:
            
            break
            
        }
                
        reducer.makeCommand(walletName: wallet.name, command: .getdescriptorinfo, param: param) {
            
            if !reducer.errorBool {
                
                let result = reducer.dictToReturn
                let descriptor = "\"\(result["descriptor"] as! String)\""
                let parameter = "\(descriptor), ''[0,1999]''"
                self.deriveKeys(parameter: parameter)
                
            } else {
                
                self.connectingView.removeConnectingView()
                displayAlert(viewController: self, isError: true, message: reducer.errorDescription)
                
            }
            
        }
        
    }
    
    func deriveKeys(parameter: String) {
        
        let reducer = Reducer()
        reducer.makeCommand(walletName: wallet.name, command: .deriveaddresses, param: parameter) {
            
            if !reducer.errorBool {
                
                let keysToConfirm = reducer.arrayToReturn as! [String]
                let keysDerivedByLibWally = Set(self.keys)
                let keysDerivedByBitcoinCore = Set(keysToConfirm)

                if (keysDerivedByLibWally.count == keysDerivedByBitcoinCore.count && keysDerivedByLibWally == keysDerivedByBitcoinCore) {
                    
                    print("keys are identical")
                    self.saveWallet()
                    
                } else {
                    
                    self.connectingView.removeConnectingView()
                    
                    displayAlert(viewController: self,
                                 isError: true,
                                 message: "keys do not match! error confirming derived keys with bitcoin core, seed will not be saved")
                    
                }
                
            } else {
                
                self.connectingView.removeConnectingView()
                displayAlert(viewController: self, isError: true, message: reducer.errorDescription)
                
            }
            
        }
        
    }
    
    func saveWallet() {
                
        connectingView.addConnectingView(vc: self, description: "saving new wallet")
        
        let enc = Encryption()
        let dataToEncrypt = words.dataUsingUTF8StringEncoding
        enc.encryptData(dataToEncrypt: dataToEncrypt) { (encryptedData, error) in
            
            if !error {
                
                var newWallet = [String:Any]()
                newWallet["birthdate"] = keyBirthday()
                newWallet["id"] = UUID()
                newWallet["derivation"] = self.derivation
                newWallet["isActive"] = true
                newWallet["name"] = "\(randomString(length: 10))_StandUp"
                newWallet["seed"] = encryptedData
                newWallet["lastUsed"] = Date()
                newWallet["lastBalance"] = 0.0
                newWallet["walletCreated"] = false
                newWallet["keysImported"] = false
                newWallet["type"] = "DEFAULT"
                
                let walletCreator = WalletCreator()
                
                walletCreator.createStandUpWallet(derivation: self.derivation) { (success, errorDescription, descriptor) in
                                                
                    if success {
                        
                        newWallet["descriptor"] = descriptor!
                        
                        let walletSaver = WalletSaver()
                        walletSaver.save(walletToSave: newWallet) { (success) in
                            
                            if success {
                                
                                print("wallet saved")
                                
                                self.connectingView.removeConnectingView()
                                displayAlert(viewController: self, isError: false, message: "✓ successfully created new wallet")
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                                
                            } else {
                                
                                print("error saving default wallet")
                                self.connectingView.removeConnectingView()
                                
                            }
                            
                        }
                        
                    } else {
                        
                        print("error creating new wallet")
                        displayAlert(viewController: self, isError: true, message: errorDescription!)
                        self.connectingView.removeConnectingView()
                        
                    }
                    
                }
                
            } else {
                
                print("error encrypting seed")
                self.connectingView.removeConnectingView()
                
            }
            
        }
        
    }
    
    private func network(path: String) -> Network {
        
        var network:Network!
        
        if path.contains("/1'") {
            
            network = .testnet
            
        } else {
            
            network = .mainnet
            
        }
        
        return network
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.alpha = 1
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "verifyAddress":
            
            if let vc = segue.destination as? VerifyAddressViewController {
                
                vc.address = address
                
            }
            
        default:
            
            break
            
        }
        
    }

}
