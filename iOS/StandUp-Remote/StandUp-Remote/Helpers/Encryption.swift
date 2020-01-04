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
            
            //if self.ud.bool(forKey: "privateKeySet") {
            //if let privateKeySet = self.keychain.getBool("privateKeySet") {
                
                //if privateKeySet {
                    
                    if let key = self.keychain.getData("privateKey") {
                        
                        let k = SymmetricKey(data: key)
                        
                        if let dataToEncrypt = string.data(using: .utf8) {
                            
                            if let sealedBox = try? ChaChaPoly.seal(dataToEncrypt, using: k) {
                                
                                //let cd = CoreDataService()
                                let encryptedData = sealedBox.combined
                                let success = self.keychain.set(encryptedData, forKey: "seed")
                                
                                if success {
                                    
                                    print("saved seed to keychain")
                                    completion((true))
                                    
                                } else {
                                    
                                    print("error saving seed to keychain")
                                    completion((false))
                                    
                                }
                                //                            cd.saveSeed(seed: encryptedData) {
                                //
                                //                                if !cd.errorBool {
                                //
                                //                                    print("saved seed to coredata")
                                //                                    completion((true))
                                //
                                //                                } else {
                                //
                                //                                    completion((false))
                                //
                                //                                }
                                //
                                //                            }
                                
                            } else {
                                
                                completion((false))
                                
                            }
                            
                        } else {
                            
                            completion((false))
                            
                        }
                        
                    } else {
                        
                        completion((false))
                        
                    }
                    
                //}
                
//            } else {
//
//                completion((false))
//
//            }
            
        } else {
            
            completion((false))
            
        }
        
    }
    
    func getSeed(completion: @escaping ((seed: String, error: Bool)) -> Void) {
        
        if #available(iOS 13.0, *) {
            
            //if let privateKeySet = self.keychain.getBool("privateKeySet") {
                
                //if privateKeySet {
                    
                    if let key = keychain.getData("privateKey") {
                        
                        if let encryptedSeed = self.keychain.getData("seed") {
                            
                            do {
                                
                                let box = try ChaChaPoly.SealedBox.init(combined: encryptedSeed)
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
                    
                    
//                } else {
//
//                    completion(("",true))
//
//                }
                
//            } else {
//
//                completion(("",true))
//
//            }
            
        } else {
            
            completion(("",true))
            
        }
        
    }
    
    func getNode(completion: @escaping ((node: NodeStruct?, error: Bool)) -> Void) {
        
        if #available(iOS 13.0, *) {
            
            //if ud.bool(forKey: "privateKeySet") {
                
                if let key = keychain.getData("privateKey") {
                    
                    let pk = SymmetricKey(data: key)
                    let cd = CoreDataService()
                    cd.retrieveEntity(entityName: .nodes) {
                        
                        let node = cd.entities[0]
                        var decryptedNode = [String:Any]()
                        var loopCount = 0
                        
                        for (k, value) in node {
                            
                            let dataToDecrypt = value as! Data
                            
                            do {
                                
                                let box = try ChaChaPoly.SealedBox.init(combined: dataToDecrypt)
                                let decryptedData = try ChaChaPoly.open(box, using: pk)
                                if let decryptedValue = String(data: decryptedData, encoding: .utf8) {
                                    
                                    decryptedNode[k] = decryptedValue
                                    loopCount += 1
                                    
                                    if loopCount == 6 {
                                        
                                        // we know there will be 6 keys, so can check the loop has finished here
                                        let nodeStruct = NodeStruct.init(dictionary: decryptedNode)
                                        completion((nodeStruct,false))
                                        
                                    }
                                    
                                } else {
                                    
                                    completion((nil,true))
                                    
                                }
                                
                            } catch {
                                
                                completion((nil,true))
                                
                            }
                            
                        }
                                                
                    }
                    
                } else {
                    
                    completion((nil,true))
                    
                }
                
//            } else {
//
//                completion((nil,true))
//
//            }
            
        } else {
            
            completion((nil,true))
            
        }
        
    }
    
    func saveNode(node: [String:String], completion: @escaping ((Bool)) -> Void) {
        
        if #available(iOS 13.0, *) {
            
            //if self.ud.bool(forKey: "privateKeySet") {
                
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
                
//            } else {
//
//                completion((false))
//
//            }
            
        } else {
            
            completion((false))
            
        }
        
    }
    
}
