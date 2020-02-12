//
//  UTXOViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

class UTXOViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var createRawOutlet: UIBarButtonItem!
    var isSweeping = false
    var amountToSend = String()
    let amountInput = UITextField()
    let amountView = UIView()
    var tapQRGesture = UITapGestureRecognizer()
    var tapTextViewGesture = UITapGestureRecognizer()
    var rawSigned = String()
    var amountTotal = 0.0
    let refresher = UIRefreshControl()
    var utxoArray = [Any]()
    var inputArray = [Any]()
    var inputs = ""
    var address = ""
    var utxoToSpendArray = [Any]()
    var creatingView = ConnectingView()
    var legacy = Bool()
    var selectedArray = [Bool]()
    var scannerShowing = false
    var blurArray = [UIVisualEffectView]()
    var isFirstTime = Bool()
    var isUnsigned = false
    var lockedArray = NSArray()
    var utxo = NSDictionary()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let blurView2 = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let qrGenerator = QRGenerator()
    var isTorchOn = Bool()
    let qrScanner = QRScanner()
    let rawDisplayer = RawDisplayer()
    var addresses = [String]()
    
    let sweepButtonView = Bundle.main.loadNibNamed("KeyPadButtonView",
                                                   owner: self,
                                                   options: nil)?.first as! UIView?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var utxoTable: UITableView!
    
    @IBAction func lockAction(_ sender: Any) {
        
        creatingView.addConnectingView(vc: self,
                                       description: "Getting Locked UTXO's")
        
        executeNodeCommand(method: .listlockunspent,
                           param: "")
        
    }
    
    func configureAmountView() {
        
        amountView.backgroundColor = view.backgroundColor
        
        amountView.frame = CGRect(x: 0,
                                  y: -200,
                                  width: view.frame.width,
                                  height: -200)
        
        amountInput.backgroundColor = view.backgroundColor
        amountInput.textColor = UIColor.white
        amountInput.keyboardAppearance = .dark
        amountInput.textAlignment = .center
        
        amountInput.frame = CGRect(x: 0,
                                   y: amountView.frame.midY,
                                   width: amountView.frame.width,
                                   height: 90)
        
        amountInput.keyboardType = UIKeyboardType.decimalPad
        amountInput.font = UIFont.init(name: "HiraginoSans-W3", size: 40)
        amountInput.tintColor = UIColor.white
        amountInput.inputAccessoryView = sweepButtonView
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sweepButtonClicked),
                                               name: NSNotification.Name(rawValue: "buttonClickedNotification"),
                                               object: nil)
        
        
    }
    
    func amountAvailable(amount: Double) -> (Bool, String) {
        
        var amountAvailable = 0.0
        
        for utxoDict in utxoToSpendArray {
            
            let utxo = utxoDict as! NSDictionary
            let amnt = utxo["amount"] as! Double
            amountAvailable += amnt
            
        }
        
        let string = amountAvailable.avoidNotation
        
        if amountAvailable >= amount {
            
            return (true, string)
            
        } else {
            
            return (false, string)
            
        }
        
    }
    
    @objc func sweepButtonClicked() {
        
        var amountToSweep = 0.0
        isSweeping = true
        
        for utxoDict in utxoToSpendArray {
            
            let utxo = utxoDict as! NSDictionary
            let amount = utxo["amount"] as! Double
            amountToSweep += amount
            
        }
        
        DispatchQueue.main.async {
            
            self.amountInput.text = amountToSweep.avoidNotation
            
        }
        
    }
    
    @objc func closeAmount() {
        
        self.createRawOutlet.tintColor = UIColor.white.withAlphaComponent(1)
        
        if self.amountInput.text != "" {
            
            self.creatingView.addConnectingView(vc: self, description: "")
            
            self.amountToSend = self.amountInput.text!
            
            let amount = Double(self.amountToSend)!
            
            if amountAvailable(amount: amount).0 {
                
                self.amountInput.resignFirstResponder()
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.amountView.frame = CGRect(x: 0,
                                                   y: -200,
                                                   width: self.view.frame.width,
                                                   height: -200)
                    
                }) { _ in
                    
                    self.amountView.removeFromSuperview()
                    self.amountInput.removeFromSuperview()
                    self.getAddress()
                    
                }
                
            } else {
                
                creatingView.removeConnectingView()
                
                let available = amountAvailable(amount: amount).1
                
                displayAlert(viewController: self,
                             isError: true,
                             message: "That UTXO only has \(available) BTC")
                
            }
            
        } else {
            
            self.amountInput.resignFirstResponder()
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.amountView.frame = CGRect(x: 0,
                                               y: -200,
                                               width: self.view.frame.width,
                                               height: -200)
                self.blurView2.alpha = 0
                
            }) { _ in
                
                self.blurView2.removeFromSuperview()
                self.amountView.removeFromSuperview()
                self.amountInput.removeFromSuperview()
                
            }
            
        }
        
    }
    
    func getAmount() {
        
        self.createRawOutlet.tintColor = UIColor.white.withAlphaComponent(0)
        
        blurView2.removeFromSuperview()
        
        let label = UILabel()
        
        label.frame = CGRect(x: 0,
                             y: 15,
                             width: amountView.frame.width,
                             height: 20)
        
        label.font = UIFont.init(name: "HiraginoSans-W3", size: 20)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.text = "Amount to send"
        
        let button = UIButton()
        button.setImage(UIImage(named: "Minus"), for: .normal)
        button.frame = CGRect(x: 0, y: 140, width: self.view.frame.width, height: 60)
        button.addTarget(self, action: #selector(closeAmount), for: .touchUpInside)
        
        blurView2.alpha = 0
        
        blurView2.frame = CGRect(x: 0,
                                 y: -20,
                                 width: self.view.frame.width,
                                 height: self.view.frame.height + 20)
        
        self.view.addSubview(self.blurView2)
        self.view.addSubview(self.amountView)
        self.amountView.addSubview(self.amountInput)
        self.amountInput.text = "0.0"
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.amountView.frame = CGRect(x: 0,
                                           y: 85,
                                           width: self.view.frame.width,
                                           height: 200)
            
            self.amountInput.frame = CGRect(x: 0,
                                            y: 40,
                                            width: self.amountView.frame.width,
                                            height: 90)
            
        }) { _ in
            
            self.amountView.addSubview(label)
            self.amountView.addSubview(button)
            self.amountInput.becomeFirstResponder()
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.blurView2.alpha = 1
                
            })
            
        }
        
    }
    
    @IBAction func createRaw(_ sender: Any) {
        
        if self.utxoToSpendArray.count > 0 {
            
            updateInputs()
            
            if self.inputArray.count > 0 {
                
                DispatchQueue.main.async {
                    
                    self.getAmount()
                    
                }
                
            } else {
                
                displayAlert(viewController: self,
                             isError: true,
                             message: "Select a UTXO first")
                
            }
            
        } else {
            
            displayAlert(viewController: self,
                         isError: true,
                         message: "Select a UTXO first")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        utxoTable.delegate = self
        utxoTable.dataSource = self
        
        configureScanner()
        configureAmountView()

        utxoTable.tableFooterView = UIView(frame: .zero)
        refresher.tintColor = UIColor.white
        refresher.addTarget(self, action: #selector(refresh),
                            for: UIControl.Event.valueChanged)
        utxoTable.addSubview(refresher)
        
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.dismissKeyboard (_:)))
        
        tapGesture.numberOfTapsRequired = 1
        self.blurView2.addGestureRecognizer(tapGesture)
        
        refresh()
        
    }
    
    @objc func dismissAddressKeyboard(_ sender: UITapGestureRecognizer) {
     
        DispatchQueue.main.async {
            
            self.qrScanner.textField.resignFirstResponder()
            
        }
        
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        self.amountInput.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.amountView.frame = CGRect(x: 0,
                                           y: -200,
                                           width: self.view.frame.width,
                                           height: -200)
            
            self.blurView2.alpha = 0
            
            self.createRawOutlet.tintColor = UIColor.white.withAlphaComponent(1)
            
        }) { _ in
            
            self.blurView2.removeFromSuperview()
            self.amountView.removeFromSuperview()
            self.amountInput.removeFromSuperview()
            
        }
        
    }
    
    @objc func refresh() {
        
        addSpinner()
        utxoArray.removeAll()
        
        executeNodeCommand(method: .listunspent,
                           param: "0")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return utxoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "utxoCell", for: indexPath)
        
        if utxoArray.count > 0 {
            
            let dict = utxoArray[indexPath.section] as! NSDictionary
            let address = cell.viewWithTag(1) as! UILabel
            let txId = cell.viewWithTag(2) as! UILabel
            let amount = cell.viewWithTag(4) as! UILabel
            let vout = cell.viewWithTag(6) as! UILabel
            let solvable = cell.viewWithTag(7) as! UILabel
            let confs = cell.viewWithTag(8) as! UILabel
            let safe = cell.viewWithTag(9) as! UILabel
            let spendable = cell.viewWithTag(10) as! UILabel
            let checkMark = cell.viewWithTag(13) as! UIImageView
            let label = cell.viewWithTag(11) as! UILabel
            txId.adjustsFontSizeToFitWidth = true
            
            if !(selectedArray[indexPath.section]) {
                
                checkMark.alpha = 0
                cell.backgroundColor = view.backgroundColor
                
            } else {
                
                checkMark.alpha = 1
                cell.backgroundColor = UIColor.black
                
            }
            
            for (key, value) in dict {
                
                let keyString = key as! String
                
                switch keyString {
                    
                case "address":
                    
                    address.text = "\(value)"
                    
                case "txid":
                    
                    txId.text = "txid: \(value)"
                    
                case "amount":
                    
                    let dbl = rounded(number: value as! Double)
                    amount.text = dbl.avoidNotation
                    
                case "vout":
                    
                    vout.text = "vout #\(value)"
                    
                case "solvable":
                    
                    if (value as! Int) == 1 {
                        
                        solvable.text = "Solvable"
                        solvable.textColor = UIColor.green
                        
                    } else if (value as! Int) == 0 {
                        
                        solvable.text = "Not Solvable"
                        solvable.textColor = UIColor.blue
                        
                    }
                    
                case "confirmations":
                    
                    if (value as! Int) == 0 {
                     
                        confs.textColor = UIColor.red
                        
                    } else {
                        
                        confs.textColor = UIColor.green
                        
                    }
                    
                    confs.text = "\(value) confs"
                    
                case "safe":
                    
                    if (value as! Int) == 1 {
                        
                        safe.text = "Safe"
                        safe.textColor = UIColor.green
                        
                    } else if (value as! Int) == 0 {
                        
                        safe.text = "Not Safe"
                        safe.textColor = UIColor.red
                        
                    }
                    
                case "spendable":
                    
                    if (value as! Int) == 1 {
                        
                        spendable.text = "Spendable"
                        spendable.textColor = UIColor.green
                        
                    } else if (value as! Int) == 0 {
                        
                        spendable.text = "COLD"
                        spendable.textColor = UIColor.blue
                        
                    }
                    
                case "label":
                    
                    label.text = (value as! String)
                    
                default:
                    
                    break
                    
                }
                
            }
            
        }
        
        return cell
        
    }
    
    func lockUTXO(txid: String, vout: Int) {
        
        let param = "false, ''[{\"txid\":\"\(txid)\",\"vout\":\(vout)}]''"
        
        executeNodeCommand(method: .lockunspent,
                           param: param)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let utxos = utxoArray as NSArray
        let utxo = utxos[indexPath.section] as! NSDictionary
        let txid = utxo["txid"] as! String
        let vout = utxo["vout"] as! Int
        
        let contextItem = UIContextualAction(style: .destructive, title: "Lock") {  (contextualAction, view, boolValue) in
            
            self.lockUTXO(txid: txid, vout: vout)
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        contextItem.backgroundColor = .systemRed

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = utxoTable.cellForRow(at: indexPath)
        let checkmark = cell?.viewWithTag(13) as! UIImageView
        let address = (utxoArray[indexPath.section] as! NSDictionary)["address"] as! String
        cell?.isSelected = true
        
        self.selectedArray[indexPath.section] = true
        
        DispatchQueue.main.async {
            
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
            UIView.animate(withDuration: 0.2, animations: {
                
                cell?.alpha = 0
                
            }) { _ in
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    cell?.alpha = 1
                    checkmark.alpha = 1
                    cell?.backgroundColor = UIColor.black
                    
                })
                
            }
            
        }
        
        utxoToSpendArray.append(utxoArray[indexPath.section] as! [String:Any])
        addresses.append(address)
        
    }
    
    func updateInputs() {
        
        inputArray.removeAll()
        
        for utxo in self.utxoToSpendArray {
            
            let dict = utxo as! [String:Any]
            let amount = dict["amount"] as! Double
            amountTotal += amount
            let txid = dict["txid"] as! String
            let vout = dict["vout"] as! Int
            let spendable = dict["spendable"] as! Bool
            let input = "{\"txid\":\"\(txid)\",\"vout\": \(vout),\"sequence\": 1}"
            
            if !spendable {
                
                isUnsigned = true
                
            }
            
            inputArray.append(input)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = utxoTable.cellForRow(at: indexPath) {
            
            self.selectedArray[indexPath.section] = false
            
            let checkmark = cell.viewWithTag(13) as! UIImageView
            let cellTxid = (cell.viewWithTag(2) as! UILabel).text
            let cellVout = (cell.viewWithTag(6) as! UILabel).text
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    checkmark.alpha = 0
                    cell.alpha = 0
                    
                }) { _ in
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        cell.alpha = 1
                        cell.backgroundColor = self.view.backgroundColor
                        
                    }, completion: { _ in
                        
                        if self.utxoToSpendArray.count > 0 {
                            
                            let txidProcessed = cellTxid?.replacingOccurrences(of: "txid: ", with: "")
                            let voutProcessed = cellVout?.replacingOccurrences(of: "vout #", with: "")
                            
                            for (index, utxo) in (self.utxoToSpendArray as! [[String:Any]]).enumerated() {
                                
                                let txid = utxo["txid"] as! String
                                let vout = "\(utxo["vout"] as! Int)"
                                
                                if txid == txidProcessed && vout == voutProcessed {
                                    
                                    self.utxoToSpendArray.remove(at: index)
                                    self.addresses.remove(at: index)
                                    
                                }
                                
                            }
                            
                        }
                        
                    })
                    
                }
                
            }
            
        }
        
    }
    
    func parseUnspent(utxos: NSArray) {
        
        if utxos.count > 0 {
            
            self.utxoArray = (utxos as NSArray).sortedArray(using: [NSSortDescriptor(key: "confirmations", ascending: true)]) as! [[String:AnyObject]]
            
            for _ in utxoArray {
                
                self.selectedArray.append(false)
                
            }
            
            DispatchQueue.main.async {
                
                self.removeSpinner()
                self.utxoTable.reloadData()
                
            }
            
        } else {
            
            self.removeSpinner()
            
            displayAlert(viewController: self,
                         isError: true,
                         message: "No UTXO's")
            
        }
        
    }
    
    func executeNodeCommand(method: BTC_CLI_COMMAND, param: String) {
        
        let reducer = Reducer()
        
        func getResult() {
            
            if !reducer.errorBool {
                
                switch method {
                    
                case .listlockunspent:
                    
                    lockedArray = reducer.arrayToReturn
                    
                    creatingView.removeConnectingView()
                    
                    DispatchQueue.main.async {
                        
                        self.performSegue(withIdentifier: "goToLocked", sender: self)
                        
                    }
                    
                case .lockunspent:
                    
                    let result = reducer.doubleToReturn
                    removeSpinner()
                    
                    if result == 1 {
                        
                        displayAlert(viewController: self,
                                     isError: false,
                                     message: "UTXO is locked and will not be selected for spends unless your node restarts, tap the lock button to unlock it")
                        
                        self.refresh()
                        
                    } else {
                        
                        displayAlert(viewController: self,
                                     isError: true,
                                     message: "Unable to lock that UTXO")
                        
                    }
                    
                case .getnewaddress:
                    
                    let address = reducer.stringToReturn
                    let roundedAmount = rounded(number: self.amountTotal)
                    
                    let spendUtxo = SendUTXO()
                    spendUtxo.inputArray = self.inputArray
                    spendUtxo.sweep = true
                    spendUtxo.addressToPay = address
                    spendUtxo.amount = roundedAmount
                    spendUtxo.addresses = addresses
                    
                    func getResult() {
                        
                        if !spendUtxo.errorBool {
                            
                            let rawTx = spendUtxo.signedRawTx
                            
                            optimizeTheFee(raw: rawTx,
                                           amount: roundedAmount,
                                           addressToPay: address,
                                           sweep: true,
                                           inputArray: self.inputArray,
                                           changeAddress: "",
                                           changeAmount: 0.0)
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                
                                self.amountTotal = 0.0
                                self.utxoToSpendArray.removeAll()
                                self.inputArray.removeAll()
                                self.utxoTable.reloadData()
                                
                                self.removeSpinner()
                                
                                displayAlert(viewController: self,
                                             isError: true,
                                             message: spendUtxo.errorDescription)
                                
                            }
                            
                        }
                        
                    }
                    
                    spendUtxo.createRawTransaction(completion: getResult)
                    
                case .listunspent:
                    
                    let resultArray = reducer.arrayToReturn
                    parseUnspent(utxos: resultArray)
                    
                case .getrawchangeaddress:
                    
                    let changeAddress = reducer.stringToReturn
                    self.getRawTx(changeAddress: changeAddress)
                    
                default:
                    
                    break
                    
                }
                
            } else {
                
                DispatchQueue.main.async {
                    
                    self.removeSpinner()
                    
                    displayAlert(viewController: self,
                                 isError: true,
                                 message: reducer.errorDescription)
                                        
                }
                
            }
            
        }
        
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                reducer.makeCommand(walletName: wallet!.name, command: method,
                                    param: param,
                                    completion: getResult)
                
            }
            
        }
                
    }
    
    func removeSpinner() {
        
        DispatchQueue.main.async {
            
            self.refresher.endRefreshing()
            self.creatingView.removeConnectingView()
            
        }
        
    }
    
    func addSpinner() {
        
        DispatchQueue.main.async {
            
            self.creatingView.addConnectingView(vc: self,
                                                description: "Getting UTXOs")
            
        }
        
    }
    
    // MARK: QR SCANNER METHODS
    
    func configureScanner() {
        
        isFirstTime = true
        
        imageView.isUserInteractionEnabled = true
        blurView.isUserInteractionEnabled = true
        
        blurView.frame = CGRect(x: view.frame.minX + 10,
                                y: 120,
                                width: view.frame.width - 20,
                                height: 50)
        
        blurView.layer.cornerRadius = 10
        blurView.clipsToBounds = true
        
        imageView.alpha = 0
        imageView.frame = view.frame
        imageView.backgroundColor = .black
        
        qrScanner.uploadButton.addTarget(self, action: #selector(chooseQRCodeFromLibrary),
                                         for: .touchUpInside)
        
        qrScanner.textField.delegate = self
        qrScanner.keepRunning = false
        qrScanner.vc = self
        qrScanner.imageView = imageView
        qrScanner.textFieldPlaceholder = "scan address QR or type/paste here"
        qrScanner.closeButton.alpha = 0
        
        qrScanner.completion = { self.getQRCode() }
        qrScanner.didChooseImage = { self.didPickImage() }
        
        qrScanner.uploadButton.addTarget(self,
                                         action: #selector(self.chooseQRCodeFromLibrary),
                                         for: .touchUpInside)
        
        qrScanner.torchButton.addTarget(self,
                                        action: #selector(toggleTorch),
                                        for: .touchUpInside)
        
        isTorchOn = false
        
        let tapGesture2 = UITapGestureRecognizer(target: self,
                                                action: #selector(self.dismissAddressKeyboard (_:)))
        
        tapGesture2.numberOfTapsRequired = 1
        self.imageView.addGestureRecognizer(tapGesture2)
        
    }
    
    func getAddress() {
        
        self.utxoTable.isUserInteractionEnabled = false
        scannerShowing = true
        
        if isFirstTime {
            
            DispatchQueue.main.async {
                
                self.qrScanner.scanQRCode()
                self.addScannerButtons()
                self.imageView.addSubview(self.qrScanner.closeButton)
                self.isFirstTime = false
                self.imageView.alpha = 1
                self.blurView2.removeFromSuperview()
                self.creatingView.removeConnectingView()
                
            }
            
        } else {
            
            self.qrScanner.startScanner()
            self.addScannerButtons()
            
            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.imageView.alpha = 1
                    
                })
                
            }
            
        }
        
    }
    
    func addScannerButtons() {
        
        imageView.addSubview(blurView)
        blurView.contentView.addSubview(qrScanner.textField)
        
        self.addBlurView(frame: CGRect(x: self.imageView.frame.maxX - 80,
                                       y: self.imageView.frame.maxY - 80,
                                       width: 70,
                                       height: 70), button: self.qrScanner.uploadButton)
        
        self.addBlurView(frame: CGRect(x: 10,
                                       y: self.imageView.frame.maxY - 80,
                                       width: 70,
                                       height: 70), button: self.qrScanner.torchButton)
        
    }
    
    func getQRCode() {
        
        let stringURL = qrScanner.stringToReturn
        self.address = stringURL
        processBIP21(url: stringURL)
        
    }
    
    @objc func goBack() {
        print("goBack")
        
        DispatchQueue.main.async {
            
            self.imageView.alpha = 0
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
    
    func addBlurView(frame: CGRect, button: UIButton) {
        
        button.removeFromSuperview()
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        blur.frame = frame
        blur.clipsToBounds = true
        blur.layer.cornerRadius = frame.width / 2
        blur.contentView.addSubview(button)
        self.imageView.addSubview(blur)
        
    }
    
    func didPickImage() {
        
        let qrString = qrScanner.qrString
        self.address = qrString
        processBIP21(url: qrString)
        
    }
    
    @objc func chooseQRCodeFromLibrary() {
        
        qrScanner.chooseQRCodeFromLibrary()
        
    }
    
    func getRawTx(changeAddress: String) {
        print("getRawTx")
        
        let dbl = Double(amountToSend)!
        let roundedAmount = rounded(number: dbl)
        
        var total = Double()
        
        for utxoDict in utxoToSpendArray {
            
            let utxo = utxoDict as! NSDictionary
            let amount = utxo["amount"] as! Double
            total += amount
            
        }
        // we set a dummy fee just to get a dummy raw transaction so we know what the size will be for fee optimisation
        let changeAmount = total - (dbl + 0.00050000)
        
        let rawTransaction = SendUTXO()
        rawTransaction.addressToPay = self.address
        rawTransaction.changeAddress = changeAddress
        rawTransaction.amount = roundedAmount
        rawTransaction.changeAmount = rounded(number: changeAmount)
        rawTransaction.sweep = self.isSweeping
        rawTransaction.inputArray = self.inputArray
        rawTransaction.addresses = addresses
        
        func getResult() {
            
            if !rawTransaction.errorBool {
                
                let rawTxSigned = rawTransaction.signedRawTx
                
                optimizeTheFee(raw: rawTxSigned,
                               amount: roundedAmount,
                               addressToPay: self.address,
                               sweep: self.isSweeping,
                               inputArray: self.inputArray,
                               changeAddress: changeAddress,
                               changeAmount: rounded(number: changeAmount))
                
            } else {
                
                creatingView.removeConnectingView()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: rawTransaction.errorDescription)
                
            }
            
        }
        
        rawTransaction.createRawTransaction(completion: getResult)
        
    }
    
   func createRawNow() {
        
        if !isSweeping {
            
            //not sweeping so need to get change address
            self.executeNodeCommand(method: .getrawchangeaddress,
                                       param: "")
            
        } else {
            
            let dbl = Double(amountToSend)!
            let roundedAmount = rounded(number: dbl)
            
            let rawTransaction = SendUTXO()
            rawTransaction.addressToPay = self.address
            rawTransaction.amount = roundedAmount
            rawTransaction.sweep = self.isSweeping
            rawTransaction.inputArray = self.inputArray
            rawTransaction.addresses = self.addresses
            
            func getResult() {
                
                if !rawTransaction.errorBool {
                    
                    let rawTxSigned = rawTransaction.signedRawTx
                    
                    optimizeTheFee(raw: rawTxSigned,
                                   amount: roundedAmount,
                                   addressToPay: self.address,
                                   sweep: self.isSweeping,
                                   inputArray: self.inputArray,
                                   changeAddress: "",
                                   changeAmount: 0.0)
                    
                } else {
                    
                    creatingView.removeConnectingView()
                    
                    displayAlert(viewController: self,
                                 isError: true,
                                 message: rawTransaction.errorDescription)
                    
                }
                
            }
            
            rawTransaction.createRawTransaction(completion: getResult)
            
        }
        
    }
    
    func optimizeTheFee(raw: String, amount: Double, addressToPay: String, sweep: Bool, inputArray: [Any], changeAddress: String, changeAmount: Double) {
        
//        let getSmartFee = GetSmartFee()
//        getSmartFee.rawSigned = raw
//        getSmartFee.vc = self
//        
//        func getFeeResult() {
//            
//            let optimalFee = rounded(number: getSmartFee.optimalFee)
//            let spendUtxo = SendUTXO()
//            spendUtxo.sweep = sweep
//            spendUtxo.addressToPay = addressToPay
//            spendUtxo.inputArray = inputArray
//            spendUtxo.changeAddress = changeAddress
//            spendUtxo.addresses = addresses
//            
//            // sender always pays the fee
//            if !sweep {
//                
//                // if not sweeping then nullify the fixed fee we added initially and then reduce the optimal fee from the change output, receiver gets what is intended
//                let roundChange = rounded(number: (changeAmount + 0.00050000) - optimalFee)
//                spendUtxo.changeAmount = roundChange
//                let rnd = rounded(number: amount)
//                spendUtxo.amount = rnd
//                
//            } else {
//                
//                // if sweeping just reduce the overall amount by the optimal fee
//                let rnd = rounded(number: amount - optimalFee)
//                spendUtxo.amount = rnd
//                
//            }
//            
//            func getResult() {
//                
//                if !spendUtxo.errorBool {
//                    
//                    let rawTx = spendUtxo.signedRawTx
//                    
//                    DispatchQueue.main.async {
//                    
//                        self.rawSigned = rawTx
//                        DispatchQueue.main.async {
//                            self.performSegue(withIdentifier: "confirmUtxoSpend", sender: self)
//                        }
//                    
//                    }
//                    
//                } else {
//                    
//                    DispatchQueue.main.async {
//                        
//                        self.removeSpinner()
//                        
//                        displayAlert(viewController: self,
//                                     isError: true,
//                                     message: spendUtxo.errorDescription)
//                        
//                    }
//                    
//                }
//                
//            }
//            
//            spendUtxo.createRawTransaction(completion: getResult)
//            
//        }
//        
//        getSmartFee.getSmartFee(completion: getFeeResult)
        
    }
    
    // MARK: TEXTFIELD METHODS
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        
        if textField == qrScanner.textField && qrScanner.textField.text != "" {
            
            processBIP21(url: qrScanner.textField.text!)
            
        } else if textField == self.qrScanner.textField && self.qrScanner.textField.text == "" {
            
            shakeAlert(viewToShake: self.qrScanner.textField)
            
        }
        
        return true
    }
    
    func processBIP21(url: String) {
        
        creatingView.addConnectingView(vc: self, description: "")
        
        let addressParser = AddressParser()
        let errorBool = addressParser.parseAddress(url: url).errorBool
        let errorDescription = addressParser.parseAddress(url: url).errorDescription
        
        if !errorBool {
            
            self.address = addressParser.parseAddress(url: url).address
            
            DispatchQueue.main.async {
                
                self.qrScanner.textField.resignFirstResponder()
                
                for blur in self.blurArray {
                    
                    blur.removeFromSuperview()
                    
                }
                
                self.blurView.removeFromSuperview()
                self.qrScanner.removeScanner()
                self.createRawNow()
                
            }
            
            if isTorchOn {
                
                toggleTorch()
                
            }
            
            DispatchQueue.main.async {
                
                let impact = UIImpactFeedbackGenerator()
                impact.impactOccurred()
                
            }
            
        } else {
            
            displayAlert(viewController: self,
                         isError: true,
                         message: errorDescription)
            
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField != amountInput {
            
            if textField.text != "" {
                
                textField.becomeFirstResponder()
                
            } else {
                
                if let string = UIPasteboard.general.string {
                    
                    textField.resignFirstResponder()
                    textField.text = string
                    self.processBIP21(url: string)
                    
                } else {
                    
                    textField.becomeFirstResponder()
                    
                }
                
            }
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField != amountInput {
            
            if textField.text != "" {
                
                self.processBIP21(url: textField.text!)
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "goToLocked":
            
            if let vc = segue.destination as? LockedViewController {
                
                vc.lockedArray = self.lockedArray
                
            }
            
        case "confirmUtxoSpend":
            
            if let vc = segue.destination as? ConfirmViewController {
                
                vc.signedRawTx = self.rawSigned
                
            }
            
        default:
            
            break
            
        }
        
    }
    
}

extension Int {
    
    var avoidNotation: String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
        
    }
}



