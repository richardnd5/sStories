import UIKit

class StoryIconNew: UIView {
    
    var name : String!
    weak var delegate : SceneDelegate?
    weak var pageDelegate : PageDelegate?
    weak var catchingMelodyDelegate : CatchingMelodyProtocol?
    var buttonImage : UIImage!
    
    var button : UIButton!
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.name = name
        
        button = UIButton()
        addSubview(button)
        
        setImage()
        setTouchEvents()
        setTag()
        
        if name == "templetonThumbnail" {
            button.backgroundColor = UIColor(hue: CGFloat.random(in: 0.0...1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        } else {
            button.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        }
        
    }
    
    func setImage(){
        let imageSize = CGRect(x: 0, y: 0, width: 700, height: 700)
        buttonImage = resizedImage(name: name, frame: imageSize)
        button.setImage(buttonImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        button.clipsToBounds = true
    }
    
    func resizeImage(to size: CGSize){
        let imageSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        buttonImage = resizedImage(name: name, frame: imageSize)
        button.setImage(buttonImage, for: .normal)
        button.contentMode = .scaleAspectFit
    }
    
    private func setTouchEvents(){
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
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
        //        delegate?.loadUpStory(name)
        
    }
    
    @objc private func touchUpOutside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
    }
    
    override func layoutSubviews() {
        setButtonConstraints()
        
        
    }
    
    func setButtonConstraints(){
        
//        let padding = frame.height/20
        button.layer.cornerRadius = frame.width/20
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: frame.height/1.5).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true

//        button.heightAnchor.constraint(equalToConstant: frame.height/1.5).isActive = true
//        button.widthAnchor.constraint(greaterThanOrEqualTo: button.heightAnchor).isActive = true
        
//        button.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
//        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
//        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
//        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        
        

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
