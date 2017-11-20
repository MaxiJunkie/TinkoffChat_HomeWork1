//
//  WriteDataService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 30.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation



protocol IWriteDataService {
    
    func writeData(_ profile : ProfileDataInterface, completion: (() -> ())?)
}

class WriteDataService : IWriteDataService {
    
    let dataManager: WriteDataProtocol
 
    init(dataManager: WriteDataProtocol) {
        self.dataManager = dataManager
    
    }
    
    func writeData(_ profile : ProfileDataInterface, completion: (() -> ())?) {
        dataManager.updateProfileData(profile: profile) {
            completion!()
        }
    }
    
}
