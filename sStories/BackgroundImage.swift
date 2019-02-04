import UIKit

class BackgroundImage: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        addBlurredBorder()
        
    }
    
    func setupImage(){
        
        image = resizedImage(name: "homePageBackground")
        contentMode = .scaleAspectFill
        layer.cornerRadius = frame.width/10
        clipsToBounds = true
        isUserInteractionEnabled = false
    }

    func addBlurredBorder(){
        maskLayer.frame = bounds
        maskLayer.shadowPath = CGPath(roundedRect: bounds.insetBy(dx: frame.height/8, dy: frame.height/6), cornerWidth: frame.height/8, cornerHeight: frame.height/8, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowRadius = frame.height/10
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.black.cgColor
        layer.mask = maskLayer;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

