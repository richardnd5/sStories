import UIKit

class NewChordSwitchButton: UIButton {
    
    weak var delegate : ButtonDelegate?
    var isActive = false {
        didSet {
            togglePulse(active: isActive)
        }
    }
    var chordString : String!
    var chordType : ChordType!
    
    var numeralImage : UIImageView!
    
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
        case .off:
            str = "soundOff"
        }
        return str
    }
    
    private func setImage(name: String){
        
        numeralImage = UIImageView()
        
        let imageSize = CGRect(x: 0, y: 0, width: 700, height: 700)
        numeralImage.image = resizedImage(name: name, frame: imageSize)
        numeralImage.contentMode = .scaleAspectFit
        adjustsImageWhenHighlighted = false
        addSubview(numeralImage)
        
        numeralImage.fillSuperview()
    }
    
    private func setTouchEvents(){
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
    }
    
    func fadeIn(){
        fadeTo(opacity: 1.0, time: 1.0)
    }
    func fadeOut(){
        fadeTo(opacity: 0.0, time: 1.0)
    }
    
    
    func togglePulse(active: Bool){
        active ? (throbWithWiggle(scaleTo: 1.2, time: 0.5)) : (layer.removeAllAnimations())
    }
    
    // button touch events
    @objc private func touchDown(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 0.8, time: 0.4)
        
    }
    
    @objc private func touchUpInside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1.0, time: 0.1)

        delegate?.chordButtonTapped(chord: chordType)
    }
    
    @objc private func touchUpOutside(_ sender: UIButton?) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
