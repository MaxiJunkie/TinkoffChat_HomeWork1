//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 28.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import CoreData

protocol CommunicationListModelProtocol: class {
    
    func fetchNewPeers(completion: (() -> ())?)
    func fetchedResultsController(completion: ((NSFetchedResultsController<User>) -> ())?)
    
}

protocol CommunicationManagerDelegate: class {
    func reloadData(with messages: [Conversations])
}



class ConversationsListModel: CommunicationListModelProtocol {

    let peersService: IPeersService
    let readDataService: IReadDataService
    
    init(peersService: IPeersService , readDataService: IReadDataService) {
        self.peersService = peersService
        self.readDataService = readDataService
    }
    
    func fetchNewPeers(completion: (() -> ())?)  {
        
        peersService.loadNewPeers { (arrayOfPeers : [Conversations]) in
            
        }
    }
    
  
    func fetchedResultsController(completion: ((NSFetchedResultsController<User>) -> ())?) {
        readDataService.fetchedResultsController { (frc) in
            completion!(frc)
        }
        
    }

}
