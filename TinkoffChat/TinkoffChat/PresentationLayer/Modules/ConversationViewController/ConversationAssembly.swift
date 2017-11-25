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
        return conversationListVC
        
    }
    
    // MARK: - PRIVATE SECTION
    
    private func conversationModel() -> ConversationModelProtocol {
        return ConversationModel(sendMessageService: sendMessageService(), readDataService: readDataService(), peersService: peersService())
    }
    
    private func readDataService() -> IReadDataService {
        return ReadDataService(dataManager: readDataManager())
    }
    private func readDataManager() -> ReadDataProtocol {
        return StorageManager()
    }
    
    private func peersService() -> IPeersService {
        return PeersService(communicationManager: communicationManager())
    }
    
    private func sendMessageService() -> ISendMessageService {
        return SendMessageService(communicationManager: communicationManager())
    }
  
    private func communicationManager() -> CommunicationManagerProtocol {
        return RootAssembly.communicationManager
    }
    
    
}
