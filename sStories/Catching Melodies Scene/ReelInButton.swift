import UIKit

class ReelInButton: UIButton {
    
    var name : String!
    weak var delegate : SceneDelegate?
    weak var pageDelegate : PageDelegate?
    weak var catchingMelodyDelegate : CatchingMelodyProtocol?
    var textLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        name = "reelInButton"
        addTextLabel()
        setTouchEvents()
        setTag()
        layer.cornerRadius = frame.width/2
        backgroundColor = UIColor(red: 212/255, green: 216/255, blue: 51/255, alpha: 1.0)
        
        let reelInWidth = frame.width/30
        addBlurBorder(dx: reelInWidth, dy: reelInWidth, cornerWidth: frame.width/2, cornerHeight: frame.width/2)
        throbWithWiggle(scaleTo: 1.07, time: 0.18)
        
        alpha = 0.0
        fadeTo(opacity: 1.0, time: 0.4)
        scaleTo(scaleTo: 0.0, time: 0.0)
        scaleTo(scaleTo: 1.0, time: 0.4, {
            self.bigWiggle()
        })
    }
    
    func addTextLabel(){
        let fr = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        textLabel = UILabel(frame: fr)
        textLabel.backgroundColor = .clear
        textLabel.textAlignment = .center
        textLabel.text = "Catch!"
        textLabel.font = UIFont(name: "Papyrus", size: frame.width/5)
        addSubview(textLabel)
    }
    
    private func setImage(){
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
    
    func setTag() {
        switch name {
        case "about":
            tag = ButtonTypee.about.rawValue
        case "read":
            tag = ButtonTypee.read.rawValue
        case "back":
            tag = ButtonTypee.back.rawValue
        case "exit":
            tag = ButtonTypee.back.rawValue
        case "nextArrow":
            tag = ButtonTypee.next.rawValue
        case "reelInButton":
            tag = ButtonTypee.reelIn.rawValue
        default:
            tag = ButtonTypee.next.rawValue
        }
    }
    
    func fadeIn(_ time: Double = 1){
        fadeTo(opacity: 1.0, time: time)
        textLabel.fadeTo(opacity: 1.0, time: time)
    }
    
    func fadeOut(_ time: Double = 1){
        fadeTo(opacity: 0.0, time: time, {
            self.scaleTo(scaleTo: 1, time: 0.0, isSpringy: false)
        })
    }
    
    @objc private func touchDown(_ sender: UIButton?) {
        layer.removeAllAnimations()
        sender!.scaleTo(scaleTo: 0.8, time: 0.4)
        if sender!.tag != ButtonTypee.next.rawValue {
            playSoundClip(.buttonDown)
        } else {
            playSoundClip(.touchDown)
        }
    }
    
    func resetButton(){
        textLabel.fadeTo(opacity: 1.0, time: 0.0)
        scaleTo(scaleTo: 1.0, time: 0.0)
    }
    
    @objc private func touchUpInside(_ sender: UIButton?) {
        catchingMelodyDelegate!.reelIn()
        fadeAndRemove(time: 0.8)
        scaleTo(scaleTo: 80, time: 1.0, isSpringy: false)
        textLabel.fadeTo(opacity: 0.0, time: 0.2)
    }
    
    @objc private func touchUpOutside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
        throbWithWiggle(scaleTo: 1.1, time: 0.18)
        bigWiggle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
