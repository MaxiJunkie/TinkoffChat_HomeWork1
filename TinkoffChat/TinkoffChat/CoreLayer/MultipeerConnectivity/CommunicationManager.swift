//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 21.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit


protocol CommunicationManagerProtocol: class {
    
    var onDataUpdate: ((_ data: [Conversations]) -> Void)? {get set}
    var messageUpdate: ((_ data: [Conversations]) -> Void)? {get set}
    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?)
    
}

class CommunicationManager:  CommunicatorDelegate , CommunicationManagerProtocol {
    
    var onlinePeers = [Conversations]() 
    
    private var communicator = MultipeerCommunicator()
    
    private var storageManager = StorageManager()
    
    
    var onDataUpdate: ((_ data: [Conversations]) -> Void)?
    var messageUpdate: ((_ data: [Conversations]) -> Void)?
    
    init() {
        communicator.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String) {
        storageManager.updateUser(userId: userID, userName: userName, isOnline: true, completion: nil)
    }
    
   
    
    func didLostUser(userID: String) {
        storageManager.updateUser(userId: userID, userName: nil, isOnline: false, completion: nil)
    }
    
    //error
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    func failedToStartAdvertising(error: Error) {
        
    }
    
    //messages
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {

        let message = Message.init(withCurrentTimeAndText: text, messageFromMe: false)
        storageManager.insertMessage(forUserId: fromUser, message: message ) {
            
        }
  
    }

    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?) {
        communicator.sendMessage(string: text, toUserID: toUserID, completionHandler: {[weak self](success, error) in
            if success {

                let message = Message.init(withCurrentTimeAndText: text, messageFromMe: true)
                self?.storageManager.insertMessage(forUserId: toUserID, message: message ) {
                    
                }
                completion!(success,nil)
            }
            else {
                completion!(false,error)
            }
        })
    }

    
}



