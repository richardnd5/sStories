import UIKit

class transparentMelody: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    var typeNumber = Int()
    
    
    init(frame: CGRect, typeNumber: Int) {
        super.init(frame: frame)
        
        
        self.typeNumber = typeNumber
        
        setupNote()
    }
    
    func setupNote(){
        
        image = resizedImage(name: "\(getTypeNameBasedOnNumber(number: typeNumber))", frame: frame, scale: 3).setOpacity(alpha: 0.1)
        contentMode = .scaleAspectFit
        layer.zPosition = 100
        layer.cornerRadius = frame.height/10
        clipsToBounds = true
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = false
    }
    
    func getTypeNameBasedOnNumber(number: Int) -> String {
        var string = String()
        
        switch number {
        case 0:
            string = "begin"
        case 1:
            string = "middle"
        case 2:
            string = "tonic"
        case 3:
            string = "dominant"
        case 4:
            string = "ending"
        case 5:
            string = "final"
        default:
            string = "begin"
        }
        return string
    }
    
    func addBlurredBorder(){
        maskLayer.frame = bounds
        maskLayer.shadowPath = CGPath(roundedRect: bounds.insetBy(dx: frame.height/20, dy: frame.height/20), cornerWidth: frame.height/10, cornerHeight: frame.height/10, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.black.cgColor
        layer.mask = maskLayer;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
