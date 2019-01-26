import UIKit

class PageView: UIView {
    
    private let pageImage: UIImageView = {
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
    
    var imageName = String()
    var storyText = [String]()
    var sceneStoryPosition = 0
    var canActivate = false
    
    init(frame: CGRect, page: Page) {
        super.init(frame: frame)
        imageName = page.imageName
        storyText = page.storyText
        
        
        pageImage.image = resizedImage(name: "\(imageName)", frame: frame)

        storyTextView.text = page.storyText[sceneStoryPosition]
        storyTextView.font = UIFont(name: "Papyrus", size: frame.width/44)
        
        setupLayout()
        alpha = 0
        fadeTo(time: 1.5, opacity: 1.0, {
            self.canActivate = true
        })
    }

    func nextStoryLine(){
        
        if canActivate{
            canActivate = false
            storyTextView.fadeTo(time: 1.0, opacity: 0.0) {
                self.sceneStoryPosition += 1
                self.storyTextView.text = self.storyText[self.sceneStoryPosition]
                self.storyTextView.fadeTo(time: 1.0, opacity: 1.0, {
                    self.canActivate = true
                })
            }
        }
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
        
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
