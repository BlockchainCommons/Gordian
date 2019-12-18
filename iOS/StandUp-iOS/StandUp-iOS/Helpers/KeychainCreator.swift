//
//  KeychainCreator.swift
//  BitSense
//
//  Created by Peter on 03/12/19.
//  Copyright © 2019 Fontaine. All rights reserved.
//

import Foundation

class KeychainCreator {
    
    func createKeyChain(completion: @escaping ((mnemonic: String, error: Bool)) -> Void) {
        
        let bytesCount = 32
        var randomBytes = [UInt8](repeating: 0, count: bytesCount)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytesCount, &randomBytes)
        
        if status == errSecSuccess {
            
            let data = Data(randomBytes)
            let sha256OfData = BTCSHA256(data) as Data
            
            if let m = BTCMnemonic.init(entropy: sha256OfData, password: "", wordListType: .english) {
                
                let words = m.words.description
                let formatMnemonic1 = words.replacingOccurrences(of: "[", with: "")
                let formatMnemonic2 = formatMnemonic1.replacingOccurrences(of: "]", with: "")
                
                // MARK: Hard coding a recovery phrase for testing purposes only, simply uncomment the below mnemonic and comment out the test mnemonic to use on mainnet
                //let mnemonic = formatMnemonic2.replacingOccurrences(of: ",", with: "")
                let mnemonic = "decide insect sign cover bicycle other chief what industry bomb lobster lonely piece toss practice"
                completion((mnemonic,false))
                
            } else {
                
                completion(("",true))
                
            }
            
        } else {
            
            completion(("",true))
            
        }
                
    }
    
}
