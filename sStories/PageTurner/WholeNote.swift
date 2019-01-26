import UIKit

class WholeNote: UIImageView {
    
    var noteImage = UIImage()
    var scaleSize : CGFloat = 1.0
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
    }
    
    func setupImage(){

        image = resizedImage(name: "wholeNote", frame: frame, scale: 3)
        
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true

        
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
                finish in
                
                completion()
        })
    }
    
    func moveViewTo(_ point: CGPoint, time: Double, _ completion: @escaping () ->()){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                
                self.frame.origin = point
        },
            completion: {
                finish in
                completion()
        })
    }
    
    func fadeOutAndRemove(){
        scaleTo(scaleTo: 0.0000001, time: 1.0) {
            self.removeFromSuperview()
        }
    }
    
    func point(){
        
        let fromPoint = CGPoint(x: frame.midX, y: frame.midY)
        let toPoint = CGPoint(x: frame.midX, y: frame.midY-frame.height/4)
        
        let anim = CABasicAnimation(keyPath: "position")
        anim.autoreverses = true
        anim.repeatCount = .infinity;
        anim.fromValue = NSValue(cgPoint: fromPoint)
        anim.toValue = NSValue(cgPoint: toPoint)
        anim.duration = 0.6
        layer.add(anim, forKey: "move")
    }
    
    
    
    func makeNoteAppearFlyAwayAndFade(){
        
        let width = frame.width/1.25
        let height = frame.width/1.25
        let x = frame.width/2-width/2
        let y = frame.height-height*2
        let note = MiniNote(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(note)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
