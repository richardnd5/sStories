import UIKit



class HomePage: UIView {
    
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Papyrus", size: 30)
        label.text = "Templeton's Fishing Journey"
        return label
    }()
    
    weak var delegate : SceneDelegate?
    var background : HomePageBackgroundImage!
    var bubblePlayZone : BubblePlayZone!
    
    var titleImage : ImageViewClass!
    
    var aboutButton : Button!
    var readButton: Button!
    
    var homeButton : Button!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBackground()
        createButtons()
        createBubblePlayZone(frame: frame)
        title.font = UIFont(name: "Papyrus", size: frame.width/20)
        setupLayout()
        
        createHomeButton()
        

        alpha = 0
//        Sound.sharedInstance.openingMusic.loopOpeningMusic()
        Sound.sharedInstance.stopPondBackground()
        Sound.sharedInstance.playPondBackground()
        
        fadeTo(opacity: 1.0, time: 1.5,{
            self.startBubbles()
        })
    }
    
    func createHomeButton(){
        homeButton = Button(frame: CGRect(), name: "backArrow")
        addSubview(homeButton)
        homeButton.resizeImage(to: CGSize(width: 30, height: 30))
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        homeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        homeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        homeButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    func startBubbles(){
        delegate?.createRandomBubblesAtRandomTimeInterval(time: 0.8)
    }
    
    func createBubblePlayZone(frame: CGRect){
        // Ewww. no auto layout. That is gross.
        let width = frame.width/1.1
        let height = frame.height/1.2
        let padding = frame.height/30
        let selfPadding = height*0.12
        let x = frame.width/2-width/2
        let y = (frame.height-height/2-padding-selfPadding)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        bubblePlayZone = BubblePlayZone(frame: frame)
        addSubview(bubblePlayZone)
    }

    var backgroundInitialPosition : CGPoint!
    func addBackground(){
        let width = frame.height/1.3
        let height = frame.height/2.1
        let backgroundFrame = CGRect(x: frame.width/2-width/2, y: frame.height/2-height/2, width: width, height: height)
        background = HomePageBackgroundImage(frame: backgroundFrame)
        addSubview(background)
        backgroundInitialPosition = background.frame.origin
        

    }
    
//    @objc func handlePan(_ sender: UIPanGestureRecognizer){
//        print("panning")
//        let translation = sender.translation(in: self)
//        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
//        sender.setTranslation(CGPoint.zero, in: self)
//
//        if sender.state == .ended || sender.state == .cancelled {
//            if sender.location(in: self) != backgroundInitialPosition {
//                sender.view?.moveViewTo(backgroundInitialPosition, time: 0.7)
//            }
//        }
//    }
    
    func createButtons() {
        
        readButton = Button(frame: CGRect.zero, name: "read")
        addSubview(readButton)
        readButton.throbWithWiggle(scaleTo: 1.1, time: 0.5)
        
        aboutButton = Button(frame: CGRect.zero, name: "about")
        addSubview(aboutButton)
        aboutButton.throbWithWiggle(scaleTo: 1.1, time: 0.6)
        
        
    }
    
    func setupLayout(){
        
        let safe = safeAreaLayoutGuide
        let padding = frame.height/40
        
        let fr = CGRect()
        titleImage = ImageViewClass(frame: fr, "homePageTitle")
        
        addSubview(titleImage)
        
//        addSubview(title)
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        titleImage.topAnchor.constraint(equalTo: safe.topAnchor ).isActive = true
        titleImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleImage.widthAnchor.constraint(equalToConstant: frame.width/1.5).isActive = true
        titleImage.heightAnchor.constraint(equalToConstant: frame.height/5).isActive = true
        
        
        
        
        
        
        readButton.translatesAutoresizingMaskIntoConstraints = false
        readButton.widthAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        readButton.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        readButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -padding).isActive = true
        readButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -padding).isActive = true
        
        aboutButton!.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.widthAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        aboutButton.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        aboutButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: padding).isActive = true
        aboutButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -padding).isActive = true
        
    }
    
    func fadeInTitleAndLabels(){
        aboutButton.fadeIn(1.0)
        readButton.fadeIn(1.0)
        titleImage.fadeTo(opacity: 1.0, time: 1.0)
    }
    
    func fadeOutTitleAndLabels(){
        aboutButton.fadeOut(1.0)
        readButton.fadeOut(1.0)
        titleImage.fadeTo(opacity: 0.0, time: 1.0)
        
    }
    
    @objc func backButtonPressed(_ sender: UIButton){
        delegate?.goHome()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
