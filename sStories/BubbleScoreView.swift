import UIKit

class BubbleScoreView: UIView {
    
    var label : UILabel!
    var noteImage : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLabel()
        setupImage()
        setupLayout()

        alpha = 0.0
        
    }
    
    func setupLabel(){
        
        label = UILabel()
        label.font = UIFont(name: "Papyrus", size: frame.width/8)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "\(totalBubbleScore)    x    "
        addSubview(label)
        
    }
    
    func setupImage(){
        noteImage = UIImageView()
        noteImage.image = resizedImage(name: "bubbleScoreNoteImage")
        noteImage.contentMode = .scaleAspectFit
        addSubview(noteImage)
    }
    
    func addToScore(){
        
        fadeTo(opacity: 1.0, time: 0.3, {
            totalBubbleScore += 1
            self.label.text = "\(totalBubbleScore)    x    "
            
            self.noteImage.scaleTo(scaleTo: 1.2, time: 0.4,{
                self.noteImage.scaleTo(scaleTo: 1.0, time: 0.4, {
                    self.fadeTo(opacity: 0.0, time: 2.0)
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
