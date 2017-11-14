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
    func writeData(with conversation: [Conversations] , completion: (() -> ())?)
    func writeMessageData(with userId: String,message : Message, completion: (() -> ())?)
 
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
    
    func writeData(with conversation: [Conversations] , completion: (() -> ())?) {
        
        dataManager.writeNewUsersInStorage(users: conversation) {
            completion!()
        }
        
    }
    
    func writeMessageData(with userId: String,message : Message, completion: (() -> ())?) {
        
        dataManager.writeConversationInStorage(with: userId, message: message ) {
           completion!()
        }

    }
    

}
