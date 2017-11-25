//
//  peersService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 29.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol IPeersService {
    func loadNewPeers(completionHandler: @escaping ((_ userId: String, _ userName: String?,_ isOnline: Bool) -> Void))
}

class PeersService : IPeersService {
    
    let communicationManager  : CommunicationManagerProtocol
    
    init(communicationManager: CommunicationManagerProtocol ) {
        self.communicationManager = communicationManager
        
    }
    
    func loadNewPeers(completionHandler: @escaping ((_ userId: String,_ userName: String?, _ isOnline: Bool) -> Void)) {
       
        communicationManager.updateCurrentConversation = { ( userId: String, userName: String?, isOnline: Bool) in
           
            completionHandler(userId, userName, isOnline)
        
        }
    }
    
}
