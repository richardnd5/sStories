//
//  PageCell.swift
//  Stroud Story UIView
//
//  Created by Nate on 12/5/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//

import UIKit

class MelodyThumbnail: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    var typeNumber = Int()
    
    
    init(frame: CGRect, typeNumber: Int) {
        super.init(frame: frame)
        
        
        self.typeNumber = typeNumber
        
        setupNote()
    }
    
    func setupNote(){
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("\(getTypeNameBasedOnNumber(number: typeNumber)).png")
        noteImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.height*3, height: frame.height*3), scale: 1)
        
        image = noteImage
        contentMode = .scaleAspectFit
        layer.zPosition = 100
        layer.cornerRadius = frame.height/10
        clipsToBounds = true
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = true
        
        setOpacity(0.1)
        
        
    }
    
    func getTypeNameBasedOnNumber(number: Int) -> String {
        var string = String()
        print("ran the get type")
        
        switch number {
        case 0:
            string = "begin"
        case 1:
            string = "middle"
        case 2:
            string = "tonic"
        case 3:
            string = "dominant"
        case 4:
            string = "ending"
        case 5:
            string = "final"
        default:
            string = "begin"
        }
        return string
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
    
    func shrinkAndRemove(time: Double, _ completion: @escaping () ->()){
        
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
    
    func moveViewTo(_ point: CGPoint, time: Double){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                
                self.frame.origin = point
        },
            completion: {
                _ in
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
