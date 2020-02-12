//
//  FiatConverter.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation

class FiatConverter {
    
    var torClient:TorClient!
    var fxRate = Double()
    var errorBool = Bool()
    
    func getFxRate(completion: @escaping () -> Void) {
        
        torClient = TorClient.sharedInstance
        
        var url:NSURL!
        url = NSURL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")
        
        let task = torClient.session.dataTask(with: url! as URL) { (data, response, error) -> Void in
            
            do {
                
                if error != nil {
                    
                    self.errorBool = true
                    completion()
                    
                } else {
                    
                    if let urlContent = data {
                        
                        do {
                            
                            let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                            
                            if let exchangeCheck = json["bpi"] as? NSDictionary {
                                
                                if let usdCheck = exchangeCheck["USD"] as? NSDictionary {
                                    
                                    if let rateCheck = usdCheck["rate_float"] as? Double {
                                        
                                        self.errorBool = false
                                        self.fxRate = rateCheck
                                        completion()
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        } catch {
                            
                            print("JSon processing failed")
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
}
