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
    var nodeLabel = ""
    
    @IBOutlet var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getValues()
        setQR()
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.dismiss(self)
            
        }
        
    }
    
    func setQR() {
        
        let url = "btcstandup://\(rpcuser):\(rpcpassword)@\(torHostname):1309/?label=\(nodeLabel)"
        imageView.frame = CGRect(x: 30, y: 30, width: 100, height: 100)
        imageView.image = getQRCode(textInput: url)
        
    }
    
    func getValues() {
        
        let ud = UserDefaults.standard
        
        if ud.object(forKey: "mainnet") != nil {
            if ud.object(forKey: "mainnet") as! Int == 1 {
                rpcport = "8332"
            }
        }
        
        if ud.object(forKey: "testnet") != nil {
            if ud.object(forKey: "testnet") as! Int == 1 {
                rpcport = "18332"
            }
        }
        
        if ud.object(forKey: "regtest") != nil {
            if ud.object(forKey: "regtest") as! Int == 1 {
                rpcport = "18443"
            }
        }
        
        nodeLabel = ud.object(forKey: "nodeLabel") as? String ?? "StandUp%20Node"
        
        if nodeLabel.contains(" ") {
            
            nodeLabel = nodeLabel.replacingOccurrences(of: " ", with: "%20")
            
        }
        
    }
    
    func getQRCode(textInput: String) -> NSImage {
        
        let data = textInput.data(using: .ascii)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let output = filter?.outputImage?.transformed(by: transform)
        
        let colorParameters = [
            "inputColor0": CIColor(color: NSColor.black), // Foreground
            "inputColor1": CIColor(color: NSColor.white) // Background
        ]
        
        let colored = (output!.applyingFilter("CIFalseColor", parameters: colorParameters as [String : Any]))
        let rep = NSCIImageRep(ciImage: colored)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        return nsImage
        
    }
    
}
