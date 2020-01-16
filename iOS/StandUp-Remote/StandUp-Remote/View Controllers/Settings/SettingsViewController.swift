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
    var derivation = ""
    var miningFeeText = ""
    var walletName = ""
    let backgroundview = UIView()
    @IBOutlet var settingsTable: UITableView!
    @IBOutlet var switchOutlet: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundview.backgroundColor = .black
        backgroundview.frame = settingsTable.frame
        view.addSubview(backgroundview)
        
        tabBarController!.delegate = self
        settingsTable.delegate = self
        
        if ud.object(forKey: "basic") != nil {
            
            if ud.object(forKey: "basic") as! Bool {
                
                DispatchQueue.main.async {
                    
                    self.switchOutlet.selectedSegmentIndex = 0
                    
                }
                
            } else {
                
                DispatchQueue.main.async {
                    
                    self.switchOutlet.selectedSegmentIndex = 1
                    
                }
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.switchOutlet.selectedSegmentIndex = 0
                
            }
            
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        settingsTable.reloadData()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.backgroundview.alpha = 0
            
        }) { (_) in
            
            self.backgroundview.removeFromSuperview()
            
        }
        
    }
    
    @IBAction func switchBasic(_ sender: Any) {
                
        if switchOutlet.selectedSegmentIndex == 0 {
            
            ud.set(true, forKey: "basic")
            
        } else {
            
            ud.set(false, forKey: "basic")
            
        }
                
        DispatchQueue.main.async {
            
            let newview = UIView()
            newview.backgroundColor = .black
            newview.frame = self.settingsTable.frame
            newview.alpha = 0
            self.view.addSubview(newview)
            
            UIView.animate(withDuration: 0.2, animations: {
                
                newview.alpha = 1
                
            }) { (_) in
                
                self.settingsTable.reloadData()
                
                UIView.animate(withDuration: 0.2, animations: {
                                        
                    newview.alpha = 0
                    
                }) { (_) in
                    
                    newview.removeFromSuperview()
                    
                }
                
            }
            
        }
        
    }
    
    func updateFeeLabel(label: UILabel, numberOfBlocks: Int) {
        
        let seconds = ((numberOfBlocks * 10) * 60)
        
        func updateFeeSetting() {
            
            ud.set(numberOfBlocks, forKey: "feeTarget")
            
        }
        
        DispatchQueue.main.async {
            
            if seconds < 86400 {
                
                if seconds < 3600 {
                    
                    DispatchQueue.main.async {
                        
                        label.text = "Confirmation target \(numberOfBlocks) blocks (\(seconds / 60) minutes)"
                        
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        label.text = "Confirmation target \(numberOfBlocks) blocks (\(seconds / 3600) hours)"
                        
                    }
                    
                }
                
            } else {
                
                DispatchQueue.main.async {
                    
                    label.text = "Confirmation target \(numberOfBlocks) blocks (\(seconds / 86400) days)"
                    
                }
                
            }
            
            updateFeeSetting()
            
        }
            
    }
    
    @objc func setFee(_ sender: UISlider) {
        
        var section = 7
        
        if switchOutlet.selectedSegmentIndex == 0 {
            
            section = 3
            
        }
        
        let cell = settingsTable.cellForRow(at: IndexPath.init(row: 0, section: section))
        let label = cell?.viewWithTag(1) as! UILabel
        let numberOfBlocks = Int(sender.value) * -1
        updateFeeLabel(label: label, numberOfBlocks: numberOfBlocks)
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        let label = settingsCell.viewWithTag(1) as! UILabel
        label.textColor = .lightGray
        let thumbnail = settingsCell.viewWithTag(2) as! UIImageView
        settingsCell.selectionStyle = .none
        
        if switchOutlet.selectedSegmentIndex == 1 {
            
            switch indexPath.section {
                
            case 0:
                
                thumbnail.image = UIImage(systemName: "square.and.arrow.up")
                label.text = "Export"
                return settingsCell
                
            case 1:
                
                thumbnail.image = UIImage(systemName: "square.and.arrow.down")
                label.text = "Import"
                return settingsCell
                
            case 2:
                
                thumbnail.image = UIImage(systemName: "info.circle")
                label.text = "Set Derivation Scheme"
                return settingsCell
                
            case 3:
                
                thumbnail.image = UIImage(systemName: "square.stack.3d.down.right")
                label.text = "Wallets"
                return settingsCell
                
            case 4:
            
                thumbnail.image = UIImage(systemName: "info.circle")
                label.text = "Wallet Info"
                return settingsCell
                
            case 5:
                
                thumbnail.image = UIImage(systemName: "checkmark.seal")
                label.text = "Verify"
                return settingsCell
                
            case 6:
                
                thumbnail.image = UIImage(systemName: "lock")
                label.text = "Export Authentication Public Key"
                return settingsCell
                
            case 7:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "miningFeeCell", for: indexPath)
                let label = cell.viewWithTag(1) as! UILabel
                let slider = cell.viewWithTag(2) as! UISlider
                let thumbnail = cell.viewWithTag(3) as! UIImageView
                thumbnail.image = UIImage(systemName: "timer")
                
                slider.addTarget(self, action: #selector(setFee), for: .allEvents)
                slider.maximumValue = 2 * -1
                slider.minimumValue = 432 * -1
                
                if ud.object(forKey: "feeTarget") != nil {
                    
                    let numberOfBlocks = ud.object(forKey: "feeTarget") as! Int
                    slider.value = Float(numberOfBlocks) * -1
                    updateFeeLabel(label: label, numberOfBlocks: numberOfBlocks)
                    
                } else {
                    
                    label.text = "Minimum fee set"
                    slider.value = 432 * -1
                    
                }
                
                label.text = ""
                
                return cell
                
            default:
                
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor.clear
                return cell
                
            }

        } else {
            
            switch indexPath.section {
                
            case 0:
                
                thumbnail.image = UIImage(systemName: "square.and.arrow.up")
                label.text = "Export"
                return settingsCell
                
            case 1:
                
                thumbnail.image = UIImage(systemName: "checkmark.seal")
                label.text = "Verify"
                return settingsCell
                
            case 2:
                
                thumbnail.image = UIImage(systemName: "lock")
                label.text = "Export Authentication Public Key"
                return settingsCell
                
            case 3:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "miningFeeCell", for: indexPath)
                let label = cell.viewWithTag(1) as! UILabel
                let slider = cell.viewWithTag(2) as! UISlider
                let thumbnail = cell.viewWithTag(3) as! UIImageView
                thumbnail.image = UIImage(systemName: "timer")
                
                slider.addTarget(self, action: #selector(setFee), for: .allEvents)
                slider.maximumValue = 2 * -1
                slider.minimumValue = 432 * -1
                
                if ud.object(forKey: "feeTarget") != nil {
                    
                    let numberOfBlocks = ud.object(forKey: "feeTarget") as! Int
                    slider.value = Float(numberOfBlocks) * -1
                    updateFeeLabel(label: label, numberOfBlocks: numberOfBlocks)
                    
                } else {
                    
                    label.text = "Minimum fee set"
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
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if switchOutlet.selectedSegmentIndex == 1 {
            
            return 8
            
        } else {
            
            return 4
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if switchOutlet.selectedSegmentIndex == 1 {
            
            switch section {
            case 0: return "Seed"
            case 2: return "Derivation"
            case 3: return "Wallet Manager"
            case 5: return "Verify Keys"
            case 6: return "Tor V3 Authentication"
            case 7: return "Mining Fee"
            default: return ""
            }
            
        } else {
            
            switch section {
            case 0: return "Seed"
            case 1: return "Verify Keys"
            case 2: return "Tor V3 Authentication"
            case 3: return "Mining Fee"
            default: return ""
            }
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if switchOutlet.selectedSegmentIndex == 1 {
            
            switch section {
                
            case 0, 3:
                
                return 10
                
            default:
                
                return 20
                
            }
            
        } else {
            
            switch section {
                
            case 0:
                
                return 10
                
            default:
                
                return 20
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
            
        case 0:
            
            return 50
            
        case 1, 4:
            
            if switchOutlet.selectedSegmentIndex == 0 {
                
                return 30
                
            } else {
                
               return 0.25
                
            }
            
        default:
            
            return 30
            
        }
                
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
        }
        
        if switchOutlet.selectedSegmentIndex == 0 {
            
            switch indexPath.section {
                
            case 0:
                
                exportSeed()
                
            case 1:
                
                verifyKeys()
                
            case 2:
                
                goToAuth()
                
            default:
                
                break
                
            }
            
        } else {
            
            switch indexPath.section {
                
            case 0:
                
                exportSeed()
                
            case 1:
                
                importSeed()
                
            case 2:
                
                setDerivation()
                
            case 3:
                
                goToWallets()
                
            case 4:
                
                getWalletInfo()
                
            case 5:
                
                verifyKeys()
                
            case 6:
                
                goToAuth()
                
            default:
                
                break
                
            }
            
        }
        
    }
    
    func getWalletInfo() {
        
        getActiveWallet { (wallet) in
            
            if wallet != nil {
                
                self.walletName = wallet!.name
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "walletInfo", sender: self)
                    
                }
                
            }
            
        }
        
    }
    
    func goToWallets() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "goToWallets", sender: self)
            
        }
        
    }
    
    func setDerivation() {
        
        let enc = Encryption()
        enc.getSeed() { (words, derivation, error) in
            
            if !error {
                
                DispatchQueue.main.async {
                    
                    self.derivation = derivation
                    self.performSegue(withIdentifier: "setDerivation", sender: self)
                    
                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "Error getting your wallet")
                
            }
            
        }
        
    }
    
    func goToAuth() {
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToAuth", sender: self)
        }
        
    }
    
    func exportSeed() {
        
        let enc = Encryption()
        enc.getSeed() { (words, derivation, error) in
            
            if !error {
                
                DispatchQueue.main.async {
                    
                    self.derivation = derivation
                    self.seed = words
                    self.performSegue(withIdentifier: "exportSeed", sender: self)
                    
                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "Error getting your seed")
                
            }
            
        }

    }
    
    func importSeed() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "importSeed", sender: self)
            
        }
        
    }
    
    func goToWalletManager() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "goManageWallets", sender: self)
            
        }
        
    }
    
    func verifyKeys() {
        
        let enc = Encryption()
        enc.getSeed { (seed, derivation, error) in
            
            if !error {
                
                DispatchQueue.main.async {
                    
                    self.seed = seed
                    self.derivation = derivation
                    self.performSegue(withIdentifier: "seeKeys", sender: self)
                    
                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error getting your seed")
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "setDerivation":
            
            if let vc = segue.destination as? DerivationViewController {
                
                vc.derivation = self.derivation
                
            }
            
        case "exportSeed":
            
            if let vc = segue.destination as? SeedViewController {
                
                vc.seed = self.seed
                //vc.derivation = self.derivation
            }
            
        case "seeKeys":
            
            if let vc = segue.destination as? VerifyKeysViewController {
                
                vc.comingFromSettings = true
                vc.words = self.seed
                vc.derivation = self.derivation
                
            }
            
        case "walletInfo":
        
            if let vc = segue.destination as? WalletInfoViewController {
                
                vc.walletname = walletName
                
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



