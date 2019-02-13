import UIKit

class BubbleScoreView: UIView {
    
    var label : UILabel!
//    var score : Int!
    var noteImage : UIImageView!
    static var score = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        BubbleScoreView.score = 0
        
        noteImage = UIImageView()
        createLabel()
        setupImage()
        setupLayout()

        layer.cornerRadius = frame.width/50
        
    }
    
    func createLabel(){
        
        label = UILabel()
        label.font = UIFont(name: "Papyrus", size: frame.width/10)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "\(BubbleScoreView.score)    x    "
        addSubview(label)
        
    }
    
    func setupImage(){
        noteImage.image = resizedImage(name: "bubbleScoreNoteImage")
        noteImage.contentMode = .scaleAspectFit
        addSubview(noteImage)
//        noteImage.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
//        noteImage.layer.cornerRadius = frame.height/10
    }
    
    func addToScore(){
        BubbleScoreView.score += 1
        label.text = "\(BubbleScoreView.score)    x    "
    }
    
    func setupLayout(){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: frame.width/1.5).isActive = true
        
        noteImage.translatesAutoresizingMaskIntoConstraints = false
        noteImage.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/5).isActive = true
        noteImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -frame.height/5).isActive = true
        noteImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        noteImage.widthAnchor.constraint(equalToConstant: frame.width/2).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
