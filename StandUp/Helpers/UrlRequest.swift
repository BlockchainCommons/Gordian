//
//  UrlRequest.swift
//  StandUp
//
//  Created by Peter on 19/11/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

class MakeRequest {
        
    func getRequest(completion: @escaping ((version:String?, error:String?)) -> Void) {
        
        let url_base = "https://api.github.com/repos/Fonta1n3/Bitcoin-Standup/contents/StandUp/SupportedVersion"
        guard let destination = URL(string: url_base) else { return }
        let request = URLRequest(url: destination)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                
                print("response = \(response)")
                                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    if error != nil {
                        
                        completion((version:"", error:"\(error as Any)"))
                        
                    } else {
                        
                        if let encodedContent = json["content"] as? String {
                            
                            let processedContent = encodedContent.replacingOccurrences(of: "\n", with: "")
                            
                            if let decodedData = Data(base64Encoded: processedContent) {
                                
                                if let decodedString = String(data: decodedData, encoding: .utf8) {
                                    
                                    let version = decodedString.replacingOccurrences(of: "### Bitcoin Core\n", with: "")
                                    completion((version:version, error:""))
                                    
                                } else {
                                    
                                    completion((version:"", error:"error decoding string"))
                                    
                                }
                                
                            } else {
                                
                                completion((version:"", error:"error decoding data"))
                                
                            }
                            
                        } else {
                            
                            completion((version:"", error:"error getting content"))
                            
                        }
                        
                        
                    }
                    
                } catch {
                    
                    print(error)
                    completion((version:"", error:"\(error as Any)"))
                }
                
            } else {
                
                completion((version:"", error:"\(String(describing: error))"))
                
            }
            
        }
        
        task.resume()
        
    }
        
}
