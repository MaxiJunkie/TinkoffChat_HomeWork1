//
//  ConversationAnimator.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 25.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import UIKit

class ConversationAnimator {
    
    
    // MARK: Animation
    
     func showAnimationIfUser(isOnline: Bool, for button: UIButton) {
        
        let animationColor = CABasicAnimation(keyPath: "backgroundColor")
        animationColor.fromValue = button.backgroundColor
        animationColor.toValue = isOnline ? UIColor.blue : UIColor.red
        button.backgroundColor = isOnline ? UIColor.blue : UIColor.red
        
        let animationScale = CAKeyframeAnimation(keyPath: "transform.scale")
        let scale1 = 1.0
        let scale2 = 1.15
        let scaleEnd = 1.0
        animationScale.values = [scale1,scale2,scaleEnd]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animationColor, animationScale]
        animationGroup.duration = 0.5
        button.layer.add(animationGroup, forKey: "groupAnimation")
        
    }
    
     func showAnimationIfUser(isOnline: Bool, for title: UILabel) {
        
        
        UIView.transition(with: title, duration: 1.0, options: .transitionCrossDissolve, animations: {
            title.textColor = isOnline ? UIColor.green : UIColor.black
        }, completion: { finish in
            title.textColor = isOnline ? UIColor.green : UIColor.black
        })
        
        let animationScale = CABasicAnimation(keyPath: "transform.scale")
        let scaleStart: CGFloat = isOnline ? 1.0 : 1.1
        let scaleEnd: CGFloat =  isOnline ? 1.1 : 1.0
        animationScale.fromValue = scaleStart
        animationScale.toValue = scaleEnd
        animationScale.duration = 1.0
        title.transform = CGAffineTransform(scaleX: scaleEnd, y: scaleEnd)
        title.layer.add(animationScale, forKey: "animationScale")
        
    }
    
    
}
