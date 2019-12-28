import UIKit

class DonateButton: UIButton {
    var name : DonationAmount!
    weak var delegate : SceneDelegate?

    init(frame: CGRect, name: DonationAmount) {
        super.init(frame: frame)
        self.name = name
        setTouchEvents()
    }

    private func setTouchEvents(){
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
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
        playSoundClip(.buttonDown)
        Haptics.shared.vibrate(.light)
    }
    
    @objc private func touchUpInside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
        playSoundClip(.buttonUp)
        Haptics.shared.vibrate(.medium)
    }
    
    @objc private func touchUpOutside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width/10
        backgroundColor = .blue
        setTitle(name.map { $0.rawValue }, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.textAlignment = .center

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
