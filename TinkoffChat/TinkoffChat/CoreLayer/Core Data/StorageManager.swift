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
}

protocol WriteDataProtocol : class {
   func updateProfileData(profile : ProfileDataInterface, completion: (() -> ())?)
}

class StorageManager: ReadDataProtocol, WriteDataProtocol {
  
    private let coreDataStack = CoreDataStack()
    
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
    
}

