import UIKit

protocol PageDelegate : class {
    func nextStoryLine()
    func shrinkText()
    func expandText()
}

class PageView: UIView {
    
    private let pageImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
//    private let nextImage: UIImageView = {
//        var imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
//        imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
//        return imageView
//    }()
//    
//    private let backImage: UIImageView = {
//        var imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//    
    
    
    private let storyTextView: UITextView = {
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
    
    var nextButton : Button!
    var backButton : Button!
    
    var imageName = String()
    var storyText : ArraySlice<String>?
    var sceneStoryPosition = 0
    var canActivate = false {
        didSet {
            isUserInteractionEnabled = canActivate
        }
    }
    
    var frameAfterSubviewLayout : CGRect!
    
    init(frame: CGRect, page: Page) {
        super.init(frame: frame)
        imageName = page.imageName
        storyText = page.storyText
        sceneStoryPosition = page.storyText.startIndex
        
        pageImage.image = resizedImage(name: "\(imageName)", frame: frame)
//        nextImage.image = resizedImage(name: "nextArrow")
        
        storyTextView.text = page.storyText[sceneStoryPosition]
        storyTextView.font = UIFont(name: "Papyrus", size: frame.width/44)
        
        setupLayout()
        alpha = 0
        fadeTo(opacity: 1.0, time: 1.5, {
            self.canActivate = true
        })
    }
    

    func nextStoryLine(){
        
        if canActivate{
            canActivate = false
            storyTextView.fadeTo(opacity: 0.0, time: 1.0) {
                self.sceneStoryPosition += 1
                self.storyTextView.text = self.storyText![self.sceneStoryPosition]
                self.storyTextView.fadeTo(opacity: 1.0, time: 1.0, {
                    self.canActivate = true
                })
            }
        }
    }
    
    func previousStoryLine(){
        
        if canActivate{
            canActivate = false
            storyTextView.fadeTo(opacity: 0.0, time: 1.0) {
                self.sceneStoryPosition -= 1
                self.storyTextView.text = self.storyText![self.sceneStoryPosition]
                self.storyTextView.fadeTo(opacity: 1.0, time: 1.0, {
                    self.canActivate = true
                })
            }
        }
    }
    
    func shrinkText(){
        storyTextView.scaleTo(scaleTo: 0.97, time: 0.4)
    }
    
    func expandText(){
        storyTextView.scaleTo(scaleTo: 1.0, time: 0.4)
    }
    
    func setupLayout(){
        
        addSubview(pageImage)
        
        pageImage.translatesAutoresizingMaskIntoConstraints = false
        pageImage.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/14).isActive = true
        pageImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pageImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        pageImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -frame.height/2.5).isActive = true
        
        addSubview(storyTextView)
        storyTextView.topAnchor.constraint(equalTo: pageImage.bottomAnchor, constant: 10).isActive = true
        storyTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 30).isActive = true
        storyTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        storyTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width/5).isActive = true
        storyTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width/5).isActive = true
        storyTextView.sizeToFit()
        
        nextButton = Button(frame: CGRect(x: 0, y: 0, width: frame.width/20, height: frame.width/20), name: "nextArrow")
        
        addSubview(nextButton)
        nextButton.alpha = 0.8
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerYAnchor.constraint(equalTo: storyTextView.centerYAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: storyTextView.trailingAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: frame.width/30).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: frame.height/15).isActive = true
        
        
        
        backButton = Button(frame: CGRect(x: 0, y: 0, width: frame.width/20, height: frame.width/20), name: "backArrow")
        
        addSubview(backButton)
        print(backButton.name)
        backButton.alpha = 0.8
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerYAnchor.constraint(equalTo: storyTextView.centerYAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: storyTextView.leadingAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: frame.width/30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: frame.height/15).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
