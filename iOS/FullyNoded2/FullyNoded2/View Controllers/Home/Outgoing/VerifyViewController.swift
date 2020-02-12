//
//  VerifyViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 03/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {

    var address = ""
    let connectingView = ConnectingView()
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("address = \(address)")
        connectingView.addConnectingView(vc: self, description: "getting address info")
        getAddressInfo(address: address)
        
    }
    
    func getAddressInfo(address: String) {
        
        let reducer = Reducer()
        
        func getResult() {
            
            if !reducer.errorBool {
                
                let dict = reducer.dictToReturn
                
                DispatchQueue.main.async {
                    
                    self.connectingView.removeConnectingView()
                    self.textView.text = "\(dict)"
                    
                }
                
            } else {
                
                self.connectingView.removeConnectingView()
                displayAlert(viewController: self, isError: true, message: reducer.errorDescription)
                
            }
            
        }
        
        let param = "\"\(address)\""
        
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                reducer.makeCommand(walletName: wallet!.name, command: .getaddressinfo,
                                    param: param,
                                    completion: getResult)
                
            }
            
        }
        
    }

}
