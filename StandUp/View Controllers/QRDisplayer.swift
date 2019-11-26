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
    @IBOutlet var spinner: NSProgressIndicator!
    @IBOutlet var spinnerDescription: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.alphaValue = 0
        spinnerDescription.alphaValue = 0
        getValues()
        setQR()
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.dismiss(self)
            
        }
        
    }
    
    func showSpinner() {
        
        DispatchQueue.main.async {
            self.spinner.startAnimation(self)
            self.spinner.alphaValue = 1
            self.spinnerDescription.alphaValue = 1
        }
        
    }
    
    func hideSpinner() {
        
        DispatchQueue.main.async {
            self.spinner.stopAnimation(self)
            self.spinner.alphaValue = 0
            self.spinnerDescription.alphaValue = 0
        }
        
    }
    
    func setQR() {
        
        let url = "btcstandup://\(rpcuser):\(rpcpassword)@\(torHostname):1309/?label=\(nodeLabel)"
        imageView.frame = CGRect(x: 30, y: 30, width: 100, height: 100)
        imageView.image = getQRCode(textInput: url)
        
    }
    
    func getValues() {
        
        let ud = UserDefaults.standard
        
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
    
    @IBAction func refreshHS(_ sender: Any) {
        
        actionAlert(message: "Refresh Hidden Service?", info: "This refreshes your hidden service so that any clients that were connected to your node will no longer be able to connect, it's a good idea to do this if for some reason you think someone may have access to your node if for example your phone was lost or stolen.") { (response) in
            
            if response {
                
                self.showSpinner()
                
                self.refreshHS {
                    
                    self.getHostname()
                    
                }
                
            }
            
        }
        
    }
    
    func refreshHS(completion: @escaping () -> Void) {
        
        let runBuildTask = RunBuildTask()
        runBuildTask.args = []
        runBuildTask.showLog = false
        runBuildTask.env = ["":""]
        runBuildTask.exitStrings = ["Done"]
        runBuildTask.runScript(script: .refreshHS) {
            
            if !runBuildTask.errorBool {
                
                self.setLog(content: runBuildTask.stringToReturn)
                completion()
                
            } else {
                
                setSimpleAlert(message: "Error", info: runBuildTask.errorDescription, buttonLabel: "OK")
                completion()
                
            }
            
        }
        
    }
    
    func getHostname() {
                
        let runBuildTask = RunBuildTask()
        runBuildTask.stringToReturn = ""
        runBuildTask.terminate = false
        runBuildTask.errorBool = false
        runBuildTask.errorDescription = ""
        runBuildTask.isRunning = false
        runBuildTask.args = []
        runBuildTask.env = ["":""]
        runBuildTask.exitStrings = ["Done"]
        runBuildTask.showLog = false
        runBuildTask.runScript(script: .getTorHostname) {
            
            if !runBuildTask.errorBool {
                
                let str = runBuildTask.stringToReturn
                print("new hostname = \(str)")
                self.torHostname = str
                self.updateImage()
                
            } else {
                
                self.hideSpinner()
                
                setSimpleAlert(message: "Error", info: "There was an error getting your new hostname: \(runBuildTask.errorDescription)", buttonLabel: "OK")
                
            }
            
        }

    }
    
    func updateImage() {
        
        DispatchQueue.main.async {
            
            self.hideSpinner()
            let url = "btcstandup://\(self.rpcuser):\(self.rpcpassword)@\(self.torHostname):1309/?label=\(self.nodeLabel)"
            let newImage = self.getQRCode(textInput: url)
            let transition = CATransition() //create transition
            transition.duration = 0.75 //set duration time in seconds
            transition.type = .fade //animation type
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            self.imageView.layer?.add(transition, forKey: nil) //add animation to your imageView's layer
            self.imageView.image = newImage //set the image
            
        }
        
    }
    
    func setLog(content: String) {
        
        let lg = Log()
        lg.writeToLog(content: content)
        
    }
    
    
}
