import UIKit

class Button: UIButton {
    
    var name : String!
    weak var delegate : SceneDelegate?
    weak var pageDelegate : PageDelegate?
    weak var catchingMelodyDelegate : CatchingMelodyProtocol?
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.name = name
        
        
        setImage()
        setTouchEvents()
        setTag()
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
    }
    
    func fadeOut(_ time: Double = 1){
        fadeTo(opacity: 0.0, time: time)
    }
    
    // button touch events
    @objc private func touchDown(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 0.8, time: 0.4)
        if sender!.tag != ButtonTypee.next.rawValue {
        playSoundClip(.buttonDown)
        } else {
            playSoundClip(.touchDown)
        }

    }
    
    @objc private func touchUpInside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
        
        if sender!.tag == ButtonTypee.about.rawValue {
            delegate?.goToAboutPage()
            playSoundClip(.buttonUp)
        } else if sender!.tag == ButtonTypee.read.rawValue {
            delegate?.startStory()
            playSoundClip(.buttonUp)
//            Sound.sharedInstance.openingMusic.stopLoop()
            playSoundClip(.pageTurn)
        }  else if sender!.tag == ButtonTypee.back.rawValue {
            delegate?.goToHomePage()
            playSoundClip(.buttonUp)
        }  else if sender!.tag == ButtonTypee.next.rawValue {
            delegate?.nextMoment()
            playSoundClip(.touchUp)
        } else if sender!.tag == ButtonTypee.reelIn.rawValue {
            catchingMelodyDelegate!.reelIn()
            
        }
    }
    
    @objc private func touchUpOutside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
