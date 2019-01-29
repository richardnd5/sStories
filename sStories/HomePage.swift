import UIKit


//protocol ButtonDelegate: class {
//    func startStory()
//    func goToAboutPage()
//}

class HomePage: UIView {
    
    private let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let title: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "Papyrus", size: 30)
        return textView
    }()
    
    weak var delegate : SceneDelegate?
    
    var anotherButton : Button!
    var anotherReadButton: Button!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = resizedImage(name: "Templeton", frame: frame)
        title.text = "Templeton's Fishing Journey"
        title.font = UIFont(name: "Papyrus", size: frame.width/20)
        
        createButtons()
        setupLayout()
        backgroundColor = .black
        alpha = 0
        layer.zPosition = 100
        fadeTo(time: 1.5,opacity: 1.0)
        
    }
    
    func createButtons() {
        
        anotherReadButton = Button(frame: CGRect.zero, name: "read")
        addSubview(anotherReadButton)
        
        anotherButton = Button(frame: CGRect.zero, name: "about")
        addSubview(anotherButton)
        
    }

    func setupLayout(){
        
        let safe = safeAreaLayoutGuide
        let bottomPadding = -frame.height/40
        
        addSubview(title)
        title.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/14).isActive = true
        title.heightAnchor.constraint(equalToConstant: frame.height/1.4)
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width/10).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width/10).isActive = true
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: frame.height/230).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -frame.height/4).isActive = true
        
        addSubview(anotherReadButton)
        anotherReadButton.translatesAutoresizingMaskIntoConstraints = false
        anotherReadButton.widthAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        anotherReadButton.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        anotherReadButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        anotherReadButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: bottomPadding).isActive = true

        addSubview(anotherButton)
        anotherButton!.translatesAutoresizingMaskIntoConstraints = false
        anotherButton!.topAnchor.constraint(equalTo: anotherReadButton.topAnchor).isActive = true
        anotherButton!.widthAnchor.constraint(equalToConstant: frame.height/9).isActive = true
        anotherButton!.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: bottomPadding).isActive = true
        anotherButton!.bottomAnchor.constraint(equalTo: anotherReadButton.bottomAnchor).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
