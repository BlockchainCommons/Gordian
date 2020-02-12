//
//  WalletSaver.swift
//  StandUp-Remote
//
//  Created by Peter on 09/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation
import KeychainSwift

class WalletSaver {
    
    let keychain = KeychainSwift()
    
    func save(walletToSave: [String:Any], completion: @escaping ((Bool)) -> Void) {
        
        let cd = CoreDataService()
        cd.retrieveEntity(entityName: .wallets) { (wallets, errorDescription) in
            
            if errorDescription == nil {
                
                cd.saveEntity(dict: walletToSave, entityName: .wallets) {
                    
                    if !cd.errorBool {
                        
                        print("saved wallet")
                        
                        if wallets!.count == 0 {
                            
                            let w = WalletStruct(dictionary: walletToSave)
                            
                            cd.updateEntity(id: w.id, keyToUpdate: "isActive", newValue: true, entityName: .wallets) {
                                
                                completion((true))
                                
                            }
                            
                        } else {
                            
                            completion((true))
                            
                        }
                        
                    } else {
                        
                        print("error saving wallet")
                        completion((false))
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
