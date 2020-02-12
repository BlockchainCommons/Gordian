//
//  SeedViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

class SeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var seed = ""
    var itemToDisplay = ""
    var infoText = ""
    var barTitle = ""
    var privateKeyDescriptor = ""
    var publicKeyDescriptor = ""
    var birthdate = "\"now\""
    var recoveryText = ""
    var index = Int()
    var wallet:WalletStruct!
    var tap = UITapGestureRecognizer()
    var tapCopyLabel = UITapGestureRecognizer()
    var tapShareLabel = UITapGestureRecognizer()
    var tapQRLabel = UITapGestureRecognizer()
    var tapCopyImage = UITapGestureRecognizer()
    var tapQRImage = UITapGestureRecognizer()
    var tapShareImage = UITapGestureRecognizer()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    @IBOutlet var tableView: UITableView!
    @IBOutlet var customButtons: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTaps()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                self.wallet = wallet!
                self.loadData()
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "no active wallet")
                
            }
            
        }
        
    }
    
    func setupTaps() {
        
        blurView.frame = self.view.frame
        blurView.alpha = 0
        tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        customButtons.alpha = 0
        customButtons.clipsToBounds = true
        customButtons.layer.cornerRadius = 8
        
        let copyLabel = customButtons.viewWithTag(1) as! UILabel
        let shareLabel = customButtons.viewWithTag(2) as! UILabel
        let displayQRLabel = customButtons.viewWithTag(3) as! UILabel
        let copyImage = customButtons.viewWithTag(4) as! UIImageView
        let shareImage = customButtons.viewWithTag(5) as! UIImageView
        let qrImage = customButtons.viewWithTag(6) as! UIImageView
        
        copyLabel.addBottomBorderWithColor(color: .darkGray, width: 0.5)
        shareLabel.addBottomBorderWithColor(color: .darkGray, width: 0.5)
        displayQRLabel.addBottomBorderWithColor(color: .darkGray, width: 0.5)
        
        copyLabel.isUserInteractionEnabled = true
        shareLabel.isUserInteractionEnabled = true
        displayQRLabel.isUserInteractionEnabled = true
        copyImage.isUserInteractionEnabled = true
        shareImage.isUserInteractionEnabled = true
        qrImage.isUserInteractionEnabled = true
        
        tapShareLabel = UITapGestureRecognizer(target: self, action: #selector(handleShareTap(_:)))
        tapShareImage = UITapGestureRecognizer(target: self, action: #selector(handleShareTap(_:)))
        tapQRLabel = UITapGestureRecognizer(target: self, action: #selector(handleQRTap(_:)))
        tapQRImage = UITapGestureRecognizer(target: self, action: #selector(handleQRTap(_:)))
        tapCopyLabel = UITapGestureRecognizer(target: self, action: #selector(handleCopyTap(_:)))
        tapCopyImage = UITapGestureRecognizer(target: self, action: #selector(handleCopyTap(_:)))

        copyLabel.addGestureRecognizer(tapCopyLabel)
        copyImage.addGestureRecognizer(tapCopyImage)
        shareLabel.addGestureRecognizer(tapShareLabel)
        shareImage.addGestureRecognizer(tapShareImage)
        qrImage.addGestureRecognizer(tapQRImage)
        displayQRLabel.addGestureRecognizer(tapQRLabel)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        removeBlurView()
        
    }
    
    func removeBlurView() {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.blurView.alpha = 0
            self.customButtons.alpha = 0
            
        }) { (_) in
            
            
        }
        
    }
    
    @objc func handleCopyTap(_ sender: UITapGestureRecognizer? = nil) {
        
        print("copy tapped")
        
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        
        var textToCopy = ""
        var message = ""
        
        switch index {
            
        case 0:
            textToCopy = seed
            message = "your seed was copied to your clipboard and will be erased in one minute"
        case 1:
            textToCopy = publicKeyDescriptor
            message = "your public key descriptor was copied to your clipboard and will be erased in one minute"
        case 2:
            textToCopy = privateKeyDescriptor
            message = "your private key descriptor was copied to your clipboard and will be erased in one minute"
        case 3:
            textToCopy = recoveryText
            message = "your recovery command was copied to your clipboard and will be erased in one minute"
            
        default:
            break
        }
        
        UIPasteboard.general.string = textToCopy
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            
            UIPasteboard.general.string = ""
            
        }
        
        removeBlurView()
        displayAlert(viewController: self, isError: false, message: message)
        
    }
    
    @objc func handleShareTap(_ sender: UITapGestureRecognizer? = nil) {
        
        print("share tapped")
        
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        
        switch index {
            
        case 0:
            itemToDisplay = seed
        case 1:
            itemToDisplay = publicKeyDescriptor
        case 2:
            itemToDisplay = privateKeyDescriptor
        case 3:
            itemToDisplay = recoveryText
        default:
            break
        }
        
        shareText()
        removeBlurView()
        
    }
    
    @objc func handleQRTap(_ sender: UITapGestureRecognizer? = nil) {
        
        print("qr tapped")
        
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        
        switch index {
            
        case 0:
            
            itemToDisplay = seed
            infoText = "Your BIP39 recovery phrase which can be imported into BIP39 compatible wallets, by default StandUp does not create a password for your recovery phrase."
            barTitle = "BIP39 Mnemonic"
            goToQRDisplayer()
            
        case 1:
            
            itemToDisplay = publicKeyDescriptor
            infoText = "Your public key descriptor which can be used with the importmulti command to create a watch-only wallet with Bitcoin Core."
            barTitle = "Pubkey Descriptor"
            goToQRDisplayer()
            
        case 2:
            
            itemToDisplay = privateKeyDescriptor
            infoText = "Your private key descriptor which can be used with the importmulti command to recover your StandUp wallet with Bitcoin Core."
            barTitle = "Private Key Descriptor"
            goToQRDisplayer()
            
        case 3:
            
            itemToDisplay = recoveryText
            infoText = "This command can be pasted into a terminal to add all your devices private keys to your node, this would be useful if you lost your device as you can use your node to recover your wallet."
            barTitle = "Recovery Command"
            goToQRDisplayer()
            
        default:
            
            break
            
        }
        
    }
    
    func shareText() {
        
        DispatchQueue.main.async {
            
            let textToShare = [self.itemToDisplay]
            
            let activityViewController = UIActivityViewController(activityItems: textToShare,
                                                                  applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true) {}
            
        }
        
    }
    
    func loadData() {
        
        self.xprv { (xprv) in
            
            if xprv != "" {
                
                self.privateKeyDescriptor = "wpkh(\(xprv)/*)"
                
                self.recoveryText = "bitcoin-cli -rpcwallet=\(self.wallet.name) importmulti { \"desc\": \"\(self.privateKeyDescriptor)\", \"timestamp\": \(self.wallet.birthdate), \"range\": [0,999], \"watchonly\": false, \"label\": \"StandUp\", \"keypool\": true, \"internal\": false }\n\nbitcoin-cli -rpcwallet=\(self.wallet.name) importmulti { \"desc\": \"\(self.privateKeyDescriptor)\", \"timestamp\": \(self.wallet.birthdate), \"range\": [1000,1999], \"watchonly\": false, \"keypool\": true, \"internal\": true }"
                
                if self.wallet.type == "MULTI" {
                    
                    self.recoveryText = "bitcoin-cli -rpcwallet=\(self.wallet.name) importmulti { \"desc\": \"\(self.privateKeyDescriptor)\", \"timestamp\": \(self.wallet.birthdate), \"range\": [0,1999], \"watchonly\": false, \"label\": \"StandUp\", \"keypool\": false, \"internal\": false }"
                    
                }
                                
            } else if self.wallet.type == "CUSTOM" {
                
                self.recoveryText = "bitcoin-cli -rpcwallet=\(self.wallet.name) importmulti { \"desc\": \"\(self.publicKeyDescriptor)\", \"timestamp\": \(self.wallet.birthdate), \"range\": [0,1999], \"watchonly\": true, \"label\": \"StandUp\", \"keypool\": false, \"internal\": false }"
                
            } else {
                
                print("error getting xprv")
                displayAlert(viewController: self, isError: true, message: "Error getting your xprv")
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        self.xpub { (xpub) in
            
            if xpub != "" {
                
                if self.wallet.type == "MULTI" {
                    
                    self.publicKeyDescriptor = self.wallet.descriptor
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } else {
                    
                    self.publicKeyDescriptor = "wpkh(\(xpub)/*)"
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
                
            } else if self.wallet.type == "CUSTOM" {
                
                self.publicKeyDescriptor = self.wallet.descriptor
                
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
                
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.backgroundColor = #colorLiteral(red: 0.0507061556, green: 0.05862525851, blue: 0.0711022839, alpha: 1)
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .lightGray
        
        switch indexPath.section {
            
        case 0:
            
            if wallet != nil {
                
                if wallet.type == "CUSTOM" {
                    
                    cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                    cell.textLabel?.text = "⚠︎ No seed on device"
                    
                }
                
            }
            
            if wallet?.seed != nil {
                
                let encryptedSeed = wallet!.seed
                
                let enc = Encryption()
                enc.decryptData(dataToDecrypt: encryptedSeed) { (decryptedData) in
                    
                    if decryptedData != nil {
                        
                        let decryptedSeed = String(bytes: decryptedData!, encoding: .utf8)!
                        let arr = decryptedSeed.split(separator: " ")
                        var str = ""
                        
                        for (i, word) in arr.enumerated() {
                            
                            if i + 1 == arr.count {
                                
                                str += "\(i + 1). \(word)"
                                
                            } else {
                                
                                str += "\(i + 1). \(word)\n"
                                
                            }
                            
                        }
                        
                        cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                        cell.textLabel?.text = str
                        
                    }
                    
                }
                
            } else {
                
                cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                cell.textLabel?.text = "⚠︎ No seed on device"
                
            }
                        
        case 1:
            
            cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
            cell.textLabel?.text = self.publicKeyDescriptor
            
        case 2:
            
            if self.wallet != nil {
                
                if self.wallet.type == "CUSTOM" {
                    
                    cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                    cell.textLabel?.text = "⚠︎ No private keys on device"
                    
                } else {
                    
                    cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                    cell.textLabel?.text = self.privateKeyDescriptor
                    
                }
                
            }
            
        case 3:
            
            cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
            cell.textLabel?.text = self.recoveryText
            
        default:
            
            return UITableViewCell()
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0: return "BIP39 Mnemonic"
        case 1: return "Public Key Descriptor"
        case 2: return "Private Key Descriptor"
        case 3: return "Bitcoin Core Recovery"
        default: return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = .clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = .systemFont(ofSize: 12, weight: .heavy)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .white
        (view as! UITableViewHeaderFooterView).textLabel?.alpha = 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if wallet != nil {
            
            if wallet.type == "MULTI" {
                
                switch section {
                    
                case 0: return 130
                    
                case 1: return 80
                    
                case 2: return 150
                    
                case 3: return 120
                    
                default:
                    
                    return 0
                    
                }
                
            } else if wallet.type == "DEFAULT"  {
                
                return 80
                
            } else if wallet.type == "CUSTOM" {
                
                switch section {
                    
                case 1, 3: return 80
                                        
                default:
                    
                    return 0
                    
                }
                
            } else {
                
                return 0
                
            }
            
        } else {
            
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 20, height: 150)
        footerView.backgroundColor = .clear
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 150)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .darkGray
        label.numberOfLines = 0
        
        if wallet != nil {
            
            if wallet.type == "CUSTOM" {
                
                switch section {
                    
                case 1:
                    
                    label.text = "Your public key descriptor can be used to easily create watch-only wallets with Bitcoin Core or to supplement multisig wallet recovery. You may use it to derive the public keys and addresses associated with this wallet."
                    footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 50, height: 80)
                    label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: 80)
                    
                case 3:
                    
                    label.text = "You may paste this command directly into a terminal where Bitcoin Core is running and it will automatically import all the public keys and scripts from the descriptor which is held on this device for the current wallet."
                    footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 50, height: 80)
                    label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: 80)
                    
                default:
                    
                    label.text = ""
                    
                }
                
                
            } else if wallet.type == "MULTI" {
                
                switch section {
                    
                case 0:
                    
                    label.text = "This BIP39 mnemonic represents one of three seeds associated with your multisig wallet, this is the only seed held on this device for this wallet. You may use this seed to derive all the private keys needed for signing one of the two required signatures for spending from your StandUp multisig wallet. You should back this up in multiple places, because it is a multisig wallet an attacker can not do anything with this seed alone."
                    footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 50, height: 130)
                    label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: 130)
                    
                case 1:
                    
                    label.text = "You must back this up in order to recover your wallet. Your public key descriptor can be used to easily create watch-only wallets with Bitcoin Core or to supplement multisig wallet recovery. You may use it to derive the public keys and addresses associated with this wallet."
                    footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 50, height: 80)
                    label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: 80)
                    
                case 2:
                    
                    label.text = "Your private key descriptor can be used to recover or spend from your wallet by importing it into your node. You may use it to derive the private keys associated with the seed which is held on this device for the current wallet. This private key descriptor will only allow you to sign for one of the two required signatures needed to spend from your StandUp multisig wallet. In order to fully recover your wallet you also need either your node that you created the wallet on or your recovery seed which should have been saved by you when you created this wallet."
                    footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 50, height: 150)
                    label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: 150)
                    
                case 3:
                    
                    label.text = "You may paste this command directly into a terminal where Bitcoin Core is running and it will automatically import all the private keys from the seed which is held on this device for the current wallet. In order to fully recover your wallet you will also need either your node that you created the wallet on or your recovery seed which should have been saved by you when you created this wallet."
                    footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 50, height: 120)
                    label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: 120)
                    
                default:
                    
                    label.text = ""
                    
                }
                
            } else if wallet.type == "DEFAULT"  {
                
                switch section {
                    
                case 0: label.text = "You can recover this wallet with BIP39 compatible wallets and tools, by default there is no passphrase associated with this mnemonic."
                    footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 50, height: 80)
                    label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: 80)
                    
                case 1: label.text = "Your public key descriptor can be used to easily create watch-only wallets with Bitcoin Core or supplement multisig wallet recovery. You may use it to derive the addresses associated with this wallet."
                    footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 50, height: 80)
                    label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: 80)
                    
                case 2: label.text = "Your private key descriptor can be used to recover or spend from your wallet by importing it into your node. You may use it to derive the private keys associated with this wallet which are held on this device."
                    footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 50, height: 80)
                    label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: 80)
                    
                case 3: label.text = "You may paste these two commands directly into a terminal where Bitcoin Core is running and your node will automatically import all the private keys from the current wallet."
                    footerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.size.width - 50, height: 80)
                    label.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: 80)
                    
                default:
                    
                    label.text = ""
                    
                }
                
            } else {
                
                label.text = ""
                
            }
            
        } else {
            
            label.text = ""
            
        }
        
        footerView.addSubview(label)
        
        return footerView
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            
            self.view.addSubview(self.blurView)
            self.blurView.addGestureRecognizer(self.tap)
            self.view.addSubview(self.customButtons)
            
            let cell = tableView.cellForRow(at: indexPath)
            self.index = indexPath.section
            self.itemToDisplay = cell!.textLabel!.text!

            UIView.animate(withDuration: 0.2, animations: {

                cell?.alpha = 0
                self.blurView.alpha = 1

            }) { _ in
                
                self.customButtons.frame = CGRect(x: self.view.frame.maxX - 200, y: self.view.frame.midY + 50, width: self.customButtons.frame.width, height: self.customButtons.frame.height)

                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.customButtons.alpha = 1
                    cell?.alpha = 1

                }) { _ in
                    
                    let impact = UIImpactFeedbackGenerator()
                    impact.impactOccurred()

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
        keyFetcher.bip32Xpub(wallet: wallet) { (xpub, error) in
            
            if !error {
                
                completion((xpub!))
                
            } else {
                
                completion((""))
                
            }
            
        }
        
    }
    
    func xprv(completion: @escaping ((String)) -> Void) {
        
        let keyFetcher = KeyFetcher()
        keyFetcher.bip32Xprv { (xprv, error) in
            
            if !error {
                
                completion((xprv!))
                
            } else {
                
                completion((""))
                
            }
            
        }
        
    }
    
    func shareRecoveryCommand() {
        
        DispatchQueue.main.async {
            
            let activityViewController = UIActivityViewController(activityItems: [self.recoveryText],
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

extension UIView {
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = (color.withAlphaComponent(0.3)).cgColor
        border.frame = CGRect(x:0, y: (self.frame.size.height - width) + 13, width: (self.frame.size.width * 2) + 15, height: width)
        self.layer.addSublayer(border)
    }
}
