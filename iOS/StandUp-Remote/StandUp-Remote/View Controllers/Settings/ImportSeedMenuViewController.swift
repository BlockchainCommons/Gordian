//
//  ImportSeedMenuViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 07/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class ImportSeedMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2//4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
            
        case 1:

            let cell = tableView.dequeueReusableCell(withIdentifier: "qrCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
//
//        case 2:
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
//            cell.selectionStyle = .none
//            return cell
//
//        case 3:
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "voiceCell", for: indexPath)
//            cell.selectionStyle = .none
//            return cell
            
        default:
            
            return UITableViewCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            
            scanWords()
            
        case 1:
            
            scanQR()
            
        default:
            
            break
            
        }
        
    }
    
    func scanQR() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "scanQR", sender: self)
            
        }
        
    }
    
    func scanWords() {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "scanWords", sender: self)
            
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
