//
//  NetworkImagesAssembly.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 17.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import UIKit

class NetworkImagesAssembly {
    func networkImagesViewCotnroller() -> NetworkImagesViewController {
        let model = networkImagesModel()
        let networkImagesVC = NetworkImagesViewController.initNetworkImagesVC(with: model)
        model.delegate = networkImagesVC
        return networkImagesVC
    }
    
    // MARK: - PRIVATE SECTION
    
    private func networkImagesModel() -> INetworkImagesModel {
        return NetworkImagesModel(imagesService: imagesService())
    }
    
    private func imagesService() -> IImagesService {
        return ImagesService(requestSender: requestSender())
    }
    
    private func requestSender() -> IRequestSender {
        return RequestSender()
    }
    
}
