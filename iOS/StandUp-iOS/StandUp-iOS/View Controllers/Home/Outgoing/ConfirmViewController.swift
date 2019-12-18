//
//  ConfirmViewController.swift
//  BitSense
//
//  Created by Peter on 12/12/19.
//  Copyright © 2019 Fontaine. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    let creatingView = ConnectingView()
    
    var signedRawTx = ""
    var outputsString = ""
    var inputsString = ""
    var inputArray = [[String:Any]]()
    var index = Int()
    var inputTotal = Double()
    var outputTotal = Double()
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        creatingView.addConnectingView(vc: self,
                                       description: "analyzing signed transaction")
        
        executeNodeCommand(method: .decoderawtransaction,
                           param: "\"\(signedRawTx)\"")
        
    }
    
    @IBAction func sendNow(_ sender: Any) {
        
        creatingView.addConnectingView(vc: self,
                                       description: "broadcasting raw transaction")
        
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
                        self.textView.text = "Transaction ID:\n\n\(result)"
                        
                        displayAlert(viewController: self,
                                     isError: false,
                                     message: "Transaction sent ✓")
                        
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
        
        reducer.makeCommand(command: method,
                            param: param,
                            completion: getResult)
        
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
            
            for a in addresses {
                
                addressString += a as! String + " "
                
            }
            
            outputTotal += amount
            outputsString += "Output #\(number):\nAmount: \(amount.avoidNotation)\nAddress: \(addressString)\n\n"
            
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
                
                for a in addresses {
                    
                    addressString += a as! String + " "
                    
                }
                
                inputTotal += amount
                inputsString += "Input #\(index + 1):\nAmount: \(amount.avoidNotation)\nAddress: \(addressString)\n\n"
                
            }
            
        }
        
        if index + 1 < inputArray.count {
            
            index += 1
            getInputInfo(index: index)
            
        } else if index + 1 == inputArray.count {
            
            DispatchQueue.main.async {
                
                let txfee = (self.inputTotal - self.outputTotal).avoidNotation
                let miningFee = "Mining Fee: \(txfee)"
                self.textView.text = self.inputsString + "\n\n\n" + self.outputsString + "\n\n\n" + miningFee
                self.creatingView.removeConnectingView()
                
            }
            
        }
        
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
                    
                    parsePrevTx(method: BTC_CLI_COMMAND.decoderawtransaction,
                                param: "\"\(rawTransaction)\"",
                                vout: vout)
                    
                default:
                    
                    break
                    
                }
                
            }
            
        }
        
        reducer.makeCommand(command: method,
                            param: param,
                            completion: getResult)
        
    }

}
