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

        changeOpacityOverTime(view: self, time: 2.0, opacity: 1.0) {
            
        }
        
    }
    
    func scaleTo(scaleTo: CGFloat, time: Double, _ completion: @escaping () ->()){
        
        scaleSize = scaleTo
        
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
    
//    func fadeOutAndRemove(){
//        scaleTo(scaleTo: 0.0000001, time: 1.0) {
//            self.removeFromSuperview()
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
