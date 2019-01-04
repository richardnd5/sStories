import UIKit

class MelodyThumbnail: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNote()
    }
    
    func setupNote(){
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("melodyThumbnail.png")
        noteImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.height*3, height: frame.height*3), scale: 1)
        image = noteImage
        
        contentMode = .scaleAspectFit
        layer.opacity = 0.0
        layer.cornerRadius = 10
        
        // add blurred edges
        maskLayer.frame = bounds
        maskLayer.shadowRadius = frame.height/70
        maskLayer.shadowPath = CGPath(roundedRect: bounds.insetBy(dx: frame.height/14, dy: frame.height/14), cornerWidth: frame.height/3, cornerHeight: frame.height/3, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.black.cgColor
        layer.mask = maskLayer;
        
        changeOpacity(view: self, time: 1.0, opacity: 1.0) {
            print("faded in")
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
