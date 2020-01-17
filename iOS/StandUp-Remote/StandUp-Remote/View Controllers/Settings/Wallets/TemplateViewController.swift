//
//  TemplateViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 14/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class TemplateViewController: UIViewController {

    @IBOutlet var switchOutlet: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchAction(_ sender: Any) {
        
        if switchOutlet.selectedSegmentIndex == 1 {
            
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "createMultisig", sender: self)
                
            }
            
        }
        
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
