import UIKit

class AboutByeahView: UIView, UIScrollViewDelegate {
    
    var aboutTitle : UILabel!
    var scrollView : UIScrollView!
    var backButton : Button!

    var aboutTitleFontSize = ScreenSize.width * 0.125
    var blurbFontSize = ScreenSize.width * 0.05

    
    let blurb = Blurb(textBlurb: "We are musicians and educators who discovered we love software development in 2013. We started teaching ourselves programming in graphical programming languages and made the switch to Swift and Javascript in 2014. We are devoted to creativity, education and sound.", imageName: "byeahButton")
    
    var blurbLabel : UILabel!
    var byeahButton : Button!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustFontSizesBasedOnScreenSize()
//        createScrollView()
        createTitle()
        createBackButton()
        createBlurbs()
        createByeahButton()
        setupConstraints()
        
        fadeViewIn(time: 1.5)
        
        
    }
    
    func adjustFontSizesBasedOnScreenSize(){
        if ScreenSize.width > ScreenSize.height {
            aboutTitleFontSize = ScreenSize.height * 0.09
            blurbFontSize = ScreenSize.height * 0.03
        }
    }
    func createScrollView(){
        scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.delegate = self
    }
    
    func createTitle(){
        aboutTitle = UILabel()
        aboutTitle.text = "About Byeah LLC"
        aboutTitle.font = UIFont(name: "Avenir Light", size: aboutTitleFontSize)
        aboutTitle.textColor = .white
        aboutTitle.textAlignment = .center
        aboutTitle.isUserInteractionEnabled = false
        addSubview(aboutTitle)
    }
    
    func createBackButton(){
        backButton = Button(frame: .zero, name: "backArrow")
        addSubview(backButton)
        backButton.tag = 101
    }
    
    func createBlurbs(){
        blurbLabel = UILabel()
        blurbLabel.numberOfLines = 0
        blurbLabel.lineBreakMode = .byWordWrapping
        blurbLabel.font = UIFont(name: "Avenir Light", size: blurbFontSize)
        blurbLabel.textColor = .white
        blurbLabel.text = blurb.textBlurb
//        blurbLabel.sizeToFit()
        blurbLabel.textAlignment = .center
        
        addSubview(blurbLabel)

    }
    
    func createByeahButton(){
        byeahButton = Button(frame: .zero, name: "byeahButton")
        byeahButton.tag = 100
        addSubview(byeahButton)
        
        byeahButton.addTarget(self, action: #selector(byeahButtonPressed), for: .touchUpInside)
    }
    
    func setupBackButtonConstraints(){
        let buttonSize = ScreenSize.width/12
        let safe = safeAreaLayoutGuide
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20).isActive = true
        backButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor, multiplier: 1).isActive = true
        
    }
    
    func setupConstraints(){
        let safe = safeAreaLayoutGuide
        
        aboutTitle.translatesAutoresizingMaskIntoConstraints = false
        aboutTitle.topAnchor.constraint(equalTo: safe.topAnchor, constant: 50).isActive = true
        aboutTitle.centerXAnchor.constraint(equalTo: safe.centerXAnchor).isActive = true
        aboutTitle.widthAnchor.constraint(equalTo: safe.widthAnchor).isActive = true
//        aboutTitle.heightAnchor.constraint(equalToConstant: aboutTitleFontSize).isActive = true
        
        blurbLabel.translatesAutoresizingMaskIntoConstraints = false
        blurbLabel.topAnchor.constraint(equalTo: aboutTitle.bottomAnchor, constant: 50).isActive = true
        blurbLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20).isActive = true
        blurbLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20).isActive = true
//        blurbLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -10).isActive = true

    }
    
    func setupByeahConstraints(){
        
//        let safe = safeAreaLayoutGuide
        let buttonSize : CGFloat!
        ScreenSize.width > ScreenSize.height ? (buttonSize = ScreenSize.height/5) : (buttonSize = ScreenSize.width/4)
        
        byeahButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        byeahButton.topAnchor.constraint(equalTo: blurbLabel.bottomAnchor, constant: 30).isActive = true
        byeahButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        byeahButton.widthAnchor.constraint(equalTo: byeahButton.heightAnchor, multiplier: 1.5).isActive = true
        byeahButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    

    override func layoutSubviews() {
        setupBackButtonConstraints()
        setupByeahConstraints()
    }
    
    @objc func byeahButtonPressed(_ sender: UIButton){
        playRandomByeahSound()
    }
    
    func playRandomByeahSound(){
        
        let randomNum = Int.random(in: 1...12)
        
        switch randomNum {
        case 1:
            playSoundClip(.byeahSound1)
        case 2:
            playSoundClip(.byeahSound2)
        case 3:
            playSoundClip(.byeahSound3)
        case 4:
            playSoundClip(.byeahSound4)
        case 5:
            playSoundClip(.byeahSound5)
        case 6:
            playSoundClip(.byeahSound6)
        case 7:
            playSoundClip(.byeahSound7)
        case 8:
            playSoundClip(.byeahSound8)
        case 9:
            playSoundClip(.byeahSound9)
        case 10:
            playSoundClip(.byeahSound10)
        case 11:
            playSoundClip(.byeahSound11)
        case 12:
            playSoundClip(.byeahSound12)
        default:
            playSoundClip(.byeahSound1)

        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
