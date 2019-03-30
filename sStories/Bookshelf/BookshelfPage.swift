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
    
    var stackViewTop : UIStackView!
    var stackViewBottom : UIStackView!
    
    var icon1 : StoryIconNew!
    var icon2 : StoryIconNew!
    var icon3 : StoryIconNew!
    var icon4 : StoryIconNew!
    
    
    var iconContainer : UIView!
    
    let relativeFontConstant:CGFloat = 0.09
    var iconWidth : CGFloat!

    
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
        
        iconWidth = frame.width/6
        
        setupViews()
        createTouchBlockingOverlay()
        
    }
    
    func createTouchBlockingOverlay(){
        touchBlockingOverlay = UIView()
        addSubview(touchBlockingOverlay)
        touchBlockingOverlay.fillSuperview()
        touchBlockingOverlay.isUserInteractionEnabled = false
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBlockingOverlayTap))
//        touchBlockingOverlay.addGestureRecognizer(tap)
    }
    
    @objc func handleBlockingOverlayTap(_ sender: UITapGestureRecognizer){
//        print("hey blocking overlay")
    }
    
    func toggleTouchEnabled(){
        if touchEnabled {
            touchBlockingOverlay.isUserInteractionEnabled = false
        } else {
            touchBlockingOverlay.isUserInteractionEnabled = true
        }
    }
    
    func createStoryIcon(_ name: String) -> StoryIconNew {
        let view = StoryIconNew(frame: .zero, name: name)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    func setupViews() {
        
        let safe = safeAreaLayoutGuide
        let padding = frame.width/6
        
        iconContainer = UIView()
        addSubview(iconContainer)
        
        aboutTitle.translatesAutoresizingMaskIntoConstraints = false
        aboutTitle.topAnchor.constraint(equalTo: safe.topAnchor, constant: frame.height/20).isActive = true
        aboutTitle.centerXAnchor.constraint(equalTo: safe.centerXAnchor).isActive = true
        aboutTitle.widthAnchor.constraint(equalTo: safe.widthAnchor).isActive = true
        aboutTitle.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.topAnchor.constraint(equalTo: aboutTitle.bottomAnchor, constant: frame.height/20).isActive = true
        iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor,constant: padding).isActive = true
        iconContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        iconContainer.bottomAnchor.constraint(equalTo: centerYAnchor, constant: frame.height/10).isActive = true
        
        icon1 = createStoryIcon("whiteDot")
        icon2 = createStoryIcon("templetonThumbnail")
        icon3 = createStoryIcon("whiteDot")
        icon4 = createStoryIcon("whiteDot");
        
        stackViewTop = UIStackView(arrangedSubviews: [icon1, icon2])
        stackViewTop.translatesAutoresizingMaskIntoConstraints = false
        stackViewTop.axis = .horizontal
        stackViewTop.distribution = .fillEqually
        iconContainer.addSubview(stackViewTop)
        
        stackViewBottom = UIStackView(arrangedSubviews: [icon3, icon4])
        stackViewBottom.translatesAutoresizingMaskIntoConstraints = false
        stackViewBottom.axis = .horizontal
        stackViewBottom.distribution = .fillEqually
        iconContainer.addSubview(stackViewBottom)
        

        stackViewTop.topAnchor.constraint(equalTo: iconContainer.topAnchor).isActive = true
        stackViewTop.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor).isActive = true
        stackViewTop.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor).isActive = true
        stackViewTop.bottomAnchor.constraint(equalTo: iconContainer.centerYAnchor).isActive = true


        stackViewBottom.topAnchor.constraint(equalTo: stackViewTop.bottomAnchor).isActive = true
        stackViewBottom.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor).isActive = true
        stackViewBottom.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor).isActive = true
        stackViewBottom.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor).isActive = true
        
        


    }
    
    func createTitle(){
        aboutTitle = UILabel()
        aboutTitle.text = "sStories"
        aboutTitle.font = UIFont(name: "Avenir-Light", size: frame.width * relativeFontConstant)
        aboutTitle.textColor = .white
        aboutTitle.textAlignment = .center
        aboutTitle.isUserInteractionEnabled = false
        addSubview(aboutTitle)
    }
    
    override func layoutSubviews() {
        for view in stackViewTop.arrangedSubviews {
            let v = view as! StoryIconNew
            v.button.backgroundColor = UIColor(hue: CGFloat.random(in: 0.0...1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        for view in stackViewBottom.arrangedSubviews {
            let v = view as! StoryIconNew
            v.button.backgroundColor = UIColor(hue: CGFloat.random(in: 0.0...1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
