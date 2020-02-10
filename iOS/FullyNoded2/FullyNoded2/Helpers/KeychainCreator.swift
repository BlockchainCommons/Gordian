//
//  KeychainCreator.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import LibWally

class KeychainCreator {
    
    func createKeyChain(completion: @escaping ((mnemonic: String?, error: Bool)) -> Void) {
        
        let bytesCount = 16//24
        var randomBytes = [UInt8](repeating: 0, count: bytesCount)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytesCount, &randomBytes)
        
        if status == errSecSuccess {
            
            let data = Data(randomBytes)
            let hex = data.hexString
            
            if let entropy = BIP39Entropy(hex) {
                
                if let mnemonic = BIP39Mnemonic.init(entropy) {
                    
                    var words = (mnemonic.words.description).replacingOccurrences(of: "\"", with: "")
                    words = words.replacingOccurrences(of: ",", with: "")
                    words = words.replacingOccurrences(of: "[", with: "")
                    words = words.replacingOccurrences(of: "]", with: "")
                    completion((words,false))
                    
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
