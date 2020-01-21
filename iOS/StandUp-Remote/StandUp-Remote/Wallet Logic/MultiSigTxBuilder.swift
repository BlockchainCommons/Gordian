//
//  MultiSigTxBuilder.swift
//  StandUp-Remote
//
//  Created by Peter on 20/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation


class MultiSigTxBuilder {
    
    func build(amount: Double, outputs: [Any], completion: @escaping ((String?)) -> Void) {
        
        var outputTotalAmount = Double()
        var inputs = [NSDictionary]()
        var inputArray = [Any]()
        var changeAddress = ""
        var inputTotal = Double()
        var outputsPlusChange = outputs
        var optimizedOutputs = outputs
        
        func getChangeAddress() {
            let keyFetcher = KeyFetcher()
            keyFetcher.musigChangeAddress { (address, error) in
                if !error {
                    changeAddress = address!
                    getUtxos()
                } else {
                    print("error getting change address")
                    completion(nil)
                }
            }
        }
        
        getChangeAddress()
        
        func getUtxos() {
            let reducer = Reducer()
            reducer.makeCommand(command: .listunspent, param: "0") {
                if !reducer.errorBool {
                    let utxos = reducer.arrayToReturn
                    parseUtxos(utxos: utxos)
                } else {
                    print("error getting utxos: \(reducer.errorDescription)")
                    completion(nil)
                }
            }
        }
        
        func parseUtxos(utxos: NSArray) {
            if utxos.count > 0 {
                for utxo in utxos {
                    let dict = utxo as! NSDictionary
                    let utxoAmount = dict["amount"] as! Double
                    if inputTotal < amount {
                        inputTotal += utxoAmount
                        inputs.append(dict)
                    } else {
                        getDummySignedTx()
                    }
                }
            } else {
                print("no utxos")
                completion(nil)
            }
        }
        
        func getDummySignedTx() {
            
            var inputAddresses = [String]()
            
            for utxo in inputs {
                let dict = utxo as! [String:Any]
                let txid = dict["txid"] as! String
                let vout = dict["vout"] as! Int
                let address = dict["address"] as! String
                inputAddresses.append(address)
                let input = "{\"txid\":\"\(txid)\",\"vout\": \(vout),\"sequence\": 1}"
                inputArray.append(input)
            }
            
            let privateKeyFetcher = GetPrivateKeys()
            privateKeyFetcher.getKeys(addresses: inputAddresses) { (privateKeys) in
                
                if privateKeys != nil {
                    
                    if privateKeys!.count > 0 {
                        
                        var inputsString = inputArray.description
                        inputsString = inputsString.replacingOccurrences(of: "\\", with: "")
                        
                        let changeAmount = rounded(number: (inputTotal - amount) - 0.00000300)
                        let changeOuput = [changeAddress:changeAmount]
                        outputsPlusChange.append(changeOuput)
                        
                        var outputsString = outputsPlusChange.description
                        outputsString = outputsString.replacingOccurrences(of: "[", with: "")
                        outputsString = outputsString.replacingOccurrences(of: "]", with: "")
                                    
                        var param = "''\(inputsString)'', ''{\(outputsString)}''"
                        param = param.replacingOccurrences(of: "\"{", with: "{")
                        param = param.replacingOccurrences(of: "}\"", with: "}")
                        
                        let reducer = Reducer()
                        reducer.makeCommand(command: .createrawtransaction, param: param) {
                            
                            if !reducer.errorBool {
                                
                                let unsignedRawTx = reducer.stringToReturn
                                let musigSigner = SignMultiSig()
                                musigSigner.sign(tx: unsignedRawTx, privateKeys: privateKeys!) { (signedTx) in
                                    
                                    if signedTx != nil {
                                        
                                        // get dummy signed raw tx first for fee optimization
                                        let feeOptimizer = GetSmartFee()
                                        feeOptimizer.rawSigned = signedTx!
                                        feeOptimizer.getSmartFee {
                                            
                                            let optimalFee = rounded(number: feeOptimizer.optimalFee)
                                            getOptimizedTx(optimalFee: optimalFee, processedInputs: inputsString, privateKeys: privateKeys!)
                                            
                                        }
                                        
                                    } else {
                                        
                                        print("error getting signed tx")
                                        completion(nil)
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                print("error creating tx: \(reducer.errorDescription)")
                                completion(nil)
                                
                            }
                        }
                        
                    } else {
                        
                        print("error no private keys returned")
                        completion(nil)
                        
                    }
                    
                } else {
                    
                    print("error getting private keys")
                    completion(nil)
                    
                }
                
            }
            
        }
        
        func getOptimizedTx(optimalFee: Double, processedInputs: String, privateKeys: [String]) {
            
            let changeAmount = rounded(number: (inputTotal - amount) - optimalFee)
            let changeOuput = [changeAddress:changeAmount]
            optimizedOutputs.append(changeOuput)
            
            var outputsString = optimizedOutputs.description
            outputsString = outputsString.replacingOccurrences(of: "[", with: "")
            outputsString = outputsString.replacingOccurrences(of: "]", with: "")
                        
            var param = "''\(processedInputs)'', ''{\(outputsString)}''"
            param = param.replacingOccurrences(of: "\"{", with: "{")
            param = param.replacingOccurrences(of: "}\"", with: "}")
            
            let reducer = Reducer()
            reducer.makeCommand(command: .createrawtransaction, param: param) {
                
                if !reducer.errorBool {
                    
                    let unsignedRawTx = reducer.stringToReturn
                    let musigSigner = SignMultiSig()
                    musigSigner.sign(tx: unsignedRawTx, privateKeys: privateKeys) { (signedTx) in
                        
                        if signedTx != nil {
                            
                            completion(signedTx!)
                            
                        } else {
                            
                            completion(nil)
                            print("error signing optimized transaction")
                            
                        }
                        
                    }
                    
                } else {
                    
                    completion(nil)
                    print("error creating optimized transaction: \(reducer.errorDescription)")
                    
                }
                
            }
            
        }
        
    }
    
}
