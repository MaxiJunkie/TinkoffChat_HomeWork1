//
//  Message.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 14.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

enum TypeOfMessage {
    case incoming
    case outcoming
}

class Message {
    let text : String
    var date : Date
    let typeOfMessage: TypeOfMessage
    
    init(text: String, date: Date, typeOfMessage: TypeOfMessage) {
        self.text = text
        self.date = date
        self.typeOfMessage = typeOfMessage
    }

    init(withCurrentTimeAndText text: String,typeOfMessage: TypeOfMessage) {
        self.text = text
        self.typeOfMessage = typeOfMessage
        self.date = Date.init()
        if let currentTime = currentTime() {
            self.date = currentTime
        }
    }
    
    private   func currentTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date as Date)
        if let year = components.year, let month = components.month , let day = components.day ,  let hour = components.hour, let minute = components.minute, let second = components.second {
            return dateFormatter.date(from:  "\(day)-\(month)-\(year) \(hour):\(minute):\(second)")
        }
        else {
            return nil
        }
    }
    
}


