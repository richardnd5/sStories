import UIKit

class ArrangingScene: UIView {
    
    
    var melodySlotViews = [UIView]()
    
    var songSlots = MelodySlots()
    var sackToArrange = SackToArrange()
    var trebleClef : MusicSymbol?
    var doubleBar : MusicSymbol?
    var sackContents = SackContents()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createArrangementSlots()
        createSackContents()

    }
    
    func createArrangementSlots(){
        
        let width = frame.width/1.3
        let height = frame.height/6
        
        songSlots = MelodySlots(frame: CGRect(x: frame.width/2-width/2, y: frame.height/10, width: width, height: height))
        addSubview(songSlots)
    }
    
    func createSackContents(){
        
        let width = frame.width/2
        let height = frame.height/8
        
        sackContents = SackContents(frame: CGRect(x: width-width/2, y: frame.height-frame.height/10-height*1.5, width: width, height: height))
        addSubview(sackContents)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
