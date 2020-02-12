//
//  TableDetailViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 04/02/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class TableDetailViewController: UIViewController {
    
    var textToShow = ""
    @IBOutlet var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = textToShow
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
