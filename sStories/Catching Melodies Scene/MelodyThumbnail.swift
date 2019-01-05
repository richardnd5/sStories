import UIKit

class MelodyThumbnail: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    var melodyNumber = Int()
    var slotPos = Int()
    
    init(frame: CGRect, melodyNumber: Int, slotPos: Int) {
        super.init(frame: frame)
        self.melodyNumber = melodyNumber
        self.slotPos = slotPos
        setupNote()
    }
    
    func setupNote(){
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("melodyThumbnail.png")
        noteImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.height*3, height: frame.height*3), scale: 1)
        image = noteImage
        
//        contentMode = .scaleAspectFit
        layer.opacity = 0.0
        layer.cornerRadius = frame.height/10
        clipsToBounds = true
        
//        // add blurred edges
//        maskLayer.frame = bounds
//        maskLayer.shadowRadius = frame.height/70
//        maskLayer.shadowPath = CGPath(roundedRect: bounds.insetBy(dx: frame.height/14, dy: frame.height/14), cornerWidth: frame.height/3, cornerHeight: frame.height/3, transform: nil)
//        maskLayer.shadowOpacity = 1;
//        maskLayer.shadowOffset = CGSize.zero;
//        maskLayer.shadowColor = UIColor.black.cgColor
//        layer.mask = maskLayer;
        
        changeOpacity(view: self, time: 1.0, opacity: 1.0) {
            
        }
        
    }
    
    func scaleTo(scaleTo: CGFloat, time: Double, _ completion: @escaping () ->()){
        
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                
                self.transform = CGAffineTransform(scaleX: scaleTo, y: scaleTo)
        },
            completion: {
                _ in
                
                completion()
        })
    }
    
    func shrinkAndRemove(time: Double){
        scaleTo(scaleTo: 0.0000001, time: time) {
            self.removeFromSuperview()
        }
    }
    
    func moveViewTo(_ point: CGPoint, time: Double){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                
                self.frame.origin = point
        },
            completion: {
                _ in
                
                
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
