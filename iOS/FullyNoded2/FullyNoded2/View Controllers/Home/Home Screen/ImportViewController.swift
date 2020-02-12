//
//  ImportViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 06/02/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController, UINavigationControllerDelegate {
    
    var onDoneBlock : ((Bool) -> Void)?
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
        
    }
    
    func configureScanner() {
        
        imageView.alpha = 0
        imageView.frame = view.frame
        imageView.isUserInteractionEnabled = true
        
        qrScanner.isScanningNode = false
        qrScanner.isImporting = true
        qrScanner.keepRunning = false
        qrScanner.vc = self
        qrScanner.imageView = imageView
        qrScanner.completion = { self.getQRCode() }
        qrScanner.didChooseImage = { self.didPickImage() }
        
        qrScanner.torchButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
        qrScanner.uploadButton.addTarget(self, action: #selector(chooseQRCodeFromLibrary), for: .touchUpInside)
        qrScanner.addTestingNodeButton.addTarget(self, action: #selector(whatIsADescriptor), for: .touchUpInside)
        
        isTorchOn = false
        
    }
    
    @objc func whatIsADescriptor() {
        
        showAlert(vc: self, title: "Descriptors", message: "A descriptor is a human readable, unambiguous bit of text which you may use to import wallets into Bitcoin Core. Descriptors communicate a wallets derivation path, whether it is hot, cold, multi-sig, single-sig, BIP67, P2SH-Segwit, Native Segwit or Legacy all in one compact line of text. Allowing you to import any type of wallet you can imagine into your node with one command.\n\nStandUp utilizes descriptors by allowing you to export either your public key or private key descriptors. Making them a great tool for wallet recovery or importing between multiple platforms.")
        
    }
    
    func addScannerButtons() {
        
        self.addBlurView(frame: CGRect(x: self.imageView.frame.maxX - 80,
                                       y: self.imageView.frame.maxY - 120,
                                       width: 70,
                                       height: 70), button: self.qrScanner.uploadButton)
        
        self.addBlurView(frame: CGRect(x: 10,
                                       y: self.imageView.frame.maxY - 120,
                                       width: 70,
                                       height: 70), button: self.qrScanner.torchButton)
        
    }
    
    func didPickImage() {
        
        let qrString = qrScanner.qrString
        processDescriptor(url: qrString)
        
    }
    
    @objc func chooseQRCodeFromLibrary() {
        
        qrScanner.chooseQRCodeFromLibrary()
        
    }
    
    func addBlurView(frame: CGRect, button: UIButton) {
        
        button.removeFromSuperview()
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        blur.frame = frame
        blur.clipsToBounds = true
        blur.layer.cornerRadius = frame.width / 2
        blur.contentView.addSubview(button)
        self.imageView.addSubview(blur)
        
    }
    
    func scanNow() {
        print("scanNow")
        
        DispatchQueue.main.async {
            
            self.qrScanner.scanQRCode()
            self.addScannerButtons()
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.imageView.alpha = 1
                
            })
            
        }
        
    }
    
    func getQRCode() {
        
        let btcstandupURI = qrScanner.stringToReturn
        processDescriptor(url: btcstandupURI)
        
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
    
    func processDescriptor(url: String) {
        
        connectingView.addConnectingView(vc: self, description: "creating custom wallet")
        
        let importWallet = ImportColdMultiSigDescriptor()
        importWallet.create(descriptor: url) { (success, error, errorDescription) in
            
            if !error && success {
                
                self.connectingView.removeConnectingView()
                showAlert(vc: self, title: "Success!", message: "Wallet created, to use it activate it in \"Wallets\"")
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: errorDescription!)
                
            }
            
        }
        
//        let qc = QuickConnect()
//
//        func nodeAdded() {
//
//            print("result")
//
//            if !qc.errorBool {
//
//                DispatchQueue.main.async {
//
//                    self.onDoneBlock!(true)
//                    self.dismiss(animated: true, completion: nil)
//
//                }
//
//            } else {
//
//                scanNow()
//
//                displayAlert(viewController: self,
//                             isError: true,
//                             message: qc.errorDescription)
//
//            }
//
//        }
//
//        func addnode() {
//
//            qc.addNode(vc: self,
//                       url: url,
//                       completion: nodeAdded)
//
//        }
//
//        if url.hasPrefix("btcrpc://") || url.hasPrefix("btcstandup://") {
//
//            addnode()
//
//        } else {
//
//
//            displayAlert(viewController: self,
//                         isError: true,
//                         message: "Thats not a compatible url!")
//
//        }
                
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
