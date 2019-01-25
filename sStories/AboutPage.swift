import UIKit

class AboutPage: UIView, UIScrollViewDelegate {
    
    weak var delegate : SceneDelegate?
    var scrollView: UIScrollView!
    
    var aboutTitle = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView()
        addSubview(scrollView)
        
        aboutTitle.text = "About"
        aboutTitle.font = UIFont(name: "Papyrus", size: frame.width/15)
        aboutTitle.textColor = .white
        aboutTitle.textAlignment = .center
        scrollView.addSubview(aboutTitle)
        
        setupContraints()
        
//        makeManySquares()
        
//        resizeScrollViewToFitContent()
        fadeTo(view:self, time: 1.5,opacity: 1.0, {})

    }
    
    func setupContraints(){
        let safe = safeAreaLayoutGuide
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
    
    func fadeTo(view: UIView, time: Double,opacity: CGFloat, _ completion: @escaping () ->()){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                view.alpha = opacity
        },
            completion: {
                _ in
                completion()
        })
    }
    
    func fadeOutAndRemove(completion: @escaping ( ) -> ( ) ){
        fadeTo(view: self, time: 1.0, opacity: 0.0, {
            self.removeFromSuperview()
            completion()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
