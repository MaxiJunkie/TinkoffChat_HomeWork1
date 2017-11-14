//
//  ReadDataService.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 30.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import CoreData

protocol IReadDataService {
    func readData(completionHandler: @escaping ((ProfileDataInterface) -> ()), errorBlock: ((NSError) -> ())?)
    func fetchedResultsController(completion: ((NSFetchedResultsController<User>) -> ())?)
    func fetchedResultsController(with id: String, completion: ((NSFetchedResultsController<Messages>) -> ())?)
}

class ReadDataService : IReadDataService {
    
    let dataManager: ReadDataProtocol

    init(dataManager: ReadDataProtocol) {
        self.dataManager = dataManager
  
    }
    
    func readData(completionHandler: @escaping ((ProfileDataInterface) -> ()), errorBlock: ((NSError) -> ())?) {
  
        dataManager.fetchProfileData { (profile) in
            completionHandler(profile)
        }
        
    }
    
    func fetchedResultsController(completion: ((NSFetchedResultsController<User>) -> ())?) {
        
        dataManager.fetchedResultsControllerOfUsers { (frc) in
            completion!(frc)
        }
        
    }
    
    func fetchedResultsController(with id: String, completion: ((NSFetchedResultsController<Messages>) -> ())?) {
        dataManager.fetchedResultsControllerOfConversation(with: id) { (frc) in
            completion!(frc)
        }
    }
    
}
