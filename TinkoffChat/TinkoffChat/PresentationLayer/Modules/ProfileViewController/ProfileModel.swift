//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 30.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

enum TypeOfSaving {
    case globalCentralDispatch
    case operation
}

protocol ProfileModelProtocol: class {
    func readDataFromFile(using type: TypeOfSaving, completion: @escaping (([String: Any]) -> ()), errorBlock: ((NSError) -> ())?)
    func writeDataInFile(using type: TypeOfSaving, _ dictionary : [String: Any], completion: @escaping (() -> ()), errorBlock: ((NSError) -> ())?)
   
}

class ProfileModel : ProfileModelProtocol {

    
    let readDataService: IReadDataService
    let writeDataService: IWriteDataService
    
    init(readDataService: IReadDataService, writeDataService: IWriteDataService ) {
        self.readDataService = readDataService
        self.writeDataService = writeDataService
    }
    
    func readDataFromFile(using type: TypeOfSaving, completion: @escaping (([String : Any]) -> ()), errorBlock: ((NSError) -> ())?) {
        if type == .globalCentralDispatch {
            readDataService.readDataWithGCD(completionHandler: { (dictionary) in
                completion(dictionary)
            }, errorBlock: nil)
            
        } else {
            readDataService.readDataWithOperation(completionHandler: { (dictionary) in
                completion(dictionary)
            }, errorBlock: nil)
        }
        
    }
    
    func writeDataInFile(using type: TypeOfSaving, _ dictionary: [String : Any], completion: @escaping (() -> ()), errorBlock: ((NSError) -> ())?) {
        if type == .globalCentralDispatch {
            writeDataService.writeDataWithGCD(dictionary, completionHandler: {
                completion()
            }, errorBlock: { error in
                errorBlock!(error)
            })
        }
        else {
            writeDataService.writeDataWithOperation(dictionary, completionHandler: {
                completion()
            }, errorBlock: { error in
                if let err = error {
                   errorBlock!(err)
                }
            })
        }
    }
    
    
}
