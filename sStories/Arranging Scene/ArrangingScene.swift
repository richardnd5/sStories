import UIKit

class ArrangingScene: UIView {
    
    var songSlots = MelodySlots()
    var sackToArrange = SackToArrange()
    var trebleClef : MusicSymbol?
    var doubleBar : MusicSymbol?
    var sackContents = SackContents()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createArrangementSlots()
        createSack()
        
        //fade the view in
        alpha = 0.0
        changeOpacityOverTime(view: self, time: 1.5, opacity: 1.0, {
            self.generateCollectedMelodies()
        })

    }
    
    func createArrangementSlots(){
        
        let width = frame.width/1.3
        let height = frame.height/6
        
        songSlots = MelodySlots(frame: CGRect(x: frame.width/2-width/2, y: frame.height/10, width: width, height: height))
        addSubview(songSlots)
    }
    
    func createSack(){
        
        let width = frame.width/2
        let height = frame.height/8
        
        sackContents = SackContents(frame: CGRect(x: width-width/2, y: frame.height-frame.height/10-height*1.5, width: width, height: height))
        addSubview(sackContents)
    }
    
    func generateCollectedMelodies(){
        
        for i in 0...sackContents.melodySlotViews.count-1{
            let x = sackContents.melodySlotViews[i].frame.minX+sackContents.frame.minX
            let y = sackContents.melodySlotViews[i].frame.minY+sackContents.frame.minY
            let width = sackContents.melodySlotViews[i].frame.width
            let height = sackContents.melodySlotViews[i].frame.height
            let view = MelodyImage(frame: CGRect(x: x, y: y, width: width, height: height), melody: collectedMelodies[i])
            addSubview(view)
            view.alpha = 0.0
            changeOpacityOverTime(view: view, time: 3, opacity: 1.0, {})
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMelodyPan))
            view.addGestureRecognizer(panGesture)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
            view.addGestureRecognizer(tap)

        }
        
    }
    
    @objc func handleMelodyPan(_ sender: UIPanGestureRecognizer){
        
        let view = sender.view as! MelodyImage
        let translation = sender.translation(in: self)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
            print("type: \(view.data?.type) location: \(sender.location(in: self))")
            print("location of first slot \(songSlots.slotPosition[1].bounds)")
        }
        
    }
    
    @objc func handleMelodyTap(_ sender: UITapGestureRecognizer){
        let view = sender.view as! MelodyImage
        Sound.sharedInstance.playPattern(view.number)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
