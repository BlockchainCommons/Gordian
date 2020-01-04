//
//  WalletCreator.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation

class WalletCreator {
    
    let ud = UserDefaults.standard
    var importingChange = false
    var descriptor = ""
    var errorString = ""
    var birthdate = "\"now\""
    var statusDescription = "Creating your wallet..."
    
    func createStandUpWallet(completion: @escaping (Bool) -> Void) {
        
        if let birthdateCheck = ud.object(forKey: "birthdate") as? Int {
            
            birthdate = "\(birthdateCheck)"
            
        }
        
        func whichChain() {
            
            executeNodeCommand(method: .getblockchaininfo,
                               param: "")
            
        }
        
        func checkForStandUpWallet() {
            
            executeNodeCommand(method: .listwalletdir,
                               param: "")
            
        }
        
        func executeNodeCommand(method: BTC_CLI_COMMAND, param: String) {
            
            let reducer = Reducer()
            
            func getResult() {
                
                if !reducer.errorBool {
                    
                    switch method {
                        
                    case .getblockchaininfo:

                        let response = reducer.dictToReturn
                        let chain = response["chain"] as! String

                        if chain == "main" {

                            print("main chain")
                            self.ud.set("m/84'/0'/0'/0", forKey: "derivation")
                            checkForStandUpWallet()

                        } else {

                            print("test chain")
                            self.ud.set("m/84'/1'/0'/0", forKey: "derivation")
                            checkForStandUpWallet()

                        }
                                                
                    case .createwallet:
                        
                        let response = reducer.dictToReturn
                        handleWalletCreation(response: response)
                        
                    case .listwalletdir:
                        
                        let dict =  reducer.dictToReturn
                        parseWallets(walletDict: dict)
                        
                    case .importmulti:
                        
                        let result = reducer.arrayToReturn
                        let success = (result[0] as! NSDictionary)["success"] as! Bool
                        
                        if success {
                            
                            if importingChange {
                                
                                ud.set(true, forKey: "keysImported")
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
                        
                        let params = "[{ \"desc\": \(descriptor), \"timestamp\": \(birthdate), \"range\": [0,999], \"watchonly\": true, \"label\": \"StandUp\", \"keypool\": true, \"internal\": false }]"
                        
                        executeNodeCommand(method: .importmulti,
                                           param: params)
                        
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
            var standUpWalletName = "StandUp"
            
            if ud.object(forKey: "walletName") != nil {
                
                standUpWalletName = ud.object(forKey: "walletName") as! String
                
            }
            
            for wallet in walletArr {
                
                let dict = wallet as! NSDictionary
                let walletName = dict["name"] as! String
                
                if walletName == standUpWalletName {
                    
                    walletExists = true
                    
                }
                
            }
            
            if walletExists {
                
                // Import the keys again incase it failed
                
                if ud.object(forKey: "keysImported") == nil {
                    
                    importPrimaryAddresses()
                    
                } else {
                    
                    completion((true))
                    
                }
                
            } else {
                
                // create it
                let param = "\"\(standUpWalletName)\", true, true, \"\", true"
                executeNodeCommand(method: .createwallet,
                                   param: param)
                
            }
            
        }
        
        func handleWalletCreation(response: NSDictionary) {
            
            let warning = response["warning"] as! String
            ud.set(true, forKey: "walletCreated")
            
            if warning == "" {
                
                
            } else {
                
                // should return an error to alert user to anything that may have gone wrong
                
            }
            
            importPrimaryAddresses()
            
        }
        
        func importPrimaryAddresses() {
            print("importPrimaryAddresses")
            
            self.statusDescription = "Importing 1,000 primary addresses..."
            
            //get the xpub
            let keyFetcher = KeyFetcher()
            keyFetcher.bip32Xpub { (xpub, error) in
                
                if !error {
                    
                    let param = "\"wpkh(\(xpub!)/*)\""
                    executeNodeCommand(method: .getdescriptorinfo, param: param)
                    
                } else {
                    
                    print("error getting xpub")
                    
                }
                
            }
            
        }
        
        func importChangeKeys() {
            
            self.statusDescription = "Importing 1,000 change addresses..."
            importingChange = true
            let params = "[{ \"desc\": \(descriptor), \"timestamp\": \(birthdate), \"range\": [1000,1999], \"watchonly\": true, \"keypool\": true, \"internal\": true }]"
            executeNodeCommand(method: .importmulti, param: params)
            
        }
        
        whichChain()
        
    }
    
}
