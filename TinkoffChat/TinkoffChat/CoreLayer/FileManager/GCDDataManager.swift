//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 14.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol ReadDataProtocol : class {
    func readDataFromFile(completion: @escaping (([String: Any]) -> ()), errorBlock: ((NSError) -> ())?)
}

protocol WriteDataProtocol : class {
    func writeDataInFile(_ dictionary : [String: Any], completion: (() -> ())?, errorBlock: ((NSError) -> ())?)
}

class GCDDataManager : ReadDataProtocol, WriteDataProtocol {
    
    let documentsDirectoryPath :NSURL =  NSURL(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)!
    
    //MARK - GCDDataManagerProtocol
    
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
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let jsonFilePath = self?.documentsDirectoryPath.appendingPathComponent("test.json") {
                if (self?.createdFile(jsonFilePath))! {
                    do {
                        let file = try FileHandle(forReadingFrom: jsonFilePath)
                        let data = file.readDataToEndOfFile()
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let object = json as? [String: Any] {
                            completion(object)
                        }
                    } catch let error as NSError {
                        print("Couldn't read from file: \(error.localizedDescription)")
                        if errorBlock != nil {
                            errorBlock!(error)
                        }
                    }
                }
            }
        }
    }
    
    internal func writeDataInFile(_ dictionary : [String: Any], completion: (() -> ())?, errorBlock: ((NSError) -> ())?) {
    
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            if let jsonFilePath = self?.documentsDirectoryPath.appendingPathComponent("test.json") {
                if (self?.createdFile(jsonFilePath))! {
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
             
                        if completion != nil {
                            completion!()
                        }
                    } catch let error as NSError {
                        print("Couldn't write to file: \(error.localizedDescription)")
                        if errorBlock != nil {
                            errorBlock!(error)
                        }
                    }
                }
            }
        }
    }
}
