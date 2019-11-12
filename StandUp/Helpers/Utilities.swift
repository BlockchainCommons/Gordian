//
//  Utilities.swift
//  StandUp
//
//  Created by Peter on 10/11/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

public func randomString(length: Int) -> String {
    
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
    
}
