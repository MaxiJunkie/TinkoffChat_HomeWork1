//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 29.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationModelProtocol: class {
    
  
    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?)
    func fetchedResultsController(completion: ((NSFetchedResultsController<Messages>) -> ())?)
    var userId: String? {get set}
}

class ConversationModel : ConversationModelProtocol {
    
    let sendMessageService: ISendMessageService
 
    let readDataService: IReadDataService
    
    var userId :String?
    
    
    init(sendMessageService: ISendMessageService, readDataService: IReadDataService) {
        self.sendMessageService = sendMessageService
        self.readDataService = readDataService
    }
    
    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?) {
       
        sendMessageService.sendMessage(text: text, toUserID: toUserID) { (success, error) in
            
            if success {
                    completion!(true,nil)
                }else {
                    completion!(false,error)
                }
            }
        }
    
    
    func fetchedResultsController(completion: ((NSFetchedResultsController<Messages>) -> ())?) {
        
        guard let userID = self.userId else {return }
      
        
        let predicate = NSPredicate(format: "conversation.conversationId == %@","conversationIdOf\(userID)")
        
        let fetchRequest = FetchRequestOptions.init(entityName: "Messages", sortKey: "date", predicate: predicate)
        
        readDataService.fetchedResultsController(with: fetchRequest) { (fetchedResultsController) in
             completion!(fetchedResultsController)
        }
        
        
    }
    
    
    
    
}


