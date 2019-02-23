import UIKit
import AudioKit

protocol ButtonDelegate : class {
    func exitButtonTapped()
    func chordButtonTapped(chord: ChordType)
}

class BubblePlayZone: UIView, ButtonDelegate {
    
    func chordButtonTapped(chord: ChordType) {
        switch chord {
            case .I:
                print("I Chord Tapped!")
            Sound.sharedInstance.switchChord(chord: .I)
            IChordButton.isActive = true
            IVChordButton.isActive = false
            VChordButton.isActive = false
            case .IV:
                print("IV Chord Tapped!")
            Sound.sharedInstance.switchChord(chord: .IV)
                IChordButton.isActive = false
                IVChordButton.isActive = true
                VChordButton.isActive = false
            case .V:
                print("V Chord Tapped!")
            Sound.sharedInstance.switchChord(chord: .V)
                IChordButton.isActive = false
                IVChordButton.isActive = false
                VChordButton.isActive = true
        }
    }
    
    
    var isActive = false
    var initialPosition : CGPoint!
    var exitButton : ExitButton!
    var IChordButton : ChordSwitchButton!
    var IVChordButton : ChordSwitchButton!
    var VChordButton : ChordSwitchButton!
    
    var tap : UITapGestureRecognizer!
    weak var delegate : SceneDelegate?
    var background : BackgroundImage!
    
    var animator: UIDynamicAnimator!
    let gravityBehavior = UIGravityBehavior()
    let collisionBehavior = UICollisionBehavior()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialPosition = CGPoint(x: frame.minX, y: frame.minY)
        createExitButton()
        createChordButtons()
        setupBackground()
        setupGestures()
        setupAnimator()
        scaleTo(scaleTo: 0.12, time: 0.0)
    }
    
    var bubbleTimer = Timer()
    func createNumberOfBubbles(_ numberOfBubbles: Int = 0){
        print("creating count")
        for _ in 0..<numberOfBubbles{

        let width = frame.width/20
        let height = frame.width/20
        let x = CGFloat.random(in: frame.width/4...frame.width-frame.width/4)
        let y = CGFloat.random(in: frame.height/40...frame.height/2-frame.height/40)
        let note = PlayZoneBubble(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(note)
        gravityBehavior.addItem(note)
        collisionBehavior.addItem(note)
        
        let pushBehavior = UIPushBehavior(items: [note], mode: UIPushBehavior.Mode.instantaneous)
        
        let randomDirection = CGFloat.pi / CGFloat.random(in: -0.2...0.2)
        let randomMagnitude = CGFloat.random(in: 0...0.3)
        
        pushBehavior.setAngle(randomDirection, magnitude: randomMagnitude)
        animator.addBehavior(pushBehavior)
        
        bringSubviewToFront(note)
        
            
        }
    }
    
    func popAllBubbles(){
        
            subviews.forEach { view in
                if view is PlayZoneBubble {
                    let note = view as! PlayZoneBubble
//                    note.shrinkRotateAndRemove()
                    note.fadeAndRemove(time: 1.4)
                }
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
    
    
    func exitButtonTapped(){
        togglePlayZone()
    }
    
    func setupGestures(){
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        if sender.state == .ended && !isActive{
            togglePlayZone()
            delegate?.stopRandomBubbles()
        }
    }
    
    // This function is used to detect touch events on views outside the superview's bounds
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
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
                    }
            }
        }
        }
        return super.hitTest(point, with: event)
    }
    
    
    func togglePlayZone(){
        
        if !isActive {
            isActive = true
            scaleTo(scaleTo: 1.0, time: 1, {
                self.exitButton.fadeIn()
                self.IChordButton.fadeIn()
                self.IVChordButton.fadeIn()
                self.VChordButton.fadeIn()
//                self.setupAnimator()
                Sound.sharedInstance.startPlaySequencer()
                self.createNumberOfBubbles(totalBubbleScore)
                
                
//                self.createRandomBubblesAtRandomTimeInterval(time: 0.1)
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
            delegate?.createRandomBubblesAtRandomTimeInterval(time: 0.4)
            Sound.sharedInstance.stopPlaySequencer()
            popAllBubbles()
            
            let bottomPadding = superview!.frame.height/30
            let selfPadding = frame.height
            let x = (superview?.frame.midX)!-frame.width/2
            let y = (superview?.frame.maxY)!-frame.height-selfPadding-bottomPadding
            let point = CGPoint(x: x, y: y)
            moveViewTo(point, time: 1)
        }
    }
    
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



