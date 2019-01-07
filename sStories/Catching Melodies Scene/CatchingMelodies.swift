/*
 To do:
 
 4 melodies.
 Separate melody class. Tonic, Sub dominant, dominant types. Phrase structure should be, tonic, sub dom., dom, tonic.
 
 Allowed to catch only 4 melodies.
 
 first round. Only random from the tonic set.
 second round. only sub dominant
 third, dominant
 fourth, tonic again.
 
 
 in the top left. Four dotted lined circles
 every time you catch a melody, an 8th note with a white background fades in and fills a spot.
 (Maybe once you catch the melody, you can tap on it to hear it, then drag it back if you don't want it)
 */

/*
 Struct?
 What does a melody need?
 it needs:
 type
 melodyNumber
 
 
 the melody needs to be a random number. Which random number depends on what type of chordal function it is.
 
 So. the random number needs to be generated when the melody is created.
 
 When you fish for a melody, it needs to check the sack for what the user has.
 
 if sackContents doesn't contain: tonic, pull up tonic
 else if sackContents doesn't contain: middle, pull up middle
 else if sackContents doesn't contain: penultimate, pull up penultimate
 else if sackContents doesn't contain: ending, pull up ending
 else if sackContents == 4, switch back to game scene.
 
 
 each melody is tagged with a MelodyType, depending on that melody type, it generates a random number depending on it's melody type.
 
 0-9 start
 10-19 middle
 20-29 penultimate
 30-39 ending
 
 When the melody is "performed", it is played twice (maybe, depending on if it feels long)
 
 */

import UIKit

class CatchingMelodies: UIView {
    
    enum State {
        case fishing
        case fishOnTheLine
        case catchOrThrowBack
    }
    
    // Images for the scene
    var pondImage =  UIImageView()
    var fishingPole : FishingPole?
    var melody : MelodyImage?
    var sack : CatchOrThrowbackImage?
    var throwbackWater : CatchOrThrowbackImage?
    var sackContents: SackContents?
    
    // Labels
    var keepLabel : Label?
    var throwbackLabel : Label?
    var instructionLabel: Label?

    var appState = State.fishing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        
        createPond()
        createFishingPole()
        createInstructionLabel()
        createSackContainer()
        setAMelodyToBiteInTheFuture()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMainTap))
        addGestureRecognizer(tapGesture)
        
        alpha = 0.0
        changeOpacity(view: self, time: 1.5, opacity: 1.0, {})
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

        //  get URL of image
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("Pond.png")
        // Downsample it to fit the set dimensions
        let ourImage = downsample(imageAt: bundleURL!, to: CGSize(width: frame.width, height: frame.height), scale: 1)
        pondImage.image = ourImage
        
        addSubview(pondImage)
        
        pondImage.contentMode = .scaleAspectFit
        pondImage.translatesAutoresizingMaskIntoConstraints = false
        pondImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pondImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pondImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        pondImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        changeOpacity(view:self, time: 1.5,opacity: 1.0, {})
        
    }
    
    func createInstructionLabel(){
        // add keep label
        instructionLabel = Label(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height/4), words: "Patiently, Templeton waiting for the first bite...", fontSize: frame.width/40)

        addSubview(instructionLabel!)
        instructionLabel?.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        instructionLabel?.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/80).isActive = true
    }
    
    func createLabels(){
        
        // add keep label
        keepLabel = Label(frame: CGRect(x: (sack?.frame.midX)!, y: (sack?.frame.minY)!, width: frame.width/3, height: frame.height/4), words: "Keep", fontSize: frame.height/26)
        
        // How do I do this in the line before instead of resetting the origin after it is instantiated. I am using sizeToFit() in it's class so I don't know what to do.
        keepLabel!.frame.origin = CGPoint(x: (sack?.frame.midX)!-keepLabel!.frame.width/2, y: (sack?.frame.minY)!-keepLabel!.frame.height*2)
        addSubview(keepLabel!)

        // add throwback label
        throwbackLabel = Label(frame: CGRect(x: (throwbackWater?.frame.midX)!, y: (throwbackWater?.frame.minY)!, width: frame.width/3, height: frame.height/4), words: "Throw Back", fontSize: frame.height/26)
        
        // Same as the keepLabel
        throwbackLabel!.frame.origin = CGPoint(x: (throwbackWater?.frame.midX)!-throwbackLabel!.frame.width/2, y: (throwbackWater?.frame.minY)!-throwbackLabel!.frame.height*2)
        addSubview(throwbackLabel!)
        
    }
    
    func createFishingPole(){
        
        fishingPole = FishingPole(frame: CGRect(x: frame.width/2-frame.width/8, y: frame.height+40, width: frame.width/4, height: frame.height/2))
        addSubview(fishingPole!)
    }
    
    func createRandomMelody(){
        
        let randomMelody = Melodyy(type: generateMissingType())
        
        // instantiate it
        melody = MelodyImage(frame: CGRect(x: frame.width/2, y: frame.height/3, width: frame.width/2, height: frame.height/2), melody: randomMelody)
        addSubview(melody!)
        print("melody type:  \(melody!.type!)   melody number: \(melody!.number)")
        
        // set the origin. (there has to be a better way to do this. How do you know the width and height before it is instantiated?)
        melody!.frame.origin = CGPoint(x: frame.width/2-melody!.frame.width/2, y: frame.height/3-melody!.frame.height/2)
        
        // Give it gesture recognizers
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMelodyPan))
        melody?.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
        melody?.addGestureRecognizer(tapGesture)
    }
    
    func generateMissingType() -> MelodyType{
        
        let randomType = MelodyType.allCases.randomElement()

        return randomType!
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

        melody?.shrinkAndRemove(time: 0.6, {
            self.throwbackWater?.scaleTo(scaleTo: 1.0, time: 0.5, {})
            self.sack?.scaleTo(scaleTo: 1.0, time: 0.5, {
                self.appState = .fishing
                self.removeImagesFromCaughtMelodyScene()
                self.instructionLabel?.text = "Let's keep fishing!"
            })
        })
    }
    
    func fishingDone(){
        
        melody?.shrinkAndRemove(time: 0.6, {
            self.throwbackWater?.scaleTo(scaleTo: 1.0, time: 0.5, {})
            self.sack?.scaleTo(scaleTo: 1.0, time: 0.5, {
                self.appState = .fishing
                self.removeImagesFromCaughtMelodyScene()
                self.instructionLabel?.text = "What a great collection of melodies! Time to head back down the mountain."
            })
        })
    }
    
    
    // NEED TO SEPARATE THE PUT LINE BACK IN OUTTA HERE!!!!
    func removeImagesFromCaughtMelodyScene(){
        
        changeOpacity(view: pondImage, time: 2.0, opacity: 1.0, {
            self.putLineBackIn()
        })
        self.sack?.fadeOutAndRemove()
        self.throwbackWater?.fadeOutAndRemove()
        self.keepLabel?.remove(fadeTime: 1.0, {})
        self.throwbackLabel?.remove(fadeTime: 1.0, {})
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
            self.appState = .fishOnTheLine
            self.fishingPole?.fishOnTheLine({})
            self.instructionLabel?.text = "Ooh! A Bite! Tap to reel it in!"
        })
    }

    func decideWhatToDoWithTheMelody(){
        
        appState = .catchOrThrowBack
        
        fishingPole?.pullPoleOut({
            
            // dim the background pond image
            changeOpacity(view: self.pondImage, time: 1.5, opacity: 0.2, {})
            
            // create catching scene images
            self.createRandomMelody()
            self.createCatchOrThrowBackImages()
            self.createLabels()
            
            self.instructionLabel?.text = "Tap on the melody to hear it, then drag it to keep or throw it back."
        })
    }
    
    // Touch Handlers
    @objc func handleMelodyPan(_ sender: UIPanGestureRecognizer){
        
        let translation = sender.translation(in: self)
        
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        
        sender.setTranslation(CGPoint.zero, in: self)
        
        if (sack?.bounds.contains(sender.location(in: sack)))! {
            sack?.scaleTo(scaleTo: 1.4, time: 0.3, {})
        } else if sack?.scaleSize != 1.0 {
            sack?.scaleTo(scaleTo: 1.0, time: 0.3, {})
        } else if (throwbackWater?.bounds.contains(sender.location(in: throwbackWater)))!{
            throwbackWater?.scaleTo(scaleTo: 1.4, time: 0.3, {})
        } else if throwbackWater?.scaleSize != 1.0 {
            throwbackWater?.scaleTo(scaleTo: 1.0, time: 0.3, {})
        }
        
        // When touches ended after panning.
        if sender.state == .ended {
            
            // if the melody was dragged to be kept
            if (sack?.bounds.contains(sender.location(in: sack)))! {
                let melody = sender.view as! MelodyImage
                sackContents?.addMelodyToOpenSlot(melodyToAdd: melody)
                if (sackContents?.sackFull())! {
                    sackContents?.addMelodiesToCollectedMelodyArray()
                    print("Your sack is full. way ho. These are the melodies you caught:  \(collectedMelodies)")
                    self.fishingDone()
                } else {
                    print("still gotta keep fishing")
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
                
        if appState == .fishOnTheLine {
            decideWhatToDoWithTheMelody()
        }
    }
    
    @objc func handleMelodyTap(_ sender: UITapGestureRecognizer){
        melody?.playMelody()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
