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
    func updateCurrentUser(completionHandler: @escaping ((_ userId: String, _ userName: String?,_ isOnline: Bool) -> Void))
    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?)
    func fetchedResultsController(completion: ((NSFetchedResultsController<Messages>) -> ())?)
    var userId: String? {get set}
}

class ConversationModel : ConversationModelProtocol {
    
    let sendMessageService: ISendMessageService
    let peersService : IPeersService
    let readDataService: IReadDataService
    
    var userId :String?
    
    
    init(sendMessageService: ISendMessageService, readDataService: IReadDataService, peersService: IPeersService) {
        self.sendMessageService = sendMessageService
        self.readDataService = readDataService
        self.peersService = peersService
    }
    
    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?) {
       
        sendMessageService.sendMessage(text: text, toUserID: toUserID) { (success, error) in
            if success {
                    completion!(true,nil)
                } else
                {
                    completion!(false,error)
                }
            }
        }
    
    func updateCurrentUser(completionHandler: @escaping ((_ userId: String, _ userName: String?,_ isOnline: Bool) -> Void)) {
        
        peersService.loadNewPeers { (userId, userName, isOnline) in
            completionHandler(userId,userName,isOnline)
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


