//
//  ConversationsTableViewCell.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 07.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

protocol ConversationsCellConfiguration : class {
    var name :String? {get set}
    var message :String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessages: Bool {get set}
}

class ConversationsTableViewCell: UITableViewCell , ConversationsCellConfiguration {

    @IBOutlet weak var textOfLastMessage: UILabel!
    @IBOutlet weak var timeOfLastMessage: UILabel!
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var imageOfUser: UIImageView!
    
    var name :String?
    var message :String?
    var date : Date?
    var online : Bool = true
    var hasUnreadMessages: Bool = true
 
    
    var messageOfHistory : Message? { didSet { updateUI()}}
    
    private func updateUI() {
      
        if let message = messageOfHistory {
       
        self.name = message.name
        self.message = message.lastMessage
        self.date = message.date
        self.online = message.online
        self.hasUnreadMessages = message.hasUnreadMessages
            
        nameOfUserLabel?.text = self.name
        imageOfUser?.layer.masksToBounds = true
        imageOfUser?.layer.cornerRadius = (imageOfUser?.bounds.size.height)!/2
        imageOfUser?.image = message.imageOfUser
        
        if self.message != nil {
            
            if self.hasUnreadMessages == true {
                textOfLastMessage?.font = UIFont.init(name: "Helvetica-Bold", size: 13)
            }
            else {
                textOfLastMessage?.font = UIFont.init(name: "Helvetica Neue", size: 13)
            }
            textOfLastMessage?.text = self.message
        } else {
            textOfLastMessage?.font = UIFont.init(name: "Helvetica-Bold", size: 15)
            textOfLastMessage?.text = "No messages yet"
        }
        
            if self.online  {
                self.backgroundColor = UIColor(red: 253/255, green: 255/255, blue: 217/255, alpha: 1.00)
            }
            else {
                self.backgroundColor = UIColor.white
            }
     
        if let newDate = self.date {
            let dateFormatter = DateFormatter()
                    if Date().timeIntervalSince(newDate) > 24*60*60 {
                        dateFormatter.dateFormat = "dd MMM"
                        let date = dateFormatter.string(from: newDate)
                        timeOfLastMessage?.text = date
                    }
                    else {
                        dateFormatter.dateFormat = "HH:mm"
                        let date = dateFormatter.string(from: newDate)
                        timeOfLastMessage?.text = date
                }
            }
        }
    }
}
