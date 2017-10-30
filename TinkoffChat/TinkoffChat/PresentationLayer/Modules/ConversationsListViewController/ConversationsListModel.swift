//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 28.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation

protocol CommunicationListModelProtocol: class {
    
    weak var delegate: CommunicationManagerDelegate? { get set }
    func fetchNewPeers()
    
}

protocol CommunicationManagerDelegate: class {
    func reloadData(with messages: [Message])
}


class ConversationsListModel: CommunicationListModelProtocol {
    
    weak var delegate: CommunicationManagerDelegate?
    
    let peersService: IPeersService
    
    init(peersService: IPeersService ) {
        self.peersService = peersService
    }
    
    func fetchNewPeers()  {
        peersService.loadNewPeers { (arrayOfPeers : [Message]) in
            
            let array = arrayOfPeers.sorted {
                if let date1 = $0.date,
                    let date2 = $1.date{
                    return date1 > date2
                } else {
                    return $0.name < $1.name
                }
            }
            self.delegate?.reloadData(with: array)
        }
    }
}
