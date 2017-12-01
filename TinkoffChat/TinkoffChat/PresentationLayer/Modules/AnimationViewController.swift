//
//  AnimationViewController.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 25.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import UIKit

import Foundation
import UIKit

class AnimationViewController: UIViewController {
    
    private var timer: Timer?
    private var currentTapPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(reconizer:)))
        longPress.minimumPressDuration = 0.2
        self.view.addGestureRecognizer(longPress)
        
    }
    
    
    @objc private func circleAnimation() {
        
        let tinkoffImageView = UIImageView()
        tinkoffImageView.image = UIImage.init(named: "tinkoffImage")
        tinkoffImageView.frame = CGRect(x: 0, y: 0, width: 40.0, height: 40.0)
        tinkoffImageView.center = currentTapPoint
        self.view.addSubview(tinkoffImageView)
        
        let delay : CFTimeInterval = 0.2
        let timeOfRotate : CFTimeInterval = 1
        let radius : CGFloat = 50
        
        // Animation #1
        
        let animationMove = CABasicAnimation(keyPath: "position")
        animationMove.fromValue = tinkoffImageView.layer.position
        animationMove.toValue = CGPoint.init(x: tinkoffImageView.layer.position.x + radius, y: tinkoffImageView.layer.position.y)
        animationMove.duration = delay
        tinkoffImageView.layer.add(animationMove, forKey: "move")
        
        // Animation #2
        
        let circlePath = UIBezierPath(arcCenter: tinkoffImageView.center, radius: radius, startAngle: 0, endAngle:CGFloat(Double.pi)*2, clockwise: false)
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.beginTime = CACurrentMediaTime() + delay
        animation.duration = timeOfRotate
        animation.repeatCount = 1
        animation.path = circlePath.cgPath
        tinkoffImageView.layer.add(animation, forKey: "rotate")
        
        // Animation #3
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
             tinkoffImageView.removeFromSuperview()
        }
        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.fromValue = 1
        animationOpacity.toValue = 0
        animationOpacity.duration = delay + timeOfRotate
        tinkoffImageView.layer.opacity = 0
        tinkoffImageView.layer.add(animationOpacity, forKey: "animationOpacity")
        CATransaction.commit()
        
    }
    
    
    @objc private func longPressGesture(reconizer: UILongPressGestureRecognizer) {
        
        currentTapPoint = reconizer.location(in: self.view)
        
        if reconizer.state == .began {
            circleAnimation()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(circleAnimation), userInfo: nil, repeats: true)
        } else if reconizer.state == .ended{
            timer?.invalidate()
        }
    }
    
    
}



