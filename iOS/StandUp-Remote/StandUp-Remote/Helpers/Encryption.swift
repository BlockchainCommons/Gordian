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
    
    func getNode(completion: @escaping ((node: NodeStruct?, error: Bool)) -> Void) {
        
        if #available(iOS 13.0, *) {
            
            if ud.bool(forKey: "privateKeySet") {
                
                if let key = keychain.getData("privateKey") {
                    
                    let pk = SymmetricKey(data: key)
                    let cd = CoreDataService()
                    cd.retrieveEntity(entityName: .nodes) {
                        
                        let node = cd.entities[0]
                        //print("node = \(node)")
                        var decryptedNode = [String:Any]()
                        
                        for (k, value) in node {
                            
                            let dataToDecrypt = value as! Data
                            
                            do {
                                
                                let box = try ChaChaPoly.SealedBox.init(combined: dataToDecrypt)
                                let decryptedData = try ChaChaPoly.open(box, using: pk)
                                if let decryptedValue = String(data: decryptedData, encoding: .utf8) {
                                    
                                    decryptedNode[k] = decryptedValue
                                    
                                } else {
                                    
                                    completion((nil,true))
                                    
                                }
                                
                            } catch {
                                
                                completion((nil,true))
                                
                            }
                            
                        }
                        
                        let nodeStruct = NodeStruct.init(dictionary: decryptedNode)
                        completion((nodeStruct,false))
                        
                    }
                    
                } else {
                    
                    completion((nil,true))
                    
                }
                
            } else {
                
                completion((nil,true))
                
            }
            
        } else {
            
            completion((nil,true))
            
        }
        
    }
    
    func saveNode(node: [String:String], completion: @escaping ((Bool)) -> Void) {
        
        if #available(iOS 13.0, *) {
            
            if self.ud.bool(forKey: "privateKeySet") {
                
                if let key = self.keychain.getData("privateKey") {
                    
                    let pk = SymmetricKey(data: key)
                    var encryptedNode = [String:Data]()
                    
                    for (k, value) in node {
                        
                        if let dataToEncrypt = value.data(using: .utf8) {
                            
                            if let sealedBox = try? ChaChaPoly.seal(dataToEncrypt, using: pk) {
                                
                                let encryptedData = sealedBox.combined
                                encryptedNode[k] = encryptedData
                                
                            } else {
                                
                                completion((false))
                                
                            }
                            
                        } else {
                            
                            completion((false))
                            
                        }
                        
                    }
                    
                    let cd = CoreDataService()
                    cd.saveEntity(dict: encryptedNode, entityName: .nodes) {
                        
                        if !cd.errorBool {
                            
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
        
    }
    
}
