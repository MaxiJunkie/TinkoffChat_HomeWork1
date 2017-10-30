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
    
    var name :String
    var messages :[String]?
    var date : Date?
    var online : Bool
    var hasUnreadMessages: Bool
    let imageOfUser: UIImage
    var userID:  String?
    var lastMessage :String?
}






