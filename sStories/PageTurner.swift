import UIKit

class PageTurner: UIView {
    
    var lineContainer = [UIView]()
    var note : WholeNote?
    var noteDestinationSlot : WholeNote?
    var ourFrame : CGRect?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.ourFrame = frame

        backgroundColor = .white
        layer.zPosition = 101
        makeLines()
        makeWholeNote()
        makeNoteDestinationSlot()

    }
    
    func makeLines(){
        let lines = CGFloat(16)
        let spacing = frame.height/lines
        print(frame)
        for i in 0...16{
            if i >= 3 && i != 8 && i < 14 {
            let line = UIView(frame: CGRect(x: 0, y: CGFloat(i)*spacing, width: frame.width, height: 2))
            line.backgroundColor = .black
            addSubview(line)
                lineContainer.append(line)
            }
        }
    }
    
    func makeWholeNote(){
        let width = frame.width/1.5
        let height = frame.width/1.5
        let x = frame.width/2-width/2
        let y = frame.height-height*2
        note = WholeNote(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(note!)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleNotePan))
        note?.addGestureRecognizer(pan)
    }
    
    func makeNoteDestinationSlot(){
        let width = frame.width/1.5
        let height = frame.width/1.5
        let x = frame.width/2-width/2
        let y = lineContainer[0].frame.origin.y-height/2
        noteDestinationSlot = WholeNote(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(noteDestinationSlot!)
        noteDestinationSlot?.isUserInteractionEnabled = false
        noteDestinationSlot?.layer.opacity = 0.3
        
    }
    
    @objc func handleNotePan(_ sender: UIPanGestureRecognizer){
        
        let view = sender.view as! WholeNote
        
            let translation = sender.translation(in: self)
            sender.view!.center = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self)
            
            if sender.state == .ended {
                print("line container frame: \(lineContainer[0].frame)")
                print("sender.location: \(sender.location(in: self))")
                if lineContainer[0].frame.contains(sender.location(in: self)) {
                    print("we're in")
                    let time = 1.0
                    view.moveViewTo(frame.origin, time: time)
        }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
