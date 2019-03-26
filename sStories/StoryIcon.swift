import UIKit

class StoryIcon: UIButton {
    
    var name : String!
    weak var delegate : SceneDelegate?
    weak var pageDelegate : PageDelegate?
    weak var catchingMelodyDelegate : CatchingMelodyProtocol?
    var buttonImage : UIImage!
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.name = name
        
        setImage()
        setTouchEvents()
        setTag()
        layer.cornerRadius = frame.width/10
        
        
        
    }
    
    private func setImage(){
        let imageSize = CGRect(x: 0, y: 0, width: 700, height: 700)
        buttonImage = resizedImage(name: name, frame: imageSize)
        setImage(buttonImage, for: .normal)
        contentMode = .scaleAspectFit
        adjustsImageWhenHighlighted = false
        clipsToBounds = true
    }
    
    func resizeImage(to size: CGSize){
        let imageSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        buttonImage = resizedImage(name: name, frame: imageSize)
        setImage(buttonImage, for: .normal)
        contentMode = .scaleAspectFit
    }
    
    private func setTouchEvents(){
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
    }
    
    func setTag() {
        tag = 100
    }
    
    func fadeIn(_ time: Double = 1){
        fadeTo(opacity: 1.0, time: time)
    }
    
    func fadeOut(_ time: Double = 1){
        fadeTo(opacity: 0.0, time: time)
    }
    
    // button touch events
    @objc private func touchDown(_ sender: UIButton?) {
        stopThrobWithAnimation({
            sender!.scaleTo(scaleTo: 0.8, time: 0.4)
        })

            playSoundClip(.buttonDown)

        
    }
    
    @objc private func touchUpInside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
        delegate?.loadUpStory(name)
        
    }
    
    @objc private func touchUpOutside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}