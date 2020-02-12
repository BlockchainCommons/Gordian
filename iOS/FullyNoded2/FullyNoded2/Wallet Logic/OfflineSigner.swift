//
//  OfflineSigner.swift
//  StandUp-Remote
//
//  Created by Peter on 28/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation
import LibWally

class OfflineSigner {
    
    func signTransactionOffline(unsignedTx: String, completion: @escaping ((String?)) -> Void) {
        
        getActiveWalletNow { (wallet, error) in
            
            var inputsToSign = [TxInput]()
            var outputsToSend = [TxOutput]()
            var inputMetaDataArray = [NSDictionary]()
            var destinationAddresses = [Address]()
            var privKeys = [HDKey]()
            
            let reducer = Reducer()
            reducer.makeCommand(walletName: wallet!.name, command: .decodepsbt, param: "\"\(unsignedTx)\"") {
                
                if !reducer.errorBool {
                    
                    let decodedPSBT = reducer.dictToReturn
                    parseDecodedPSBT(psbt: decodedPSBT)
                    
                } else {
                    
                    print("error decoding psbt: \(reducer.errorDescription)")
                    completion(nil)
                    
                }
                
            }
            
            func parseDecodedPSBT(psbt: NSDictionary) {
                
                let inputs = psbt["inputs"] as! NSArray
                
                for input in inputs {
                    
                    inputMetaDataArray.append(input as! NSDictionary)
                    
                }
                
                let tx = psbt["tx"] as! NSDictionary
                parseTx(tx: tx)
                
            }
            
            func parseTx(tx: NSDictionary) {
                
                let vins = tx["vin"] as! NSArray
                let vouts = tx["vout"] as! NSArray
                parseVouts(vouts: vouts, vins: vins)
                
            }
            
            func parseVins(vins: NSArray) {
                
                for (i, input) in vins.enumerated() {
                    
                    let vinDict = input as! NSDictionary
                    let txid = vinDict["txid"] as! String
                    let vout = UInt32(vinDict["vout"] as! Int)
                    let witness_utxo = inputMetaDataArray[i]["witness_utxo"] as! NSDictionary
                    let scriptPubKeyDict = witness_utxo["scriptPubKey"] as! NSDictionary
                    let hex = scriptPubKeyDict["hex"] as! String
                    let scriptPubKey = ScriptPubKey.init(hex)!
                    let amount = UInt64((witness_utxo["amount"] as! Double) * 100000000)
                    let bip32derivs = inputMetaDataArray[i]["bip32_derivs"] as! NSArray
                    let path = (bip32derivs[0] as! NSDictionary)["path"] as! String
                    let index = Int(path.split(separator: "/")[1])!
                                    
                    let keyfetcher = KeyFetcher()
                    
                    keyfetcher.key(index: index) { (key, error) in
                        
                        if !error {
                            
                            //getActiveWalletNow { (wallet, error) in
                                
                                //if wallet != nil && !error {
                                                                    
                                    let witness = Witness(.payToWitnessPubKeyHash(key!.pubKey))
                                    let input = TxInput(Transaction(txid)!, vout, amount, nil, witness, scriptPubKey)!
                                    inputsToSign.append(input)
                                    privKeys.append(key!)
                                    
                                    if i + 1 == vins.count {
                                        
                                        var transaction = Transaction(inputsToSign, outputsToSend)
                                        let signedTx = transaction.sign(privKeys)
                                        
                                        if signedTx {
                                            
                                            completion(transaction.description!)
                                            
                                        } else {
                                            
                                            print("failed signing")
                                            completion(nil)
                                            
                                        }
                                                                    
                                    }
                                    
                                //}
                                
                            //}
                                                   
                        } else {
                            
                            print("error fetching key for offline signing")
                            completion(nil)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            func parseVouts(vouts: NSArray, vins: NSArray) {
                
                for (i, vout) in vouts.enumerated() {
                    
                    let dict = vout as! NSDictionary
                    let scriptPubKey = dict["scriptPubKey"] as! NSDictionary
                    let addresses = scriptPubKey["addresses"] as! NSArray
                    let amount = UInt64((dict["value"] as! Double) * 100000000)
                    let destination = Address.init((addresses[0] as! String))!
                    let output = TxOutput(destination.scriptPubKey, amount, .testnet)
                    outputsToSend.append(output)
                    
                    if i + 1 == vouts.count {
                        
                        parseVins(vins: vins)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

// MARK: P2WSH SINGLE SIGNATURE DECODED PSBT

/*
 
 {
     fee = "2.09e-06";
     inputs =     (
                 {
             "bip32_derivs" =             (
                                 {
                     "master_fingerprint" = ab0c1617;
                     path = "m/1024";
                     pubkey = 03dc580320edb2cf95619d48715208afe002c837323a172fb713c6460ad6d63db4;
                 }
             );
             "witness_utxo" =             {
                 amount = "0.00072718";
                 scriptPubKey =                 {
                     address = tb1qxa46ft82fuqx8jwumxxryzcwwmvmnyax2w5y27;
                     asm = "0 376ba4acea4f0063c9dcd98c320b0e76d9b993a6";
                     hex = 0014376ba4acea4f0063c9dcd98c320b0e76d9b993a6;
                     type = "witness_v0_keyhash";
                 };
             };
         },
                 {
             "bip32_derivs" =             (
                                 {
                     "master_fingerprint" = ab0c1617;
                     path = "m/29";
                     pubkey = 03ef392de264a1d7e65e63b630e05b3313e179e20e1f441d3ea2e1a60a1ed08f4a;
                 }
             );
             "witness_utxo" =             {
                 amount = "0.00014";
                 scriptPubKey =                 {
                     address = tb1q795pgjwf2tlkeez9yhk4fefss2dn6n4sjcvkm3;
                     asm = "0 f1681449c952ff6ce44525ed54e530829b3d4eb0";
                     hex = 0014f1681449c952ff6ce44525ed54e530829b3d4eb0;
                     type = "witness_v0_keyhash";
                 };
             };
         }
     );
     outputs =     (
                 {
             "bip32_derivs" =             (
                                 {
                     "master_fingerprint" = ab0c1617;
                     path = "m/1027";
                     pubkey = 03b1db6fb73dd648514a6980f9c13251beb3b5669de3b4f4a2f1b218925010c378;
                 }
             );
         },
                 {
             "bip32_derivs" =             (
                                 {
                     "master_fingerprint" = ab0c1617;
                     path = "m/31";
                     pubkey = 02633a8fd2dd143ba18d8a3772425430bc19ff723c416e5ef2ac711b91179bb2cb;
                 }
             );
         }
     );
     tx =     {
         hash = 8358e660362028b8c7817990705151e13f5b17c6c8c16f6e7a1de28ae7c0941c;
         locktime = 0;
         size = 154;
         txid = 8358e660362028b8c7817990705151e13f5b17c6c8c16f6e7a1de28ae7c0941c;
         version = 2;
         vin =         (
                         {
                 scriptSig =                 {
                     asm = "";
                     hex = "";
                 };
                 sequence = 4294967293;
                 txid = 405d6091ac3e3ffda1cac7a273ec7fb4a2d142ce072ddba6e20f5a103216f906;
                 vout = 0;
             },
                         {
                 scriptSig =                 {
                     asm = "";
                     hex = "";
                 };
                 sequence = 4294967293;
                 txid = de36a9af891799cfe80a406a57ac02711621d0e07ed8d2e79bd7267f15eb4275;
                 vout = 1;
             }
         );
         vout =         (
                         {
                 n = 0;
                 scriptPubKey =                 {
                     addresses =                     (
                         tb1qxq94e5cn0h6tdphyfxzl4c9sjqt8s8xgcpv4up
                     );
                     asm = "0 300b5cd3137df4b686e44985fae0b09016781cc8";
                     hex = 0014300b5cd3137df4b686e44985fae0b09016781cc8;
                     reqSigs = 1;
                     type = "witness_v0_keyhash";
                 };
                 value = "6.509e-05";
             },
                         {
                 n = 1;
                 scriptPubKey =                 {
                     addresses =                     (
                         tb1qk06rj22rf5wmvq6mxkdjaeh9httcj5h8gd0s5z
                     );
                     asm = "0 b3f43929434d1db6035b359b2ee6e5bad78952e7";
                     hex = 0014b3f43929434d1db6035b359b2ee6e5bad78952e7;
                     reqSigs = 1;
                     type = "witness_v0_keyhash";
                 };
                 value = "0.0008";
             }
         );
         vsize = 154;
         weight = 616;
     };
     unknown =     {
     };
 }
 */
