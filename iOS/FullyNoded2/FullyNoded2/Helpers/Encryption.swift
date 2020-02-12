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
    
    func encryptData(dataToEncrypt: Data, completion: @escaping ((encryptedData: Data?, error: Bool)) -> Void) {
        
        if let key = self.keychain.getData("privateKey") {
            
            let k = SymmetricKey(data: key)
            
            if let sealedBox = try? ChaChaPoly.seal(dataToEncrypt, using: k) {
                
                let encryptedData = sealedBox.combined
                completion((encryptedData,false))
                
            } else {
                
                completion((nil,true))
                
            }
            
        }
        
    }
    
    func decryptData(dataToDecrypt: Data, completion: @escaping ((Data?)) -> Void) {
        
        if #available(iOS 13.0, *) {
            
            if let key = self.keychain.getData("privateKey") {
                
                do {
                    
                    let box = try ChaChaPoly.SealedBox.init(combined: dataToDecrypt)
                    let k = SymmetricKey(data: key)
                    let decryptedData = try ChaChaPoly.open(box, using: k)
                    completion((decryptedData))
                    
                } catch {
                    
                    print("failed decrypting")
                    completion((nil))
                    
                }
                
            }
            
        }
        
    }
    
//    func getSeed(completion: @escaping ((seed: String, derivation: String, error: Bool)) -> Void) {
//
//        if #available(iOS 13.0, *) {
//
//            getActiveWallet() { (activeWallet) in
//
//                if activeWallet != nil {
//
//                    let encryptedSeed = activeWallet!.seed
//
//                    self.decryptData(dataToDecrypt: encryptedSeed) { (decryptedSeed) in
//
//                        if decryptedSeed != nil {
//
//                            if let seed = String(data: decryptedSeed!, encoding: .utf8) {
//
//                                completion((seed, activeWallet!.derivation, false))
//
//                            } else {
//
//                                completion(("","",true))
//
//                            }
//
//                        } else {
//
//                            completion(("","",true))
//
//                        }
//
//                    }
//
//                }
//
//            }
//
//        } else {
//            
//            completion(("","",true))
//
//        }
//
//    }
    
    func getNode(completion: @escaping ((node: NodeStruct?, error: Bool)) -> Void) {
        
        if #available(iOS 13.0, *) {
            
            if let key = keychain.getData("privateKey") {
                
                let pk = SymmetricKey(data: key)
                let cd = CoreDataService()
                cd.retrieveEntity(entityName: .nodes) { (nodes, errorDescription) in
                    
                    if errorDescription == nil {
                        
                        if nodes!.count > 0 {
                            
                            for node in nodes! {
                                
                                if (node["isActive"] as! Bool) {
                                    
                                    var decryptedNode = node
                                    var loopCount = 0
                                    
                                    for (k, value) in node {
                                                                                                                    
                                        if k != "isActive" && k != "id" && k != "walletCreated" && k != "keysImported" {
                                            
                                            loopCount += 1
                                         
                                            let dataToDecrypt = value as! Data
                                            
                                            do {
                                                
                                                let box = try ChaChaPoly.SealedBox.init(combined: dataToDecrypt)
                                                let decryptedData = try ChaChaPoly.open(box, using: pk)
                                                if let decryptedValue = String(data: decryptedData, encoding: .utf8) {
                                                    
                                                    decryptedNode[k] = decryptedValue
                                                    
                                                    if loopCount == 4 {
                                                        
                                                        // we know there will be 10 keys, so can check the loop has finished here
                                                        let nodeStruct = NodeStruct.init(dictionary: decryptedNode)
                                                        completion((nodeStruct,false))
                                                        
                                                    }
                                                    
                                                } else {
                                                    
                                                    completion((nil,true))
                                                    
                                                }
                                                
                                            } catch {
                                                
                                                print("error decryting node")
                                                completion((nil,true))
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        } else {
                            
                            print("no nodes")
                            completion((nil,true))
                            
                        }
                        
                    } else {
                        
                        print("error getting nodes: \(errorDescription!)")
                    }
                    
                }
                
            } else {
                
                print("private key not accessible")
                completion((nil,true))
                
            }
            
        } else {
            
            completion((nil,true))
            
        }
        
    }
    
    func saveNode(node: [String:Any], completion: @escaping ((Bool)) -> Void) {
        
        if #available(iOS 13.0, *) {
            
            if let key = self.keychain.getData("privateKey") {
                
                let pk = SymmetricKey(data: key)
                var encryptedNode = node
                
                for (k, value) in node {
                                        
                    if k != "id" && k != "isActive" && k != "walletCreated" && k != "keysImported" {
                        
                        let stringToEncrypt = value as! String
                        
                        if let dataToEncrypt = stringToEncrypt.data(using: .utf8) {
                            
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
        
    }
    
}
