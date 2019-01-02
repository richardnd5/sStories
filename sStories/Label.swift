import UIKit


class Label: UILabel {
    init(frame: CGRect, words: String, fontSize: CGFloat){
        super.init(frame: frame)
        text = words
        font = UIFont(name: "Papyrus", size: fontSize)
        textColor = .white
        textAlignment = .center
        sizeToFit()
        
        alpha = 0.0
        fadeTo(time: 2.0, opacity: 1.0, {})
    }
    
    func fadeTo(time: Double,opacity: CGFloat, _ completion: @escaping () ->()){
        
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.alpha = opacity
        },
            completion: {
                _ in
                completion()
        })
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
