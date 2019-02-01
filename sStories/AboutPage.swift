import UIKit

class AboutPage: UIView, UIScrollViewDelegate {
    
    weak var delegate : SceneDelegate?
    var scrollView: UIScrollView!
    var aboutTitle : UILabel!
    var backButton : UIButton!
    var blurbArray = [AboutBlurb]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createScrollView()
        createTitle()
        createButtons()
        setupContraints()
        
        alpha = 0.0
        self.fadeTo(time: 1.5,opacity: 1.0)
        addBlurbs()
    }
    
    func addBlurbs(){
        
        let safe = safeAreaLayoutGuide
        let padding : CGFloat = 60
        for (index, blurb) in blurbs.enumerated() {
            //        blurbs.forEach { blurb in
            let view = AboutBlurb(frame: CGRect.zero, text: blurb.textBlurb, imageName: blurb.imageName)
            scrollView.addSubview(view)
            
            if blurbArray.count == 0 {
                view.anchor(
                    top: scrollView.topAnchor,
                    leading: safe.leadingAnchor,
                    trailing: safe.trailingAnchor,
                    bottom: nil,
                    padding: UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0),
                    size: CGSize(width: frame.width, height: frame.height))
            } else if index < blurbs.count-1 {
                view.anchor(
                    top: blurbArray[index-1].bottomAnchor,
                    leading: safe.leadingAnchor,
                    trailing: safe.trailingAnchor,
                    bottom: nil,
                    padding: UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0),
                    size: CGSize(width: frame.width, height: frame.height))
            } else if index == blurbs.count-1 {
                view.anchor(
                    top: blurbArray[blurbArray.count-1].bottomAnchor,
                    leading: safe.leadingAnchor,
                    trailing: safe.trailingAnchor,
                    bottom: scrollView.bottomAnchor,
                    padding: UIEdgeInsets(top: padding, left: 0, bottom: -padding, right: 0),
                    size: CGSize(width: frame.width, height: frame.height))
            }
            blurbArray.append(view)   
        }
    }
    
    func createScrollView(){
        scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.delegate = self
    }
    
    func createTitle(){
        aboutTitle = UILabel()
        aboutTitle.text = "About"
        aboutTitle.font = UIFont(name: "Papyrus", size: frame.width/15)
        aboutTitle.textColor = .white
        aboutTitle.textAlignment = .center
        aboutTitle.isUserInteractionEnabled = false
        addSubview(aboutTitle)
    }
    
    func createButtons() {
        backButton = Button(frame: CGRect.zero, name: "back")
        addSubview(backButton)
    }
    
    func setupContraints(){
        
        let safe = safeAreaLayoutGuide
        let bottomPadding = frame.height/40
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: safe.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: safe.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: safe.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safe.bottomAnchor).isActive = true
        
        aboutTitle.translatesAutoresizingMaskIntoConstraints = false
        aboutTitle.topAnchor.constraint(equalTo: safe.topAnchor, constant: frame.height/10).isActive = true
        aboutTitle.centerXAnchor.constraint(equalTo: safe.centerXAnchor).isActive = true
        aboutTitle.widthAnchor.constraint(equalTo: safe.widthAnchor).isActive = true
        aboutTitle.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: frame.height/7).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: frame.height/7).isActive = true
        backButton.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: bottomPadding).isActive = true
        backButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -bottomPadding).isActive = true
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        delegate?.goToHomePage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var opacity = 1-scrollView.contentOffset.y / 50
        
        if opacity > 1 {
            opacity = 1
            aboutTitle.alpha = opacity
            backButton.alpha = opacity
        } else {
            aboutTitle.alpha = opacity
            backButton.alpha = opacity
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
