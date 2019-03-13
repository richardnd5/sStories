import UIKit
import AudioKit

//protocol ButtonDelegate : class {
//    func exitButtonTapped()
//}

class KeyboardTurner: UIView {
    
    var keyboardIsActive = false
    var initialPosition : CGPoint!
    
    var whiteKeyArray = [PianoKey]()
    var blackKeyArray = [PianoKey]()
    var exitButton : ExitButton!
    var tap : UITapGestureRecognizer!
    var chordArray : Array<PageTurnPianoNote>!
    
    var activatedKey : PianoKey!
    var keyPlaying = false

    
    weak var delegate : SceneDelegate?
    
    init(frame: CGRect, _ currentPage: Int = 0) {
        super.init(frame: frame)
        initialPosition = CGPoint(x: frame.minX, y: frame.minY)
        fillChordArray(currentPage: currentPage)

        drawKeyboard()
        alpha = 0.0
        fadeTo(opacity: 1.0, time: 1.5)
    }
    
    var notesActive = [PageTurnPianoNote]()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

            for touch in touches {
                let location = touch.location(in: self)
                checkIfKeyPlayingInLocation(location)
        }
    }
    
    func checkIfKeyPlayingInLocation(_ location: CGPoint){
        blackKeyArray.forEach { view in
            if view.frame.contains(location) && !keyPlaying {
                if partOfChord(noteToCheck: Int(view.keyNumber), chordArray: chordArray){
                    view.playKey()
                    activatedKey = view
                    keyPlaying = true
                    
                    if !notesActive.contains(PageTurnPianoNote(rawValue: view.keyNumber!)!) {
                        notesActive.append(PageTurnPianoNote(rawValue: view.keyNumber!)!)
                    }
                }
            }
        }
        
        whiteKeyArray.forEach { view in
            if view.frame.contains(location) && !keyPlaying {

                if partOfChord(noteToCheck: Int(view.keyNumber), chordArray: chordArray){
                    view.playKey()
                    activatedKey = view
                    keyPlaying = true
                    
                    if !notesActive.contains(PageTurnPianoNote(rawValue: view.keyNumber!)!) {
                        notesActive.append(PageTurnPianoNote(rawValue: view.keyNumber!)!)
                    }
                }

            }
        }
        
        // check if you have all the notes
        if notesActive.count == chordArray.count {
            print("counted them all!")
            // make new arrays. fill them.
            var notesArray = [Int]()
            var chordArrayToCheck = [Int]()
            notesActive.forEach { note in
                notesArray.append(Int(note.rawValue))
            }
            chordArray.forEach { note in
                chordArrayToCheck.append(Int(note.rawValue))
            }
            // sort the arrays
            notesArray = notesArray.sorted()
            chordArrayToCheck = chordArrayToCheck.sorted()
            // check if the same
            if notesArray.elementsEqual(chordArrayToCheck){
                triggerFinishAnimation()
            }
        }
    }
    
    func fillChordArray(currentPage: Int){
        chordArray = [PageTurnPianoNote]()
        arpeggioArray[currentPage].forEach { note in
            chordArray.append(note)
        }
    }
    
    func partOfChord(noteToCheck: Int, chordArray: [PageTurnPianoNote]) -> Bool {
        var bool : Bool
        chordArray.contains(PageTurnPianoNote(rawValue: MIDINoteNumber(noteToCheck))!) ? (bool = true) : (bool = false)
        return bool
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            for touch in touches {
                let location = touch.location(in: self)
                subviews.forEach { view in
                    if view.frame.contains(location) && view is PianoKey{
                        let key = view as! PianoKey
                        if activatedKey != nil {
                            key.stopKey()
                            activatedKey.stopKey()
                            activatedKey = nil
                            keyPlaying = false
                        }
                    }
                }
            }
        
        
    }

    func drawKeyboard(){
        
        // 36, 38,40,41,43,45,47,48,50,52,53,55,57,59,60,62,64,65,67,69,71,72,74,76,77,79,81,83,84,86
//        let whiteKeyNumbers = [36,38,40,41,43,45,47,48,50,52,53,55,57,59,60,62,64,65,67,69,71,72,74,76,77,79,81,83,84,86]
        
        let whiteKeyNumbers = [41,43,45,47,48,50,52,53,55,57,59,60,62,64,65,67,69,71,72,74,76]
                                // 37,39,0,42,44,46,0,49,51,0,54,56,58,0
        let blackKeyNumbers = [42,44,46,0,49,51,0,54,56,58,0,61,63,0,66,68,70,0,73,75,0,78]

//        let whiteKeyNumbers = [60,62,64,65,67,69,71,72,74,76,77,79,81,83,84]
//        let blackKeyNumbers = [61,63,0,66,68,70,0,73,75,0,78,80,82,0,85]
        
        
        layer.zPosition = 200
        let numberOfWhiteKeys = CGFloat(whiteKeyNumbers.count)
        
        let whiteKeyWidth = frame.width/numberOfWhiteKeys
        let blackKeyWidth = whiteKeyWidth*0.68
        let blackKeyHeight = frame.height*0.64
        
        // add white keys
        for i in 0...Int(numberOfWhiteKeys)-1 {
            let fr = CGRect(x: whiteKeyWidth*CGFloat(i), y: 0, width: whiteKeyWidth, height: frame.height)
            

            
            let key = PianoKey(frame: fr, type: .white, keyNumber: MIDINoteNumber(whiteKeyNumbers[i]))
            addSubview(key)
            if partOfChord(noteToCheck: whiteKeyNumbers[i], chordArray: chordArray){
                print("part of chord! \(whiteKeyNumbers[i])")
                key.setupTargetDot()
            }
            whiteKeyArray.append(key)
            

        }
        
        // add black keys
        for i in 0...whiteKeyArray.count-1 {
            if i <= blackKeyNumbers.count-1 {
                if blackKeyNumbers[i] == 0 {
                    continue
                } else {
                    let frame = CGRect(x: whiteKeyArray[i].frame.midX+blackKeyWidth/4, y: 0, width: blackKeyWidth, height: blackKeyHeight)
                    let key = PianoKey(frame: frame, type: .black, keyNumber: MIDINoteNumber(blackKeyNumbers[i]))
                    addSubview(key)
                    if partOfChord(noteToCheck: blackKeyNumbers[i], chordArray: chordArray){
                        print("part of chord! \(whiteKeyNumbers[i])")
                        key.setupTargetDot()
                    }
                    blackKeyArray.append(key)
                    
                }
            }
        }
    }
    
    func triggerFinishAnimation(){
        
        isUserInteractionEnabled = false
        
        for (i, note) in chordArray.enumerated(){
            // accelerando
//            let time = i*(4.0*(1/(i+1)))
            
            // 0.0, 0.1, 0.2-
            let time = i*0.1
            let accelTime = time - (time/(14-i))
            print("time: \(i) \(time)")
            
            
            
            Timer.scheduledTimer(withTimeInterval: accelTime, repeats: false) { _ in
                self.whiteKeyArray.forEach({ key in
                    if Int(key.keyNumber) == note.rawValue{
                        key.turnPageAnimationPlayNote()
                        self.makeNoteAppearFlyAwayAndFade(location: key.frame.origin)
                    }
                })
                self.blackKeyArray.forEach({ key in
                    if Int(key.keyNumber) == note.rawValue{
                        key.turnPageAnimationPlayNote()
                        self.makeNoteAppearFlyAwayAndFade(location: key.frame.origin)
                    }
                })
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            playSoundClip(.pageTurn)
            self.delegate!.nextPage()
            self.fadeAndRemove(time: 1.5)
        }
    }
    
    func makeNoteAppearFlyAwayAndFade(location: CGPoint){
        
        let width = frame.width/20
        let height = frame.width/20
        let x = location.x
        let y = location.y
        let note = MiniNote(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(note)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


