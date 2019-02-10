import UIKit

enum keyType {
    case white
    case black
}

protocol ButtonDelegate : class {
    func exitButtonTapped()
}

class PianoKeyboard: UIView, ButtonDelegate {
    
    var isActive = false
    var initialPosition : CGPoint!
    
    var whiteKeyArray = [PianoKey]()
    var blackKeyArray = [PianoKey]()
    var exitButton : ExitButton!
    var tap : UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialPosition = CGPoint(x: frame.minX, y: frame.minY)
        drawKeyboard()
        createExitButton()
        scaleTo(scaleTo: 0.05, time: 0.0)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        tap.isEnabled = false
        toggleKeyboard()
    }
    
    func exitButtonTapped(){
        toggleKeyboard()
        tap.isEnabled = true
    }
    
    var wasPlayed = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isActive {
            print("touch began")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isActive {
            print("touch moved")
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isActive {
            print("touch ended")
        }
    }
    
    // This function is used to detect touch events on views outside the superview's bounds
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let translatedPoint = exitButton.convert(point, from: self)
        
        if (exitButton.bounds.contains(translatedPoint)) {
            print("Your button was pressed")
            return exitButton.hitTest(translatedPoint, with: event)
        }
        return super.hitTest(point, with: event)
    }
    
    
    func toggleKeyboard(){
        
        if !isActive {
            isActive = true
            scaleTo(scaleTo: 1.0, time: 1)
            let point = CGPoint(x: initialPosition.x, y: (superview?.frame.midY)!-frame.height/2)
            moveViewTo(point, time: 1)
            whiteKeyArray.forEach { key in
                key.toggleActive()
            }
            blackKeyArray.forEach { key in
                key.toggleActive()
            }
        } else {
            isActive = false
            scaleTo(scaleTo: 0.05, time: 1)
            
            let bottomPadding = superview!.frame.height/30
            let selfPadding = frame.height
            let x = (superview?.frame.midX)!-frame.width/2
            let y = (superview?.frame.maxY)!-frame.height-selfPadding-bottomPadding
            let point = CGPoint(x: x, y: y)
            moveViewTo(point, time: 1)
            
            whiteKeyArray.forEach { key in
                key.toggleActive()
            }
            blackKeyArray.forEach { key in
                key.toggleActive()
            }
            
        }
    }
    
    func createExitButton(){
        exitButton = ExitButton()
        addSubview(exitButton)
        exitButton.delegate = self
        
        let size = frame.height/10
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        exitButton.topAnchor.constraint(equalTo: topAnchor, constant: -size).isActive = true
    }
    
    @objc func handleExitTap(){
        toggleKeyboard()
    }
    
    func drawKeyboard(){
        let whiteKeyNumbers = [60,62,64,65,67,69,71,72,74,76,77,79,81,83,84]
        let blackKeyNumbers = [61,63,0,66,68,70,0,73,75,0,78,80,82,0,85]
        
        
        layer.zPosition = 200
        let numberOfWhiteKeys : CGFloat = 12
        
        let whiteKeyWidth = frame.width/numberOfWhiteKeys
        let blackKeyWidth = whiteKeyWidth*0.68
        let blackKeyHeight = frame.height*0.64
        
        // add white keys
        for i in 0...Int(numberOfWhiteKeys)-1 {
            let fr = CGRect(x: whiteKeyWidth*CGFloat(i), y: 0, width: whiteKeyWidth, height: frame.height)
            let key = PianoKey(frame: fr, type: .white, keyNumber: whiteKeyNumbers[i])
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
                    let key = PianoKey(frame: frame, type: .black, keyNumber: blackKeyNumbers[i])
                    addSubview(key)
                    blackKeyArray.append(key)
                    
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

