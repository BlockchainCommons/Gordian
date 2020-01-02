//
//  QuickConnect.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import UIKit

class QuickConnect {
    
    let aes = AESService()
    let cd = CoreDataService()
    var errorBool = Bool()
    var errorDescription = ""
    
    // MARK: QuickConnect url examples
    // btcstandup://rpcuser:rpcpassword@uhqefiu873h827h3ufnjecnkajbciw7bui3hbuf233b.onion:1309/?label=Node%20Name
    // btcstandup://rpcuser:rpcpassword@uhqefiu873h827h3ufnjecnkajbciw7bui3hbuf233b.onion:1309/?
    // btcstandup://rpcuser:rpcpassword@uhqefiu873h827h3ufnjecnkajbciw7bui3hbuf233b.onion:1309?
    
    func addNode(vc: UIViewController, url: String, authkey: String, authPubKey: String, completion: @escaping () -> Void) {
        
        cd.retrieveEntity(entityName: .nodes) {
            
            if !self.cd.errorBool {
                
                var host = ""
                var rpcPassword = ""
                var rpcUser = ""
                var label = "StandUp"
                
                if let params = URLComponents(string: url)?.queryItems {
                    
                    if let hostCheck = URLComponents(string: url)?.host {
                        
                        host = hostCheck
                        
                    }
                    
                    if let portCheck = URLComponents(string: url)?.port {
                        
                        host += ":" + String(portCheck)
                        
                    }
                    
                    if let rpcPasswordCheck = URLComponents(string: url)?.password {
                        
                        rpcPassword = rpcPasswordCheck
                        
                    }
                    
                    if let rpcUserCheck = URLComponents(string: url)?.user {
                        
                        rpcUser = rpcUserCheck
                        
                    }
                    
                    if rpcUser == "" && rpcPassword == "" {
                        
                        if params.count == 2 {
                            
                            rpcUser = (params[0].description).replacingOccurrences(of: "user=", with: "")
                            rpcPassword = (params[1].description).replacingOccurrences(of: "password=", with: "")
                            
                            if rpcPassword.contains("?label=") {
                                
                                let arr = rpcPassword.components(separatedBy: "?label=")
                                rpcPassword = arr[0]
                                
                                if arr.count > 1 {
                                    
                                    label = arr[1]
                                    
                                }
                                
                            }
                            
                        }
                        
                    } else {
                        
                        let url = URL(string: url)
                        
                        if let labelCheck = url?.value(for: "label") {
                            
                            label = labelCheck
                            
                        }
                        
                    }
                    
                } else {
                    
                    self.errorBool = true
                    completion()
                    
                }
                
                guard host != "", rpcUser != "", rpcPassword != "", authkey != "" else {
                    self.errorBool = true
                    completion()
                    return
                }
                                
                var node = [String:Any]()
                let torNodeHost = self.aes.encryptKey(keyToEncrypt: host)
                let torNodeRPCPass = self.aes.encryptKey(keyToEncrypt: rpcPassword)
                let torNodeRPCUser = self.aes.encryptKey(keyToEncrypt: rpcUser)
                let torNodeLabel = self.aes.encryptKey(keyToEncrypt: label)
                let encauthkey = self.aes.encryptKey(keyToEncrypt: authkey)
                let encpubkey = self.aes.encryptKey(keyToEncrypt: authPubKey)
                
                node["onionAddress"] = torNodeHost
                node["label"] = torNodeLabel
                node["rpcuser"] = torNodeRPCUser
                node["rpcpassword"] = torNodeRPCPass
                node["authKey"] = encauthkey
                node["authPubKey"] = encpubkey
                                
                self.cd.saveEntity(dict: node, entityName: .nodes) {
                    
                    if !self.cd.errorBool {
                        
                        let success = self.cd.boolToReturn
                        
                        if success {
                            
                            print("standup node added")
                            self.errorBool = false
                            completion()
                            
                        } else {
                            
                            self.errorBool = true
                            self.errorDescription = "Error adding QuickConnect node"
                            completion()
                            
                        }
                        
                    } else {
                        
                        self.errorBool = true
                        self.errorDescription = self.cd.errorDescription
                        completion()
                        
                    }
                    
                }
                
            } else {
                
                self.errorBool = true
                self.errorDescription = "Error adding getting nodes from core data"
                completion()
                
            }
            
        }
        
    }
    
}

extension URL {
    
    func value(for paramater: String) -> String? {
        
        let queryItems = URLComponents(string: self.absoluteString)?.queryItems
        let queryItem = queryItems?.filter({$0.name == paramater}).first
        let value = queryItem?.value
        return value
    }
    
}
