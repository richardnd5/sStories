import UIKit

class MelodySlots: UIView {
    
    private let rows = 6
    private let spacing : CGFloat = 20
    private var slotWidth : CGFloat!
    var slotPosition = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        slotWidth = frame.width/CGFloat(rows)
        createArrangementSlots()
    }
    
    private func createArrangementSlots() {
        
        for i in 0..<rows {
            
            let view = UIView(frame: CGRect(x: CGFloat(i)*slotWidth, y: 0, width: slotWidth-spacing, height: slotWidth-spacing))
            view.layer.cornerRadius = view.frame.height/10
            view.backgroundColor = UIColor.init(white: 0.9, alpha: 0.3)
            view.isUserInteractionEnabled = true
            slotPosition.append(view)
            addSubview(view)
            view.addDashedBorder()
            
            let thumbnail = transparentMelody(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), typeNumber: i)
            view.addSubview(thumbnail)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
