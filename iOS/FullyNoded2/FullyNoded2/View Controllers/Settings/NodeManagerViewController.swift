//
//  NodeManagerViewController.swift
//  StandUp-Remote
//
//  Created by Peter on 31/01/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import UIKit

class NodeManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet var table: UITableView!
    var nodes = [[String:Any]]()
    var addButton = UIBarButtonItem()
    var editButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        navigationController?.delegate = self
        addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addNode))
        editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editNodes))
        self.navigationItem.setRightBarButtonItems([addButton, editButton], animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        load()
        
    }
    
    @objc func addNode() {
        
        let impact = UIImpactFeedbackGenerator()
        
        DispatchQueue.main.async {
            
            impact.impactOccurred()
            self.performSegue(withIdentifier: "addNode", sender: self)
            
        }
        
    }
    
    @objc func editNodes() {
        
        table.setEditing(!table.isEditing, animated: true)
        
        if table.isEditing {
            
            editButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(editNodes))
            
        } else {
            
            editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editNodes))
            
        }
        
        self.navigationItem.setRightBarButtonItems([addButton, editButton], animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let id = nodes[indexPath.section]["id"] as! UUID
            
            let cd = CoreDataService()
            cd.deleteEntity(id: id, entityName: .nodes) {
                
                if !cd.errorBool {
                                        
                    DispatchQueue.main.async {
                        
                        self.nodes.remove(at: indexPath.section)
                        tableView.deleteSections(IndexSet.init(arrayLiteral: indexPath.section), with: .fade)
                        
                    }
                    
                } else {
                    
                    displayAlert(viewController: self, isError: true, message: "error deleting node")
                    
                }
                
            }
                        
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let node = nodes[section]
        let idToActivate = NodeStruct.init(dictionary: node).id
         
        //turning on
        makeActive(nodeToActivate: idToActivate)
        
        DispatchQueue.main.async {

            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()

        }
        
    }
    
    func load() {
        
        self.nodes.removeAll()
        
        let cd = CoreDataService()
        cd.retrieveEntity(entityName: .nodes) { (nodes, errorDescription) in
            
            if errorDescription == nil {
                
                let enc = Encryption()
                
                for (i, node) in nodes!.enumerated() {
                    
                    self.nodes.append(node)
                    
                    for (key, value) in node {
                        
                        if key != "isActive" && key != "id" && key != "walletCreated" && key != "keysImported" {
                            
                            let encryptedData = value as! Data
                            enc.decryptData(dataToDecrypt: encryptedData) { (decryptedData) in
                                
                                if decryptedData != nil {
                                    
                                    let decryptedString = String(bytes: decryptedData!, encoding: .utf8)
                                    self.nodes[i][key] = decryptedString!
                                    
                                }
                                
                            }
                            
                        }
                                                
                    }
                    
                    if i + 1 == nodes!.count {
                        
                        DispatchQueue.main.async {
                            
                            self.table.reloadData()
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: errorDescription!)
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return nodes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nodeCell", for: indexPath)
        
        cell.selectionStyle = .none
        let nodeLabel = cell.viewWithTag(1) as! UILabel
        let onionAddress = cell.viewWithTag(2) as! UILabel
        let isActive = cell.viewWithTag(3) as! UISwitch
        let node = NodeStruct.init(dictionary: nodes[indexPath.section])
        nodeLabel.text = node.label
        let onion = node.onionAddress
        isActive.isOn = node.isActive
        isActive.addTarget(self, action: #selector(alternate(_:)), for: .touchUpInside)
        isActive.restorationIdentifier = "\(indexPath.section)"
        
        let first10 = String(onion.prefix(10))
        let last15 = String(onion.suffix(15))
        
        onionAddress.text = "\(first10)*****\(last15)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 58
        
    }
    
    @objc func alternate(_ sender: UISwitch) {
        print("alternate")
        
        let restId = sender.restorationIdentifier!
        let section = Int(restId)!
        let node = nodes[section]
        let idToActivate = NodeStruct.init(dictionary: node).id
        
       if sender.isOn {
            
            //turning on
            makeActive(nodeToActivate: idToActivate)
            
        } else {
            
            self.table.reloadSections([section], with: .fade)
            
            showAlert(vc: self, title: "Alert", message: "You must always have one active node, if you would like to use a different node simply switch it on and the other nodes will be switched off automatically.")
            
        }
        
        DispatchQueue.main.async {
            
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            
        }
        
    }
    
    func makeActive(nodeToActivate: UUID) {
        
        let cd = CoreDataService()
        cd.retrieveEntity(entityName: .nodes) { (nodes, errorDescription) in
            
            if errorDescription == nil {
                
                if nodes!.count > 0 {
                    
                    for node in nodes! {
                        
                        let str = NodeStruct.init(dictionary: node)
                        
                        if str.id == nodeToActivate {
                            
                            cd.updateEntity(id: nodeToActivate, keyToUpdate: "isActive", newValue: true, entityName: .nodes) {
                                
                                if !cd.errorBool {
                                    
                                   self.deactivateOtherNodes(nodeToActivate: nodeToActivate)
                                    
                                } else {
                                    
                                    displayAlert(viewController: self, isError: true, message: "error deactivating wallet")
                                    
                                }
                                
                            }
                            
                        }
                        
                    }

                }
                
            } else {
                
                displayAlert(viewController: self, isError: true, message: "error deactivating wallets: \(errorDescription!)")
                
            }
            
        }
        
    }
    
    func deactivateOtherNodes(nodeToActivate: UUID) {
        print("deactivateOtherNodes")
        
        let cd = CoreDataService()
        cd.retrieveEntity(entityName: .nodes) { (nodes, errorDescription) in
            
            if errorDescription == nil {
                
                if nodes!.count > 0 {
                    
                    for node in nodes! {
                        
                        let str = NodeStruct.init(dictionary: node)
                        
                        if str.id != nodeToActivate {
                            
                            cd.updateEntity(id: str.id, keyToUpdate: "isActive", newValue: false, entityName: .nodes) {
                                
                                if !cd.errorBool {
                                    
                                    self.load()
                                    
                                } else {
                                    
                                    displayAlert(viewController: self, isError: true, message: cd.errorDescription)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let id = segue.identifier
        
        switch id {
            
        case "addNode":
            
            if let vc = segue.destination as? ScannerViewController {
                
                vc.onDoneBlock = { result in
                    
                    self.load()
                    
                }
                
            }
            
        default:
            
            break
            
        }
        
    }
    

}
