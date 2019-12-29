//
//  LoadingAnimationView.swift
//  Little Ideas
//
//  Created by Jayson Coppo on 3/21/19.
//  Copyright © 2019 Jayson Coppo. All rights reserved.
//

import UIKit

class LoadingAnimationView: UIView {
    
    let curvyLine1 = CAShapeLayer()
    let curvyLine2 = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        let rotation1 = CABasicAnimation(keyPath: "transform.rotation")
        rotation1.byValue = 2*CGFloat.pi
        rotation1.duration = 1
        rotation1.repeatCount = Float.infinity
        curvyLine1.add(rotation1, forKey: rotation1.keyPath)
        
        let rotation2 = CABasicAnimation(keyPath: "transform.rotation")
        rotation2.byValue = -2*CGFloat.pi
        rotation2.duration = 1
        rotation2.repeatCount = Float.infinity
        curvyLine2.add(rotation2, forKey: rotation1.keyPath)
    }
    
    override func layoutSubviews() {
        let curvePath1 = UIBezierPath(arcCenter: CGPoint.zero, radius: 30, startAngle: 0, endAngle: CGFloat.pi/4, clockwise: true)
        let curvePath2 = UIBezierPath(arcCenter: CGPoint.zero, radius: 20, startAngle: 0, endAngle: CGFloat.pi/4, clockwise: true)
        
        curvyLine1.path = curvePath1.cgPath
        curvyLine1.strokeColor = UIColor.blue.cgColor
        curvyLine1.fillColor = UIColor.clear.cgColor
        curvyLine1.lineWidth = 2
        curvyLine1.position = CGPoint(x: frame.width/2, y: frame.height/2)
        
        curvyLine2.path = curvePath2.cgPath
        curvyLine2.strokeColor = UIColor.blue.cgColor
        curvyLine2.fillColor = UIColor.clear.cgColor
        curvyLine2.lineWidth = 2
        curvyLine2.position = CGPoint(x: frame.width/2, y: frame.height/2)
        
        layer.addSublayer(curvyLine1)
        layer.addSublayer(curvyLine2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
