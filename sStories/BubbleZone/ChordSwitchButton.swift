import UIKit

enum ChordType {
    case I
    case IV
    case V
}

class ChordSwitchButton: UIButton {
    
    weak var delegate : ButtonDelegate?
    var isActive = false {
        didSet {
         togglePulse(active: isActive)
        }
    }
    var chordString : String!
    var chordType : ChordType!
    
    init(frame: CGRect, chord: ChordType) {
        super.init(frame: frame)
        self.chordType = chord
        chordString = getChordString(chord: chordType)
        setImage(name: chordString)
        setTouchEvents()
        alpha = 0.0

        
    }
    
    private func getChordString(chord: ChordType) -> String {
        var str : String!
        switch chord {
        case .I:
            str =  "I"
        case .IV:
            str = "IV"
        case .V:
            str = "V"
        }
        return str
    }
    
    private func setImage(name: String){
        let imageSize = CGRect(x: 0, y: 0, width: 700, height: 700)
        setImage(resizedImage(name: name, frame: imageSize), for: .normal)
        contentMode = .scaleAspectFit
        adjustsImageWhenHighlighted = false
    }
    
    private func setTouchEvents(){
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
    }
    
    func fadeIn(){
        fadeTo(time: 1.0, opacity: 1.0)
    }
    func fadeOut(){
        fadeTo(time: 1.0, opacity: 0.0)
    }
    
    
    func togglePulse(active: Bool){
        active ? (throbWithWiggle(scaleTo: 1.2, time: 0.5)) : (layer.removeAllAnimations())
    }
    
    // button touch events
    @objc private func touchDown(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 0.8, time: 0.4)

    }
    
    @objc private func touchUpInside(_ sender: UIButton?) {
        delegate?.chordButtonTapped(chord: chordType)
    }
    
    @objc private func touchUpOutside(_ sender: UIButton?) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
 Tap and hold and pan a note value.
 plays a sustained oscilator with filter. Section off screen for diatonicism
 */
