//
//  WalletsViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 10/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class WalletsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var wallets = [WalletStruct]()
    let dateFormatter = DateFormatter()
    @IBOutlet var walletTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        walletTable.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        refresh()
        
    }
    
    func refresh() {
        
        wallets.removeAll()
        let cd = CoreDataService()
        cd.retrieveEntity(entityName: .wallets) {
            
            if !cd.errorBool {
                
                for entity in cd.entities {
                    
                    let str = WalletStruct.init(dictionary: entity)
                    self.wallets.append(str)
                    
                }
                
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
        let birthdateLabel = cell.viewWithTag(1) as! UILabel
        let derivationLabel = cell.viewWithTag(2) as! UILabel
        //let isActiveLabel = cell.viewWithTag(3) as! UILabel
        let typeLabel = cell.viewWithTag(5) as! UILabel
        let onOffSwitch = cell.viewWithTag(6) as! UISegmentedControl
        onOffSwitch.accessibilityLabel = "\(indexPath.section)"
        //onOffSwitch.target(forAction: #selector(alternate(_:)), for: nil)
        onOffSwitch.addTarget(self, action: #selector(alternate(_:)), for: .valueChanged)
        let wallet = wallets[indexPath.section]
        
        birthdateLabel.text = "birthdate \(getDate(unixTime: wallet.birthdate))"
        derivationLabel.text = "\(wallet.derivation)"
        typeLabel.text = "\(wallet.type) type"
        
        if wallet.isActive {
            
            onOffSwitch.selectedSegmentIndex = 0
            
        } else {
            
            onOffSwitch.selectedSegmentIndex = 1
            
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
     
        return "\(wallets[section].name)"
        
    }
    
    func getDate(unixTime: Int32) -> String {
        
        print("unixtime = \(unixTime)")
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MMM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        print("strDate = \(strDate)")
        return strDate
        
    }
    
    @objc func alternate(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        let wallet = wallets[Int(sender.accessibilityLabel!)!]
        
        if index == 0 {
            
            //turning on
            makeActive(wallet: wallet)
            
        } else {
            
            //turning off
            deactivate(wallet: wallet)
            
        }
        
    }
    
    func makeActive(wallet: WalletStruct) {
        
        let idToActivate = wallet.id
        let walletname = wallet.name
        let cd = CoreDataService()
        cd.retrieveEntity(entityName: .wallets) {
            
            let wallets = cd.entities
            
            if wallets.count > 1 {
                
                for (i, wallet) in wallets.enumerated() {
                    
                    let str = WalletStruct.init(dictionary: wallet)
                    
                    if str.id != idToActivate && str.isActive {
                        
                        cd.updateEntity(id: str.id, keyToUpdate: "isActive", newValue: false, entityName: .wallets) {
                            
                            if !cd.errorBool {
                                
                                let ud = UserDefaults.standard
                                ud.removeObject(forKey: "walletName")
                                
                                if i + 1 == wallets.count {
                                    
                                    cd.updateEntity(id: idToActivate, keyToUpdate: "isActive", newValue: true, entityName: .wallets) {
                                        
                                        if !cd.errorBool {
                                            
                                            ud.set(walletname, forKey: "walletName")
                                            DispatchQueue.main.async {
                                                
                                                self.refresh()
                                                
                                            }
                                            
                                        } else {
                                            
                                            displayAlert(viewController: self, isError: true, message: "error activating wallet")
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                displayAlert(viewController: self, isError: true, message: "error deactivating wallet")
                                
                            }
                            
                        }
                        
                    }
                    
                }

            } else {
                
                cd.updateEntity(id: idToActivate, keyToUpdate: "isActive", newValue: true, entityName: .wallets) {
                    
                    if !cd.errorBool {
                        
                        DispatchQueue.main.async {
                            
                            self.refresh()
                            
                        }
                        
                    } else {
                        
                        displayAlert(viewController: self, isError: true, message: "error activating wallet")
                        
                    }
                    
                }
                
            }
                    
        }
        
    }
    
    func deactivate(wallet: WalletStruct) {
        
        let cd = CoreDataService()
        
        cd.updateEntity(id: wallet.id, keyToUpdate: "isActive", newValue: false, entityName: .wallets) {
            
            if !cd.errorBool {
                
                DispatchQueue.main.async {
                    
                    self.refresh()
                    
                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error activating wallet")
                
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
