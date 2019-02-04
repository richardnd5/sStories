import UIKit

class HomePage: UIView {
    
//    private let imageView: UIImageView = {
//
//
//        var imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
//        return imageView
//    }()
    
    private let title: UILabel = {
        let textView = UILabel()
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
//        textView.isEditable = false
//        textView.isScrollEnabled = false
//        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "Papyrus", size: 30)
        return textView
    }()
    
    weak var delegate : SceneDelegate?
//    private var maskLayer = CAGradientLayer()
    var background : BackgroundImage!

    
    var aboutButton : Button!
    var readButton: Button!
//    var imageSize = CGRect(x: 0, y: 0, width: ScreenSize.width/1.6, height: ScreenSize.width/2.1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        imageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
//        imageView.image = resizedImage(name: "homePageBackground", frame: frame)
        addBackground()
        
        title.text = "Templeton's Fishing Journey"
        title.font = UIFont(name: "Papyrus", size: frame.width/20)
        
        
//        imageView.clipsToBounds = true
        
        createButtons()
        setupLayout()
//        imageView.layer.cornerRadius = imageView.frame.width/2
        
//        addBlurredBorder()

        backgroundColor = .black
        alpha = 0
        layer.zPosition = 100
        fadeTo(time: 1.5,opacity: 1.0)
        
    }
    
    func addBackground(){
        let width = frame.height/1.3
        let height = frame.height/2.1
        let backgroundFrame = CGRect(x: frame.width/2-width/2, y: frame.height/2-height/2, width: width, height: height)
        background = BackgroundImage(frame: backgroundFrame)
        addSubview(background)
    }
    
    func createButtons() {
        
        readButton = Button(frame: CGRect.zero, name: "read")
        addSubview(readButton)
        
        aboutButton = Button(frame: CGRect.zero, name: "about")
        addSubview(aboutButton)
        
    }
//
//    func addBlurredBorder(){
//
//
//        maskLayer.frame = imageSize
//        print(maskLayer.frame)
//
//        maskLayer.shadowPath = CGPath(roundedRect: maskLayer.bounds.insetBy(dx: maskLayer.frame.height/8, dy: maskLayer.frame.height/10), cornerWidth: maskLayer.frame.height/8, cornerHeight: maskLayer.frame.height/8, transform: nil)
//        maskLayer.shadowOpacity = 1.0
//        maskLayer.shadowRadius = imageSize.height/40
//        maskLayer.shadowOffset = CGSize.zero
//        maskLayer.shadowColor = UIColor.black.cgColor
//        imageView.layer.mask = maskLayer;
//    }

    func setupLayout(){
        
        let safe = safeAreaLayoutGuide
        let padding = frame.height/40
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/14).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: frame.width/1.3).isActive = true
        title.adjustsFontSizeToFitWidth = true
        
        addSubview(readButton)
        readButton.translatesAutoresizingMaskIntoConstraints = false
        readButton.widthAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        readButton.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        readButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -padding).isActive = true
        readButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -padding).isActive = true

        addSubview(aboutButton)
        aboutButton!.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.widthAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        aboutButton.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        aboutButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: padding).isActive = true
        aboutButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -padding).isActive = true
        
//
//        addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: padding).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: readButton.topAnchor).isActive = true
//        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
