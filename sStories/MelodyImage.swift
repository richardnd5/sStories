//
//  PageCell.swift
//  Stroud Story UIView
//
//  Created by Nate on 12/5/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//

import UIKit

class MelodyImage: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    var number = Int()
    var type : MelodyType!
    var data : Melody?
    var inCorrectSlot = false
    
    var glowingOverlay = UIView()
    
    init(frame: CGRect, melody: Melody) {
        super.init(frame: frame)

        self.number = melody.number
        self.type = melody.type
        self.data = melody
        setupNote()
    }
    
    func setupNote(){
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("\(determineWhatImageToShowForMelody(type: type)).png")
        noteImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.height*3, height: frame.height*3), scale: 1)
        
        image = noteImage
        contentMode = .scaleAspectFit
        layer.zPosition = 2
        layer.opacity = 0.0
        layer.cornerRadius = frame.height/10
        clipsToBounds = true
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = true
        
        changeOpacityOverTime(view: self, time: 1.0, opacity: 1.0) {}
        
        setupGlowingOverlay()
        
    }
    
    func setupGlowingOverlay(){
        glowingOverlay = UIView(frame: CGRect.zero)
        glowingOverlay.backgroundColor = .green
        glowingOverlay.layer.zPosition = 2
        glowingOverlay.layer.opacity = 0.0
        addSubview(glowingOverlay)
        glowingOverlay.fillSuperview()
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
    
    func changeSize(to: CGSize, time: Double){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                
                self.frame.size = to
        },
            completion: {
                _ in
                
                
        })
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
    
//    func pauseAnimation(){
//        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
//        layer.speed = 0.0
//        layer.timeOffset = pausedTime
//    }
//
//    func resumeAnimation(){
//        var pausedTime = layer.timeOffset
//        layer.speed = 1.0
//        layer.timeOffset = 0.0
//        layer.beginTime = 0.0
//        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
//        layer.beginTime = timeSincePause
//    }
    
    func startGlowingPulse(){
        print("start pulse")
        let glow : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        glow.fromValue = 0.0
        glow.toValue = 0.4
        glow.duration = 0.7;
        glow.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        glow.repeatCount = .infinity;
        glow.autoreverses = true
        glowingOverlay.layer.add(glow, forKey: "throb")
    }
    
    func stopGlowingPulse(){
        
        print("stop pulse")
        CATransaction.begin()
        let glow : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        glow.toValue = 0.0
        glow.duration = 0.7
        glow.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        glow.fillMode = .forwards

        CATransaction.setCompletionBlock {
            self.glowingOverlay.layer.removeAnimation(forKey: "throb")
            self.isPlaying = false
        }
        glowingOverlay.layer.add(glow, forKey: "stopGlow")
        
        CATransaction.commit()
        
        
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
    
    var glowTimer = Timer()
    var isPlaying = false
    func playMelody(){

        if !isPlaying {
            
            isPlaying = true
            glowTimer.invalidate()

            print("playing audio")
            data?.audio?.playMelody()
            startGlowingPulse()

            // Hardcoded timer value based on 80 bpm, 8 beats or 16 beats for final
            var length = TimeInterval()
            let bpmToSec = 60/tempo
            type == .final ? (length = TimeInterval((bpmToSec)*16)-3) : (length = TimeInterval((bpmToSec)*8)-1)

            print(length)

            glowTimer = Timer.scheduledTimer(withTimeInterval: length, repeats: false, block:{_ in self.stopGlowingPulse()})
            
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
