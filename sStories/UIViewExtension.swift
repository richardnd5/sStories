import UIKit

extension UIView {
    
    func fadeTo(opacity: CGFloat, time: Double,  _ completion: @escaping () ->() = {} ){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.alpha = opacity
        },
            completion: {
                _ in
                completion()
        })
    }
    
    func fadeAndRemove(time: Double, completion: @escaping ( ) -> ( ) = {} ){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.alpha = 0.0
        },
            completion: {
                _ in
                completion()
                self.removeFromSuperview()
        })
    }
    
    func addDashedBorder() {
        let color = UIColor.white.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4,2]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: self.frame.height/10).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addBlurBorder(dx: CGFloat, dy: CGFloat, cornerWidth: CGFloat, cornerHeight: CGFloat, shadowRadius: CGFloat = 3){
        let maskLayer = CAGradientLayer()
        maskLayer.frame = bounds
        maskLayer.shadowPath = CGPath(roundedRect: bounds.insetBy(dx: dx, dy: dy), cornerWidth: cornerWidth, cornerHeight: cornerHeight, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowRadius = shadowRadius
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.black.cgColor
        layer.mask = maskLayer;
    }
    
    func shrinkAndRemove(time: Double, _ completion: @escaping () ->() = {} ){
        
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
    
    func moveViewTo(_ point: CGPoint, time: Double, _ completion: @escaping () ->() = {} ){
        UIView.animate(
            withDuration: time,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.1,
            options: .curveEaseInOut,
            animations: {
                self.frame.origin = point
        },
            completion: {
                _ in
                completion()
        })
    }
    
    func warningWiggle(){

        
        // Wiggle pole fast like.
        let wiggle : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        wiggle.toValue = 4
        wiggle.duration = 0.1;
        wiggle.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        wiggle.repeatCount = 4;
        wiggle.autoreverses = true
        
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [wiggle]
        animGroup.duration = 0.3
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animGroup.isRemovedOnCompletion = false
        
        animGroup.fillMode = .forwards
        
        layer.add(animGroup, forKey: "animGroup")

    }
    
    func bigWiggle(){
        
        let randX = Double.random(in: 0.4...3.0)
        let randY = Double.random(in: 0.4...3.0)
        
        let randXSpeed = Double.random(in: 0.1...0.22)
        let randYSpeed = Double.random(in: 0.1...0.22)
        
        let wiggleLeftRight : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        wiggleLeftRight.toValue = randX
        wiggleLeftRight.duration = randXSpeed
        wiggleLeftRight.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        wiggleLeftRight.repeatCount = .infinity
        wiggleLeftRight.autoreverses = true
        
        let wiggleUpDown : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        wiggleUpDown.toValue = randY
        wiggleUpDown.duration = randYSpeed
        wiggleUpDown.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        wiggleUpDown.repeatCount = .infinity
        wiggleUpDown.autoreverses = true
        
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [wiggleLeftRight, wiggleUpDown]
        animGroup.duration = 0.2
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animGroup.isRemovedOnCompletion = false
        
        animGroup.fillMode = .forwards
        animGroup.repeatCount = .infinity
        
        layer.add(animGroup, forKey: "bigWiggle")
        
    }
    
    func stopBigWiggle(){
        layer.removeAnimation(forKey: "bigWiggle")
    }
    
    func warningScaleUp(){
        let scaleAnim : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 1
        scaleAnim.toValue = 1.1
        scaleAnim.duration = 0.4
        scaleAnim.autoreverses = true
        scaleAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(scaleAnim, forKey: nil)
    }
    
    func changeSize(to: CGSize, time: Double){
        UIView.animate(
            withDuration: time,
            delay: 0,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: {
                self.frame.size = to
        },
            completion: {
                _ in
        })
    }
    
    func scaleTo(scaleTo: CGFloat, time: Double, _ completion: @escaping () -> () = {}, isSpringy: Bool = true ){
        
        if isSpringy {
        UIView.animate(
            withDuration: time,
            delay: 0,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: 0.77,
            options: .curveEaseInOut,
            animations: {
                self.transform = CGAffineTransform(scaleX: scaleTo, y: scaleTo)
                
        },
            completion: {
                _ in
                completion()
        })
        } else {
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
    }
    
    func throbWithWiggle(scaleTo: CGFloat, time: Double, fromValue: Double = 1.0, _ completion: @escaping () -> () = {} ){
        
        let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = time
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.autoreverses = true
        scaleAnimation.fromValue = fromValue
        scaleAnimation.toValue = scaleTo;
        layer.add(scaleAnimation, forKey: "throb")
        
    }
    
    func stopThrobWithWiggle(){
        
        layer.removeAnimation(forKey: "throb")
    }
    
    func stopThrobWithAnimation( _ completion: @escaping () -> () = {}  ){
        
        CATransaction.begin()
        
        let scaleAnimation: CASpringAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.01
        scaleAnimation.toValue = 1.0
        scaleAnimation.initialVelocity = 0.3
        scaleAnimation.damping = 3
        
        CATransaction.setCompletionBlock{ [weak self] in
            self!.layer.removeAnimation(forKey: "throb")
            completion()
        }
        
        layer.add(scaleAnimation, forKey: "scalee")
        CATransaction.commit()
    }
    
    
    func changeBackgroundColorGraduallyTo(_ color: UIColor, time: Double, isSpringy: Bool = true, _ completion: @escaping () -> () = {}  ){
        
        if isSpringy {
            UIView.animate(
                withDuration: time,
                delay: 0,
                usingSpringWithDamping: 0.55,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut,
                animations: {
                        self.backgroundColor = color
            },
                completion: {
                    _ in
                    completion()
            })
        } else {
            UIView.animate(
                withDuration: time,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self.backgroundColor = color
            },
                completion: {
                    _ in
                    completion()
            })
        }
    }
    
    func point(){
        let fromPoint = CGPoint(x: frame.midX, y: frame.midY)
        let toPoint = CGPoint(x: frame.midX, y: frame.midY-frame.height/4)
        
        let anim = CABasicAnimation(keyPath: "position")
        anim.autoreverses = true
        anim.repeatCount = .infinity;
        anim.fromValue = NSValue(cgPoint: fromPoint)
        anim.toValue = NSValue(cgPoint: toPoint)
        anim.duration = 0.6
        layer.add(anim, forKey: "move")
    }
}
