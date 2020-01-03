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
            
            ud.set("m/84'/1'/0'/0", forKey: "derivation")
                        
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
            
            createSaveSeed()
            
        }
        
    }
    
    func createSaveSeed() {
        
        let keychain = KeychainCreator()
        keychain.createKeyChain() { (mnemonic, error) in
            
            if !error {
                
                self.enc.encryptAndSaveSeed(string: mnemonic!) { (success) in
                    
                    if success {
                        
                        print("seed saved")
                        self.ud.set(false, forKey: "firstTime")
                        
                    } else {
                        
                        print("seed not saved!!!")
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

