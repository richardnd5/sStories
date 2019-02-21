//
//  PageCell.swift
//  Stroud Story UIView
//
//  Created by Nate on 12/5/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//

import UIKit

class PerformingBackground: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        
    }
    
    func setupImage(){
        
        image = resizedImage(name: "Performance", frame: frame, scale: 1)
        contentMode = .scaleAspectFit
        layer.zPosition = -10
        layer.cornerRadius = frame.height/10
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

