import UIKit

class DonatePopUpView: UIView {
    
    var label : UILabel!
    var oneDollarButton : DonateButton!
    var twentyDollarButton : DonateButton!
    var fiveDollarButton : DonateButton!
    var tenDollarButton : DonateButton!
    var cancelButton : DonateButton!

    var donateStackView : UIStackView!
    let relativeFontConstant:CGFloat = 0.046
    
    var loadingSpinner : LoadingAnimationView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        expandIn(time: 0.9)
        backgroundColor = .white
        setupViews()

    }
    
    func setupViews(){
        
        label = UILabel()
        label.font = UIFont(name: "Avenir Light", size: 12)
        label.text = "More stories to come! We want to make apps like this for a living. Help us do that by donating!"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        oneDollarButton = DonateButton(frame: .zero, name: "$1")
        fiveDollarButton = DonateButton(frame: .zero, name: "$5")
        tenDollarButton = DonateButton(frame: .zero, name: "$10")
        twentyDollarButton = DonateButton(frame: .zero, name: "$20")
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
        
        addSubview(cancelButton)
        let size = CGSize(width: frame.width/6, height: frame.height/8)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -frame.height/8).isActive = true

        donateStackView = UIStackView(arrangedSubviews: [oneDollarButton, fiveDollarButton, tenDollarButton, twentyDollarButton])
        donateStackView.translatesAutoresizingMaskIntoConstraints = false
        donateStackView.axis = .horizontal
        donateStackView.distribution = .equalCentering
        
        addSubview(donateStackView)
        let padding = frame.width/20
        let iconSize = frame.width/6

        [donateStackView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -frame.height/7),
        donateStackView.heightAnchor.constraint(equalToConstant: iconSize),
         donateStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
         donateStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)].forEach { $0.isActive = true }
        
        donateStackView.arrangedSubviews.forEach { view in
            view.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        }

    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width/10
        setupLayout()

    }
    
    func showLoadingSpinner(){
        
        
        for view in donateStackView.arrangedSubviews {
            view.fadeTo(opacity: 0.0, time: 0.2)
        }
        loadingSpinner = LoadingAnimationView(frame: .zero)
        addSubview(loadingSpinner)
        loadingSpinner.alpha = 0.0
        loadingSpinner.fadeTo(opacity: 1.0, time: 0.5)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        
        [loadingSpinner.bottomAnchor.constraint(equalTo: centerYAnchor),
         loadingSpinner.topAnchor.constraint(equalTo: label.bottomAnchor),
         loadingSpinner.leftAnchor.constraint(equalTo: leftAnchor),
         loadingSpinner.rightAnchor.constraint(equalTo: rightAnchor)].forEach { $0.isActive = true }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


