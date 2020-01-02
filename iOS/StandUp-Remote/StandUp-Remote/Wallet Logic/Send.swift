//
//  Send.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation

class Send {
    
    var amount = Double()
    var addressToPay = ""
    var signedRawTx = ""
    var unsignedRawTx = ""
    var errorBool = Bool()
    var errorDescription = ""
    var numberOfBlocks = Int()
    var outputs = ""
    var index = 0
    var indexarray = [String]()
    
    func create(completion: @escaping () -> Void) {
        
        let reducer = Reducer()
        
        func getAddressInfo(addresses: [String]) {
            print("getAddressInfo: \(addresses)")
            
            var privkeyarray = [String]()
            
            func sign() {
                print("sign")
                
                let param = "\"\(unsignedRawTx)\", \(privkeyarray)"
                reducer.makeCommand(command: .signrawtransactionwithkey, param: param) {
                    
                    if !reducer.errorBool {
                        
                        let dict = reducer.dictToReturn
                        print("dict = \(dict)")
                        let complete = dict["complete"] as! Bool
                        
                        if complete {
                            
                            let hex = dict["hex"] as! String
                            self.signedRawTx = hex
                            completion()
                            
                        } else {
                            
                            
                        }
                        
                    } else {
                        
                        self.errorBool = true
                        self.errorDescription = reducer.errorDescription
                        completion()
                    }
                    
                }
                
            }
            
            func getinfo() {
                
                if !reducer.errorBool {
                    
                    self.index += 1
                    let result = reducer.dictToReturn
                    print("result: \(result)")
                    let hdkeypath = result["hdkeypath"] as! String
                    let arr = hdkeypath.components(separatedBy: "/")
                    indexarray.append(arr[1])
                    print("indexarray = \(indexarray)")
                    getAddressInfo(addresses: addresses)
                        
                } else {
                    
                    errorBool = true
                    errorDescription = reducer.errorDescription
                    completion()
                    
                }
                
            }
            
            if addresses.count > self.index {
                
                reducer.makeCommand(command: .getaddressinfo,
                                    param: "\"\(addresses[self.index])\"",
                                    completion: getinfo)
                
            } else {
                
                print("loop finished")
                // loop is finished get the private keys
                let keyfetcher = KeyFetcher()
                print("indexarray2 = \(indexarray)")
                
                for (i, keypathint) in indexarray.enumerated() {
                    
                    let int = Int(keypathint)!
                    
                    keyfetcher.privKey(index: int) { (privKey, error) in
                        
                        if !error {
                            
                            privkeyarray.append(privKey!)
                            
                            if i == self.indexarray.count - 1 {
                                
                                // get the unsigned raw transaction and sign it
                                print("privekeys = \(privkeyarray)")
                                sign()
                                
                            }
                            
                        } else {
                            
                            self.errorBool = true
                            self.errorDescription = "error getting private key"
                            completion()
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        func executeNodeCommand(method: BTC_CLI_COMMAND, param: String) {
            
            func getResult() {
                
                if !reducer.errorBool {
                    
                    switch method {
                        
                    case .walletprocesspsbt:
                        
                        let psbt = reducer.dictToReturn["psbt"] as! String
                        executeNodeCommand(method: .decodepsbt, param: "\"\(psbt)\"")
                        
                    case .converttopsbt:
                        
                        let psbt = reducer.stringToReturn
                        executeNodeCommand(method: .walletprocesspsbt, param: "\"\(psbt)\"")
                        
                    case .fundrawtransaction:

                        let result = reducer.dictToReturn
                        unsignedRawTx = result["hex"] as! String
                        //completion()
                        
                        executeNodeCommand(method: .converttopsbt, param: "\"\(unsignedRawTx)\"")

                    case .createrawtransaction:

                        let unsignedRawTx = reducer.stringToReturn

                        let param = "\"\(unsignedRawTx)\", { \"includeWatching\":true, \"subtractFeeFromOutputs\":[], \"replaceable\": true, \"conf_target\": \(numberOfBlocks) }"

                        executeNodeCommand(method: .fundrawtransaction,
                                           param: param)
                        
                    case .walletcreatefundedpsbt:
                        
                        print("walletcreatefundedpsbt")
                        let result = reducer.dictToReturn
                        let psbt = result["psbt"] as? String ?? "error getting psbt"
                        unsignedRawTx = psbt
                        //completion()
                        
                    case .decodepsbt:
                        
                        let decodedPsbt = reducer.dictToReturn
                        let inputArray = decodedPsbt["inputs"] as! NSArray
                        var addressArray = [String]()
                        
                        for input in inputArray {
                            
                            let dict = input as! NSDictionary
                            let witness_utxo = dict["witness_utxo"] as! NSDictionary
                            let scriptPubKey = witness_utxo["scriptPubKey"] as! NSDictionary
                            let address = scriptPubKey["address"] as! String
                            addressArray.append(address)
                            
                        }
                        
                        getAddressInfo(addresses: addressArray)
                        
                    default:
                        
                        break
                        
                    }
                    
                } else {
                    
                    errorBool = true
                    errorDescription = reducer.errorDescription
                    completion()
                    
                }
                
            }
            
            reducer.makeCommand(command: method,
                                param: param,
                                completion: getResult)
            
        }
        
//        let param = "''[]'', ''{\(self.outputs)}'', 0, { \"includeWatching\":true, \"subtractFeeFromOutputs\":[], \"replaceable\": true, \"conf_target\": \(numberOfBlocks), \"change_type\": \"bech32\" }, true"
//
//        executeNodeCommand(method: .walletcreatefundedpsbt,
//                           param: param)
        
        let param = "''[]'', ''{\(self.outputs)}'', 0, true"
        
        executeNodeCommand(method: .createrawtransaction,
                           param: param)
        
    }
    
}
