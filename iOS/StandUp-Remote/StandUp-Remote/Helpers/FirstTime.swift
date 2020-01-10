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
            
            createSaveSeed()
            
        }
        
    }
    
    func createSaveSeed() {
        
        if self.keychain.getData("seed") == nil {
            
            let keyCreator = KeychainCreator()
            keyCreator.createKeyChain() { (mnemonic, error) in
                
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
            
        } else {
            
            // seed already saved
            self.ud.set(false, forKey: "firstTime")
            
        }
        
    }
    
}

