//
//  ProfileAssembly.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 30.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation


class ProfileAssembly {
    
    func profileViewController() -> ProfileViewController {
        
        let model = profileModel()
        let ProfileVC = ProfileViewController.initProfileVC(with: model)
        return ProfileVC
        
    }
    
    // MARK: - PRIVATE SECTION
    
    private func profileModel() -> ProfileModelProtocol {
        return ProfileModel(readDataService: readDataService(), writeDataService: writeDataService())
    }
    
    private func readDataService() -> IReadDataService {
        return ReadDataService(dataManager: readDataManager())
    }
    private func writeDataService() -> IWriteDataService {
        return WriteDataService(dataManager: writeDataFileManager())
    }
    
    private func readDataManager() -> ReadDataProtocol {
        return StorageManager()
    }
    
    private func writeDataFileManager() -> WriteDataProtocol {
        return StorageManager()
    }

    
    
    
}
