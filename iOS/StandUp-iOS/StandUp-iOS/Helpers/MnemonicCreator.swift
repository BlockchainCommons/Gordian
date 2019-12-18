//
//  MnemonicCreator.swift
//  BitSense
//
//  Created by Peter on 03/12/19.
//  Copyright © 2019 Fontaine. All rights reserved.
//

import Foundation

class MnemonicCreator {
    
    func convert(words: String, completion: @escaping ((mnemonic: BTCMnemonic?, error: Bool)) -> Void) {
        
        let wordArray = words.split(separator: " ")
            
        if let mnemonic = BTCMnemonic.init(words: wordArray, password: "", wordListType: .english) {
            
            completion((mnemonic,false))
            
        } else {
                
            completion((nil,true))
            
        }
        
    }
    
}
