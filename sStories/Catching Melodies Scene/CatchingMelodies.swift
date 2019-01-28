import UIKit

class CatchingMelodies: UIView {
    
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
    var sackContents: SackContents?
    
    // Labels
    var keepLabel : Label?
    var throwbackLabel : Label?
    var instructionLabel: Label?

    override init(frame: CGRect) {
        super.init(frame: frame)

        createPond()
        createFishingPole()
        createInstructionLabel()
        createSackContainer()
        setAMelodyToBiteInTheFuture()
        
        // Add a tap gesture to the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMainTap))
        addGestureRecognizer(tapGesture)
        
        //fade the view in
        alpha = 0.0
        
        fadeTo(time: 1.5, opacity: 1.0)
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

        pondImage.image = resizedImage(name: "Pond", frame: frame)
        addSubview(pondImage)
        pondImage.layer.zPosition = -100
        
        pondImage.contentMode = .scaleAspectFit
        pondImage.translatesAutoresizingMaskIntoConstraints = false
        pondImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pondImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pondImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        pondImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        fadeTo(time: 1.5, opacity: 1.0)
        
    }
    
    func createInstructionLabel(){
        // add keep label
        
        let width = frame.width
        let height = frame.height/18
        let x = CGFloat(0)
        let y = frame.height/60
        
        
        instructionLabel = Label(frame: CGRect.zero, words: "Patiently, Templeton waiting for the first bite...", fontSize: height-height/10)

        addSubview(instructionLabel!)
        let safe = safeAreaLayoutGuide
        instructionLabel?.anchor(top: topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: nil, padding: UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0), size: .zero)
        instructionLabel?.heightAnchor.constraint(equalToConstant: frame.height/18)

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
    
    func createRandomMelody(){
        
        let missingType = sackContents?.missingMelodyType()
        let randomNeededMelody = Melody(type: missingType!)
        
        // instantiate it
        melodyImage = MelodyImage(frame: CGRect(x: frame.width/2, y: frame.height/3, width: frame.height/4, height: frame.height/4), melody: randomNeededMelody)
        melodyImage?.addBlurredBorder()
        addSubview(melodyImage!)
        
        // set the origin. (there has to be a better way to do this. How do you know the width and height before it is instantiated?)
        melodyImage!.frame.origin = CGPoint(x: frame.width/2-melodyImage!.frame.width/2, y: frame.height/3-melodyImage!.frame.height/2)
        
        // Give it gesture recognizers
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMelodyPan))
        melodyImage?.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
        melodyImage?.addGestureRecognizer(tapGesture)
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
    }

    func goBackToFishing(){

        melodyImage?.shrinkAndRemove(time: 0.6, {
            self.throwbackWater?.scaleTo(scaleTo: 1.0, time: 0.5, {self.throwbackWater!.scaleSize = 1.0})
            self.sack?.scaleTo(scaleTo: 1.0, time: 0.5, {
                self.sack!.scaleSize = 1.0
                self.sceneState = .fishing
                self.removeImagesFromCaughtMelodyScene()
                self.instructionLabel?.changeText(to: "Let's wait for another bite!")
                // shake screen.
            })
        })
    }
    
    func fishingDone(){
        sceneState = .fishingDone
        melodyImage?.shrinkAndRemove(time: 0.6, {
            self.throwbackWater?.scaleTo(scaleTo: 1.0, time: 0.5, {self.throwbackWater!.scaleSize = 1.0})
            self.sack?.scaleTo(scaleTo: 1.0, time: 0.5, {
                self.sack!.scaleSize = 1.0
                self.pondImage.fadeTo(time: 2.0, opacity: 1.0)
                self.sack?.fadeAndRemove(time: 1.0)
                self.throwbackWater?.fadeAndRemove(time: 1.0)
                self.keepLabel?.fadeAndRemove(time: 1.0)
                self.throwbackLabel?.fadeAndRemove(time: 1.0)
                self.instructionLabel?.changeText(to: "What a great collection of melodies! Time to head back down the mountain.")
            })
        })
    }
    

    func removeImagesFromCaughtMelodyScene(){
        
        pondImage.fadeTo(time: 2.0, opacity: 1.0) {
            self.putLineBackIn()
        }
        self.sack?.fadeAndRemove(time: 1.0)
        self.throwbackWater?.fadeAndRemove(time: 1.0)
        self.keepLabel?.fadeAndRemove(time: 1.0)
        self.throwbackLabel?.fadeAndRemove(time: 1.0)
    }

    func putLineBackIn(){
        
            fishingPole?.putPoleIn({
                // completion handler. after the pole is put in, set a timer for the next melody to "bite"
                self.setAMelodyToBiteInTheFuture()
            })
    }
    
    func setAMelodyToBiteInTheFuture(){
        
        // choose a random time
        let randomTime = TimeInterval.random(in: 4...7)
        
        // schedule a timer to trigger a melody bite in the future
        Timer.scheduledTimer(withTimeInterval: randomTime, repeats: false, block:{_ in
            self.sceneState = .fishOnTheLine
            self.fishingPole?.fishOnTheLine({})
            self.instructionLabel?.changeText(to: "Ooh! A bite! Tap to reel it in!")
        })
    }

    func decideWhatToDoWithTheMelody(){
        
        sceneState = .catchOrThrowBack
        
        fishingPole?.pullPoleOut({
            
            // dim the background pond image
            self.pondImage.fadeTo(time: 1.5, opacity: 0.2)
            
            // create catching scene images
            self.createRandomMelody()
            self.createCatchOrThrowBackImages()
            self.createLabels()
            self.instructionLabel?.changeText(to: "Tap on the melody to hear it, then drag it to keep or throw it back.")
        })
    }
    
    // Touch Handlers
    @objc func handleMelodyPan(_ sender: UIPanGestureRecognizer){
        
        let translation = sender.translation(in: self)
        
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        
        sender.setTranslation(CGPoint.zero, in: self)
        
        if (sack?.bounds.contains(sender.location(in: sack)))! {
            sack?.scaleTo(scaleTo: 1.4, time: 0.3, {self.sack!.scaleSize = 1.4})
        } else if sack?.scaleSize != 1.0 {
            sack?.scaleTo(scaleTo: 1.0, time: 0.3, {self.sack!.scaleSize = 1.0})
        } else if (throwbackWater?.bounds.contains(sender.location(in: throwbackWater)))!{
            throwbackWater?.scaleTo(scaleTo: 1.4, time: 0.3, {self.throwbackWater!.scaleSize = 1.4})
        } else if throwbackWater?.scaleSize != 1.0 {
            throwbackWater?.scaleTo(scaleTo: 1.0, time: 0.3, {self.throwbackWater!.scaleSize = 1.0})
        }
        
        // When touches ended after panning.
        if sender.state == .ended {
            
            // if the melody was dragged to be kept
            if (sack?.bounds.contains(sender.location(in: sack)))! {
                let melodyImage = sender.view as! MelodyImage
                let melody = melodyImage.data
                sackContents?.addMelodyToOpenSlot(melody: melody!)
                if (sackContents?.sackFull())! {
                    self.fishingDone()
                    // If the sack is full, store the melodies globally
                    sackContents!.addMelodiesToCollectedMelodyArray()
                } else {
                    self.goBackToFishing()
                }
            }
                // if the melody was dragged to be put back
            else if (throwbackWater?.bounds.contains(sender.location(in: throwbackWater)))!{
                self.goBackToFishing()
            }
        }
    }
    
    @objc func handleMainTap(_ sender: UITapGestureRecognizer){
        
        if sceneState == .fishing {
            instructionLabel?.changeText(to: "Wait for a melody to bite!")
        }

        if sceneState == .fishOnTheLine {
            decideWhatToDoWithTheMelody()
        } else if sceneState == .fishingDone {
            delegate?.returnToStory()
        }
        
    }
    
    @objc func handleMelodyTap(_ sender: UITapGestureRecognizer){
        melodyImage?.playMelody()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
