//
//  IRequestManager.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 17.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

struct RequestConfig<Model>  {
    let request: IRequest
    let parser: Parser<Model>
}

enum Result<T> {
    case Success(T)
    case Fail(String)
}

protocol IRequestSender {
    func send<Model>(config: RequestConfig<Model>, completionHandler: @escaping (Result<Model>) -> Void)
}

