import UIKit

class MiniPerformingNoteView: UIView {
    
    var noteImage = UIImage()
    var number = Int()
    var imageView = UIImageView()
    var maskLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        addBlurBorder(dx: frame.height/20, dy: frame.height/20, cornerWidth: frame.height/2, cornerHeight: frame.height/2)
        layer.zPosition = 1000
    }
    
    func setupImage(){
        
        number = Int.random(in: 0...11)
        
        let width = frame.width/2
        let height = frame.height/2
        let x = frame.width/2-width/2
        let y = frame.height/2-height/2
        let fr = CGRect(x: x, y: y, width: width, height: height)
        
        imageView = UIImageView(frame: fr)
        imageView.image = resizedImage(name: "musicSymbol\(number)", frame: frame, scale: 3)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        
        layer.opacity = 0.0
        isUserInteractionEnabled = true
        layer.cornerRadius = frame.height/2
        
        fadeTo(time: 1.0, opacity: 1.0)
        let randomNumber = CGFloat.random(in: 0.0...1.0)
        backgroundColor = UIColor(hue: randomNumber, saturation: randomNumber, brightness: 1.0, alpha: 1.0)
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
    
    func makeNoteAppearAndFloat(){
        let range = (-frame.height*3...frame.height*3)
        let randX = CGFloat.random(in: range)
        let randY = CGFloat.random(in: range)
        let time = 1.0
        
        let fromPoint = CGPoint(x: frame.midX, y: frame.midY)
        let toPoint = CGPoint(x: frame.midX-randX, y: frame.midY-randY)
        
        let randomRotation = NSNumber(value: Double.random(in: -Double.pi...Double.pi))
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = randomRotation
        rotation.duration = time
        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotation.fillMode = .forwards
        layer.add(rotation, forKey: "rotation")
    }
    
    func shrinkRotateAndRemove(){
        
        let time = 0.5
        let randomRotation = NSNumber(value: Double.random(in: -Double.pi*3...Double.pi*3))
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = randomRotation
        rotation.duration = time
        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotation.fillMode = .forwards
        layer.add(rotation, forKey: "rotation")
        
        let scale : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue = 0.0
        scale.duration = time
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.fillMode = .forwards
        layer.add(scale, forKey: "rotate")
        
        fadeAndRemove(time: time)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


