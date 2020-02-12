//
//  SignMultiSig.swift
//  StandUp-Remote
//
//  Created by Peter on 17/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation


class SignMultiSig {
    
    var prevTxID = ""
    var vout = Int()
    var amount = Double()
    var isWitness = Bool()
    var redeemScript = ""
    var scriptSigHex = ""
    var signedByNodeTx = ""
    var privateKeys = [String]()
    
    func sign(tx: String, privateKeys: [String], completion: @escaping ((String?)) -> Void) {
        
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                func executeNodeCommand(method: BTC_CLI_COMMAND, param: String) {
                            
                            let reducer = Reducer()
                            
                            func getResult() {
                                
                                if !reducer.errorBool {
                                    
                                    switch method {
                                        
                //                    case .walletprocesspsbt:
                //
                //                        let dict = reducer.dictToReturn
                //                        print("processedpsbt = \(dict)")
                                        
                                    case .signrawtransactionwithwallet:
                                        
                                        let dict = reducer.dictToReturn
                                        let complete = dict["complete"] as! Bool
                                        
                                        if complete {
                                            
                                            let hex = dict["hex"] as! String
                                            self.signedByNodeTx = hex
                                            executeNodeCommand(method: .decoderawtransaction, param: "\"\(self.signedByNodeTx)\"")
                                            
                                        } else {
                                            
                                            let errors = dict["errors"] as! NSArray
                                            var errorStrings = [String]()
                                            
                                            for error in errors {
                                                
                                                let dic = error as! NSDictionary
                                                let str = dic["error"] as! String
                                                errorStrings.append(str)
                                                
                                            }
                                            
                                            var err = errorStrings.description.replacingOccurrences(of: "]", with: "")
                                            err = err.description.replacingOccurrences(of: "[", with: "")
                                            
                                            if let hex = dict["hex"] as? String {
                                                
                                                self.signedByNodeTx = hex
                                                executeNodeCommand(method: .decoderawtransaction, param: "\"\(self.signedByNodeTx)\"")
                                                
                                            } else {
                                                
                                                //error
                                                completion(nil)
                                                
                                            }
                                            
                                        }
                                        
                                    case .decoderawtransaction:
                                        
                                        let txDict = reducer.dictToReturn
                                        let vin = txDict["vin"] as! NSArray
                                        let vinDict = vin[0] as! NSDictionary
                                        self.prevTxID = vinDict["txid"] as! String
                                        self.vout = vinDict["vout"] as! Int
                                        
                                        executeNodeCommand(method: .getrawtransaction, param: "\"\(self.prevTxID)\", true")
                                        
                                    case .getrawtransaction:
                                        
                                        let prevTxDict = reducer.dictToReturn
                                        let outputs = prevTxDict["vout"] as! NSArray
                                        
                                        for outputDict in outputs {
                                            
                                            let output = outputDict as! NSDictionary
                                            let index = output["n"] as! Int
                                            
                                            if index == self.vout {
                                                
                                                let scriptPubKey = output["scriptPubKey"] as! NSDictionary
                                                let addresses = scriptPubKey["addresses"] as! NSArray
                                                let spendingFromAddress = addresses[0] as! String
                                                self.scriptSigHex = scriptPubKey["hex"] as! String
                                                self.amount = output["value"] as! Double
                                                
                                                executeNodeCommand(method: .getaddressinfo, param: "\"\(spendingFromAddress)\"")
                                                
                                            }
                                            
                                        }
                                        
                                    case .getaddressinfo:
                                        
                                        let result = reducer.dictToReturn
                                        
                                        if let script = result["hex"] as? String {
                                            
                                            self.isWitness = result["iswitness"] as! Bool
                                            self.redeemScript = script
                                            var param = ""
                                            
                                            if !self.isWitness {
                                                
                                                param = "\"\(self.signedByNodeTx)\", ''\(privateKeys)'', ''[{ \"txid\": \"\(self.prevTxID)\", \"vout\": \(self.vout), \"scriptPubKey\": \"\(self.scriptSigHex)\", \"redeemScript\": \"\(self.redeemScript)\", \"amount\": \(self.amount) }]''"
                                                
                                            } else {
                                                
                                                param = "\"\(self.signedByNodeTx)\", ''\(privateKeys)'', ''[{ \"txid\": \"\(self.prevTxID)\", \"vout\": \(self.vout), \"scriptPubKey\": \"\(self.scriptSigHex)\", \"witnessScript\": \"\(self.redeemScript)\", \"amount\": \(self.amount) }]''"
                                                
                                            }
                                            
                                            executeNodeCommand(method: .signrawtransactionwithkey, param: param)
                                            
                                        } else {
                                            
                                            //error fetching the redeem script
                                            print("error fetching redeem script")
                                            completion(nil)
                                            
                                        }
                                        
                                    case .signrawtransactionwithkey:
                                        
                                        let dict = reducer.dictToReturn
                                        print("result = \(dict)")
                                        let complete = dict["complete"] as! Bool
                                        
                                        if complete {
                                            
                                            let hex = dict["hex"] as! String
                                            completion(hex)
                                            
                                        } else {
                                            
                                            DispatchQueue.main.async {
                                                
                                                let errors = dict["errors"] as! NSArray
                                                var errorStrings = [String]()
                                                
                                                for error in errors {
                                                    
                                                    let dic = error as! NSDictionary
                                                    let str = dic["error"] as! String
                                                    errorStrings.append(str)
                                                    
                                                }
                                                
                                                var err = errorStrings.description.replacingOccurrences(of: "]", with: "")
                                                err = err.description.replacingOccurrences(of: "[", with: "")
                                                
                                                if let hex = dict["hex"] as? String {
                                                    
                                                    completion(hex)
                                                    
                                                } else {
                                                    
                                                    //error
                                                    completion(nil)
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    default:
                                        
                                        break
                                        
                                    }
                                    
                                } else {
                                    
                                    completion(nil)
                                    
                                }
                                
                            }
                            
                    reducer.makeCommand(walletName: wallet!.name, command: method,
                                                param: param,
                                                completion: getResult)
                            
                        }
                        
                        executeNodeCommand(method: .signrawtransactionwithwallet, param: "\"\(tx)\"")
                        //executeNodeCommand(method: .walletprocesspsbt, param: "\"\(tx)\"")
                
            }
            
        }
        
    }

}
