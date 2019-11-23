//
//  Defaults.swift
//  StandUp
//
//  Created by Peter on 23/11/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation

class Defaults {
    
    private func getBitcoinConf(completion: @escaping ((conf: [String], error: Bool)) -> Void) {
        print("getbitcoinconf")
        let runBuildTask = RunBuildTask()
        runBuildTask.args = []
        runBuildTask.env = ["DATADIR":dataDir()]
        print("datadir = \(dataDir())")
        runBuildTask.showLog = false
        runBuildTask.exitStrings = ["Done"]
        runBuildTask.runScript(script: .getRPCCredentials) {
            
            if !runBuildTask.errorBool {
                
                let conf = (runBuildTask.stringToReturn).components(separatedBy: "\n")
                completion((conf, false))
                
            } else {
                
                completion(([""], true))
                setSimpleAlert(message: "Error", info: runBuildTask.errorDescription, buttonLabel: "OK")
                
            }
            
        }
        
    }
    
    let ud = UserDefaults.standard
    
    public func setDefaults(completion: @escaping () -> Void) {
        
        if ud.object(forKey: "testnet") == nil {
            
            ud.set(1, forKey: "testnet")
            
        }
        
        if ud.object(forKey: "mainnet") == nil {
            
            ud.set(0, forKey: "mainnet")
            
        }
        
        if ud.object(forKey: "regtest") == nil {
            
            ud.set(0, forKey: "regtest")
            
        }
        
        if ud.object(forKey: "dataDir") == nil {
            
            if chain() == "main" {
                
                ud.set("/Users/\(NSUserName())/Library/Application Support/Bitcoin", forKey: "dataDir")
                
            } else if chain() == "test" {
                
                ud.set("/Users/\(NSUserName())/Library/Application Support/Bitcoin/testnet3", forKey: "dataDir")
            }
            
        } else {
            
            print("datadir=\(ud.object(forKey: "dataDir") as! String)")
            
        }
        
        func setLocals() {
            
            print("setlocals")
            
            if ud.object(forKey: "pruned") == nil {
                print("prune == nil")
                
                ud.set(0, forKey: "pruned")
                
            }
            
            if ud.object(forKey: "txindex") == nil {
                print("txindex == nil")
                
                ud.set(0, forKey: "txindex")
                
            }
            
            if ud.object(forKey: "walletdisabled") == nil {
                
                ud.set(0, forKey: "walletdisabled")
                
            }
            
            completion()
            
        }
        
        getBitcoinConf { (conf, error) in
            
            if !error {
                
                print("conf = \(conf)")
                
                if conf.count > 0 {
                    
                    for setting in conf {
                        
                        if setting.contains("=") {
                            
                            let arr = setting.components(separatedBy: "=")
                            let k = arr[0]
                            let existingValue = arr[1]
                            
                            switch k {
                                
                            case "prune": self.ud.set(Int(existingValue)!, forKey: "prune")
                                print("updated prune to \(Int(existingValue)!)")
                                
                                if Int(existingValue) == 1 {
                                
                                    self.ud.set(0, forKey: "txindex")
                                
                                }
                                
                            case "walletdisabled": self.ud.set(Int(existingValue)!, forKey: "walletdisabled")
                                print("updated walletdisabled to \(Int(existingValue)!)")
                            case "txindex": self.ud.set(Int(existingValue)!, forKey: "txindex")
                                print("updated txindex to \(Int(existingValue)!)")
                            default:
                                break
                            }
                            
                        }
                        
                    }
                    
                    setLocals()
                    
                }
                
            } else {
                
                setLocals()
                print("error getting conf")
                
            }
            
        }
        
        if ud.object(forKey: "nodeLabel") == nil {
            
            ud.set("StandUp Node", forKey: "nodeLabel")
            
        }
        
    }
    
    public func chain() -> String {
        
        var chain = ""
        let testnet = ud.object(forKey: "testnet") as! Int
        let mainnet = ud.object(forKey: "mainnet") as! Int
        let regtest = ud.object(forKey: "regtest") as! Int
        
        if mainnet == 1 {
            chain = "main"
        }
        
        if testnet == 1 {
            chain = "test"
        }
        
        if regtest == 1 {
            chain = "regtest"
        }
        
        return chain
        
    }
    
    public func dataDir() -> String {
        
        return ud.object(forKey:"dataDir") as! String
        
    }
    
    public func prune() -> Int {
        
        //print("prune = \(ud.object(forKey:"prune") as! Int)")
        
        return ud.object(forKey:"prune") as? Int ?? 0
        
    }
    
    public func txindex() -> Int {
        
        //print("txindex = \(ud.object(forKey:"txindex") as! Int)")
        
        return ud.object(forKey: "txindex") as? Int ?? 0
        
    }
    
    public func walletdisabled() -> Int {
        
        return ud.object(forKey: "walletdisabled") as! Int
        
    }
    
    public func mainnet() -> Int {
        
        return ud.object(forKey: "mainnet") as! Int
        
    }
    
    public func testnet() -> Int {
        
        return ud.object(forKey: "testnet") as! Int
        
    }
    
    public func regtest() -> Int {
        
        return ud.object(forKey: "regtest") as! Int
        
    }
    
    public func setDataDir(value: String) {
        
        ud.set(value, forKey: "dataDir")
        
    }

}

