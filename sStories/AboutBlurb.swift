import UIKit

class AboutBlurb: UIView {
    
    private let textBlurb: UILabel = {
//        let textView = UILabel(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
        let textView = UILabel()
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.numberOfLines = 0
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let line: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    
    
    init(frame: CGRect, text: String, imageName: String = "8thThumb") {
        super.init(frame: frame)
        
        imageView.image = resizedImage(name: "\(imageName)")
    
        
        let fontSize : CGFloat = 30
        textBlurb.text = text
        textBlurb.font = UIFont(name: "Papyrus", size: fontSize)
        textBlurb.minimumScaleFactor = 0.5
        textBlurb.adjustsFontSizeToFitWidth = true
        textBlurb.numberOfLines = 0
        
        setupLayout()
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupLayout(){
        
        let safe = safeAreaLayoutGuide
        let padding : CGFloat = 60
        
        let textHoldingView = UIView()
        addSubview(textHoldingView)

        textHoldingView.translatesAutoresizingMaskIntoConstraints = false
        textHoldingView.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        textHoldingView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        textHoldingView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20).isActive = true
        textHoldingView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20).isActive = true

        textHoldingView.addSubview(textBlurb)
        textBlurb.fillSuperview()
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: textBlurb.bottomAnchor, constant: padding).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding).isActive = true
        line.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        line.widthAnchor.constraint(equalToConstant: 60).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
