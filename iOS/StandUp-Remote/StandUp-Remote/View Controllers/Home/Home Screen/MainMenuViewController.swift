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
    var sectionZeroLoaded = Bool()
    var sectionOneLoaded = Bool()
    let spinner = UIActivityIndicatorView(style: .medium)
    var refreshButton = UIBarButtonItem()
    var dataRefresher = UIBarButtonItem()
    var wallets = NSArray()
    var viewHasLoaded = Bool()
    let label = UILabel()
    var existingWalletName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let keychain = KeychainSwift()
//        keychain.clear()
        
        tabBarController?.delegate = self
        mainMenu.delegate = self
        mainMenu.alpha = 0
        mainMenu.tableFooterView = UIView(frame: .zero)
        initialLoad = true
        viewHasLoaded = false
        sectionZeroLoaded = false
        sectionOneLoaded = false
        firstTimeHere()
        addNavBarSpinner()
        configureRefresher()
        setFeeTarget()
        showUnlockScreen()
        addlaunchScreen()
        setExistingWallet()
        
    }
    
    func setExistingWallet() {
        
        getActiveWallet { (wallet) in
            
            if wallet != nil {
                
                self.existingWalletName = wallet!.name
                
            }
            
        }
        
    }
    
    func walletChanged(walletName: String) -> Bool {
        
        if walletName != "" {
            
            if existingWalletName != walletName {
                
                return true
                
            } else {
                
                return false
                
            }
            
        } else {
            
            return false
            
        }
        
    }
    
    func addNavBarSpinner() {
        
        spinner.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        dataRefresher = UIBarButtonItem(customView: spinner)
        navigationItem.setRightBarButton(dataRefresher, animated: true)
        spinner.startAnimating()
        spinner.alpha = 1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        func filter() {
            
            if self.nodes.count > 0 {
                
                getActiveWallet { (wallet) in
                    
                    if wallet != nil {
                        
                        if self.initialLoad || self.walletChanged(walletName: wallet!.name) {
                            
                            self.existingWalletName = wallet!.name
                            self.refresh()
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                self.removeLoadingView()
                self.removeSpinner()
                
                if ud.object(forKey: "showIntro") == nil {
                    
                    self.performSegue(withIdentifier: "showIntro", sender: self)
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        self.performSegue(withIdentifier: "scanNow", sender: self)
                        
                    }
                    
                }
                
            }
            
        }
        
        // fetch nodes
        cd.retrieveEntity(entityName: .nodes) {
            
            if !self.cd.errorBool {
                
                self.nodes = self.cd.entities
                filter()
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "there was an error fetching your node")
                
            }
            
        }
                    
    }
    
    @objc func refreshData(_ sender: Any) {
        print("refreshData")
        
        addNavBarSpinner()
        
        if ud.object(forKey: "walletCreated") == nil || ud.object(forKey: "keysImported") == nil {
            
            addlaunchScreen()
            
            let enc = Encryption()
            
            enc.getSeed { (seed, derivation, error) in
                
                if !error {
                    
                    let walletCreator = WalletCreator()
                    
                    DispatchQueue.main.async {
                        self.label.text = walletCreator.statusDescription
                    }
                    
                    walletCreator.createStandUpWallet(derivation: derivation) { (success, error) in
                        
                        if success {
                            
                            self.loadSectionZero()
                            self.setExistingWallet()
                            
                        } else {
                            
                            print("error")
                            self.removeSpinner()
                            self.removeLoadingView()
                            displayAlert(viewController: self, isError: true, message: "Wallet creation interrupted! Tap the refresh button\n" + error!)
                            
                        }
                        
                    }
                    
                }
            }
            
        } else {
            
            if nodes.count > 0 {
                
                if connector.torConnected {
                    
                    refreshDataNow()
                    
                } else {
                    
                    self.connector = Connector()
                    self.connectTor(connector: self.connector)
                    
                }
                
            }
            
        }
        
    }
    
    func refreshDataNow() {
        print("refreshDataNow")
        
        if nodes.count > 0 {
            
            addNavBarSpinner()
            loadSectionZero()
            
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
            
            return 2 + transactionArray.count
            
        } else {
            
            return 3
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func blankCell() -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.05172085258, green: 0.05855310153, blue: 0.06978280196, alpha: 1)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            if sectionZeroLoaded {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                let coldBalanceLabel = cell.viewWithTag(2) as! UILabel
                
                if coldBalance == "" {
                    
                    self.coldBalance = "0"
                    
                }
                
                coldBalanceLabel.text = self.coldBalance
                return cell
                
            } else {
                
                return blankCell()
                
            }
            
        case 1:
            
            if sectionOneLoaded {
                
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
                
                sizeLabel.text = "\(self.size) size"
                difficultyLabel.text = "\(self.difficulty) difficulty"
                sync.text = "\(self.progress) synced"
                feeRate.text = "\(self.feeRate) fee rate"
                
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
                        
                    } else if self.network == "test" {
                        
                        network.text = "testnet"
                        
                    } else {
                        
                        network.text = self.network
                        
                    }
                    
                }
                
                blockHeight.text = "\(self.currentBlock.withCommas()) blocks"
                connections.text = "\(incomingCount) ↓ \(outgoingCount) ↑ connections"
                version.text = "v\(self.version)"
                hashRate.text = self.hashrateString + " " + "EH/s hashrate"
                uptime.text = "\(self.uptime / 86400) days uptime"
                
                return cell
                
            } else {
                
                return blankCell()
                
            }
            
        default:
            
            if transactionArray.count == 0 {
                
                return blankCell()
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainMenuCell",
                                                         for: indexPath)
                
                cell.selectionStyle = .none
                tableView.separatorColor = .darkGray
                
                let amountLabel = cell.viewWithTag(2) as! UILabel
                let confirmationsLabel = cell.viewWithTag(3) as! UILabel
                let labelLabel = cell.viewWithTag(4) as! UILabel
                let dateLabel = cell.viewWithTag(5) as! UILabel
                amountLabel.alpha = 1
                confirmationsLabel.alpha = 1
                labelLabel.alpha = 1
                dateLabel.alpha = 1
                
                let dict = self.transactionArray[indexPath.section - 2]
                                
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
                
                if amount.hasPrefix("-") {
                    
                    amountLabel.text = amount
                    amountLabel.textColor = UIColor.darkGray
                    labelLabel.textColor = UIColor.darkGray
                    confirmationsLabel.textColor = UIColor.darkGray
                    dateLabel.textColor = UIColor.darkGray
                    
                } else {
                    
                    amountLabel.text = "+" + amount
                    amountLabel.textColor = UIColor.white
                    labelLabel.textColor = UIColor.white
                    confirmationsLabel.textColor = UIColor.white
                    dateLabel.textColor = UIColor.white
                    
                }
                
                return cell
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionString = ""
        switch section {
        case 0: sectionString = "Balance"
        case 1: sectionString = "Stats"
        case 2: sectionString = "History"
        default: break}
        return sectionString
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = .left
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.alpha = 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
            
        case 0:
            
            return 30
            
        case 1, 2:
            
            return 20
            
        default:
            
            return 5
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case 0:
            
            if sectionZeroLoaded {
                
                return 80
                
            } else {
                
                return 47
                
            }
            
        case 1:
            
            if sectionOneLoaded {
                
                return 192
                
            } else {
                
                return 47
                
            }
            
        default:
            
            if sectionZeroLoaded {
                
                return 80
                
            } else {
                
                return 47
                
            }
            
        }
        
    }
    
    func loadSectionZero() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.removeLoadingView()
        }
                
        let nodeLogic = NodeLogic()
        nodeLogic.walletDisabled = walletDisabled
        
        func completion() {
            print("completion")
            
            if nodeLogic.errorBool {
                
                self.removeLoadingView()
                self.removeSpinner()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: nodeLogic.errorDescription)
                
            } else {
                
                self.initialLoad = false
                
                let dict = nodeLogic.dictToReturn
                let str = HomeStruct(dictionary: dict)
                self.coldBalance = str.coldBalance
                
                DispatchQueue.main.async {
                    
                    self.sectionZeroLoaded = true
                    self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 0), with: .fade)
                    let impact = UIImpactFeedbackGenerator()
                    impact.impactOccurred()
                    self.loadSectionTwo()
                    
                }
                
            }
            
        }
        
        nodeLogic.loadSectionZero(completion: completion)
        
    }
    
    func loadSectionOne() {
        print("loadSectionOne")
        
        let nodeLogic = NodeLogic()
        nodeLogic.walletDisabled = walletDisabled
        
        func completion() {
            
            if nodeLogic.errorBool {
                
                self.removeLoadingView()
                self.removeSpinner()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: nodeLogic.errorDescription)
                
            } else {
                
                let dict = nodeLogic.dictToReturn
                let str = HomeStruct(dictionary: dict)
                sectionOneLoaded = true
                feeRate = str.feeRate
                mempoolCount = str.mempoolCount
                network = str.network
                torReachable = str.torReachable
                size = str.size
                difficulty = str.difficulty
                progress = str.progress
                isPruned = str.pruned
                incomingCount = str.incomingCount
                outgoingCount = str.outgoingCount
                version = str.version
                hashrateString = str.hashrate
                uptime = str.uptime
                currentBlock = str.blockheight
                sectionOneLoaded = true
                
                DispatchQueue.main.async {
                    
                    self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 1),
                                                 with: .fade)
                    
                    let impact = UIImpactFeedbackGenerator()
                    impact.impactOccurred()
                    self.removeSpinner()
                    
                }
                
            }
            
        }
        
        nodeLogic.loadSectionOne(completion: completion)
        
    }
    
    func loadSectionTwo() {
        
        let nodeLogic = NodeLogic()
        nodeLogic.walletDisabled = walletDisabled
        
        func completion() {
            
            if nodeLogic.errorBool {
                
                self.removeSpinner()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: nodeLogic.errorDescription)
                
            } else {
                
                transactionArray.removeAll()
                transactionArray = nodeLogic.arrayToReturn.reversed()
                
                DispatchQueue.main.async {
                    
                    self.mainMenu.reloadData()
                    let impact = UIImpactFeedbackGenerator()
                    impact.impactOccurred()
                    self.loadSectionOne()                    
                    
                }
                
            }
            
        }
        
        nodeLogic.loadSectionTwo(completion: completion)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            
        }
        
        let cell = tableView.cellForRow(at: indexPath)!
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                cell.alpha = 0
                
            }) { _ in
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    cell.alpha = 1
                    
                })
                
            }
            
        }
        
        if indexPath.section == 0 {
            
            addNavBarSpinner()
            let converter = FiatConverter()
            
            func getResult() {
                
                if !converter.errorBool {
                    
                    let btcCold = self.coldBalance
                    let rate = converter.fxRate
                    
                    guard let coldDouble = Double(self.coldBalance.replacingOccurrences(of: ",", with: "")) else {
                        
                        displayAlert(viewController: self,
                                     isError: true,
                                     message: "error converting hot balance to fiat")
                        
                        removeSpinner()
                        
                        return
                    }
                    
                    let formattedColdDouble = (coldDouble * rate).withCommas()
                    self.coldBalance = "﹩\(formattedColdDouble)"
                    
                    DispatchQueue.main.async {
                        
                        self.removeSpinner()
                        self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 0), with: .fade)
                        
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        
                        self.coldBalance = btcCold
                        self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 0), with: .fade)
                        
                    }
                    
                } else {
                    
                    removeSpinner()
                    
                    displayAlert(viewController: self,
                                 isError: true,
                                 message: "error getting fiat rate")
                    
                }
                
            }
            
            converter.getFxRate(completion: getResult)
            
        } else if indexPath.section == 1 {
            
            self.addNavBarSpinner()
            self.loadSectionZero()
            
        } else if indexPath.section > 1 {
            
            if transactionArray.count > 0 {
                
                    let selectedTx = self.transactionArray[indexPath.section - 2]
                    let txID = selectedTx["txID"] as! String
                    self.tx = txID
                    UIPasteboard.general.string = txID
                    
                    DispatchQueue.main.async {
                        
                        self.performSegue(withIdentifier: "getTransaction", sender: self)
                        
                    }
                
            }
            
        }
        
    }
    
    //MARK: User Interface
    
    func addlaunchScreen() {
        
        if let _ = self.tabBarController {
            
            DispatchQueue.main.async {
                
                self.addNavBarSpinner()
                self.backView.alpha = 0
                self.backView.frame = self.tabBarController!.view.frame
                self.backView.backgroundColor = .black
                let imageView = UIImageView()
                imageView.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y - 75, width: 150, height: 150)
                imageView.image = UIImage(named: "1024.png")
                self.backView.addSubview(imageView)
                self.view.addSubview(self.backView)
                
                // add a label to update whats happening...
                self.label.frame = CGRect(x: 16, y: self.navigationController!.navigationBar.frame.maxY + 5, width: self.view.frame.width - 32, height: 40)
                self.label.font = UIFont.systemFont(ofSize: 38, weight: .black)
                self.label.adjustsFontSizeToFitWidth = true
                self.label.textAlignment = .left
                self.label.textColor = .lightText
                self.label.text = "Connecting Tor..."
                self.label.numberOfLines = 0
                self.backView.addSubview(self.label)
                
                UIView.animate(withDuration: 0.8) {
                    self.backView.alpha = 1
                }
                
            }
            
        }
        
    }
    
    func removeSpinner() {
        
        DispatchQueue.main.async {
            
            self.spinner.stopAnimating()
            self.spinner.alpha = 0
            
            self.refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                 target: self,
                                                 action: #selector(self.refreshData(_:)))
            
            self.refreshButton.tintColor = UIColor.white.withAlphaComponent(1)
            
            self.navigationItem.setRightBarButton(self.refreshButton,
                                                  animated: true)
            
            self.viewHasLoaded = true
                        
        }
        
    }
    
    func removeLoadingView() {
        
        DispatchQueue.main.async {
            
            self.refresher.endRefreshing()
            UIView.animate(withDuration: 0.3, animations: {
                self.backView.alpha = 0
                self.mainMenu.alpha = 1
            }) { (_) in
                self.backView.removeFromSuperview()
            }
            
        }
        
    }
    
    func configureRefresher() {
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        
        refresher.attributedTitle = NSAttributedString(string: "refresh data",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        refresher.addTarget(self, action: #selector(self.refresh),
                            for: UIControl.Event.valueChanged)
        
        mainMenu.addSubview(refresher)
        
    }
    
    func reloadTable() {
        print("reloadTable")
        
        //used when user switches between nodes so old node data is not displayed
        sectionZeroLoaded = false
        sectionOneLoaded = false
        transactionArray.removeAll()
        
        DispatchQueue.main.async {
            
            self.mainMenu.reloadData()
            
        }
        
    }
    
    //MARK: User Actions
    
    @objc func closeConnectingView() {
        
        DispatchQueue.main.async {
            self.connectingView.removeConnectingView()
        }
        
    }
    
    @objc func refresh() {
        print("refresh")
        
        if !initialLoad {
            
            reloadWalletData()
            
        } else {
            
            if nodes.count > 0 {
                
                self.connector = Connector()
                self.connectTor(connector: self.connector)
                
            }
            
        }        
        
    }
    
    func updateLabel(text: String) {
        
        DispatchQueue.main.async {
            let animation = CATransition()
            self.label.layer.add(animation, forKey: nil)
            self.label.text = text
        }
        
    }
    
    func connectTor(connector:Connector) {
        print("connecttor")
        
        self.addlaunchScreen()
        
        func completion() {
            print("connecttor completion")
            
            if !connector.torConnected {
                
                removeLoadingView()
                removeSpinner()
                
                displayAlert(viewController: self,
                             isError: true,
                             message: "unable to connect to tor")
                
            } else {
                
                self.updateLabel(text: "Tor connected ✓")
                
                viewHasLoaded = true
                
                if self.nodes.count > 0 {
                    
                    let ud = UserDefaults.standard
                    
                    if ud.object(forKey: "walletCreated") == nil || ud.object(forKey: "keysImported") == nil {
                        
                        let enc = Encryption()
                        enc.getSeed { (seed, derivation, error) in
                            
                            if !error {
                                
                                // first time do whole shebang
                                let walletCreator = WalletCreator()
                                
                                DispatchQueue.main.async {
                                    self.addNavBarSpinner()
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    self.label.text = walletCreator.statusDescription
                                }
                                    
                                walletCreator.createStandUpWallet(derivation: derivation) { (success, error) in
                                    
                                    if success {
                                        
                                        displayAlert(viewController: self, isError: false, message: "Succesfully created your StandUp wallet ✓")
                                        self.setExistingWallet()
                                        self.loadSectionZero()
                                        
                                    } else {
                                        
                                        print("error")
                                        self.removeSpinner()
                                        self.removeLoadingView()
                                        ud.removeObject(forKey: "walletCreated")
                                        displayAlert(viewController: self, isError: true, message: "Error creating your wallet! Tap the refresh button\n" + error!)
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    } else {
                        
                        loadSectionZero()
                        
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        self.removeLoadingView()
                        self.performSegue(withIdentifier: "scanNow", sender: self)
                    }
                    
                }
                
            }
            
        }
        
        connector.connectTor(completion: completion)
        
    }
    
    func reloadWalletData() {
        
        addNavBarSpinner()
        let nodeLogic = NodeLogic()
        nodeLogic.walletDisabled = false
        sectionZeroLoaded = false
        transactionArray.removeAll()
        
        DispatchQueue.main.async {
            
            self.mainMenu.reloadData()
            
        }
        
        func completion() {
            print("completion")
            
            if nodeLogic.errorBool {
                
                if nodeLogic.errorDescription.contains("could not connect to the server.") {
                    
                    TorClient.sharedInstance.resign()
                    self.connector = Connector()
                    self.connectTor(connector: self.connector)
                    
                } else {
                    
                    self.removeLoadingView()
                    self.removeSpinner()
                    
                    displayAlert(viewController: self,
                                 isError: true,
                                 message: nodeLogic.errorDescription)
                    
                }
                
            } else {
                
                let dict = nodeLogic.dictToReturn
                let str = HomeStruct(dictionary: dict)
                self.coldBalance = (str.coldBalance)
                
                DispatchQueue.main.async {
                    
                    self.sectionZeroLoaded = true
                    self.mainMenu.reloadSections(IndexSet.init(arrayLiteral: 0), with: .fade)
                    let impact = UIImpactFeedbackGenerator()
                    impact.impactOccurred()
                    self.loadSectionTwo()
                    
                }
                
            }
            
        }
        
        nodeLogic.loadSectionZero(completion: completion)
        refresher.endRefreshing()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "getTransaction":
            
            if let vc = segue.destination as? TransactionViewController {
                
                vc.txid = tx
                
            }
            
        default:
            
            break
            
        }
        
    }
    
    //MARK: Helpers
    
    func firstTimeHere() {
        
        let firstTime = FirstTime()
        firstTime.firstTimeHere()
        
    }
    
}

extension Double {
    
    func withCommas() -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
        
    }
    
}

extension MainMenuViewController  {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          animationControllerForTransitionFrom fromVC: UIViewController,
                          to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return MyTransition(viewControllers: tabBarController.viewControllers)
        
    }
    
}
