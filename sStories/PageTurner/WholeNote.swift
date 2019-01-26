import UIKit

class WholeNote: UIImageView {
    
    var noteImage = UIImage()
    var scaleSize : CGFloat = 1.0
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
    }
    
    func setupImage(){

        image = resizedImage(name: "wholeNote", frame: frame, scale: 3)
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }

    func makeNoteAppearFlyAwayAndFade(){
        
        let width = frame.width/1.25
        let height = frame.width/1.25
        let x = frame.width/2-width/2
        let y = frame.height-height*2
        let note = MiniNote(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(note)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
