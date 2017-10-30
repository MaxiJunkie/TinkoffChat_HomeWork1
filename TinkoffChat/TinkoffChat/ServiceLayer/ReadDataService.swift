//
//  ReadDataService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 30.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation


protocol IReadDataService {
    
    func readDataWithGCD(completionHandler: @escaping (([String: Any]) -> ()), errorBlock: ((NSError) -> ())?)
    func readDataWithOperation(completionHandler: @escaping (([String: Any]) -> ()), errorBlock: ((NSError) -> ())?)
}

class ReadDataService : IReadDataService {
    
    let GCDDataManager: ReadDataProtocol
    let operationDataManager: ReadDataProtocol
    
    init(GCDDataManager: ReadDataProtocol, operationDataManager: ReadDataProtocol) {
        self.GCDDataManager = GCDDataManager
        self.operationDataManager = operationDataManager
        
    }
    
    
    func readDataWithGCD(completionHandler: @escaping (([String : Any]) -> ()), errorBlock: ((NSError) -> ())?) {
        GCDDataManager.readDataFromFile(completion: { (dictionary) in
            completionHandler(dictionary)
        }, errorBlock: { error in
            errorBlock!(error)
        })
    }
    
    func readDataWithOperation(completionHandler: @escaping (([String : Any]) -> ()), errorBlock: ((NSError) -> ())?) {
        operationDataManager.readDataFromFile(completion: { (dictionary) in
            completionHandler(dictionary)
        }, errorBlock: { error in
            errorBlock!(error)
        })
    }
    
}
