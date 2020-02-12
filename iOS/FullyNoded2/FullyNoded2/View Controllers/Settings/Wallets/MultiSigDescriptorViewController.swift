//
//  MultiSigDescriptorViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 15/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit
import LibWally

class MultiSigDescriptorViewController: UIViewController, UINavigationControllerDelegate {
    
    var onDoneBlock3 : ((Bool) -> Void)?
    var tapQRGesture = UITapGestureRecognizer()
    let qrGenerator = QRGenerator()
    let connectingView = ConnectingView()
    var recoveryPubkey = ""
    var localSeed = Data()
    var publickeys = [String]()
    var descriptor = ""
    var derivation = ""
    var nodesSeed = ""
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var createButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        createButton.clipsToBounds = true
        createButton.layer.cornerRadius = 10
        imageView.isUserInteractionEnabled = true
        publickeys.append(recoveryPubkey)
        createLocalKey()
        createNodesKey()
        
    }
    
    @IBAction func createAction(_ sender: Any) {
        
        getInfo(descriptor: descriptor)
        
    }
    
    func createLocalKey() {
        print("createLocalKey")
        
        let keychainCreator = KeychainCreator()
        keychainCreator.createKeyChain { (words, error) in
            
            if !error {
                
                let unencryptedSeed = words!.dataUsingUTF8StringEncoding
                let enc = Encryption()
                enc.encryptData(dataToEncrypt: unencryptedSeed) { (encryptedSeed, error) in
                    
                    if !error {
                        
                        self.localSeed = encryptedSeed!
                        self.convert(words: words!)
                        
                    } else {
                        
                        displayAlert(viewController: self, isError: true, message: "error encrypting data")
                        
                    }
                    
                    
                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error creating your recovery key")
                
            }
            
        }
        
    }
    
    func convert(words: String) {
        
        let converter = MnemonicCreator()
        converter.convert(words: words) { (mnemonic, error) in
            
            if !error {
                
                self.getXpub(mnemonic: mnemonic!)
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error converting your words to BIP39 mnmemonic")
                
            }
            
        }
        
    }
    
    func createNodesKey() {
        
        let keychainCreator = KeychainCreator()
        keychainCreator.createKeyChain { (words, error) in
            
            if !error {
                
                self.convert(words: words!)
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error creating your recovery key")
                
            }
            
        }
        
    }
    
    
    func getXpub(mnemonic: BIP39Mnemonic) {
        
        if let masterKey = HDKey((mnemonic.seedHex("")), self.network(path: "m/84'/1'/0'/0")) {
            
            if let path = BIP32Path("m/84'/1'/0'/0") {
                
                do {
                    
                    let account = try masterKey.derive(path)
                    self.publickeys.append(account.xpub)
                    
                    if self.publickeys.count == 2 {
                        
                        
                        
                    }
                    
                    if self.publickeys.count == 3 {
                        
                        self.nodesSeed = account.xpriv!
                        self.constructDescriptor(derivation: "m/84'/1'/0'/0")
                        
                    }
                    
                } catch {
                    
                    displayAlert(viewController: self, isError: true, message: "failed deriving xpub")
                    
                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "failed initiating bip32 path")
                
            }
            
        } else {
            
            displayAlert(viewController: self, isError: true, message: "failed creating masterkey")
            
        }
        
    }
    
    func constructDescriptor(derivation: String) {
        
        let signatures = 2
        
        var processedKeys = (publickeys.description).replacingOccurrences(of: "[", with: "")
        processedKeys = processedKeys.replacingOccurrences(of: ",", with: "/*,")
        processedKeys = processedKeys.replacingOccurrences(of: "]", with: "/*]")
        processedKeys = processedKeys.replacingOccurrences(of: "]", with: "")
        processedKeys = processedKeys.replacingOccurrences(of: "\"", with: "")
        
        // MARK: TODO CHANGE TO SORTEDMULTI
        
        switch derivation {

        case "m/84'/1'/0'/0", "m/84'/0'/0'/0":

            descriptor = "wsh(multi(\(signatures),\(processedKeys)))"

        case "m/44'/1'/0'/0", "m/44'/0'/0'/0":

            descriptor = "sh(multi(\(signatures),\(processedKeys)))"

        case "m/49'/1'/0'/0", "m/49'/0'/0'/0":

            descriptor = "sh(wsh(multi(\(signatures),\(processedKeys))))"
            
        default:

            break

        }
        
        descriptor = descriptor.replacingOccurrences(of: "\"", with: "")
        descriptor = descriptor.replacingOccurrences(of: " ", with: "")
        
        qrGenerator.textInput = descriptor
        
        tapQRGesture = UITapGestureRecognizer(target: self,
                                              action: #selector(shareQRCode(_:)))
        
        imageView.addGestureRecognizer(tapQRGesture)
        
        DispatchQueue.main.async {
            
            self.imageView.image = self.qrGenerator.getQRCode()
            
        }
        
    }
    
    func getInfo(descriptor: String) {
        
        connectingView.addConnectingView(vc: self, description: "creating your wallets descriptor")
        
        let reducer = Reducer()
        print("descriptor: \(descriptor)")
        
        reducer.makeCommand(walletName: "", command: .getdescriptorinfo, param: "\"\(descriptor)\"") {
            
            DispatchQueue.main.async {
                self.connectingView.label.text = "importing your descriptor to your node"
            }
            
            if !reducer.errorBool {
                
                let result = reducer.dictToReturn
                print("result = \(result)")
                
                let desc = result["descriptor"] as! String
                
                let enc = Encryption()
                enc.getNode { (node, error) in
                    
                    if !error {
                        
                        var newWallet = [String:Any]()
                        newWallet["descriptor"] = desc
                        newWallet["derivation"] = "m/84'/1'/0'/0"
                        newWallet["seed"] = self.localSeed
                        newWallet["birthdate"] = keyBirthday()
                        newWallet["id"] = UUID()
                        newWallet["name"] = "\(randomString(length: 10))_StandUp"
                        newWallet["isActive"] = false
                        newWallet["type"] = "MULTI"
                        newWallet["nodeId"] = node!.id
                        newWallet["isArchived"] = false
                        
                        let multiSigCreator = CreateMultiSigWallet()
                        let wallet = WalletStruct.init(dictionary: newWallet)
                        multiSigCreator.create(wallet: wallet, nodeXprv: self.nodesSeed, nodeXpub: self.publickeys[2]) { (success) in
                            
                            if success {
                                
                                DispatchQueue.main.async {
                                   self.connectingView.label.text = "saving your wallet to your device"
                                }
                                
                                let walletSaver = WalletSaver()
                                walletSaver.save(walletToSave: newWallet) { (success) in
                                    
                                    if success {
                                        
                                        self.connectingView.removeConnectingView()
                                        
                                        DispatchQueue.main.async {
                                            
                                            self.onDoneBlock3!(true)
                                            self.dismiss(animated: true, completion: nil)
                                            
                                        }
                                        
                                    } else {
                                        
                                        displayAlert(viewController: self, isError: true, message: "error saving wallet")
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                displayAlert(viewController: self, isError: true, message: "failed creating your wallet")
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                print("error: \(reducer.errorDescription)")
                
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
    
    @objc func shareQRCode(_ sender: UITapGestureRecognizer) {
        print("shareQRCode")
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.imageView.alpha = 0
                
            }) { _ in
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.imageView.alpha = 1
                    
                })
                
            }
            
            let objectsToShare = [self.imageView.image]
            
            let activityController = UIActivityViewController(activityItems: objectsToShare as [Any],
                                                              applicationActivities: nil)
            
            activityController.popoverPresentationController?.sourceView = self.view
            self.present(activityController, animated: true) {}
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
