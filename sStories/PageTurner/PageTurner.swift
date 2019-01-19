import UIKit

class PageTurner: UIView {
    
    var lineContainer = [UIView]()
    var note : WholeNote!
    var noteDestinationSlot : WholeNote!
    var ourFrame : CGRect!
    var noteLocationArray = [ClosedRange<CGFloat>]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.ourFrame = frame

        backgroundColor = .white
        layer.zPosition = 101
        isUserInteractionEnabled = true
        makeLines()
        makeWholeNote()
        makeNoteDestinationSlot()
        fillNoteLocationArray()

    }
    
    func makeLines(){
        let lines = 32 // 32 lines so I have some variables for the spaces for use later.
        let spacing = frame.height/CGFloat(lines)
        for i in 0...lines{
            let line = UIView(frame: CGRect(x: 0, y: CGFloat(i)*spacing, width: frame.width, height: 2))
            addSubview(line)
            lineContainer.append(line)
            // This is just a bit of math to draw the correct lines.
            if i % 2 == 0 && i >= 3*2 && i != 8*2 && i < 14*2 {
                line.backgroundColor = .black
            }
        }
    }
    
    func fillNoteLocationArray(){
        let backwardsArray = lineContainer.reversed()
        backwardsArray.forEach { (view) in
            print(view.frame.midY)
//            let range = ClosedRange<view.frame.midY>
        }
        
    }
    
    func makeWholeNote(){
        let width = frame.width/1.5
        let height = frame.width/1.5
        let x = frame.width/2-width/2
        let y = frame.height-height*2
        note = WholeNote(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(note!)
        note?.layer.zPosition = 2
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleNotePan))
        note?.addGestureRecognizer(pan)
    }
    
    func makeNoteDestinationSlot(){
        let width = frame.width/1.5
        let height = frame.width/1.5
        let x = frame.width/2-width/2
        let y = lineContainer[8].frame.origin.y-height/2 // lineContainer index 8 is line "D" in the top staff
        noteDestinationSlot = WholeNote(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(noteDestinationSlot!)
        noteDestinationSlot?.isUserInteractionEnabled = false
        noteDestinationSlot?.layer.opacity = 0.3
        
    }
    
    var previousPlayedNote : Int!
    func playNoteAsItPasses(_ point: CGFloat){
        switch point{
            
        default:
            return
        }
        
        
    }
    
    @objc func handleNotePan(_ sender: UIPanGestureRecognizer){
        
        let view = sender.view as! WholeNote
        
            let translation = sender.translation(in: self)
            sender.view!.center = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self)
        
            if sender.state == .changed {
                let yPos = sender.location(in: self).y
                playNoteAsItPasses(yPos)
            }
            
            if sender.state == .ended {

                // check if the melody is in the correct spot.
                let dragSpot = CGRect(x: 0, y: (noteDestinationSlot?.frame.origin.y)!, width: frame.width, height: (noteDestinationSlot?.frame.height)!)
                
                if dragSpot.contains(sender.location(in: self)){
                    // This is the movement and lock to spot animation
                    let time = 0.4
                    let finalPlace = noteDestinationSlot?.frame.origin
                    view.moveViewTo(CGPoint(x: (finalPlace?.x)!, y: lineContainer[1].frame.origin.y-((note?.frame.height)!/2)), time: time, {})
                    view.scaleTo(scaleTo: 1.5, time: 0.5) {
                        view.scaleTo(scaleTo: 1.0, time: 0.2, {})
                        view.moveViewTo(finalPlace!, time: 0.2, {})
//                        // fade out page turner
//                        changeOpacityOverTime(view: self, time: 1.0, opacity: 0.0, {
//                            self.isUserInteractionEnabled = false
//                        })
                    }
                }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
