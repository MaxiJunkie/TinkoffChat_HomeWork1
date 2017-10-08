//
//  ChatTableViewCell.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 07.10.17.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit
import Foundation

protocol MessageCellConfiguration :class {
    var textOfMessage: String? {get set}
}

class ChatTableViewCell:  UITableViewCell, MessageCellConfiguration    {

    @IBOutlet weak var outboundLabel: UILabel!
    @IBOutlet weak var incomingLabel: UILabel!
   
    var textOfMessage: String? {
        get {
            if self.reuseIdentifier == "outboundCell" {
                return outboundLabel.text
            }
            else {
                return incomingLabel.text
            }
        }
        set {
            if self.reuseIdentifier == "outboundCell" {
                outboundLabel.text = newValue
            }
            else {
                incomingLabel.text = newValue
            }
        }
    }
    

}


