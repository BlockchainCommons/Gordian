//
//  ConfirmViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let creatingView = ConnectingView()
    var signedRawTx = ""
    var outputsString = ""
    var inputsString = ""
    var inputArray = [[String:Any]]()
    var inputTableArray = [[String:Any]]()
    var outputArray = [[String:Any]]()
    var index = Int()
    var inputTotal = Double()
    var outputTotal = Double()
    var miningFee = ""
    var recipients = [String]()
    var addressToVerify = ""
    @IBOutlet var playButton: UIBarButtonItem!
    @IBOutlet var confirmTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("recipients = \(recipients)")
        
        navigationController?.delegate = self

        creatingView.addConnectingView(vc: self,
                                       description: "verifying signed transaction")
        
        executeNodeCommand(method: .decoderawtransaction,
                           param: "\"\(signedRawTx)\"")
        
    }
    
    @IBAction func sendNow(_ sender: Any) {
        
        creatingView.addConnectingView(vc: self,
                                       description: "broadcasting transaction")
        
        executeNodeCommand(method: .sendrawtransaction,
                           param: "\"\(signedRawTx)\"")
        
    }
    
    

    func executeNodeCommand(method: BTC_CLI_COMMAND, param: String) {
        
        let reducer = Reducer()
        
        func getResult() {
            
            if !reducer.errorBool {
                
                switch method {
                    
                case .sendrawtransaction:
                    
                    let result = reducer.stringToReturn
                    
                    DispatchQueue.main.async {
                        
                        UIPasteboard.general.string = result
                        self.creatingView.removeConnectingView()
                        self.navigationItem.title = "Sent ✓"
                        self.playButton.tintColor = UIColor.white.withAlphaComponent(0)
                        
                        displayAlert(viewController: self,
                                     isError: false,
                                     message: "Transaction sent ✓")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                    }
                    
                case .decoderawtransaction:
                    
                    let dict = reducer.dictToReturn
                    
                    // parse the inputs and outputs and display to user
                    parseTransaction(tx: dict)
                    
                default:
                    
                    break
                    
                }
                
            } else {
                
                creatingView.removeConnectingView()
                                
                displayAlert(viewController: self,
                             isError: true,
                             message: reducer.errorDescription)
                
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
    
    func parseTransaction(tx: NSDictionary) {
        
        let inputs = tx["vin"] as! NSArray
        let outputs = tx["vout"] as! NSArray
        parseOutputs(outputs: outputs)
        parseInputs(inputs: inputs, completion: getFirstInputInfo)
        
    }
    
    func getFirstInputInfo() {
        
        index = 0
        getInputInfo(index: index)
        
    }
    
    func getInputInfo(index: Int) {
        
        let dict = inputArray[index]
        let txid = dict["txid"] as! String
        let vout = dict["vout"] as! Int
        
        parsePrevTx(method: .getrawtransaction,
                    param: "\"\(txid)\"",
                    vout: vout)
        
    }
    
    func parseInputs(inputs: NSArray, completion: @escaping () -> Void) {
        
        for (index, i) in inputs.enumerated() {
            
            let input = i as! NSDictionary
            let txid = input["txid"] as! String
            let vout = input["vout"] as! Int
            let dict = ["inputNumber":index + 1, "txid":txid, "vout":vout as Any] as [String : Any]
            inputArray.append(dict)
            
            if index + 1 == inputs.count {
                
                completion()
                
            }
            
        }
        
    }
    
    func parseOutputs(outputs: NSArray) {
        
        for (i, o) in outputs.enumerated() {
            
            let output = o as! NSDictionary
            let scriptpubkey = output["scriptPubKey"] as! NSDictionary
            let addresses = scriptpubkey["addresses"] as? NSArray ?? []
            let amount = output["value"] as! Double
            let number = i + 1
            var addressString = ""
            
            if addresses.count > 1 {
                
                for a in addresses {
                    
                    addressString += a as! String + " "
                    
                }
                
            } else {
                
                addressString = addresses[0] as! String
                
            }
            
            outputTotal += amount
            outputsString += "Output #\(number):\nAmount: \(amount.avoidNotation)\nAddress: \(addressString)\n\n"
            var isChange = true
            
            for recipient in recipients {
                
                if addressString == recipient {
                    
                    isChange = false
                    
                }
                
            }
            
            let outputDict:[String:Any] = [
            
                "index": number,
                "amount": amount.avoidNotation,
                "address": addressString,
                "isChange": isChange
            
            ]
            
            print("outputdict = \(outputDict)")
            
            outputArray.append(outputDict)
            
        }
        
    }
    
    func parsePrevTxOutput(outputs: NSArray, vout: Int) {
        
        for o in outputs {
            
            let output = o as! NSDictionary
            let n = output["n"] as! Int
            
            if n == vout {
                
                //this is our inputs output, get amount and address
                let scriptpubkey = output["scriptPubKey"] as! NSDictionary
                let addresses = scriptpubkey["addresses"] as! NSArray
                let amount = output["value"] as! Double
                var addressString = ""
                
                if addresses.count > 1 {
                    
                    for a in addresses {
                        
                        addressString += a as! String + " "
                        
                    }
                    
                } else {
                    
                    addressString = addresses[0] as! String
                    
                }
                
                inputTotal += amount
                inputsString += "Input #\(index + 1):\nAmount: \(amount.avoidNotation)\nAddress: \(addressString)\n\n"
                
                let inputDict:[String:Any] = [
                
                    "index": index + 1,
                    "amount": amount.avoidNotation,
                    "address": addressString
                
                ]
                
                inputTableArray.append(inputDict)
                
            }
            
        }
        
        if index + 1 < inputArray.count {
            
            index += 1
            getInputInfo(index: index)
            
        } else if index + 1 == inputArray.count {
            
            let txfee = (self.inputTotal - self.outputTotal).avoidNotation
            self.miningFee = "\(txfee) btc"
            loadTableData()
            
        }
        
    }
    
    func loadTableData() {
        
        DispatchQueue.main.async {
            
            self.confirmTable.reloadData()
            
        }
        
        self.creatingView.removeConnectingView()
    }
    
    func parsePrevTx(method: BTC_CLI_COMMAND, param: String, vout: Int) {
        
        let reducer = Reducer()
        
        func getResult() {
            
            if !reducer.errorBool {
                
                switch method {
                    
                case .decoderawtransaction:
                    
                    let txDict = reducer.dictToReturn
                    let outputs = txDict["vout"] as! NSArray
                    parsePrevTxOutput(outputs: outputs, vout: vout)
                    
                case .getrawtransaction:
                    
                    let rawTransaction = reducer.stringToReturn
                    
                    parsePrevTx(method: .decoderawtransaction,
                                param: "\"\(rawTransaction)\"",
                                vout: vout)
                    
                default:
                    
                    break
                    
                }
                
            } else {
                
                creatingView.removeConnectingView()
                displayAlert(viewController: self, isError: true, message: "Error parsing inputs")
                
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            
            return inputArray.count
            
        case 1:
            
            return outputArray.count
            
        case 2:
            
            return 1
            
        default:
            
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case 0, 1:
            
            return 78
            
        case 2:
            
            return 44
            
        default:
            
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let inputCell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath)
            let inputIndexLabel = inputCell.viewWithTag(1) as! UILabel
            let inputAmountLabel = inputCell.viewWithTag(2) as! UILabel
            let inputAddressLabel = inputCell.viewWithTag(3) as! UILabel
            let input = inputTableArray[indexPath.row]
            inputIndexLabel.text = "Input #\(input["index"] as! Int)"
            inputAmountLabel.text = "\((input["amount"] as! String)) btc"
            inputAddressLabel.text = (input["address"] as! String)
            inputAddressLabel.adjustsFontSizeToFitWidth = true
            inputCell.selectionStyle = .none
            return inputCell
            
        case 1:
            
            let outputCell = tableView.dequeueReusableCell(withIdentifier: "outputCell", for: indexPath)
            let outputIndexLabel = outputCell.viewWithTag(1) as! UILabel
            let outputAmountLabel = outputCell.viewWithTag(2) as! UILabel
            let outputAddressLabel = outputCell.viewWithTag(3) as! UILabel
            let changeLabel = outputCell.viewWithTag(4) as! UILabel
            changeLabel.textColor = .darkGray
            let output = outputArray[indexPath.row]
            let address = (output["address"] as! String)
            let isChange = (output["isChange"] as! Bool)
            
            if isChange {
                
                outputAddressLabel.textColor = .darkGray
                outputAmountLabel.textColor = .darkGray
                outputIndexLabel.textColor = .darkGray
                changeLabel.alpha = 1
                
            } else {
                
                outputAddressLabel.textColor = .white
                outputAmountLabel.textColor = .white
                outputIndexLabel.textColor = .white
                changeLabel.alpha = 0
                
            }
            
            outputIndexLabel.text = "Output #\(output["index"] as! Int)"
            outputAmountLabel.text = "\((output["amount"] as! String)) btc"
            outputAddressLabel.text = address
            outputAddressLabel.adjustsFontSizeToFitWidth = true
            outputCell.selectionStyle = .none
            return outputCell
            
        case 2:
            
            let miningFeeCell = tableView.dequeueReusableCell(withIdentifier: "miningFeeCell", for: indexPath)
            let miningLabel = miningFeeCell.viewWithTag(1) as! UILabel
            miningLabel.text = self.miningFee
            miningFeeCell.selectionStyle = .none
            return miningFeeCell
            
        default:
            
            return UITableViewCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionString = ""
        
        switch section {
        case 0:
            sectionString = "Inputs"
        case 1:
            sectionString = "Outputs"
        case 2:
            sectionString = "Mining Fee"
        default:
            break
        }
        
        return sectionString
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)//UIFont.systemFont(ofSize: 12)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.alpha = 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 30
            
        } else {
            
            return 20
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 || indexPath.section == 1 {
            
            let cell = tableView.cellForRow(at: indexPath)!
            let impact = UIImpactFeedbackGenerator()
            let addressLabel = cell.viewWithTag(3) as! UILabel
            self.addressToVerify = addressLabel.text!
            
            DispatchQueue.main.async {
                
                impact.impactOccurred()
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    cell.alpha = 0
                    
                }) { _ in
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        cell.alpha = 1
                        
                    }) { _ in
                        
                        DispatchQueue.main.async {
                            
                            self.performSegue(withIdentifier: "verify", sender: self)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "verify":
            
            if let vc = segue.destination as? VerifyViewController {
                
                vc.address = self.addressToVerify
                
            }
            
        default:
            
            break
            
        }
        
    }

}
