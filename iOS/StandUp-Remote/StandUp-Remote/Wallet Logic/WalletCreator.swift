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
    var statusDescription = "Creating your wallet..."
    
    func createStandUpWallet(derivation: String, completion: @escaping ((success: Bool, errorDescription: String?)) -> Void) {
        
        getActiveWallet { (wallet) in
            
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
                                
                                var newDerivation = wallet!.derivation
                                
                                switch wallet!.derivation {
                                    
                                case "m/84'/1'/0'/0":
                                    
                                    newDerivation = "m/84'/0'/0'/0"
                                    
                                case "m/44'/1'/0'/0":
                                    
                                    newDerivation = "m/44'/0'/0'/0"
                                    
                                case "m/49'/1'/0'/0":
                                    
                                    newDerivation = "m/49'/0'/0'/0"
                                    
                                default:
                                    
                                    break
                                    
                                }
                                
                                let cd = CoreDataService()
                                
                                cd.updateEntity(id: wallet!.id, keyToUpdate: "derivation", newValue: newDerivation, entityName: .wallets) {
                                    
                                    if !cd.errorBool {
                                        
                                        print("changed derivation to mainnet")
                                        checkForStandUpWallet()
                                        
                                    }
                                    
                                }
                                
                            } else {

                                print("test chain")
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
                                
                                if self.importingChange {
                                    
                                    self.ud.set(true, forKey: "keysImported")
                                    completion((true,nil))
                                    
                                } else {
                                    
                                    importChangeKeys()
                                    
                                }
                                
                            } else {
                                
                                let errorDict = (result[0] as! NSDictionary)["error"] as! NSDictionary
                                let error = errorDict["message"] as! String
                                completion((false,error))
                                
                            }
                            
                            if let warnings = (result[0] as! NSDictionary)["warnings"] as? NSArray {
                                
                                if warnings.count > 0 {
                                    
                                    for warning in warnings {
                                        
                                        let warn = warning as! String
                                        self.errorString += warn
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        case .getdescriptorinfo:
                            
                            let result = reducer.dictToReturn
                            self.descriptor = "\"\(result["descriptor"] as! String)\""
                            
                            let params = "[{ \"desc\": \(self.descriptor), \"timestamp\": \"now\", \"range\": [0,999], \"watchonly\": true, \"label\": \"StandUp\", \"keypool\": true, \"internal\": false }]"
                            
                            executeNodeCommand(method: .importmulti,
                                               param: params)
                            
                        default:
                            
                            break
                            
                        }
                        
                    } else {
                        
                        completion((false,reducer.errorDescription))
                        
                    }
                    
                }
                
                reducer.makeCommand(command: method,
                                    param: param,
                                    completion: getResult)
                
            }
            
            func parseWallets(walletDict: NSDictionary) {
                
                let walletArr = walletDict["wallets"] as! NSArray
                var walletExists = false
                
                for existingWallet in walletArr {
                    
                    let dict = existingWallet as! NSDictionary
                    let existingWalletName = dict["name"] as! String
                    
                    if existingWalletName == wallet!.name {
                        
                        walletExists = true
                        
                    }
                    
                }
                
                if walletExists {
                    
                    // Import the keys again incase it failed
                    
                    if self.ud.object(forKey: "keysImported") == nil {
                        
                        importPrimaryAddresses()
                        
                    } else {
                        
                        completion((true,nil))
                        
                    }
                    
                } else {
                    
                    // create it
                    let param = "\"\(wallet!.name)\", true, true, \"\", true"
                    executeNodeCommand(method: .createwallet,
                                       param: param)
                    
                }
                
            }
            
            func handleWalletCreation(response: NSDictionary) {
                
                let warning = response["warning"] as! String
                self.ud.set(true, forKey: "walletCreated")
                
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
                        
                        var param = ""
                        //let ud = UserDefaults.standard
                        //let derivation = ud.object(forKey: "derivation") as! String
                        
                        switch wallet!.derivation {
                            
                        case "m/84'/1'/0'/0", "m/84'/0'/0'/0":
                            
                            param = "\"wpkh(\(xpub!)/*)\""
                            
                        case "m/44'/1'/0'/0", "m/44'/0'/0'/0":
                            
                            param = "\"pkh(\(xpub!)/*)\""
                            
                        case "m/49'/1'/0'/0", "m/49'/0'/0'/0":
                            
                            param = "\"sh(wpkh(\(xpub!)/*))\""
                            
                        default:
                            
                            break
                            
                        }
                        
                        //let param = "\"wpkh(\(xpub!)/*)\""
                        executeNodeCommand(method: .getdescriptorinfo, param: param)
                        
                    } else {
                        
                        print("error getting xpub")
                        
                    }
                    
                }
                
            }
            
            func importChangeKeys() {
                
                self.statusDescription = "Importing 1,000 change addresses..."
                self.importingChange = true
                let params = "[{ \"desc\": \(self.descriptor), \"timestamp\": \"now\", \"range\": [1000,1999], \"watchonly\": true, \"keypool\": true, \"internal\": true }]"
                executeNodeCommand(method: .importmulti, param: params)
                
            }
            
            whichChain()
            
        }
        
    }
    
}
