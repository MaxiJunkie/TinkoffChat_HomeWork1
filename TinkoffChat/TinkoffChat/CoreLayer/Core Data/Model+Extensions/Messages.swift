//
//  Messages.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 11.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import CoreData

extension Messages {
    
    static func insertMessages(with text: String?, in context: NSManagedObjectContext) -> Messages? {
        if let messages = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: context) as? Messages {
            messages.textOfMessage = text
            return messages
        }
        return nil
    }
    
    static func fetchRequestMessages(with id: String,  model: NSManagedObjectModel) -> NSFetchRequest<Messages>? {
        
        let templateName = "MessagesFromConversationId"
        let dictionary = ["conversationId": id]
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: dictionary) as? NSFetchRequest<Messages> else {
            assert(false, "No template with name: \(templateName)")
            return nil
        }
        return fetchRequest
    }
    
    
    static func remove(messages: [Messages] , in context: NSManagedObjectContext) {
        
        for message in messages {
            context.delete(message)
        }
        
    }
    
    static func findMessages(withConversationId id: String, in context: NSManagedObjectContext) -> [Messages] {
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            assertionFailure("Model is not available in context!")
            return []
        }
        var messages: [Messages] = []
        guard let fetchRequest = Messages.fetchRequestMessages(with: id, model: model) else {
            return []
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            messages = results
            
        } catch {
            print("Failed to fetch user: \(error)")
        }
        return messages
    }
    
}
