//
//  fetchMessagesService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 29.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation


protocol IFetchMessagesService {
    func loadNewMessages(completionHandler: @escaping (([Message]) -> Void))
}

class FetchMessagesService : IFetchMessagesService {
    
    let communicationManager  : CommunicationManagerProtocol
    
    init(communicationManager: CommunicationManagerProtocol ) {
        self.communicationManager = communicationManager
        
    }
    
 
    func loadNewMessages(completionHandler: @escaping (([Message]) -> Void)) {
        
        communicationManager.messageUpdate = { (arrayOfPeers : [Message]) in
            completionHandler(arrayOfPeers)
        }
    }
}
