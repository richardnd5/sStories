import UIKit
import AudioKit


// MOVE LATER!!!!!!!!
enum PageTurnPianoNote : MIDINoteNumber, CaseIterable {
    case Eb2 = 39
    case E2 = 40
    case F2 = 41
    case Gb2 = 42
    case G2 = 43
    case Ab2 = 44
    case A2 = 45
    case Bb2 = 46
    case B2 = 47
    case C3 = 48
    case Db3 = 49
    case D3 = 50
    case Eb3 = 51
    case E3 = 52
    case F3 = 53
    case Gb3 = 54
    case G3 = 55
    case Ab3 = 56
    case A3 = 57
    case Bb3 = 58
    case B3 = 59
    case C4 = 60
    case Db4 = 61
    case D4 = 62
    case Eb4 = 63
    case E4 = 64
    case F4 = 65
    case Gb4 = 66
    case G4 = 67
    case Ab4 = 68
    case A4 = 69
    case Bb4 = 70
    case B4 = 71
    case C5 = 72
    case Db5 = 73
    case D5 = 74
    case Eb5 = 75
    case E5 = 76
    case F5 = 77
    case Gb5 = 78
    case G5 = 79
    case Ab5 = 80
    case A5 = 81
    case Bb5 = 82
    case B5 = 83
    case C6 = 84
    case Db6 = 85
}

class PageTurner: UIView {
    
    var lineContainer = [UIView]()
    var note : WholeNote!
    var noteDestinationSlot : WholeNote!
    var arrow : Arrow!
    var ourFrame : CGRect!
    var noteLocationArray = [ClosedRange<CGFloat>]()
    var previousNoteIndex : Int!
    
    var currentPage : Int!
    
    var chordArray : Array<PageTurnPianoNote>!
//    var chordArray : Array<PageTurnPianoNote> = [.Db3, .F3, .Ab3, .C4, .Db4, .Eb4, .Ab4]
    
    weak var delegate : SceneDelegate?
    
    init(frame: CGRect, _ currentPage: Int = 0) {
        super.init(frame: frame)
        self.ourFrame = frame
        self.currentPage = currentPage
        
        backgroundColor = .white
        layer.zPosition = 101
        isUserInteractionEnabled = true
        
        makeLines()
        makeWholeNote()
        makeArrow()
        makeNoteDestinationSlot()
        fillNoteLocationArray()
//        createRandomChordArpeggio()
        
        fillChordArray(currentPage: currentPage)
        
        alpha = 0.0
        fadeTo(opacity: 1.0, time: 1.0)
        
    }
    
    func fillChordArray(currentPage: Int){
        chordArray = [PageTurnPianoNote]()
        arpeggioArray[currentPage].forEach { note in
            chordArray.append(note)
        }
    }
    
    func createRandomChordArpeggio(){
        chordArray.removeAll()
        for _ in 0...6 {
            let randomNote = PageTurnPianoNote.allCases.randomElement()
            chordArray.append(randomNote!)
        }
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
        backwardsArray.forEach { view in
            let lineWidth = (lineContainer[1].frame.minY-lineContainer[0].frame.maxY)/2
            print("line width: \(lineWidth)")
            let range = (view.frame.midY-lineWidth)...(view.frame.midY+lineWidth)
            noteLocationArray.append(range)
        }
    }
    
    func makeArrow(){
        let width = frame.width/2
        let height = frame.width/2
        let x = frame.width/2-width/2
        let y = note.frame.minY-width
        
        arrow = Arrow(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(arrow!)
        arrow?.layer.zPosition = 1
    }
    
    func makeWholeNote(){
        let width = frame.width/1.5
        let height = frame.width/1.5
        let x = frame.width/2-width/2
        let y = lineContainer[28].frame.midY
        
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
    
    func partOfChord(noteToCheck: PageTurnPianoNote, chordArray: [PageTurnPianoNote]) -> Bool {
        var bool : Bool
        chordArray.contains(noteToCheck) ? (bool = true) : (bool = false)
        return bool
    }
    
    func playNote(_ noteToPlay: PageTurnPianoNote){
        
        Sound.shared.playNote(noteToPlay, 50)
        note.makeNoteAppearFlyAwayAndFade()
        
    }
    
    func checkNoteToPlay(_ point: CGFloat){
        for (index, range) in noteLocationArray.enumerated() {
            if range.contains(point){
                
                if index != previousNoteIndex {
                    previousNoteIndex = index
                    print(index)
                    
                    if index >= 6 {
                        let keyOffset = index-6
                        let note = PageTurnPianoNote.allCases[keyOffset]
                        if partOfChord(noteToCheck: note, chordArray: chordArray) {
                            playNote(note)
                            
                            break
                        }
                    }
                }
            }
        }
    }
    
    func triggerFinishAnimation(view: WholeNote){
        let time = 0.7
        let penultimatePlace = lineContainer[3].frame
        let finalPlace = noteDestinationSlot?.frame.origin
        
        
        playNote(.Ab5)
        view.moveViewTo(CGPoint(x: (finalPlace?.x)!, y: penultimatePlace.minY), time: time, {
            
            self.playNote(.Db5)
            view.moveViewTo(finalPlace!, time: 0.6, {
                playSoundClip(.pageTurn)
                self.fadeAndRemove(time: 1.5)
                self.delegate!.nextPage()
            })
        })
    }
    
    @objc func handleNotePan(_ sender: UIPanGestureRecognizer){
        
        let view = sender.view as! WholeNote
        
//        if view.frame.origin.y > noteDestinationSlot.frame.maxY {
        
            if sender.state == .began && arrow.isVisible {
                arrow.fadeAndRemove(time: 1.5)
            }
            
            let translation = sender.translation(in: self)
            sender.view!.center = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self)
            
            let yPos = view.frame.midY
            checkNoteToPlay(yPos)
            
//        }
//        else if view.frame.origin.y <= noteDestinationSlot.frame.maxY && sender.state != .ended {
//            sender.state = .ended
//        }
        
        if sender.state == .ended {

            // 1
            let velocity = sender.velocity(in: self)
            let magnitude = sqrt(velocity.y * velocity.y)
            let slideMultiplier = magnitude / 600
            
            // 2
            let slideFactor = 0.01 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:sender.view!.center.x,
                                     y:sender.view!.center.y + (velocity.y * slideFactor))
            // 4
//            finalPoint.x = min(max(finalPoint.x, 0), self.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.bounds.size.height)
            
            // 5
            UIView.animate(withDuration: Double(slideFactor * 4),
                           delay: 0,
                           // 6
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {sender.view!.center = finalPoint },
                completion: {
                    _ in
                    
                    if (sender.view?.frame.origin.y)! >= self.frame.height-100 {
                        let point = CGPoint(x: sender.view!.frame.origin.x, y: self.frame.height-100)
                        sender.view?.moveViewTo(point, time: 0.4)
                    }
                    if (sender.view?.frame.origin.y)! <= CGFloat(40) {
                        let point = CGPoint(x: (sender.view!.frame.origin.x), y: CGFloat(40))
                        sender.view?.moveViewTo(point, time: 0.4)
                    }
                    let destinationRange = self.noteDestinationSlot.frame.minY...self.noteDestinationSlot.frame.maxY
                    if destinationRange.contains(view.frame.minY) || destinationRange.contains(view.frame.maxY) {
                        //            if view.frame.origin.y <= noteDestinationSlot.frame.maxY && view.frame.origin.y >= noteDestinationSlot.frame.minY {
                        self.triggerFinishAnimation(view: view)
                    }
            })
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
