//
//  PageCell.swift
//  Stroud Story UIView
//
//  Created by Nate on 12/5/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//

import UIKit

class Melody: UIImageView {
    
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    var patternNumber = Int()

    
    init(frame: CGRect, number: Int) {
        super.init(frame: frame)

        patternNumber = number
        setupNote()

    }
    
    func setupNote(){
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("melody \(patternNumber).png")
        noteImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.height*3, height: frame.height*3), scale: 1)
        image = noteImage
        
        // Set up imageview
        frame.size = CGSize(width: noteImage.size.width/2.5, height: noteImage.size.height/2.5)
        contentMode = .scaleAspectFit
        layer.zPosition = 100
        layer.opacity = 0.0
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = true

        // add blurred edges
        maskLayer.frame = bounds
        maskLayer.shadowRadius = frame.height/20
        maskLayer.shadowPath = CGPath(roundedRect: bounds.insetBy(dx: frame.height/8, dy: frame.height/8), cornerWidth: frame.height/3, cornerHeight: frame.height/2.28, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.black.cgColor
        layer.mask = maskLayer;
        
        changeOpacity(view: self, time: 2.0, opacity: 1.0) {
            print("faded in")

        }
        
    }

    func scaleTo(scaleTo: CGFloat, time: Double, _ completion: @escaping () ->()){
        
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {

                self.transform = CGAffineTransform(scaleX: scaleTo, y: scaleTo)
        },
            completion: {
                _ in
                
                completion()
        })
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
    
    func fadeOutAndRemove(time: Double, _ completion: @escaping () ->()){
        
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                
                self.transform = CGAffineTransform(scaleX: 0.00000001, y: 0.00000001)
        },
            completion: {
                _ in
                self.removeFromSuperview()
                completion()
        })
    }
    
    func playMelody(){
        SoundClass.Sound.playPattern(patternNumber)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
