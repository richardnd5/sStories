import UIKit

class AboutByeahView: UIView, UIScrollViewDelegate {
    
    var aboutTitle : UILabel!
    var scrollView : UIScrollView!
    var backButton : Button!
    
    var titleFontSize : CGFloat = 32
    let relativeFontConstant:CGFloat = 0.046
    let aboutTitleFontSize = ScreenSize.height * 0.08
    let blurbFontSize = ScreenSize.height * 0.03

    
    let blurb = Blurb(textBlurb: "We are musicians and educators who realized we love software development in 2013. We started teaching ourselves programming in graphical programming languages and made the switch to Swift and Javascript in 2014. We are devoted to creativity, education and sound.", imageName: "byeahButton")
    
    var blurbLabel : UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        createScrollView()
        createTitle()
        createBackButton()
        createBlurbs()
        setupConstraints()
        
        fadeViewIn(time: 1.5)
        
        
    }
    
    func createScrollView(){
        scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.delegate = self
    }
    
    func createTitle(){
        aboutTitle = UILabel()
        aboutTitle.text = "About Byeah"
        aboutTitle.font = UIFont(name: "Avenir Light", size: aboutTitleFontSize)
        aboutTitle.textColor = .white
        aboutTitle.textAlignment = .center
        aboutTitle.isUserInteractionEnabled = false
        addSubview(aboutTitle)
    }
    
    func createBackButton(){
        backButton = Button(frame: .zero, name: "backArrow")
        addSubview(backButton)

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
        blurbLabel.topAnchor.constraint(equalTo: aboutTitle.bottomAnchor, constant: 30).isActive = true
        blurbLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20).isActive = true
        blurbLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20).isActive = true
//        blurbLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -10).isActive = true
        

    }
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var opacity = 1-scrollView.contentOffset.y / 80
        
        if opacity > 1 {
            opacity = 1
            aboutTitle.alpha = opacity
        } else {
            aboutTitle.alpha = opacity
        }
    }
    
    override func layoutSubviews() {
        setupBackButtonConstraints()
        
//        scrollView.contentSize = frame.size
        
//        createBlurbs()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
