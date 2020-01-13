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
    
    let ud = UserDefaults.standard
    let keychain = KeychainSwift()
    
    func save(walletToSave: [String:Any], completion: @escaping ((Bool)) -> Void) {
        
        let cd = CoreDataService()
        cd.retrieveEntity(entityName: .wallets) {
            
            let wallets = cd.entities
            
            if wallets.count > 0 {
                
                for (i, wallet) in wallets.enumerated() {
                    
                    let str = WalletStruct.init(dictionary: wallet)
                    
                    if str.isActive {
                        
                        cd.updateEntity(id: str.id, keyToUpdate: "isActive", newValue: false, entityName: .wallets) {
                            
                            if !cd.errorBool {
                                
                                print("deactived a wallet")
                                
                                cd.saveEntity(dict: walletToSave, entityName: .wallets) {
                                    
                                    if !cd.errorBool {
                                        
                                        print("saved wallet")
                                        completion((true))
                                        
                                    } else {
                                        
                                        print("error saving wallet")
                                        completion((false))
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                print("error deactivating a wallet")
                                completion((false))
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                cd.saveEntity(dict: walletToSave, entityName: .wallets) {
                    
                    if !cd.errorBool {
                        
                        print("saved wallet")
                        completion((true))
                        
                    } else {
                        
                        print("error saving wallet")
                        completion((false))
                        
                    }
                    
                }
                
            }
        
        }
        
    }
    
}
