import UIKit

class Arrow: UIImageView {
    
    var noteImage = UIImage()
    var scaleSize : CGFloat = 1.0
    var isVisible = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        point()
    }
    
    func setupImage(){
        
        image = resizedImage(name: "arrow", frame: frame, scale: 3)
        image = image?.setOpacity(alpha: 0.3)
        
        contentMode = .scaleToFill
        layer.opacity = 0.0
        isUserInteractionEnabled = true
        
        changeOpacityOverTime(view: self, time: 3.0, opacity: 1.0) {
            
        }
        
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
                finish in
                
                completion()
        })
    }
    
    func moveViewTo(_ point: CGPoint, time: Double, _ completion: @escaping () ->()){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                
                self.frame.origin = point
        },
            completion: {
                finish in
                completion()
        })
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
    
    
    func fadeOutAndRemove(){
        isVisible = false
        changeOpacityOverTime(view: self, time: 1.0, opacity: 0.0) {
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
