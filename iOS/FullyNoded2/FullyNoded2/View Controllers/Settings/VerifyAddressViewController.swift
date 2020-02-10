//
//  VerifyAddressViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 27/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class VerifyAddressViewController: UIViewController {
    
    var address = ""
    let qrScanner = QRScanner()
    let imageView = UIImageView()
    let connectingView = ConnectingView()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    override func viewDidLoad() {
        super.viewDidLoad()

        addBackground()
        addImageView()
        connectingView.addConnectingView(vc: self, description: "")
        configureScanner()
        scanNow()
        
    }
    
    func addBackground() {
        
        backgroundView.frame = self.view.frame
        self.view.addSubview(backgroundView)
        
    }
    
    func addImageView() {
        
        imageView.alpha = 1
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        backgroundView.contentView.addSubview(imageView)
        
    }
    
    func configureScanner() {
        
        imageView.isUserInteractionEnabled = true
        qrScanner.keepRunning = false
        qrScanner.vc = self
        qrScanner.imageView = imageView
        qrScanner.completion = { self.getQRCode() }
        
    }
    
    func scanNow() {
        print("scanNow")
        
        DispatchQueue.main.async {
            
            self.connectingView.removeConnectingView()
            self.qrScanner.scanQRCode()
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.imageView.alpha = 1
                
            })
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.imageView.alpha = 1
                
            }) { (_) in
                
                showAlert(vc: self, title: "Don't trust, verify.", message: "The purpose of this tool is to allow you to verify that the app derives the exact addresses and keys that you expect it to.\n\nYou can use a third party offline tool to import your BIP39 recovery phrase and derive your addresses.\n\nCreate a QR code with one of the derived addresses, scan it with this tool to ensure they match.\n\nJust swipe the scanner down to close it.")
                
            }
            
        }
        
    }
    
    func getQRCode() {
        
        let scannedAddress = qrScanner.stringToReturn
        verifyAddresses(scannedAddress: scannedAddress)
        
    }
    
    func verifyAddresses(scannedAddress: String) {
        
        if self.address == scannedAddress {
            
            showAlert(vc: self, title: "✅ Verified", message: "Addresses verified to be identical ✓")
            
        } else {
            
            showAlert(vc: self, title: "⚠️ Rejected", message: "Addresses do not match!\n\nDo NOT proceed until you figure out why the derived addresses do not match what you expect!")
            
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
