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
    let writeDataService: IWriteDataService
    let readDataService: IReadDataService
    
    init(peersService: IPeersService , writeDataService: IWriteDataService, readDataService: IReadDataService) {
        self.peersService = peersService
        self.writeDataService = writeDataService
        self.readDataService = readDataService
    }
    
    func fetchNewPeers(completion: (() -> ())?)  {
        
        peersService.loadNewPeers { (arrayOfPeers : [Conversations]) in
            
            let array = arrayOfPeers.sorted {
                if let date1 = $0.date,
                    let date2 = $1.date{
                    return date1 > date2
                } else {
                    return $0.name < $1.name
                }
            }
            self.writeNewPeersInCoreData(with: array, completion: {
             
                completion!()
            })
        }
        
        
    }
    
    private func writeNewPeersInCoreData(with peers: [Conversations], completion: (() -> ())?) {
        
        writeDataService.writeData(with: peers) {
            completion!()
        }
    }
    
    func fetchedResultsController(completion: ((NSFetchedResultsController<User>) -> ())?) {
        readDataService.fetchedResultsController { (frc) in
            completion!(frc)
        }
        
    }

}
