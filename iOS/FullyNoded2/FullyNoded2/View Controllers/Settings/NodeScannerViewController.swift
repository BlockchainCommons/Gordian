//
//  NodeScannerViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 31/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class NodeScannerViewController: UIViewController, UINavigationControllerDelegate {
    
    var onDoneBlock : ((Bool) -> Void)?
    let qrScanner = QRScanner()
    let connectingView = ConnectingView()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self
        configureImageView()
        configureScanner()
        scanNow()
        
    }
    
    func configureImageView() {
        
        imageView.frame = self.view.frame
        self.view.addSubview(imageView)
        
    }
    
    func configureScanner() {
        
        imageView.alpha = 0
        imageView.frame = view.frame
        imageView.isUserInteractionEnabled = true
        
        qrScanner.isScanningNode = true
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
        
        let btcstandupURI = qrScanner.stringToReturn
        addBtcRpcQr(url: btcstandupURI)
        
    }
    
    func addBtcRpcQr(url: String) {
        
        let qc = QuickConnect()
    
        func nodeAdded() {
            
            print("result")
            
            if !qc.errorBool {
                
                DispatchQueue.main.async {
                    
                    self.onDoneBlock!(true)
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            } else {
                
                scanNow()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: qc.errorDescription)
                
            }
            
        }
        
        func addnode() {
            
            qc.addNode(vc: self,
                       url: url,
                       completion: nodeAdded)
            
        }
        
        if url.hasPrefix("btcrpc://") || url.hasPrefix("btcstandup://") {
            
            addnode()
            
        } else {
            
            
            displayAlert(viewController: self,
                         isError: true,
                         message: "Thats not a compatible url!")
            
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
