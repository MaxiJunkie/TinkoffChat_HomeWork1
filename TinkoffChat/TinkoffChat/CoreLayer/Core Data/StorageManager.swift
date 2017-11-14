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
    func fetchedResultsControllerOfUsers(completion: ((NSFetchedResultsController<User>) -> ())?)
    func fetchedResultsControllerOfConversation(with conversationId: String , completion: ((NSFetchedResultsController<Messages>) -> ())?)
}

protocol WriteDataProtocol : class {
   func updateProfileData(profile : ProfileDataInterface, completion: (() -> ())?)
   func writeNewUsersInStorage(users: [Conversations], completion: (() -> ())?)
   func writeConversationInStorage(with userId: String , message: Message ,completion: (() -> ())?)
}

class StorageManager: ReadDataProtocol, WriteDataProtocol {
  
    private let coreDataStack = CoreDataStack()

    static let saveContextForConversations = CoreDataStack().saveContext
    static let saveContextForConversation = CoreDataStack().saveContext
    
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
        
        saveContext.perform {
            self.coreDataStack.performSave(context: saveContext) {
                DispatchQueue.main.async {
                    completion!()
                }
            }
        }
        
    }
    
    
    
     // MARK: Users
    
    func writeNewUsersInStorage(users: [Conversations], completion: (() -> ())?) {
       
   
        guard let saveContext = StorageManager.saveContextForConversations else {
            print("No context")
            return
        }
      
        let setOfUsers :NSSet? = []
    
        for user in users {
      
            guard let userId = user.userID else { return }
           
            let conversationId = "conversationOf\(userId)"
            
            if let newUser = User.findOrInsertUser(with: userId, in: saveContext) {
               
                if user.online == false {
                    User.remove(user: newUser, in: saveContext)
                    let messages = Messages.findMessages(withConversationId: conversationId, in: saveContext)
                    Messages.remove(messages: messages, in: saveContext)
                    
                } else {
                
                newUser.name = user.name
                newUser.isOnline = user.online
                
                if let photo = user.imageOfUser {
                  newUser.photo =  UIImagePNGRepresentation(photo)
            
                }
                
                if let conversation = Conversation.findOrInsertConversation(with: conversationId, in: saveContext) {
               
                    conversation.isOnline = user.online
                    
                    var messages = Messages.findMessages(withConversationId: conversationId, in: saveContext)
            
                    if let lastMessage = Messages.insertMessages(with: user.lastMessage , in: saveContext) {
                        
                        lastMessage.date = user.date
                        lastMessage.messageFromMe = false
                      
                        messages.append(lastMessage)
                        
                        conversation.lastMessage = lastMessage
    
                    }
                    newUser.typingOfConversation = conversation
                }
                    setOfUsers?.adding(newUser)
                }
            }
        }
       
      
        guard let appUser = AppUser.findOrInsertAppUser(in: saveContext) else {
            return
        }
        
        appUser.users = setOfUsers
    
        saveContext.perform {
            self.coreDataStack.performSave(context: saveContext) {
                DispatchQueue.main.async {
                    completion!()
                }
            }
        }
    }
    
    
    func fetchedResultsControllerOfUsers(completion: ((NSFetchedResultsController<User>) -> ())?) {
    
        
        guard let saveContext = StorageManager.saveContextForConversations else {
            print("No context")
            return
        }
        
        saveContext.perform {
       
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
            let sortByName = NSSortDescriptor(key: "name", ascending: false)
            
            
            fetchRequest.sortDescriptors = [sortByName]
            fetchRequest.fetchBatchSize = 20
            
            let predicate = NSPredicate(format: "userId != %@",UIDevice.current.name)
            
            fetchRequest.predicate = predicate
            
            let fetchedResultsController = NSFetchedResultsController<User>(fetchRequest:
                fetchRequest, managedObjectContext: saveContext, sectionNameKeyPath: nil,
                              cacheName: nil)
            
            DispatchQueue.main.async {
                completion!(fetchedResultsController)
            }
        }
    }
    
    
    
    // MARK: Conversation
    
    func writeConversationInStorage(with userId: String , message: Message ,completion: (() -> ())?) {
        
        guard let saveContext = StorageManager.saveContextForConversation else {
            print("No context")
            return
        }
        
        let conversationId = "conversationOf\(userId)"
        
        if let conversation = Conversation.findOrInsertConversation(with: conversationId, in: saveContext) {
      
            var messages = Messages.findMessages(withConversationId: conversation.conversationId!, in: saveContext)
          
            if let newMessage = Messages.insertMessages(with: message.text, in: saveContext) {
               
                if message.typeOfMessage == .incoming {
                   newMessage.messageFromMe = false
                } else {
                   newMessage.messageFromMe = true
                }
                
                newMessage.date = message.date
                messages.append(newMessage)
                conversation.lastMessage = newMessage
                
            }
            
            let setOfMessages :NSSet? = NSSet.init(array: messages)
            conversation.messages = setOfMessages
          
        }
        
        
        saveContext.perform {
            self.coreDataStack.performSave(context: saveContext) {
                DispatchQueue.main.async {
                    completion!()
                }
            }
        }
    }
    
    
    func fetchedResultsControllerOfConversation(with conversationId: String , completion: ((NSFetchedResultsController<Messages>) -> ())?) {
        
        guard let saveContext = StorageManager.saveContextForConversation else {
            print("No context")
            return
        }
 
        saveContext.perform {
            
            let fetchRequest = NSFetchRequest<Messages>(entityName: "Messages")
            
            let sortByDate = NSSortDescriptor(key: "date", ascending: false)
            
            fetchRequest.sortDescriptors = [sortByDate]
            fetchRequest.fetchBatchSize = 20
            
            let predicate = NSPredicate(format: "conversation.conversationId == %@","conversationOf\(conversationId)")
            
            fetchRequest.predicate = predicate
            
            let fetchedResultsController = NSFetchedResultsController<Messages>(fetchRequest:
                fetchRequest, managedObjectContext: saveContext, sectionNameKeyPath: nil,
                              cacheName: nil)
            
            DispatchQueue.main.async {
                completion!(fetchedResultsController)
            }
        }
    }
    
    
}

