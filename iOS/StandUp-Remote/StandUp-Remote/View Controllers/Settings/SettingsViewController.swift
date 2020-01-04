//
//  SettingsViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    
    let ud = UserDefaults.standard
    var seed = ""
    var miningFeeText = ""
    @IBOutlet var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController!.delegate = self
        settingsTable.delegate = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        settingsTable.reloadData()
        
    }
    
    func updateFeeLabel(label: UILabel, numberOfBlocks: Int) {
        
        let seconds = ((numberOfBlocks * 10) * 60)
        
        func updateFeeSetting() {
            
            ud.set(numberOfBlocks, forKey: "feeTarget")
            
        }
        
        DispatchQueue.main.async {
            
            if seconds < 86400 {
                
                //less then a day
                if seconds < 3600 {
                    
                    DispatchQueue.main.async {
                        
                        //less then an hour
                        label.text = "Mining fee target \(numberOfBlocks) blocks (\(seconds / 60) minutes)"
                        
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        //more then an hour
                        label.text = "Mining fee target \(numberOfBlocks) blocks (\(seconds / 3600) hours)"
                        
                    }
                    
                }
                
            } else {
                
                DispatchQueue.main.async {
                    
                    //more then a day
                    label.text = "Mining fee target \(numberOfBlocks) blocks (\(seconds / 86400) days)"
                    
                }
                
            }
            
            updateFeeSetting()
            
        }
            
    }
    
    @objc func setFee(_ sender: UISlider) {
        
        let cell = settingsTable.cellForRow(at: IndexPath.init(row: 0, section: 2))
        let label = cell?.viewWithTag(1) as! UILabel
        let numberOfBlocks = Int(sender.value) * -1
        updateFeeLabel(label: label, numberOfBlocks: numberOfBlocks)
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        let label = settingsCell.viewWithTag(1) as! UILabel
        label.textColor = UIColor.white
        settingsCell.selectionStyle = .none
        
        switch indexPath.section {
            
        case 0:
            
            label.text = "Export Seed"
            return settingsCell
            
        case 1:
            
            label.text = "Export Authentication Public Key"
            return settingsCell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "miningFeeCell", for: indexPath)
            let label = cell.viewWithTag(1) as! UILabel
            let slider = cell.viewWithTag(2) as! UISlider
            
            slider.addTarget(self, action: #selector(setFee), for: .allEvents)
            slider.maximumValue = 2 * -1
            slider.minimumValue = 432 * -1
            
            if ud.object(forKey: "feeTarget") != nil {
                
                let numberOfBlocks = ud.object(forKey: "feeTarget") as! Int
                slider.value = Float(numberOfBlocks) * -1
                updateFeeLabel(label: label, numberOfBlocks: numberOfBlocks)
                
            } else {
                
                label.text = "Minimum fee set (you can always bump it)"
                slider.value = 432 * -1
                
            }
            
            label.text = ""
            
            return cell
            
        default:
            
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.clear
            return cell
            
        }
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0: return "Seed"
        case 1: return "Tor V3 Authentication"
        case 2: return "Mining Fee"
        default:return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.init(name: "HiraginoSans-W3", size: 12)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.lightText
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 20
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
        }
        
        switch indexPath.section {
        case 0: goToSeed()
        case 1: goToAuth()
        default: break
        }
        
    }
    
    func goToAuth() {
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToAuth", sender: self)
        }
        
    }
    
    func goToSeed() {
        
        let enc = Encryption()
        enc.getSeed() { (words, error) in
            
            if !error {
                
                DispatchQueue.main.async {
                    self.seed = words
                    self.performSegue(withIdentifier: "goToSeed", sender: self)
                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "Error getting your seed")
                
            }
            
        }

    }
    
    func goToWalletManager() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "goManageWallets", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "goToSeed":
            
            if let vc = segue.destination as? SeedViewController {
                
                vc.seed = self.seed
                
            }
                    
        default:
        
            break
            
        }
        
    }
    
}

public extension Int {
    
    func withCommas() -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    
}

extension SettingsViewController  {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
}



