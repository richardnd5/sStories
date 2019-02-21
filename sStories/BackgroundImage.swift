import UIKit

class BackgroundImage: UIImageView {
    
    var noteImage = UIImage()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        
        addBlurBorder(dx: frame.height/8, dy: frame.height/6, cornerWidth: frame.height/8, cornerHeight: frame.height/8, shadowRadius: frame.height/10)
        
    }
    
    func setupImage(){
        
        image = resizedImage(name: "homePageBackground")
        contentMode = .scaleAspectFill
        layer.cornerRadius = frame.width/10
        clipsToBounds = true
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
