//
//  LockedViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

class LockedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lockedArray = NSArray()
    var helperArray = [[String:Any]]()
    let creatingView = ConnectingView()
    var selectedVout = Int()
    var selectedTxid = ""
    var ind = 0
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        DispatchQueue.main.async {
            
            self.creatingView.addConnectingView(vc: self,
                                                description: "Getting Locked UTXOs")
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getHelperArray()
        
    }
    
    func getHelperArray() {
        
        helperArray.removeAll()
        
        ind = 0
        
        if lockedArray.count > 0 {
            
            for utxo in lockedArray {
                
                let dict = utxo as! NSDictionary
                let txid = dict["txid"] as! String
                let vout = dict["vout"] as! Int
                
                let helperDict = ["txid":txid,
                                  "vout":vout,
                                  "amount":0.0] as [String : Any]
                
                helperArray.append(helperDict)
                
            }
            
            getAmounts(i: ind)
            
        } else {
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
                self.creatingView.removeConnectingView()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: "No locked UTXO's")
                
            }
            
        }
        
    }
    
    func getAmounts(i: Int) {
        
        if i <= helperArray.count - 1 {
            
            selectedTxid = helperArray[i]["txid"] as! String
            selectedVout = helperArray[i]["vout"] as! Int
            
            executeNodeCommand(method: .getrawtransaction,
                               param: "\"\(selectedTxid)\", true")
            
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return helperArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "lockedCell", for: indexPath)
        
        let amountLabel = cell.viewWithTag(1) as! UILabel
        let voutLabel = cell.viewWithTag(2) as! UILabel
        let txidLabel = cell.viewWithTag(3) as! UILabel
        
        let dict = helperArray[indexPath.row]
        let txid = dict["txid"] as! String
        let vout = dict["vout"] as! Int
        let amount = dict["amount"] as! Double
        
        amountLabel.text = "\(amount)"
        voutLabel.text = "vout #\(vout)"
        txidLabel.text = "txid" + " " + txid
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 113
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let utxo = helperArray[indexPath.row]
        let txid = utxo["txid"] as! String
        let vout = utxo["vout"] as! Int
        
        let contextItem = UIContextualAction(style: .destructive, title: "Unlock") {  (contextualAction, view, boolValue) in
            
            self.unlockUTXO(txid: txid, vout: vout)
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        contextItem.backgroundColor = .blue

        return swipeActions
    }
    
    func unlockUTXO(txid: String, vout: Int) {
        
        let param = "true, ''[{\"txid\":\"\(txid)\",\"vout\":\(vout)}]''"
        
        executeNodeCommand(method: BTC_CLI_COMMAND.lockunspent,
                           param: param)
        
    }
    
    
    func executeNodeCommand(method: BTC_CLI_COMMAND, param: String) {
        
        let reducer = Reducer()
        
        func getResult() {
            
            if !reducer.errorBool {
                
                switch method {
                    
                case .getrawtransaction:
                    
                    let dict = reducer.dictToReturn
                    let outputs = dict["vout"] as! NSArray
                    
                    for (i, outputDict) in outputs.enumerated() {
                        
                        let output = outputDict as! NSDictionary
                        let value = output["value"] as! Double
                        let vout = output["n"] as! Int
                        
                        if vout == selectedVout {
                            
                            helperArray[ind]["amount"] = value
                            ind = ind + 1
                            
                        }
                        
                        if i + 1 == outputs.count {
                            
                            if ind <= helperArray.count - 1 {
                                
                                getAmounts(i: ind)
                                
                            } else {
                                
                                DispatchQueue.main.async {
                                    
                                    self.tableView.reloadData()
                                    self.creatingView.removeConnectingView()
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                case .listlockunspent:
                    
                    lockedArray = reducer.arrayToReturn
                    getHelperArray()
                    
                case .lockunspent:
                    
                    let result = reducer.doubleToReturn
                    
                    if result == 1 {
                        
                        displayAlert(viewController: self,
                                     isError: false,
                                     message: "UTXO is unlocked and can be selected for spends")
                        
                    } else {
                        
                        displayAlert(viewController: self,
                                     isError: true,
                                     message: "Unable to unlock that UTXO")
                        
                    }
                    
                    helperArray.removeAll()
                    
                    executeNodeCommand(method: .listlockunspent,
                                       param: "")
                    
                    DispatchQueue.main.async {
                        
                        self.creatingView.addConnectingView(vc: self,
                                                            description: "Refreshing")
                        
                    }
                    
                default:
                    
                    break
                    
                }
                
            } else {
                
                DispatchQueue.main.async {
                    
                    self.creatingView.removeConnectingView()
                    
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
    
}
