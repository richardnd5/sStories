import UIKit

extension UIView {
    
    func fadeTo(time: Double, opacity: CGFloat, _ completion: @escaping () ->() = {} ){
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
        var maskLayer = CAGradientLayer()
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
    
    func scaleTo(scaleTo: CGFloat, time: Double, _ completion: @escaping () -> () = {} ){
        
        UIView.animate(
            withDuration: time,
            delay: 0,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: scaleTo,
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
