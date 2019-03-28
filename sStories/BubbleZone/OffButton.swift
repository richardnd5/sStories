import UIKit

class OffButton: UIButton {
    
    weak var delegate : ButtonDelegate?
    var isActive = false {
        didSet {
            togglePulse(active: isActive)
        }
    }
    var chordString : String!
    var chordType : ChordType!
    
    var numeralImage : UIImageView!
    
    var isImageOn = false
    
    init(frame: CGRect, chord: ChordType) {
        super.init(frame: frame)
        self.chordType = chord
        chordString = getChordString(chord: chordType)
        setImage(name: chordString)
        
        setTouchEvents()
        alpha = 0.0
        
    }
    
    private func getChordString(chord: ChordType) -> String {
        
        return "soundOff"
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
    
    func switchImageToOn(){
        if !isImageOn {
            isImageOn = true
            let imageSize = CGRect(x: 0, y: 0, width: 700, height: 700)
            numeralImage.image = resizedImage(name: "soundOn", frame: imageSize)
        }
    }
    
    func switchImageToOff(){
        if isImageOn {
            isImageOn = false
            let imageSize = CGRect(x: 0, y: 0, width: 700, height: 700)
            numeralImage.image = resizedImage(name: "soundOff", frame: imageSize)
        }
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
