import UIKit

class SackContents: UIView {
    
    var melodyImage: UIImageView?
    var melodySlots = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUIGrid()
        
//        let label = UILabel(frame: CGRect(x: -100, y: 0, width: 100, height: 100))
//        label.text = "Melodies Caught"
//        label.font = UIFont(name: "Papyrus", size: 20)
//        label.textColor = .white
//        label.numberOfLines = 2
//        label.backgroundColor = .red
//        addSubview(label)
        addMelodyToSlot(0)
        
    }
    
    func makeUIGrid() {
        
        let rows = 4
        let spacing : CGFloat = 10
        let width = frame.width/CGFloat(rows)
        let height = frame.height
        
        for i in 0..<rows {
            
            let view = UIView(frame: CGRect(x: CGFloat(i)*width, y: 0, width: width-spacing, height: height))
            view.layer.cornerRadius = view.frame.height/3
            view.addDashedBorder()
            melodySlots.append(view)
            addSubview(view)
        }
    }
    
    func addMelodyToSlot(_ number: Int){
        
        let x = melodySlots[number].frame.minX
        let y = melodySlots[number].frame.minY
        let width = melodySlots[number].frame.width
        let height = melodySlots[number].frame.height
        
        let melody = MelodyThumbnail(frame: CGRect(x: x, y: y, width: width, height: height))
        melodySlots[number].addSubview(melody)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
