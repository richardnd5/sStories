import UIKit
import AudioKit


class PianoKey : UIView {
    
    var keyNumber : MIDINoteNumber!
    var type : KeyType!
    var overlay = UIView()
    var keyIsActive = false
//    var audio : PianoKeyAudioFile!
    
    var targetDot : UIView!
    var isTarget = false
    
    let blackKeyWidthMultiplier : CGFloat = 0.68
    let blackKeyHeightMultiplier : CGFloat = 0.64
    
    var beenTouched = false
    
    init(frame: CGRect, type: KeyType, keyNumber: MIDINoteNumber, _ isTarget: Bool = false){
        super.init(frame: frame)
        self.keyNumber = keyNumber
        self.type = type
        self.isTarget = isTarget
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
        clipsToBounds = true
    }

    
    func setupTargetDot(){
        
        isTarget = true

        var width = frame.width/3
        var height = frame.width/3
        var y = frame.height/1.5

        
        if type == .white {
            width = width*blackKeyWidthMultiplier
            height = height*blackKeyHeightMultiplier
            y = frame.height/1.3
        }
        
        let x = frame.width/2-width/2
        
        let fr = CGRect(x: x, y: y, width: width, height: height)
        targetDot = UIView(frame: fr)
        targetDot.backgroundColor = .red
        targetDot.layer.cornerRadius = width/2
        targetDot.alpha = 0.0
        targetDot.isUserInteractionEnabled = false
        addSubview(targetDot)
        
        targetDot.fadeTo(opacity: 1.0, time: 1.0)
        targetDot.throbWithWiggle(scaleTo: 1.5, time: 0.5)
        
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
    
//    func setupTouchDown(){
//        let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
//        press.minimumPressDuration = 0
//        addGestureRecognizer(press)
//    }

//    @objc func handlePress(_ sender: UILongPressGestureRecognizer){
//        if keyIsActive {
//            if sender.state == .began {
//                playKey()
//                
//            } else if sender.state == .ended {
//                stopKey()
//            }
//        }
//    }
    
    func increaseDot(){
        targetDot.stopThrobWithWiggle()
        targetDot.scaleTo(scaleTo: 50.0, time: 2.0)
        targetDot.changeBackgroundColorGraduallyTo(.blue, time: 1.0)
    }
    func decreaseDot(){
        targetDot.scaleTo(scaleTo: 1.0, time: 1.0)
    }
    
    func turnPageAnimationPlayNote(){
        let randomColor = UIColor(hue: CGFloat.random(in: 0...1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        targetDot.changeBackgroundColorGraduallyTo(randomColor, time: 1.0)
        Sound.shared.oldPlayNote(keyNumber)
    }
    
    func playKey(){
        
        Sound.shared.pianoSampler.play(noteNumber: keyNumber, velocity: 30)
        keyIsActive = true
        if keyIsActive {
            increaseDot()
            beenTouched = true
        }
    }
    
    func stopKey(){
        
        Sound.shared.pianoSampler.stop(noteNumber: keyNumber)
        keyIsActive = false

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
