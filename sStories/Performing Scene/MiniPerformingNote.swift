import UIKit

class MiniPerformingNote: UIImageView {
    
    var noteImage = UIImage()
    var number = Int()
    var maskLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        makeNoteAppearFlyAwayAndFade()
        addBlurBorder(dx: frame.height/20, dy: frame.height/20, cornerWidth: frame.height/10, cornerHeight: frame.height/10)
    }
    
    func setupImage(){
        
        number = Int.random(in: 0...11)
        image = resizedImage(name: "musicSymbol\(number)", frame: frame, scale: 3)
        
        contentMode = .scaleAspectFit
        layer.opacity = 0.0
        isUserInteractionEnabled = true
        layer.cornerRadius = frame.height/10
        
        fadeTo(opacity: 1.0, time: 2.0)
        backgroundColor = UIColor(red: 137/255, green: 220/255, blue: 237/255, alpha: 1.0)
    }
    
    func makeNoteAppearFlyAwayAndFade(){
        
        let range = (-frame.height*3...frame.height*3)
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

