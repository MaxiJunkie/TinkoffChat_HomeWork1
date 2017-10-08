//
//  Message.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 07.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import UIKit

public struct Message  {
    
    var name :String?
    var message :String?
    var date : Date?
    var online : Bool
    var hasUnreadMessages: Bool
    let imageOfUser: UIImage
    
    static  public var messages : [Message] = customDatas()
    static private func customDatas () -> [Message] {
        
        var messages = [Message]()
        
        for _ in 1...5 {
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            
            let message = Message.init(name: "Anna Furrow",
                                       message: "You're one of Peter's compression plays, huh? Uhh, one of? How many does he have…",
                                       date: dateFormatter.date(from:  "7-10-2017 15:22"),
                                       online: true,
                                       hasUnreadMessages: true,
                                       imageOfUser:  UIImage(named: "mask1.png")!)
            
            let message1 = Message.init(name: "Jane Nyland",
                                       message: "Both of them.",
                                       date: dateFormatter.date(from:  "24-12-2015 23:59"),
                                       online: false,
                                       hasUnreadMessages: false,
                                       imageOfUser:  UIImage(named: "mask2.png")!)
          
            let message2 = Message.init(name: "Bob Janzen",
                                        message: "hy are there so many? You know how sea turtles have a shit-ton of babies because m…",
                                        date: dateFormatter.date(from:  "6-10-2017 22:22"),
                                        online: true,
                                        hasUnreadMessages: false,
                                        imageOfUser:  UIImage(named: "mask3.png")!)
            
            let message3 = Message.init(name: "Carole Ahlers",
                                        message: "I think it's because the pixels change value differently than conventional Just look at th…",
                                        date: dateFormatter.date(from:  "5-10-2017 21:22"),
                                        online: false,
                                        hasUnreadMessages: true,
                                        imageOfUser:  UIImage(named: "mask4.png")!)
            
            let message4 = Message.init(name: "Erica Wolfram",
                                        message: nil,
                                        date: dateFormatter.date(from:  "7-10-2017 12:22"),
                                        online: false,
                                        hasUnreadMessages: false,
                                        imageOfUser:  UIImage(named: "mask5.png")!)
        
            let message5 = Message.init(name: "Dan Stinger",
                                        message: nil,
                                        date: dateFormatter.date(from:  "6-10-2017 14:22"),
                                        online: true,
                                        hasUnreadMessages: true,
                                        imageOfUser:  UIImage(named: "mask6.png")!)
      
            
            messages.append(message)
            messages.append(message1)
            messages.append(message2)
            messages.append(message3)
            messages.append(message4)
            messages.append(message5)
            
        }
        return messages
    }
   
}






