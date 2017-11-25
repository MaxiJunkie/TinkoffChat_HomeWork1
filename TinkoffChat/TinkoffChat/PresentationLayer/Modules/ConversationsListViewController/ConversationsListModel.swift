//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 28.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CommunicationListModelProtocol: class {
    
    func fetchNewPeers(completion: (() -> ())?)
    func fetchedResultsController(completion: ((NSFetchedResultsController<User>) -> ())?)
    
}


class ConversationsListModel: CommunicationListModelProtocol {

    let peersService: IPeersService
    let readDataService: IReadDataService
    
    init(peersService: IPeersService , readDataService: IReadDataService) {
        self.peersService = peersService
        self.readDataService = readDataService
    }
    
    func fetchNewPeers(completion: (() -> ())?)  {
        
      
    }
    
  
    func fetchedResultsController(completion: ((NSFetchedResultsController<User>) -> ())?) {
  
        let predicate = NSPredicate(format: "userId != %@", UIDevice.current.name)
        
        let fetchRequest = FetchRequestOptions.init(entityName: "User", sortKey: "name", predicate: predicate)
        
        readDataService.fetchedResultsController(with: fetchRequest) { (fetchedResultsController ) in
             completion!(fetchedResultsController)
        }
        
        
    }
}
