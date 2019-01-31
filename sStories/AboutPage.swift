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
        blurbs.forEach { blurb in
            let view = AboutBlurb(frame: CGRect.zero, text: blurb.textBlurb, imageName: blurb.imageName)
            scrollView.addSubview(view)
            // setup contraints
            if blurbArray.count == 0 {
                view.anchor(top: aboutTitle.bottomAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: nil, padding: UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: frame.height))
            } else {
                view.anchor(top: blurbArray[blurbArray.count-1].bottomAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: nil, padding: UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: frame.height))
            }
            blurbArray.append(view)
        }
        scrollView.contentSize.height = frame.height*CGFloat(blurbArray.count)
    }
    
    func createScrollView(){
        scrollView = UIScrollView()
        addSubview(scrollView)
    }
    
    func createTitle(){
        aboutTitle = UILabel()
        aboutTitle.text = "About"
        aboutTitle.font = UIFont(name: "Papyrus", size: frame.width/15)
        aboutTitle.textColor = .white
        aboutTitle.textAlignment = .center
        scrollView.addSubview(aboutTitle)
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
        aboutTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: frame.height/10).isActive = true
        aboutTitle.centerXAnchor.constraint(equalTo: safe.centerXAnchor).isActive = true
        aboutTitle.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        aboutTitle.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: frame.height/7).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: frame.height/7).isActive = true
        backButton.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: bottomPadding).isActive = true
        backButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -bottomPadding).isActive = true
        
    }
    
    func resizeScrollViewToFitContent(){
        var contentRect = CGRect.zero
        for view in scrollView.subviews {
            let viewSize = view.intrinsicContentSize
            print(viewSize)
            contentRect = contentRect.union(CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
        }
        scrollView.contentSize = contentRect.size
        scrollView.isDirectionalLockEnabled = true
    }
    
    func makeManySquares(){
        let rows = 3
        let columns = 100
        let width = 100
        let height = CGFloat(100)
        
        for i in 0...rows{
            for j in 0...columns{
                let view = UIView(frame: CGRect(x: CGFloat(i*width), y: CGFloat(j)*height, width: CGFloat(width-10), height: height-10))
                view.backgroundColor = UIColor.init(hue: CGFloat.random(in: 0...1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
                scrollView.addSubview(view)
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        delegate?.goToHomePage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
