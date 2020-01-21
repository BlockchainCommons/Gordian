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
    
    let enc = Encryption()
    
    func privKey(index: Int, completion: @escaping ((privKey: String?, error: Bool)) -> Void) {
        
        let enc = Encryption()
        enc.getSeed() { (words, derivationPath, error) in

            if !error {

                let mnenomicCreator = MnemonicCreator()
                
                mnenomicCreator.convert(words: words) { (mnemonic, error) in
                    
                    if !error {
                        
                        if let masterKey = HDKey((mnemonic!.seedHex("")), self.network(path: derivationPath)) {
                            
                            if let path = BIP32Path(derivationPath) {
                                
                                do {
                                    
                                    let account = try masterKey.derive(path)
                                    
                                    if let childPath = BIP32Path("\(index)") {
                                        
                                        do {
                                            
                                            let key = try account.derive(childPath)
                                            
                                            if let keyToReturn = key.privKey {
                                                
                                                let wif = keyToReturn.wif
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
    
    func bip32Xpub(completion: @escaping ((xpub: String?, error: Bool)) -> Void) {
        
        let enc = Encryption()
        enc.getSeed() { (words, derivationPath, error) in
            
            if !error {
                
                let mnenomicCreator = MnemonicCreator()
                mnenomicCreator.convert(words: words) { (mnemonic, error) in
                    
                    if !error {
                        
                        if let masterKey = HDKey((mnemonic!.seedHex("")), self.network(path: derivationPath)) {
                            
                            if let path = BIP32Path(derivationPath) {
                                
                                do {
                                    
                                    let account = try masterKey.derive(path)
                                    completion((account.xpub,false))
                                    
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
        
    }
    
    func bip32Xprv(completion: @escaping ((xprv: String?, error: Bool)) -> Void) {
        
        let enc = Encryption()
        enc.getSeed() { (words, derivationPath, error) in
            
            if !error {
                
                let mnenomicCreator = MnemonicCreator()
                
                mnenomicCreator.convert(words: words) { (mnemonic, error) in
                    
                    if !error {
                        
                        if let masterKey = HDKey((mnemonic!.seedHex("")), self.network(path: derivationPath)) {
                            
                            if let path = BIP32Path(derivationPath) {
                                
                                do {
                                    
                                    let account = try masterKey.derive(path)
                                    
                                    if let xprv = account.xpriv {
                                        
                                        completion((xprv,false))
                                        
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
        
    }
    
    func musigAddress(completion: @escaping ((address: String?, error: Bool)) -> Void) {
        
        getActiveWallet { (wallet) in
            
            if wallet != nil {
                
                let reducer = Reducer()
                let index = wallet!.index + 1
                let param = "\"\(wallet!.descriptor)\", [\(index),\(index)]"
                
                reducer.makeCommand(command: .deriveaddresses, param: param) {
                    
                    if !reducer.errorBool {
                        
                        self.updateIndex(wallet: wallet!)
                        let address = reducer.arrayToReturn[0] as! String
                        completion((address,false))
                        
                    } else {
                        
                        print("error deriving addresses: \(reducer.errorDescription)")
                        completion((nil,true))
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func musigChangeAddress(completion: @escaping ((address: String?, error: Bool)) -> Void) {
        
        getActiveWallet { (wallet) in
            
            if wallet != nil {
                
                let reducer = Reducer()
                let index = wallet!.index + 1000
                
                if wallet!.index < 1000 {
                    
                    let param = "\"\(wallet!.descriptor)\", [\(index),\(index)]"
                    
                    reducer.makeCommand(command: .deriveaddresses, param: param) {
                        
                        if !reducer.errorBool {
                            
                            let address = reducer.arrayToReturn[0] as! String
                            completion((address,false))
                            
                        } else {
                            
                            print("error deriving addresses: \(reducer.errorDescription)")
                            completion((nil,true))
                            
                        }
                        
                    }
                    
                } else {
                    
                    print("error, need to import more keys")
                    
                }
                
            }
            
        }
        
    }
    
    private func updateIndex(wallet: WalletStruct) {
        
        let cd = CoreDataService()
        cd.updateEntity(id: wallet.id, keyToUpdate: "index", newValue: wallet.index + 1, entityName: .wallets) {
            
            if !cd.errorBool {
                
                
            } else {
                
                print("error updating index: \(cd.errorDescription)")
                
            }
            
        }
        
    }
    
    private func network(path: String) -> Network {
        
        var network:Network!
        
        if path.contains("/1'") {
            
            network = .testnet
            
        } else {
            
            network = .mainnet
            
        }
        
        return network
        
    }
    
}
