import UIKit
import AudioKit
import QuartzCore

protocol ButtonDelegate : class {
    func exitButtonTapped()
    func chordButtonTapped(chord: ChordType)
}

class BubblePlayZone: UIView, ButtonDelegate, UIGestureRecognizerDelegate {
    
    var background : BackgroundImage!

    // Buttons
    var exitButton : ExitButton!
    var IChordButton : NewChordSwitchButton!
    var IVChordButton : NewChordSwitchButton!
    var VChordButton : NewChordSwitchButton!
    var offButton : NewChordSwitchButton!
    
    // Note dragging variables
    var arrayOfRanges = [ClosedRange<CGFloat>]()
    var previousNote : Int!
    let pitchBendArray = [-8,-7,-5,-3,-1,0,2,4,5,7,9,11,12,14,16,17,19,21,23,24,26,28,29,31,33,35,36]
    
    let noteSliderColors : Array<UIColor> = []

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
        setupBackground()
        createChordButtons()
        setupGestures()
        setupAnimator()
        fillClosedRangeArray()

        scaleTo(scaleTo: 0.12, time: 0.0)
        self.delegate?.stopRandomBubbles()

        
    }
    // MARK - setup functions.
    func createExitButton(){
        exitButton = ExitButton()
        addSubview(exitButton)
        exitButton.delegate = self
        
        let size = frame.height/20
        let padding = CGFloat(0)
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -padding-frame.width/60).isActive = true
        exitButton.topAnchor.constraint(equalTo: topAnchor, constant: -size-padding).isActive = true
        
    }
    
//    func createChordButtons(){
//
//        let size = frame.height/7
//        //        let size = background.frame.width/4
//
//        IVChordButton = NewChordSwitchButton(frame: CGRect.zero, chord: .IV)
//        addSubview(IVChordButton)
//        IVChordButton.delegate = self
//        IVChordButton.translatesAutoresizingMaskIntoConstraints = false
//        IVChordButton.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        IVChordButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant: -frame.width/9).isActive = true
//        IVChordButton.widthAnchor.constraint(equalToConstant: size).isActive = true
//        IVChordButton.heightAnchor.constraint(equalToConstant: size).isActive = true
//
//
//        IChordButton = NewChordSwitchButton(frame: CGRect.zero, chord: .I)
//        addSubview(IChordButton)
//        IChordButton.delegate = self
//        IChordButton.translatesAutoresizingMaskIntoConstraints = false
//        IChordButton.topAnchor.constraint(equalTo: IVChordButton.topAnchor).isActive = true
//        IChordButton.trailingAnchor.constraint(equalTo: IVChordButton.leadingAnchor, constant: -frame.width/5).isActive = true
//        IChordButton.widthAnchor.constraint(equalToConstant: size).isActive = true
//        IChordButton.heightAnchor.constraint(equalToConstant: size).isActive = true
//
//
//        VChordButton = NewChordSwitchButton(frame: CGRect.zero, chord: .V)
//        addSubview(VChordButton)
//        VChordButton.delegate = self
//        VChordButton.translatesAutoresizingMaskIntoConstraints = false
//        VChordButton.topAnchor.constraint(equalTo: IVChordButton.topAnchor).isActive = true
//        VChordButton.leadingAnchor.constraint(equalTo: IVChordButton.trailingAnchor, constant: frame.width/5).isActive = true
//        VChordButton.widthAnchor.constraint(equalToConstant: size).isActive = true
//        VChordButton.heightAnchor.constraint(equalToConstant: size).isActive = true
//
//        offButton = NewChordSwitchButton(frame: CGRect.zero, chord: .off)
//        addSubview(offButton)
//        offButton.delegate = self
//        offButton.translatesAutoresizingMaskIntoConstraints = false
//        offButton.topAnchor.constraint(equalTo: IVChordButton.topAnchor).isActive = true
//        offButton.leadingAnchor.constraint(equalTo: VChordButton.trailingAnchor, constant: frame.width/5).isActive = true
//        offButton.widthAnchor.constraint(equalToConstant: size*0.8).isActive = true
//        offButton.heightAnchor.constraint(equalToConstant: size*0.8).isActive = true
//
//    }
    
    func createChordButtons(){
        
//        let size = frame.height/7
        let width = frame.width/4
        let height = frame.height/7
        
        IChordButton = NewChordSwitchButton(frame: CGRect.zero, chord: .I)
        addSubview(IChordButton)
        IChordButton.delegate = self
        IChordButton.translatesAutoresizingMaskIntoConstraints = false
        IChordButton.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        IChordButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        IChordButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        IChordButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        IVChordButton = NewChordSwitchButton(frame: CGRect.zero, chord: .IV)
        addSubview(IVChordButton)
        IVChordButton.delegate = self
        IVChordButton.translatesAutoresizingMaskIntoConstraints = false
        IVChordButton.topAnchor.constraint(equalTo: IChordButton.topAnchor).isActive = true
//        IVChordButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant: -frame.width/9).isActive = true
        IVChordButton.leadingAnchor.constraint(equalTo: IChordButton.trailingAnchor).isActive = true
        IVChordButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        IVChordButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    
        VChordButton = NewChordSwitchButton(frame: CGRect.zero, chord: .V)
        addSubview(VChordButton)
        VChordButton.delegate = self
        VChordButton.translatesAutoresizingMaskIntoConstraints = false
        VChordButton.topAnchor.constraint(equalTo: IVChordButton.topAnchor).isActive = true
        VChordButton.leadingAnchor.constraint(equalTo: IVChordButton.trailingAnchor).isActive = true
        VChordButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        VChordButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        offButton = NewChordSwitchButton(frame: CGRect.zero, chord: .off)
        addSubview(offButton)
        offButton.delegate = self
        offButton.translatesAutoresizingMaskIntoConstraints = false
        offButton.topAnchor.constraint(equalTo: IVChordButton.topAnchor).isActive = true
        offButton.leadingAnchor.constraint(equalTo: VChordButton.trailingAnchor).isActive = true
        offButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        offButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        
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
        let width = frame.width
        let partition = width/CGFloat(numberOfNotes)
        print(partition)
        for i in 0...numberOfNotes {
            
            let range = CGFloat(i)*partition...CGFloat(i+1)*partition
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
                self.delegate?.stopRandomBubbles()
            })
            
            let bottomPadding = superview!.frame.height/12
            let point = CGPoint(x: initialPosition.x, y: (superview?.frame.midY)!-frame.height/2-bottomPadding)
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
//        let yScaledAlpha = Rescale(from: (0, frame.height), to: (1.5, 0.0)).rescale(yPos)

        for (index, range) in arrayOfRanges.enumerated() {
            if range.contains(xPos) && previousNote != index {
                previousNote = index
                print(index)
                note.pitchBend(amount: Double(pitchBendArray[index]))
                
                let xScaled = Rescale(from: (0, frame.width), to: (0.0, 1.0)).rescale(xPos)
                let color = UIColor(hue: xScaled, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                note.changeBackgroundColorGraduallyTo(color, time: 0.2)

            }
        }
        
        let yScaled = Rescale(from: (frame.height, 0), to: (0, 2200)).rescale(yPos)
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
            
            if sender.state == .ended {
            // 1
            let velocity = sender.velocity(in: self)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 500
            print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            // 2
            let slideFactor = 0.015 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:sender.view!.center.x + (velocity.x * slideFactor),
                                     y:sender.view!.center.y + (velocity.y * slideFactor))
            // 4
            finalPoint.x = min(max(finalPoint.x, 0), self.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.bounds.size.height)
            
            // 5
            UIView.animate(withDuration: Double(slideFactor * 2),
                           delay: 0,
                           // 6
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {sender.view!.center = finalPoint },
                completion: nil)
            }
            
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



