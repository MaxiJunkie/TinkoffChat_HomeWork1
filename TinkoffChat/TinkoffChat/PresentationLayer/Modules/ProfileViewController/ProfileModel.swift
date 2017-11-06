//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 30.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation



protocol ProfileModelProtocol: class {
    func readDataFromCoreData( completion: @escaping ((ProfileDataInterface) -> ()), errorBlock: ((NSError) -> ())?)
    func writeDataInCoreData(_ profile : ProfileDataInterface, completion: @escaping (() -> ()), errorBlock: ((NSError) -> ())?)
   
}

class ProfileModel : ProfileModelProtocol {

    let readDataService: IReadDataService
    let writeDataService: IWriteDataService
    
    var currentProfile = ProfileDataInterface(with: "", userInfo: "", image: nil)
    
    init(readDataService: IReadDataService, writeDataService: IWriteDataService ) {
        self.readDataService = readDataService
        self.writeDataService = writeDataService
    }
    
    func readDataFromCoreData(completion: @escaping ((ProfileDataInterface) -> ()), errorBlock: ((NSError) -> ())?) {
      
        readDataService.readData(completionHandler: { (profile) in
            self.currentProfile = profile
            completion(profile)
        }, errorBlock: nil)
        
    }
    
    func writeDataInCoreData( _ profile: ProfileDataInterface, completion: @escaping (() -> ()), errorBlock: ((NSError) -> ())?) {
     
        if currentProfile.name != profile.name {
            profile.nameIsChanged = true
        }
        if currentProfile.userInfo != profile.userInfo {
             profile.userInfoIsChanged = true
        }
        if let isEqual = currentProfile.photoImage?.isEqual(profile.photoImage) {
            if !isEqual {
                profile.photoImageIsChanged = true
            }
        }
        
        writeDataService.writeData(profile) {
            completion()
        }
        
    }
    
    
}
