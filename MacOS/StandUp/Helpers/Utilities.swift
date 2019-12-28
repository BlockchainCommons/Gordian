//
//  Utilities.swift
//  StandUp
//
//  Created by Peter on 10/11/19.
//  Copyright © 2019 Blockchain Commons, LLC
//

import Foundation
import Cocoa

public func randomString(length: Int) -> String {
    
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
    
}

public func setSimpleAlert(message: String, info: String, buttonLabel: String) {
    
    DispatchQueue.main.async {
        
        let a = NSAlert()
        a.messageText = message
        a.informativeText = info
        a.addButton(withTitle: buttonLabel)
        a.runModal()
        
    }
    
}

public func actionAlert(message: String, info: String, result: @escaping (Bool) -> Void) {
    
    DispatchQueue.main.async {
        
        let a = NSAlert()
        a.messageText = message
        a.informativeText = info
        a.addButton(withTitle: "Yes")
        a.addButton(withTitle: "No")
        let response = a.runModal()
        
        if response == .alertFirstButtonReturn {
            
            result((true))
            
        } else {
            
            result((false))
            
        }
        
    }
    
}
