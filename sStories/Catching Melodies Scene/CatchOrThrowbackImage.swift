import UIKit

class CatchOrThrowbackImage: UIImageView {
    
    var noteImage = UIImage()
    var scaleSize : CGFloat = 1.0
    var imageName = String()
    var isSelected = false

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

        fadeTo(time: 2.0, opacity: 1.0)
    }
    
    func expand(){
        scaleTo(scaleTo: 1.4, time: 0.8, {self.scaleSize = 1.4})
        if imageName == "sack" {
            playSoundClip(.fishingSackDrag)
        } else if imageName == "throwbackWater" {
            playSoundClip(.fishingThrowbackDrag)
        }
        isSelected = true
    }
    
    func shrink(){
        scaleTo(scaleTo: 1.0, time: 0.8, {self.scaleSize = 1.0})
        isSelected = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
