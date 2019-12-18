//
//  WalletCreator.swift
//  BitSense
//
//  Created by Peter on 05/12/19.
//  Copyright © 2019 Fontaine. All rights reserved.
//

import Foundation

class WalletCreator {
    
    let ud = UserDefaults.standard
    var importingChange = false
    var descriptor = ""
    var errorString = ""
    
    func createStandUpWallet(completion: @escaping (Bool) -> Void) {
        
        func checkForStandUpWallet() {
            
            executeNodeCommand(method: .listwalletdir,
                               param: "")
            
        }
        
        func executeNodeCommand(method: BTC_CLI_COMMAND, param: String) {
            
            let reducer = Reducer()
            
            func getResult() {
                
                if !reducer.errorBool {
                    
                    switch method {
                        
                    case .createwallet:
                        
                        let response = reducer.dictToReturn
                        handleWalletCreation(response: response)
                        
                    case .listwalletdir:
                        
                        let dict =  reducer.dictToReturn
                        parseWallets(walletDict: dict)
                        
                    case .importmulti:
                        
                        let result = reducer.arrayToReturn
                        print("result = \(result)")
                        let success = (result[0] as! NSDictionary)["success"] as! Bool
                        
                        if success {
                            
                            if importingChange {
                                
                                completion(true)
                                
                            } else {
                                
                                importChangeKeys()
                                
                            }
                            
                        } else {
                            
                            let errorDict = (result[0] as! NSDictionary)["error"] as! NSDictionary
                            let error = errorDict["message"] as! String
                            errorString = error
                            completion(false)
                            
                        }
                        
                        if let warnings = (result[0] as! NSDictionary)["warnings"] as? NSArray {
                            
                            if warnings.count > 0 {
                                
                                for warning in warnings {
                                    
                                    let warn = warning as! String
                                    errorString += warn
                                    
                                }
                                
                            }
                            
                        }
                        
                    case .getdescriptorinfo:
                        
                        let result = reducer.dictToReturn
                        descriptor = "\"\(result["descriptor"] as! String)\""
                        
                        let params = "[{ \"desc\": \(descriptor), \"timestamp\": \"now\", \"range\": [0,999], \"watchonly\": true, \"label\": \"StandUp\", \"keypool\": true, \"internal\": false }]"
                        
                        executeNodeCommand(method: .importmulti, param: params)
                        
                        
                    default:
                        
                        break
                        
                    }
                    
                } else {
                    
                    //return an error
                    errorString = reducer.errorDescription
                    print("reducer.errorDescription = \(reducer.errorDescription)")
                    completion((false))
                    
                }
                
            }
            
            reducer.makeCommand(command: method,
                                param: param,
                                completion: getResult)
            
        }
        
        func parseWallets(walletDict: NSDictionary) {
            
            let walletArr = walletDict["wallets"] as! NSArray
            var walletExists = false
            
            for wallet in walletArr {
                
                let dict = wallet as! NSDictionary
                let walletName = dict["name"] as! String
                
                if walletName == "StandUp" {
                    
                    walletExists = true
                    
                }
                
            }
            
            if walletExists {
                
                completion((true))
                
            } else {
                
                // create it
                let param = "\"StandUp\", true, true, \"\", true"
                executeNodeCommand(method: .createwallet, param: param)
                
            }
            
        }
        
        func handleWalletCreation(response: NSDictionary) {
            
            let name = response["name"] as! String
            let warning = response["warning"] as! String
            ud.set(name, forKey: "walletName")
            
            if warning == "" {
                
                
                
            } else {
                
                // should return an error to alert user to anything that may have gone wrong
                
            }
            
            importPrimaryAddresses()
            
        }
        
        func importPrimaryAddresses() {
            print("importPrimaryAddresses")
            
            //get the xpub
            let keyFetcher = KeyFetcher()
            keyFetcher.bip32Xpub { (xpub, error) in
                
                if !error {
                    
                    let param = "\"wpkh(\(xpub)/*)\""
                    executeNodeCommand(method: .getdescriptorinfo, param: param)
                    
                } else {
                    
                    print("error getting xpub")
                }
                
            }
            
        }
        
        func importChangeKeys() {
            
            importingChange = true
            let params = "[{ \"desc\": \(descriptor), \"timestamp\": \"now\", \"range\": [1000,1999], \"watchonly\": true, \"keypool\": true, \"internal\": true }]"
            executeNodeCommand(method: .importmulti, param: params)
            
        }
        
        checkForStandUpWallet()
        
    }
    
}
