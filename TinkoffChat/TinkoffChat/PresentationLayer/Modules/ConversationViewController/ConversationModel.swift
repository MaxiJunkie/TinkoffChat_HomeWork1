//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 29.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol ConversationModelProtocol: class {
    
    weak var delegate: CommunicationManagerDelegate? { get set }
    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?)
    func fetchNewMessages()
}

class ConversationModel : ConversationModelProtocol {
    
    let sendMessageService: ISendMessageService
    let fetchMessagesService: IFetchMessagesService
    
    weak var delegate: CommunicationManagerDelegate?
    
    init(sendMessageService: ISendMessageService,fetchMessagesService: IFetchMessagesService ) {
        self.sendMessageService = sendMessageService
        self.fetchMessagesService = fetchMessagesService
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
    
    func fetchNewMessages() {
        fetchMessagesService.loadNewMessages { (arrayOfPeers : [Message]) in
               self.delegate?.reloadData(with: arrayOfPeers)
        }
    }
    
}


