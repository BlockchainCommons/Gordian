//
//  CreateMultiSigViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 15/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class CreateMultiSigViewController: UIViewController {
    
    var onDoneBlock1 : ((Bool) -> Void)?
    @IBOutlet var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createButton.clipsToBounds = true
        createButton.layer.cornerRadius = 10
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {

        

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {

        self.dismiss(animated: false, completion: nil)

    }
    
    @IBAction func createAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "recoveryKey", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch segue.identifier {
            
        case "recoveryKey":
            
            if let vc = segue.destination as? RecoveryViewController {
                
                vc.onDoneBlock2 = { result in
                    
                    DispatchQueue.main.async {
                        
                        self.view.alpha = 0
                        self.onDoneBlock1!(true)
                        self.dismiss(animated: false, completion: nil)
                        
                    }
                    
                }
                
            }
            
        default:
            
            break
            
        }
        
    }

}
