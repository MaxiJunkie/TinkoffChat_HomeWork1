//
//  NetworkImagesModel.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 17.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation


protocol INetworkImagesModel: class {
    weak var delegate: INetworkImagesModelDelegate? { get set }
    func fetchImage(with url: String , completionHandler: @escaping (ImageModel?, String?) -> Void)
    func fetchNewImages()
}


protocol INetworkImagesModelDelegate: class {
    func setup(imagesModel: [ImagesModel])
}


class NetworkImagesModel: INetworkImagesModel {
    
    weak var delegate: INetworkImagesModelDelegate?
    
    let imagesService: IImagesService

    init(imagesService: IImagesService) {
        self.imagesService = imagesService
    }
    
    func fetchNewImages() {
        
        imagesService.loadNewImages { (imagesModel, error) in
            
            assert(error == nil, "Error of request")
            if let images = imagesModel {
                self.delegate?.setup(imagesModel: images )
            }
        }
    }
    
    func fetchImage(with url: String , completionHandler: @escaping (ImageModel?, String?) -> Void) {
        
        imagesService.loadNewImage(with: url) { (imageModel, error) in
            if let model = imageModel {
                completionHandler(model,nil)
            }
        }
        
    }
    
    
}
