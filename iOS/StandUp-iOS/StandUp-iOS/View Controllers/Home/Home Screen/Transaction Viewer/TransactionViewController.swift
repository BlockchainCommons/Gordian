//
//  TransactionViewController.swift
//  BitSense
//
//  Created by Peter on 22/07/19.
//  Copyright © 2019 Fontaine. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {
    
    var txid = ""
    let creatingView = ConnectingView()
    
    @IBOutlet var textView: UITextView!
    
    @IBAction func back(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatingView.addConnectingView(vc: self,
                                       description: "getting transaction")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        executeNodeCommand(method: BTC_CLI_COMMAND.gettransaction,
                              param: "\"\(txid)\", true")
        
    }

    func executeNodeCommand(method: BTC_CLI_COMMAND, param: String) {
        
        let reducer = Reducer()
        
        func getResult() {
            
            if !reducer.errorBool {
                
                switch method {
                    
                case BTC_CLI_COMMAND.gettransaction:
                    
                    let dict = reducer.dictToReturn
                    
                    DispatchQueue.main.async {
                        
                        self.textView.text = "\(reducer.dictToReturn)"
                        self.creatingView.removeConnectingView()
                        
                    }
                    
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

}
