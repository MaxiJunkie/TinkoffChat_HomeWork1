//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 14.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation


class OperationDataManager : Operation , ReadDataProtocol, WriteDataProtocol {
 
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    var operationDictionary = [String:Any]()
    var errorBlock: (() -> ())?
    var completion: (([String: Any]) -> ())?
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
            
            writeDataInFile(self.operationDictionary, completion: nil, errorBlock: nil)
            if self.isCancelled {
                
                state = .finished
            } else {
                state = .finished
            }
            
            
        }
    }
    
    
    private let documentsDirectoryPath = NSURL(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)!
    
    //MARK - OperationDataManagerProtocol
    
    internal func createdFile(_ url: URL?) -> Bool {
        if let jsonFilePath = url {
            let fileManager = FileManager.default
            var isDirectory: ObjCBool = false
            if !fileManager.fileExists(atPath: jsonFilePath.absoluteString, isDirectory: &isDirectory) {
                let created = fileManager.createFile(atPath: jsonFilePath.absoluteString, contents: nil, attributes: nil)
                if created {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        }
        return false
    }
    
    internal func readDataFromFile(completion: @escaping (([String: Any]) -> ()), errorBlock: ((NSError) -> ())?) {
        
         weak var weakSelf = self
        
            if let jsonFilePath = weakSelf?.documentsDirectoryPath.appendingPathComponent("test.json") {
                if self.createdFile(jsonFilePath) {
                    do {
                        let file = try FileHandle(forReadingFrom: jsonFilePath)
                        let data = file.readDataToEndOfFile()
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let object = json as? [String: Any] {
                            weakSelf?.completion!(object)
                        }
                    } catch let error as NSError {
                        print("Couldn't read from file: \(error.localizedDescription)")
                            weakSelf?.errorBlock!()
                }
            }
        }
    }
    
    internal func writeDataInFile(_ dictionary : [String: Any], completion: (() -> ())?, errorBlock: ((NSError) -> ())?) {

        weak var weakSelf = self
        
            if let jsonFilePath = weakSelf?.documentsDirectoryPath.appendingPathComponent("test.json") {
                if self.createdFile(jsonFilePath) {
                    let dict = dictionary
                    var jsonData: NSData!
                    do {
                        jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions()) as NSData
                        
                    } catch let error as NSError {
                        print("Array to JSON conversion failed: \(error.localizedDescription)")
                    }
                 
                    do {
                        let file = try FileHandle(forWritingTo: jsonFilePath)
                        file.truncateFile(atOffset: 0)
                        file.write(jsonData as Data)
                        file.closeFile()
                 
                    } catch let error as NSError {
                        print("Couldn't write to file: \(error.localizedDescription)")
                        weakSelf?.errorBlock!()
                    }
                }
            }
        }
}
