//
//  MnemonicCreator.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import LibWally

class MnemonicCreator {
    
    func convert(words: String, completion: @escaping ((mnemonic: BIP39Mnemonic?, error: Bool)) -> Void) {
        
        let wordArray = words.split(separator: " ")
        var array = [String]()
        
        for word in wordArray {
            
            array.append(String(word))
            
        }
    
        if let mnemonic = BIP39Mnemonic(array) {
            
            completion((mnemonic,false))
            
        } else {
            
            completion((nil,true))
            
        }
        
    }
    
}
