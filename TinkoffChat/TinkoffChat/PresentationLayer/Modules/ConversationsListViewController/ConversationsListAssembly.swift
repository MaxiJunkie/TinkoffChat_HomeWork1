//
//  ConversationListAssembly.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 28.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

class ConversationsListAssembly {
    
    func conversationsListViewController() -> ConversationsListViewController {
        
        let model = communicationModel()
        let conversationListVC = ConversationsListViewController.initConversationsList(with: model)
        model.delegate = conversationListVC
        return conversationListVC
   
    }
    
    // MARK: - PRIVATE SECTION
    
    private func communicationModel() -> CommunicationListModelProtocol {
        return ConversationsListModel(peersService: peersService())
    }
    
    private func peersService() -> IPeersService {
        return PeersService(communicationManager: communicationManager())
    }
    
    private func communicationManager() -> CommunicationManagerProtocol {
        return RootAssembly.communicationManager
    }
    

}
