//
//  ConversationAssembly.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 29.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation


class ConversationAssembly {
    
    func conversationViewController() -> ConversationViewController {
        
        let model = conversationModel()
        let conversationListVC = ConversationViewController.initConversationVC(with: model)
        model.delegate = conversationListVC
        return conversationListVC
        
    }
    
    // MARK: - PRIVATE SECTION
    
    private func conversationModel() -> ConversationModelProtocol {
        return ConversationModel(sendMessageService: sendMessageService(), fetchMessagesService: fetchMessagesService())
    }
    
    private func sendMessageService() -> ISendMessageService {
        return SendMessageService(communicationManager: communicationManager())
    }
    private func fetchMessagesService() -> IFetchMessagesService {
       return FetchMessagesService(communicationManager: communicationManager())
    }
    
    private func communicationManager() -> CommunicationManagerProtocol {
        return RootAssembly.communicationManager
    }
    
    
}
