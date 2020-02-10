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
    var wallet:WalletStruct!
    
    func create(completion: @escaping () -> Void) {
        
        func sign(unsignedTx: String) {
            
            if self.wallet.derivation.contains("84") {
                
                let signer = OfflineSigner()
                signer.signTransactionOffline(unsignedTx: unsignedTx) { (signedTx) in
                    
                    if signedTx != nil {
                     
                        self.signedRawTx = signedTx!
                        completion()
                        
                    }
                    
                }
                
            } else if self.wallet.derivation.contains("44") {
                
                let signer = OfflineSignerLegacy()
                signer.signTransactionOffline(unsignedTx: unsignedTx) { (signedTx) in
                    
                    if signedTx != nil {
                     
                        self.signedRawTx = signedTx!
                        completion()
                        
                    }
                    
                }
                
            } else if self.wallet.derivation.contains("49") {
                
                let signer = OfflineSignerP2SHSegwit()
                signer.signTransactionOffline(unsignedTx: unsignedTx) { (signedTx) in
                    
                    if signedTx != nil {
                     
                        self.signedRawTx = signedTx!
                        completion()
                        
                    }
                    
                }
                
            }
            
        }
        
        func executeNodeCommand(method: BTC_CLI_COMMAND, param: String) {
            
            let reducer = Reducer()
            
            func getResult() {
                
                if !reducer.errorBool {
                    
                    switch method {
                        
                    case .walletcreatefundedpsbt:

                        print("walletcreatefundedpsbt")
                        let result = reducer.dictToReturn
                        let psbt = result["psbt"] as? String ?? "error getting psbt"
                        sign(unsignedTx: psbt)
                        
                    default:
                        
                        break
                        
                    }
                    
                } else {
                    
                    errorBool = true
                    errorDescription = reducer.errorDescription
                    completion()
                    
                }
                
            }
            
            reducer.makeCommand(walletName: self.wallet.name, command: method,
                                param: param,
                                completion: getResult)
            
        }
        
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                self.wallet = wallet!
                
                let feeTarget = UserDefaults.standard.object(forKey: "feeTarget") as? Int ?? 432
                var changeType = ""
                
                if wallet!.derivation.contains("84") {
                    
                    changeType = "bech32"
                    
                } else if wallet!.derivation.contains("44") {
                    
                    changeType = "legacy"
                    
                } else if wallet!.derivation.contains("49") {
                    
                    changeType = "p2sh-segwit"
                    
                }
                
                let param = "''[]'', ''{\(self.outputs)}'', 0, ''{\"includeWatching\": true, \"replaceable\": true, \"conf_target\": \(feeTarget), \"change_type\": \"\(changeType)\" }'', true"
                
                executeNodeCommand(method: .walletcreatefundedpsbt,
                                   param: param)
                
            }
            
        }
        
    }
    
}
