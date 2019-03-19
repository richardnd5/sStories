import UIKit

class DonatePopUpView: UIView {
    
    var label : UILabel!
    var oneDollarButton : Button!
    var twoDollarButton : Button!
    var fiveDollarButton : Button!
    var tenDollarButton : Button!
    var cancelButton : Button!

    var stackView : UIStackView!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        
        alpha = 0.0
        fadeTo(opacity: 1.0, time: 1.0)
        
    }
    
    func setupViews(){
        label = UILabel()
        label.font = UIFont(name: "Avenir Light", size: 24)
        label.text = "Help us keep making things for you by donating!"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        oneDollarButton = Button(frame: .zero, name: "wholeNote")
        twoDollarButton = Button(frame: .zero, name: "wholeNote")
        fiveDollarButton = Button(frame: .zero, name: "wholeNote")
        tenDollarButton = Button(frame: .zero, name: "wholeNote")
        cancelButton = Button(frame: .zero, name: "off")
        
        addSubview(label)
//        addSubview(oneDollarButton)
//        addSubview(twoDollarButton)
//        addSubview(fiveDollarButton)
//        addSubview(tenDollarButton)
//        addSubview(cancelButton)
        

    }
    
    func setupLayout(){
        let safe = safeAreaLayoutGuide
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/10).isActive = true
        label.centerXAnchor.constraint(equalTo: safe.centerXAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: frame.height/6).isActive = true

        stackView = UIStackView(arrangedSubviews: [oneDollarButton, twoDollarButton, fiveDollarButton, tenDollarButton, cancelButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)

        let padding = frame.width/20

        [stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -frame.height/7),
        stackView.heightAnchor.constraint(equalToConstant: frame.width/10),
         stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
         stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)].forEach { $0.isActive = true }
    }
    
    
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width/10
        setupLayout()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
