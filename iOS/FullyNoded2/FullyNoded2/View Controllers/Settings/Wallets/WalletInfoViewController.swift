//
//  WalletInfoViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 14/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class WalletInfoViewController: UIViewController {

    var walletname = ""
    let connectingView = ConnectingView()
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectingView.addConnectingView(vc: self, description: "getting wallet info")
        getWalletInfo()
        
    }
    
    func getWalletInfo() {
        
        getActiveWalletNow { (wallet, error) in
            
            if !error && wallet != nil {
                
                let reducer = Reducer()
                reducer.makeCommand(walletName: wallet!.name, command: .getwalletinfo, param: "") {
                    
                    if !reducer.errorBool {
                        
                        DispatchQueue.main.async {
                            
                            self.textView.text = "\(reducer.dictToReturn)"
                            self.connectingView.removeConnectingView()
                            
                        }
                        
                    } else {
                                        
                        self.connectingView.removeConnectingView()
                        displayAlert(viewController: self, isError: true, message: reducer.errorDescription)
                        
                    }
                    
                }
                
            }
            
        }
        
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
