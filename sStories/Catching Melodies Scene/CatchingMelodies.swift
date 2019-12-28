import UIKit

protocol CatchingMelodyProtocol : class {
    func reelIn()
}

class CatchingMelodies: UIView, CatchingMelodyProtocol {
    
    enum State {
        case fishing
        case fishOnTheLine
        case catchOrThrowBack
        case fishingDone
    }
    
    var sceneState = State.fishing
    weak var delegate : SceneDelegate?
    
    // Images for the scene
    var pondImage =  UIImageView()
    var fishingPole : FishingPole?
    var melodyImage : MelodyImage?
    var sack : CatchOrThrowbackImage?
    var throwbackWater : CatchOrThrowbackImage?
    var sackContents: SackContents!
    
    // Labels
    var keepLabel : Label?
    var throwbackLabel : Label?
    var instructionLabel: Label?
    
    var melodyImageArray = [MelodyImage]()
    
    var reelInButton : ReelInButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createPond()
        createFishingPole()
        createInstructionLabel()
        createSackContainer()
        setAMelodyToBiteInTheFuture()
        startBackgroundSound()

        //fade the view in
        alpha = 0.0
        fadeTo(opacity: 1.0, time: 2.5, {
            self.delegate?.createRandomBubblesAtRandomTimeInterval(time: 0.7)
        })
    }
    
    func startBackgroundSound(){
        Sound.shared.playPondBackground()
    }
    
    func stopBackgroundSound(){
        Sound.shared.stopPondBackgroundSound()
    }
    
    func createSackContainer(){
        sackContents = SackContents(frame: CGRect(x: 0, y: 0, width: frame.width/4, height: frame.height/17))
        addSubview(sackContents!)
        
        // set up constraints
        sackContents?.translatesAutoresizingMaskIntoConstraints = false
        sackContents?.heightAnchor.constraint(equalToConstant: frame.height/17).isActive = true
        sackContents?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        sackContents?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width/17).isActive = true
        sackContents?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width/1.4).isActive = true
        
    }
    
    func createPond(){
        
        pondImage.image = resizedImage(name: "PondNew", frame: frame)
        addSubview(pondImage)
        pondImage.layer.zPosition = -100
        
        pondImage.contentMode = .scaleAspectFit
        pondImage.translatesAutoresizingMaskIntoConstraints = false
        pondImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pondImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pondImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        pondImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        fadeTo(opacity: 1.0, time: 1.5)
        

        
    }
    
    func createInstructionLabel(){
        // add keep label
        let height = frame.height/18
        let y = frame.height/60
        let sidePadding = frame.width/14
        
        instructionLabel = Label(frame: CGRect.zero, words: "Patiently, Templeton waited for the first bite...", fontSize: height-height/10)
        
        addSubview(instructionLabel!)
        let safe = safeAreaLayoutGuide
        instructionLabel?.anchor(top: topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: nil, padding: UIEdgeInsets(top: y, left: sidePadding, bottom: 0, right: -sidePadding), size: .zero)
        instructionLabel?.heightAnchor.constraint(equalToConstant: frame.height/18).isActive = true
        
    }
    
    func createLabels(){
        
        // add keep label
        keepLabel = Label(frame: CGRect(x: (sack?.frame.midX)!, y: (sack?.frame.minY)!, width: frame.width/3, height: frame.height/4), words: "Keep", fontSize: frame.height/26)
        
        // How do I do this in the line before instead of resetting the origin after it is instantiated. I am using sizeToFit() in it's class so I don't know what to do.
        keepLabel!.frame.origin = CGPoint(x: (sack?.frame.midX)!-keepLabel!.frame.width/2, y: (sack?.frame.minY)!-keepLabel!.frame.height)
        addSubview(keepLabel!)
        
        // add throwback label
        throwbackLabel = Label(frame: CGRect(x: (throwbackWater?.frame.midX)!, y: (throwbackWater?.frame.minY)!, width: frame.width/3, height: frame.height/4), words: "Throw Back", fontSize: frame.height/26)
        
        // Same as the keepLabel
        throwbackLabel!.frame.origin = CGPoint(x: (throwbackWater?.frame.midX)!-throwbackLabel!.frame.width/2, y: (throwbackWater?.frame.minY)!-throwbackLabel!.frame.height)
        addSubview(throwbackLabel!)
        
    }
    
    func createFishingPole(){
        
        let width = frame.width/1.5
        let height = frame.height/1.3
        let x = frame.width/2-width/2
        let y = frame.height-height/2.4
        
        fishingPole = FishingPole(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(fishingPole!)
        
    }
    
    func createReelInButton(){
        
        let randX = CGFloat.random(in: frame.width/2.5...frame.width-frame.width/2.5)
        let randY = CGFloat.random(in: frame.height/2...frame.height/2+frame.height/4)
        
        let width = frame.width/20
        
        let fr = CGRect(x: randX, y: randY, width: width, height: width)
        reelInButton = ReelInButton(frame: fr)
        addSubview(reelInButton)
        reelInButton.catchingMelodyDelegate = self
        
        

    }
    
    func createRandomMelody(){
        
        let missingType = missingMelodyType(melodyArray: melodyImageArray)
        let randomNeededMelody = Melody(type: missingType)
        
        // instantiate it
        melodyImage = MelodyImage(frame: CGRect(x: frame.width/2, y: frame.height/3, width: frame.height/4, height: frame.height/4), melody: randomNeededMelody)

        addSubview(melodyImage!)
        
        // set the origin. (there has to be a better way to do this. How do you know the width and height before it is instantiated?)
        melodyImage!.frame.origin = CGPoint(x: frame.width/2-melodyImage!.frame.width/2, y: frame.height/3-melodyImage!.frame.height/2)
        
        // Give it gesture recognizers
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMelodyPan))
        melodyImage?.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
        melodyImage?.addGestureRecognizer(tapGesture)
        
    }
    
    func moveMelodyToShowDragging(){
        
        isUserInteractionEnabled = false
        let currentPoint = melodyImage?.frame.origin

        let temporarySpot = CGPoint(x: (sack?.frame.origin.x)!+(melodyImage?.frame.width)!/2, y: (sack?.frame.origin.y)!+(melodyImage?.frame.height)!/2)
        
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block:{_ in
            self.melodyImage?.moveViewTo(temporarySpot, time: 2.0, {
                self.melodyImage?.moveViewTo(currentPoint!, time: 1.5, {
                    self.isUserInteractionEnabled = true
                })
            })
        })

    }
    
    func missingMelodyType(melodyArray: [MelodyImage]) -> MelodyType {
        
        var typeItNeeds = MelodyType.begin
        
        let containsBegin = melodyArray.contains(where: { $0.type == .begin })
        let containsMiddle = melodyArray.contains(where: { $0.type == .middle })
        let containsTonic = melodyArray.contains(where: { $0.type == .tonic })
        let containsDominant = melodyArray.contains(where: { $0.type == .dominant })
        let containsEnding = melodyArray.contains(where: { $0.type == .ending })
        let containsFinal = melodyArray.contains(where: { $0.type == .final })
        
        if !containsBegin {
            typeItNeeds = .begin
        } else if !containsMiddle {
            typeItNeeds = .middle
        } else if !containsTonic {
            typeItNeeds = .tonic
        } else if !containsDominant {
            typeItNeeds = .dominant
        } else if !containsEnding {
            typeItNeeds = .ending
        } else if !containsFinal {
            typeItNeeds = .final
        }
        return typeItNeeds
    }
    
    func createCatchOrThrowBackImages(){
        
        let bottomPadding = frame.height/7
        let sidePadding = frame.width/20
        
        sack = CatchOrThrowbackImage(frame: CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height/3), imageName: "sack")
        addSubview(sack!)
        sack!.frame.origin = CGPoint(x: 0+sidePadding, y: frame.height-sack!.frame.height-bottomPadding)
        
        throwbackWater = CatchOrThrowbackImage(frame: CGRect(x: frame.width, y: frame.height/4, width: frame.width/3, height: frame.height/3),imageName: "throwbackWater")
        addSubview(throwbackWater!)
        throwbackWater!.frame.origin = CGPoint(x: frame.width-throwbackWater!.frame.width, y: frame.height-throwbackWater!.frame.height-bottomPadding)
        
        if melodyImageArray.count == 0 {
            moveMelodyToShowDragging()
        }
    }
    
    func goBackToFishing(){
        
        Sound.shared.turnUpPond()
        melodyImage?.shrinkAndRemove(time: 0.8, {
            self.throwbackWater?.shrink()
            self.sack?.scaleTo(scaleTo: 1.0, time: 0.8, {
                self.sack!.scaleSize = 1.0
                self.sceneState = .fishing
                self.removeImagesFromCaughtMelodyScene()
                self.instructionLabel?.changeText(to: "Let's wait for another bite!")
                self.delegate?.createRandomBubblesAtRandomTimeInterval(time: 0.7)
            })
        })
    }
    
    func fishingDone(){
        sceneState = .fishingDone
        melodyImage?.shrinkAndRemove(time: 0.8, {
            self.throwbackWater?.shrink()
            self.sack?.scaleTo(scaleTo: 1.0, time: 0.8, {
                self.sack!.scaleSize = 1.0
                self.pondImage.fadeTo(opacity: 1.0, time: 2.0)
                self.sack?.fadeAndRemove(time: 1.0)
                self.throwbackWater?.fadeAndRemove(time: 1.0)
                self.keepLabel?.fadeAndRemove(time: 1.0)
                self.throwbackLabel?.fadeAndRemove(time: 1.0)
                self.instructionLabel?.changeText(to: "What a great collection of melodies! Time to head back down the mountain.")
                self.delegate?.returnToStory()
            })
        })
    }
    
    func removeImagesFromCaughtMelodyScene(){
        
        pondImage.fadeTo(opacity: 1.0, time: 2.0) {
            self.putLineBackIn()
        }
        self.sack?.fadeAndRemove(time: 1.0)
        self.throwbackWater?.fadeAndRemove(time: 1.0)
        self.keepLabel?.fadeAndRemove(time: 1.0)
        self.throwbackLabel?.fadeAndRemove(time: 1.0)
    }
    
    func putLineBackIn(){
        playSoundClip(.fishingCastLine)
        fishingPole?.putPoleIn({
            // completion handler. after the pole is put in, set a timer for the next melody to "bite"
            self.setAMelodyToBiteInTheFuture()
        })
    }
    
    func setAMelodyToBiteInTheFuture(){
        
        // choose a random time
        let randomTime = TimeInterval.random(in: 5...8)
//        let randomTime = TimeInterval.random(in: 0...1)
        
        // schedule a timer to trigger a melody bite in the future
        Timer.scheduledTimer(withTimeInterval: randomTime, repeats: false, block:{_ in
            self.sceneState = .fishOnTheLine
            self.fishingPole?.fishOnTheLine({})
            self.createReelInButton()
            self.instructionLabel?.changeText(to: "Ooh! It's a bite!")
            playRandomTriggeredSoundClip(.fishingMelodyOnTheLine)
        })
    }
    
    func decideWhatToDoWithTheMelody(){
        
        sceneState = .catchOrThrowBack
        stopRandomTriggeredSoundClip(.fishingMelodyOnTheLine)
        
        
        fishingPole?.pullPoleOut({
            
            // dim the background pond image
            self.pondImage.fadeTo(opacity: 0.2, time: 1.5)
            Sound.shared.turnDownPond()
            
            // create catching scene images
            self.createRandomMelody()
            self.createCatchOrThrowBackImages()
            self.createLabels()
            self.instructionLabel?.changeText(to: "Drag the melody to keep it or throw it back.")
            
            self.delegate?.stopRandomBubbles()
//            self.reelInButton.fadeOut(0.5)
            self.melodyImage?.playMelody()

            
        })
    }
    
    func addMelodyToSack(_ melody: Melody){
        
        var filledSlots = [Int]()

        melodyImageArray.forEach { mel in
            filledSlots.append((mel.data?.slotPosition)!)
        }
        
        var openSlot : Int!
        for i in 0...sackContents.melodySlotViews.count-1 {
            if !filledSlots.contains(i){
                openSlot = i
                break
            }
        }

        let x = sackContents.melodySlotViews[openSlot].frame.minX+sackContents.frame.minX
        let y = sackContents.melodySlotViews[openSlot].frame.minY+sackContents.frame.minY
        let width = sackContents.melodySlotViews[openSlot].frame.width
        let height = sackContents.melodySlotViews[openSlot].frame.height
        
        let view = MelodyImage(frame: CGRect(x: x, y: y, width: width, height: height), melody: melody, isThumbnail: true)
        addSubview(view)
        view.initialPosition = CGPoint(x: x, y: y)
        view.data?.slotPosition = openSlot
        melodyImageArray.append(view)
        
        view.alpha = 0.0
        view.fadeTo(opacity: 1.0, time: 1.5)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSackMelodyPan))
        view.addGestureRecognizer(panGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
        view.addGestureRecognizer(tap)
    }
    
    func removeMelodyFromSack(_ view: MelodyImage){
        view.shrinkAndRemove(time: 0.5)
        playSoundClip(.fishingThrowbackDrop)
        
        for i in 0...melodyImageArray.count-1 {
            if view.data?.slotPosition == melodyImageArray[i].data!.slotPosition {
                melodyImageArray.remove(at: i)
                return // return so it doesn't continue the for loop
            }
        }
    }
    
    func sackFull(melodyArray: [MelodyImage]) -> Bool {
        
        var bool = false
        
        if melodyArray.count == 6 {
            bool = true
        }

        return bool
    }
    
    func addMelodiesToCollectedMelodyArray(melodyArray: [MelodyImage]){
        melodyArray.forEach { mel in
            collectedMelodies.append(mel.data!)
        }
    }
    
    func reelIn(){
        
        
            if sceneState == .fishing {
                instructionLabel?.changeText(to: "Wait for a melody to bite!")
                warningWiggle()
                instructionLabel?.warningScaleUp()
                playSoundClip(.fishingWarning)
            }
            
            if sceneState == .fishOnTheLine {
                decideWhatToDoWithTheMelody()
                playSoundClip(.fishingPullMelodyOut)
            }
        

    }
    
    @objc func handleSackMelodyPan(_ sender: UIPanGestureRecognizer){
        
        let view = sender.view as! MelodyImage
        
        let translation = sender.translation(in: self)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
        
        if sender.state == .ended {
            if sender.view!.center.y <= view.initialPosition.y/1.4 ||
                sender.view!.center.x >= view.initialPosition.x*4 {
                removeMelodyFromSack(view)
            } else {
                view.moveViewTo(view.initialPosition, time: 0.5)
            }
        }
    }
    
    // Touch Handlers
    @objc func handleMelodyPan(_ sender: UIPanGestureRecognizer){
        
        let translation = sender.translation(in: self)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
        //        playSoundClip(.fishingMelodyDrag)
        
        if (sack?.bounds.contains(sender.location(in: sack)))! && !(sack?.isSelected)!{
            sack?.expand()
        }
        if !(sack?.bounds.contains(sender.location(in: sack)))! && (sack?.isSelected)! {
            sack?.shrink()
        }
        if (throwbackWater?.bounds.contains(sender.location(in: throwbackWater)))! && !(throwbackWater?.isSelected)! {
            throwbackWater?.expand()
        }
        if !(throwbackWater?.bounds.contains(sender.location(in: throwbackWater)))! && (throwbackWater?.isSelected)! {
            throwbackWater?.shrink()
        }
        
        // When touches ended after panning.
        if sender.state == .ended {
            //            stopSoundClip(.fishingMelodyDrag)
            // if the melody was dragged to be kept
            if (sack?.bounds.contains(sender.location(in: sack)))! {
                let melodyImage = sender.view as! MelodyImage
                let melody = melodyImage.data
                
                //                sackContents?.addMelodyToOpenSlot(melody: melody!)
                addMelodyToSack(melody!)
                
                playSoundClip(.fishingSackDrop)
//                if (sackContents?.sackFull())! {
                if sackFull(melodyArray: melodyImageArray) {
                    self.fishingDone()
                    playSoundClip(.fishingSackFull)
                    // If the sack is full, store the melodies globally
                    addMelodiesToCollectedMelodyArray(melodyArray: melodyImageArray)
                } else {
                    self.goBackToFishing()
                }
            }
                // if the melody was dragged to be put back
            else if (throwbackWater?.bounds.contains(sender.location(in: throwbackWater)))!{
                self.goBackToFishing()
                playSoundClip(.fishingThrowbackDrop)
            } else {
                
                let melodySize = sender.view?.frame.size
                let point = CGPoint(x: frame.width/2-(melodySize?.width)!/2, y: frame.height/3-(melodySize?.height)!/2)
                sender.view?.moveViewTo(point, time: 0.8)
            }
        }
    }
    
    @objc func handleMainTap(_ sender: UITapGestureRecognizer){
        

        
    }
    
    @objc func handleMelodyTap(_ sender: UITapGestureRecognizer){
        
        for view in subviews {
            if view is MelodyImage {
               let v = view as! MelodyImage
                if v.isPlaying {
                    v.stopMelody()
                }
            }
        }
        
        let view = sender.view as! MelodyImage
        view.playMelody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
