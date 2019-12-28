//
//  KeyPad.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

class KeyPad: UIView {
    
    var buttonTapped = UIButton()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func sweep(_ sender: Any) {
        
        //print("sweep button clicked")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "buttonClickedNotification"), object: nil)

    }
    
    @IBOutlet weak var sweepButtonOutlet: UIButton!
    
}
