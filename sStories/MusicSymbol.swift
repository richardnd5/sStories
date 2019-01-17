import UIKit

class MusicSymbol: UIImageView {
    
    var symbolImage = UIImage()
    var maskLayer = CAGradientLayer()
    var symbol = String()
    
    
    init(frame: CGRect, symbol: String) {
        super.init(frame: frame)
        self.symbol = symbol
        
        setupSymbol()
    }
    
    func setupSymbol(){
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("\(symbol).png")
        symbolImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.height*3, height: frame.height*3), scale: 1)
        image = symbolImage
        layer.opacity = 0.0
        layer.cornerRadius = frame.height/10
        clipsToBounds = true
        
        changeOpacityOverTime(view: self, time: 1.0, opacity: 1.0) {
            
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

