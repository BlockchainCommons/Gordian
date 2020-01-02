//
//  KeyFetcher.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import LibWally

class KeyFetcher {
    
    func privKey(index: Int, completion: @escaping ((privKey: String?, error: Bool)) -> Void) {
        
        let cd = CoreDataService()
        cd.retrieveSeed { (encSeed, error) in
            
            if !error {
                
                let enc = Encryption()
                enc.decrypt(data: encSeed!) { (words, error) in
                    
                    if !error {
                        
                        let mnenomicCreator = MnemonicCreator()
                        
                        mnenomicCreator.convert(words: words) { (mnemonic, error) in
                            
                            if !error {
                                
                                if let masterKey = HDKey((mnemonic!.seedHex("")), .testnet) {
                                    
                                    if let path = BIP32Path("m/84'/1'/0'/0") {
                                        
                                        do {
                                            
                                            let account = try masterKey.derive(path)
                                            
                                            if let childPath = BIP32Path("\(index)") {
                                                
                                                do {
                                                    
                                                    let key = try account.derive(childPath)
                                                    
                                                    if let keyToReturn = key.privKey {
                                                        
                                                        let wif = keyToReturn.wif
                                                        print("private key = \(wif)")
                                                        completion((wif,false))
                                                        
                                                    } else {
                                                        
                                                        completion((nil,true))
                                                        
                                                    }
                                                    
                                                } catch {
                                                    
                                                    completion((nil,true))
                                                    
                                                }
                                                
                                            }
                                            
                                        } catch {
                                            
                                            completion((nil,true))
                                            
                                        }
                                        
                                    } else {
                                        
                                        completion((nil,true))
                                        
                                    }
                                    
                                } else {
                                    
                                    completion((nil,true))
                                    
                                }
                                
                            } else {
                                
                                completion((nil,true))
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func bip32Xpub(completion: @escaping ((xpub: String?, error: Bool)) -> Void) {
        
        let cd = CoreDataService()
        cd.retrieveSeed { (encSeed, error) in
            
            if !error {
                
                let enc = Encryption()
                enc.decrypt(data: encSeed!) { (words, error) in
                    
                    if !error {
                        
                        let mnenomicCreator = MnemonicCreator()
                        
                        mnenomicCreator.convert(words: words) { (mnemonic, error) in
                            
                            if !error {
                                
                                if let masterKey = HDKey((mnemonic!.seedHex("")), .testnet) {
                                    
                                    if let path = BIP32Path("m/84'/1'/0'/0") {
                                        
                                        do {
                                            
                                            let account = try masterKey.derive(path)
                                            let tpub = account.xpub
                                            print("tpub = \(tpub)")
                                            completion((tpub,false))
                                            
                                        } catch {
                                            
                                            completion((nil,true))
                                            
                                        }
                                        
                                    } else {
                                        
                                        completion((nil,true))
                                        
                                    }
                                    
                                } else {
                                    
                                    completion((nil,true))
                                    
                                }
                                
                            } else {
                                
                                completion((nil,true))
                                
                            }
                            
                        }
                        
                    } else {
                        
                        completion((nil,true))
                        
                    }
                    
                }
                
            } else {
                
                completion((nil,true))
                
            }
            
        }
        
    }
    
    func bip32Xprv(completion: @escaping ((xprv: String?, error: Bool)) -> Void) {
        
        let cd = CoreDataService()
        cd.retrieveSeed { (encSeed, error) in
            
            if !error {
                
                let enc = Encryption()
                enc.decrypt(data: encSeed!) { (words, error) in
                    
                    if !error {
                        
                        let mnenomicCreator = MnemonicCreator()
                        
                        mnenomicCreator.convert(words: words) { (mnemonic, error) in
                            
                            if !error {
                                
                                if let masterKey = HDKey((mnemonic!.seedHex("")), .testnet) {
                                    
                                    if let path = BIP32Path("m/84'/1'/0'/0") {
                                        
                                        do {
                                            
                                            let account = try masterKey.derive(path)
                                            
                                            if let tprv = account.xpriv {
                                                
                                                print("tprv = \(tprv)")
                                                completion((tprv,false))
                                                
                                            } else {
                                                
                                                completion((nil,true))
                                                
                                            }
                                            
                                        } catch {
                                            
                                            completion((nil,true))
                                            
                                        }
                                        
                                    } else {
                                        
                                        completion((nil,true))
                                        
                                    }
                                    
                                } else {
                                    
                                    completion((nil,true))
                                    
                                }
                                
                            } else {
                                
                                completion((nil,true))
                                
                            }
                            
                        }
                        
                    } else {
                        
                        completion((nil,true))
                        
                    }
                    
                }
                
            } else {
                
                completion((nil,true))
                
            }
            
        }
        
    }
    
}
