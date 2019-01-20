import UIKit

class MiniNote: UIImageView {
    
    var noteImage = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        makeNoteAppearFlyAwayAndFade()
    }
    
    func setupImage(){
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("8thThumb.png")
        noteImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.height*3, height: frame.height*3), scale: 1)
        image = noteImage
        
        contentMode = .scaleAspectFit
        layer.opacity = 0.0
        isUserInteractionEnabled = true
        
        changeOpacityOverTime(view: self, time: 2.0, opacity: 1.0) {
            
        }
        
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
        
        changeOpacityOverTime(view: self, time: time, opacity: 0.0) {
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

