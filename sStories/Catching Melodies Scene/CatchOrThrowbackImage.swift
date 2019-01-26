import UIKit

class CatchOrThrowbackImage: UIImageView {
    
    var noteImage = UIImage()
    var scaleSize : CGFloat = 1.0
    var imageName = String()

    init(frame: CGRect, imageName: String) {
        super.init(frame: frame)
        self.imageName = imageName
        setupImage()
    }
    
    func setupImage(){
        
        image = resizedImage(name: "\(imageName)", frame: frame, scale: 3)

        contentMode = .scaleAspectFit
        layer.zPosition = 1
        layer.opacity = 0.0
        isUserInteractionEnabled = false

        fadeTo(time: 2.0, opacity: 1.0, {})
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
