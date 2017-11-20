//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 05.11.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol ReadDataProtocol : class {
    func fetchProfileData(completion: ((ProfileDataInterface) -> ())?)
    func fetchedResultsController<Type>(with fetchRequestOptions: FetchRequestOptions, completion: ((NSFetchedResultsController<Type>) -> ())?)
}

protocol WriteDataProtocol : class {
   func updateProfileData(profile : ProfileDataInterface, completion: (() -> ())?)
}


struct FetchRequestOptions {
    
    let entityName: String
    let sortKey: String
    let predicate: NSPredicate
    
}


class StorageManager: ReadDataProtocol, WriteDataProtocol {
  
    private let coreDataStack = CoreDataStack()
    
    static let saveContext = CoreDataStack().saveContext

    //MARK: Profile
    
    func fetchProfileData(completion: ((ProfileDataInterface) -> ())?) {
       
        guard let saveContext = self.coreDataStack.saveContext else {
            print("No context")
            return
        }
        
        saveContext.perform {
            
            guard let appUser = AppUser.findOrInsertAppUser(in: saveContext) else {
                return
            }
            guard let user = appUser.currentUser else {
                return
            }
            
            var image = UIImage.init(named: "placeholder-user")
            if let data = user.photo  {
                image = UIImage.init(data:data)
            }
            
            let profileData = ProfileDataInterface(with: user.name, userInfo: user.userInfo, image: image)
            DispatchQueue.main.async {
                completion!(profileData)
            }
        }

    }
    
    
    func updateProfileData(profile : ProfileDataInterface, completion: (() -> ())?) {
        

        guard let saveContext = self.coreDataStack.saveContext else {
            print("No context")
            return
        }
        
 
        saveContext.perform {
            guard let appUser = AppUser.findOrInsertAppUser(in: saveContext) else {
                return
            }
            guard let user = appUser.currentUser else {
                return
            }
        
            if let name = profile.name {
                if profile.nameIsChanged {
                    user.name = name
                }
            }
            if let userDescription = profile.userInfo {
                if profile.userInfoIsChanged {
                    user.userInfo = userDescription
                }
            }
        
            if let image = profile.photoImage {
                if profile.photoImageIsChanged {
                    if let photoData = UIImagePNGRepresentation(image) {
                        user.photo = photoData
                    }
                }
            }
        
       
            self.coreDataStack.performSave(context: saveContext) {
                DispatchQueue.main.async {
                    completion!()
                }
            }
        }
        
    }
    
    
    
     // MARK: Users
    
    
    func updateUser(userId: String, userName: String?, isOnline: Bool, completion: (() -> ())?) {
        
        guard let saveContext = StorageManager.saveContext else {
            print("No context")
            return
        }
        
        saveContext.perform {
            
            if let newUser = User.findOrInsertUser(with: userId, in: saveContext) {
                newUser.name = userName
                newUser.isOnline = isOnline
                if let photo = UIImage(named: "mask3.png") {
                    newUser.photo =  UIImagePNGRepresentation(photo)
                }
            }
            self.coreDataStack.performSave(context: saveContext, completionHandler: nil)
        
        }
        
        
    }
    
    //MARK: Messages
    
    
    func insertMessage(forUserId: String, message: Message , completionHandler:(() -> ())?) {
        
        guard let saveContext = StorageManager.saveContext else {
            print("No context")
            return
        }
        
        saveContext.perform {
            
            guard let user = User.findOrInsertUser(with: forUserId, in: saveContext) else {return}
            let conversationId = "conversationIdOf\(forUserId)"
            if let conversation = Conversation.findOrInsertConversation(with: conversationId, in: saveContext) {
                var messages = Messages.findMessages(withConversationId: conversationId, in: saveContext)
                if let newMessage = self.insert(message: message, in: saveContext) {
                    messages.append(newMessage)
                    conversation.lastMessage = newMessage
                }
                let setOfMessages :NSSet? = NSSet.init(array: messages)
                conversation.messages = setOfMessages
                user.typingOfConversation = conversation
            }
            
            self.coreDataStack.performSave(context: saveContext, completionHandler: nil)
        }
    }
    
    
    
    private func insert(message: Message, in context: NSManagedObjectContext) -> Messages? {
        guard let newMessage = Messages.insertMessages(with: message.text, in: context) else {return nil}
        newMessage.messageFromMe = message.messageFromMe
        newMessage.date = message.date
        return newMessage
    }
    
    
    
    // MARK: FetchedResultsControllers
    
   
    
    func fetchedResultsController<Type>(with fetchRequestOptions: FetchRequestOptions, completion: ((NSFetchedResultsController<Type>) -> ())?) {
        
        guard let saveContext = StorageManager.saveContext else {
            print("No context")
            return
        }
        
        saveContext.perform {
            
            let fetchRequest = NSFetchRequest<Type>(entityName: fetchRequestOptions.entityName)
            let sortByName = NSSortDescriptor(key: "\(fetchRequestOptions.sortKey)", ascending: false)
            fetchRequest.sortDescriptors = [sortByName]
            fetchRequest.fetchBatchSize = 20
            fetchRequest.predicate = fetchRequestOptions.predicate
            
            let fetchedResultsController = NSFetchedResultsController<Type>(fetchRequest:
                fetchRequest, managedObjectContext: saveContext, sectionNameKeyPath: nil,
                              cacheName: nil)
            
            DispatchQueue.main.async {
                completion!(fetchedResultsController)
            }
            
        }
    
    }
    

}

