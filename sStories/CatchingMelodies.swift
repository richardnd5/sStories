import UIKit

class CatchingMelodies: UIView {
    
    enum State {
        case fishing
        case fishOnTheLine
        case catchOrThrowBack
    }
    
    var pondImage =  UIImageView()

    var fishingPole : FishingPole?
    var melody : Melody?
    var sack : CatchOrThrowbackImage?
    var throwbackWater : CatchOrThrowbackImage?
    
    var keepLabel : Label?
    var throwbackLabel : Label?

    var appState = State.fishing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createPond()
        createFishingPole()
        
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false, block:{_ in
            self.theresAFishOnTheLine()
        })
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMainTap))
        addGestureRecognizer(tapGesture)
        
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
        
        fadeTo(view:self, time: 1.5,opacity: 1.0, {})
        
    }
    
    func createLabels(){
        
        // add keep label
        keepLabel = Label(frame: CGRect(x: (sack?.frame.midX)!, y: (sack?.frame.minY)!, width: frame.width/3, height: frame.height/4), words: "Keep", fontSize: frame.height/26)
        // How do I do this in the line before instead of resetting the origin after it is instantiated.
        keepLabel!.frame.origin = CGPoint(x: (sack?.frame.midX)!-keepLabel!.frame.width/2, y: (sack?.frame.minY)!-keepLabel!.frame.height*2)
        addSubview(keepLabel!)

        // add throwback label
        throwbackLabel = Label(frame: CGRect(x: (throwbackWater?.frame.midX)!, y: (throwbackWater?.frame.minY)!, width: frame.width/3, height: frame.height/4), words: "Throw Back", fontSize: frame.height/26)
        throwbackLabel!.frame.origin = CGPoint(x: (throwbackWater?.frame.midX)!-throwbackLabel!.frame.width/2, y: (throwbackWater?.frame.minY)!-throwbackLabel!.frame.height*2)
        addSubview(throwbackLabel!)
    }
    

    func createFishingPole(){
        
        fishingPole = FishingPole(frame: CGRect(x: frame.width/2-frame.width/8, y: frame.height+40, width: frame.width/4, height: frame.height/2))
        addSubview(fishingPole!)
        
        fishingPole?.wobblePole()

    }
    
    func createRandomMelody(){
        
        let randomNumber = Int.random(in: 1...36)
        melody = Melody(frame: CGRect(x: frame.width/2, y: frame.height/3, width: frame.width/2, height: frame.height/2), number: randomNumber)
        addSubview(melody!)
        melody!.frame.origin = CGPoint(x: frame.width/2-melody!.frame.width/2, y: frame.height/3-melody!.frame.height/2)
        
        // Give it gesture recognizers
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        melody?.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
        melody?.addGestureRecognizer(tapGesture)
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
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer){
        
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
            if (sack?.bounds.contains(sender.location(in: sack)))! {
                self.goBackToFishing()
            }
            else if (throwbackWater?.bounds.contains(sender.location(in: throwbackWater)))!{
                self.goBackToFishing()
            }
        }
    }
    
    @objc func handleMainTap(_ sender: UITapGestureRecognizer){
        
        print("it is tapping")
        if appState == .fishOnTheLine {
            appState = .catchOrThrowBack
            fishingPole!.isReadyToCastOrReelIn = false
            
            fishingPole?.pullPoleOut({
                fadeTo(view: self.pondImage, time: 1.5, opacity: 0.2, {})
                self.melodyAppears()
            })

        }
    }
    
    @objc func handleMelodyTap(_ sender: UITapGestureRecognizer){
        melody?.playMelody()
    }
    
    func goBackToFishing(){

        melody?.fadeOutAndRemove(time: 0.6, {
            self.throwbackWater?.scaleTo(scaleTo: 1.0, time: 0.5, {})
            self.sack?.scaleTo(scaleTo: 1.0, time: 0.5, {
                self.backToFishingMode()
                self.sack?.fadeOutAndRemove()
                self.throwbackWater?.fadeOutAndRemove()
                self.keepLabel?.remove(fadeTime: 1.0, {})
                self.throwbackLabel?.remove(fadeTime: 1.0, {})
                self.appState = .fishing
            })
        })
    }

    func backToFishingMode(){
        
        pondImage.layer.removeAllAnimations()
        fadeTo(view: pondImage, time: 2.0, opacity: 1.0, {
            self.putLineBackIn()
        })
    }
    
    func putLineBackIn(){
        
        if appState == .fishing && fishingPole!.isReadyToCastOrReelIn {
            fishingPole?.putPoleIn({
                // completion handler
                self.fishingPole!.isReadyToCastOrReelIn = true
                self.fishingPole!.wobblePole()
                
                Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false, block:{_ in
                    self.theresAFishOnTheLine()
                })
            })
        }
    }

    func melodyAppears(){
        createRandomMelody()
        createCatchOrThrowBackImages()
        createLabels()
    }
    
    func fadeBackgroundOut(){
        
        let backgroundOpacity : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        backgroundOpacity.duration = 1.5
        backgroundOpacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        backgroundOpacity.isRemovedOnCompletion = false
        backgroundOpacity.fromValue = 1.0
        backgroundOpacity.toValue = 0.2
        backgroundOpacity.fillMode = .forwards
        
        pondImage.layer.add(backgroundOpacity, forKey: "backgroundOpacitiy")
    }
    
    func theresAFishOnTheLine(){
        appState = .fishOnTheLine
        
        fishingPole?.fishOnTheLine({})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
