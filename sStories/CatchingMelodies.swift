import UIKit

class CatchingMelodies: UIView {
    
    private let pondImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var fishingPole = UIImageView()
    var poleImage = UIImage()
    


    var melody : Melody?
    var sack : Sack?
    var throwbackWater : ThrowbackWater?
    
    var keepLabel = UILabel()
    var throwbackLabel = UILabel()

    
    var canActivate = false
    var readyToCastSlashReelIn = true
    var fishingPoleIn = true
    var fishOnLine = false
    var appState = State.readyToFish
    
    enum State {
        case catchOrThrowBack
        case readyToFish
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //  get URL of image
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("Pond.png")
        // Downsample it to fit the set dimensions
        let ourImage = downsample(imageAt: bundleURL!, to: CGSize(width: frame.width, height: frame.height), scale: 1)
        pondImage.image = ourImage

        setupFishingPole()
        

        setupLayout()
        backgroundColor = .black
        alpha = 0
        fadeTo(view:self, time: 1.5,opacity: 1.0, {})
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block:{_ in
            self.theresAFishOnTheLine()
        })
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMainTap))
        addGestureRecognizer(tapGesture)
        

        
    }
    
    func createLabels(){
        keepLabel = UILabel(frame: CGRect(x: (sack?.frame.midX)!, y: (sack?.frame.minY)!, width: frame.width/3, height: frame.height/4))
        keepLabel.text = "Keep"
        keepLabel.font = UIFont(name: "Papyrus", size: frame.height/26)
        keepLabel.textColor = .white
        keepLabel.textAlignment = .center
        keepLabel.sizeToFit()
        keepLabel.frame.origin = CGPoint(x: (sack?.frame.midX)!-keepLabel.frame.width/2, y: (sack?.frame.minY)!-keepLabel.frame.height*2)
        keepLabel.layer.opacity = 0.0
        fadeTo(view: keepLabel, time: 2.0, opacity: 1.0, {})
        addSubview(keepLabel)
        
        throwbackLabel = UILabel(frame: CGRect(x: (throwbackWater?.frame.midX)!, y: (throwbackWater?.frame.minY)!, width: frame.width/3, height: frame.height/4))
        throwbackLabel.text = "Throw Back"
        throwbackLabel.font = UIFont(name: "Papyrus", size: frame.height/26)
        throwbackLabel.textColor = .white
        throwbackLabel.textAlignment = .center
        throwbackLabel.sizeToFit()
        throwbackLabel.frame.origin = CGPoint(x: (throwbackWater?.frame.midX)!-throwbackLabel.frame.width/2, y: (throwbackWater?.frame.minY)!-throwbackLabel.frame.height*2)
        throwbackLabel.layer.opacity = 0.0
        fadeTo(view: throwbackLabel, time: 2.0, opacity: 1.0, {})
        
        addSubview(throwbackLabel)
    }
    
    @objc func handleMainTap(_ sender: UITapGestureRecognizer){
        print("main tap worked")
        if appState == .readyToFish {
            if readyToCastSlashReelIn {
                fishingPoleIn ? catchFishAnimation() : backToFishingMode()
            }
        }
    }
    
    func setupFishingPole(){
        let fishingPoleURL = Bundle.main.resourceURL?.appendingPathComponent("FishingPole.png")
        poleImage = downsample(imageAt: fishingPoleURL!, to: CGSize(width: frame.height, height: frame.height), scale: 1)
        
        fishingPole = UIImageView(frame: CGRect(x: frame.width/2-frame.width/8, y: frame.height+40, width: frame.width/4, height: frame.height/2))
        fishingPole.contentMode = .bottom
        fishingPole.isUserInteractionEnabled = false
        
        fishingPole.image = poleImage
        fishingPole.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    func setupMelody(){
        let randomNumber = Int.random(in: 1...36)
        melody = Melody(frame: CGRect(x: frame.width/2, y: frame.height/3, width: frame.width/2, height: frame.height/2), number: randomNumber)
        addSubview(melody!)
        melody!.frame.origin = CGPoint(x: frame.width/2-melody!.frame.width/2, y: frame.height/3-melody!.frame.height/2)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        melody?.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMelodyTap))
        melody?.addGestureRecognizer(tapGesture)
    }
    
    func setupDragLocations(){
        
        let bottomPadding = frame.height/7
        let sidePadding = frame.width/20
        
        sack = Sack(frame: CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height/3))
        addSubview(sack!)
        sack!.frame.origin = CGPoint(x: 0+sidePadding, y: frame.height-sack!.frame.height-bottomPadding)
        
        throwbackWater = ThrowbackWater(frame: CGRect(x: frame.width, y: frame.height/4, width: frame.width/3, height: frame.height/3))
        addSubview(throwbackWater!)
        throwbackWater!.frame.origin = CGPoint(x: frame.width-throwbackWater!.frame.width, y: frame.height-throwbackWater!.frame.height-bottomPadding)
    }
    
    @objc func noteTouch(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            melody?.scaleTo(scaleTo: 0.3, time: 0.3, {})
        }
        if sender.state == .ended {
            melody?.scaleTo(scaleTo: 1.0, time: 0.3, {})
        }
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
        
        
        // When touch up after panning.
        if sender.state == .ended {
            
            if (sack?.bounds.contains(sender.location(in: sack)))! {
                print("going in the sack")
                self.goBackToFishing()
            }
            else if (throwbackWater?.bounds.contains(sender.location(in: throwbackWater)))!{
                print("going back to the water")
                self.goBackToFishing()
            }
            
        }
        
    }
    
    @objc func handleMelodyTap(_ sender: UITapGestureRecognizer){
        melody?.playMelody()
        print("playing melody \(melody?.patternNumber)")
    }
    
    func goBackToFishing(){

        melody?.fadeOutAndRemove(time: 0.6, {
            self.throwbackWater?.scaleTo(scaleTo: 1.0, time: 0.5, {})
            self.sack?.scaleTo(scaleTo: 1.0, time: 0.5, {
                self.backToFishingMode()
                self.sack?.fadeOutAndRemove()
                self.throwbackWater?.fadeOutAndRemove()
                self.removeLabels()
                self.appState = .readyToFish
            })
        })



    }
    
    func removeLabels(){
        fadeTo(view: keepLabel, time: 1.0, opacity: 0.0, {
            self.keepLabel.removeFromSuperview()
        })
        fadeTo(view: throwbackLabel, time: 1.0, opacity: 0.0) {
            self.throwbackLabel.removeFromSuperview()
        }
    }
    
    func fadeTo(view: UIView, time: Double,opacity: CGFloat, _ completion: @escaping () ->()){
        canActivate = false
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                view.alpha = opacity
        },
            completion: {
                _ in
                self.canActivate = true
                completion()
        })
    }
    
    func setupLayout(){
        
        addSubview(pondImage)
        
        pondImage.translatesAutoresizingMaskIntoConstraints = false
        pondImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pondImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pondImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        pondImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(fishingPole)
        wobblePole()
        
    }
    
    private func wobblePole() {
        
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi / -90)
        rotationAnimation.duration = 3.0;
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotationAnimation.repeatCount = .infinity;
        rotationAnimation.autoreverses = true
        fishingPole.layer.add(rotationAnimation, forKey: "rotationAnimation")

    }
    
    func backToFishingMode(){
        
        pondImage.layer.removeAllAnimations()
        
        CATransaction.begin()
        
        let backgroundOpacity : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        backgroundOpacity.duration = 2.0
        backgroundOpacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        backgroundOpacity.isRemovedOnCompletion = false
        backgroundOpacity.fromValue = 0.2
        backgroundOpacity.toValue = 1.0
        backgroundOpacity.fillMode = .forwards
        
        pondImage.layer.add(backgroundOpacity, forKey: "backgroundOpacitiy")
        
        CATransaction.commit()
        
        CATransaction.setCompletionBlock{ [weak self] in
            
            self!.putLineBackIn()
            
            
        }
    }
    
    func putLineBackIn(){
        
        if appState == .readyToFish {
        
        fishingPole.layer.removeAllAnimations()
        readyToCastSlashReelIn = false

        CATransaction.begin()
        
        let scaleAnim : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 4
        scaleAnim.toValue = 1
        
        let opacity : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0.0
        opacity.toValue = 1.0
        
        let rotate : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 1.0
        rotate.toValue = 0.0
        
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [scaleAnim,opacity, rotate]
        animGroup.duration = 0.75
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animGroup.isRemovedOnCompletion = false
        animGroup.fillMode = .forwards
            
        fishingPole.layer.add(animGroup, forKey: "animGroup")
        CATransaction.commit()
        
        CATransaction.setCompletionBlock{ [weak self] in
            self!.readyToCastSlashReelIn = true
            self!.fishingPoleIn = true
            self!.wobblePole()
            
            Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false, block:{_ in
                self!.theresAFishOnTheLine()
            })
        }
        


        }
        
    }

    func catchFishAnimation(){
        
        if fishOnLine {
        fishingPole.layer.removeAllAnimations()

        appState = .catchOrThrowBack
        readyToCastSlashReelIn = false
        fishingPoleIn = false
        CATransaction.begin()

        let scaleAnim : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 0.75
        scaleAnim.toValue = 4

        let opacity : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1.0
        opacity.toValue = 0.0
        
        let rotate : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0.0
        rotate.toValue = 1.0
        
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [scaleAnim,opacity, rotate]
        animGroup.duration = 0.45
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animGroup.isRemovedOnCompletion = false
        animGroup.fillMode = .forwards
        
        CATransaction.setCompletionBlock{ [weak self] in
            self!.readyToCastSlashReelIn = true
            self!.fishOnLine = false
            self!.fadeBackgroundOut()
            self!.melodyAppears()
            
        }
        
        fishingPole.layer.add(animGroup, forKey: "animGroup")

        CATransaction.commit()
        }
    }
    
    func melodyAppears(){
        setupMelody()
        setupDragLocations()
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

        
        CATransaction.begin()
        
        let scaleAnim : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 1
        scaleAnim.toValue = 0.75
        
        // Wiggle pole fast like.
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi / -400)
        rotationAnimation.duration = 0.1;
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotationAnimation.repeatCount = .infinity;
        rotationAnimation.autoreverses = true
        fishingPole.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [scaleAnim]
        animGroup.duration = 0.3
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animGroup.isRemovedOnCompletion = false
        
        animGroup.fillMode = .forwards
        
        CATransaction.setCompletionBlock{ [weak self] in
            self!.readyToCastSlashReelIn = true
            self!.fishOnLine = true

        }
        
        fishingPole.layer.add(animGroup, forKey: "animGroup")
        CATransaction.commit()
        
    }
    
    func throbImage(_ view: UIView){
        let scale : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = 1.02
        scale.duration = 0.4;
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.repeatCount = .infinity;
        scale.autoreverses = true
        view.layer.add(scale, forKey: "throb")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
