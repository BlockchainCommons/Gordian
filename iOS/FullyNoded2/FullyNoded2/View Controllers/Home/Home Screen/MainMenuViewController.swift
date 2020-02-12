//
//  MainMenuViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit
import KeychainSwift

class MainMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, UINavigationControllerDelegate {
    
    var isRefreshingZero = Bool()
    var isRefreshingOne = Bool()
    var isRefreshingTwo = Bool()
    var existingNodeId = UUID()
    var torConnected = Bool()
    var sectionTwoLoaded = Bool()
    let imageView = UIImageView()
    let progressView = UIProgressView(progressViewStyle: .bar)
    var statusLabel = UILabel()
    var timer:Timer!
    var wallet:WalletStruct!
    var node:NodeStruct!
    var walletInfo:HomeStruct!
    let backView = UIView()
    let ud = UserDefaults.standard
    var hashrateString = String()
    var version = String()
    var incomingCount = Int()
    var outgoingCount = Int()
    var isPruned = Bool()
    var tx = String()
    var currentBlock = Int()
    var transactionArray = [[String:Any]]()
    @IBOutlet var mainMenu: UITableView!
    var refresher: UIRefreshControl!
    var connector:Connector!
    var connectingView = ConnectingView()
    let cd = CoreDataService()
    var nodes = [[String:Any]]()
    var uptime = Int()
    var initialLoad = Bool()
    var mempoolCount = Int()
    var walletDisabled = Bool()
    var torReachable = Bool()
    var progress = ""
    var difficulty = ""
    var feeRate = ""
    var size = ""
    var coldBalance = ""
    var unconfirmedBalance = ""
    var network = ""
    var p2pOnionAddress = ""
    var sectionZeroLoaded = Bool()
    var sectionOneLoaded = Bool()
    let spinner = UIActivityIndicatorView(style: .medium)
    var refreshButton = UIBarButtonItem()
    var dataRefresher = UIBarButtonItem()
    var wallets = NSArray()
    let label = UILabel()
    var existingWalletName = ""
    var fiatBalance = ""
    var sectionThreeLoaded = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        torConnected = false
        mainMenu.delegate = self
        tabBarController?.delegate = self
        navigationController?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .torConnecting, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.foregroundNotificationReceived(_:)), name: .didEnterForeground, object: nil)
        mainMenu.tableFooterView = UIView(frame: .zero)
        initialLoad = true
        sectionZeroLoaded = false
        sectionOneLoaded = false
        sectionTwoLoaded = false
        sectionThreeLoaded = false
        isRefreshingOne = true
        setTitleView()
        addRefreshButton()
        configureRefresher()
        
        if ud.object(forKey: "firstTime") == nil {
            
            firstTimeHere()
            
        } else {
            
            showUnlockScreen()
            
        }
        
        let enc = Encryption()
        enc.getNode { (node, error) in
            
            if !error && node != nil {
                
                self.node = node!
                self.existingNodeId = node!.id
                
                getActiveWalletNow() { (wallet, error) in
                    
                    if !error && wallet != nil {
                        
                        self.wallet = wallet
                        self.existingWalletName = wallet!.name
                        
                    }
                    
                }
                
            }
            
        }
                
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            self.performSegue(withIdentifier: "settings", sender: self)
            
        }
        
    }
    
    
    @objc func notificationReceived(_ notification: Notification) {
        print("notificationReceived TorConnected")
        
        self.torConnected = true
        self.reloadSectionOne()
        //self.sectionOneLoaded = true
        didAppear()

    }
    
    @objc func foregroundNotificationReceived(_ notification: Notification) {
        print("foreground NotificationReceived")
        
        if UIDevice.modelName != "iPhone 11 pro max" && UIDevice.modelName != "Simulator iPhone 11 pro max" {
         
            self.torConnected = false
            self.reloadSectionOne()
            
        } else {
            
            if !initialLoad {
                
                self.isRefreshingOne = true
                
            }
            
            if TorClient.sharedInstance.isOperational {
                
                self.torConnected = true
                
            } else {
                
                self.torConnected = false
                
            }
            
            self.reloadSectionOne()
            
        }

    }
    
    @IBAction func goToWallets(_ sender: Any) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            self.performSegue(withIdentifier: "scanNow", sender: self)
            
        }
        
    }
    
    @objc func walletsSegue() {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            self.performSegue(withIdentifier: "goToWallets", sender: self)
            
        }
        
    }
    
    func setTitleView() {
        
        let imageView = UIImageView(image: UIImage(named: "1024.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
        
    }
    
    func addNavBarSpinner() {

        DispatchQueue.main.async {

            self.spinner.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            self.dataRefresher = UIBarButtonItem(customView: self.spinner)
            self.navigationItem.setRightBarButton(self.dataRefresher, animated: true)
            self.spinner.startAnimating()
            self.spinner.alpha = 1

        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.mainMenu.translatesAutoresizingMaskIntoConstraints = true
        
        if initialLoad {
            
            self.addStatusLabel(description: "     Initiating Tor tunnel...")
            
        }
        
        didAppear()
        
    }
    
    func didAppear() {
        print("didappear")
                
        DispatchQueue.main.async {
            
            self.reloadSectionOne()
            
            let enc = Encryption()
            
            enc.getNode { (node, error) in
                
                if !error {
                                        
                    self.node = node!
                    
                    if self.torConnected {
                        
                        if self.initialLoad {
                            
                            self.initialLoad = false
                            self.refresh()
                            
                        } else {
                            
                            getActiveWalletNow() { (w, error) in
                                                                
                                if !error && w != nil {
                                    
                                    self.wallet = w!
                                    
                                    if self.existingWalletName != w!.name {
                                        
                                        self.loadSectionZero()
                                        
//                                        self.sectionZeroLoaded = false
//
//                                        DispatchQueue.main.async {
//
//                                            self.mainMenu.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
//
//                                        }
//
//                                        self.refreshNow()
                                        
                                    }
                                    
                                } else {
                                    
                                    if self.existingNodeId != node!.id {
                                        
                                        self.refreshNow()
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                } else {
                    
                    self.removeSpinner()
                    self.addNode()
                    
                }
                
            }
                        
        }

    }
    
    @IBAction func lockButton(_ sender: Any) {
        
        showUnlockScreen()
        
    }
    
    func setFeeTarget() {
        
        if ud.object(forKey: "feeTarget") == nil {
            
            ud.set(432, forKey: "feeTarget")
            
        }
        
    }
    
    func showUnlockScreen() {
        
        let keychain = KeychainSwift()
        
        if keychain.get("UnlockPassword") != nil {
            
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "lockScreen", sender: self)
                
            }
            
        }
        
    }
    
    //MARK: Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if transactionArray.count > 0 {
            
            return 3 + transactionArray.count
            
        } else {
            
            return 4
            
        }
                
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func spinningCell() -> UITableViewCell {
        
        let blank = blankCell()
        let spinner = UIActivityIndicatorView()
        spinner.frame = CGRect(x: 16, y: (blank.frame.height / 2) - 10, width: 20, height: 20)
        blank.addSubview(spinner)
        spinner.startAnimating()
        return blank
        
    }
    
    func blankCell() -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.05172085258, green: 0.05855310153, blue: 0.06978280196, alpha: 1)
        return cell
        
    }
    
    func descriptionCell(description: String) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.05172085258, green: 0.05855310153, blue: 0.06978280196, alpha: 1)
        cell.textLabel?.text = description
        cell.textLabel?.textColor = .lightGray
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        switch indexPath.section {
            
        case 0:
            
            if sectionZeroLoaded {
                
                if wallet.type == "DEFAULT" {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "singleSigCell", for: indexPath)
                    cell.selectionStyle = .none
                    
                    let walletNameLabel = cell.viewWithTag(1) as! UILabel
                    let coldBalanceLabel = cell.viewWithTag(2) as! UILabel
                    let walletTypeLabel = cell.viewWithTag(4) as! UILabel
                    let derivationPathLabel = cell.viewWithTag(5) as! UILabel
                    let seedOnDeviceLabel = cell.viewWithTag(8) as! UILabel
                    let seedOnDeviceImage = cell.viewWithTag(10) as! UIImageView
                    let dirtyFiatLabel = cell.viewWithTag(11) as! UILabel
                    let infoButton = cell.viewWithTag(12) as! UIButton
                    //let walletsButton = cell.viewWithTag(13) as! UIButton
                    //let addWalletButton = cell.viewWithTag(14) as! UIButton
                    let deviceXprv = cell.viewWithTag(15) as! UILabel
                    let deviceView = cell.viewWithTag(16)!
                    let refreshingSpinner = cell.viewWithTag(23) as! UIActivityIndicatorView
                    let nodeView = cell.viewWithTag(24)!
                    
                    nodeView.layer.cornerRadius = 8
                    
                    if isRefreshingZero {
                        
                        refreshingSpinner.alpha = 1
                        refreshingSpinner.startAnimating()
                        
                    } else {
                        
                        refreshingSpinner.alpha = 0
                        refreshingSpinner.stopAnimating()
                    }
                    
                    deviceView.layer.cornerRadius = 8
                    
                    //addWalletButton.addTarget(self, action: #selector(addWallet), for: .touchUpInside)
                    infoButton.addTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                    //walletsButton.addTarget(self, action: #selector(walletsSegue), for: .touchUpInside)
                    
                    self.coldBalance = walletInfo.coldBalance
                                    
                    if coldBalance == "" {
                        
                        self.coldBalance = "0"
                        
                    }
                    
                    dirtyFiatLabel.text = "\(self.fiatBalance)"
                    
                    if network == "test" {
                        
                        coldBalanceLabel.textColor = .systemOrange
                        
                    } else if network == "main" {
                        
                        coldBalanceLabel.textColor = .systemGreen
                        
                    }
                    
                    if walletInfo.unconfirmed {
                        
                        coldBalanceLabel.text = self.coldBalance + " " + "BTC ⚠︎"
                        coldBalanceLabel.textColor = .systemRed
                        
                    } else {
                        
                        coldBalanceLabel.text = self.coldBalance + " " + "BTC"
                        
                    }
                    
                    coldBalanceLabel.adjustsFontSizeToFitWidth = true
                    
                    walletTypeLabel.text = "Single Signature"
                    seedOnDeviceLabel.text = "1 Signer on \(UIDevice.current.name)"
                    
//                    var cointype = "1"
//
//                    if walletInfo.network == "main" {
//
//                        cointype = "0"
//
//                    }
                    
                    if wallet.derivation.contains("84") {
                        
                        derivationPathLabel.text = "Native Segwit Account 0 (BIP84 \(wallet.derivation))"
                        
                    } else if wallet.derivation.contains("44") {
                        
                        derivationPathLabel.text = "Legacy Account 0 (BIP44 \(wallet.derivation))"
                        
                    } else if wallet.derivation.contains("49") {
                        
                        derivationPathLabel.text = "P2SH Nested Segwit Account 0 (BIP49 \(wallet.derivation))"
                        
                    }
                    
                    walletNameLabel.text = "\(wallet.name).dat"
                    
                    return cell
                    
                } else if wallet.type == "MULTI" {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath)
                    cell.selectionStyle = .none
                    
                    let walletNameLabel = cell.viewWithTag(1) as! UILabel
                    let coldBalanceLabel = cell.viewWithTag(2) as! UILabel
                    let walletTypeLabel = cell.viewWithTag(4) as! UILabel
                    let derivationPathLabel = cell.viewWithTag(5) as! UILabel
                    let backUpSeedLabel = cell.viewWithTag(6) as! UILabel
                    let seedOnNodeLabel = cell.viewWithTag(7) as! UILabel
                    let seedOnDeviceLabel = cell.viewWithTag(8) as! UILabel
                    //let seedOnNodeImage = cell.viewWithTag(9) as! UIImageView
                    //let seedOnDeviceImage = cell.viewWithTag(10) as! UIImageView
                    let dirtyFiatLabel = cell.viewWithTag(11) as! UILabel
                    let infoButton = cell.viewWithTag(12) as! UIButton
                    //let walletsButton = cell.viewWithTag(13) as! UIButton
                    //let addWalletButton = cell.viewWithTag(14) as! UIButton
                    //let deviceXprv = cell.viewWithTag(15) as! UILabel
                    let deviceView = cell.viewWithTag(16)!
                    //let nodeXprv = cell.viewWithTag(17) as! UILabel
                    let nodeView = cell.viewWithTag(18)!
                    let offlineView = cell.viewWithTag(19)!
                    //let keysOnNodeImage = cell.viewWithTag(20) as! UIImageView
                    //let keyOfflineImage = cell.viewWithTag(21) as! UIImageView
                    //let offlineSignerImage = cell.viewWithTag(22) as! UIImageView
                    let refreshingSpinner = cell.viewWithTag(23) as! UIActivityIndicatorView
                    
                    if isRefreshingZero {
                        
                        refreshingSpinner.alpha = 1
                        refreshingSpinner.startAnimating()
                        
                    } else {
                        
                        refreshingSpinner.alpha = 0
                        refreshingSpinner.stopAnimating()
                    }
                    
                    nodeView.layer.cornerRadius = 8
                    offlineView.layer.cornerRadius = 8
                    deviceView.layer.cornerRadius = 8
                    
                    //addWalletButton.addTarget(self, action: #selector(addWallet), for: .touchUpInside)
                    infoButton.addTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                    //walletsButton.addTarget(self, action: #selector(walletsSegue), for: .touchUpInside)
                    
                    self.coldBalance = walletInfo.coldBalance
                                    
                    if coldBalance == "" {
                        
                        self.coldBalance = "0"
                        
                    }
                    
                    dirtyFiatLabel.text = "\(self.fiatBalance)"
                    
                    if network == "test" {
                        
                        coldBalanceLabel.textColor = .systemOrange
                        
                    } else if network == "main" {
                        
                        coldBalanceLabel.textColor = .systemGreen
                        
                    }
                    
                    if walletInfo.unconfirmed {
                        
                        coldBalanceLabel.text = self.coldBalance + " " + "BTC ⚠︎"
                        coldBalanceLabel.textColor = .systemRed
                        
                    } else {
                        
                        coldBalanceLabel.text = self.coldBalance + " " + "BTC"
                        
                    }
                    
                    coldBalanceLabel.adjustsFontSizeToFitWidth = true
                    
                    walletTypeLabel.text = "2 of 3 multisig"
                    backUpSeedLabel.text = "1 Seed Offline"
                    seedOnNodeLabel.text = "1 Seedless \(node.label)"
                    seedOnDeviceLabel.text = "1 Seed on \(UIDevice.current.name)"
                    nodeView.alpha = 1
                    offlineView.alpha = 1
                    
                    var account = "1"
                    
                    if walletInfo.network == "main" {
                        
                        account = "0"
                        
                    }
                    
                    if wallet.derivation.contains("84") {
                        
                        derivationPathLabel.text = "Native Segwit Account \(account) (BIP84 \(wallet.derivation))"
                        
                    } else if wallet.derivation.contains("44") {
                        
                        derivationPathLabel.text = "Legacy Account \(account) (BIP44 \(wallet.derivation))"
                        
                    } else if wallet.derivation.contains("49") {
                        
                        derivationPathLabel.text = "P2SH Nested Segwit Account \(account) (BIP49 \(wallet.derivation))"
                        
                    }
                    
                    walletNameLabel.text = "\(wallet.name).dat"
                    
                    return cell
                    
                } else {
                    
                    let cell = mainMenu.dequeueReusableCell(withIdentifier: "coldStorageCell", for: indexPath)
                    cell.selectionStyle = .none
                    
                    let walletNameLabel = cell.viewWithTag(1) as! UILabel
                    let coldBalanceLabel = cell.viewWithTag(2) as! UILabel
                    let walletTypeLabel = cell.viewWithTag(4) as! UILabel
                    let derivationPathLabel = cell.viewWithTag(5) as! UILabel
                    let seedOnDeviceLabel = cell.viewWithTag(8) as! UILabel
                    let dirtyFiatLabel = cell.viewWithTag(11) as! UILabel
                    let infoButton = cell.viewWithTag(12) as! UIButton
                    let refreshingSpinner = cell.viewWithTag(23) as! UIActivityIndicatorView
                    let nodeView = cell.viewWithTag(24)!
                    
                    nodeView.layer.cornerRadius = 8
                    
                    if isRefreshingZero {
                        
                        refreshingSpinner.alpha = 1
                        refreshingSpinner.startAnimating()
                        
                    } else {
                        
                        refreshingSpinner.alpha = 0
                        refreshingSpinner.stopAnimating()
                    }
                    
                    
                    infoButton.addTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                    
                    self.coldBalance = walletInfo.coldBalance
                    
                    if coldBalance == "" {
                        
                        self.coldBalance = "0"
                        
                    }
                    
                    dirtyFiatLabel.text = "\(self.fiatBalance)"
                    
                    if network == "test" {
                        
                        coldBalanceLabel.textColor = .systemOrange
                        
                    } else if network == "main" {
                        
                        coldBalanceLabel.textColor = .systemGreen
                        
                    }
                    
                    if walletInfo.unconfirmed {
                        
                        coldBalanceLabel.text = self.coldBalance + " " + "BTC ⚠︎"
                        coldBalanceLabel.textColor = .systemRed
                        
                    } else {
                        
                        coldBalanceLabel.text = self.coldBalance + " " + "BTC"
                        
                    }
                    
                    coldBalanceLabel.adjustsFontSizeToFitWidth = true
                    
                    walletTypeLabel.text = "Custom"
                    seedOnDeviceLabel.text = "1 Watch-only wallet on \(node.label)"
                    
                    // need to parse the descriptor or key
                    
                    if wallet.derivation.contains("84") {
                        
                        derivationPathLabel.text = "Native Segwit Account 0 (BIP84 \(wallet.derivation))"
                        
                    } else if wallet.derivation.contains("44") {
                        
                        derivationPathLabel.text = "Legacy Account 0 (BIP44 \(wallet.derivation))"
                        
                    } else if wallet.derivation.contains("49") {
                        
                        derivationPathLabel.text = "P2SH Nested Segwit Account 0 (BIP49 \(wallet.derivation))"
                        
                    }
                    
                    walletNameLabel.text = "\(wallet.name).dat"
                    
                    return cell
                }
                
            } else {
                
                if sectionOneLoaded && self.node != nil && self.wallet != nil && self.torConnected {
                    
                    let spinner = spinningCell()
                    return spinner
                    
                } else if sectionOneLoaded && wallet == nil && self.torConnected {
                    
                    let cell = descriptionCell(description: "⚠︎ No active wallet")
                    let addWalletButton = UIButton()
                    addWalletButton.frame = CGRect(x: cell.frame.maxX, y: (cell.frame.height / 2) - 10, width: 20, height: 20)
                    addWalletButton.addTarget(self, action: #selector(addWallet), for: .touchUpInside)
                    let image = UIImage(systemName: "plus")
                    addWalletButton.setImage(image, for: .normal)
                    addWalletButton.tintColor = .systemBlue
                    cell.addSubview(addWalletButton)
                    
                    return cell
                    
                } else {
                    
                    let blank = blankCell()
                    return blank
                    
                }
                
            }
            
        case 1:
                        
            if node != nil {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "torCell", for: indexPath)
                cell.selectionStyle = .none
                let torStatusLabel = cell.viewWithTag(1) as! UILabel
                let p2pOnionLabel = cell.viewWithTag(3) as! UILabel
                let onionVersionLabel = cell.viewWithTag(4) as! UILabel
                let connectionStatusLabel = cell.viewWithTag(5) as! UILabel
                let v3address = cell.viewWithTag(6) as! UILabel
                let torActiveCircle = cell.viewWithTag(7) as! UIImageView
                let spinner = cell.viewWithTag(8) as! UIActivityIndicatorView
                let infoButton = cell.viewWithTag(9) as! UIButton
                spinner.startAnimating()
                spinner.alpha = 1
                
                infoButton.addTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                
                let onionAddress = (node.onionAddress.split(separator: "."))[0]
                
                if onionAddress.count == 16 {
                    
                    onionVersionLabel.text = "bitcoin core rpc hidden service version 2"
                    
                } else if onionAddress.count == 56 {
                    
                    onionVersionLabel.text = "bitcoin core rpc hidden service version 3"
                    
                }
                
                if isRefreshingOne {
                    
                    spinner.startAnimating()
                    spinner.alpha = 1
                    
                } else {
                    
                    spinner.stopAnimating()
                    spinner.alpha = 0
                    
                }
                
                let first10 = String(node.onionAddress.prefix(5))
                let last15 = String(node.onionAddress.suffix(15))
                v3address.text = "💻 ← \(first10)*****\(last15) → 📱"
                
                if sectionOneLoaded {
                    
                    connectionStatusLabel.text = "connected to \(node.label)"
                    p2pOnionLabel.text = "P2P URL: \(p2pOnionAddress)"
                    
                } else {
                    
                    connectionStatusLabel.text = "establishing connection to \(node.label)"
                    p2pOnionLabel.text = "fetching network info from your node..."
                    
                }
                
                if self.torConnected {
                    
                    torStatusLabel.text = "connected"
                    torActiveCircle.image = UIImage.init(imageLiteralResourceName: "greenCircle.png")
                    
                    if sectionOneLoaded && !isRefreshingOne {
                        
                        spinner.stopAnimating()
                        spinner.alpha = 0
                        
                    } else if isRefreshingOne && !sectionOneLoaded {
                        
                        spinner.startAnimating()
                        spinner.alpha = 1
                        
                    }
                    
                } else {
                    
                    torStatusLabel.text = "disconnected"
                    torActiveCircle.image = UIImage.init(imageLiteralResourceName: "redCircle.png")
                    connectionStatusLabel.text = "disconnected..."
                    
                    spinner.startAnimating()
                    spinner.alpha = 1
                    
                    
                }
                
                return cell
                
            } else {
                
                return blankCell()
                
            }
            
        case 2:
            
            if sectionTwoLoaded {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NodeInfo", for: indexPath)
                cell.selectionStyle = .none
                cell.isSelected = false
                
                let network = cell.viewWithTag(1) as! UILabel
                let pruned = cell.viewWithTag(2) as! UILabel
                let connections = cell.viewWithTag(3) as! UILabel
                let version = cell.viewWithTag(4) as! UILabel
                let hashRate = cell.viewWithTag(5) as! UILabel
                let sync = cell.viewWithTag(6) as! UILabel
                let blockHeight = cell.viewWithTag(7) as! UILabel
                let uptime = cell.viewWithTag(8) as! UILabel
                let mempool = cell.viewWithTag(10) as! UILabel
                let tor = cell.viewWithTag(11) as! UILabel
                let difficultyLabel = cell.viewWithTag(12) as! UILabel
                let sizeLabel = cell.viewWithTag(13) as! UILabel
                let feeRate = cell.viewWithTag(14) as! UILabel
                let isHot = cell.viewWithTag(15) as! UILabel
                let refreshingSpinner = cell.viewWithTag(16) as! UIActivityIndicatorView
                let infoButton = cell.viewWithTag(17) as! UIButton
                
                infoButton.addTarget(self, action: #selector(getWalletInfo(_:)), for: .touchUpInside)
                
                network.layer.cornerRadius = 6
                pruned.layer.cornerRadius = 6
                connections.layer.cornerRadius = 6
                version.layer.cornerRadius = 6
                hashRate.layer.cornerRadius = 6
                sync.layer.cornerRadius = 6
                blockHeight.layer.cornerRadius = 6
                uptime.layer.cornerRadius = 6
                mempool.layer.cornerRadius = 6
                tor.layer.cornerRadius = 6
                difficultyLabel.layer.cornerRadius = 6
                sizeLabel.layer.cornerRadius = 6
                feeRate.layer.cornerRadius = 6
                isHot.layer.cornerRadius = 6
                
                if isRefreshingTwo {
                    
                    refreshingSpinner.alpha = 1
                    refreshingSpinner.startAnimating()
                    
                } else {
                    
                    refreshingSpinner.alpha = 0
                    refreshingSpinner.stopAnimating()
                }
                
                sizeLabel.text = "\(self.size) size"
                difficultyLabel.text = "\(self.difficulty) difficulty"
                
                if self.progress == "99%" {
                    
                    sync.text = "fully synced"
                    
                } else {
                    
                    sync.text = "\(self.progress) synced"
                    
                }
                
                feeRate.text = "\(self.feeRate) fee rate"
                
                isHot.textColor = .white
                
                if wallet != nil {
                    
                    isHot.alpha = 1
                    
                    if wallet.type == "DEFAULT" {
                        
                        isHot.backgroundColor = .systemBlue
                        isHot.text = "watch-only"
                        
                    } else if wallet.type == "MULTI" {
                        
                        isHot.backgroundColor = .systemYellow
                        isHot.text = "signer"
                        
                    } else if wallet.type == "CUSTOM" {
                        
                        isHot.backgroundColor = .systemBlue
                        isHot.text = "watch-only"
                    }
                    
                } else {
                    
                    isHot.alpha = 0
                    
                }
                
                if torReachable {
                    
                    tor.text = "Tor on"
                    
                } else {
                    
                    tor.text = "Tor off"
                    
                }
                
                mempool.text = "\(self.mempoolCount.withCommas()) mempool"
                
                if self.isPruned {
                    
                    pruned.text = "pruned"
                    
                } else if !self.isPruned {
                    
                    pruned.text = "not pruned"
                }
                
                if self.network != "" {
                    
                    if self.network == "main" {
                        
                        network.text = "mainnet"
                        network.backgroundColor = .systemGreen
                        
                    } else if self.network == "test" {
                        
                        network.text = "⚠ testnet"
                        network.backgroundColor = .systemOrange
                        network.textColor = .white
                        
                    } else {
                        
                        network.text = self.network
                        
                    }
                    
                }
                
                blockHeight.text = "\(self.currentBlock.withCommas()) blocks"
                connections.text = "\(incomingCount) ↓ \(outgoingCount) ↑ connections"
                version.text = "Bitcoin Core v\(self.version)"
                hashRate.text = self.hashrateString + " " + "EH/s hashrate"
                uptime.text = "\(self.uptime / 86400) days uptime"
                
                return cell
                
            } else {
                
                if sectionOneLoaded {
                    
                    let spinner = spinningCell()
                    return spinner
                    
                } else {
                    
                    let blank = blankCell()
                    return blank
                    
                }
                
                
            }
            
        default:
            
            if !sectionThreeLoaded {
                
                if sectionZeroLoaded {
                    
                    return spinningCell()
                    
                } else {
                    
                    if self.wallet == nil && sectionTwoLoaded {
                        
                        return descriptionCell(description: "⚠︎ No active wallet")
                        
                    } else if self.wallet != nil && sectionTwoLoaded {
                        
                        return descriptionCell(description: "No transactions")
                        
                    } else {
                        
                        return blankCell()
                        
                    }
                    
                }
                
            } else {
                
                if transactionArray.count > 0 {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MainMenuCell", for: indexPath)
                    cell.selectionStyle = .none
                    
                    tableView.separatorColor = .darkGray
                    
                    let amountLabel = cell.viewWithTag(2) as! UILabel
                    let confirmationsLabel = cell.viewWithTag(3) as! UILabel
                    let labelLabel = cell.viewWithTag(4) as! UILabel
                    let dateLabel = cell.viewWithTag(5) as! UILabel
                    let infoButton = cell.viewWithTag(6) as! UIButton
                    
                    infoButton.addTarget(self, action: #selector(getTransaction(_:)), for: .touchUpInside)
                    infoButton.restorationIdentifier = "\( indexPath.section)"
                    amountLabel.alpha = 1
                    confirmationsLabel.alpha = 1
                    labelLabel.alpha = 1
                    dateLabel.alpha = 1
                    
                    let dict = self.transactionArray[indexPath.section - 3]
                                    
                    confirmationsLabel.text = (dict["confirmations"] as! String) + " " + "confs"
                    let label = dict["label"] as? String
                    
                    if label != "," {
                        
                        labelLabel.text = label
                        
                    } else if label == "," {
                        
                        labelLabel.text = ""
                        
                    }
                    
                    dateLabel.text = dict["date"] as? String
                    
                    if dict["abandoned"] as? Bool == true {
                        
                        cell.backgroundColor = UIColor.red
                        
                    }
                    
                    let amount = dict["amount"] as! String
                    var textColor = UIColor.darkGray
                    let confs = Int(dict["confirmations"] as! String)!
                    
                    if confs == 0 {
                        
                        textColor = .systemRed
                        
                    } else if confs < 6 {
                     
                        textColor = .systemYellow
                        
                    }
                    
                    let selfTransfer = dict["selfTransfer"] as! Bool
                    
                    if amount.hasPrefix("-") {
                    
                        amountLabel.text = amount
                        
                    } else {
                        
                        if confs == 0 {
                            
                            textColor = .systemRed
                            
                        } else if confs < 6 {
                             
                            textColor = .systemYellow
                                
                        } else {
                            
                            textColor = .white
                            
                        }
                        
                        amountLabel.text = "+" + amount
                                            
                    }
                    
                    if selfTransfer {
                        
                        amountLabel.text = (amountLabel.text!).replacingOccurrences(of: "+", with: "🔄")
                        amountLabel.text = (amountLabel.text!).replacingOccurrences(of: "-", with: "🔄")
                        
                    }
                    
                    if confs == 0 {
                        
                        amountLabel.text = "⚠︎ \(amountLabel.text!)"
                        
                    }
                    
                    amountLabel.textColor = textColor
                    labelLabel.textColor = textColor
                    confirmationsLabel.textColor = textColor
                    dateLabel.textColor = textColor
                    
                    return cell
                    
                } else {
                    
                    if self.wallet == nil {
                        
                        return descriptionCell(description: "⚠︎ No active wallet")
                        
                    } else {
                        
                        return descriptionCell(description: "No transactions")
                        
                    }
                    
                }
               
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                    
        var sectionString = ""
        switch section {
        case 0: sectionString = "Wallet Info"
        case 1: sectionString = "Tor Status"
        case 2: sectionString = "Full Node Status"
        case 3: sectionString = "Transaction History"
        default: break}
        return sectionString
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .systemGray
        (view as! UITableViewHeaderFooterView).textLabel?.alpha = 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
            
        case 0:
            
            return 30
            
        case 1, 2, 3:
            
            return 20
            
        default:
            
            return 5
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case 0:
                        
            if sectionZeroLoaded {
                
                if wallet.type == "MULTI" {
                    
                    return 290
                    
                } else if wallet.type == "CUSTOM" {
                    
                    return 188
                    
                } else {
                    
                    return 255
                    
                }

            } else {

                return 47

            }
            
        case 1:
            
            if self.node != nil {
                
                return 129
                
            } else {
                
                return 47
                
            }
                        
        case 2:
            
            if sectionTwoLoaded {
                
                return 192
                
            } else {
                
                return 47
                
            }
            
        default:
            
            if sectionThreeLoaded {
                
                return 80
                
            } else {
                
                return 47
                
            }
            
        }
        
    }
    
    @objc func getWalletInfo(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            
            self.performSegue(withIdentifier: "walletInfo", sender: self)
            
        }
        
    }
    
    func updateWalletMetaData(wallet: WalletStruct) {
        
        let cd = CoreDataService()
        cd.updateEntity(id: wallet.id, keyToUpdate: "lastBalance", newValue: Double(self.walletInfo.coldBalance)!, entityName: .wallets) {
            
            if !cd.errorBool {
                
                print("succesfully updated lastBalance")
                
            } else {
                
                print("error saving lastBalance")
                
            }
            
        }
        
        cd.updateEntity(id: wallet.id, keyToUpdate: "lastUsed", newValue: Date(), entityName: .wallets) {
            
            if !cd.errorBool {
                
                print("succesfully updated lastUsed")
                
            } else {
                
                print("error saving lastUsed")
                
            }
            
        }
        
    }
    
    func loadSectionOne() {
        
        if self.node != nil {
            
            statusLabel.text = "     Getting Tor network data..."
            let nodeLogic = NodeLogic()
            nodeLogic.loadSectionOne {
                
                if !nodeLogic.errorBool {
                    
                    let s = HomeStruct(dictionary: nodeLogic.dictToReturn)
                    self.p2pOnionAddress = s.p2pOnionAddress
                    self.version = s.version
                    self.torReachable = s.torReachable
                    
                    self.sectionOneLoaded = true
                    self.isRefreshingOne = false
                    
                    if self.wallet != nil {
                        
                        DispatchQueue.main.async {
                            
                            self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 1, 0), with: .fade)
                            
                        }
                        
                        self.loadSectionZero()
                        
                    } else {
                        
                        DispatchQueue.main.async {
                            
                            self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 1, 2), with: .fade)
                            
                        }
                        
                        self.loadSectionTwo()
                                                                        
                    }
                    
                } else {
                    
                    self.sectionOneLoaded = false
                    self.removeStatusLabel()
                    self.removeSpinner()
                    
                    self.isRefreshingOne = false
                    
                    DispatchQueue.main.async {
                        self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 1), with: .fade)
                    }
                    
                    displayAlert(viewController: self,
                                 isError: true,
                                 message: nodeLogic.errorDescription)
                                        
                }
                
            }
            
        }
        
    }
    
    func loadSectionZero() {
        
        self.isRefreshingZero = true
        DispatchQueue.main.async {
            self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 0), with: .fade)
        }
        
        DispatchQueue.main.async {
            
            self.statusLabel.text = "     Getting wallet info..."
            
        }
                        
        let nodeLogic = NodeLogic()
        nodeLogic.wallet = self.wallet
        self.existingWalletName = self.wallet.name
        nodeLogic.walletDisabled = false
        
        func completion() {
            print("completion")
            
            if nodeLogic.errorBool {
                
                self.sectionZeroLoaded = false
                self.removeStatusLabel()
                self.removeSpinner()
                self.isRefreshingZero = false
                
                DispatchQueue.main.async {
                    self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 0), with: .fade)
                }
                
                displayAlert(viewController: self,
                             isError: true,
                             message: nodeLogic.errorDescription)
                
            } else {
                
                let dict = nodeLogic.dictToReturn
                self.walletInfo = HomeStruct(dictionary: dict)
                
                DispatchQueue.main.async {
                    
                    self.updateWalletMetaData(wallet: self.wallet)
                    self.sectionZeroLoaded = true
                    self.isRefreshingZero = false
                    self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 0, 3), with: .fade)
                    let impact = UIImpactFeedbackGenerator()
                    impact.impactOccurred()
                    self.loadSectionThree()
                    
                }
                
            }
            
        }
        
        nodeLogic.loadSectionZero(completion: completion)
        
    }
    
    func loadSectionTwo() {
        print("loadSectionTwo")
        
        self.isRefreshingTwo = true
        
        DispatchQueue.main.async {
            
            self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 2), with: .fade)
            self.statusLabel.text = "     Getting Full Node data..."
            
        }
        
        let nodeLogic = NodeLogic()
        nodeLogic.wallet = wallet
        nodeLogic.walletDisabled = walletDisabled
        
        func completion() {
            
            if nodeLogic.errorBool {
                
                self.sectionTwoLoaded = false
                self.removeSpinner()
                self.removeStatusLabel()
                self.isRefreshingTwo = false
                
                DispatchQueue.main.async {
                    self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 2), with: .fade)
                }
                
                
                displayAlert(viewController: self,
                             isError: true,
                             message: nodeLogic.errorDescription)
                
            } else {
                
                let dict = nodeLogic.dictToReturn
                let str = HomeStruct(dictionary: dict)
                feeRate = str.feeRate
                mempoolCount = str.mempoolCount
                network = str.network
                size = str.size
                difficulty = str.difficulty
                progress = str.progress
                isPruned = str.pruned
                incomingCount = str.incomingCount
                outgoingCount = str.outgoingCount
                hashrateString = str.hashrate
                uptime = str.uptime
                currentBlock = str.blockheight
                sectionTwoLoaded = true
                
                self.isRefreshingTwo = false
                
                DispatchQueue.main.async {
                    
                    if self.wallet == nil {
                        
                        self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 0, 2, 3), with: .fade)
                        
                    } else {
                        
                        self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 2, 0), with: .fade)
                        
                    }
                    
                    let impact = UIImpactFeedbackGenerator()
                    impact.impactOccurred()
                    self.removeSpinner()
                    self.removeStatusLabel()
                    
                }
                
            }
            
        }
        
        nodeLogic.loadSectionTwo(completion: completion)
        
    }
    
    func loadSectionThree() {
        
        statusLabel.text = "     Getting transactions..."
        
        let nodeLogic = NodeLogic()
        nodeLogic.wallet = wallet
        nodeLogic.walletDisabled = walletDisabled
        
        func completion() {
            
            if nodeLogic.errorBool {
                
                self.sectionThreeLoaded = false
                self.removeSpinner()
                self.removeStatusLabel()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: nodeLogic.errorDescription)
                
            } else {
                
                self.transactionArray.removeAll()
                self.transactionArray = nodeLogic.arrayToReturn.reversed()
                self.sectionThreeLoaded = true
                                
                DispatchQueue.main.async {
                    
                    self.mainMenu.reloadData()
                    let impact = UIImpactFeedbackGenerator()
                    impact.impactOccurred()
                    self.loadSectionTwo()
                    
                }
                
            }
            
        }
        
        nodeLogic.loadSectionThree(completion: completion)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let impact = UIImpactFeedbackGenerator()
//
//        func fade() {
//
//            DispatchQueue.main.async {
//
//                impact.impactOccurred()
//
//            }
//
//            let cell = tableView.cellForRow(at: indexPath)!
//
//            DispatchQueue.main.async {
//
//                UIView.animate(withDuration: 0.2, animations: {
//
//                    cell.alpha = 0
//
//                }) { _ in
//
//                    UIView.animate(withDuration: 0.2, animations: {
//
//                        cell.alpha = 1
//
//                    })
//
//                }
//
//            }
//
//        }
        
        if indexPath.section == 0 {
            
            
            
        } else if indexPath.section == 1 {
            
//            DispatchQueue.main.async {
//
//                self.performSegue(withIdentifier: "torInfo", sender: self)
//
//            }
            
        } else if indexPath.section == 2 {
            
            //addNavBarSpinner()
            //loadSectionZero()
            
        } else if indexPath.section > 2 {
            
//            if transactionArray.count > 0 {
//
//
//
//            }
            
        }
        
    }
    
    @objc func getTransaction(_ sender: UIButton) {
        
        let impact = UIImpactFeedbackGenerator()
        let index = Int(sender.restorationIdentifier!)!
        let selectedTx = self.transactionArray[index - 3]
        let txID = selectedTx["txID"] as! String
        self.tx = txID
        UIPasteboard.general.string = txID
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            self.performSegue(withIdentifier: "getTransaction", sender: self)
            
        }
        
    }
    
    func getDirtyFiatBalance() {
        
        let converter = FiatConverter()
        
        func getResult() {
            
            if !converter.errorBool {
                
                let rate = converter.fxRate
                
                guard let coldDouble = Double(self.coldBalance.replacingOccurrences(of: ",", with: "")) else {
                    
                    return
                    
                }
                
                let formattedColdDouble = ((coldDouble * rate).rounded()).withCommas()
                self.fiatBalance = "﹩\(formattedColdDouble) USD"
                
                DispatchQueue.main.async {
                    
                    self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 0), with: .fade)
                    
                }
                
            }
            
        }
        
        converter.getFxRate(completion: getResult)
    }
    
    //MARK: User Interface
    
    func configureLaunchScreen() {
        
        DispatchQueue.main.async {
            
            self.backView.alpha = 0
            self.backView.frame = self.view.frame
            self.backView.backgroundColor = .black
            self.imageView.frame = CGRect(x: self.view.center.x - (75 / 2), y: self.view.center.y - (75 / 2), width: 75, height: 75)
            self.imageView.image = UIImage(named: "1024.png")
            
            self.progressView.trackTintColor = .clear
            self.progressView.tintColor = .blue
            self.progressView.frame = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: self.backView.frame.width, height: 5)
            
            self.label.frame = CGRect(x: 16, y: self.progressView.frame.maxY + 5, width: self.view.frame.width - 32, height: 13)
            self.label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            self.label.adjustsFontSizeToFitWidth = true
            self.label.textAlignment = .left
            self.label.textColor = .white
            self.label.text = "Connecting Tor... progress 0%"
            self.label.numberOfLines = 0
            
        }
        
        
    }
    
    func addStatusLabel(description: String) {
        print("addstatuslabel = \(description)")
        
        //Matshona Dhliwayo — 'Great things take time; that is why seeds persevere through rocks and dirt to bloom.'
        
        DispatchQueue.main.async {
            
            self.statusLabel.removeFromSuperview()
            self.statusLabel.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: 50)
            self.statusLabel.backgroundColor = .black
            self.statusLabel.textAlignment = .left
            self.statusLabel.textColor = .lightGray
            self.statusLabel.font = .systemFont(ofSize: 12)
            self.statusLabel.text = description
            self.view.addSubview(self.statusLabel)
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.statusLabel.frame = CGRect(x: 16, y: self.navigationController!.navigationBar.frame.maxY + 5, width: self.view.frame.width - 32, height: 13)
                self.mainMenu.frame = CGRect(x: 0, y: self.statusLabel.frame.maxY, width: self.mainMenu.frame.width, height: self.mainMenu.frame.height)
                
            })
            
        }
        
    }
    
    func removeStatusLabel() {
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.statusLabel.frame.origin.y = -50
                self.mainMenu.frame = CGRect(x: 0, y: 0, width: self.mainMenu.frame.width, height: self.view.frame.height)
                
            }) { (_) in
                
                self.statusLabel.removeFromSuperview()
                
            }
            
        }
        
    }
    
    func removeSpinner() {
        
        DispatchQueue.main.async {
            
            self.refresher.endRefreshing()
            self.spinner.stopAnimating()
            self.spinner.alpha = 0
            self.addRefreshButton()
            
        }
        
    }
    
    func addRefreshButton() {
        
        DispatchQueue.main.async {
            
            self.refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                 target: self,
                                                 action: #selector(self.refreshNow))
            
            self.refreshButton.tintColor = UIColor.white.withAlphaComponent(1)
            
            self.navigationItem.setRightBarButtonItems([self.refreshButton], animated: true)
            
        }
    }
    
    @objc func addWallet() {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
        
            impact.impactOccurred()
            
        }
        
        if self.torConnected {
            
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "To create a wallet, select a type below", message: "", preferredStyle: .actionSheet)

                alert.addAction(UIAlertAction(title: "Single-Sig", style: .default, handler: { action in
                    
                    self.createSingleSig()

                }))
                
                alert.addAction(UIAlertAction(title: "Multi-Sig", style: .default, handler: { action in
                    
                    self.createMultiSig()

                }))
                
                alert.addAction(UIAlertAction(title: "Import Custom", style: .default, handler: { action in
                    
                    self.importCustom()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in }))
                        
                self.present(alert, animated: true, completion: nil)
                
            }
            
        } else {
            
            showAlert(vc: self, title: "Tor not connected", message: "You need to be connected to a node over tor in order to create a wallet")
            
        }
        
    }
    
    func importCustom() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "import", sender: self)
            
        }
        
    }
    
    func createMultiSig() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "createMuSig", sender: self)
            
        }
        
    }
    
    func createSingleSig() {
        
        connectingView.addConnectingView(vc: self, description: "Creating single-sig wallet")
        
        let enc = Encryption()
        let keyCreator = KeychainCreator()
        keyCreator.createKeyChain() { (mnemonic, error) in
            
            if !error {
                
                let dataToEncrypt = mnemonic!.dataUsingUTF8StringEncoding
                enc.encryptData(dataToEncrypt: dataToEncrypt) { (encryptedData, error) in
                    
                    if !error {
                        
                        let walletSaver = WalletSaver()
                        var newWallet = [String:Any]()
                        newWallet["birthdate"] = keyBirthday()
                        newWallet["id"] = UUID()
                        newWallet["derivation"] = "m/84'/1'/0'/0"
                        newWallet["isActive"] = false
                        newWallet["name"] = "\(randomString(length: 10))_StandUp"
                        newWallet["seed"] = encryptedData!
                        newWallet["lastUsed"] = Date()
                        newWallet["lastBalance"] = 0.0
                        newWallet["type"] = "DEFAULT"
                        newWallet["nodeId"] = self.node.id
                        newWallet["isArchived"] = false
                        
                        let walletCreator = WalletCreator()
                        walletCreator.walletDict = newWallet
                        walletCreator.node = self.node
                        
                        walletCreator.createStandUpWallet(derivation: "m/84'/1'/0'/0") { (success, errorDescription, descriptor) in
                            
                            if success {
                                
                                newWallet["descriptor"] = descriptor!
                                
                                walletSaver.save(walletToSave: newWallet) { (success) in
                                    
                                    if success {
                                        
                                        print("wallet saved")
                                        
                                        self.connectingView.removeConnectingView()
                                        
                                        showAlert(vc: self, title: "Success!", message: "Single sig wallet created, if you have more then one wallet you need to go to the wallets screen and tap it to activate it")
                                        
                                        self.refreshNow()
                                                                                
                                    } else {
                                        
                                        print("error saving wallet")
                                        displayAlert(viewController: self, isError: true, message: "There was an error saving your wallet")
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                self.connectingView.removeConnectingView()
                                displayAlert(viewController: self, isError: true, message: "There was an error creating your wallet: \(errorDescription!)")
                                
                            }
                            
                        }
                        
                    } else {
                        
                        self.connectingView.removeConnectingView()
                        displayAlert(viewController: self, isError: true, message: "There was an error encrypting your seed")
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func configureRefresher() {
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        
        refresher.attributedTitle = NSAttributedString(string: "refresh data",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        refresher.addTarget(self, action: #selector(self.refreshNow), for: UIControl.Event.valueChanged)
        
        mainMenu.addSubview(refresher)
        
    }
    
    //MARK: User Actions
    
    @objc func closeConnectingView() {
        
        DispatchQueue.main.async {
            self.connectingView.removeConnectingView()
        }
        
    }
    
    @objc func refreshNow() {
        print("refresh")
        
        self.isRefreshingOne = true
        self.mainMenu.reloadSections(IndexSet(arrayLiteral: 1), with: .fade)
        self.reloadTableData()
        
    }
    
    @objc func refresh() {
        print("refresh")
        
        self.reloadTableData()
        
    }
    
    func updateLabel(text: String) {
        
        DispatchQueue.main.async {
            let animation = CATransition()
            self.label.layer.add(animation, forKey: nil)
            self.label.text = text
        }
        
    }
    
    func addNode() {
        
        if ud.object(forKey: "showIntro") == nil {
            
            DispatchQueue.main.async {
                
                self.removeSpinner()
                self.performSegue(withIdentifier: "showIntro", sender: self)
                
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.removeSpinner()
                self.performSegue(withIdentifier: "scanNow", sender: self)
                
            }
            
        }
        
    }
    
    func reloadTableData() {
        
        addNavBarSpinner()
        self.refresher.endRefreshing()
        self.addStatusLabel(description: "     Getting Tor Network Info...")
        
        getActiveWalletNow() { (w, error) in
                
            if !error {
                
                self.loadSectionOne()
                                
            } else {
                                
                if self.node != nil {
                    
                     self.loadSectionOne()
                    
                } else {
                    
                    self.isRefreshingOne = false
                    self.removeSpinner()
                    self.removeStatusLabel()
                    displayAlert(viewController: self, isError: true, message: "no active node, please go to node manager and activate one")
                    
                }
                
            }
            
        }
        
    }
    
    func reloadSectionOne() {
        
        DispatchQueue.main.async {
            
            self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 1), with: .fade)
            
        }
        
    }
    
    func nodeJustAdded() {
        print("nodeJustAdded")
        
        let enc = Encryption()
        enc.getNode { (node, error) in
            
            if !error && node != nil {
                
                self.node = node!
                self.reloadSectionOne()
                
                if !self.torConnected {
                    
                    TorClient.sharedInstance.start {
                        
                        self.didAppear()
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "createMuSig":
            
            if let vc = segue.destination as? CreateMultiSigViewController {
                
                vc.onDoneBlock1 = { result in
                    
                    let cd = CoreDataService()
                    cd.retrieveEntity(entityName: .wallets) { (wallets, errorDescription) in
                        
                        if wallets != nil {
                            
                            var numberOfUnarchivedWallets = 0
                            
                            for w in wallets! {
                                
                                let ws = WalletStruct(dictionary: w)
                                
                                if !ws.isArchived {
                                    
                                    numberOfUnarchivedWallets += 1
                                    
                                }
                                
                            }
                            
                            if wallets!.count == 1 || numberOfUnarchivedWallets == 1 {
                                
                                self.addStatusLabel(description: "")
                                self.sectionZeroLoaded = false
                                self.sectionThreeLoaded = false
                                
                                showAlert(vc: self, title: "Success!", message: "2 of 3 multi-sig wallet created successfully!")
                                
                            } else {
                                
                                showAlert(vc: self, title: "Success!", message: "2 of 3 multi-sig wallet created successfully!\n\nYou have more then one wallet on this node so we have not activated the newly created wallet yet, please go to wallet manager to activate it.")
                                
                            }
                            
                        }
                        
                    }
                    
                    self.didAppear()
                    
                }
                
            }
            
        case "goToWallets":
            
            if let vc = segue.destination as? WalletsViewController {
                
                vc.node = self.node
                
            }
            
        case "getTransaction":
            
            if let vc = segue.destination as? TransactionViewController {
                
                vc.txid = tx
                
            }
            
        case "scanNow":
            
            if let vc = segue.destination as? ScannerViewController {
                
                vc.onDoneBlock = { result in
                    
                    self.addNavBarSpinner()
                    self.nodeJustAdded()
                    
                }
                
            }
            
        case "torInfo":
            
            if let vc = segue.destination as? TableDetailViewController {
                
                vc.textToShow = "Insert detailed info about the tor connections and hidden services..."
                
            }
            
        case "walletInfo":
            
            if let vc = segue.destination as? TableDetailViewController {
                
                vc.textToShow = "Insert detailed info about the wallet, seeds etc..."
                
            }
            
        default:
            
            break
            
        }
        
    }
    
    //MARK: Helpers
    
    func firstTimeHere() {
        
        setFeeTarget()
        
        let firstTime = FirstTime()
        firstTime.firstTimeHere { (success) in
            
            if success {
                
                self.showUnlockScreen()
                //self.setExistingWallet()
                
            } else {
                
                print("error setting first time data")
                
            }
            
        }
        
    }
    
}

extension Double {
    
    func withCommas() -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
        
    }
    
}

//extension MainMenuViewController  {
//    
//    func tabBarController(_ tabBarController: UITabBarController,
//                          animationControllerForTransitionFrom fromVC: UIViewController,
//                          to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        return MyTransition(viewControllers: tabBarController.viewControllers)
//        
//    }
//    
//}
