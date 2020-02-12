//
//  CoreDataService.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    
    var entities = [[String:Any]]()
    var boolToReturn = Bool()
    var errorBool = Bool()
    var errorDescription = ""
    
    func saveSeed(seed: Data, completion: @escaping () -> Void) {
        print("saveSeedToCoreData")
        
        DispatchQueue.main.async {
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
                let context = appDelegate.persistentContainer.viewContext
                guard let entity = NSEntityDescription.entity(forEntityName: "Seed", in: context) else {
                    self.errorBool = true
                    self.errorDescription = "unable to access Seed"
                    completion()
                    return
                }
                
                let credential = NSManagedObject(entity: entity, insertInto: context)
                
                credential.setValue(seed, forKey: "seed")
                
                do {
                    
                    try context.save()
                    self.boolToReturn = true
                    print("Saved seed")
                    
                } catch {
                    
                    self.errorBool = true
                    self.errorDescription = "Failed saving seed"
                    
                }
                
                completion()
                
            } else {
                
                self.errorBool = true
                self.errorDescription = "Unable to access app delegate for core data"
                completion()
                
            }
            
        }
        
    }
    
    func saveEntity(dict: [String:Any], entityName: ENTITY, completion: @escaping () -> Void) {
        print("saveEntityToCoreData")
        
        DispatchQueue.main.async {
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
                let context = appDelegate.persistentContainer.viewContext
                guard let entity = NSEntityDescription.entity(forEntityName: entityName.rawValue, in: context) else {
                    self.errorBool = true
                    self.errorDescription = "unable to access \(entityName.rawValue)"
                    completion()
                    return
                }
                
                let credential = NSManagedObject(entity: entity, insertInto: context)
                
                for (key, value) in dict {
                    
                    credential.setValue(value, forKey: key)
                    
                    do {
                        
                        try context.save()
                        self.boolToReturn = true
                        print("Saved credential \(key) = \(value)")
                        
                    } catch {
                        
                        self.errorBool = true
                        self.errorDescription = "Failed saving credential \(key) = \(value)"
                        
                    }
                    
                }
                
                completion()
                
            } else {
                
                self.errorBool = true
                self.errorDescription = "Unable to access app delegate for core data"
                completion()
                
            }
            
        }
        
    }
    
    func retrieveEntity(entityName: ENTITY, completion: @escaping ((entity: [[String:Any]]?, errorDescription: String?)) -> Void) {
        print("retrieveEntity")
        
        DispatchQueue.main.async {

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                print("got app delegate")

                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.resultType = .dictionaryResultType
                
                do {
                    
                    if let results = try context.fetch(fetchRequest) as? [[String:Any]] {
                            
                        completion((results, nil))
                                                
                    }
                    
                } catch {
                    
                    completion((nil, "Error fetching \(entityName)"))
                    
                }

            } else {

                completion((nil, "error can't access app delegate"))
                
            }

        }
        
    }
    
    func updateEntity(id: UUID, keyToUpdate: String, newValue: Any, entityName: ENTITY, completion: @escaping () -> Void) {
        print("updateEntity")
        
       DispatchQueue.main.async {
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    
                    let context = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
                    fetchRequest.returnsObjectsAsFaults = false
                    
                    do {
                        
                        let results = try context.fetch(fetchRequest) as [NSManagedObject]
                        
                        if results.count > 0 {
                            
                            for data in results {
                                
                                if id == data.value(forKey: "id") as? UUID {
                                    
                                    print("set \(newValue) for key \(keyToUpdate)")
                                    data.setValue(newValue, forKey: keyToUpdate)
                                    
                                    do {
                                        
                                        try context.save()
                                        self.errorBool = false
                                        self.boolToReturn = true
                                        print("updated successfully")
                                        completion()
                                        
                                    } catch {
                                        
                                        print("error editing")
                                        self.errorBool = true
                                        self.errorDescription = "error editing"
                                        completion()
                                        
                                    }
                                    
                                }
                                
                            }
                                                       
                        } else {
                            
                            print("no results")
                            self.errorBool = true
                            self.errorDescription = "no results"
                            completion()
                        }
                        
                    } catch {
                        
                        print("Failed")
                        self.errorBool = true
                        self.errorDescription = "failed"
                        completion()
                    }
                    
                } else {
                    
                    self.errorBool = true
                    self.errorDescription = "Something strange has happened and we do not have access to app delegate, please try again."
                    completion()
                    
                }
                
            }
            
        //}
        
    }
    
    func deleteSeed(completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Seed")
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    
                    let results = try context.fetch(fetchRequest) as [NSManagedObject]
                    
                    if results.count > 0 {
                        
                        for result in results {
                            
                            context.delete(result as NSManagedObject)
                            
                            do {
                                
                                try context.save()
                                print("deleted succesfully")
                                self.boolToReturn = true
                                self.errorBool = false
                                
                            } catch {
                                
                                print("error deleting")
                                self.boolToReturn = false
                                self.errorBool = true
                                self.errorDescription = "error deleting"
                                
                            }
                            
                        }
                        
                        completion()
                        
                    } else {
                        
                        print("no results")
                        self.errorBool = true
                        self.errorDescription = "no results for that entity to delete"
                        completion()
                        
                    }
                    
                } catch {
                    
                    print("Failed")
                    self.errorBool = true
                    self.errorDescription = "failed trying to delete that entity"
                    completion()
                    
                }
                
            } else {
                
                self.errorBool = true
                self.errorDescription = "failed getting the app delegate"
                completion()
                
            }
            
        }
                
    }
    
    func deleteEntity(id: UUID, entityName: ENTITY, completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    
                    let results = try context.fetch(fetchRequest) as [NSManagedObject]
                    
                    if results.count > 0 {
                        
                        for (index, data) in results.enumerated() {
                            
                            if id == data.value(forKey: "id") as? UUID {
                                
                                context.delete(results[index] as NSManagedObject)
                                
                                do {
                                    
                                    try context.save()
                                    print("deleted succesfully")
                                    self.boolToReturn = true
                                    self.errorBool = false
                                    
                                } catch {
                                    
                                    print("error deleting")
                                    self.boolToReturn = false
                                    self.errorBool = true
                                    self.errorDescription = "error deleting"
                                    
                                }
                                
                            }
                            
                        }
                        
                        completion()
                        
                    } else {
                        
                        print("no results")
                        self.errorBool = true
                        self.errorDescription = "no results for that entity to delete"
                        completion()
                        
                    }
                    
                } catch {
                    
                    print("Failed")
                    self.errorBool = true
                    self.errorDescription = "failed trying to delete that entity"
                    completion()
                    
                }
                
            } else {
                
                self.errorBool = true
                self.errorDescription = "failed getting the app delegate"
                completion()
                
            }
            
        }
                
    }
    
}
