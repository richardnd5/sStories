import UIKit
import AudioKit

protocol ButtonDelegate : class {
    func exitButtonTapped()
}

class PianoKeyboard: UIView, ButtonDelegate {
    
    var keyboardIsActive = false
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
        scaleTo(scaleTo: 0.12, time: 0.0)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pan.maximumNumberOfTouches = 1
        addGestureRecognizer(pan)

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !keyboardIsActive {
            toggleKeyboard()
        }
        else {
            for touch in touches {
                let location = touch.location(in: self)
                checkIfKeyPlayingInLocation(location)
            }
        }
    }
    
    func checkIfKeyPlayingInLocation(_ location: CGPoint){
        blackKeyArray.forEach { view in
            if view.frame.contains(location) && !keyPlaying {
                
                view.playKey()
                activatedKey = view
                keyPlaying = true
            }
        }
        whiteKeyArray.forEach { view in
            if view.frame.contains(location) && !keyPlaying {
                
                view.playKey()
                activatedKey = view
                keyPlaying = true
            }
        }
    }
    
    var activatedKey : PianoKey!
    var keyPlaying = false
    @objc func handlePan(_ sender: UIPanGestureRecognizer){
        if keyboardIsActive {
            let location = sender.location(in: self)
            
            if sender.state == .began {
                checkIfKeyPlayingInLocation(location)
            }
            
            if sender.state == .changed {
                if !activatedKey.frame.contains(location) {
                    activatedKey.stopKey()
                    keyPlaying = false
                    
                }
                checkIfKeyPlayingInLocation(location)
            }
            else if sender.state == .ended {
                //                if sender.view!.frame.contains(location){
                if sender.view is PianoKey {
                    let key = sender.view as! PianoKey
                    key.stopKey()
                    activatedKey.stopKey()
                    activatedKey = nil
                    keyPlaying = false
                    //                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print(touches.count)
        if keyboardIsActive {
            for touch in touches {
                let location = touch.location(in: self)
                subviews.forEach { view in
                    if view.frame.contains(location){
                        let key = view as! PianoKey
                        if activatedKey != nil {
                            key.stopKey()
                            activatedKey.stopKey()
                            activatedKey = nil
                            keyPlaying = false
                        }
                    }
                }
            }
        }
    }
    
    func exitButtonTapped(){
        toggleKeyboard()
    }

    
    // This function is used to detect touch events on views outside the superview's bounds
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let translatedPoint = exitButton.convert(point, from: self)
        
        if (exitButton.bounds.contains(translatedPoint)) {
            return exitButton.hitTest(translatedPoint, with: event)
        }
        return super.hitTest(point, with: event)
    }
    
    
    func toggleKeyboard(){
        
        if !keyboardIsActive {
            keyboardIsActive = true
            scaleTo(scaleTo: 1.0, time: 1, {
                self.exitButton.fadeIn()
            })
            let point = CGPoint(x: initialPosition.x, y: (superview?.frame.midY)!-frame.height/2)
            moveViewTo(point, time: 1)
            whiteKeyArray.forEach { key in
                key.toggleActive()
            }
            blackKeyArray.forEach { key in
                key.toggleActive()
            }
        } else {
            keyboardIsActive = false
            scaleTo(scaleTo: 0.12, time: 1)
            exitButton.fadeOut()
            
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
            let key = PianoKey(frame: fr, type: .white, keyNumber: MIDINoteNumber(whiteKeyNumbers[i]))
            addSubview(key)
            whiteKeyArray.append(key)
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            key.addGestureRecognizer(pan)
        }
        
        // add black keys
        for i in 0...whiteKeyArray.count-1 {
            if i <= blackKeyNumbers.count-1 {
                if blackKeyNumbers[i] == 0 {
                    continue
                } else {
                    let frame = CGRect(x: whiteKeyArray[i].frame.midX+blackKeyWidth/4, y: 0, width: blackKeyWidth, height: blackKeyHeight)
                    let key = PianoKey(frame: frame, type: .black, keyNumber: MIDINoteNumber(blackKeyNumbers[i]))
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


