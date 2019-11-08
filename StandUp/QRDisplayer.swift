//
//  QRDisplayer.swift
//  StandUp
//
//  Created by Peter on 07/10/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Cocoa

class QRDisplayer: NSViewController {
    
    var rpcpassword = ""
    var rpcuser = ""
    var rpcport = ""
    var torHostname = ""
    
    @IBOutlet var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "btcstandup://\(rpcuser):\(rpcpassword)@\(torHostname):\(rpcport)/?label=Stand%20Up%20Node"
        imageView.image = getQRCode(textInput: url)
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.dismiss(self)
            
        }
        
    }
    
    func getQRCode(textInput: String) -> NSImage {
        
        let data = textInput.data(using: .ascii)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let output = filter?.outputImage?.transformed(by: transform)
        let grey = #colorLiteral(red: 0.07804081589, green: 0.09001789242, blue: 0.1025182381, alpha: 1)
        
        let colorParameters = [
            "inputColor0": CIColor(color: NSColor.green), // Foreground
            "inputColor1": CIColor(color: grey) // Background
        ]
        
        let colored = (output!.applyingFilter("CIFalseColor", parameters: colorParameters as [String : Any]))
        let rep = NSCIImageRep(ciImage: colored)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        return nsImage
        
    }
    
}
