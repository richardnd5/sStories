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
        alpha = 0.0
        
    }
    
    func createLabel(){
        
        label = UILabel()
        label.font = UIFont(name: "Papyrus", size: frame.width/8)
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
        
        fadeTo(time: 0.3, opacity: 1.0, {
            BubbleScoreView.score += 1
            self.label.text = "\(BubbleScoreView.score)    x    "
            
            self.noteImage.scaleTo(scaleTo: 1.2, time: 0.4,{
                self.noteImage.scaleTo(scaleTo: 1.0, time: 0.4, {
                    self.fadeTo(time: 2.0, opacity: 0.0)
                })
            })
        })

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
