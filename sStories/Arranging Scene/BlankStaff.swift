import UIKit

class BlankStaff: UIImageView {
    
    var staffImage = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        
        setup()
        
    }
    
    func setup(){
        
        // Set up image
        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("blankStaff.png")
        staffImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.width*3, height: frame.height*3), scale: 1)
//        image = staffImage
        
//        contentMode = .scaleAspectFill
        
        backgroundColor = .red
        isUserInteractionEnabled = true
        clipsToBounds = true
        setNeedsDisplay()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}











































//import UIKit
//
//class BlankStaff: UIImageView {
//
//    var staffImage = UIImage()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .red
//        fillSuperview()
//        setup()
//
//    }
//
//    func setup(){
//
//        // Set up image
//        let imageURL = Bundle.main.resourceURL?.appendingPathComponent("blankStaff.png")
//        staffImage = downsample(imageAt: imageURL!, to: CGSize(width: frame.width*3, height: frame.height*3), scale: 1)
//        image = staffImage
//
//        // downsample(imageAt: imageURL!, to: CGSize(width: frame.height*3, height: frame.height*3), scale: 1)
//
//        contentMode = .scaleAspectFill
//        backgroundColor = .red
//        isUserInteractionEnabled = true
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
