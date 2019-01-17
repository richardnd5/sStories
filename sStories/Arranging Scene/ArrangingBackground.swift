//
//  PageCell.swift
//  Stroud Story UIView
//
//  Created by Nate on 12/5/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//

import UIKit

class ArrangingBackground: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupImage()
    }
    
    func setupImage(){
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("arrangingBackground.png")
        noteImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.height*3, height: frame.height*3), scale: 1)
        
        image = noteImage
        contentMode = .scaleAspectFill
        layer.zPosition = -10
        layer.cornerRadius = frame.height/10
        clipsToBounds = true
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = false
        
        addBlurredBorder()
        
    }
    
    func setOpacity(_ to: CGFloat){
        noteImage = noteImage.setOpacity(alpha: to)!
        image = noteImage
    }
    
    func addBlurredBorder(){
        maskLayer.frame = bounds
        maskLayer.shadowPath = CGPath(roundedRect: bounds.insetBy(dx: frame.height/20, dy: frame.height/20), cornerWidth: frame.height/10, cornerHeight: frame.height/10, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.black.cgColor
        layer.mask = maskLayer;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
