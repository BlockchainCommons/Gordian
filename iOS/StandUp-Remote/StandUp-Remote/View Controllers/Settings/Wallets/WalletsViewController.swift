//
//  WalletsViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 10/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class WalletsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var name = ""
    var wallets = [[String:Any]]()
    let dateFormatter = DateFormatter()
    @IBOutlet var walletTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        walletTable.delegate = self
        walletTable.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        refresh()
        
    }
    
    func refresh() {
        print("refresh")
        
        wallets.removeAll()
        let cd = CoreDataService()
        cd.entities.removeAll()
        cd.retrieveEntity(entityName: .wallets) {
            
            if !cd.errorBool {
                
                self.wallets = cd.entities
                
                DispatchQueue.main.async {
                    self.walletTable.reloadData()
                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error getting wallets")
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath)
        cell.selectionStyle = .none
        let birthdateLabel = cell.viewWithTag(1) as! UILabel
        let derivationLabel = cell.viewWithTag(2) as! UILabel
        let typeLabel = cell.viewWithTag(5) as! UILabel
        let onOffSwitch = cell.viewWithTag(6) as! UISegmentedControl
        let onOffImage = cell.viewWithTag(7) as! UIImageView
        
        onOffSwitch.accessibilityLabel = "\(indexPath.section)"
        onOffSwitch.addTarget(self, action: #selector(alternate(_:)), for: .valueChanged)
        
        let walletDict = wallets[indexPath.section]
        let wallet = WalletStruct.init(dictionary: walletDict)
        
        birthdateLabel.text = "birthdate \(getDate(unixTime: wallet.birthdate))"
        
        if wallet.derivation.contains("84") {
            
            derivationLabel.text = "BIP84"
            
        } else if wallet.derivation.contains("44") {
            
            derivationLabel.text = "BIP44"
            
        } else if wallet.derivation.contains("49") {
            
            derivationLabel.text = "BIP49"
            
        }
                
        if wallet.type == "DEFAULT" {
            
            typeLabel.text = "Single signature"
            
        } else {
            
            typeLabel.text = "2 of 3 multi signature"
            
        }
                
        if wallet.isActive {
            
            onOffSwitch.selectedSegmentIndex = 0
            onOffImage.image = UIImage(named: "greenCircle.png")
            
        } else {
            
            onOffSwitch.selectedSegmentIndex = 1
            onOffImage.image = UIImage(named: "redCircle.png")
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)//UIFont.init(name: "HiraginoSans-W3", size: 12)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let name = WalletStruct.init(dictionary: wallets[section]).name
        return "\(name).dat"
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        name = WalletStruct.init(dictionary: wallets[indexPath.section]).name
//        
//        DispatchQueue.main.async {
//            
//            self.performSegue(withIdentifier: "walletInfo", sender: self)
//            
//        }
        
    }
    
    func getDate(unixTime: Int32) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MMM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
        
    }
    
    @objc func alternate(_ sender: UISegmentedControl) {
        print("alternate")
        
        let index = sender.selectedSegmentIndex
        let wallet = wallets[Int(sender.accessibilityLabel!)!]
        let idToActivate = WalletStruct.init(dictionary: wallet).id
        
        if index == 0 {
            
            //turning on
            makeActive(walletToActivate: idToActivate)
            
        } else {
            
            //turning off
            //deactivate(wallet: wallet)
            
        }
        
        DispatchQueue.main.async {
            
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
        }
        
    }
    
    func makeActive(walletToActivate: UUID) {
        
        let cd = CoreDataService()
        cd.retrieveEntity(entityName: .wallets) {
            
            let wallets = cd.entities
            
            if wallets.count > 0 {
                
                for wallet in wallets {
                    
                    let str = WalletStruct.init(dictionary: wallet)
                    
                    if str.id == walletToActivate {
                        
                        cd.updateEntity(id: walletToActivate, keyToUpdate: "isActive", newValue: true, entityName: .wallets) {
                            
                            if !cd.errorBool {
                                
                               self.deactivateOtherWallets(walletToActivate: walletToActivate)
                                
                            } else {
                                
                                displayAlert(viewController: self, isError: true, message: "error deactivating wallet")
                                
                            }
                            
                        }
                        
                    }
                    
                }

            }
                    
        }
        
    }
    
    func deactivateOtherWallets(walletToActivate: UUID) {
        print("deactivateOtherWallets")
        
        let cd = CoreDataService()
        cd.retrieveEntity(entityName: .wallets) {
            
            let wallets = cd.entities
            
            if wallets.count > 0 {
                
                for wallet in wallets {
                    
                    let str = WalletStruct.init(dictionary: wallet)
                    
                    if str.id != walletToActivate {
                        
                        cd.updateEntity(id: str.id, keyToUpdate: "isActive", newValue: false, entityName: .wallets) {
                            
                            if !cd.errorBool {
                                
                                self.refresh()
                                
                            } else {
                                
                                displayAlert(viewController: self, isError: true, message: cd.errorDescription)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "walletInfo":
            
            if let vc = segue.destination as? WalletInfoViewController {
                
                vc.walletname = name
                
            }
            
        default:
            
            break
            
        }
        
    }
    

}
