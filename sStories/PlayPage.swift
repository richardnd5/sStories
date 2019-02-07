import UIKit


class PlayPage: UIView {
    
    var isActive = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawKeyboard()
        clipsToBounds = true
    }
    
    func toggleKeyboard(){
        
        if !isActive {
            isActive = true
            scaleTo(scaleTo: 1.0, time: 1.5)
        } else {
            isActive = false
            scaleTo(scaleTo: 0.2, time: 1.5)
        }
    }
    
    func drawKeyboard(){
        let whiteKeyNumbers = [60,62,64,65,67,69,71,72,74,76,77,79,81,83,84]
        let blackKeyNumbers = [61,63,0,66,68,70,0,73,75,0,78,80,82,0,85]
        var whiteKeyArray = [Key]()
        var blackKeyArray = [Key]()
        
        layer.zPosition = 200
        let numberOfWhiteKeys : CGFloat = 12
        
        let whiteKeyWidth = frame.width/numberOfWhiteKeys
        let blackKeyWidth = whiteKeyWidth*0.68
        let blackKeyHeight = frame.height*0.64
        
        // add white keys
        for i in 0...Int(numberOfWhiteKeys)-1 {
            let fr = CGRect(x: whiteKeyWidth*CGFloat(i), y: 0, width: whiteKeyWidth, height: frame.height)
            let key = Key(frame: fr, type: .white, keyNumber: whiteKeyNumbers[i])
            addSubview(key)
            whiteKeyArray.append(key)
        }
        
        // add black keys
        for i in 0...whiteKeyArray.count-1 {
            if i <= blackKeyNumbers.count-1 {
                if blackKeyNumbers[i] == 0 {
                    continue
                } else {
                    let frame = CGRect(x: whiteKeyArray[i].frame.midX+blackKeyWidth/4, y: 0, width: blackKeyWidth, height: blackKeyHeight)
                    let key = Key(frame: frame, type: .black, keyNumber: blackKeyNumbers[i])
                    addSubview(key)
                    blackKeyArray.append(key)
                    
                }
            }
        }
        scaleTo(scaleTo: 0.2, time: 0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum type {
    case white
    case black
}

class Key : UIView {
    
    var keyNumber : Int!
    var type : type!
    var overlay = UIView()
    
    init(frame: CGRect, type: type, keyNumber: Int){
        super.init(frame: frame)
        self.keyNumber = keyNumber
        self.type = type
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        setupTouchDown()
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
    
    func setupTouchDown(){
        let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
        press.minimumPressDuration = 0
        addGestureRecognizer(press)
    }
    
    @objc func handlePress(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            playNote(keyNumber)
            overlay.alpha = 0.4
            
        } else if sender.state == .ended {
            stopNote(keyNumber)
            overlay.alpha = 0
        }
    }
    
    func playNote(_ note: Int){
        print("play note: \(note)")
    }
    
    func stopNote(_ note: Int){
        print("stop note: \(note)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
