//
//  RawDisplayer.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import UIKit

class RawDisplayer {
    
    var y = CGFloat()
    let textView = UITextView()
    var qrView = UIImageView()
    let qrGenerator = QRGenerator()
    let backgroundView = UIView()
    let copiedLabel = UILabel()
    //var navigationBar = UINavigationBar()
    var tabbar = UITabBar()
    var vc = UIViewController()
    var rawString = ""
    let impact = UIImpactFeedbackGenerator()
    
    func addRawDisplay() {
        
        //tabbar = vc.tabBarController!.tabBar
        //navigationBar = vc.navigationController!.navigationBar
        configureBackground()
        configureQrView()
        configureTextView()
        configureCopiedLabel()
        
        qrView.image = generateQrCode(key: rawString)
        textView.text = rawString
        UIPasteboard.general.string = rawString
        
        backgroundView.addSubview(qrView)
        backgroundView.addSubview(textView)
        vc.view.addSubview(backgroundView)
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.backgroundView.alpha = 1
            
        }) { _ in
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.qrView.frame = CGRect(x: 10,
                                           y: self.y,
                                           width: self.vc.view.frame.width - 20,
                                           height:self.vc.view.frame.width - 20)
                
            }, completion: { _ in
                
                self.impact.impactOccurred()
                
                UIView.animate(withDuration: 0.4, animations: {
                    
                    let qrHeight = self.vc.view.frame.width - 20
                    let totalViewHeight = self.vc.view.frame.height

                    
                    self.textView.frame = CGRect(x: 10,
                                                 y: self.qrView.frame.maxY,
                                                 width: self.vc.view.frame.width - 20,
                                                 height: totalViewHeight - qrHeight)
                    
                }, completion: { _ in
                    
                    self.impact.impactOccurred()
                    
                    DispatchQueue.main.async {
                        
                        self.addCopiedLabel()
                        
                    }
                    
                })
                
            })
            
        }
        
    }
    
    func addCopiedLabel() {
        
        vc.view.addSubview(copiedLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.copiedLabel.frame = CGRect(x: 0,
                                                y: self.vc.view.frame.maxY - 50,
                                                width: self.vc.view.frame.width,
                                                height: 50)
                
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.copiedLabel.frame = CGRect(x: 0,
                                                    y: self.vc.view.frame.maxY + 100,
                                                    width: self.vc.view.frame.width,
                                                    height: 50)
                    
                }, completion: { _ in
                    
                    self.copiedLabel.removeFromSuperview()
                    
                })
                
            })
            
        }
        
    }
    
    func configureCopiedLabel() {
        
        copiedLabel.text = "copied to clipboard ✓"
        
        copiedLabel.frame = CGRect(x: 0,
                                   y: vc.view.frame.maxY + 100,
                                   width: vc.view.frame.width,
                                   height: 50)
        
        copiedLabel.textColor = UIColor.darkGray
        copiedLabel.font = UIFont.init(name: "HiraginoSans-W3", size: 17)
        copiedLabel.backgroundColor = UIColor.black
        copiedLabel.textAlignment = .center
        
    }
    
    func configureQrView() {
        
        qrView.isUserInteractionEnabled = true
        
        qrView.frame = CGRect(x: 10,
                              y: vc.view.frame.maxY + 200,
                              width: vc.view.frame.width - 20,
                              height: vc.view.frame.width - 20)
        
    }
    
    func configureTextView() {
        
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .natural
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.adjustsFontForContentSizeCategory = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        
        let qrHeight = vc.view.frame.width - 20
        let totalViewHeight = vc.view.frame.height
        
        textView.frame = CGRect(x: 10,
                                y: vc.view.frame.maxY + 170,
                                width: vc.view.frame.width - 20,
                                height: totalViewHeight - qrHeight)
        
    }
    
    func configureBackground() {
        
        backgroundView.alpha = 0
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.frame = vc.view.frame
        
    }
    
    func generateQrCode(key: String) -> UIImage {
        
        self.qrGenerator.textInput = key
        let imageToReturn = self.qrGenerator.getQRCode()
        return imageToReturn
        
    }
    
}
