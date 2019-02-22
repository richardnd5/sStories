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
    
    var aboutButton : Button!
    var readButton: Button!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBackground()
        createButtons()
        createBubblePlayZone(frame: frame)
        title.font = UIFont(name: "Papyrus", size: frame.width/20)
        setupLayout()
        

        alpha = 0
//        Sound.sharedInstance.openingMusic.loopOpeningMusic()
        
        fadeTo(time: 1.5,opacity: 1.0,{
            self.startBubbles()
        })
    }
    
    func startBubbles(){
        delegate?.createRandomBubblesAtRandomTimeInterval(time: 0.4)
    }
    
    func createBubblePlayZone(frame: CGRect){
        // Ewww. no auto layout. That is gross.
        let width = frame.width/1.5
        let height = frame.height/1.5
        let padding = frame.height/30
        let selfPadding = height*0.12
        let x = frame.width/2-width/2
        let y = (frame.height-height/2-padding-selfPadding)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        bubblePlayZone = BubblePlayZone(frame: frame)
        addSubview(bubblePlayZone)
    }

    func addBackground(){
        let width = frame.height/1.3
        let height = frame.height/2.1
        let backgroundFrame = CGRect(x: frame.width/2-width/2, y: frame.height/2-height/2, width: width, height: height)
        background = HomePageBackgroundImage(frame: backgroundFrame)
        addSubview(background)
    }
    
    func createButtons() {
        
        readButton = Button(frame: CGRect.zero, name: "read")
        addSubview(readButton)
        
        aboutButton = Button(frame: CGRect.zero, name: "about")
        addSubview(aboutButton)
        
    }
    
    func setupLayout(){
        
        let safe = safeAreaLayoutGuide
        let padding = frame.height/40
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/14).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: frame.width/1.3).isActive = true
        title.adjustsFontSizeToFitWidth = true
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
