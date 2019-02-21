// This is currently usused.

import UIKit

class BookmarkPage: UIView {
    
    var tab : UIImageView!
    var pageContainer : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createTab()
        createContainer()
        setupLayout()
        layer.zPosition = 800
        createGestures()
        
    }
    
    func createGestures(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMelodyPan))
        addGestureRecognizer(panGesture)
    }
    
    @objc func handleMelodyPan(_ sender: UIPanGestureRecognizer){
        
    }
    
    func createTab(){
        tab = UIImageView()
        addSubview(tab)
        tab.backgroundColor = .red
    }
    
    func createContainer(){
        pageContainer = UIView()
        addSubview(pageContainer)
        pageContainer.backgroundColor = .orange
    }
    
    func setupLayout(){
        
        let safe = safeAreaLayoutGuide
        pageContainer.translatesAutoresizingMaskIntoConstraints = false
        pageContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor)
        pageContainer.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pageContainer.heightAnchor.constraint(equalToConstant: frame.height/1.5).isActive = true
        pageContainer.bottomAnchor.constraint(equalTo: safe.topAnchor).isActive = true
        
        
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.topAnchor.constraint(equalTo: pageContainer.bottomAnchor).isActive = true
        tab.heightAnchor.constraint(equalToConstant: frame.height/8).isActive = true
        tab.widthAnchor.constraint(equalToConstant: frame.width/10).isActive = true
        tab.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: frame.width/16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
