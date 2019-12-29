import UIKit

class PlayButton: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    var typeNumber = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNote()
        alpha = 0.0
        fadeTo(opacity: 1.0, time: 1.5)
    }
    
    func setupNote(){
        image = resizedImage(name: "playButtonNew", frame: frame, scale: 3)
        contentMode = .scaleAspectFit
        layer.zPosition = 100
        clipsToBounds = true
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
