//
//  ImportSeedViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 07/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit
import Vision
import VisionKit

class ImportSeedViewController: UIViewController, VNDocumentCameraViewControllerDelegate, UINavigationControllerDelegate {
    
    var words = ""
    var derivation = ""
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var nextButtonOutlet: UIButton!
    
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        textView.alpha = 0
        imageView.alpha = 0
        nextButtonOutlet.alpha = 0
        nextButtonOutlet.clipsToBounds = true
        nextButtonOutlet.layer.cornerRadius = 12
        setupVision()
        scan()
        
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        getActiveWalletNow { (wallet, error) in
            
            if wallet != nil && !error {
                
                self.derivation = wallet!.derivation
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "goVerify", sender: self)
                    
                }
                
            }
            
        }
        
    }
    
    private func scan() {
        
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
        
    }
    
    private func setupVision() {
        textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var detectedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                print("text \(topCandidate.string) has confidence \(topCandidate.confidence)")
    
                detectedText += topCandidate.string
                detectedText += "\n"
            }
            
            print("detectedText = \(detectedText)")
            self.words = detectedText.replacingOccurrences(of: "\n", with: " ")
            self.hideImageShowText(words: detectedText)
            
        }

        textRecognitionRequest.recognitionLevel = .accurate
    }
    
    func hideImageShowText(words: String) {
        
        DispatchQueue.main.async {
            
            self.imageView.image = nil
            self.imageView.removeFromSuperview()
            self.showText(words: words)
            
//            UIView.animate(withDuration: 0.2, animations: {
//
//                self.imageView.alpha = 0
//
//            }) { _ in
//
//                self.imageView.image = nil
//                self.imageView.removeFromSuperview()
//                self.showText(words: words)
//
//            }
            
        }
        
    }
    
    func showText(words: String) {
        
        DispatchQueue.main.async {
            
            self.textView.text = words
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.textView.alpha = 1
                
            }) { _ in
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.nextButtonOutlet.alpha = 1
                    
                }) { _ in
                    
                    displayAlert(viewController: self, isError: false, message: "Confirm the words are correct, edit them if necessary, then tap \"go verify\"")
                    self.navigationItem.title = "Confirm"
                    
                }
                
            }
            
        }
        
    }
    
    private func processImage(_ image: UIImage) {
        imageView.image = image
        recognizeTextInImage(image)
    }
    
    private func recognizeTextInImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        textRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        let originalImage = scan.imageOfPage(at: 0)
        let newImage = compressedImage(originalImage)
        controller.dismiss(animated: true)
        
        processImage(newImage)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }

    func compressedImage(_ originalImage: UIImage) -> UIImage {
        guard let imageData = originalImage.jpegData(compressionQuality: 1),
            let reloadedImage = UIImage(data: imageData) else {
                return originalImage
        }
        return reloadedImage
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "goVerify":
            
            if let vc = segue.destination as? VerifyKeysViewController {
                
                vc.derivation = derivation
                vc.comingFromSettings = false
                vc.words = words
                
            }
            
        default:
            
            break
            
        }
        
    }
    

}
