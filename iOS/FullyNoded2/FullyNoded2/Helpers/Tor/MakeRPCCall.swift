//
//  MakeRPCCall.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation

class MakeRPCCall {
    
    static let sharedInstance = MakeRPCCall()
    let torClient = TorClient.sharedInstance
    let ud = UserDefaults.standard
    var errorBool = Bool()
    var errorDescription = String()
    var objectToReturn:Any!
    var attempts = 0
    
    func executeRPCCommand(walletName: String, method: BTC_CLI_COMMAND, param: Any, completion: @escaping () -> Void) {
        print("executeTorRPCCommand")
        
        attempts += 1
        
        let enc = Encryption()
        enc.getNode { (node, error) in
            
            if !error {
                
                //getActiveWallet { (wallet) in
                
                //if wallet != nil {
                
                let onionAddress = node!.onionAddress
                let rpcusername = node!.rpcuser
                let rpcpassword = node!.rpcpassword
                //let walletName = wallet!.name
                
                let walletUrl = "http://\(rpcusername):\(rpcpassword)@\(onionAddress)/wallet/\(walletName)"
                print("walleturl = \(walletUrl)")
                
                // Have to escape ' characters for certain rpc commands
                var formattedParam = (param as! String).replacingOccurrences(of: "''", with: "")
                formattedParam = formattedParam.replacingOccurrences(of: "'\"'\"'", with: "'")
                
                guard let url = URL(string: walletUrl) else {
                    self.errorBool = true
                    self.errorDescription = "url error"
                    completion()
                    return
                }
                
                var request = URLRequest(url: url)
                request.timeoutInterval = 10
                request.httpMethod = "POST"
                request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
                request.httpBody = "{\"jsonrpc\":\"1.0\",\"id\":\"curltest\",\"method\":\"\(method)\",\"params\":[\(formattedParam)]}".data(using: .utf8)
                print("request = \("{\"jsonrpc\":\"1.0\",\"id\":\"curltest\",\"method\":\"\(method)\",\"params\":[\(formattedParam)]}")")
                
                let queue = DispatchQueue(label: "com.FullyNoded.torQueue")
                queue.async {
                    
                    let task = self.torClient.session.dataTask(with: request as URLRequest) { (data, response, error) in
                        
                        do {
                            
                            if error != nil {
                                
                                // attempt a node command 20 times to avoid user having to tap refresh button
                                if self.attempts < 20 {
                                    
//                                    if error!.localizedDescription.contains("The request timed out") && self.attempts == 2 {
//
//                                        self.errorBool = true
//                                        self.errorDescription = error!.localizedDescription
//                                        completion()
//
//                                    } else {
                                        
                                        self.executeRPCCommand(walletName: walletName, method: method, param: param, completion: completion)
                                        
                                    //}
                                    
                                } else {
                                    
                                    self.attempts = 0
                                    self.errorBool = true
                                    self.errorDescription = error!.localizedDescription
                                    completion()
                                    
                                }
                                
                            } else {
                                
                                self.attempts = 0
                                
                                if let urlContent = data {
                                    
                                    do {
                                        
                                        let jsonAddressResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                                        
                                        print("result = \(String(describing: jsonAddressResult["result"]))")
                                        
                                        if let errorCheck = jsonAddressResult["error"] as? NSDictionary {
                                            
                                            if let errorMessage = errorCheck["message"] as? String {
                                                
                                                self.errorDescription = errorMessage
                                                
                                            } else {
                                                
                                                self.errorDescription = "Uknown error"
                                                
                                            }
                                            
                                            self.errorBool = true
                                            completion()
                                            
                                            
                                        } else {
                                            
                                            self.errorBool = false
                                            self.errorDescription = ""
                                            self.objectToReturn = jsonAddressResult["result"]
                                            completion()
                                            
                                        }
                                        
                                    } catch {
                                        
                                        self.errorBool = true
                                        self.errorDescription = "Uknown Error"
                                        completion()
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    task.resume()
                    
                }
                
                //}
                
                //}
                
            } else {
                
                self.errorBool = true
                self.errorDescription = "error fetching node credentials"
                completion()
                
            }
            
        }
        
    }
    
    private init() {}
    
}
