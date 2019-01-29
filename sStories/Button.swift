import UIKit

class Button: UIButton {
    
    var name : String!
//    weak var delegate : ButtonDelegate?
    weak var delegate : SceneDelegate?
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.name = name
        
        setImage()
        setTouchEvents()
        tag = setTag(name: name).rawValue
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
    
    func setTag(name: String) -> ButtonTypee {
        switch name {
        case "about":
            return ButtonTypee.about
        case "read":
            return ButtonTypee.read
        case "back":
            return ButtonTypee.back
        default:
            return ButtonTypee.normal
        }
    }
    
    // button touch events
    @objc private func touchDown(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 0.8, time: 0.1)
    }
    
    @objc private func touchUpInside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.1)
        
        if sender!.tag == ButtonTypee.about.rawValue {
            delegate?.goToAboutPage()
        } else if sender!.tag == ButtonTypee.read.rawValue {
            delegate?.startStory()
        }  else if sender!.tag == ButtonTypee.back.rawValue {
            delegate?.goToHomePage()
        }
        
    }
    
    @objc private func touchUpOutside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
