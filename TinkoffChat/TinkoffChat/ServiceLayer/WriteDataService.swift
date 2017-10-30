//
//  WriteDataService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 30.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation



protocol IWriteDataService {
    
    func writeDataWithGCD(_ dictionary : [String: Any], completionHandler: @escaping (() -> ()), errorBlock: ((NSError) -> ())?)
    func writeDataWithOperation(_ dictionary : [String: Any], completionHandler: @escaping (() -> ()), errorBlock: ((NSError?) -> ())?)
}

class WriteDataService : IWriteDataService {
    
    let GCDDataManager: WriteDataProtocol
    let createQueue : CreateQueueProtocol
    
    init(GCDDataManager: WriteDataProtocol,createQueue: CreateQueueProtocol ) {
        self.GCDDataManager = GCDDataManager
        self.createQueue = createQueue

    }
    
    
    func writeDataWithGCD(_ dictionary : [String: Any], completionHandler: @escaping (() -> ()), errorBlock: ((NSError) -> ())?){
        GCDDataManager.writeDataInFile(dictionary, completion: {
            completionHandler()
        }, errorBlock: { error in
            errorBlock!(error)
        })
    }
    
    func writeDataWithOperation(_ dictionary : [String: Any], completionHandler: @escaping (() -> ()), errorBlock: ((NSError?) -> ())?) {
      
        createQueue.createQueue(dictionary: dictionary, completionHandler: {
             completionHandler()
        }) {
            errorBlock!(nil)
        }
    }
}
