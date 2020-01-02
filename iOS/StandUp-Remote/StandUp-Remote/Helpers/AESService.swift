//
//  AESService.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import CryptoSwift
import KeychainSwift

class AESService {
    
    let keychain = KeychainSwift()
    
    func decryptKey(keyToDecrypt:String) -> String {
        print("decryptKey start")
        
        var stringtoReturn = ""
        
        if let pw = keychain.get("AESKey") {
            
            do {
                
                let aes = try AES(key: pw, iv: "drowssapdrowssap")
                let decrypted = try aes.decrypt(Array<UInt8>(hex: keyToDecrypt))
                stringtoReturn = String(data: Data(decrypted), encoding: .utf8)!
                print("decryptKey finish")
                
            } catch {
                
                print("error decrypting")
                
            }
            
        } else {
            
            print("error getting AESPassword from keychain")
            
        }
        
        return stringtoReturn
        
    }
    
    func encryptKey(keyToEncrypt: String) -> String {
        print("encryptKey start")
        
        var stringtoReturn = ""
        
        if let pw = keychain.get("AESKey") {
            
            do {
                
                let aes = try AES(key: pw, iv: "drowssapdrowssap")
                let encrypted = try aes.encrypt(Array<UInt8>(keyToEncrypt.utf8))
                stringtoReturn = encrypted.toHexString()
                print("encryptKey finished")
                
            } catch {
                
                print("error decrypting")
                
            }
            
        } else {
            
            print("error getting AESPassword from keychain")
            
        }
        
        return stringtoReturn
        
    }
    
}
