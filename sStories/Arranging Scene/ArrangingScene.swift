import UIKit

class ArrangingScene: UIView {
    
    var songSlots = MelodySlots()
    var melodyImageArray = [MelodyImage]()
    var sackToArrange = SackToArrange()
    var trebleClef : MusicSymbol?
    var doubleBar : MusicSymbol?
    var sackContents = SackContents()
    var playButton : PlayButton?
    var instructionLabel: Label?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createArrangementSlots()
        createSack()
        createInstructionLabel()
        
        //fade the view in
        alpha = 0.0
        changeOpacityOverTime(view: self, time: 1.5, opacity: 1.0, {
            self.generateCollectedMelodies()
        })
    }
    
    func createInstructionLabel(){
        // add keep label
        instructionLabel = Label(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height/4), words: "Drag the melodies to their correct spots!", fontSize: frame.width/40)
        
        addSubview(instructionLabel!)
        instructionLabel?.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        instructionLabel?.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/80).isActive = true
    }
    
    func createPlayButton(){
        
        // Gross. Next time. Learn about dynamically changing auto layout...
        let width = frame.width/6
        let height = frame.height/6
        let x = frame.width/2-width/2
        let y = frame.height/2-height
        
        playButton = PlayButton(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(playButton!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePlayTap))
        playButton?.addGestureRecognizer(tap)
        
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
            melodyImageArray.append(view)
            
            view.alpha = 0.0
            changeOpacityOverTime(view: view, time: 1.5, opacity: 1.0, {})
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMelodyPan))
            view.addGestureRecognizer(panGesture)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
            view.addGestureRecognizer(tap)

        }
        
    }
    
    func songFullyArranged() -> Bool{
        var bool = false
        for i in 0...melodyImageArray.count-1 {
            if !melodyImageArray[i].inCorrectSlot {
                bool = false
                break
            } else {
                bool = true
            }
        }
        return bool
    }
    
    @objc func handleMelodyPan(_ sender: UIPanGestureRecognizer){
        
        let view = sender.view as! MelodyImage
        
        if !view.inCorrectSlot {

        let translation = sender.translation(in: self)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
            
            // Look through each slot position
            for i in 0...songSlots.slotPosition.count-1 {
                // convert the frame to the superview's superview coordinate system
                let frame = songSlots.convert(songSlots.slotPosition[i].frame, to: self)
                // check if the melody is in the correct spot.
                if frame.contains(sender.location(in: self)) && view.data?.slotPosition == i {
                    // if it is, move it to the position and resize it.
                    let time = 0.4
                    view.moveViewTo(frame.origin, time: time)
                    view.changeSize(to: songSlots.slotPosition[i].frame.size, time: time)
                    view.inCorrectSlot = true
                    
                    if songFullyArranged() {
                        print("We're ready for the play button!")
                        createPlayButton()
                    }
                }
            }
        }
        }
    }
    
    @objc func handleMelodyTap(_ sender: UITapGestureRecognizer){
        let view = sender.view as! MelodyImage
        Sound.sharedInstance.playPattern(view.number)
    }
    
    @objc func handlePlayTap(_ sender: UITapGestureRecognizer){
        print("time to play the sound.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
