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
            return "Welcome to StandUp-iOS!"
        case .pageOne:
            return "What does StandUp-iOS do?"
        case .pageTwo:
            return "How does StandUp-iOS work?"
        case .pageThree:
            return "Is StandUp-iOS secure?"
        }
    }
    
    var body: String {
        switch self {
        case .pageZero:
            return "StandUp is made possible by Blockchain Commons, please see our website for more info www.blockchaincommons.com and the GitHub for all the details at https://github.com/BlockchainCommons/Bitcoin-Standup\n\nStandUp-iOS is tailor made to work with Bitcoin Core and works especially well with the MacOS StandUp.app and the StandUp.sh Linux scripts."
        case .pageOne:
            return "1. Connect to your node by scanning the QuickConnect QR code over Tor.\n\nStandUp-iOS will then automatically:\n\n2. Create a seed locally on your device and encrypt it.\n\n3. Create a dedicated \"StandUp\" wallet on your node.\n\n4. Import your xpub to create a watch-only wallet on your node.\n\n5. Stores your seed locally so it can sign transactions before broadcasting them, that way your node does not hold the private keys, to back up your wallet simply go to \"Settings\" and tap \"Export Seed\".\n\n6. Full coin control, batching and simple sending of Bitcoin transactions, it will display statistics about the Bitcoin network straight from your node, it allows seed exporting via BIP39 recovery phrase or public/private descriptors."
        case .pageTwo:
            return "StandUp-iOS keeps things simple by storing your seed locally and using Bitcoin Core for all the complex wallet functionality.\n\nAll wallet functionality is powered by your node over Tor.\n\nStandUp-iOS runs its very own Tor node on your device which allows it to connect to your nodes hidden service to utilize Bitcoin Core wallet functions.\n\nThe unique architecture of StandUp-iOS means that you can use BIP39 recovery phrases with your Bitcoin Core node whilst keeping your node cold and storing the private keys in a more secure way on your device."
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
