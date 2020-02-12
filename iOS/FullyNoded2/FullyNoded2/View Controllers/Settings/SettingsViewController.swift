//
//  SettingsViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//
import KeychainSwift
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ud = UserDefaults.standard
    var seed = ""
    var derivation = ""
    var miningFeeText = ""
    var walletName = ""
    let backgroundview = UIView()
    @IBOutlet var settingsTable: UITableView!
    //@IBOutlet var switchOutlet: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundview.alpha = 0
        backgroundview.backgroundColor = .black
        backgroundview.frame = settingsTable.frame
        view.addSubview(backgroundview)
        //tabBarController!.delegate = self
        settingsTable.delegate = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        load()
        
    }
    
    func load() {
        
        //self.checkDefault()
                
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                self.derivation = wallet!.derivation
                
                DispatchQueue.main.async {
                    self.settingsTable.reloadData()
                }
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.backgroundview.alpha = 0
                    
                }) { (_) in
                    
                    self.backgroundview.removeFromSuperview()
                    
                }
                
            }
            
        }
        
    }
    
//    func checkDefault() {
//
//        if ud.object(forKey: "basic") != nil {
//
//            if ud.object(forKey: "basic") as! Bool {
//
//                DispatchQueue.main.async {
//
//                    self.switchOutlet.selectedSegmentIndex = 0
//
//                }
//
//            } else {
//
//                DispatchQueue.main.async {
//
//                    self.switchOutlet.selectedSegmentIndex = 1
//
//                }
//            }
//
//        } else {
//
//            DispatchQueue.main.async {
//
//                self.switchOutlet.selectedSegmentIndex = 0
//
//            }
//
//        }
//
//    }
    
//    @IBAction func switchBasic(_ sender: Any) {
//
//        if switchOutlet.selectedSegmentIndex == 0 {
//
//            ud.set(true, forKey: "basic")
//
//        } else {
//
//            ud.set(false, forKey: "basic")
//
//        }
//
//        DispatchQueue.main.async {
//
//            let newview = UIView()
//            newview.backgroundColor = .black
//            newview.frame = self.settingsTable.frame
//            newview.alpha = 0
//            self.view.addSubview(newview)
//
//            UIView.animate(withDuration: 0.2, animations: {
//
//                newview.alpha = 1
//
//            }) { (_) in
//
//                self.settingsTable.reloadData()
//
//                UIView.animate(withDuration: 0.2, animations: {
//
//                    newview.alpha = 0
//
//                }) { (_) in
//
//                    newview.removeFromSuperview()
//
//                }
//
//            }
//
//        }
//
//    }
    
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
        
//        var section = 9
//
//        if switchOutlet.selectedSegmentIndex == 0 {
//
//            section = 6
//
//        }
        
        let cell = settingsTable.cellForRow(at: IndexPath.init(row: 0, section: 3))
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
        
        switch indexPath.section {
            
            case 0:
                
                thumbnail.image = UIImage(systemName: "lock")
                label.text = "Export Authentication Public Key"
                return settingsCell
                
            case 1:
                
                thumbnail.image = UIImage(systemName: "desktopcomputer")
                label.text = "Node Manager"
                return settingsCell
                
            case 2:
                
                thumbnail.image = UIImage(systemName: "exclamationmark.triangle")
                label.text = "Reset app"
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
        
//        if switchOutlet.selectedSegmentIndex == 1 {
//
//            switch indexPath.section {
//
//            /*case 0:
//
//                thumbnail.image = UIImage(systemName: "square.and.arrow.up")
//                label.text = "Export"
//                return settingsCell
//
//            case 1:
//
//                thumbnail.image = UIImage(systemName: "square.and.arrow.down")
//                label.text = "Import"
//                return settingsCell
//
//            case 2:
//
//                thumbnail.image = UIImage(systemName: "checkmark.seal")
//                label.text = "Verify"
//                return settingsCell
//
//            case 3:
//
//                thumbnail.image = UIImage(systemName: "square.and.arrow.up")
//                label.text = "Export"
//                return settingsCell
//
//            case 4:
//
//                thumbnail.image = UIImage(systemName: "square.stack.3d.down.right")
//                label.text = "Wallets"
//                return settingsCell
//
//            case 5:
//
//                thumbnail.image = UIImage(systemName: "info.circle")
//                label.text = "Wallet Info"
//                return settingsCell*/
//
////            case 7:
////
////                thumbnail.image = UIImage(systemName: "info.circle")
////
////                var account = "0"
////
////                if self.derivation.contains("1") {
////
////                    account = "1"
////
////                }
////
////                if self.derivation.contains("84") {
////
////                    label.text = "Native Segwit Account \(account) (BIP84 \(self.derivation))"
////
////                } else if self.derivation.contains("44") {
////
////                    label.text = "Legacy Account \(account) (BIP44 \(self.derivation))"
////
////                } else if self.derivation.contains("49") {
////
////                    label.text = "P2SH Segwit Account \(account) (BIP49 \(self.derivation))"
////
////                }
////
////                label.adjustsFontSizeToFitWidth = true
////
////                return settingsCell
//
//            case 0:
//
//                thumbnail.image = UIImage(systemName: "lock")
//                label.text = "Export Authentication Public Key"
//                return settingsCell
//
//            case 1:
//
//                thumbnail.image = UIImage(systemName: "desktopcomputer")
//                label.text = "Node Manager"
//                return settingsCell
//
//            case 2:
//
//                thumbnail.image = UIImage(systemName: "exclamationmark.triangle")
//                label.text = "Reset app"
//                return settingsCell
//
//            case 3:
//
//                let cell = tableView.dequeueReusableCell(withIdentifier: "miningFeeCell", for: indexPath)
//                let label = cell.viewWithTag(1) as! UILabel
//                let slider = cell.viewWithTag(2) as! UISlider
//                let thumbnail = cell.viewWithTag(3) as! UIImageView
//                thumbnail.image = UIImage(systemName: "timer")
//
//                slider.addTarget(self, action: #selector(setFee), for: .allEvents)
//                slider.maximumValue = 2 * -1
//                slider.minimumValue = 432 * -1
//
//                if ud.object(forKey: "feeTarget") != nil {
//
//                    let numberOfBlocks = ud.object(forKey: "feeTarget") as! Int
//                    slider.value = Float(numberOfBlocks) * -1
//                    updateFeeLabel(label: label, numberOfBlocks: numberOfBlocks)
//
//                } else {
//
//                    label.text = "Minimum fee set"
//                    slider.value = 432 * -1
//
//                }
//
//                label.text = ""
//
//                return cell
//
//            default:
//
//                let cell = UITableViewCell()
//                cell.backgroundColor = UIColor.clear
//                return cell
//
//            }
//
//        } else {
//
//            switch indexPath.section {
//
//            /*case 0:
//
//                thumbnail.image = UIImage(systemName: "square.and.arrow.up")
//                label.text = "Export"
//                return settingsCell
//
//            case 1:
//
//                thumbnail.image = UIImage(systemName: "square.and.arrow.down")
//                label.text = "Import"
//                return settingsCell
//
//            case 2:
//
//                thumbnail.image = UIImage(systemName: "checkmark.seal")
//                label.text = "Verify"
//                return settingsCell
//
//            case 3:
//
//                thumbnail.image = UIImage(systemName: "square.and.arrow.up")
//                label.text = "Export"
//                return settingsCell*/
//
//            case 4:
//
//                thumbnail.image = UIImage(systemName: "lock")
//                label.text = "Export Authentication Public Key"
//                return settingsCell
//
//            case 5:
//
//                thumbnail.image = UIImage(systemName: "desktopcomputer")
//                label.text = "Node Manager"
//                return settingsCell
//
//            case 6:
//
//                let cell = tableView.dequeueReusableCell(withIdentifier: "miningFeeCell", for: indexPath)
//                let label = cell.viewWithTag(1) as! UILabel
//                let slider = cell.viewWithTag(2) as! UISlider
//                let thumbnail = cell.viewWithTag(3) as! UIImageView
//                thumbnail.image = UIImage(systemName: "timer")
//
//                slider.addTarget(self, action: #selector(setFee), for: .allEvents)
//                slider.maximumValue = 2 * -1
//                slider.minimumValue = 432 * -1
//
//                if ud.object(forKey: "feeTarget") != nil {
//
//                    let numberOfBlocks = ud.object(forKey: "feeTarget") as! Int
//                    slider.value = Float(numberOfBlocks) * -1
//                    updateFeeLabel(label: label, numberOfBlocks: numberOfBlocks)
//
//                } else {
//
//                    label.text = "Minimum fee set"
//                    slider.value = 432 * -1
//
//                }
//
//                label.text = ""
//
//                return cell
//
//            default:
//
//                let cell = UITableViewCell()
//                cell.backgroundColor = UIColor.clear
//                return cell
//
//            }
//
//        }
    

    
    //}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
//        if switchOutlet.selectedSegmentIndex == 1 {
//
//            return 10
//
//        } else {
//
//            return 7
//
//        }
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //if switchOutlet.selectedSegmentIndex == 1 {
            
            switch section {
//            case 0: return "Seed"
//            case 2: return "Keys and Addresses"
//            case 4: return "Wallet Manager"
            //case 7: return "Derivation"
            case 6: return "Tor V3 Authentication"
            case 7: return "Node Manager"
            case 8: return "Kill Switch"
            case 9: return "Mining Fee"
            default: return ""
            }
            
//        } else {
//
//            switch section {
//            case 0: return "Seed"
//            case 2: return "Keys and Addresses"
//            case 4: return "Tor V3 Authentication"
//            case 5: return "Node Manager"
//            case 6: return "Mining Fee"
//            default: return ""
//            }
//
//        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
//        if switchOutlet.selectedSegmentIndex == 1 {
//
//            switch section {
//
//            case 0, 2, 4, 5:
//
//                return 10
//
//            default:
//
//                return 20
//
//            }
//
//        } else {
//
//            switch section {
//
//            case 0, 2:
//
//                return 10
//
//            default:
//
//                return 20
//
//            }
//
//        }
        
        return 20
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
            
        case 0:
            
            return 50
            
        default:
            
            return 30
            
        }
        
//        if switchOutlet.selectedSegmentIndex == 0 {
//
//            switch section {
//
//            case 0:
//
//                return 50
//
//            case 1, 3:
//
//                return 0.25
//
//            default:
//
//                return 30
//
//            }
//
//        } else {
//
//            switch section {
//
//            case 0:
//
//                return 50
//
//            case 1, 3, 5:
//
//                return 0.25
//
//            default:
//
//                return 30
//
//            }
//
//        }
        
        
                
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
        }
        
        switch indexPath.section {
            
        case 0:
            
            goToAuth()
            
        case 1:
            
            nodeManager()
            
        case 2:
        
            resetApp()
            
        default:
            
            break
            
        }
        
//        if switchOutlet.selectedSegmentIndex == 0 {
//
//            switch indexPath.section {
//
//            case 0:
//
//                exportSeed()
//
//            case 1:
//
//                importSeed()
//
//            case 2:
//
//                verifyKeys()
//
//            case 3:
//
//                exportKeys()
//
//            case 4:
//
//                goToAuth()
//
//            case 5:
//
//                nodeManager()
//
//            default:
//
//                break
//
//            }
//
//        } else {
//
//            switch indexPath.section {
//
//            case 0:
//
//                exportSeed()
//
//            case 1:
//
//                importSeed()
//
//            case 2:
//
//                verifyKeys()
//
//            case 3:
//
//                exportKeys()
//
//            case 4:
//
//                goToWallets()
//
//            case 5:
//
//                getWalletInfo()
//
////            case 6:
////
////                walletTemplates()
//
////            case 7:
////
////                setDerivation()
//
//            case 6:
//
//                goToAuth()
//
//            case 7:
//
//                nodeManager()
//
//            case 8:
//
//                resetApp()
//
//            default:
//
//                break
//
//            }
//
//        }
        
    }
    
    func resetApp() {
        
        let cd = CoreDataService()
        let ud = UserDefaults.standard
        
        let domain = Bundle.main.bundleIdentifier!
        ud.removePersistentDomain(forName: domain)
        ud.synchronize()
        
        cd.retrieveEntity(entityName: .nodes) { (nodes, errorDescription) in
            
            if nodes != nil {
                
               for n in nodes! {
                    
                    let str = NodeStruct(dictionary: n)
                    let id = str.id
                    
                    cd.deleteEntity(id: id, entityName: .nodes) {
                        
                        if !cd.errorBool {
                            
                            let success = cd.boolToReturn
                            
                            if success {
                                
                                cd.retrieveEntity(entityName: .wallets) { (wallets, errorDescription) in
                                    
                                    if wallets != nil {
                                        
                                        for h in wallets! {
                                            
                                            let str = WalletStruct(dictionary: h)
                                            let id = str.id
                                            
                                            cd.deleteEntity(id: id, entityName: .wallets) {
                                                
                                                if !cd.errorBool {
                                                    
                                                    let success = cd.boolToReturn
                                                    
                                                    if success {
                                                        
                                                        let keychain = KeychainSwift()
                                                        
                                                        if keychain.clear() {
                                                            
                                                            displayAlert(viewController: self, isError: false, message: "app has been reset")
                                                            
                                                        } else {
                                                            
                                                            displayAlert(viewController: self, isError: true, message: "app reset partially failed")
                                                            
                                                        }
                                                        
                                                    } else {
                                                        
                                                        displayAlert(viewController: self, isError: true, message: "app reset partially failed")
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                displayAlert(viewController: self, isError: true, message: "app reset failed")
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func nodeManager() {
        
        DispatchQueue.main.async {
        
            self.performSegue(withIdentifier: "nodeManager", sender: self)
            
        }
        
    }
    
    func exportKeys() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "exportKeys", sender: self)
            
        }
        
    }
    
    func walletTemplates() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "templates", sender: self)
            
        }
        
    }
    
    func getWalletInfo() {
        
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
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
    
//    func setDerivation() {
//
//        let enc = Encryption()
//        enc.getSeed() { (words, derivation, error) in
//
//            if !error {
//
//                DispatchQueue.main.async {
//
//                    self.derivation = derivation
//                    self.performSegue(withIdentifier: "setDerivation", sender: self)
//
//                }
//
//            } else {
//
//                displayAlert(viewController: self, isError: true, message: "Error getting your wallet")
//
//            }
//
//        }
//
//    }
    
    func goToAuth() {
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToAuth", sender: self)
        }
        
    }
    
    func exportSeed() {
        
        getActiveWalletNow() { (wallet, error) in
            
            if wallet != nil && !error {
                
                DispatchQueue.main.async {
                    
                    self.derivation = wallet!.derivation
                    
                    let enc = Encryption()
                    enc.decryptData(dataToDecrypt: wallet!.seed) { (seed) in
                        
                        if seed != nil {
                            
                            self.seed = String(data: seed!, encoding: .utf8)!
                            
                            DispatchQueue.main.async {
                                
                                self.performSegue(withIdentifier: "exportSeed", sender: self)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
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
        
        getActiveWalletNow() { (wallet, error) in
            
            if wallet != nil && !error {
                
                DispatchQueue.main.async {
                    
                    self.derivation = wallet!.derivation
                    
                    let enc = Encryption()
                    enc.decryptData(dataToDecrypt: wallet!.seed) { (words) in
                        
                        if words != nil {
                            
                            DispatchQueue.main.async {
                                
                                self.seed = String(data: words!, encoding: .utf8)!
                                self.performSegue(withIdentifier: "seeKeys", sender: self)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
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
            
//        case "exportKeys":
//            
//            if let vc = segue.destination as? ExportKeysViewController {
//                
//                
//            }
            
        case "exportSeed":
            
            if let vc = segue.destination as? SeedViewController {
                
                vc.seed = self.seed
                
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

//extension SettingsViewController  {
//    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return MyTransition(viewControllers: tabBarController.viewControllers)
//    }
//}



