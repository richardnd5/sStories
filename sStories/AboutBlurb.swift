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
    
    private let dividingLine: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    let fontSize : CGFloat = 30
    
    init(frame: CGRect, text: String, imageName: String = "8thThumb") {
        super.init(frame: frame)
        
        imageView.image = resizedImage(name: "\(imageName)")
        dividingLine.image = resizedImage(name: "dividingLine")
        
        
        textBlurb.text = text
        textBlurb.font = UIFont(name: "Papyrus", size: fontSize)
//        textBlurb.sizeToFit()
        
        setupLayout()
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupLayout(){
        
        let safe = safeAreaLayoutGuide
        let bottomPadding = -frame.height/40
        
        let textHoldingView = UIView()
        addSubview(textHoldingView)

        textHoldingView.translatesAutoresizingMaskIntoConstraints = false
        textHoldingView.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/14).isActive = true
        //        textHoldingView.heightAnchor.constraint(equalToConstant: textHoldingView.frame.height).isActive = true
        textHoldingView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        textHoldingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textHoldingView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20).isActive = true
        textHoldingView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20).isActive = true
        
        
        textHoldingView.addSubview(textBlurb)
        textBlurb.translatesAutoresizingMaskIntoConstraints = false
        textBlurb.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/14).isActive = true
//        textBlurb.heightAnchor.constraint(equalToConstant: textBlurb.frame.height).isActive = true
        textBlurb.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        textBlurb.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textBlurb.leadingAnchor.constraint(equalTo: safe.leadingAnchor).isActive = true
        textBlurb.trailingAnchor.constraint(equalTo: safe.trailingAnchor).isActive = true
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: textBlurb.bottomAnchor, constant: frame.height/230).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(dividingLine)
        dividingLine.translatesAutoresizingMaskIntoConstraints = false
        dividingLine.widthAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        dividingLine.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        dividingLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dividingLine.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: bottomPadding).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
