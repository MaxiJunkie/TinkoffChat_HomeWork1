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
 
    static func generateCurrentUserIdString() -> String {
        return UIDevice.current.name
    }
    
    static func generateCurrentUserNameString() -> String {
        return "m.stegnienko"
    }
    
    static func insertUser(with id: String, in context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userId = id
            return user
        }
        
        return nil
    }
    
    static func remove(user : User, in context: NSManagedObjectContext) {
       
        user.appUser = nil
        user.conversations = nil
        user.typingOfConversation?.messages = nil
        user.typingOfConversation = nil
        user.currentAppUser = nil
        context.delete(user)
        
    }
    
    static func fetchRequestUser(with id: String,  model: NSManagedObjectModel) -> NSFetchRequest<User>? {
      
        let templateName = "UserWithId"
        let dictionary = ["userId": id]
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: dictionary) as? NSFetchRequest<User> else {
            assert(false, "No template with name: \(templateName)")
            return nil
        }
        return fetchRequest
    }
    
    
    static func findOrInsertUser(with id: String, in context: NSManagedObjectContext) -> User? {
     
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            assertionFailure("Model is not available in context!")
            return nil
        }
        var user: User?
        guard let fetchRequest = User.fetchRequestUser(with: id, model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple users found!")
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
        
        if user == nil {
            user = User.insertUser(with: id, in: context)
            
        }
        return user
    }
    
    
}
