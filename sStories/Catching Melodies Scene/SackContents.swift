import UIKit

class SackContents: UIView {
    
    var melodyImage: UIImageView?
    var melodySlots = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUIGrid()
        
        
        
        
    }
    
    func makeUIGrid() {
        
        let rows = 4
        let spacing : CGFloat = 10
        let width = frame.width/CGFloat(rows)
    
        for i in 0..<rows {
            
            let view = UIView(frame: CGRect(x: CGFloat(i)*width, y: 0, width: width-spacing, height: width-spacing))
            view.layer.cornerRadius = view.frame.height/10
            view.backgroundColor = UIColor.init(white: 0.9, alpha: 0.3)
            view.isUserInteractionEnabled = true
            addDashedBorder(view)
            melodySlots.append(view)
            addSubview(view)
            print("\(i):     \(view.frame.origin)")
        }
    }
    
    func addMelodyToSlot(_ number: Int, melodyNumber: Int){
        
        let width = melodySlots[number].frame.width
        let height = melodySlots[number].frame.height
        
        
        let melody = MelodyThumbnail(frame: CGRect(x: 0, y: 0, width: width, height: height), melodyNumber: melodyNumber, slotPos: number)
        melody.isUserInteractionEnabled = true
        melodySlots[number].addSubview(melody)
        
        // Give it gesture recognizers
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMelodyPan))
        melody.addGestureRecognizer(panGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
        melody.addGestureRecognizer(tap)
    }
    
    func addMelodyToOpenSlot(_ number: Int, melodyNumber: Int){
        for i in 0...collectedMelodies.count-1 {
            if collectedMelodies[i] == nil {
                let width = melodySlots[number].frame.width
                let height = melodySlots[number].frame.height
                
                
                let melody = MelodyThumbnail(frame: CGRect(x: 0, y: 0, width: width, height: height), melodyNumber: melodyNumber, slotPos: i)
                melody.isUserInteractionEnabled = true
                melodySlots[number].addSubview(melody)
                
                // Give it gesture recognizers
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMelodyPan))
                melody.addGestureRecognizer(panGesture)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
                melody.addGestureRecognizer(tap)
                
            }
        }

        
    }
    
    func removeMelodyFromSlot(_ number: Int){
        
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
    
    func fadeOutAndRemove(){
        scaleTo(scaleTo: 0.0000001, time: 1.0) {
            self.removeFromSuperview()
        }
    }
    
    func addDashedBorder(_ view: UIView) {
        let color = UIColor.white.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = view.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: frame.height/10).cgPath
        
        view.layer.addSublayer(shapeLayer)
    }
    
    @objc func handleMelodyPan(_ sender: UIPanGestureRecognizer){
        
        let view = sender.view as! MelodyThumbnail

        let translation = sender.translation(in: self)
        
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
            
            if sender.location(in: self).y <= -view.frame.height*3 {
                view.shrinkAndRemove(time: 0.4)
                collectedMelodies.remove(at: view.slotPos)
                
            } else {
                view.moveViewTo(CGPoint.zero, time: 0.4)
            }
        }
        
    }
    
    @objc func handleMelodyTap(_ sender: UITapGestureRecognizer){
        let view = sender.view as! MelodyThumbnail
        
        Sound.sharedInstance.playPattern(view.melodyNumber)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
