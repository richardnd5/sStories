import UIKit

class DonatePopUpView: UIView {
    
    
    var label : UILabel!
    var oneDollarButton : DonateButton!
    var twoDollarButton : DonateButton!
    var fiveDollarButton : DonateButton!
    var tenDollarButton : DonateButton!
    var cancelButton : DonateButton!

    var stackView : UIStackView!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        expandIn(time: 0.9)
        backgroundColor = .white
        setupViews()
        
//        fadeTo(opacity: 1.0, time: 1.0)
        
        IAPService.shared.getProducts()
        
        IAPService.shared.purchase(product: .nonConsumable)
        
    }
    
    func setupViews(){
        label = UILabel()
        label.font = UIFont(name: "Avenir Light", size: 24)
        label.text = "Help us keep creating things for you by donating!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        oneDollarButton = DonateButton(frame: .zero, name: "$1")
        twoDollarButton = DonateButton(frame: .zero, name: "$2")
        fiveDollarButton = DonateButton(frame: .zero, name: "$5")
        tenDollarButton = DonateButton(frame: .zero, name: "$10")
        cancelButton = DonateButton(frame: .zero, name: "No, Thanks")
        
        addSubview(label)

    }
    
    func setupLayout(){
        let safe = safeAreaLayoutGuide
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/10).isActive = true
        label.centerXAnchor.constraint(equalTo: safe.centerXAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: frame.height/6).isActive = true

        
        stackView = UIStackView(arrangedSubviews: [oneDollarButton, twoDollarButton, fiveDollarButton, tenDollarButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        
        addSubview(stackView)
        let padding = frame.width/20
        let iconSize = frame.height/4

        [stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: frame.height/7),
        stackView.heightAnchor.constraint(equalToConstant: iconSize),
         stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
         stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)].forEach { $0.isActive = true }
        
        stackView.arrangedSubviews.forEach { view in
            view.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        }
        
        
        addSubview(cancelButton)
        let size = CGSize(width: frame.width/6, height: frame.height/8)
        cancelButton.centerXAndSize(size: size, top: stackView.bottomAnchor, topPadding: frame.height/20)
    }
    
    
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width/10
        setupLayout()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
