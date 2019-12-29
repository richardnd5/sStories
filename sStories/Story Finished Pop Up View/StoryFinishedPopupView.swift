import UIKit

class StoryFinishedPopUpView: UIView {
    
    var label : UILabel!
    var okayButton : OkayButton!
    var downArrow : ImageViewClass!

    let relativeFontConstant:CGFloat = 0.086
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        expandIn(time: 0.9)
        backgroundColor = UIColor(white: 0.6, alpha: 1.0)
        setupViews()
    }
    
    func setupViews(){
        label = UILabel()
        label.font = UIFont(name: "Avenir Light", size: 12)
        label.text = "Remember all the bubbles you popped? You can make music with them below!"
        label.numberOfLines = 0
        label.textAlignment = .center
        addSubview(label)
    
        okayButton = OkayButton(frame: .zero, name: "Got it!")
        addSubview(okayButton)
        
        downArrow = ImageViewClass(frame: .zero, "downArrowGrey")
        addSubview(downArrow)
    }
    
    func setupLayout(){
        let fontSize = frame.height * relativeFontConstant
        label.font = UIFont(name: "Avenir Light", size: fontSize)
        let safe = safeAreaLayoutGuide
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/10).isActive = true
        label.centerXAnchor.constraint(equalTo: safe.centerXAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        label.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let size = CGSize(width: frame.width/6, height: frame.height/8)
        okayButton.translatesAutoresizingMaskIntoConstraints = false
        okayButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4).isActive = true
        okayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        okayButton.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        okayButton.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        downArrow.translatesAutoresizingMaskIntoConstraints = false
        downArrow.topAnchor.constraint(equalTo: okayButton.bottomAnchor, constant: 4).isActive = true
        downArrow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        downArrow.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        downArrow.widthAnchor.constraint(equalTo: downArrow.heightAnchor, multiplier: 1).isActive = true
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width/10
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


