//
//  WalletStruct.swift
//  StandUp-Remote
//
//  Created by Peter on 09/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation

public struct WalletStruct: CustomStringConvertible {
    
    let birthdate:Int32
    let derivation:String
    let id:UUID
    let identity:Data
    let isActive:Bool
    let seed:Data
    let name:String
    let type:String
    let keys:String
    let descriptor:String
    let index:Int
    let lastUsed:Date
    let lastBalance:Double
    let nodeId:UUID
    let walletCreated:Bool
    let keysImported:Bool
    let isArchived:Bool
    
    init(dictionary: [String: Any]) {
        
        self.birthdate = dictionary["birthdate"] as? Int32 ?? 0
        self.derivation = dictionary["derivation"] as? String ?? ""
        self.id = dictionary["id"] as! UUID
        self.identity = dictionary["identity"] as? Data ?? "no identity yet".data(using: .utf8)!
        self.isActive = dictionary["isActive"] as? Bool ?? false
        self.name = dictionary["name"] as? String ?? ""
        self.seed = dictionary["seed"] as? Data ?? "no seed".data(using: .utf8)!
        self.type = dictionary["type"] as? String ?? "DEFAULT"
        self.keys = dictionary["keys"] as? String ?? ""
        self.descriptor = dictionary["descriptor"] as? String ?? ""
        self.index = dictionary["index"] as? Int ?? 0
        self.lastUsed = dictionary["lastUsed"] as? Date ?? Date()
        self.lastBalance = dictionary["lastBalance"] as? Double ?? 0.0
        self.nodeId = dictionary["nodeId"] as? UUID ?? UUID()
        self.walletCreated = dictionary["walletCreated"] as? Bool ?? false
        self.keysImported = dictionary["keysImported"] as? Bool ?? false
        self.isArchived = dictionary["isArchived"] as? Bool ?? false
        
    }
    
    public var description: String {
        return ""
    }
    
}
