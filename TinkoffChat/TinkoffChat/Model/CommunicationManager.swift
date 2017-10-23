//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 21.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

class CommunicationManager: CommunicatorDelegate {
    
    var onlinePeers = [Message]()
    var currentPeer: Message?
    
    var text : String = ""
    
    private var communicator = MultipeerCommunicator()
    
    weak var delegateOfConversations: CommunicationManagerDelegate?
    weak var delegateOfConversation: CommunicationManagerDelegate?
    
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
                                   message: nil,
                                   date: nil,
                                   online: true,
                                   hasUnreadMessages: false,
                                   imageOfUser:  UIImage(named: "mask1.png")! ,
                                   userID: userID)
   
      
        onlinePeers.append(message)
        
        onlinePeers = onlinePeers.sorted {
            if let date1 = $0.date,
            let date2 = $1.date{
            return date1 > date2
        } else {
            return ($0.name)! < ($1.name)!
            }
            
        }
        
        self.delegateOfConversations?.reloadData()

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
            self.delegateOfConversations?.reloadData()
            self.delegateOfConversation?.reloadData()
        }
        
    }
    
    //error
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    func failedToStartAdvertising(error: Error) {
        
    }
    
    //messages
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        self.text = text
        for (index, user) in onlinePeers.enumerated() {
            if user.userID == fromUser {
                onlinePeers[index].message = text
                onlinePeers[index].date = currentTime()
                onlinePeers.insert(onlinePeers[index], at: 0)
                onlinePeers.remove(at: index + 1)
                break
            }
        }
        
            
        self.delegateOfConversations?.reloadData()
        self.delegateOfConversation?.reloadData()
        
    }

    func sendMessage(text: String, toUserID: String, completion: ((Bool,Error?) -> ())?) {
        communicator.sendMessage(string: text, toUserID: toUserID, completionHandler: {[weak self](success, error) in
            if success {
                for (index, user) in (self?.onlinePeers.enumerated())! {
                    if user.userID == toUserID {
                        self?.onlinePeers[index].message = text
                        self?.onlinePeers[index].date = self?.currentTime()
                        self?.onlinePeers.insert((self?.onlinePeers[index])!, at: 0)
                        self?.onlinePeers.remove(at: index + 1)
                        self?.delegateOfConversations?.reloadData()
                        break
                    }
                }
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



