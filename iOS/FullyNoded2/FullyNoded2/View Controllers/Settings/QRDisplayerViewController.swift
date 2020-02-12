//
//  QRDisplayerViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 27/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class QRDisplayerViewController: UIViewController {
    
    var address = ""
    let qrGenerator = QRGenerator()
    let imageView = UIImageView()
    let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackground()
        addImageView()
        showQR()
        
    }
    
    func addBackground() {
        
        backgroundView.frame = self.view.frame
        self.view.addSubview(backgroundView)
        
    }
    
    func addImageView() {
        
        imageView.frame = CGRect(x: 16, y: 100, width: self.view.frame.width - 32, height: self.view.frame.width - 32)
        backgroundView.contentView.addSubview(imageView)
        
    }
    
    func showQR() {
        
        qrGenerator.textInput = address
        let qr = qrGenerator.getQRCode()
        
        DispatchQueue.main.async {
            
            self.imageView.image = qr
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
