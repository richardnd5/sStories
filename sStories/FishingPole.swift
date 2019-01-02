import UIKit

class FishingPole: UIImageView {
    
    var poleImage = UIImage()
    var scaleSize = CGFloat()
    var isReadyToCastOrReelIn = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("FishingPole.png")
        poleImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.height*2, height: frame.height*2), scale: 1)
        image = poleImage
        
        contentMode = .bottom
        isUserInteractionEnabled = false
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
    }

    func fadeTo(view: UIView, time: Double,opacity: CGFloat, _ completion: @escaping () ->()){
        
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                view.alpha = opacity
        },
            completion: {
                _ in
                completion()
        })
    }
    
    func wobblePole() {
        
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi / -90)
        rotationAnimation.duration = 3.0;
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotationAnimation.repeatCount = .infinity;
        rotationAnimation.autoreverses = true
        layer.add(rotationAnimation, forKey: "rotationAnimation")
        
    }
    
    func pullPoleOut(_ completion: @escaping ()->()){
        layer.removeAllAnimations()
        
        CATransaction.begin()
        
        let scaleAnim : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 0.75
        scaleAnim.toValue = 4
        
        let opacity : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1.0
        opacity.toValue = 0.0
        
        let rotate : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0.0
        rotate.toValue = 1.0
        
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [scaleAnim,opacity, rotate]
        animGroup.duration = 0.45
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animGroup.isRemovedOnCompletion = false
        animGroup.fillMode = .forwards
        
        CATransaction.setCompletionBlock{ [weak self] in
            completion()
            self!.isReadyToCastOrReelIn = true
        }
        
        layer.add(animGroup, forKey: "animGroup")
        
        CATransaction.commit()
    }
    
    func putPoleIn(_ completion: @escaping ()->()){
        layer.removeAllAnimations()
        
        CATransaction.begin()
        
        let scaleAnim : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 4
        scaleAnim.toValue = 1
        
        let opacity : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0.0
        opacity.toValue = 1.0
        
        let rotate : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 1.0
        rotate.toValue = 0.0
        
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [scaleAnim,opacity, rotate]
        animGroup.duration = 0.75
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animGroup.isRemovedOnCompletion = false
        animGroup.fillMode = .forwards
        
        
        CATransaction.setCompletionBlock{ [weak self] in
            completion()
        }
        layer.add(animGroup, forKey: "animGroup")

        CATransaction.commit()

    }
    
    func fishOnTheLine(_ completion: @escaping ()->()){
        
        CATransaction.begin()
        let scaleAnim : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 1
        scaleAnim.toValue = 0.75
        
        // Wiggle pole fast like.
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi / -400)
        rotationAnimation.duration = 0.1;
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotationAnimation.repeatCount = .infinity;
        rotationAnimation.autoreverses = true
        
        CATransaction.setCompletionBlock{ [weak self] in
            completion()
            self!.isReadyToCastOrReelIn = true
        }
        
        layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [scaleAnim]
        animGroup.duration = 0.3
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animGroup.isRemovedOnCompletion = false
        
        animGroup.fillMode = .forwards

        layer.add(animGroup, forKey: "animGroup")
        
        CATransaction.commit()
    }
    
    func scaleTo(scaleTo: CGFloat, time: Double, _ completion: @escaping () ->()){
        
        scaleSize = scaleTo
        
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
    
    func fadeOutAndRemove(){
        scaleTo(scaleTo: 0.0000001, time: 1.0) {
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
