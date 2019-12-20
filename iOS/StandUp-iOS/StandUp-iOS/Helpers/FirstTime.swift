//
//  FirstTime.swift
//  BitSense
//
//  Created by Peter on 05/04/19.
//  Copyright © 2019 Fontaine. All rights reserved.
//

import Foundation
import KeychainSwift
import CryptoKit

class FirstTime {
    
    let aes = AESService()
    let cd = CoreDataService()
    let ud = UserDefaults.standard
    let keychain = KeychainSwift()
    let enc = Encryption()
    
    func firstTimeHere() {
        print("firstTimeHere")
        
        if ud.object(forKey: "firstTime") == nil {
            
            let password = randomString(length: 32)
            
            if ud.string(forKey: "UnlockPassword") != nil {
                
                keychain.set(ud.string(forKey: "UnlockPassword")!, forKey: "UnlockPassword")
                ud.removeObject(forKey: "UnlockPassword")
                
            }
            
            if #available(iOS 13.0, *) {
                
                let privateKey = P256.Signing.PrivateKey().rawRepresentation
                
                if keychain.set(privateKey, forKey: "privateKey") {
                    
                    print("keychain set privkey")
                    ud.set(true, forKey: "privateKeySet")
                    
                } else {
                    
                    print("keychain set privkey")
                    ud.set(false, forKey: "privateKeySet")
                    
                }
                
            }
            
            if keychain.set(password, forKey: "AESKey") {
                
                print("keychain set AESKey succesfully")
                ud.set(true, forKey: "firstTime")
            
            } else {
                
                print("error setting AESKey in keychain")
                
            }
            
            createSaveSeed()
            
        }
        
    }
    
    func createSaveSeed() {
        
        let keychain = KeychainCreator()
        keychain.createKeyChain(isTestnet: false) { (mnemonic, error) in
            
            if !error {
                
                self.enc.encryptAndSaveSeed(string: mnemonic) { (success) in
                    
                    if success {
                        
                        // seed encrypted and saved
                        print("seed saved")
                        
                    } else {
                        
                        print("seed not saved!!!")
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

