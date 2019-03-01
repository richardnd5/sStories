import UIKit
import AudioKit


// MOVE LATER!!!!!!!!
enum PageTurnPianoNote : MIDINoteNumber, CaseIterable {
//    case F1 = 29
//    case Gb1 = 30
//    case Ab1 = 32
//    case Bb1 = 34
//    case C1 = 36
//    case Db2 = 37
//    case Eb2 = 39
//    case F2 = 41
    
    case Gb2 = 42
    case Ab2 = 44
    case Bb2 = 46
    case C3 = 48
    case Db3 = 49
    case Eb3 = 51
    case F3 = 53
    case Gb3 = 54
    case Ab3 = 56
    case Bb3 = 58
    case C4 = 60
    case Db4 = 61
    case Eb4 = 63
    case F4 = 65
    case Gb4 = 66
    case Ab4 = 68
    case Bb4 = 70
    case C5 = 72
    case Db5 = 73
    case Eb5 = 75
    case F5 = 77
    case Gb5 = 78
    case Ab5 = 80
    case Bb5 = 82
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
    var previousPlayedNote : Int!
    
    weak var delegate : SceneDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.ourFrame = frame

        backgroundColor = .white
        layer.zPosition = 101
        isUserInteractionEnabled = true
        
        makeLines()
        makeWholeNote()
        makeArrow()
        makeNoteDestinationSlot()
        fillNoteLocationArray()
        
        alpha = 0.0
        fadeTo(opacity: 1.0, time: 1.0)
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
            } else {
                line.backgroundColor = .red
            }
        }
    }
    
    func fillNoteLocationArray(){
        let backwardsArray = lineContainer.reversed()
        backwardsArray.forEach { view in
            let range = (view.frame.midY-30)...(view.frame.midY+10)
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
    
    
    var prevNotePageTurn : PageTurnPianoNote!
    func playNote(_ noteToPlay: PageTurnPianoNote){
        if prevNotePageTurn != noteToPlay {
            
            Sound.sharedInstance.playNote(noteToPlay)
            print(noteToPlay)
            prevNotePageTurn = noteToPlay
            note.makeNoteAppearFlyAwayAndFade()
        }
    }
    
    // get point
    // see where the point is in the line array
    // trigger note playing if is one of the "active chords"
    
    var arppeggioArray = [PageTurnPianoNote]()
    
    func fillArpeggioArray(){
        arppeggioArray.append(PageTurnPianoNote.Ab2)
        arppeggioArray.append(PageTurnPianoNote.Eb3)
        arppeggioArray.append(PageTurnPianoNote.F3)
        arppeggioArray.append(PageTurnPianoNote.Bb3)
        arppeggioArray.append(PageTurnPianoNote.C4)
        arppeggioArray.append(PageTurnPianoNote.Eb4)
        arppeggioArray.append(PageTurnPianoNote.Ab4)
    }
    
    func checkNoteToPlay(_ point: CGFloat){
        for (index, range) in noteLocationArray.enumerated() {
            if range.contains(point) && index >= 4 {
                print(index)
                let keyOffset = index-4
                playNote(PageTurnPianoNote.allCases[keyOffset])
                break
            }
        }
    }
    
    func checkWhichNoteToPlay(_ point: CGFloat){
        
        if noteLocationArray.count-1 == 32 {
        
        switch point {

        case noteLocationArray[6]:
//            playNoteIfNotLastNotePlayed(0)
            playNote(.Gb2)

        case noteLocationArray[10]:
//            playNoteIfNotLastNotePlayed(1)
            playNote(.Db3)

        case noteLocationArray[14]:
//            playNoteIfNotLastNotePlayed(2)
            playNote(.Ab3)
            
        case noteLocationArray[15]:
//            playNoteIfNotLastNotePlayed(3)
            playNote(.Bb3)

        case noteLocationArray[17]:
            playNoteIfNotLastNotePlayed(4)
//            playNote(.Db4)

        case noteLocationArray[20]:
            playNoteIfNotLastNotePlayed(5)
//            playNote(.Gb4)
            
        case noteLocationArray[21]:
            playNoteIfNotLastNotePlayed(6)
//            playNote(.Ab4)

        case noteLocationArray[24]:
            playNoteIfNotLastNotePlayed(6)
//            playNote(.Db5)
            
        default:
            return
        }
        }
        
    }
    
    
    
    func playNoteIfNotLastNotePlayed(_ noteNumber: Int){
        let noteSlot = noteNumber
        if previousPlayedNote != noteSlot {
            Sound.sharedInstance.pageTurnSoundArray[noteSlot].playNote()
            previousPlayedNote = noteSlot
            note.makeNoteAppearFlyAwayAndFade()
        }
    }
    
    func triggerFinishAnimation(view: WholeNote){
        let time = 0.7
        let penultimatePlace = lineContainer[3].frame
        let finalPlace = noteDestinationSlot?.frame.origin

        playNoteIfNotLastNotePlayed(7)
        view.moveViewTo(CGPoint(x: (finalPlace?.x)!, y: penultimatePlace.minY), time: time, {
            
            self.playNoteIfNotLastNotePlayed(8)
            view.moveViewTo(finalPlace!, time: 0.6, {
                playSoundClip(.pageTurn)
                self.fadeAndRemove(time: 1.5)
                self.delegate!.nextPage()
            })
        })
    }
    
    @objc func handleNotePan(_ sender: UIPanGestureRecognizer){
        
        let view = sender.view as! WholeNote
        
        if view.frame.origin.y > noteDestinationSlot.frame.maxY {
            
            if sender.state == .began && arrow.isVisible {
                arrow.fadeAndRemove(time: 1.5)
            }
            
            let translation = sender.translation(in: self)
            sender.view!.center = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self)
            
            let yPos = view.frame.midY
//            checkWhichNoteToPlay(yPos)
            checkNoteToPlay(yPos)
            
        } else if view.frame.origin.y <= noteDestinationSlot.frame.maxY && sender.state != .ended {
            sender.state = .ended
            triggerFinishAnimation(view: view)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
