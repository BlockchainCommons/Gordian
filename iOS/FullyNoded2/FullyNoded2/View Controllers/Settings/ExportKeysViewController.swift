//
//  ExportKeysViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 27/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit
import LibWally

class ExportKeysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var fetchingAddresses = Bool()
    var qrString = ""
    var keys = [[String:String]]()
    var wallet:WalletStruct!
    var connectingView = ConnectingView()
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        getWords()
        connectingView.addConnectingView(vc: self, description: "fetching your keys")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return keys.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exportCell", for: indexPath)
        cell.selectionStyle = .none
        
        let addressView = cell.viewWithTag(1)!
        let publicKeyView = cell.viewWithTag(5)!
        let wifView = cell.viewWithTag(9)!
        
        addressView.layer.cornerRadius = 8
        publicKeyView.layer.cornerRadius = 8
        wifView.layer.cornerRadius = 8
        
        let addressLabel = cell.viewWithTag(2) as! UILabel
        let publicKeyLabel = cell.viewWithTag(6) as! UILabel
        let wifLabel = cell.viewWithTag(10) as! UILabel
        
        if wallet.type == "DEFAULT" {
            
            addressLabel.text = keys[indexPath.section]["address"]
            publicKeyLabel.text = keys[indexPath.section]["publicKey"]
            wifLabel.text = "*********************************************************"
            
        } else if wallet.type == "MULTI" {
                        
            if fetchingAddresses {
                
                addressLabel.text = "Fetching addresses from your node..."
                publicKeyLabel.text = keys[indexPath.section]["publicKey"]
                wifLabel.text = "*********************************************************"
                
            } else {
                
                 addressLabel.text = keys[indexPath.section]["address"]
                
            }
            
        } else if wallet.type == "CUSTOM" {
            
            if fetchingAddresses {
                
                addressLabel.text = "Fetching addresses from your node..."
                
            } else {
                
                 addressLabel.text = keys[indexPath.section]["address"]
                
            }
            
            publicKeyLabel.text = "need to look into deriving multi-sig pub keys/scripts from libwally"
            wifLabel.text = "⚠︎ no private keys on device for current wallet"
             
        }
        
        
        
        addressLabel.adjustsFontSizeToFitWidth = true
        publicKeyLabel.adjustsFontSizeToFitWidth = true
        wifLabel.adjustsFontSizeToFitWidth = true
        
        let showAddressQRButton = cell.viewWithTag(3) as! UIButton
        let copyAddressButton = cell.viewWithTag(4) as! UIButton
        let showPublicKeyQRButton = cell.viewWithTag(7) as! UIButton
        let copyPublicKeyButton = cell.viewWithTag(8) as! UIButton
        let showWifQRButton = cell.viewWithTag(11) as! UIButton
        let copyWifButton = cell.viewWithTag(12) as! UIButton
        
        showAddressQRButton.accessibilityLabel = "\(indexPath.section)"
        copyAddressButton.accessibilityLabel = "\(indexPath.section)"
        showPublicKeyQRButton.accessibilityLabel = "\(indexPath.section)"
        copyPublicKeyButton.accessibilityLabel = "\(indexPath.section)"
        showWifQRButton.accessibilityLabel = "\(indexPath.section)"
        copyWifButton.accessibilityLabel = "\(indexPath.section)"
        
        showAddressQRButton.addTarget(self, action: #selector(addressQR(_:)), for: .touchUpInside)
        copyAddressButton.addTarget(self, action: #selector(copyAddress(_:)), for: .touchUpInside)
        showPublicKeyQRButton.addTarget(self, action: #selector(publicKeyQR(_:)), for: .touchUpInside)
        copyPublicKeyButton.addTarget(self, action: #selector(copyPublicKey(_:)), for: .touchUpInside)
        showWifQRButton.addTarget(self, action: #selector(wifQR(_:)), for: .touchUpInside)
        copyWifButton.addTarget(self, action: #selector(copyWif(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 224
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "\(wallet.derivation)/\(section)"
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.alpha = 1
        
    }
    
    @objc func copyAddress(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        let index = Int(sender.accessibilityLabel!)!
        let address = keys[index]["address"]
        UIPasteboard.general.string = address
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            
            UIPasteboard.general.string = ""
            
        }
        
        displayAlert(viewController: self, isError: false, message: "address copied to clipboard for 60 seconds")
        
    }
    
    @objc func addressQR(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        let index = Int(sender.accessibilityLabel!)!
        qrString = keys[index]["address"]!
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "exportKeys", sender: self)
            
        }
        
    }
    
    @objc func copyPublicKey(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        let index = Int(sender.accessibilityLabel!)!
        let publicKey = keys[index]["publicKey"]
        UIPasteboard.general.string = publicKey
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            
            UIPasteboard.general.string = ""
            
        }
        
        displayAlert(viewController: self, isError: false, message: "public key copied to clipboard for 60 seconds")
        
    }
    
    @objc func publicKeyQR(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        let index = Int(sender.accessibilityLabel!)!
        
        qrString = keys[index]["publicKey"]!
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "exportKeys", sender: self)
            
        }
        
    }
    
    @objc func copyWif(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        let index = Int(sender.accessibilityLabel!)!
        let wif = keys[index]["wif"]
        UIPasteboard.general.string = wif
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            
            UIPasteboard.general.string = ""
            
        }
        
        displayAlert(viewController: self, isError: false, message: "wif copied to clipboard for 60 seconds")
        
    }
    
    @objc func wifQR(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        let index = Int(sender.accessibilityLabel!)!
        
        qrString = keys[index]["wif"]!
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "exportKeys", sender: self)
            
        }
        
    }
    
     func getKeysFromBitcoinCore() {
        
        let reducer = Reducer()
        var param = ""
        
        if wallet.descriptor.contains("\"\"") {
            
            param = "\(wallet.descriptor), ''[0,1999]''"
            
        } else {
            
            param = "\"\(wallet.descriptor)\", ''[0,1999]''"
            
        }
        
        reducer.makeCommand(walletName: wallet.name, command: .deriveaddresses, param: param) {
             
             if !reducer.errorBool {
                 
                let result = reducer.arrayToReturn
                 
                for (i, address) in result.enumerated() {
                    
                    if self.wallet.type == "CUSTOM" {
                        
                        self.keys.append(["address":(address as! String)])
                        
                    } else {
                        
                        self.keys[i]["address"] = (address as! String)
                        
                    }
                    
                    
                    
                    if i + 1 == result.count {
                        
                        DispatchQueue.main.async {
                            
                            self.fetchingAddresses = false
                            self.table.reloadData()
                            self.connectingView.removeConnectingView()
                            
                        }
                        
                    }
                    
                }
                                  
             } else {
                 
                self.connectingView.removeConnectingView()
                 displayAlert(viewController: self, isError: true, message: "error getting addresses from your node")
                                  
             }
             
         }
         
     }
    
    
    func getWords() {
        
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                self.wallet = wallet!
                
                if wallet!.type == "DEFAULT" || wallet!.type == "MULTI" {
                    
                    let encryptedSeed = wallet!.seed
                    let enc = Encryption()
                    enc.decryptData(dataToDecrypt: encryptedSeed) { (decryptedSeed) in
                        
                        let words = String(bytes: decryptedSeed!, encoding: .utf8)!
                        self.getKeysFromLibWally(words: words)
                        
                    }
                    
                } else if wallet!.type == "CUSTOM" {
                    
                    self.getKeysFromBitcoinCore()
                    
                }
                
            }
            
        }
        
    }
    
    func getKeysFromLibWally(words: String) {
        
        let mnemonicCreator = MnemonicCreator()
        mnemonicCreator.convert(words: words) { (mnemonic, error) in
            
            if !error {
                
                self.getKeys(mnemonic: mnemonic!)
                
            } else {
                
                self.connectingView.removeConnectingView()
                displayAlert(viewController: self, isError: true, message: "error converting those words into a seed")
                
            }
            
        }
        
    }
    
    func getKeys(mnemonic: BIP39Mnemonic) {
        
        let derivation = wallet.derivation
        let path = BIP32Path(derivation)!
        let masterKey = HDKey((mnemonic.seedHex("")), network(path: derivation))!
        let account = try! masterKey.derive(path)
        
        for i in 0 ... 1999 {
            
            let key1 = try! account.derive(BIP32Path("\(i)")!)
            let addressType = AddressType.payToWitnessPubKeyHash
            
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
            
            let dict = [
            
                "address":"\(address)",
                "publicKey":"\((key1.pubKey.data).hexString)",
                "wif":"\(key1.privKey!.wif)"
            
            ]
                                    
            keys.append(dict)
            
            if i == 1999 {
                
                DispatchQueue.main.async {
                    
                    if self.wallet.type == "MULTI" {
                        
                        self.fetchingAddresses = true
                        self.getKeysFromBitcoinCore()
                        
                    }
                    
                    self.table.reloadData()
                    self.connectingView.removeConnectingView()
                    
                }
                
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let id = segue.identifier
        
        switch id {
            
        case "exportKeys":
            
            if let vc = segue.destination as? QRDisplayerViewController {
                
                vc.address = qrString
                
            }
            
        default:
            
            break
            
        }
        
    }
    

}
