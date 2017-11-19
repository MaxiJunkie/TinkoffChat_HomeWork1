//
//  Parser.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 17.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol IModel {
    associatedtype Model
}


class Parser<IModel> {
    func parse(data: Data) -> IModel? { return nil }
}



