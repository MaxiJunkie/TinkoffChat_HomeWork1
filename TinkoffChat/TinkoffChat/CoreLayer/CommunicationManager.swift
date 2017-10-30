//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 21.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit


protocol CommunicationManagerProtocol: class {
    
    var onDataUpdate: ((_ data: [Message]) -> Void)? {get set}
    var messageUpdate: ((_ data: [Message]) -> Void)? {get set}
    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?)
    
}

class CommunicationManager:  CommunicatorDelegate , CommunicationManagerProtocol {
    
    var onlinePeers = [Message]() 
    
    private var communicator = MultipeerCommunicator()
    weak var delegateOfConversation: CommunicationManagerDelegate?
    
    var onDataUpdate: ((_ data: [Message]) -> Void)?
    var messageUpdate: ((_ data: [Message]) -> Void)? 
    
    init() {
        communicator.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String) {

        for user in onlinePeers {
            if user.userID == userID {
                return
            }
        }
        let message = Message.init(name: userName,
                                   messages: [],
                                   date: nil,
                                   online: true,
                                   hasUnreadMessages: false,
                                   imageOfUser:  UIImage(named: "mask3.png")! ,
                                   userID: userID ,
                                   lastMessage: nil)
   
      
        onlinePeers.append(message)
        onDataUpdate?(onlinePeers)
    }
    
   
    
    func didLostUser(userID: String) {
        var index : Int?
        for (i, user) in onlinePeers.enumerated() {
            if user.userID == userID {
                index = i
                break
            }
        }
        if let index = index {
            onlinePeers.remove(at: index)
            onDataUpdate?(onlinePeers)
        }
        
    }
    
    //error
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    func failedToStartAdvertising(error: Error) {
        
    }
    
    //messages
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
    
        for (index, user) in onlinePeers.enumerated() {
            if user.userID == fromUser {
                onlinePeers[index].messages?.append(text)
                onlinePeers[index].lastMessage = text
                onlinePeers[index].date = currentTime()
                onlinePeers.insert(onlinePeers[index], at: 0)
                onlinePeers.remove(at: index + 1)
                break
            }
        }
        onDataUpdate?(onlinePeers)
        messageUpdate?(onlinePeers)
  
    }

    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?) {
        communicator.sendMessage(string: text, toUserID: toUserID, completionHandler: {[weak self](success, error) in
            if success {
                for (index, user) in (self?.onlinePeers.enumerated())! {
                    if user.userID == toUserID {
                        self?.onlinePeers[index].messages?.append(text)
                        self?.onlinePeers[index].lastMessage = text
                        self?.onlinePeers[index].date = self?.currentTime()
                        self?.onlinePeers.insert((self?.onlinePeers[index])!, at: 0)
                        self?.onlinePeers.remove(at: index + 1)
                        break
                    }
                }
                self?.onDataUpdate?((self?.onlinePeers)!)
                completion!(success,nil)
            }
            else {
                completion!(false,error)
            }
        })
    }
    
 
    func currentTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date)
        if let year = components.year, let month = components.month , let day = components.day ,  let hour = components.hour, let minute = components.minute {
            return dateFormatter.date(from:  "\(day)-\(month)-\(year) \(hour):\(minute)")
        }
        else {
            return nil
        }
    }
    
}



