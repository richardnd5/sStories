// This class needs cleaning.

import UIKit

class BookshelfPage: UIView, UIScrollViewDelegate {
    
    weak var delegate : SceneDelegate?
    var scrollView: UIScrollView!
    var aboutTitle : UILabel!
    var backButton : UIButton!
    var blurbArray = [AboutBlurb]()
    var scrollUpButton : UIButton!
    
    var touchBlockingOverlay : UIView!
    
    var arrow : ImageViewClass!
    
    
    var stackView : UIStackView!
    
    var icon1 : StoryIcon!
    var icon2 : StoryIcon!
    var icon3 : StoryIcon!
    var icon4 : StoryIcon!
    
    var touchEnabled = true {
        didSet {
            toggleTouchEnabled()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        createTitle()
        alpha = 0.0
        self.fadeTo(opacity: 1.0, time: 1.5)
        
        setupViews()
        createTouchBlockingOverlay()
        
    }
    
    func createTouchBlockingOverlay(){
        touchBlockingOverlay = UIView()
        addSubview(touchBlockingOverlay)
        touchBlockingOverlay.fillSuperview()
        touchBlockingOverlay.isUserInteractionEnabled = false
    }
    
    func toggleTouchEnabled(){
        if touchEnabled {
            touchBlockingOverlay.isUserInteractionEnabled = false
        } else {
            touchBlockingOverlay.isUserInteractionEnabled = true
        }
    }
    
    func createStoryIcon(_ name: String) -> StoryIcon {
        let view = StoryIcon(frame: .zero, name: name)
        view.translatesAutoresizingMaskIntoConstraints = false

        // Get swifty.
        [view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         view.widthAnchor.constraint(equalToConstant: frame.width/10),
         view.heightAnchor.constraint(equalToConstant: frame.width/10)].forEach { $0.isActive = true }
        
        return view
    }
    
    func setupViews() {
        
        let safe = safeAreaLayoutGuide
        
        aboutTitle.translatesAutoresizingMaskIntoConstraints = false
        aboutTitle.topAnchor.constraint(equalTo: safe.topAnchor, constant: frame.height/10).isActive = true
        aboutTitle.centerXAnchor.constraint(equalTo: safe.centerXAnchor).isActive = true
        aboutTitle.widthAnchor.constraint(equalTo: safe.widthAnchor).isActive = true
        aboutTitle.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        
        
        icon1 = createStoryIcon("whiteDot")
        icon2 = createStoryIcon("templetonThumbnail")
        icon2.backgroundColor = UIColor(hue: CGFloat.random(in: 0.0...1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
        icon3 = createStoryIcon("whiteDot")
        icon4 = createStoryIcon("whiteDot")
        
        
        stackView = UIStackView(arrangedSubviews: [icon1, icon2, icon3, icon4])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        addSubview(stackView)
        
        let padding = frame.width/8
        
        [stackView.topAnchor.constraint(equalTo: aboutTitle.bottomAnchor, constant: frame.height/8),
        stackView.heightAnchor.constraint(equalToConstant: frame.width/10),
         stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
         stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)].forEach { $0.isActive = true }

    }
    
    func createTitle(){
        aboutTitle = UILabel()
        aboutTitle.text = "sStories"
        aboutTitle.font = UIFont(name: "Avenir-Light", size: frame.width/14)
        aboutTitle.textColor = .white
        aboutTitle.textAlignment = .center
        aboutTitle.isUserInteractionEnabled = false
        addSubview(aboutTitle)
    }
    
    override func layoutSubviews() {
        stackView.subviews.forEach { view in
            let v = view as! StoryIcon
            if v.name == "whiteDot" {
                v.addDashedBorder()
            } else {
                v.layer.cornerRadius = v.frame.width/10
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
