//
//  OfflineSignerP2SHSegwit.swift
//  StandUp-Remote
//
//  Created by Peter on 30/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation
import LibWally

class OfflineSignerP2SHSegwit {
    
    func signTransactionOffline(unsignedTx: String, completion: @escaping ((String?)) -> Void) {
        
//        var inputsToSign = [TxInput]()
//        var outputsToSend = [TxOutput]()
//        var inputMetaDataArray = [NSDictionary]()
//        var destinationAddresses = [Address]()
//        var privKeys = [HDKey]()
//        
//        let reducer = Reducer()
//        reducer.makeCommand(command: .decodepsbt, param: "\"\(unsignedTx)\"") {
//            
//            if !reducer.errorBool {
//                
//                let decodedPSBT = reducer.dictToReturn
//                parseDecodedPSBT(psbt: decodedPSBT)
//                
//            } else {
//                
//                print("error decoding psbt: \(reducer.errorDescription)")
//                completion(nil)
//                
//            }
//            
//        }
//        
//        func parseDecodedPSBT(psbt: NSDictionary) {
//            
//            let inputs = psbt["inputs"] as! NSArray
//            
//            for (i, input) in inputs.enumerated() {
//                
//                inputMetaDataArray.append(input as! NSDictionary)
//                
//                if i + 1 == inputs.count {
//                    
//                    let tx = psbt["tx"] as! NSDictionary
//                    parseTx(tx: tx)
//                    
//                }
//                
//            }
//            
//        }
//        
//        func parseTx(tx: NSDictionary) {
//            
//            let vins = tx["vin"] as! NSArray
//            let vouts = tx["vout"] as! NSArray
//            parseVouts(vouts: vouts, vins: vins)
//            
//        }
//        
//        func parseVins(vins: NSArray) {
//            
//            print("vins.count = \(vins.count)")
//        
//            for (i, input) in vins.enumerated() {
//                
//                let vinDict = input as! NSDictionary
//                let txid = vinDict["txid"] as! String
//                let vout = UInt32(vinDict["vout"] as! Int)
//                
//                let witness_utxo = inputMetaDataArray[i]["witness_utxo"] as! NSDictionary
//                let scriptPubKeyDict = witness_utxo["scriptPubKey"] as! NSDictionary
//                let hex = scriptPubKeyDict["hex"] as! String
//                let scriptPubKey = ScriptPubKey(hex)!
//                let amount = UInt64((witness_utxo["amount"] as! Double) * 100000000)
//                let bip32derivs = inputMetaDataArray[i]["bip32_derivs"] as! NSArray
//                let bip32derivsDict = bip32derivs[0] as! NSDictionary
//                let path = bip32derivsDict["path"] as! String
//                let index = Int(path.split(separator: "/")[1])!
//                
////                let pubkeyString = bip32derivsDict["pubkey"] as! String
////                let pubkeyData = Data.init(pubkeyString)!
////                let pubkey = PubKey.init(pubkeyData, .testnet)!
//                
//                let keyfetcher = KeyFetcher()
//                
//                keyfetcher.key(index: index) { (key, error) in
//                    
//                    if !error {
//                        
//                        let witness = Witness(.payToScriptHashPayToWitnessPubKeyHash(key!.pubKey))
//                        let input = TxInput(Transaction(txid)!, vout, amount, nil, witness, scriptPubKey)!
//                        inputsToSign.append(input)
//                        privKeys.append(key!)
//                        
//                        if i + 1 == vins.count {
//                            
//                            var transaction = Transaction(inputsToSign, outputsToSend)
//                            let signedTx = transaction.sign(privKeys)
//                            
//                            if signedTx {
//                                
//                                completion(transaction.description!)
//                                
//                            } else {
//                                
//                                print("failed signing")
//                                completion(nil)
//                                
//                            }
//                                                        
//                        }
//                                               
//                    } else {
//                        
//                        print("error fetching key for offline signing")
//                        completion(nil)
//                        
//                    }
//                    
//                }
//            
//            }
//            
//        }
//        
//        func parseVouts(vouts: NSArray, vins: NSArray) {
//            
//            for (i, vout) in vouts.enumerated() {
//                
//                let dict = vout as! NSDictionary
//                let scriptPubKey = dict["scriptPubKey"] as! NSDictionary
//                let addresses = scriptPubKey["addresses"] as! NSArray
//                let amount = UInt64((dict["value"] as! Double) * 100000000)
//                let destination = Address.init((addresses[0] as! String))!
//                let output = TxOutput(destination.scriptPubKey, amount, .testnet)
//                outputsToSend.append(output)
//                                
//                if i + 1 == vouts.count {
//                    
//                    parseVins(vins: vins)
//                    
//                }
//                
//            }
//            
//        }
        
    }
    
}

// MARK: P2SH-SEGWIT DECODED PSBT EXAMPLE

/*
 
 {
     fee = "1.66e-06";
     inputs =     (
                 {
             "bip32_derivs" =             (
                                 {
                     "master_fingerprint" = 7122bed7;
                     path = "m/0";
                     pubkey = 034624871d247d73085a733d4d7682e4aea2c752666b3d5eed3b045978186b1908;
                 }
             );
             "redeem_script" =             {
                 asm = "0 ae29f5cdd1186911b9892fc3b138dd2766b6d2fb";
                 hex = 0014ae29f5cdd1186911b9892fc3b138dd2766b6d2fb;
                 type = "witness_v0_keyhash";
             };
             "witness_utxo" =             {
                 amount = "0.01";
                 scriptPubKey =                 {
                     address = 2NACU5eWkXCpjrFDp9KfLntMSRpBMpucNd4;
                     asm = "OP_HASH160 b9f4a77ca7d570fe9f9d59c368a63f7d20c72572 OP_EQUAL";
                     hex = a914b9f4a77ca7d570fe9f9d59c368a63f7d20c7257287;
                     type = scripthash;
                 };
             };
         }
     );
     outputs =     (
                 {
             "bip32_derivs" =             (
                                 {
                     "master_fingerprint" = 7122bed7;
                     path = "m/1000";
                     pubkey = 0362b5506fd67418c361c5e10d9a877c112863de958de4eee75458bc514a7aad1c;
                 }
             );
             "redeem_script" =             {
                 asm = "0 4a73d2c40642946c661bc307aacc026f220eaaf8";
                 hex = 00144a73d2c40642946c661bc307aacc026f220eaaf8;
                 type = "witness_v0_keyhash";
             };
         },
                 {
             "bip32_derivs" =             (
                                 {
                     "master_fingerprint" = 7122bed7;
                     path = "m/1";
                     pubkey = 03f46db645b5c94bf906a295613bb269085aa5f3b90e6a0634a60882444ca9daca;
                 }
             );
             "redeem_script" =             {
                 asm = "0 3336ce358cb46fa5d87140100cbcf6be485b26c1";
                 hex = 00143336ce358cb46fa5d87140100cbcf6be485b26c1;
                 type = "witness_v0_keyhash";
             };
         }
     );
     tx =     {
         hash = 23f42eb13e627c557206b6869c82fc42932d6f9e5e92eade5c569cabf02768b2;
         locktime = 0;
         size = 115;
         txid = 23f42eb13e627c557206b6869c82fc42932d6f9e5e92eade5c569cabf02768b2;
         version = 2;
         vin =         (
                         {
                 scriptSig =                 {
                     asm = "";
                     hex = "";
                 };
                 sequence = 4294967293;
                 txid = c815b47192cc0a87674f8e85cf1942dde022995b8f2ce5e217d112c507ae542f;
                 vout = 1;
             }
         );
         vout =         (
                         {
                 n = 0;
                 scriptPubKey =                 {
                     addresses =                     (
                         2NGB3E8QxpLmnpU92CcJKB3eyiHfRJQA6BR
                     );
                     asm = "OP_HASH160 fb803f00689600595eb322903d59104b163b955d OP_EQUAL";
                     hex = a914fb803f00689600595eb322903d59104b163b955d87;
                     reqSigs = 1;
                     type = scripthash;
                 };
                 value = "0.008998340000000001";
             },
                         {
                 n = 1;
                 scriptPubKey =                 {
                     addresses =                     (
                         2N8nHNdxduJuwvGR6ab7eNmdYAbfqxjqRvf
                     );
                     asm = "OP_HASH160 aa699b8a020963891b975a3a62e4b0d8b12b39af OP_EQUAL";
                     hex = a914aa699b8a020963891b975a3a62e4b0d8b12b39af87;
                     reqSigs = 1;
                     type = scripthash;
                 };
                 value = "0.001";
             }
         );
         vsize = 115;
         weight = 460;
     };
     unknown =     {
     };
 }
 */
