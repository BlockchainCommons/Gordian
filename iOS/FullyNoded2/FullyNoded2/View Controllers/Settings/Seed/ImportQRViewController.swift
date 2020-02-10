//
//  ImportQRViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 13/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class ImportQRViewController: UIViewController, UINavigationControllerDelegate {
    
    let qrScanner = QRScanner()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let connectingView = ConnectingView()
    var words = ""
    var derivation = ""
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.delegate = self
        configureScanner()
        scanNow()
        
    }
    
    func configureScanner() {
        
        imageView.alpha = 0
        imageView.frame = view.frame
        imageView.isUserInteractionEnabled = true
        
        qrScanner.keepRunning = false
        qrScanner.vc = self
        qrScanner.imageView = imageView
        qrScanner.completion = { self.getQRCode() }
        
    }
    
    func scanNow() {
        print("scanNow")
        
        DispatchQueue.main.async {
            
            self.qrScanner.scanQRCode()
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.imageView.alpha = 1
                
            })
            
        }
        
    }
    
    func getQRCode() {
        
        words = qrScanner.stringToReturn
        
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                self.derivation = wallet!.derivation
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "goVerify", sender: self)
                    
                }
                
            }
            
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "goVerify":
            
            if let vc = segue.destination as? VerifyKeysViewController {
                
                vc.derivation = derivation
                vc.comingFromSettings = false
                vc.words = words
                
            }
            
        default:
            
            break
            
        }
        
    }


}
