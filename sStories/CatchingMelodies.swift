import UIKit

class CatchingMelodies: UIView {
    
    private let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var fishingPole = UIImageView()
    var poleImage = UIImage()
    var canActivate = false
    var readyToCastSlashReelIn = true
    var fishingPoleIn = true
    var fishOnLine = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //  get URL of image
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("Pond.png")
        // Downsample it to fit the set dimensions
        let ourImage = downsample(imageAt: bundleURL!, to: CGSize(width: frame.width, height: frame.height), scale: 1)
        
        let fishingPoleURL = Bundle.main.resourceURL?.appendingPathComponent("FishingPole.png")
        poleImage = downsample(imageAt: fishingPoleURL!, to: CGSize(width: frame.height, height: frame.height), scale: 1)
        imageView.image = ourImage
        
        fishingPole = UIImageView(frame: CGRect(x: frame.width/2-frame.width/8, y: frame.height+40, width: frame.width/4, height: frame.height/2))
        fishingPole.contentMode = .bottom
        fishingPole.isUserInteractionEnabled = false
        
        fishingPole.image = poleImage
        fishingPole.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)

        setupLayout()
        backgroundColor = .black
        alpha = 0
        fadeTo(view:self, time: 1.5,opacity: 1.0, {})
        
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false, block:{_ in
            self.theresAFishOnTheLine()
        })
        
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
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
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
        
        imageView.layer.removeAllAnimations()
        
        CATransaction.begin()
        
        let backgroundOpacity : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        backgroundOpacity.duration = 2.0
        backgroundOpacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        backgroundOpacity.isRemovedOnCompletion = false
        backgroundOpacity.fromValue = 0.2
        backgroundOpacity.toValue = 1.0
        backgroundOpacity.fillMode = .forwards
        
        imageView.layer.add(backgroundOpacity, forKey: "backgroundOpacitiy")
        
        CATransaction.setCompletionBlock{ [weak self] in
            
            self!.putLineBackIn()
            
            
        }
        CATransaction.commit()
    }
    
    func putLineBackIn(){
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
        animGroup.duration = 0.45
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animGroup.isRemovedOnCompletion = false
        animGroup.fillMode = .forwards
        
        CATransaction.setCompletionBlock{ [weak self] in
            self!.readyToCastSlashReelIn = true
            self!.fishingPoleIn = true
            self!.wobblePole()
            
            Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false, block:{_ in
                self!.theresAFishOnTheLine()
            })
        }
        
        fishingPole.layer.add(animGroup, forKey: "animGroup")
        CATransaction.commit()

        
    }

    func catchFishAnimation(){
        
        if fishOnLine {
        fishingPole.layer.removeAllAnimations()

        
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
        }
        
        fishingPole.layer.add(animGroup, forKey: "animGroup")

        CATransaction.commit()
        }
        
    }
    
    func fadeBackgroundOut(){
        let backgroundOpacity : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        backgroundOpacity.duration = 1.5
        backgroundOpacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        backgroundOpacity.isRemovedOnCompletion = false
        backgroundOpacity.fromValue = 1.0
        backgroundOpacity.toValue = 0.2
        backgroundOpacity.fillMode = .forwards
        
        imageView.layer.add(backgroundOpacity, forKey: "backgroundOpacitiy")
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if readyToCastSlashReelIn {
            fishingPoleIn ? catchFishAnimation() : backToFishingMode()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
