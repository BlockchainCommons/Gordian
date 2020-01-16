//
//  FirstTime.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import KeychainSwift
import CryptoKit

class FirstTime {
    
    let cd = CoreDataService()
    let ud = UserDefaults.standard
    let keychain = KeychainSwift()
    let enc = Encryption()
    
    func firstTimeHere() {
        print("firstTimeHere")
        
        if ud.object(forKey: "firstTime") == nil {
            
            let walletName = "\(randomString(length: 10))" + "_StandUp"
            ud.set("m/84'/1'/0'/0", forKey: "derivation")
            ud.set(walletName, forKey: "walletName")
            
            if #available(iOS 13.0, *) {
                
                let privateKey = P256.Signing.PrivateKey().rawRepresentation
                
                if keychain.getData("privateKey") == nil {
                    
                    if keychain.set(privateKey, forKey: "privateKey") {
                        
                        print("keychain set privkey")
                        
                    } else {
                        
                        print("keychain set privkey")
                        
                    }
                    
                }
                
            }
            
            saveDefaultWallet()
            
        }
        
    }
    
    func saveDefaultWallet() {
        
        let keyCreator = KeychainCreator()
        keyCreator.createKeyChain() { (mnemonic, error) in
            
            if !error {
                
                let walletSaver = WalletSaver()
                let dataToEncrypt = mnemonic!.dataUsingUTF8StringEncoding
                self.enc.encryptData(dataToEncrypt: dataToEncrypt) { (encryptedData, error) in
                    
                    var defaultWallet = [String:Any]()
                    defaultWallet["birthdate"] = keyBirthday()
                    print("birthdate = \(defaultWallet["birthdate"] as! Int32)")
                    defaultWallet["id"] = UUID()
                    defaultWallet["derivation"] = "m/84'/1'/0'/0"
                    self.ud.set("m/84'/1'/0'/0", forKey: "derivation")
                    defaultWallet["isActive"] = true
                    defaultWallet["name"] = "\(randomString(length: 10))_StandUp"
                    self.ud.set(defaultWallet["name"] as! String, forKey: "walletName")
                    defaultWallet["seed"] = encryptedData
                    
                    walletSaver.save(walletToSave: defaultWallet) { (success) in
                        
                        if success {
                            
                            print("default wallet saved")
                            self.ud.set(false, forKey: "firstTime")
                            
                        } else {
                            
                            print("error saving default wallet")
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

