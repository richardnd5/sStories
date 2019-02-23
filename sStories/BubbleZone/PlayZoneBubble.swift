import UIKit
import AudioKit

class PlayZoneBubble: UIView {
    
    var noteImage = UIImage()
    var imageView : UIImageView!
    var maskLayer = CAGradientLayer()
    var number = Int()
    var type : MelodyType!
    var data : Melody?
    var inCorrectSlot = false
    var glowTimer = Timer()
    var isPlaying = false
    var glowingOverlay : UIView!
    var initialPosition : CGPoint!
    
    var pitches = [MIDINoteNumber]()
    var rhythms = [AKDuration]()
//    let majScale = [61 as Int,63 as Int,65 as Int,66 as Int,68 as Int,70 as Int,72 as Int,73 as Int,75 as Int,77 as Int,78 as Int,80 as Int]
    var majScale : Array<Int>?
    var numberOfNotes : Int!

    
    init(frame: CGRect, isThumbnail: Bool = false) {
        super.init(frame: frame)
        numberOfNotes = Int.random(in: 1...4)
        majScale = [61,63,65,66,68,70,72,73,75,77,78,80]
        
        setupImage()
//        setupNote()
        
        if !isThumbnail {
            addBlurBorder(dx: frame.height/40, dy: frame.height/40, cornerWidth: frame.height/2, cornerHeight: frame.height/2)
        }
        generateRandomPitches()
        generateRandomRhythms()
        
        let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
        press.minimumPressDuration = 0.0
        addGestureRecognizer(press)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleMelodyPan))
        addGestureRecognizer(pan)

    }
    
    func setupImage(){
        
        number = Int.random(in: 0...11)
        
        let width = frame.width/2
        let height = frame.height/2
        let x = frame.width/2-width/2
        let y = frame.height/2-height/2
        let fr = CGRect(x: x, y: y, width: width, height: height)
        
        imageView = UIImageView(frame: fr)
        imageView.image = resizedImage(name: "musicSymbol\(number)", frame: frame, scale: 3)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        
        layer.opacity = 0.0
        isUserInteractionEnabled = true
        layer.cornerRadius = frame.height/2
        
        fadeTo(time: 1.0, opacity: 1.0)
        let randomNumber = CGFloat.random(in: 0.0...1.0)
        backgroundColor = UIColor(hue: randomNumber, saturation: randomNumber, brightness: 1.0, alpha: 1.0)
        
        setupGlowingOverlay()

    }
    
    
    @objc func handlePress(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            print("pressed a bubble!!!")
            Sound.sharedInstance.generatePianoImprov(notes: pitches, beats: rhythms)
            glowInandOut()
        }
        
    }
    func generateRandomPitches(){
        
        for _ in 0..<numberOfNotes{
            let randomElement = majScale!.randomElement()?.value()
            let rand = MIDINoteNumber(randomElement!)
            pitches.append(rand)
        }
    }
    func generateRandomRhythms(){
        for i in 0..<numberOfNotes{
            if i == 0 {
                let position = AKDuration(beats: 0)
                rhythms.append(position)
            } else {
                //            let rand = AKDuration(beats: Double(Int.random(in: 1...4)))
                rhythms.append(AKDuration(beats: Double(i)/2))
            }
            
        }
    }

    @objc func handleMelodyPan(_ sender: UIPanGestureRecognizer){
        
        let translation = sender.translation(in: self)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
    }
    
    func setupGlowingOverlay(){
        glowingOverlay = UIView(frame: CGRect.zero)
        glowingOverlay.backgroundColor = .green
        glowingOverlay.layer.zPosition = 2
        glowingOverlay.layer.opacity = 0.0
        addSubview(glowingOverlay)
        glowingOverlay.fillSuperview()
    }
    
    
    private func startGlowingPulse(){
        let glow : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        glow.fromValue = 0.0
        glow.toValue = 0.4
        glow.duration = 0.7;
        glow.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        glow.repeatCount = .infinity;
        glow.autoreverses = true
        glowingOverlay.layer.add(glow, forKey: "throb")
    }
    
    private func glowInandOut(){
        let glow : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        glow.fromValue = 0.0
        glow.toValue = 0.5
        glow.duration = 2.0;
        glow.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        glow.autoreverses = true
        glow.autoreverses = true
        glowingOverlay.layer.add(glow, forKey: "throb")
    }
    
    private func growBigAndSmall(){
        print("growingBig")
        scaleTo(scaleTo: 1.3, time: 0.4, {
            print("growingSmall")
            self.scaleTo(scaleTo: 1.0, time: 4.0)
        })
    }
    
    private func stopGlowingPulse(){
        
        glowTimer.invalidate()
        CATransaction.begin()
        let glow : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        glow.toValue = 0.0
        glow.duration = 4.0
        glow.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        glow.fillMode = .forwards
        
        CATransaction.setCompletionBlock {
            self.glowingOverlay.layer.removeAnimation(forKey: "throb")
            self.isPlaying = false
        }
        glowingOverlay.layer.add(glow, forKey: "stopGlow")
        
        CATransaction.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//class qqPlayZoneBubble: UIView {
//
//    var noteImage = UIImage()
//    var number = Int()
//    var imageView = UIImageView()
//    var maskLayer = CAGradientLayer()
//    var pitches = [MIDINoteNumber]()
//    var rhythms = [AKDuration]()
//    let majScale = [61 as Int,63 as Int,65 as Int,66 as Int,68 as Int,70 as Int,72 as Int,73 as Int,75 as Int,77 as Int,78 as Int,80 as Int]
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupImage()
//        addBlurBorder(dx: frame.height/20, dy: frame.height/20, cornerWidth: frame.height/2, cornerHeight: frame.height/2)
//        layer.zPosition = 1000
//        generateRandomPitches()
//        generateRandomRhythms()
//
//        let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
//        press.minimumPressDuration = 0.0
//        addGestureRecognizer(press)
//    }
//
//    @objc func handlePress(_ sender: UILongPressGestureRecognizer){
//        if sender.state == .began {
//            print("pressed a bubblew")
//            Sound.sharedInstance.generatePianoImprov(notes: pitches, beats: rhythms)
//
//        }
//    }
//    func generateRandomPitches(){
//        for _ in 0..<4{
//            let randomElement = majScale.randomElement()?.value()
//            let rand = MIDINoteNumber(randomElement!)
//            pitches.append(rand)
//        }
//    }
//    func generateRandomRhythms(){
//        for i in 0..<4{
//            print(rhythms)
//            if i == 0 {
//                let position = AKDuration(beats: 0)
//                rhythms.append(position)
//            } else {
////            let rand = AKDuration(beats: Double(Int.random(in: 1...4)))
//            rhythms.append(AKDuration(beats: Double(i)))
//            }
//
//        }
//    }
//
//    func setupImage(){
//
//        number = Int.random(in: 0...11)
//
//        let width = frame.width/2
//        let height = frame.height/2
//        let x = frame.width/2-width/2
//        let y = frame.height/2-height/2
//        let fr = CGRect(x: x, y: y, width: width, height: height)
//
//        imageView = UIImageView(frame: fr)
//        imageView.image = resizedImage(name: "musicSymbol\(number)", frame: frame, scale: 3)
//        imageView.contentMode = .scaleAspectFit
//        addSubview(imageView)
//
//
//        layer.opacity = 0.0
//        isUserInteractionEnabled = true
//        layer.cornerRadius = frame.height/2
//
//        fadeTo(time: 1.0, opacity: 1.0)
//        backgroundColor = UIColor(white: 0.9, alpha: 0.9)
//    }
//
//    func makeNoteAppearFlyAwayAndFade(){
//
//        let range = (-frame.height*3...frame.height*3)
//        let randX = CGFloat.random(in: range)
//        let randY = CGFloat.random(in: range)
//        let time = 1.0
//
//        let fromPoint = CGPoint(x: frame.midX, y: frame.midY)
//        let toPoint = CGPoint(x: frame.midX-randX, y: frame.midY-randY)
//
//        let position = CABasicAnimation(keyPath: "position")
//
//        position.fromValue = NSValue(cgPoint: fromPoint)
//        position.toValue = NSValue(cgPoint: toPoint)
//        position.duration = time
//        position.fillMode = .forwards
//        layer.add(position, forKey: "position")
//
//        let randomRotation = NSNumber(value: Double.random(in: -Double.pi...Double.pi))
//        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotation.toValue = randomRotation
//        rotation.duration = time
//        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        rotation.fillMode = .forwards
//        layer.add(rotation, forKey: "rotation")
//
//        fadeAndRemove(time: time)
//    }
//
//    func makeNoteAppearAndFloat(){
//        let range = (-frame.height*3...frame.height*3)
//        let randX = CGFloat.random(in: range)
//        let randY = CGFloat.random(in: range)
//        let time = 1.0
//
//        let fromPoint = CGPoint(x: frame.midX, y: frame.midY)
//        let toPoint = CGPoint(x: frame.midX-randX, y: frame.midY-randY)
//
//        let randomRotation = NSNumber(value: Double.random(in: -Double.pi...Double.pi))
//        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotation.toValue = randomRotation
//        rotation.duration = time
//        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        rotation.fillMode = .forwards
//        layer.add(rotation, forKey: "rotation")
//    }
//
//    func shrinkRotateAndRemove(){
//
//        let time = 0.5
//        let randomRotation = NSNumber(value: Double.random(in: -Double.pi*3...Double.pi*3))
//        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotation.toValue = randomRotation
//        rotation.duration = time
//        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        rotation.fillMode = .forwards
//        layer.add(rotation, forKey: "rotation")
//
//        let scale : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
//        scale.toValue = 0.0
//        scale.duration = time
//        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        scale.fillMode = .forwards
//        layer.add(scale, forKey: "rotate")
//
//        fadeAndRemove(time: time)
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


