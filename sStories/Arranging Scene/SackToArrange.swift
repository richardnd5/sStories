import UIKit

class SackToArrange: UIView {
    
    let rows = 6
    let spacing : CGFloat = 20
    var slotWidth : CGFloat!
    var melodySlotViews = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        slotWidth = frame.width/CGFloat(rows)
        createArrangementSlots()
    }
    
    func createArrangementSlots() {
        
        for i in 0..<rows {
            
            let view = UIView(frame: CGRect(x: CGFloat(i)*slotWidth, y: 0, width: slotWidth-spacing, height: slotWidth-spacing))
            view.layer.cornerRadius = view.frame.height/10
            view.backgroundColor = UIColor.init(white: 0.9, alpha: 0.3)
            view.isUserInteractionEnabled = true
            melodySlotViews.append(view)
            addSubview(view)
            addDashedBorder(view)
            
        }
    }
    
    func addDashedBorder(_ view: UIView) {
        let color = UIColor.white.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = CGSize(width: slotWidth-spacing, height: slotWidth-spacing)
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: frameSize.height/10).cgPath
        
        view.layer.addSublayer(shapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
