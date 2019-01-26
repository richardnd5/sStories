import UIKit

class AboutPage: UIView, UIScrollViewDelegate {
    
    weak var delegate : SceneDelegate?
    var scrollView: UIScrollView!
    
    var aboutTitle : UILabel!
    
    private let backArrow: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView()
        addSubview(scrollView)
        
        aboutTitle = UILabel()
        aboutTitle.text = "About"
        aboutTitle.font = UIFont(name: "Papyrus", size: frame.width/15)
        aboutTitle.textColor = .white
        aboutTitle.textAlignment = .center
        scrollView.addSubview(aboutTitle)
        
        backArrow.image = resizedImage(name: "backArrow", frame: frame)
        addSubview(backArrow)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        backArrow.addGestureRecognizer(tap)

        setupContraints()

        alpha = 0.0
        self.fadeTo(time: 1.5,opacity: 1.0)

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
        
        
        backArrow.translatesAutoresizingMaskIntoConstraints = false
        backArrow.heightAnchor.constraint(equalToConstant: frame.height/7).isActive = true
        backArrow.widthAnchor.constraint(equalToConstant: frame.height/7).isActive = true
        backArrow.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: bottomPadding).isActive = true
        backArrow.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -bottomPadding).isActive = true

    }
    
    func resizeScrollViewToFitContent(){
        var contentRect = CGRect.zero
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
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
        delegate?.backHome()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
