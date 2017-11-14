//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 11.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {
    
    static func insertConversation(with id: String, in context: NSManagedObjectContext) -> Conversation? {
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation {
            conversation.conversationId = id
            return conversation
        }
        
        return nil
    }
    
    static func fetchRequestConversation(with id: String,  model: NSManagedObjectModel) -> NSFetchRequest<Conversation>? {
        
        let templateName = "Conversation"
        let dictionary = ["conversationId": id]
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: dictionary) as? NSFetchRequest<Conversation> else {
            assert(false, "No template with name: \(templateName)")
            return nil
        }
        return fetchRequest
    }
    
    
    static func findOrInsertConversation(with id: String, in context: NSManagedObjectContext) -> Conversation? {
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            assertionFailure("Model is not available in context!")
            return nil
        }
        var conversation: Conversation?
        guard let fetchRequest = Conversation.fetchRequestConversation(with: id, model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple users found!")
            if let foundConversation = results.first {
                conversation = foundConversation
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
        
        if conversation == nil {
            conversation = Conversation.insertConversation(with: id, in: context)
        }
        return conversation
    }
    
    
}
