//
//  ViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 30/12/19.
//  Copyright © 2019 Blockchain Commons, LLC. All rights reserved.
//

import UIKit
import LibWally
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createSeed()
    }
    
    func createSeed() {
        
        let bytesCount = 24
        var randomBytes = [UInt8](repeating: 0, count: bytesCount)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytesCount, &randomBytes)
        
        if status == errSecSuccess {
            
            let data = Data(randomBytes)
            let hex = data.hexString
            let entropy = BIP39Entropy(hex)!
            let mnemonic = BIP39Mnemonic.init(entropy)!
            let masterKey = HDKey((mnemonic.seedHex("")), .testnet)!
            let path = BIP32Path("m/84'/1'/0'")!
            let account = try! masterKey.derive(path)
            let tpub = account.xpub
            let tprv = account.xpriv!
            
            let key1 = try! account.derive(BIP32Path("0/0")!)
            let address1 = key1.address(.payToWitnessPubKeyHash)
            var words = (mnemonic.words.description).replacingOccurrences(of: "\"", with: "")
            words = words.replacingOccurrences(of: ",", with: "")
            words = words.replacingOccurrences(of: "[", with: "")
            words = words.replacingOccurrences(of: "]", with: "")
            print("words = \(words)")
            print("tpub = \(tpub)")
            print("tprv = \(tprv)")
            print("first address = \(address1)")
            print("first private key = \(key1)")
            
        }
    }

}

