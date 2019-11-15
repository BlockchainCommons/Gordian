//
//  RunAppleScript.swift
//  StandUp
//
//  Created by Peter on 13/11/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

class RunAppleScript {
    
    var errorBool = Bool()
    var errorDescription = ""
    var stringToReturn = ""
    
    func runScript(script: SCRIPT, completion: @escaping () -> Void) {
        
        let appleScript = NSAppleScript(source: script.rawValue)!
        var errorDict:NSDictionary?
        
        if let result = appleScript.executeAndReturnError(&errorDict).stringValue {
            
            if errorDict != nil {
                
                errorBool = true
                errorDescription = errorDict!["NSAppleScriptErrorBriefMessage"] as? String ?? "unknown error"
                completion()
                
            } else {
                
                stringToReturn = result
                completion()
                
            }
            
        } else {
            
            errorBool = true
            errorDescription = "unable to parse script result"
            completion()
            
        }
        
    }
    
}
