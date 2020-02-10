//
//  GetPrivateKeys.swift
//  StandUp-Remote
//
//  Created by Peter on 20/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation

class GetPrivateKeys {
    
    var index = Int()
    var indexarray = [Int]()
    
    func getKeys(addresses: [String], completion: @escaping (([String]?)) -> Void) {
        
        func getAddressInfo(addresses: [String]) {
            
            let reducer = Reducer()
            var privkeyarray = [String]()
            
            func getinfo() {
                
                if !reducer.errorBool {
                    
                    self.index += 1
                    let result = reducer.dictToReturn
                    
                    if let hdkeypath = result["hdkeypath"] as? String {
                        
                        let arr = hdkeypath.components(separatedBy: "/")
                        indexarray.append(Int(arr[1])!)
                        getAddressInfo(addresses: addresses)
                        
                    } else {
                        
                        if let desc = result["desc"] as? String {
                            
                            let arr = desc.components(separatedBy: "/")
                            let index = (arr[1].components(separatedBy: "]"))[0]
                            indexarray.append(Int(index)!)
                            getAddressInfo(addresses: addresses)
                            
                        }
                        
                    }
                        
                } else {
                    
                    print("error getting key path: \(reducer.errorDescription)")
                    completion(nil)
                    
                }
                
            }
            
            if addresses.count > self.index {
                
                getActiveWalletNow { (wallet, error) in
                    
                    if !error && wallet != nil {
                        
                        reducer.makeCommand(walletName: wallet!.name, command: .getaddressinfo, param: "\"\(addresses[self.index])\"", completion: getinfo)
                        
                    }
                    
                }
                
            } else {
                
                print("loop finished")
                // loop is finished get the private keys
                let keyfetcher = KeyFetcher()
                
                for (i, keypathint) in indexarray.enumerated() {
                    
                    let int = Int(keypathint)
                    
                    keyfetcher.privKey(index: int) { (privKey, error) in
                        
                        if !error {
                            
                            privkeyarray.append(privKey!)
                            
                            if i == self.indexarray.count - 1 {
                                
                                completion(privkeyarray)
                                
                            }
                            
                        } else {
                            
                            print("error getting private key")
                            completion(nil)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        getAddressInfo(addresses: addresses)
        
    }
    
}
