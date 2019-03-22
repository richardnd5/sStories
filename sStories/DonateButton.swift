import UIKit

class DonateButton: UIButton {
    
    var name : String!
    weak var delegate : SceneDelegate?

    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.name = name
    
        print("button!   \(name)")
        setTouchEvents()
        

//        setTitleColor(.red, for: .normal)
//        backgroundColor = UIColor(hue: CGFloat.random(in: 0.0...1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
//        titleLabel?.font = UIFont(name: "Avenir Light", size: 20)
//        setTitleColor(.black, for: .normal)
        
//        for state: UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
//            setTitle(NSLocalizedString("Title", comment: ""), for: state)
//        }
        
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
    }
    
    @objc private func touchUpInside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
        playSoundClip(.buttonUp)
    }
    
    @objc private func touchUpOutside(_ sender: UIButton?) {
        sender!.scaleTo(scaleTo: 1, time: 0.4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width/10
        backgroundColor = .blue
        setTitle(name, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.textAlignment = .center

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
