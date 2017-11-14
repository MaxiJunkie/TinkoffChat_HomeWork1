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
    func fetchNewMessages()
    var userId: String? {get set}
}

class ConversationModel : ConversationModelProtocol {
    
    let sendMessageService: ISendMessageService
    let fetchMessagesService: IFetchMessagesService
    let writeDataService: IWriteDataService
    let readDataService: IReadDataService
    
    var userId :String?
    
    
    init(sendMessageService: ISendMessageService,fetchMessagesService: IFetchMessagesService, writeDataService: IWriteDataService, readDataService: IReadDataService) {
        self.sendMessageService = sendMessageService
        self.fetchMessagesService = fetchMessagesService
        self.writeDataService = writeDataService
        self.readDataService = readDataService
    }
    
    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?) {
       
        sendMessageService.sendMessage(text: text, toUserID: toUserID) { (success, error) in
                if success {
                    let message = Message.init(withCurrentTimeAndText: text, typeOfMessage: .outcoming)
                    self.writeDataService.writeMessageData(with: toUserID, message: message, completion: {
                      
                        completion!(true,nil)
                    })
                }else {
                    completion!(false,error)
                }
            }
        }
    
    
    
    func fetchNewMessages() {
        fetchMessagesService.loadNewMessages { (arrayOfPeers : [Conversations]) in
     
            for user in arrayOfPeers {
                if user.userID == self.userId {
                     if let lastMessage =  user.messages?.last {
                        
                            let message = Message.init(withCurrentTimeAndText: lastMessage, typeOfMessage: .incoming)
                        
                            guard let userID = self.userId else {return}
                            self.writeDataService.writeMessageData(with: userID, message: message, completion: {
                           
                        })
                    }
                }
            }
        }
    }
    
    
    func fetchedResultsController(completion: ((NSFetchedResultsController<Messages>) -> ())?) {
        
        guard let userID = self.userId else {return }
      
        readDataService.fetchedResultsController(with: userID) { (frc) in
            completion!(frc)
        }
        
    }
    
    
    
    
}


