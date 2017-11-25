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
    @IBOutlet weak var outboandView: UIView!
    @IBOutlet weak var incomingView: UIView!
    
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
            self.selectionStyle = .none
            self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            if self.reuseIdentifier == "outboundCell" {
                outboandView.layer.masksToBounds = true
                outboandView.layer.cornerRadius = 2
                outboundLabel.text = newValue
            }
            else {
                incomingView.layer.masksToBounds = true
                incomingView.layer.cornerRadius = 2
                incomingLabel.text = newValue
            }
        }
    }
    

}


