import UIKit

class PianoKey : UIView {
    
    var keyNumber : Int!
    var type : keyType!
    var overlay = UIView()
    var isActive = false
    
    init(frame: CGRect, type: keyType, keyNumber: Int){
        super.init(frame: frame)
        self.keyNumber = keyNumber
        self.type = type
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        isUserInteractionEnabled = false
        //        setupTouchDown()
        setupOverlay()
        
        switch type {
        case .white:
            backgroundColor = .white
            overlay.backgroundColor = .black
        case .black:
            backgroundColor = .black
            overlay.backgroundColor = .white
        }
    }
    
    func setupOverlay(){
        
        let fr = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        overlay = UIView(frame: fr)
        overlay.alpha = 0
        overlay.isUserInteractionEnabled = false
        addSubview(overlay)
    }
    
    func toggleActive(){
        isUserInteractionEnabled.toggle()
    }
    
    func setupTouchDown(){
        let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
        press.minimumPressDuration = 0
        addGestureRecognizer(press)
    }
    
//    var wasPlayed = false
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        playKey()
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        stopKey()
//    }
    
    @objc func handlePress(_ sender: UILongPressGestureRecognizer){
        if isActive {
            if sender.state == .began {
                playKey()
                
            } else if sender.state == .ended {
                stopKey()
            }
        }
    }
    
    func playKey(){
        overlay.alpha = 0.4
        print("key number: \(keyNumber) played..")
    }
    
    func stopKey(){
        overlay.alpha = 0
        print("key number: \(keyNumber) stopped..")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
