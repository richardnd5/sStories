import UIKit

class ArrangingBackground: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
    }
    
    func setupImage(){ 
        image = resizedImage(name: "arrangingBackground", frame: frame, scale: 3)
        contentMode = .scaleAspectFill
        layer.zPosition = -10
        layer.cornerRadius = frame.height/10
        clipsToBounds = true
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = false
        addBlurBorder(dx: frame.height/20, dy: frame.height/20, cornerWidth: frame.height/10, cornerHeight: frame.height/10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

