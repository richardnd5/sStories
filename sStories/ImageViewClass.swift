import UIKit

class ImageViewClass: UIImageView {
    
    var noteImage = UIImage()
    var imageName : String!
    
    init(frame: CGRect, _ imageName: String = "homePageBackground") {
        super.init(frame: frame)
        self.imageName = imageName
        setupImage()
        
    }
    
    func setupImage(){
        
        image = resizedImage(name: imageName)
        contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

