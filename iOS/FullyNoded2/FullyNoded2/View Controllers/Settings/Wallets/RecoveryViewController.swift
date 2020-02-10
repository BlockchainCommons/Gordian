//
//  RecoveryViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 15/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit
import LibWally

class RecoveryViewController: UIViewController {
    
    var onDoneBlock2 : ((Bool) -> Void)?
    var recoveryPubkey = ""
    @IBOutlet var textView: UITextView!
    @IBOutlet var nextButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButtonOutlet.clipsToBounds = true
        nextButtonOutlet.layer.cornerRadius = 10
        textView.isEditable = false
        textView.isSelectable = true
        createRecoveryKey()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        onDoneBlock2!(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        self.dismiss(animated: false, completion: nil)

    }
    
    func createRecoveryKey() {
        
        let keychainCreator = KeychainCreator()
        keychainCreator.createKeyChain { (mnemonic, error) in
            
            if !error {
                
                DispatchQueue.main.async {
                    
                    self.textView.text = mnemonic!
                    
                }
                
                self.getMnemonic(words: mnemonic!)
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error creating your recovery key")
                
            }
            
        }
        
    }
    
    func getMnemonic(words: String) {
        
        let mnemonicCreator = MnemonicCreator()
        mnemonicCreator.convert(words: words) { (mnemonic, error) in
            
            if !error {
                
                self.getXpub(mnemonic: mnemonic!)
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error getting xpub from your recovery key")
                
            }
            
        }
        
    }
    
    func getXpub(mnemonic: BIP39Mnemonic) {
        
        //getActiveWallet { (wallet) in
                
            //if wallet != nil {
                
                if let masterKey = HDKey((mnemonic.seedHex("")), self.network(path: "m/84'/1'/0'/0")) {
                    
                    if let path = BIP32Path("m/84'/1'/0'/0") {
                        
                        do {
                            
                            let account = try masterKey.derive(path)
                            self.recoveryPubkey = account.xpub
                            print("recovery pubkey = \(self.recoveryPubkey)")
                            
                        } catch {
                            
                            displayAlert(viewController: self, isError: true, message: "failed deriving xpub")
                            
                        }
                        
                    } else {
                        
                        displayAlert(viewController: self, isError: true, message: "failed initiating bip32 path")
                        
                    }
                    
                } else {
                    
                    displayAlert(viewController: self, isError: true, message: "failed creating masterkey")
                    
                }
                
            //}
            
        //}
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        if self.recoveryPubkey != "" {
            
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "descriptor", sender: self)
                
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "descriptor":
            
            if let vc = segue.destination as? MultiSigDescriptorViewController {
                
                vc.recoveryPubkey = recoveryPubkey
                
                vc.onDoneBlock3 = { result in
                    
                    DispatchQueue.main.async {
                        self.view.alpha = 0
                        self.onDoneBlock2!(true)
                        self.dismiss(animated: false, completion: nil)
                        
                    }
                    
                }
                
            }
            
        default:
            
            break
            
        }
        
    }
    

}
