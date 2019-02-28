import UIKit
import AudioKit

protocol ButtonDelegate : class {
    func exitButtonTapped()
    func chordButtonTapped(chord: ChordType)
}

class BubblePlayZone: UIView, ButtonDelegate, UIGestureRecognizerDelegate {
    
    var background : BackgroundImage!

    // Buttons
    var exitButton : ExitButton!
    var IChordButton : ChordSwitchButton!
    var IVChordButton : ChordSwitchButton!
    var VChordButton : ChordSwitchButton!
    var offButton : ChordSwitchButton!
    
    // Note dragging variables
    var arrayOfRanges = [ClosedRange<CGFloat>]()
    var previousNote : Int!
    let pitchBendArray = [-7,-5,-3,-1,0,2,4,5,7,9,11,12,14,16,17,19,21]

    // Animator variables.
    var animator: UIDynamicAnimator!
    let gravityBehavior = UIGravityBehavior()
    let collisionBehavior = UICollisionBehavior()
    
    var tap : UITapGestureRecognizer!
    // Functionality variables
    var isActive = false
    var initialPosition : CGPoint!
    weak var delegate : SceneDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialPosition = CGPoint(x: frame.minX, y: frame.minY)
        createExitButton()
        createChordButtons()
        setupBackground()
        setupGestures()
        setupAnimator()
        scaleTo(scaleTo: 0.12, time: 0.0)
        
        fillClosedRangeArray()
    }
    // MARK - setup functions.
    func createExitButton(){
        exitButton = ExitButton()
        addSubview(exitButton)
        exitButton.delegate = self
        
        let size = frame.height/10
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -frame.width/30).isActive = true
        exitButton.topAnchor.constraint(equalTo: topAnchor, constant: -size-frame.width/30).isActive = true
        
    }
    
    func createChordButtons(){
        
        let size = frame.height/10
        
        IVChordButton = ChordSwitchButton(frame: CGRect.zero, chord: .IV)
        addSubview(IVChordButton)
        IVChordButton.delegate = self
        IVChordButton.translatesAutoresizingMaskIntoConstraints = false
        IVChordButton.topAnchor.constraint(equalTo: bottomAnchor, constant: frame.width/30).isActive = true
        IVChordButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        IVChordButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        IVChordButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        
        IChordButton = ChordSwitchButton(frame: CGRect.zero, chord: .I)
        addSubview(IChordButton)
        IChordButton.delegate = self
        IChordButton.translatesAutoresizingMaskIntoConstraints = false
        IChordButton.topAnchor.constraint(equalTo: bottomAnchor, constant: frame.width/30).isActive = true
        IChordButton.trailingAnchor.constraint(equalTo: IVChordButton.leadingAnchor, constant: -frame.width/5).isActive = true
        IChordButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        IChordButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        
        VChordButton = ChordSwitchButton(frame: CGRect.zero, chord: .V)
        addSubview(VChordButton)
        VChordButton.delegate = self
        VChordButton.translatesAutoresizingMaskIntoConstraints = false
        VChordButton.topAnchor.constraint(equalTo: bottomAnchor, constant: frame.width/30).isActive = true
        VChordButton.leadingAnchor.constraint(equalTo: IVChordButton.trailingAnchor, constant: frame.width/5).isActive = true
        VChordButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        VChordButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        offButton = ChordSwitchButton(frame: CGRect.zero, chord: .off)
        addSubview(offButton)
        offButton.delegate = self
        offButton.translatesAutoresizingMaskIntoConstraints = false
        offButton.topAnchor.constraint(equalTo: bottomAnchor, constant: frame.width/30).isActive = true
        offButton.leadingAnchor.constraint(equalTo: VChordButton.trailingAnchor, constant: frame.width/5).isActive = true
        offButton.widthAnchor.constraint(equalToConstant: size*0.8).isActive = true
        offButton.heightAnchor.constraint(equalToConstant: size*0.8).isActive = true
        
    }
    
    func createNumberOfBubbles(_ numberOfBubbles: Int = 0){
        for _ in 0..<numberOfBubbles{

        let width = frame.width/14
        let height = frame.width/14
        let x = CGFloat.random(in: frame.width/4...frame.width-frame.width/4)
        let y = CGFloat.random(in: frame.height/40...frame.height/2-frame.height/40)
        let note = PlayZoneBubble(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(note)
        gravityBehavior.addItem(note)
        collisionBehavior.addItem(note)
        
        let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
        press.minimumPressDuration = 0.0
        note.addGestureRecognizer(press)
        press.delegate = self
            
        let pan = UIPanGestureRecognizer(target: self, action: (#selector(handlePan)))
        note.addGestureRecognizer(pan)

        bringSubviewToFront(note)
        
            
        }
    }
    
    func setupAnimator(){
        
        animator = UIDynamicAnimator(referenceView: self)
        
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 0)
        animator.addBehavior(gravityBehavior)
        
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
    }
    
    func setupBackground(){
        
        let fr = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        background = BackgroundImage(frame: fr, "bubbleZoneBackground")
        // for the collision boundary. Easier to increase image size instead of setting new boundaries.
        background.scaleTo(scaleTo: 1.09, time: 3.0)
        let measurement = fr.width/30
        background.addBlurBorder(dx: measurement, dy: measurement, cornerWidth: measurement, cornerHeight: measurement)
        addSubview(background)
    }
    
    func setupGestures(){
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    func fillClosedRangeArray(){
        let numberOfNotes = 16
        let height = frame.width
        for i in 0...numberOfNotes {
            
            let range = CGFloat(i)*height...CGFloat(i+1)*height
            arrayOfRanges.append(range)
        }
    }
    // MARK - Usage Functions
    func popAllBubbles(){
        
            subviews.forEach { view in
                if view is PlayZoneBubble {
                    let note = view as! PlayZoneBubble
                    note.fadeAndRemove(time: 1.4)
                }
            }
    }

    func exitButtonTapped(){
        togglePlayZone()
    }
    
    func chordButtonTapped(chord: ChordType) {
        switch chord {
        case .I:
            Sound.sharedInstance.switchChord(chord: .I)
            IChordButton.isActive = true
            IVChordButton.isActive = false
            VChordButton.isActive = false
        case .IV:
            Sound.sharedInstance.switchChord(chord: .IV)
            IChordButton.isActive = false
            IVChordButton.isActive = true
            VChordButton.isActive = false
        case .V:
            Sound.sharedInstance.switchChord(chord: .V)
            IChordButton.isActive = false
            IVChordButton.isActive = false
            VChordButton.isActive = true
        case .off:
            
            Sound.sharedInstance.switchChord(chord: .off)
            IChordButton.isActive = false
            IVChordButton.isActive = false
            VChordButton.isActive = false
        }
    }
    
    func togglePlayZone(){
        
        if !isActive {
            isActive = true
            scaleTo(scaleTo: 1.0, time: 1, {
                self.exitButton.fadeIn()
                self.IChordButton.fadeIn()
                self.IVChordButton.fadeIn()
                self.VChordButton.fadeIn()
                self.offButton.fadeIn()
                Sound.sharedInstance.startPlaySequencer()
                Sound.sharedInstance.turnDownPond()
                self.createNumberOfBubbles(totalBubbleScore)
                
                self.delegate?.fadeOutTitleAndButtons()
            })
            let point = CGPoint(x: initialPosition.x, y: (superview?.frame.midY)!-frame.height/2)
            moveViewTo(point, time: 1)
            
        } else {
            isActive = false
            scaleTo(scaleTo: 0.12, time: 1)
            exitButton.fadeOut()
            self.IChordButton.fadeOut()
            self.IVChordButton.fadeOut()
            self.VChordButton.fadeOut()
            self.offButton.fadeOut()
            
            delegate?.createRandomBubblesAtRandomTimeInterval(time: 0.7)
            Sound.sharedInstance.stopPlaySequencer()
            Sound.sharedInstance.turnUpPond()
            popAllBubbles()
            self.delegate?.fadeInTitleAndButtons()
            
            let bottomPadding = superview!.frame.height/30
            let selfPadding = frame.height
            let x = (superview?.frame.midX)!-frame.width/2
            let y = (superview?.frame.maxY)!-frame.height-selfPadding-bottomPadding
            let point = CGPoint(x: x, y: y)
            moveViewTo(point, time: 1)
        }
    }

    func checkWhichNoteToPlay(_ sender: UIPanGestureRecognizer){
        let note = sender.view as! PlayZoneBubble
        let xPos = sender.view!.center.x
        let yPos = sender.view!.center.y
        
        for (index, range) in arrayOfRanges.enumerated() {
            if range.contains(xPos) && previousNote != index {
                previousNote = index
                print(index)
                note.pitchBend(amount: Double(pitchBendArray[index]))
            }
        }
        
        let yScaled = Rescale(from: (frame.height, 0), to: (500, 15000)).rescale(yPos)
        note.filter.cutoffFrequency = Double(yScaled)
    }
    // MARK - Gesture Functions
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer){
        
        if background.frame.contains(sender.location(in: self)) {

            let translation = sender.translation(in: self)
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self)
            
        }
        
        let note = sender.view as! PlayZoneBubble
        let pitch = MIDINoteNumber(61)
        if sender.state == .began {
            note.playWave(pitch)
            note.bigWiggle()
            
        }else if sender.state == .changed {

            checkWhichNoteToPlay(sender)
            
        } else if sender.state == .ended {
            note.stopWave(pitch)
            note.stopBigWiggle()
            
            // To move bubble back into view if it is out of bounds.
            if !background.frame.contains(note.frame) {
                var endPoint = note.frame.origin
                
                if note.frame.minX <= background.frame.minX {
                    endPoint.x = background.frame.minX+note.frame.width
                }
                if note.frame.maxX >= background.frame.maxX {
                    endPoint.x = background.frame.maxX-note.frame.width*2
                }
                if note.frame.minY <= background.frame.minY {
                    endPoint.y = background.frame.minY+note.frame.height
                }
                if note.frame.maxY >= background.frame.maxY {
                    endPoint.y = background.frame.maxY-note.frame.height*2
                }
                
                note.moveViewTo(endPoint, time: 0.8)
            }
            
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        if sender.state == .ended && !isActive{
            togglePlayZone()
            delegate?.stopRandomBubbles()
            delegate!.fadeOutTitleAndButtons()
        }
    }
    
    @objc func handlePress(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            let note = sender.view as! PlayZoneBubble
            Sound.sharedInstance.generatePianoImprov(notes: note.pitches, beats: note.rhythms, pressedNote: sender)
            note.pulseToRhythm()
            // Play first note of the sequence on touch down.
            let firstNote = note.pitches[0]
            Sound.sharedInstance.pianoSampler.play(noteNumber: firstNote, velocity: 127)
            note.scaleNoteUpAndDown()
        }
        
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // This function is used to detect touch events on views outside the superview's bounds
        
        var translatedPoint = exitButton.convert(point, from: self)

        if (exitButton.bounds.contains(translatedPoint)) {
            return exitButton.hitTest(translatedPoint, with: event)
        }
        
        else {
            translatedPoint = IChordButton.convert(point, from: self)
            
            if (IChordButton.bounds.contains(translatedPoint)) {
                return IChordButton.hitTest(translatedPoint, with: event)
            }
            
            else {
                translatedPoint = IVChordButton.convert(point, from: self)
                if (IVChordButton.bounds.contains(translatedPoint)) {
                    return IVChordButton.hitTest(translatedPoint, with: event)
                }
                
                else {
                    translatedPoint = VChordButton.convert(point, from: self)
                    if (VChordButton.bounds.contains(translatedPoint)) {
                        return VChordButton.hitTest(translatedPoint, with: event)
                    } else {
                        translatedPoint = offButton.convert(point, from: self)
                        if (offButton.bounds.contains(translatedPoint)) {
                            return offButton.hitTest(translatedPoint, with: event)
                        }
                    }
            }
        }
        }
        return super.hitTest(point, with: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



