import UIKit

class AboutBlurb: UIView {
    
    private let textBlurb: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
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
    
    init(frame: CGRect, text: String, imageName: String = "8thThumb") {
        super.init(frame: frame)
        
        imageView.image = resizedImage(name: "\(imageName)", frame: frame)
        dividingLine.image = resizedImage(name: "dividingLine", frame: frame)
        
        textBlurb.text = text
        textBlurb.font = UIFont(name: "Papyrus", size: frame.width/44)
        
        setupLayout()
        isUserInteractionEnabled = false
        
    }
    
    func setupLayout(){
        
        let safe = safeAreaLayoutGuide
        let bottomPadding = -frame.height/40
        
        addSubview(textBlurb)
        textBlurb.translatesAutoresizingMaskIntoConstraints = false
        textBlurb.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/14).isActive = true
        textBlurb.heightAnchor.constraint(equalToConstant: frame.height/1.4)
        textBlurb.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textBlurb.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width/10).isActive = true
        textBlurb.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width/10).isActive = true
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: textBlurb.bottomAnchor, constant: frame.height/230).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -frame.height/4).isActive = true
        
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
