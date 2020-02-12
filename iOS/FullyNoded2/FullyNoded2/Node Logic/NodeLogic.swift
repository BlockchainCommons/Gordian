//
//  NodeLogic.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation

class NodeLogic {
    
    let dateFormatter = DateFormatter()
    var errorBool = Bool()
    var errorDescription = ""
    var dictToReturn = [String:Any]()
    var arrayToReturn = [[String:Any]]()
    var walletsToReturn = NSArray()
    var walletDisabled = Bool()
    var wallet:WalletStruct!
    
    func loadSectionOne(completion: @escaping () -> Void) {
        
        let reducer = Reducer()
        reducer.makeCommand(walletName: "", command: .getnetworkinfo, param: "") {
            
            if !reducer.errorBool {
                
                let networkInfo = reducer.dictToReturn
                let subversion = (networkInfo["subversion"] as! String).replacingOccurrences(of: "/", with: "")
                self.dictToReturn["subversion"] = subversion.replacingOccurrences(of: "Satoshi:", with: "")
                
                let localaddresses = networkInfo["localaddresses"] as! NSArray
                
                if localaddresses.count > 0 {
                    
                    for address in localaddresses {
                        
                        let dict = address as! NSDictionary
                        let p2pAddress = dict["address"] as! String
                        let port = dict["port"] as! Int
                        
                        if p2pAddress.contains("onion") {
                            
                            self.dictToReturn["p2pOnionAddress"] = p2pAddress + ":" + "\(port)"
                            
                        }
                        
                    }
                    
                }
                
                let networks = networkInfo["networks"] as! NSArray
                
                for network in networks {
                    
                    let dict = network as! NSDictionary
                    let name = dict["name"] as! String
                    
                    if name == "onion" {
                        
                        let reachable = dict["reachable"] as! Bool
                        self.dictToReturn["reachable"] = reachable
                        
                    }
                    
                }
                
                completion()
                
            } else {
                
                self.errorBool = true
                self.errorDescription = "\(reducer.errorDescription)"
                completion()
                
            }
            
        }
        
    }
    
    func loadSectionZero(completion: @escaping () -> Void) {
        print("loadSectionZero")
        
        let reducer = Reducer()
        
        func getResult() {
            
            if !reducer.errorBool {
                
                switch reducer.method {
                    
                case BTC_CLI_COMMAND.listunspent.rawValue:
                    
                    let utxos = reducer.arrayToReturn
                    parseUtxos(utxos: utxos)
                    completion()
                    
                default:
                    
                    print("break1")
                    break
                    
                }
                
            } else {
                
                errorBool = true
                errorDescription = reducer.errorDescription
                
                print("errorDescription = \(errorDescription)")
                
                if errorDescription.contains("Requested wallet does not exist or is not loaded") {
                    
                    // possibly changed from mainnet to testnet or vice versa, try and load once
                    
                    reducer.errorDescription = ""
                    reducer.errorBool = false
                    errorDescription = ""
                    errorBool = false
                    
                    reducer.makeCommand(walletName: wallet.name, command: .loadwallet, param: "\"\(wallet.name)\"") {
                        
                        if !reducer.errorBool {
                            
                            reducer.makeCommand(walletName: self.wallet.name, command: .listunspent,
                                                param: "0",
                                                completion: getResult)
                            
                        } else {
                            
                            self.errorBool = true
                            self.errorDescription = "Wallet does not exist, maybe you changed networks? If you want to use the app on a different network please delete the app and install again"
                            completion()
                            
                        }
                        
                    }
                    
                } else {
                    
                     completion()
                    
                }
                
            }
            
        }
        
        if !walletDisabled {
            
            reducer.makeCommand(walletName: wallet.name, command: .listunspent,
                                param: "0",
                                completion: getResult)
            
        } else {
            
            dictToReturn["coldBalance"] = "disabled"
            dictToReturn["unconfirmedBalance"] = "disabled"
            completion()
            
        }
        
    }
    
    func loadSectionTwo(completion: @escaping () -> Void) {
        print("loadSectionTwo")
        
        var walletName = ""
        
        if wallet != nil {
            
            walletName = wallet!.name
            
        }
        
        let reducer = Reducer()
        
        func getResult() {
            
            if !reducer.errorBool {
                
                switch reducer.method {
                    
                case BTC_CLI_COMMAND.estimatesmartfee.rawValue:
                    
                    let result = reducer.dictToReturn
                    
                    if let feeRate = result["feerate"] as? Double {
                        
                        let btcperbyte = feeRate / 1000
                        let satsperbyte = (btcperbyte * 100000000).avoidNotation
                        dictToReturn["feeRate"] = "\(satsperbyte) s/b"
                        
                    } else {
                        
                        if let errors = result["errors"] as? NSArray {
                            
                            dictToReturn["feeRate"] = "\(errors[0] as! String)"
                            
                        }
                       
                    }
                    
                    completion()
                    
                case BTC_CLI_COMMAND.getmempoolinfo.rawValue:
                    
                    let dict = reducer.dictToReturn
                    dictToReturn["mempoolCount"] = dict["size"] as! Int
                    let feeRate = UserDefaults.standard.integer(forKey: "feeTarget")
                    
                    reducer.makeCommand(walletName: walletName, command: .estimatesmartfee,
                                        param: "\(feeRate)",
                                        completion: getResult)
                    
                case BTC_CLI_COMMAND.uptime.rawValue:
                    
                    dictToReturn["uptime"] = Int(reducer.doubleToReturn)
                    
                    reducer.makeCommand(walletName: walletName, command: .getmempoolinfo,
                                        param: "",
                                        completion: getResult)
                    
                case BTC_CLI_COMMAND.getmininginfo.rawValue:
                    
                    let miningInfo = reducer.dictToReturn
                    parseMiningInfo(miningInfo: miningInfo)
                    
                    reducer.makeCommand(walletName: walletName, command: .uptime,
                                        param: "",
                                        completion: getResult)
                    
//                case BTC_CLI_COMMAND.getnetworkinfo.rawValue:
//
//                    let networkInfo = reducer.dictToReturn
//                    parseNetworkInfo(networkInfo: networkInfo)
                    
                    
                    
                case BTC_CLI_COMMAND.getpeerinfo.rawValue:
                    
                    let peerInfo = reducer.arrayToReturn
                    parsePeerInfo(peerInfo: peerInfo)
                    
                    reducer.makeCommand(walletName: walletName, command: .getmininginfo,
                                        param: "",
                                        completion: getResult)
                    
                case BTC_CLI_COMMAND.getblockchaininfo.rawValue:
                    
                    let blockchainInfo = reducer.dictToReturn
                    parseBlockchainInfo(blockchainInfo: blockchainInfo)
                    
                    reducer.makeCommand(walletName: walletName, command: .getpeerinfo,
                                        param: "",
                                        completion: getResult)
                    
                default:
                    
                    break
                    
                }
                
            } else {
                
                errorBool = true
                errorDescription = reducer.errorDescription
                completion()
                
            }
            
        }
        
        reducer.makeCommand(walletName: walletName, command: .getblockchaininfo,
                            param: "",
                            completion: getResult)
        
        
        
    }
    
    func loadSectionThree(completion: @escaping () -> Void) {
        print("loadSectionThree")
        
        let reducer = Reducer()
        
        func getResult() {
            
            if !reducer.errorBool {
                
                switch reducer.method {
                    
                case BTC_CLI_COMMAND.listtransactions.rawValue:
                    
                    let transactions = reducer.arrayToReturn
                    parseTransactions(transactions: transactions)
                    completion()
                    
                default:
                    
                    break
                    
                }
                
            } else {
                
                errorBool = true
                errorDescription = reducer.errorDescription
                completion()
                
            }
            
        }
        
        if !walletDisabled {
            
            reducer.makeCommand(walletName: wallet.name, command: .listtransactions,
                                param: "\"*\", 50, 0, true",
                                completion: getResult)
            
        } else {
            
            arrayToReturn = []
            completion()
            
        }
        
    }
    
    // MARK: Section 0 parsers
    
    func parseUtxos(utxos: NSArray) {
        
        var amount = 0.0
        
        for utxo in utxos {
            
            let utxoDict = utxo as! NSDictionary
            let spendable = utxoDict["spendable"] as! Bool
            let confirmations = utxoDict["confirmations"] as! Int
            
            if !spendable {
                
                let balance = utxoDict["amount"] as! Double
                amount += balance
                
            }
            
            if confirmations < 1 {
                
                dictToReturn["unconfirmed"] = true
                
            }
            
        }
        
        if amount == 0.0 {
            
            dictToReturn["coldBalance"] = "0.0"
            
        } else {
            
            dictToReturn["coldBalance"] = "\((round(100000000*amount)/100000000).avoidNotation)"
            
        }
        
    }
    
    // MARK: Section 1 parsers
    
    func parseMiningInfo(miningInfo: NSDictionary) {
        
        let hashesPerSecond = miningInfo["networkhashps"] as! Double
        let exahashesPerSecond = hashesPerSecond / 1000000000000000000
        dictToReturn["networkhashps"] = Int(exahashesPerSecond).withCommas()
        
    }
    
    func parseBlockchainInfo(blockchainInfo: NSDictionary) {
        
        if let currentblockheight = blockchainInfo["blocks"] as? Int {
            
            dictToReturn["blocks"] = currentblockheight
            
        }
        
        if let difficultyCheck = blockchainInfo["difficulty"] as? Double {
            
            
            dictToReturn["difficulty"] = "\(Int(difficultyCheck / 1000000000000).withCommas()) trillion"
            
        }
        
        if let sizeCheck = blockchainInfo["size_on_disk"] as? Int {
            
            dictToReturn["size"] = "\(sizeCheck/1000000000) gb"
            
        }
        
        if let progressCheck = blockchainInfo["verificationprogress"] as? Double {
            
            dictToReturn["progress"] = "\(Int(progressCheck*100))%"
            
        }
        
        if let chain = blockchainInfo["chain"] as? String {
            
            dictToReturn["chain"] = chain
            
        }
        
        if let pruned = blockchainInfo["pruned"] as? Bool {
            
            dictToReturn["pruned"] = pruned
            
        }
        
    }
    
    func parsePeerInfo(peerInfo: NSArray) {
        
        var incomingCount = 0
        var outgoingCount = 0
        
        for peer in peerInfo {
            
            let peerDict = peer as! NSDictionary
            
            let incoming = peerDict["inbound"] as! Bool
            
            if incoming {
                
                incomingCount += 1
                dictToReturn["incomingCount"] = incomingCount
                
            } else {
                
                outgoingCount += 1
                dictToReturn["outgoingCount"] = outgoingCount
                
            }
            
        }
        
    }
    
    func parseNetworkInfo(networkInfo: NSDictionary) {
        
        
        
    }
    
    func parseTransactions(transactions: NSArray) {
        
        var transactionArray = [[String:Any]]()
        self.arrayToReturn.removeAll()
        
        for item in transactions {
            
            if let transaction = item as? NSDictionary {
                
                var label = String()
                var replaced_by_txid = String()
                var isCold = false
                
                let address = transaction["address"] as? String ?? ""
                let amount = transaction["amount"] as? Double ?? 0.0
                let amountString = amount.avoidNotation
                let confsCheck = transaction["confirmations"] as? Int ?? 0
                let confirmations = String(confsCheck)
                
                if let replaced_by_txid_check = transaction["replaced_by_txid"] as? String {
                    
                    replaced_by_txid = replaced_by_txid_check
                    
                }
                
                if let labelCheck = transaction["label"] as? String {
                    
                    label = labelCheck
                    
                    if labelCheck == "" {
                        
                        label = ""
                        
                    }
                    
                    if labelCheck == "," {
                        
                        label = ""
                        
                    }
                    
                } else {
                    
                    label = ""
                    
                }
                
                let secondsSince = transaction["time"] as? Double ?? 0.0
                let rbf = transaction["bip125-replaceable"] as? String ?? ""
                let txID = transaction["txid"] as? String ?? ""
                
                let date = Date(timeIntervalSince1970: secondsSince)
                dateFormatter.dateFormat = "MMM-dd-yyyy HH:mm"
                let dateString = dateFormatter.string(from: date)
                
                if let boolCheck = transaction["involvesWatchonly"] as? Bool {
                    
                    isCold = boolCheck
                    
                }
                
                
                                
                transactionArray.append(["address": address,
                                         "amount": amountString,
                                         "confirmations": confirmations,
                                         "label": label,
                                         "date": dateString,
                                         "rbf": rbf,
                                         "txID": txID,
                                         "replacedBy": replaced_by_txid,
                                         "involvesWatchonly":isCold,
                                         "selfTransfer":false,
                                         "remove":false])
                
            }
            
        }
        
        // process self transfers
                    
        for (i, tx) in transactionArray.enumerated() {
            
            let amount = Double(tx["amount"] as! String)!
            let txID = tx["txID"] as! String
            
            for (x, transaction) in transactionArray.enumerated() {
                
                let amountToCompare = Double(transaction["amount"] as! String)!
                
                if x != i && txID == (transaction["txID"] as! String) {
                    
                    if amount + amountToCompare == 0 && amount > 0 {
                        
                        transactionArray[i]["selfTransfer"] = true
                        
                    } else if amount + amountToCompare == 0 && amount < 0 {
                        
                        transactionArray[i]["remove"] = true
                        
                    }
                    
                }
                
            }
            
        }
                    
        for tx in transactionArray {
            
            if !(tx["remove"] as! Bool) {
                
                arrayToReturn.append(tx)
                
            }
            
        }
        
    }
    
}
