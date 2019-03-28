import UIKit

class DonatePopUpView: UIView {
    
    var label : UILabel!
    var oneDollarButton : DonateButton!
    var twoDollarButton : DonateButton!
    var fiveDollarButton : DonateButton!
    var tenDollarButton : DonateButton!
    var cancelButton : DonateButton!

    var donateStackView : UIStackView!
    let relativeFontConstant:CGFloat = 0.046


 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        expandIn(time: 0.9)
        backgroundColor = .white
        setupViews()
        
//        IAPService.shared.getProducts()
        
//        IAPService.shared.purchase(product: .nonConsumable)
        
        
        
    }
    
    func setupViews(){
        
        label = UILabel()
        label.font = UIFont(name: "Avenir Light", size: 12)
        label.text = "We want to make apps like this for a living. Help us do that by donating!"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        oneDollarButton = DonateButton(frame: .zero, name: "$1")
        twoDollarButton = DonateButton(frame: .zero, name: "$2")
        fiveDollarButton = DonateButton(frame: .zero, name: "$5")
        tenDollarButton = DonateButton(frame: .zero, name: "$10")
        cancelButton = DonateButton(frame: .zero, name: "Nah")
        
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
        
        let fontSize = frame.height * relativeFontConstant
        label.font = UIFont(name: "Avenir Light", size: fontSize)

        
        donateStackView = UIStackView(arrangedSubviews: [oneDollarButton, twoDollarButton, fiveDollarButton, tenDollarButton])
        donateStackView.translatesAutoresizingMaskIntoConstraints = false
        donateStackView.axis = .horizontal
        donateStackView.distribution = .equalCentering
        
        addSubview(donateStackView)
        let padding = frame.width/20
        let iconSize = frame.width/6

        [donateStackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: frame.height/7),
        donateStackView.heightAnchor.constraint(equalToConstant: iconSize),
         donateStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
         donateStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)].forEach { $0.isActive = true }
        
        donateStackView.arrangedSubviews.forEach { view in
            view.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        }
        
        
        addSubview(cancelButton)
        let size = CGSize(width: frame.width/6, height: frame.height/8)
        cancelButton.centerXAndSize(size: size, top: donateStackView.bottomAnchor, topPadding: frame.height/20)
        

    }
    
    
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width/10
        setupLayout()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
