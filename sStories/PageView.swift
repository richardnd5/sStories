import UIKit

protocol PageDelegate : class {
    func nextStoryLine()
    func shrinkText()
    func expandText()
}

class PageView: UIView {
    
    let pageImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let storyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        return textView
    }()
    
    var nextButton : Button!
    var backButton : Button!
    
    var playSoundButton : Button!
    
    var navigationButtonsVisable = false
    
    var imageName = String()
    var storyText : ArraySlice<String>?
    var sceneStoryPosition = 0
    var canActivate = false {
        didSet {
            isUserInteractionEnabled = canActivate
        }
    }
    
//    var frameAfterSubviewLayout : CGRect!
//    var imageViewInitialPosition : CGPoint!
    
    var pageViewInitialPosition : CGPoint!
    var storyTextViewInitialPosition : CGPoint!
    
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
        VoiceOverAudio.shared.playWithDelay()

        alpha = 0
        fadeTo(opacity: 1.0, time: 1.2, {
            self.canActivate = true
        })

        
//        storyTextView.addGestureRecognizer(panText)
        
//        loadVoices()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        


    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        if !navigationButtonsVisable {
            showNavigationButtons()
        }
    }
    
    @objc func handleTextPan(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: self)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
//            sender.view?.moveViewTo(storyTextViewInitialPosition, time: 0.5)

        }
    }
    
    func showNavigationButtons(){
        navigationButtonsVisable = true
        nextButton.fadeIn(1.0)
        backButton.fadeIn(1.0)
    }
    
    func hideNavigationButtons(){
        navigationButtonsVisable = false
        nextButton.fadeOut(1.0)
        backButton.fadeOut(1.0)
    }

    func nextStoryLine(){
        
        if canActivate{
            canActivate = false
            playSoundButton.fadeOut(1.0)
            storyTextView.fadeTo(opacity: 0.0, time: 1.0) {
                self.sceneStoryPosition += 1
                self.storyTextView.text = self.storyText![self.sceneStoryPosition]
                
                self.playSoundButton.fadeIn(1.0)
                self.storyTextView.fadeTo(opacity: 1.0, time: 1.0, {
                    self.canActivate = true
                    VoiceOverAudio.shared.playWithDelay()
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
                    VoiceOverAudio.shared.playWithDelay()
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
        nextButton.alpha = 0.0

        let buttonWidth = frame.width/10
        let buttonHeight = frame.height/5
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        
        
        backButton = Button(frame: CGRect(x: 0, y: 0, width: frame.width/20, height: frame.width/20), name: "backArrow")
        
        addSubview(backButton)
        backButton.alpha = 0.0
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        
        let playSoundButtonWidth = frame.width/30
        let playSoundButtonHeight = frame.height/15
        
        playSoundButton = Button(frame: CGRect(x: 0, y: 0, width: playSoundButtonWidth, height: playSoundButtonHeight), name: "playSoundButton")
        
        addSubview(playSoundButton)
        playSoundButton.alpha = 0.8
        
        playSoundButton.addTarget(self, action: #selector(handlePlaySpeaking), for: .touchUpInside)
        
        
        
        playSoundButton.translatesAutoresizingMaskIntoConstraints = false
        playSoundButton.topAnchor.constraint(equalTo: storyTextView.topAnchor).isActive = true
        playSoundButton.trailingAnchor.constraint(equalTo: storyTextView.leadingAnchor).isActive = true
        playSoundButton.widthAnchor.constraint(equalToConstant: playSoundButtonWidth).isActive = true
        playSoundButton.heightAnchor.constraint(equalToConstant: playSoundButtonHeight).isActive = true

        
    }
    
//    var audioClip : VoiceOverAudio!
//    func loadVoices(){
//        audioClip = VoiceOverAudio(fileName: "readStory0")
//    }
    
    @objc func handlePlaySpeaking(_ sender: UIButton?){
//        audioClip.playWithDelay()
        VoiceOverAudio.shared.playWithDelay()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
