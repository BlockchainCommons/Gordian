//
//  InvoiceViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController, UITextFieldDelegate {
    
    let spinner = UIActivityIndicatorView(style: .medium)
    var textToShareViaQRCode = String()
    var addressString = String()
    var qrCode = UIImage()
    let descriptionLabel = UILabel()
    var tapQRGesture = UITapGestureRecognizer()
    var tapAddressGesture = UITapGestureRecognizer()
    var nativeSegwit = Bool()
    var p2shSegwit = Bool()
    var legacy = Bool()
    let connectingView = ConnectingView()
    let qrGenerator = QRGenerator()
    let copiedLabel = UILabel()
    let cd = CoreDataService()
    var refreshButton = UIBarButtonItem()
    var dataRefresher = UIBarButtonItem()
    var initialLoad = Bool()
    var wallet:WalletStruct!
    
    @IBOutlet var amountField: UITextField!
    @IBOutlet var labelField: UITextField!
    @IBOutlet var qrView: UIImageView!
    @IBOutlet var addressOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        initialLoad = true
        addressOutlet.isUserInteractionEnabled = true
        addressOutlet.text = ""
        amountField.delegate = self
        labelField.delegate = self
        configureCopiedLabel()
        
        amountField.addTarget(self,
                              action: #selector(textFieldDidChange(_:)),
                              for: .editingChanged)
        
        labelField.addTarget(self,
                             action: #selector(textFieldDidChange(_:)),
                             for: .editingChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        addDoneButtonOnKeyboard()
        load()
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        
        self.load()
                
    }
    
    func addNavBarSpinner() {
        
        spinner.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        dataRefresher = UIBarButtonItem(customView: spinner)
        navigationItem.setRightBarButton(dataRefresher, animated: true)
        spinner.startAnimating()
        spinner.alpha = 1
        
    }
    
    func removeLoader() {
        
        DispatchQueue.main.async {
            
            self.spinner.stopAnimating()
            self.spinner.alpha = 0
            
            self.refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                 target: self,
                                                 action: #selector(self.load))
            
            self.refreshButton.tintColor = UIColor.white.withAlphaComponent(1)
            
            self.navigationItem.setRightBarButton(self.refreshButton,
                                                  animated: true)
            
                        
        }
        
    }
    
    @objc func load() {
        
        connectingView.addConnectingView(vc: self, description: "fetching invoice address from your node")
        
        getActiveWalletNow() { (wallet, error) in
            
            if !error && wallet != nil {
                
                self.wallet = wallet!
                
                self.addNavBarSpinner()
                
                if !self.initialLoad {
                    
                    DispatchQueue.main.async {
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            
                            self.addressOutlet.alpha = 0
                            self.qrView.alpha = 0
                            
                        }) { (_) in
                            
                            self.addressOutlet.text = ""
                            self.qrView.image = nil
                            self.addressOutlet.alpha = 1
                            self.qrView.alpha = 1
                            self.showAddress()
                            
                        }
                        
                    }
                    
                } else {
                    
                    self.showAddress()
                    
                }
                
            } else if error {
                
                self.connectingView.removeConnectingView()
                self.removeLoader()
                showAlert(vc: self, title: "Error", message: "No active wallets")
                
            }
            
        }
        
    }
    
    func filterDerivation(derivation: String) {
        
        if derivation.contains("84") {
            
            self.executeNodeCommand(method: .getnewaddress,
                                    param: "\"\", \"bech32\"")
            
        } else if derivation.contains("44") {
            
            self.executeNodeCommand(method: .getnewaddress,
                                    param: "\"\", \"legacy\"")
            
        } else if derivation.contains("49") {
            
            self.executeNodeCommand(method: .getnewaddress,
                                    param: "\"\", \"p2sh-segwit\"")
            
        }
        
    }
    
    func showAddress() {
        
        let derivation = wallet!.derivation
        let type = wallet!.type
        
        if type == "MULTI" || type == "CUSTOM" {
            
            self.getMsigAddress()
            
        } else {
            
            self.filterDerivation(derivation: derivation)
            
        }
        
    }
    
    func getMsigAddress() {
        
        let keyFetcher = KeyFetcher()
        keyFetcher.musigAddress { (address, error) in
            
            if !error {
                
                self.connectingView.removeConnectingView()
                self.removeLoader()
                self.addressString = address!
                self.showAddress(address: address!)
                
            } else {
                
                self.connectingView.removeConnectingView()
                displayAlert(viewController: self, isError: true, message: "error getting musig address")
                
            }
            
        }
        
    }
    
    func showAddress(address: String) {
        print("show address: \(address)")
        
        DispatchQueue.main.async {
            
            let pasteboard = UIPasteboard.general
            pasteboard.string = address
            
            self.qrCode = self.generateQrCode(key: address)
            self.qrView.image = self.qrCode
            self.qrView.isUserInteractionEnabled = true
            self.qrView.alpha = 0
            self.view.addSubview(self.qrView)
            
            self.descriptionLabel.frame = CGRect(x: 10,
                                            y: self.view.frame.maxY - 30,
                                            width: self.view.frame.width - 20,
                                            height: 20)
            
            self.descriptionLabel.textAlignment = .center
            
            self.descriptionLabel.font = UIFont.init(name: "HelveticaNeue-Light",
                                                size: 12)
            
            self.descriptionLabel.textColor = UIColor.white
            self.descriptionLabel.text = "Tap the QR Code or text to copy/save/share"
            self.descriptionLabel.adjustsFontSizeToFitWidth = true
            self.descriptionLabel.alpha = 0
            self.view.addSubview(self.descriptionLabel)
            
            self.tapAddressGesture = UITapGestureRecognizer(target: self,
                                                       action: #selector(self.shareAddressText(_:)))
            
            self.addressOutlet.addGestureRecognizer(self.tapAddressGesture)
            
            self.tapQRGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(self.shareQRCode(_:)))
            
            self.qrView.addGestureRecognizer(self.tapQRGesture)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.descriptionLabel.alpha = 1
                self.qrView.alpha = 1
                self.addressOutlet.alpha = 1
                
            }) { _ in
                
                self.addressOutlet.text = address
                self.addCopiedLabel()
                
            }
            
        }
        
    }
    
    func addCopiedLabel() {
        
        view.addSubview(copiedLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                if self.tabBarController != nil {
                    
                    self.copiedLabel.frame = CGRect(x: 0,
                                                    y: self.tabBarController!.tabBar.frame.minY - 50,
                                                    width: self.view.frame.width,
                                                    height: 50)
                    
                }
                
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.copiedLabel.frame = CGRect(x: 0,
                                                    y: self.view.frame.maxY + 100,
                                                    width: self.view.frame.width,
                                                    height: 50)
                    
                }, completion: { _ in
                    
                    self.copiedLabel.removeFromSuperview()
                    
                })
                
            })
            
        }
        
    }
    
    @objc func shareAddressText(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.addressOutlet.alpha = 0
            
        }) { _ in
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.addressOutlet.alpha = 1
                
            })
            
        }
        
        DispatchQueue.main.async {
            
            let textToShare = [self.addressString]
            
            let activityViewController = UIActivityViewController(activityItems: textToShare,
                                                                  applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true) {}
            
        }
        
    }
    
    @objc func shareQRCode(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.qrView.alpha = 0
            
        }) { _ in
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.qrView.alpha = 1
                
            }) { _ in
                
                let activityController = UIActivityViewController(activityItems: [self.qrView.image!],
                                                                  applicationActivities: nil)
                
                activityController.popoverPresentationController?.sourceView = self.view
                self.present(activityController, animated: true) {}
                
            }
            
        }
        
    }
    
    func executeNodeCommand(method: BTC_CLI_COMMAND, param: String) {
        print("executeNodeCommand")
        
        let reducer = Reducer()
        
        func getResult() {
            
            if !reducer.errorBool {
                
                switch method {
                    
                case .getnewaddress:
                    
                    DispatchQueue.main.async {
                        
                        self.connectingView.removeConnectingView()
                        self.initialLoad = false
                        let address = reducer.stringToReturn
                        self.removeLoader()
                        self.addressString = address
                        self.addressOutlet.text = address
                        self.showAddress(address: address)
                        
                    }
                    
                default:
                    
                    break
                    
                }
                
            } else {
                
                self.connectingView.removeConnectingView()
                self.removeLoader()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: reducer.errorDescription)
            }
            
        }
        
        reducer.makeCommand(walletName: wallet.name, command: method,
                                    param: param,
                                    completion: getResult)
                            
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("textFieldDidChange")
        
        updateQRImage()
        
    }
    
    func generateQrCode(key: String) -> UIImage {
        print("generateqrcode: \(key)")
        qrGenerator.textInput = key
        let qr = qrGenerator.getQRCode()
        
        return qr
        
    }
    
    func updateQRImage() {
        
        var newImage = UIImage()
        
        if self.amountField.text == "" && self.labelField.text == "" {
            
            newImage = self.generateQrCode(key:"bitcoin:\(self.addressString)")
            textToShareViaQRCode = "bitcoin:\(self.addressString)"
            
        } else if self.amountField.text != "" && self.labelField.text != "" {
            
            newImage = self.generateQrCode(key:"bitcoin:\(self.addressString)?amount=\(self.amountField.text!)&label=\(self.labelField.text!)")
            textToShareViaQRCode = "bitcoin:\(self.addressString)?amount=\(self.amountField.text!)&label=\(self.labelField.text!)"
            
        } else if self.amountField.text != "" && self.labelField.text == "" {
            
            newImage = self.generateQrCode(key:"bitcoin:\(self.addressString)?amount=\(self.amountField.text!)")
            textToShareViaQRCode = "bitcoin:\(self.addressString)?amount=\(self.amountField.text!)"
            
        } else if self.amountField.text == "" && self.labelField.text != "" {
            
            newImage = self.generateQrCode(key:"bitcoin:\(self.addressString)?label=\(self.labelField.text!)")
            textToShareViaQRCode = "bitcoin:\(self.addressString)?label=\(self.labelField.text!)"
            
        }
        
        DispatchQueue.main.async {
            
            UIView.transition(with: self.qrView,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.qrView.image = newImage },
                              completion: nil)
            
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
        }
        
    }
    
    @objc func doneButtonAction() {
        
        self.amountField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        return false
        
    }
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar = UIToolbar()
        
        doneToolbar.frame = CGRect(x: 0,
                                   y: 0,
                                   width: 320,
                                   height: 50)
        
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                        target: nil,
                                        action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                    style: UIBarButtonItem.Style.done,
                                                    target: self,
                                                    action: #selector(doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = (items as! [UIBarButtonItem])
        doneToolbar.sizeToFit()
        
        self.amountField.inputAccessoryView = doneToolbar
        
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
    func configureCopiedLabel() {
        
        copiedLabel.text = "copied to clipboard ✓"
        
        copiedLabel.frame = CGRect(x: 0,
                                   y: view.frame.maxY + 100,
                                   width: view.frame.width,
                                   height: 50)
        
        copiedLabel.textColor = UIColor.darkGray
        copiedLabel.font = UIFont.init(name: "HiraginoSans-W3", size: 17)
        copiedLabel.backgroundColor = UIColor.black
        copiedLabel.textAlignment = .center
        
    }

}
