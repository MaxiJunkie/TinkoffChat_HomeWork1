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
      
        return conversationListVC
   
    }
    
    // MARK: - PRIVATE SECTION
    
    private func communicationModel() -> CommunicationListModelProtocol {
        return ConversationsListModel( peersService: peersService(), writeDataService: writeDataService(), readDataService: readDataService())
    }
    
    private func peersService() -> IPeersService {
        return PeersService(communicationManager: communicationManager())
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
    private func communicationManager() -> CommunicationManagerProtocol {
        return RootAssembly.communicationManager
    }
    

}
