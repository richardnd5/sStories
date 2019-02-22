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
    
    private let nextImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
    
    var imageName = String()
    var storyText : ArraySlice<String>?
    var sceneStoryPosition = 0
    var canActivate = false
    
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
        fadeTo(time: 1.5, opacity: 1.0, {
            self.canActivate = true
        })
    }
    
    func setupNextButton(){
        
    }

    func nextStoryLine(){
        
        if canActivate{
            canActivate = false
            storyTextView.fadeTo(time: 1.0, opacity: 0.0) {
                self.sceneStoryPosition += 1
                self.storyTextView.text = self.storyText![self.sceneStoryPosition]
                self.storyTextView.fadeTo(time: 1.0, opacity: 1.0, {
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
        
        nextButton = Button(frame: CGRect(x: 0, y: 0, width: frame.width/20, height: frame.height/20), name: "nextArrow")
        addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        nextButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 30).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: storyTextView.centerYAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: storyTextView.trailingAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: frame.width/30).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: frame.height/15).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
