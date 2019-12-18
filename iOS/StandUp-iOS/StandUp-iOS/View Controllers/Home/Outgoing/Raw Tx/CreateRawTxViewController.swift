//
//  CreateRawTxViewController.swift
//  BitSense
//
//  Created by Peter on 09/10/18.
//  Copyright © 2018 Fontaine. All rights reserved.
//

import UIKit

class CreateRawTxViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var qrCode = UIImage()
    var spendable = Double()
    var rawTxUnsigned = String()
    var rawTxSigned = String()
    var amountAvailable = Double()
    let qrImageView = UIImageView()
    var stringURL = String()
    var address = String()
    let nextButton = UIButton()
    var amount = String()
    var blurArray = [UIVisualEffectView]()
    let rawDisplayer = RawDisplayer()
    var scannerShowing = false
    var isFirstTime = Bool()
    var outputs = [Any]()
    var outputsString = ""
    
    @IBOutlet var addressInput: UITextView!
    @IBOutlet var addOutlet: UIButton!
    @IBOutlet var amountInput: UITextField!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var actionOutlet: UIButton!
    @IBOutlet var receivingLabel: UILabel!
    @IBOutlet var outputsTable: UITableView!
    @IBOutlet var scannerView: UIImageView!
    
    let creatingView = ConnectingView()
    let qrScanner = QRScanner()
    var isTorchOn = Bool()
    var outputArray = [[String:String]]()
    
    func configureScanner() {
        
        isFirstTime = true
        scannerView.alpha = 0
        scannerView.frame = view.frame
        scannerView.isUserInteractionEnabled = true
        
        qrScanner.uploadButton.addTarget(self, action: #selector(chooseQRCodeFromLibrary),
                                         for: .touchUpInside)
        
        qrScanner.keepRunning = false
        qrScanner.vc = self
        qrScanner.imageView = scannerView
        qrScanner.textField.alpha = 0
        qrScanner.downSwipeAction = { self.back() }
        qrScanner.completion = { self.getQRCode() }
        qrScanner.didChooseImage = { self.didPickImage() }
        
        qrScanner.uploadButton.addTarget(self,
                                         action: #selector(self.chooseQRCodeFromLibrary),
                                         for: .touchUpInside)
        
        qrScanner.torchButton.addTarget(self,
                                        action: #selector(toggleTorch),
                                        for: .touchUpInside)
        
        isTorchOn = false
        
        qrScanner.closeButton.addTarget(self,
                                        action: #selector(back),
                                        for: .touchUpInside)
        
    }
    
    func addScannerButtons() {
        
        self.addBlurView(frame: CGRect(x: self.scannerView.frame.maxX - 80,
                                       y: self.scannerView.frame.maxY - 80,
                                       width: 70,
                                       height: 70), button: self.qrScanner.uploadButton)
        
        self.addBlurView(frame: CGRect(x: 10,
                                       y: self.scannerView.frame.maxY - 80,
                                       width: 70,
                                       height: 70), button: self.qrScanner.torchButton)
        
    }
    
    @IBAction func scanNow(_ sender: Any) {
        
        print("scanNow")
        
        scannerShowing = true
        addressInput.resignFirstResponder()
        amountInput.resignFirstResponder()
        
        if isFirstTime {
            
            DispatchQueue.main.async {
                
                self.qrScanner.scanQRCode()
                self.addScannerButtons()
                self.scannerView.addSubview(self.qrScanner.closeButton)
                self.isFirstTime = false
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.scannerView.alpha = 1
                    
                })
                
            }
            
        } else {
            
            self.qrScanner.startScanner()
            self.addScannerButtons()
            
            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.scannerView.alpha = 1
                    
                })
                
            }
            
        }
        
    }
    
    func addOut() {
        
        if outputArray.count > 0 && amountInput.text == "" && addressInput.text == "" {
            
            tryRaw()
            
        } else {
         
            if amountInput.text != "" && addressInput.text != "" && amountInput.text != "0.0" {
                
                let dict = ["address":addressInput.text!, "amount":amountInput.text!] as [String : String]
                
                outputArray.append(dict)
                
                DispatchQueue.main.async {
                    
                    self.outputsTable.alpha = 1
                    self.amountInput.text = ""
                    self.addressInput.text = ""
                    self.outputsTable.reloadData()
                    
                }
                
            } else {
                
                displayAlert(viewController: self,
                             isError: true,
                             message: "You need to fill out a recipient and amount first then tap this button, this button is used for adding multiple recipients aka \"batching\".")
                
            }
            
        }
        
    }
    
    @IBAction func addOutput(_ sender: Any) {
        
        addOut()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Recipients:"
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.init(name: "System", size: 10)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.lightText
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return outputArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = view.backgroundColor
        
        if outputArray.count > 0 {
            
            if outputArray.count > 1 {
                
                tableView.separatorColor = UIColor.white
                tableView.separatorStyle = .singleLine
                
            }
            
            let address = outputArray[indexPath.row]["address"]!
            let amount = outputArray[indexPath.row]["amount"]!
            
            cell.textLabel?.text = "#\(indexPath.row + 1)\nSending: \(String(describing: amount))\nTo: \(String(describing: address))"
            
        } else {
            
           cell.textLabel?.text = ""
            
        }
        
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountInput.delegate = self
        addressInput.delegate = self
        outputsTable.delegate = self
        outputsTable.dataSource = self
        outputsTable.tableFooterView = UIView(frame: .zero)
        outputsTable.alpha = 0
        configureScanner()
        addTapGesture()
        scannerView.alpha = 0
        scannerView.backgroundColor = UIColor.black
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rawTxSigned = ""
    }
    
    func addTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.dismissKeyboard (_:)))
        
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func getQRCode() {
        
        let stringURL = qrScanner.stringToReturn
        processKeys(key: stringURL)
        
    }
    
    // MARK: User Actions
    
    @IBAction func goToUTXOs(_ sender: Any) {
        
        DispatchQueue.main.async {
        
            self.performSegue(withIdentifier: "goToUTXOs", sender: self)
            
        }
        
    }
    
    
    @objc func close() {
        
        DispatchQueue.main.async {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func confirm(raw: String) {
        
        DispatchQueue.main.async {
            
            self.creatingView.removeConnectingView()
            self.amount = ""
            self.amountInput.text = ""
            self.addressInput.text = ""
            self.outputs.removeAll()
            self.outputArray.removeAll()
            self.outputsString = ""
            self.outputsTable.reloadData()
            self.rawTxSigned = raw
            self.performSegue(withIdentifier: "goConfirm", sender: self)
            
        }
        
    }
    
    @IBAction func tryRawNow(_ sender: Any) {
        print("tryrawnow")
        
        DispatchQueue.main.async {
            self.addressInput.resignFirstResponder()
            self.amountInput.resignFirstResponder()
        }
        
        tryRaw()
        
    }
    
    @objc func tryRaw() {
        print("tryraw")
        
        
        
        creatingView.addConnectingView(vc: self,
                                       description: "Creating Raw")
        
        if self.addressInput.text != "" && self.amountInput.text != "" {
            
          addOut()
            
        }
        
        func convertOutputs() {
            
            for output in outputArray {
                
                if let amount = output["amount"] {
                    
                    if let address = output["address"] {
                        
                        if address != "" {
                            
                            let dbl = Double(amount)!
                            let out = [address:dbl]
                            outputs.append(out)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            outputsString = outputs.description
            outputsString = outputsString.replacingOccurrences(of: "[", with: "")
            outputsString = outputsString.replacingOccurrences(of: "]", with: "")
            self.getRawTx()
            
        }
        
        if outputArray.count == 0 {
            
            if self.amountInput.text != "" && self.amountInput.text != "0.0" && self.addressInput.text != "" {
                
                let dict = ["address":addressInput.text!, "amount":amountInput.text!] as [String : String]
                
                outputArray.append(dict)
                convertOutputs()
                
            } else {
                
                creatingView.removeConnectingView()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: "You need to fill out an amount and a recipient")
                
            }
            
        /*} else if outputArray.count > 0 && self.amountInput.text != "" || self.amountInput.text != "0.0" && self.addressInput.text != "" {
            
            creatingView.removeConnectingView()
            
            displayAlert(viewController: self,
                         isError: true,
                         message: "If you want to add multiple recipients please tap the \"+\" and add them all first.")*/
            
        } else if outputArray.count > 0 {
            
            convertOutputs()
            
        }
        
    }
    
    func didPickImage() {
        
        let qrString = qrScanner.qrString
        processKeys(key: qrString)
        
    }
    
    @objc func chooseQRCodeFromLibrary() {
        
        qrScanner.chooseQRCodeFromLibrary()
        
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        amountInput.resignFirstResponder()
        addressInput.resignFirstResponder()
        
    }
    
    //MARK: User Interface
    
    func addBlurView(frame: CGRect, button: UIButton) {
        
        button.removeFromSuperview()
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        blur.frame = frame
        blur.clipsToBounds = true
        blur.layer.cornerRadius = frame.width / 2
        blur.contentView.addSubview(button)
        self.scannerView.addSubview(blur)
        
    }
    
    @objc func back() {
        
        DispatchQueue.main.async {
            
            self.scannerView.alpha = 0
            self.scannerShowing = false
            
        }
        
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
    
    //MARK: Textfield methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("shouldChangeCharactersInRange")
        
        if (textField.text?.contains("."))! {
            
           let decimalCount = (textField.text?.components(separatedBy: ".")[1])?.count
            
            if decimalCount! <= 7 {
                
                
            } else {
                
                DispatchQueue.main.async {
                    
                    displayAlert(viewController: self,
                                 isError: true,
                                 message: "Only 8 decimal places allowed")
                    
                    self.amountInput.text = ""
                    
                }
                
            }
            
        }
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        
        if textField == addressInput && addressInput.text != "" {
            
            processKeys(key: addressInput.text!)
            
        //} else if textField == self.amountInput && self.amountInput.text != "" {
            
            //self.amountInput.resignFirstResponder()
            
        } else if textField == addressInput && addressInput.text == "" {
            
            shakeAlert(viewToShake: self.qrScanner.textField)
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        
        textField.endEditing(true)
        return true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if isTorchOn {
            
            toggleTorch()
            
        }
        
    }
    
    //MARK: Helpers
    
    func rounded(number: Double) -> Double {
        
        return Double(round(100000000*number)/100000000)
        
    }
    
    func processBIP21(url: String) {
        
        let addressParser = AddressParser()
        let errorBool = addressParser.parseAddress(url: url).errorBool
        let errorDescription = addressParser.parseAddress(url: url).errorDescription
        
        if !errorBool {
            
            let address = addressParser.parseAddress(url: url).address
            let amount = "\(addressParser.parseAddress(url: url).amount)"
            
            DispatchQueue.main.async {
                
                self.addressInput.resignFirstResponder()
                self.amountInput.resignFirstResponder()
                
                DispatchQueue.main.async {
                    
                    let dict = ["address":address, "amount":amount] as [String : String]
                    
                    self.outputArray.append(dict)
                    
                    DispatchQueue.main.async {
                        
                        self.outputsTable.alpha = 1
                        self.amountInput.text = ""
                        self.addressInput.text = ""
                        self.outputsTable.reloadData()
                        
                    }
                    
                }
                
                self.back()
                
            }
            
        } else {
            
            displayAlert(viewController: self,
                         isError: true,
                         message: errorDescription)
            
        }
        
    }
    
    enum error: Error {
        
        case noCameraAvailable
        case videoInputInitFail
        
    }
    
    func processKeys(key: String) {
        
        self.processBIP21(url: key)
        
    }
    
    //MARK: Result Parsers
    
    func getRawTx() {
        print("getRawTx")
        
        let rawTransaction = Send()//RawTransaction()
        rawTransaction.outputs = outputsString
        let ud = UserDefaults.standard
        rawTransaction.numberOfBlocks = ud.object(forKey: "feeTarget") as? Int ?? 6
        
        func getResult() {
            
            if !rawTransaction.errorBool {
                
                self.confirm(raw: rawTransaction.signedRawTx)
                
            } else {
                
                DispatchQueue.main.async {
                    
                    self.outputsString = ""
                    self.outputs.removeAll()
                    self.creatingView.removeConnectingView()
                    
                    displayAlert(viewController: self,
                                 isError: true,
                                 message: rawTransaction.errorDescription)
                    
                }
                
            }
            
        }
        
        DispatchQueue.main.async {
            
            rawTransaction.create(completion: getResult)
            
        }
        
    }
    
    //MARK: Node Commands
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == addressInput {
            
            if textView.text != "" {
                
                textView.becomeFirstResponder()
                
            } else {
                
                if let string = UIPasteboard.general.string {
                    
                    textView.becomeFirstResponder()
                    textView.text = string
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        textView.resignFirstResponder()
                        //self.processKeys(key: string)
                    }
                    
                    
                } else {
                    
                    textView.becomeFirstResponder()
                    
                }
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.outputArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "goConfirm":
            
            if let vc = segue.destination as? ConfirmViewController {
                
                vc.signedRawTx = self.rawTxSigned
                
            }
            
        default:
            
            break
            
        }
        
    }
    
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}



