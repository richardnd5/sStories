import UIKit

class SackContents: UIView {
    
    var melodyImage: UIImageView?
    var melodySlotViews = [UIView]()
    var melodiesInSack = [Melody]()
    let spacing : CGFloat = 10

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeSackSlots()
    }
    
    func makeSackSlots() {
        
        let rows = 6
        let width = frame.width/CGFloat(rows)
    
        for i in 0..<rows {
            
            let view = UIView(frame: CGRect(x: CGFloat(i)*width, y: 0, width: width-spacing, height: width-spacing))
            view.layer.cornerRadius = view.frame.height/10
            view.backgroundColor = UIColor.init(white: 0.9, alpha: 0.3)
            view.isUserInteractionEnabled = true
            addDashedBorder(view)
            melodySlotViews.append(view)
            addSubview(view)
        }
    }
    
    func addMelodyToOpenSlot(melody: Melody){
        
            for i in 0...melodySlotViews.count-1{
                if melodySlotViews[i].subviews.count == 0 {
                        let width = melodySlotViews[0].frame.width
                        let height = melodySlotViews[0].frame.height
                    
                        let view = MelodyImage(frame: CGRect(x: 0, y: 0, width: width, height: height), melody: melody)
                        view.isUserInteractionEnabled = true
                        view.tag = 0
                        melodySlotViews[i].addSubview(view)
                        melody.slotPosition = i
                        melodiesInSack.append(melody)
                        
                        // Give it gesture recognizers
                        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMelodyPan))
                        view.addGestureRecognizer(panGesture)
                        
                        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
                        view.addGestureRecognizer(tap)
                    
                        return // return and not finish the for-loop
                    }
            }
    }
    
    func removeMelodyFromSack(_ view: MelodyImage){
        view.shrinkAndRemove(time: 0.4, {})
        
        for i in 0...melodiesInSack.count-1 {
            if view.data?.slotPosition == melodiesInSack[i].slotPosition {
                melodiesInSack.remove(at: i)
                
                for melody in melodiesInSack {
//                    print("mel num: \(melody.number) slot pos: \(melody.slotPosition) type: \(melody.type)")
                }
                
                return // return so it doesn't continue the for loop
            }
        }

    }
    
    func missingMelodyType() -> MelodyType {

        var typeItNeeds = MelodyType.begin
        
        let containsBegin = melodiesInSack.contains(where: { $0.type == .begin })
        let containsMiddle = melodiesInSack.contains(where: { $0.type == .middle })
        let containsTonic = melodiesInSack.contains(where: { $0.type == .tonic })
        let containsDominant = melodiesInSack.contains(where: { $0.type == .dominant })
        let containsEnding = melodiesInSack.contains(where: { $0.type == .ending })
        let containsFinal = melodiesInSack.contains(where: { $0.type == .final })
        
        if !containsBegin {
            typeItNeeds = .begin
        } else if !containsMiddle {
            typeItNeeds = .middle
        } else if !containsTonic {
            typeItNeeds = .tonic
        } else if !containsDominant {
            typeItNeeds = .dominant
        } else if !containsEnding {
            typeItNeeds = .ending
        } else if !containsFinal {
            typeItNeeds = .final
        }

        return typeItNeeds
    }
    

    func sackFull() -> Bool{
        
        var bool = false
        for i in 0...melodySlotViews.count-1 {
            if melodySlotViews[i].subviews.count == 0 {
                bool = false
                break
            } else {
                bool = true
            }
        }

        return bool
    }
    
    // after it all has been added
    func addMelodiesToCollectedMelodyArray(){
        for i in 0...melodySlotViews.count-1{
            for view in melodySlotViews[i].subviews {
//                let melody = view as! MelodyThumbnail
                collectedMelodies.append(melodiesInSack[i])
            }
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
        
        let view = sender.view as! MelodyImage

        let translation = sender.translation(in: self)
        
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
            
            if sender.location(in: self).y <= -view.frame.height*3 {
                removeMelodyFromSack(view)
            } else {
                view.moveViewTo(CGPoint.zero, time: 0.4)
            }
        }
        
    }
    
    @objc func handleMelodyTap(_ sender: UITapGestureRecognizer){
        let view = sender.view as! MelodyImage
        
//        Sound.sharedInstance.playPattern(view.number)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
