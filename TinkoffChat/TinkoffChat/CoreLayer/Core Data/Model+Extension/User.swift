//
//  User.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 06.11.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension User {
 
    static func generateUserIdString() -> String {
        return UIDevice.current.name
    }
    
    static func generateCurrentUserNameString() -> String {
        return "m.stegnienko"
    }
    
    static func findOrInsertUser(with id: String, in context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userId = id
            return user
        }
        
        return nil
    }
    
    
}
