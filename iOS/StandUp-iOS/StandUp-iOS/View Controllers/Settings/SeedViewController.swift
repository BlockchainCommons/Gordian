//
//  SeedViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

class SeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var seed = ""
    var itemToDisplay = ""
    var infoText = ""
    var barTitle = ""
    var privateKeyDescriptor = ""
    var publicKeyDescriptor = ""
    var birthdate = "\"now\""
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let birthdateCheck = UserDefaults.standard.object(forKey: "birthdate") as? Int {
            
            birthdate = "\(birthdateCheck)"
            
        }
        
        loadData()
        
    }
    
    func loadData() {
        
        self.xprv { (xprv) in
            
            if xprv != "" {
                
                self.privateKeyDescriptor = "wpkh(\(xprv)/*)"
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                
                print("error getting xprv")
                displayAlert(viewController: self, isError: true, message: "Error getting your xprv")
                
            }
            
        }
        
        self.xpub { (xpub) in
            
            if xpub != "" {
                
                self.publicKeyDescriptor = "wpkh(\(xpub)/*)"
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                
                print("error getting xpub")
                displayAlert(viewController: self, isError: true, message: "Error getting your xpub")
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.backgroundColor = #colorLiteral(red: 0.0507061556, green: 0.05862525851, blue: 0.0711022839, alpha: 1)
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        
        switch indexPath.section {
            
        case 0:
    
            cell.textLabel?.text = seed
                        
        case 1:
            
            cell.textLabel?.text = UserDefaults.standard.object(forKey: "derivation") as? String
            
        case 2:
            
            cell.textLabel?.text = self.publicKeyDescriptor
            
        case 3:
            
            cell.textLabel?.text = self.privateKeyDescriptor
            
        case 4:
            
            cell.textLabel?.text = "bitcoin-cli importmulti { \"desc\": \"\(self.privateKeyDescriptor)\", \"timestamp\": \(birthdate), \"range\": [0,999], \"watchonly\": false, \"label\": \"StandUp\", \"keypool\": true, \"internal\": false }\n\nbitcoin-cli importmulti { \"desc\": \"\(self.privateKeyDescriptor)\", \"timestamp\": \(birthdate), \"range\": [1000,1999], \"watchonly\": false, \"keypool\": true, \"internal\": true }"
            
        default:
            
            return UITableViewCell()
            
        }
        
        cell.sizeToFit()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0: return "BIP39 Phrase"
        case 1: return "Derivation Path"
        case 2: return "Public Key Descriptor"
        case 3: return "Private Key Descriptor"
        case 4: return "Bitcoin Core Recovery"
        default: return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            
            let cell = tableView.cellForRow(at: indexPath)
            self.itemToDisplay = cell!.textLabel!.text!
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
            UIView.animate(withDuration: 0.2, animations: {
                
                cell?.alpha = 0
                
            }) { _ in
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    cell?.alpha = 1
                    
                }) { _ in
                    
                    switch indexPath.section {
                        
                    case 0:
                        
                        self.infoText = "Your BIP39 recovery phrase which can be imported into BIP39 compatible wallets, by default StandUp does not create a password for your recovery phrase."
                        self.barTitle = "BIP39 Phrase"
                        self.goToQRDisplayer()
                        
                    case 2:
                        
                        self.infoText = "Your public key descriptor which can be used with the importmulti command to create a watch-only wallet with Bitcoin Core."
                        self.barTitle = "Pubkey Descriptor"
                        self.goToQRDisplayer()
                        
                    case 3:
                        
                        self.infoText = "Your private key descriptor which can be used with the importmulti command to recover your StandUp wallet with Bitcoin Core."
                        self.barTitle = "Private Key Descriptor"
                        self.goToQRDisplayer()
                        
                    case 4:
                        
                        self.shareRecoveryCommand()
                        
                    default:
                        
                        break
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func goToQRDisplayer() {
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showQR", sender: self)
        }
    }
    
    func xpub(completion: @escaping ((String)) -> Void) {
        
        let keyFetcher = KeyFetcher()
        keyFetcher.bip32Xpub { (xpub, error) in
            
            if !error {
                
                completion((xpub))
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error retrieving your xpub")
                completion((""))
                
            }
            
        }
        
    }
    
    func xprv(completion: @escaping ((String)) -> Void) {
        
        let keyFetcher = KeyFetcher()
        keyFetcher.bip32Xprv { (xprv, error) in
            
            if !error {
                
                completion((xprv))
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error retrieving your xprv")
                completion((""))
                
            }
            
        }
        
    }
    
    func shareRecoveryCommand() {
        
        DispatchQueue.main.async {
                            
            let textToShare = ["bitcoin-cli importmulti { \"desc\": \"\(self.privateKeyDescriptor)\", \"timestamp\": \(self.birthdate), \"range\": [0,999], \"watchonly\": false, \"label\": \"StandUp\", \"keypool\": true, \"internal\": false }\n\nbitcoin-cli importmulti { \"desc\": \"\(self.privateKeyDescriptor)\", \"timestamp\": \(self.birthdate), \"range\": [1000,1999], \"watchonly\": false, \"keypool\": true, \"internal\": true }"]
            
            let activityViewController = UIActivityViewController(activityItems: textToShare,
                                                                  applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true) {}
            
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let id = segue.identifier
        
        switch id {
            
        case "showQR":
            
            if let vc = segue.destination as? QRViewController {
                
                vc.itemToDisplay = itemToDisplay
                vc.barTitle = barTitle
                vc.infoText = infoText
                
            }
            
        default:
            
            break
            
        }
        
    }

}
