//
//  ReadDataService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 30.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation


protocol IReadDataService {
    func readData(completionHandler: @escaping ((ProfileDataInterface) -> ()), errorBlock: ((NSError) -> ())?)
}

class ReadDataService : IReadDataService {
    
    let dataManager: ReadDataProtocol

    init(dataManager: ReadDataProtocol) {
        self.dataManager = dataManager
  
    }
    
    func readData(completionHandler: @escaping ((ProfileDataInterface) -> ()), errorBlock: ((NSError) -> ())?) {
  
        dataManager.fetchProfileData { (profile) in
            completionHandler(profile)
        }
        
    }
    
}
