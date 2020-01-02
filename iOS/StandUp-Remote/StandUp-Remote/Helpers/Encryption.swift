//
//  Encryption.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import CryptoKit
import KeychainSwift

class Encryption {
    
    let keychain = KeychainSwift()
    let ud = UserDefaults.standard
    
    func encryptAndSaveSeed(string: String, completion: @escaping ((Bool)) -> Void) {
        
        if #available(iOS 13.0, *) {
            
            if self.ud.bool(forKey: "privateKeySet") {
                
                if let key = self.keychain.getData("privateKey") {
                    
                    let k = SymmetricKey(data: key)
                    
                    if let dataToEncrypt = string.data(using: .utf8) {
                        
                        if let sealedBox = try? ChaChaPoly.seal(dataToEncrypt, using: k) {
                            
                            let cd = CoreDataService()
                            let encryptedData = sealedBox.combined
                            cd.saveSeed(seed: encryptedData) {
                                
                                if !cd.errorBool {
                                    
                                    print("saved seed to coredata")
                                    completion((true))
                                    
                                } else {
                                    
                                    completion((false))
                                    
                                }
                                
                            }
                            
                        } else {
                            
                            completion((false))
                            
                        }
                        
                    } else {
                        
                        completion((false))
                        
                    }
                    
                } else {
                    
                    completion((false))
                    
                }
                
            } else {
                
                completion((false))
                
            }
            
        } else {
            
            completion((false))
            
        }
        
    }
    
    func decrypt(data: Data, completion: @escaping ((seed: String, error: Bool)) -> Void) {
        
        if #available(iOS 13.0, *) {
            
            if ud.bool(forKey: "privateKeySet") {
                
                if let key = keychain.getData("privateKey") {
                    
                    do {
                        
                        let box = try ChaChaPoly.SealedBox.init(combined: data)
                        let k = SymmetricKey(data: key)
                        let decryptedData = try ChaChaPoly.open(box, using: k)
                        if let seed = String(data: decryptedData, encoding: .utf8) {
                            
                            completion((seed,false))
                            
                        } else {
                            
                            completion(("",true))
                            
                        }
                        
                        
                    } catch {
                        
                        print("failed decrypting")
                        completion(("",true))
                        
                    }
                    
                } else {
                    
                    completion(("",true))
                    
                }
                
            } else {
                
                completion(("",true))
                
            }
            
        } else {
            
            completion(("",true))
            
        }
                
    }
    
}
