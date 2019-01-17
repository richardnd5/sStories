//
//  PageCell.swift
//  Stroud Story UIView
//
//  Created by Nate on 12/5/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//

import UIKit

class PlayButton: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    var typeNumber = Int()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNote()
        alpha = 0.0
        changeOpacityOverTime(view: self, time: 1.5, opacity: 1.0, {})
    }
    
    func setupNote(){
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("playButton.png")
        noteImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.height*3, height: frame.height*3), scale: 1)
        
        image = noteImage
        contentMode = .scaleAspectFit
        layer.zPosition = 100
        clipsToBounds = true
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = true

    }
    
    func throbImage(_ view: UIView){
        let scale : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = 1.02
        scale.duration = 0.4;
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.repeatCount = .infinity;
        scale.autoreverses = true
        view.layer.add(scale, forKey: "throb")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
