//
//  CreateQueue.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 30.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol CreateQueueProtocol {
    func createQueue(dictionary: [String:Any], completionHandler: @escaping (() -> ()), errorBlock: (() -> ())?)
}


class CreateQueue: CreateQueueProtocol {
    
    let queue = OperationQueue()
    
    let operation = OperationDataManager()
    
    func createQueue(dictionary: [String:Any] , completionHandler: @escaping (() -> ()), errorBlock: (() -> ())?) {
        
        weak var weakSelf = self
        weakSelf?.queue.maxConcurrentOperationCount = 1
        weakSelf?.operation.operationDictionary = dictionary
        weakSelf?.queue.addOperation(operation)
        weakSelf?.operation.completionBlock = {
            if  weakSelf?.operation.errorBlock != nil {
                errorBlock!()
            } else {
                completionHandler()
            }
        }
    }
    
}
