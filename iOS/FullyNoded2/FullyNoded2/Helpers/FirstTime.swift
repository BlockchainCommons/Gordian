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
    
    func firstTimeHere(completion: @escaping ((Bool)) -> Void) {
        print("firstTimeHere")
        
        if #available(iOS 13.0, *) {
            
            let privateKey = P256.Signing.PrivateKey().rawRepresentation
            
            if keychain.set(privateKey, forKey: "privateKey") {
                
                print("keychain set privkey")
                let keygen = KeyGen()
                keygen.generate { (pubkey, privkey) in
                    
                    if pubkey != nil && privkey != nil {
                        
                        let pubkeyData = pubkey!.dataUsingUTF8StringEncoding
                        let privkeyData = privkey!.dataUsingUTF8StringEncoding
                        
                        self.enc.encryptData(dataToEncrypt: privkeyData) { (encryptedPrivkey, error) in
                            
                            if !error {
                                
                                let dict = ["privkey":encryptedPrivkey!, "pubkey":pubkeyData]
                                
                                self.cd.saveEntity(dict: dict, entityName: .auth) {
                                    
                                    if !self.cd.errorBool {
                                        
                                        self.ud.set(false, forKey: "firstTime")
                                        completion(true)
                                        
                                    } else {
                                        
                                        print("error saving auth keys")
                                        completion(false)
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                print("error encrypting pubkey")
                                completion(false)
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
                
            } else {
                
                print("keychain set privkey")
                
            }
            
        }
        
    }
    
}

