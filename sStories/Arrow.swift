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
        
        fadeTo(opacity: 1.0, time: 3.0)
        point()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
