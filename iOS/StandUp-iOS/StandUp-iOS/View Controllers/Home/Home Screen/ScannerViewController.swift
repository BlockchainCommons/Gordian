//
//  ScannerViewController.swift
//  BitSense
//
//  Created by Peter on 04/12/19.
//  Copyright © 2019 Fontaine. All rights reserved.
//

import UIKit

class ScannerViewController: UIViewController, UINavigationControllerDelegate {
    
    let qrScanner = QRScanner()
    var isTorchOn = Bool()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let connectingView = ConnectingView()
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        configureScanner()
        scanNow()
        
        // MARK: For testing purposes we hard code a btcstandup url, to revert just comment out addNode()
        //addnode()
    }
    
    func addnode() {
        
        // Testnet Linode instance:
        let url = "btcstandup://StandUp:71e355f8e097857c932cc315f321eb4a@ftemeyifladknw3cpdhilomt7fhb3cquebzczjb7hslia77khc7cnwid.onion:1309/?label=LinodeStandUp.sh"
        addBtcRpcQr(url: url)
        
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
        
        let btcstandupURI = qrScanner.stringToReturn
        addBtcRpcQr(url: btcstandupURI)
        
    }
    
    @objc func toggleTorch() {
           
           if isTorchOn {
               
               qrScanner.toggleTorch(on: false)
               isTorchOn = false
               
           } else {
               
               qrScanner.toggleTorch(on: true)
               isTorchOn = true
               
           }
           
       }
    
    func addBtcRpcQr(url: String) {
        
        let qc = QuickConnect()
    
        func nodeAdded() {
            
            print("result")
            
            if !qc.errorBool {
                
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            } else {
                
                scanNow()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: qc.errorDescription)
                
            }
            
        }
        
        func addnode() {
            
            connectingView.addConnectingView(vc: self, description: "getting authentication keys")
            
            let keygen = KeyGen()
            keygen.generate()
            let pubkey = "descriptor:x25519:" + keygen.pubKey
            let privkey = keygen.privKey
            
            qc.addNode(vc: self,
                       url: url, authkey: privkey, authPubKey: pubkey,
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        if id == "showPubkey" {
            
            if let vc = segue.destination as? AuthenticateViewController {
                
                vc.isadding = true
            }
        }
    }
    

}
