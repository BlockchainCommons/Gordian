//
//  UrlRequest.swift
//  StandUp
//
//  Created by Peter on 19/11/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

class MakeRequest {
    
    var dictToReturn = NSDictionary()
    
    func getRequest(completion: @escaping () -> Void) {
        
        let url_base = "https://api.github.com/repos/Fonta1n3/Bitcoin-Standup/contents/SUPPORTED_VERSIONS.md"
        //https://api.github.com/repos/{owner}/{repo}
        //"https://api.github.com/repos/Fonta1n3/Bitcoin-Standup/contents/{+path}"
        // path = "README.md"
        
        guard let destination = URL(string: url_base) else { return }
        let request = URLRequest(url: destination)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                
                print("response = \(String(describing: response))")
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    if error != nil {
                        
                        print(error as Any)
                        completion()
                        
                    } else {
                        
                        self.dictToReturn = json
                        let encodedContent = (self.dictToReturn["content"] as! String).replacingOccurrences(of: "\n", with: "")
                        print("content = \(encodedContent)")
                        let decodedData = Data(base64Encoded: encodedContent)!
                        let decodedString = String(data: decodedData, encoding: .utf8)!
                        print("decodedString = \(decodedString)")
                        completion()
                        
                    }
                    
                } catch {
                    
                    print(error)
                    completion()
                }
                
            } else {
                
                print(error ?? "")
                completion()
                
            }
            
        }
        
        task.resume()
        print(url_base)
        
    }
        
}
