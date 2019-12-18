//
//  NodeStruct.swift
//  BitSense
//
//  Created by Peter on 18/09/19.
//  Copyright © 2019 Fontaine. All rights reserved.
//

import Foundation


public struct NodeStruct: CustomStringConvertible {
    
    let label:String
    let onionAddress:String
    let rpcpassword:String
    let rpcuser:String
    let authKey:String
    let authPubKey:String
    
    init(dictionary: [String: Any]) {
        
        self.label = dictionary["label"] as? String ?? ""
        self.onionAddress = dictionary["onionAddress"] as? String ?? ""
        self.rpcpassword = dictionary["rpcpassword"] as? String ?? ""
        self.rpcuser = dictionary["rpcuser"] as? String ?? ""
        self.authKey = dictionary["authKey"] as? String ?? ""
        self.authPubKey = dictionary["authPubKey"] as? String ?? ""
        
    }
    
    public var description: String {
        return ""
    }
    
}

