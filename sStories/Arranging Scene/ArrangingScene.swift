import UIKit

class ArrangingScene: UIView {
    
    enum State {
        case arranging
        case arrangementCompleted
    }
    
    var sceneState = State.arranging
    
    var songSlots = MelodySlots()
    var melodyImageArray = [MelodyImage]()
    
    var sackContents = SackContents()
    var playButton : PlayButton?
    var instructionLabel: Label?
    var background: ArrangingBackground?
    
    weak var delegate : SceneDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackgroundImage()
        createInstructionLabel()
        createArrangementSlots()
        createSack()
        fillSackWithMelodies()
        
        //fade the view in
        alpha = 0.0
        
        fadeTo(time: 1.5, opacity: 1.0, {
            self.generateCollectedMelodies()
        })
        
    }
    
    func setupBackgroundImage(){
        let ourFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        background = ArrangingBackground(frame: ourFrame)
        addSubview(background!)
    }
    
    func createInstructionLabel(){
        
        let height = frame.height/20
        let y = frame.height/60
        instructionLabel = Label(frame: CGRect.zero, words: "Time to arrange the melodies! Drag the melodies to their correct spots.", fontSize: height)
        addSubview(instructionLabel!)
        
        let safe = safeAreaLayoutGuide
        instructionLabel?.anchor(top: topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: nil, padding: UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0), size: .zero)
        instructionLabel?.heightAnchor.constraint(equalToConstant: frame.height/18)
        
        
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
        
        songSlots = MelodySlots(frame: CGRect(x: frame.width/2-width/2, y: frame.height/8, width: width, height: height))
        addSubview(songSlots)
    }
    
    func createSack(){
        
        let width = frame.width/2
        let height = frame.height/8
        
        sackContents = SackContents(frame: CGRect(x: width-width/2, y: frame.height-frame.height/10-height*2, width: width, height: height))
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
            view.initialPosition = CGPoint(x: x, y: y)
            melodyImageArray.append(view)
            
            view.alpha = 0.0
            view.fadeTo(time: 1.5, opacity: 1.0)
            
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
            
            if sender.state == .began {
                loopSoundEffect(.arrangingDrag)
            }
            
            let translation = sender.translation(in: self)
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self)
//            playSoundClip(.arrangingDrag)
            
            if sender.state == .ended {
                stopLoopedSoundEffect(.arrangingDrag)
                // Look through each slot position
                for i in 0...songSlots.slotPosition.count-1 {
                    // convert the frame to the superview's superview coordinate system
                    let frame = songSlots.convert(songSlots.slotPosition[i].frame, to: self)
                    // check if the melody is in the correct spot.
                    if frame.contains(sender.location(in: self)) && view.data?.slotPosition == i {
                        // if it is, move it to the position and resize it.
                        let time = 0.4
                        view.moveViewTo(frame.origin, time: time, {})
                        view.changeSize(to: songSlots.slotPosition[i].frame.size, time: time)
                        view.inCorrectSlot = true
                        playSoundClip(.arrangingPlaceMelody)
                        
                        if songFullyArranged() {
                            Sound.sharedInstance.loadCollectedMelodies(collectedMelodies)
                            Sound.sharedInstance.putMelodiesIntoSequencerInOrder()
                            playSoundClip(.arrangingAllMelodiesLocked)
                            createPlayButton()
                            instructionLabel?.changeText(to: "Great job! Time to get ready for the performance.")
                            sceneState = .arrangementCompleted
                            delegate?.returnToStory()
                        }
                    } else {
                        // move view to original position
                        view.moveViewTo(view.initialPosition, time: 0.5)
                        // play not correct slot sound.
                    }
                }
            }
        }
    }
    
    @objc func handleMelodyTap(_ sender: UITapGestureRecognizer){
        let view = sender.view as! MelodyImage
        view.playMelody()
    }
    
    @objc func handlePlayTap(_ sender: UITapGestureRecognizer){
        Sound.sharedInstance.playSequencer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
