import UIKit

class Label: UILabel {
    init(frame: CGRect, words: String, fontSize: CGFloat){
        super.init(frame: frame)
        text = words
        font = UIFont(name: "Papyrus", size: fontSize)
        textColor = .white
        textAlignment = .center
        layer.zPosition = 10
        alpha = 0.0
        fadeTo(time: 1.5, opacity: 1.0, {})
        adjustsFontSizeToFitWidth = true
    }

    func changeText(to: String){
        text = to
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
