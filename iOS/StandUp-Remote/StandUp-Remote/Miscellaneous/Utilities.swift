//
//  Utilities.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import UIKit

public func getActiveWallet(completion: @escaping ((WalletStruct?)) -> Void) {
    
    let cd = CoreDataService()
    cd.retrieveEntity(entityName: .wallets) {
        
        let wallets = cd.entities
        
        for (i, wallet) in wallets.enumerated() {
            
            let walletStr = WalletStruct.init(dictionary: wallet)
            
            if walletStr.isActive {
                
                completion((walletStr))
                
            } else {
                
                if i + 1  == wallets.count {
                    
                    print("no active wallets")
                    completion(nil)
                    
                }
                
            }
            
        }
        
    }
    
}

func dateToUnix(inputdate: Date) -> Int {
    
    let unixTime = inputdate.timeIntervalSince1970
    return Int(unixTime)
    
}

public func keyBirthday() -> Int32 {
    
    let date = Date()
    return Int32(date.timeIntervalSince1970)
    
}

public func saveKeyBirthday() {
    
    let birthdate = keyBirthday()
    let ud = UserDefaults.standard
    ud.set(birthdate, forKey: "birthdate")
    
}

public func randomString(length: Int) -> String {
    
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
    
}

public func rounded(number: Double) -> Double {
    
    return Double(round(100000000*number)/100000000)
    
}

public func displayAlert(viewController: UIViewController, isError: Bool, message: String) {
    
    DispatchQueue.main.async {
        
        let errorView = ErrorView()
        
        errorView.isUserInteractionEnabled = true
        
        errorView.showErrorView(vc: viewController,
                                text: message,
                                isError: isError)
        
    }
    
}

public func isWalletRPC(command: BTC_CLI_COMMAND) -> Bool {
    
    var boolToReturn = Bool()
    
    switch command {
        
    case .listtransactions,
         .getbalance,
         .getunconfirmedbalance,
         .getnewaddress,
         .getwalletinfo,
         .getrawchangeaddress,
         .importmulti,
         .importprivkey,
         .rescanblockchain,
         .fundrawtransaction,
         .listunspent,
         .walletprocesspsbt,
         .gettransaction,
         .getaddressinfo,
         .bumpfee,
         .signrawtransactionwithwallet,
         .listaddressgroupings,
         .listlabels,
         .getaddressesbylabel,
         .listlockunspent,
         .lockunspent,
         .abortrescan,
         .walletcreatefundedpsbt,
         .encryptwallet,
         .walletpassphrase,
         .walletpassphrasechange,
         .walletlock:
        
        boolToReturn = true
        
    default:
        
        boolToReturn = false
        
    }
    
    return boolToReturn
    
}

public func shakeAlert(viewToShake: UIView) {
    print("shakeAlert")
    
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.07
    animation.repeatCount = 4
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
    
    DispatchQueue.main.async {
        
        viewToShake.layer.add(animation, forKey: "position")
        
    }
}

public func getDocumentsDirectory() -> URL {
    print("getDocumentsDirectory")
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

public extension Double {
    
    var avoidNotation: String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
        
    }
}
