//
//  IntroViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

enum Pages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
    case pageThree
    
    var title: String {
        switch self {
        case .pageZero:
            return "Welcome to StandUp-Remote!"
        case .pageOne:
            return "How do I use StandUp-Remote?"
        case .pageTwo:
            return "How does StandUp-Remote work?"
        case .pageThree:
            return "Is StandUp-Remote secure?"
        }
    }
    
    var body: String {
        
        switch self {
            
        case .pageZero:
            
            return "StandUp is made possible by Blockchain Commons, A \"not-for-profit\" benefit corporation. Founded to support blockchain infrastructure & the broader security industry through cryptographic & privacy protocol implementations, research, and standards.\n\nPlease consider supporting us via BTCPayServer here \n\nPlease see our website for more info at blockchaincommons.com\n\nAnd the GitHub which includes the source code and detailed information.\n\nStandUp-iOS is tailor made to work with Bitcoin Core and works especially well with the MacOS StandUp.app and the StandUp.sh Linux scripts. You may also pair this app over Tor by scanning the QR code your BTCPayServer, RaspiBlitz, Nodl, or MyNode produce."
            
        case .pageOne:
            
            return "First, connect to your node by scanning the QuickConnect QR code that your node software produces, supporting node software includes StandUp.app (MacOS), BTCPayServer, MyNode, RaspiBlitz and Nodl. Of course you may do this yourself by following the instructions on our github.\n\nThe app will then do all the hard work for you. Using StandUp is straightforward, to create a Bitcoin invoice just tap the \"In\" button, to spend Bitcoin just tap the \"Out\" button. For advanced users you can tap the list button for full coin control.\n\nGo to settings to export your seed and for wallet recovery information.\n\nAuthenticate your connection to your node with the public key you can export in settings."
            
        case .pageTwo:
            
            return "StandUp-iOS keeps things simple by storing your seed locally and using Bitcoin Core for all the complex wallet functionality.\n\nStandUp-iOS runs a Tor node on your device which it uses to connect to your nodes hidden service. This way you can privately and securely control your nodes wallet functionality remotely from anywhere in the world, allowing you to keep your node completely behind a firewall.\n\nThe unique architecture of StandUp-iOS means that you can use BIP39 recovery phrases with your Bitcoin Core node whilst keeping your node cold and storing the private keys in a more secure way on your device.\n\nStandUp-iOS automatically creates a seed locally on your device and encrypts it.\n\nIt then creates a dedicated \"StandUp\" wallet on your node, importing your xpub to create a watch-only wallet on your node.\n\nIt stores your seed locally so it can derive the necessary private keys on demand to sign raw transactions before broadcasting them. To back up your wallet simply go to \"Settings\" and tap \"Export Seed\", to recover your wallet use the Wallet Recovery Commands with any Bitcoin Core node console."
            
        case .pageThree:
            
            return "StandUp-iOS will create a Tor V3 authentication private key and public key, the private key is encrypted and stored locally on your device, you will never see it. You will need to export the public key to your nodes hidden service \"authorized_clients\" directory which is simple to do with either MacOS StandUp.app or the StandUp.sh Linux scripts.\n\nThat's it! Tap the back button or the home button to get started."
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        case .pageThree:
            return 3
        }
    }
}

class IntroViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var pageController: UIPageViewController?
    private var pages: [Pages] = Pages.allCases
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: "showIntro")
        self.setupPageController()
    }
    
    private func setupPageController() {
        
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        
        let initialVC = PageViewController(with: pages[0])
        
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        self.pageController?.didMove(toParent: self)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PageViewController else {
            return nil
        }
        
        var index = currentVC.page.index
        
        if index == 0 {
            return nil
        }
        
        index -= 1
        
        let vc: PageViewController = PageViewController(with: pages[index])
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PageViewController else {
            return nil
        }
        
        var index = currentVC.page.index
        
        if index >= self.pages.count - 1 {
            return nil
        }
        
        index += 1
        
        let vc: PageViewController = PageViewController(with: pages[index])
        
        return vc
    }
    
}
