//
//  RunBuildTask.swift
//  StandUp
//
//  Created by Peter on 13/11/19.
//  Copyright © 2019 Peter. All rights reserved.
//

import Foundation
import Cocoa

class RunBuildTask {
    
    var isRunning = false
    var buildTask:Process!
    var args = [String]()
    var stringToReturn = ""
    var terminate = Bool()
    var errorBool = Bool()
    var errorDescription = ""
    var exitStrings = [String]()
    var textView = NSTextView()
    var showLog = Bool()
    //static let sharedInstance = RunBuildTask()
    
    func runScript(script: SCRIPT, completion: @escaping () -> Void) {
        
        isRunning = true
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        let resource = script.rawValue
        
        taskQueue.async {
            
            guard let path = Bundle.main.path(forResource: resource, ofType: "command") else {
                print("Unable to locate \(resource).command")
                return
            }
            
            self.buildTask = Process()
            self.buildTask.launchPath = path
            self.buildTask.arguments = self.args
            
            self.buildTask.terminationHandler = {
                
                task in
                
                print("task did terminate")
                
                DispatchQueue.main.async {
                    self.isRunning = false
                    self.errorBool = false
                    completion()
                }
                
            }
            
            self.captureStandardOutputAndRouteToTextView(task: self.buildTask, script: script, textView: self.textView, completion: completion)
            self.buildTask.launch()
            self.buildTask.waitUntilExit()
            
        }
        
    }
    
    func captureStandardOutputAndRouteToTextView(task: Process, script: SCRIPT, textView: NSTextView, completion: @escaping () -> Void) {
        
        let stdOut = Pipe()
        let stdErr = Pipe()
        task.standardOutput = stdOut
        task.standardError = stdErr
        
        let handler = { (file: FileHandle!) -> Void in
            
            let data = file.availableData
            
            if self.isRunning {
                
                guard let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                    self.errorBool = true
                    self.errorDescription = "failed to parse data into string"
                    completion()
                    return
                }
                
                self.stringToReturn = output as String
                
                DispatchQueue.main.async {
                    
                    if self.showLog {
                        
                        let prevOutput = self.textView.string
                        let nextOutput = prevOutput + (output as String)
                        self.textView.string = nextOutput
                        
                    }
                    
                    var exitNow = false
                    
                    for str in self.exitStrings {
                        
                        if (output as String).contains(str) {
                            
                            exitNow = true
                            print("exitnow")
                            
                        }
                        
                    }
                    
                    if exitNow && self.isRunning {
                        
                        if self.buildTask.isRunning {
                            
                            self.buildTask.terminate()
                            print("terminate")
                            
                            do {
                                
                                if #available(OSX 10.15, *) {
                                    
                                    try file.close()
                                    print("file closed")
                                    
                                } else {
                                    
                                    //handle older version here
                                    
                                }
                                
                            } catch {
                                
                                print("failed closing file")
                                
                            }
                            
                        }
                        
                    } else {
                        
                        if self.isRunning {
                            
                            self.textView.scrollToEndOfDocument(self)
                            
                        }
                        
                    }
                    
                }
                                
            }
            
        }
        
        stdErr.fileHandleForReading.readabilityHandler = handler
        stdOut.fileHandleForReading.readabilityHandler = handler
        
    }
    
}
