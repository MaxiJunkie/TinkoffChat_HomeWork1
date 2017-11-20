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
    func fetchedResultsController<Type>(with fetchRequestOptions: FetchRequestOptions, completion: ((NSFetchedResultsController<Type>) -> ())?)
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
    
    
    func fetchedResultsController<Type>(with fetchRequestOptions: FetchRequestOptions, completion: ((NSFetchedResultsController<Type>) -> ())?)  {
        
        dataManager.fetchedResultsController(with: fetchRequestOptions) { (fetchedResultsController) in
            completion!(fetchedResultsController)
        }
    }
    
    
    
}
