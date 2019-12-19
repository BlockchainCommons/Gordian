//
//  UrlRequest.swift
//  StandUp
//
//  Created by Peter on 19/11/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

class FetchJSON {
        
    func getRequest(completion: @escaping ((dict:NSDictionary?, error:String?)) -> Void) {
        
        let url = "https://api.github.com/repos/BlockchainCommons/Bitcoin-Standup/contents/StandUp/JSON/SupportedVersion.json"
        guard let destination = URL(string: url) else { return }
        let request = URLRequest(url: destination)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                                                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                        
                    if error != nil {
                        
                        completion((dict:["":""], error:"\(error as Any)"))
                        
                    } else {
                        
                        if let encodedContent = json["content"] as? String {
                            
                            let processedContent = encodedContent.replacingOccurrences(of: "\n", with: "")
                            
                            if let decodedData = Data(base64Encoded: processedContent) {
                                
                                let supportedVersionJSON = try JSONSerialization.jsonObject(with: decodedData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                
                                completion((dict:supportedVersionJSON, error:""))
                                
                                
                            } else {
                                
                                completion((dict:["":""], error:"error decoding data"))
                                
                            }
                            
                        } else {
                            
                            completion((dict:["":""], error:"error getting content"))
                            
                        }
                        
                    }
                    
                } catch {
                    
                    print(error)
                    completion((dict:["":""], error:"\(error as Any)"))
                }
                
            } else {
                
                completion((dict:["":""], error:"\(String(describing: error))"))
                
            }
            
        }
        
        task.resume()
        
    }
        
}
