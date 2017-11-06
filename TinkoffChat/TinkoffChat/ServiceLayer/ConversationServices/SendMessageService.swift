//
//  ConversationService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 29.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol ISendMessageService {
    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?)
}

class SendMessageService : ISendMessageService {
    
    let communicationManager  : CommunicationManagerProtocol
    
    init(communicationManager: CommunicationManagerProtocol ) {
        self.communicationManager = communicationManager
        
    }
    
    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?) {
        communicationManager.sendMessage(text: text, toUserID: toUserID) { (success, error) in
            if success {
                completion!(success,nil)
            } else
            {
                completion!(false,error)
            }
        }
    }
}
