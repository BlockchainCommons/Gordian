//
//  DerivationViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 07/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class DerivationViewController: UIViewController, UINavigationControllerDelegate {
    
    var words = ""
    var derivation = ""
    var isTestnet = Bool()
    let connectingView = ConnectingView()
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var derivationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        derivationLabel.text = derivation + "/*"
        
        if derivation.contains("1'") {
            
            isTestnet = true
            
        }
        
        switch derivation {
            
        case "m/84'/0'/0'/0", "m/84'/1'/0'/0":
            
            segmentedControl.selectedSegmentIndex = 1
            
        case "m/44'/0'/0'/0", "m/44'/1'/0'/0":
            
            segmentedControl.selectedSegmentIndex = 0
            
        case "m/49'/0'/0'/0", "m/49'/1'/0'/0":
            
            segmentedControl.selectedSegmentIndex = 2
            
        default:
            
            break
            
        }
        
    }
    
    @IBAction func switchDerivation(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            
            DispatchQueue.main.async {
                
                if self.isTestnet {
                    
                    self.derivationLabel.text = "m/44'/1'/0'/0/*"
                    
                } else {
                    
                    self.derivationLabel.text = "m/44'/0'/0'/0/*"
                    
                }
                
            }
            
        case 1:
            
            DispatchQueue.main.async {
                
                if self.isTestnet {
                    
                    self.derivationLabel.text = "m/84'/1'/0'/0/*"
                    
                } else {
                    
                    self.derivationLabel.text = "m/84'/0'/0'/0/*"
                    
                }
                
            }
            
        case 2:
            
            DispatchQueue.main.async {
                
                if self.isTestnet {
                    
                    self.derivationLabel.text = "m/49'/1'/0'/0/*"
                    
                } else {
                    
                    self.derivationLabel.text = "m/49'/0'/0'/0/*"
                    
                }
                
            }
            
        default:
            
            break
            
        }
        
        showAlert()
        
    }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Notice", message: "Changing the derivation scheme will create a new wallet with the exisiting seed, the current wallet is saved and can be accessed and reactivated at any time", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Create New Wallet", style: .default, handler: { action in
            
            self.connectingView.addConnectingView(vc: self.navigationController!, description: "deriving keys for verification")
            self.createNewWallet()

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in

            DispatchQueue.main.async {
                
                switch self.derivation {
                    
                case "m/84'/0'/0'/0", "m/84'/1'/0'/0":
                    
                    self.segmentedControl.selectedSegmentIndex = 1
                    
                case "m/44'/0'/0'/0", "m/44'/1'/0'/0":
                    
                    self.segmentedControl.selectedSegmentIndex = 0
                    
                case "m/49'/0'/0'/0", "m/49'/1'/0'/0":
                    
                    self.segmentedControl.selectedSegmentIndex = 2
                    
                default:
                    
                    break
                    
                }
                
                self.derivationLabel.text = self.derivation
                
                //self.navigationController?.popToRootViewController(animated: true)
                
            }

        }))
                
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createNewWallet() {
        
        let path = (self.derivationLabel.text)!.replacingOccurrences(of: "/*", with: "")
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                DispatchQueue.main.async {
                    
                    self.derivation = path
                    
                    let encryptedseed = wallet!.seed
                    let enc = Encryption()
                    
                    enc.decryptData(dataToDecrypt: encryptedseed) { (decryptedseed) in
                        
                        if decryptedseed != nil {
                            
                            self.words = String(bytes: decryptedseed!, encoding: .utf8)!
                            self.connectingView.removeConnectingView()
                            self.performSegue(withIdentifier: "verifyDerivation", sender: self)
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                self.connectingView.removeConnectingView()
                displayAlert(viewController: self, isError: true, message: "error getting seed")
                
            }
            
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let id = segue.identifier
        
        switch id {
            
        case "verifyDerivation":
            
            if let vc = segue.destination as? VerifyKeysViewController {
                
                vc.derivation = self.derivation
                vc.words = self.words
                vc.comingFromSettings = false
                
            }
            
        default:
            
            break
            
        }
        
    }
    

}
