import UIKit
import AudioKit


class PianoKey : UIView {
    
    var keyNumber : MIDINoteNumber!
    var type : KeyType!
    var overlay = UIView()
    var keyIsActive = false
    var audio : PianoKeyAudioFile!
    
    init(frame: CGRect, type: KeyType, keyNumber: MIDINoteNumber){
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
        
        audio = PianoKeyAudioFile()
        
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
    
    func playKey(){
        overlay.alpha = 0.4
//        audio.play()
        Sound.sharedInstance.playNote(keyNumber)
        keyIsActive = true
    }
    
    func stopKey(){
        overlay.alpha = 0
//        audio.stop()
        Sound.sharedInstance.stopNote(keyNumber)
        keyIsActive = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
