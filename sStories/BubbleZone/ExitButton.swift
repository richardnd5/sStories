import UIKit

class ExitButton: UIButton {
    
    weak var delegate : ButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage()
        setTouchEvents()
        alpha = 0.0
    }
    
    private func setImage(){
        let imageSize = CGRect(x: 0, y: 0, width: 700, height: 700)
        setImage(resizedImage(name: "exit", frame: imageSize), for: .normal)
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
    
    // button touch events
    @objc private func touchDown(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 0.8, time: 0.4)
        playSoundClip(.buttonDown)
        
    }
    
    @objc private func touchUpInside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
        playSoundClip(.buttonUp)
        delegate?.exitButtonTapped()
    }
    
    @objc private func touchUpOutside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

