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
        return ConversationModel(sendMessageService: sendMessageService(), fetchMessagesService: fetchMessagesService(), writeDataService: writeDataService(), readDataService: readDataService())
    }
    
    private func writeDataService() -> IWriteDataService {
        return WriteDataService(dataManager: writeDataFileManager())
    }
    private func writeDataFileManager() -> WriteDataProtocol {
        return StorageManager()
    }
    private func readDataService() -> IReadDataService {
        return ReadDataService(dataManager: readDataManager())
    }
    private func readDataManager() -> ReadDataProtocol {
        return StorageManager()
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
