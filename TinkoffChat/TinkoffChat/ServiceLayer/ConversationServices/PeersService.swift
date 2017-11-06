//
//  peersService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 29.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol IPeersService {
    func loadNewPeers(completionHandler: @escaping ((_ data: [Message]) -> Void))
}

class PeersService : IPeersService {
    
    let communicationManager  : CommunicationManagerProtocol
    
    init(communicationManager: CommunicationManagerProtocol ) {
        self.communicationManager = communicationManager
        
    }
    
    func loadNewPeers(completionHandler: @escaping (([Message]) -> Void)) {
       
        communicationManager.onDataUpdate = { (arrayOfPeers : [Message]) in
       
            completionHandler(arrayOfPeers)
        }
    }
    
}
