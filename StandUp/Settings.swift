//
//  Settings.swift
//  StandUp
//
//  Created by Peter on 08/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Cocoa

class Settings: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.dismiss(self)
            
        }
        
    }
    
    
}
