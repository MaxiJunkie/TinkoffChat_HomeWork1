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
        return ReadDataService(GCDDataManager: GCDReadDataFileManager(), operationDataManager: operationDataManager())
    }
    private func writeDataService() -> IWriteDataService {
        return WriteDataService(GCDDataManager: GCDWriteDataFileManager(),createQueue: createQueue())
    }
    
    private func GCDReadDataFileManager() -> ReadDataProtocol {
        return GCDDataManager()
    }
    
    private func GCDWriteDataFileManager() -> WriteDataProtocol {
        return GCDDataManager()
    }
    
    private func operationDataManager() -> ReadDataProtocol {
        return OperationDataManager()
    }
    
    private func createQueue() -> CreateQueueProtocol {
        return CreateQueue()
    }
    
    
    
    
}
