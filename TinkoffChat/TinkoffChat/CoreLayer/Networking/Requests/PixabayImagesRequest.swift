//
//  PixabayImagesRequest.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 18.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

class PixabayImagesRequest : IRequest {
    
    private let baseUrl: String = "https://pixabay.com/api/"
    
    private let key: String = "?key=7087566-3e3d24d3cf5eda5063c44c063"
    
    private let searchTerm: String = "&q=yellow+flowers"
    
    private let imageType: String = "&image_type=photo"
   
    private var perPage : Int
    
    private var perPageString: String {
       return "&per_page=\(perPage)"
    }
    
    private let pretty: String = "&pretty=true"
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        let urlString: String = baseUrl + key + searchTerm + imageType + perPageString + pretty
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    // MARK: - Initialization
    
    init(perPage: Int = 150) {
        self.perPage = perPage
    }
    
    
}
