//
//  CreateMultisigWallet.swift
//  StandUp-Remote
//
//  Created by Peter on 14/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation

class CreateMultiSigWallet {
    
    let cd = CoreDataService()
    let enc = Encryption()
    
    func create(wallet: WalletStruct, nodeXprv: String, nodeXpub: String, completion: @escaping ((Bool)) -> Void) {
        
        let reducer = Reducer()
        
        func importMulti(param: Any) {
        
            reducer.makeCommand(walletName: wallet.name, command: .importmulti, param: param) {
                
                if !reducer.errorBool {
                    
                    let result = reducer.arrayToReturn
                    let success = (result[0] as! NSDictionary)["success"] as! Bool
                    
                    if success {
                        
                        print("success")
                        
                        completion(true)
                        
                    } else {
                        
                        let errorDict = (result[0] as! NSDictionary)["error"] as! NSDictionary
                        let error = errorDict["message"] as! String
                        print("error importing multi: \(error)")
                        completion(false)
                        
                    }
                    
                } else {
                    
                    print("error importmulti: \(reducer.errorDescription)")
                    completion(false)
                    
                }
                
            }
            
        }
        
        func createWallet() {
                
                let reducer = Reducer()
                let param = "\"\(wallet.name)\", false, true, \"\", true"
                reducer.makeCommand(walletName: wallet.name, command: .createwallet, param: param) {
                    
                    if !reducer.errorBool {
                        
                        let array = (wallet.descriptor).split(separator: "#")
                        var descriptor = "\(array[0])"
                        descriptor = descriptor.replacingOccurrences(of: nodeXpub, with: nodeXprv)
                        
                        reducer.makeCommand(walletName: wallet.name, command: .getdescriptorinfo, param: "\"\(descriptor)\"") {
                            
                            if !reducer.errorBool {
                                
                                print("result = \(reducer.dictToReturn)")
                                
                                let updatedDescriptor = reducer.dictToReturn["descriptor"] as! String
                                let checksum = reducer.dictToReturn["checksum"] as! String
                                let array = updatedDescriptor.split(separator: "#")
                                let hotDescriptor = "\(array[0])" + "#" + checksum
                                
                                var params = "[{ \"desc\": \"\(hotDescriptor)\", \"timestamp\": \"now\", \"range\": [0,1999], \"watchonly\": false, \"label\": \"StandUp\", \"keypool\": false, \"internal\": false }]"
                                params = params.replacingOccurrences(of: nodeXpub, with: nodeXprv)
                                importMulti(param: params)
                                
                            }
                            
                        }
                        
                    } else {
                        
                        print("error creating wallet")
                        completion(false)
                        
                    }
                    
                }
                
            }
        
        createWallet()
        
    }
    
}
