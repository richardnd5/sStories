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
        changeOpacityOverTime(view: self, time: 1.5, opacity: 1.0, {})
        adjustsFontSizeToFitWidth = true
    }

    func remove(fadeTime: Double,_ completion: @escaping () ->()){
        
        UIView.animate(
            withDuration: fadeTime,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.alpha = 0.000000001
        },
            completion: {
                _ in
                completion()
                self.removeFromSuperview()
        })
    }
    
    func changeText(to: String){
        text = to
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
