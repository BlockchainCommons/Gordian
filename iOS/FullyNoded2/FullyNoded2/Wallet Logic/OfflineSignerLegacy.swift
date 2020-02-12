//
//  OfflineSignerLegacy.swift
//  StandUp-Remote
//
//  Created by Peter on 29/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation
import LibWally

class OfflineSignerLegacy {
    
    func signTransactionOffline(unsignedTx: String, completion: @escaping ((String?)) -> Void) {
        
        var inputsToSign = [TxInput]()
        var outputsToSend = [TxOutput]()
        var inputMetaDataArray = [NSDictionary]()
        var privKeys = [HDKey]()
        
        getActiveWalletNow { (wallet, error) in
            
            if !error && wallet != nil {
                
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
                print("parseTx")
                
                let vins = tx["vin"] as! NSArray
                let vouts = tx["vout"] as! NSArray
                parseVouts(vouts: vouts, vins: vins)
                
            }
            
            func parseVins(vins: NSArray) {
                
                for (i, input) in vins.enumerated() {
                    
                    let vinDict = input as! NSDictionary
                    let txid = vinDict["txid"] as! String
                    let voutInt = UInt32(vinDict["vout"] as! Int)
                    let non_witness_utxo = inputMetaDataArray[i]["non_witness_utxo"] as! NSDictionary
                    let utxoVouts = non_witness_utxo["vout"] as! NSArray
                    
                    for vout in utxoVouts {
                        
                        let dict = vout as! NSDictionary
                        let n = UInt32(dict["n"] as! Int)
                        
                        if n == voutInt {
                            
                            let value = UInt64((dict["value"] as! Double) * 100000000)
                            let bip32derivs = inputMetaDataArray[i]["bip32_derivs"] as! NSArray
                            let bip32derivsDict = bip32derivs[0] as! NSDictionary
                            let path = bip32derivsDict["path"] as! String
                            let index = Int(path.split(separator: "/")[1])!
                            let pubkeyString = bip32derivsDict["pubkey"] as! String
                            let pubkeyData = Data.init(pubkeyString)!
                            let pubkey = PubKey.init(pubkeyData, .testnet)!
                            let scriptsig = ScriptSig.init(.payToPubKeyHash(pubkey))
                            let scriptPubKey = dict["scriptPubKey"] as! NSDictionary
                            let scriptPubKeyHex = scriptPubKey["hex"] as! String
                            let scriptPubKeyToSign = ScriptPubKey.init(scriptPubKeyHex)!
                            
                            let keyfetcher = KeyFetcher()
                            keyfetcher.key(index: index) { (key, error) in
                                
                                if !error {
                                    
                                    //getActiveWallet { (wallet) in
                                        
                                        //if wallet != nil {
                                            
                                            let input = TxInput(Transaction(txid)!, voutInt, value, scriptsig, nil, scriptPubKeyToSign)!
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

    // MARK: LEGACY SINGLE SIGNATURE DECODED PSBT

    /*
     
     {
         fee = "2.26e-06";
         inputs =     (
                     {
                 "bip32_derivs" =             (
                                     {
                         "master_fingerprint" = e763fbd7;
                         path = "m/0";
                         pubkey = 03aa8dbb301be63cc6fd9c5ec747c5e07d09b458827ab9a0df12fcb94547910746;
                     }
                 );
                 "non_witness_utxo" =             {
                     hash = 9d0379967a3b2186767a123286dd0b117dcad19d8172dfbea6643e9cf5a7e1bc;
                     locktime = 1664255;
                     size = 140;
                     txid = 9d0379967a3b2186767a123286dd0b117dcad19d8172dfbea6643e9cf5a7e1bc;
                     version = 2;
                     vin =                 (
                                             {
                             scriptSig =                         {
                                 asm = 0014e358c7358a7991e2eea3d53465fd27de9af7598b;
                                 hex = 160014e358c7358a7991e2eea3d53465fd27de9af7598b;
                             };
                             sequence = 4294967294;
                             txid = 733845ca0b79871068683acb130b9a88ccc3069eb09b6138c22c6e3720021eac;
                             vout = 0;
                         }
                     );
                     vout =                 (
                                             {
                             n = 0;
                             scriptPubKey =                         {
                                 addresses =                             (
                                     mx5M2pUqKWeQw44RcpMUj35omuMkZpqask
                                 );
                                 asm = "OP_DUP OP_HASH160 b5a24db172c03c7877b651f98e6f3e0e841d21ef OP_EQUALVERIFY OP_CHECKSIG";
                                 hex = 76a914b5a24db172c03c7877b651f98e6f3e0e841d21ef88ac;
                                 reqSigs = 1;
                                 type = pubkeyhash;
                             };
                             value = "0.01";
                         },
                                             {
                             n = 1;
                             scriptPubKey =                         {
                                 addresses =                             (
                                     2MtJj5xLY4atWdUMscbzjBAzGAiBXSRjqhj
                                 );
                                 asm = "OP_HASH160 0ba1a9cbf645e982e3d4f4aa9abd612e3314ca94 OP_EQUAL";
                                 hex = a9140ba1a9cbf645e982e3d4f4aa9abd612e3314ca9487;
                                 reqSigs = 1;
                                 type = scripthash;
                             };
                             value = "0.02199666";
                         }
                     );
                     vsize = 140;
                     weight = 560;
                 };
             }
         );
         outputs =     (
                     {
                 "bip32_derivs" =             (
                                     {
                         "master_fingerprint" = e763fbd7;
                         path = "m/1000";
                         pubkey = 026715bc3fe4e4ef99fd3efef995d0a36b04e20fb89cb55c0c5267f3feb1d4ea94;
                     }
                 );
             },
                     {
                 "bip32_derivs" =             (
                                     {
                         "master_fingerprint" = e763fbd7;
                         path = "m/1";
                         pubkey = 02a4a7298cc79b79f184e9804e29b0269fdd8b779475cfec326c86b71cbc199b4c;
                     }
                 );
             }
         );
         tx =     {
             hash = 8b6334488360150a5783cae35837d0efdf98e4c3063318139bca42394f848c12;
             locktime = 0;
             size = 119;
             txid = 8b6334488360150a5783cae35837d0efdf98e4c3063318139bca42394f848c12;
             version = 2;
             vin =         (
                             {
                     scriptSig =                 {
                         asm = "";
                         hex = "";
                     };
                     sequence = 4294967293;
                     txid = 9d0379967a3b2186767a123286dd0b117dcad19d8172dfbea6643e9cf5a7e1bc;
                     vout = 0;
                 }
             );
             vout =         (
                             {
                     n = 0;
                     scriptPubKey =                 {
                         addresses =                     (
                             mg1biJzQKDUBXJjyYDDqEuF9jaUG3319xc
                         );
                         asm = "OP_DUP OP_HASH160 056ae1d0a7d2c72fee1834b5470e6dcfa2852f37 OP_EQUALVERIFY OP_CHECKSIG";
                         hex = 76a914056ae1d0a7d2c72fee1834b5470e6dcfa2852f3788ac;
                         reqSigs = 1;
                         type = pubkeyhash;
                     };
                     value = "0.00969774";
                 },
                             {
                     n = 1;
                     scriptPubKey =                 {
                         addresses =                     (
                             mv2GQ8vE2gNJ6VKZ8TJzNrK76VUDhAaHeX
                         );
                         asm = "OP_DUP OP_HASH160 9f1cefe340a7c2acffc13a08db39ce1eb4b1987e OP_EQUALVERIFY OP_CHECKSIG";
                         hex = 76a9149f1cefe340a7c2acffc13a08db39ce1eb4b1987e88ac;
                         reqSigs = 1;
                         type = pubkeyhash;
                     };
                     value = "0.0003";
                 }
             );
             vsize = 119;
             weight = 476;
         };
         unknown =     {
         };
     }
     */
