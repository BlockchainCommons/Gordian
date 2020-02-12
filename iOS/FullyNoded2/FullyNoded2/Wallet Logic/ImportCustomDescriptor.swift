//
//  ImportCustomDescriptor.swift
//  FullyNoded2
//
//  Created by Peter on 10/02/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation


class ImportColdMultiSigDescriptor {
    
    func create(descriptor: String, completion: @escaping ((success: Bool, error:Bool, errorDescription: String?)) -> Void) {
        
        let enc = Encryption()
        enc.getNode { (node, error) in
            
            if node != nil && !error {
                
                let reducer = Reducer()
                var newWallet = [String:Any]()
                newWallet["birthdate"] = keyBirthday()
                newWallet["id"] = UUID()
                newWallet["isActive"] = false
                newWallet["name"] = "\(randomString(length: 10))_StandUp"
                newWallet["lastUsed"] = Date()
                newWallet["lastBalance"] = 0.0
                newWallet["type"] = "CUSTOM"
                newWallet["nodeId"] = node!.id
                newWallet["isArchived"] = false
                let str = WalletStruct(dictionary: newWallet)
                
                let param = "\"\(str.name)\", true, true, \"\", true"
                
                reducer.makeCommand(walletName: str.name, command: .createwallet, param: param) {
                    
                    if !reducer.errorBool {
                        
                        reducer.makeCommand(walletName: "", command: .getdescriptorinfo, param: "\"\(descriptor)\"") {
                            
                            if !reducer.errorBool {
                                
                                let result = reducer.dictToReturn
                                let processedDescriptor = result["descriptor"] as! String
                                
                                newWallet["descriptor"] = processedDescriptor
                                
                                let params = "[{ \"desc\": \"\(processedDescriptor)\", \"timestamp\": \"now\", \"range\": [0,1999], \"watchonly\": true, \"label\": \"FullyNoded2\", \"keypool\": false, \"internal\": false }]"
                                
                                reducer.makeCommand(walletName: str.name, command: .importmulti, param: params) {
                                    
                                    if !reducer.errorBool {
                                        
                                        let walletSaver = WalletSaver()
                                        walletSaver.save(walletToSave: newWallet) { (success) in
                                            
                                            if success {
                                                
                                                completion((true, false, nil))
                                                
                                            } else {
                                                
                                                completion((false, true, "failed saving wallet locally"))
                                                
                                            }
                                            
                                        }
                                        
                                    } else {
                                        
                                        completion((false, true, reducer.errorDescription))
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                completion((false, true, reducer.errorDescription))
                                
                            }
                            
                        }
                        
                    } else {
                        
                        completion((false, true, reducer.errorDescription))
                        
                    }
                    
                }
                
            } else {
                
                completion((false, true, "error getting active node"))
                
            }
            
        }
        
    }
    
}
