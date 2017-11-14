//
//  peersService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 29.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol IPeersService {
    func loadNewPeers(completionHandler: @escaping ((_ data: [Conversations]) -> Void))
}

class PeersService : IPeersService {
    
    let communicationManager  : CommunicationManagerProtocol
    
    init(communicationManager: CommunicationManagerProtocol ) {
        self.communicationManager = communicationManager
        
    }
    
    func loadNewPeers(completionHandler: @escaping (([Conversations]) -> Void)) {
       
        communicationManager.onDataUpdate = { (arrayOfPeers : [Conversations]) in
       
            completionHandler(arrayOfPeers)
        }
    }
    
}
