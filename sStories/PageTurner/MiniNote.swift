import UIKit

class MiniNote: UIImageView {
    
    var noteImage = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        makeNoteAppearFlyAwayAndFade()
    }
    
    func setupImage(){

        image = resizedImage(name: "8thThumb", frame: frame, scale: 3)
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = false
        alpha = 0.0
        fadeTo(opacity: 1.0, time: 2.0)
        
    }
    
    func makeNoteAppearFlyAwayAndFade(){
        
        let range = (-frame.height*4...frame.height*4)
        let randX = CGFloat.random(in: range)
        let randY = CGFloat.random(in: range)
        let time = 1.0
        
        let fromPoint = CGPoint(x: frame.midX, y: frame.midY)
        let toPoint = CGPoint(x: frame.midX-randX, y: frame.midY-randY)
        
        let position = CABasicAnimation(keyPath: "position")
        
        position.fromValue = NSValue(cgPoint: fromPoint)
        position.toValue = NSValue(cgPoint: toPoint)
        position.duration = time
        position.fillMode = .forwards
        layer.add(position, forKey: "position")
        
        let randomRotation = NSNumber(value: Double.random(in: -Double.pi...Double.pi))
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = randomRotation
        rotation.duration = time
        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotation.fillMode = .forwards
        layer.add(rotation, forKey: "rotation")
        
        fadeAndRemove(time: time)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

