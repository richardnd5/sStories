import UIKit

class MelodyImage: UIImageView {
    
    var noteImage = UIImage()
    var maskLayer = CAGradientLayer()
    var number = Int()
    var type : MelodyType!
    var data : Melody?
    var inCorrectSlot = false
    var glowTimer = Timer()
    var isPlaying = false
    var glowingOverlay : UIView!
    var initialPosition : CGPoint!
    
    init(frame: CGRect, melody: Melody, isThumbnail: Bool = false) {
        super.init(frame: frame)
        self.number = melody.number
        self.type = melody.type
        self.data = melody
        setupNote()
        
        if !isThumbnail {
            addBlurBorder(dx: frame.height/20, dy: frame.height/20, cornerWidth: frame.height/10, cornerHeight: frame.height/10)
        }
    }
    
    func setupNote(){
        image = resizedImage(name: "\(determineWhatImageToShowForMelody(type: type))", frame: frame, scale: 3)
        contentMode = .scaleAspectFit
        layer.zPosition = 2
        layer.opacity = 0.0
        layer.cornerRadius = frame.height/10
        clipsToBounds = true
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        isUserInteractionEnabled = true
        
        fadeTo(opacity: 1.0, time: 1.0)
        setupGlowingOverlay()
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
    
    private func stopGlowingPulse(){
        glowTimer.invalidate()
        CATransaction.begin()
        let glow : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        glow.toValue = 0.0
        glow.duration = 0.7
        glow.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        glow.fillMode = .forwards
        
        CATransaction.setCompletionBlock {
            self.glowingOverlay.layer.removeAnimation(forKey: "throb")
            self.isPlaying = false
        }
        glowingOverlay.layer.add(glow, forKey: "stopGlow")
        
        CATransaction.commit()
    }
    
    func playMelody(){
        if !isPlaying {
            isPlaying = true
            glowTimer.invalidate()
            data?.audio?.playMelody()
            startGlowingPulse()
            
            var audioDuration = Double((data?.audio?.getAudioDuration())!)
            type == MelodyType.final ? (audioDuration -= 5) : (audioDuration -= 1.6)
            
            glowTimer = Timer.scheduledTimer(withTimeInterval: audioDuration, repeats: false, block:{_ in self.stopGlowingPulse()})
        }
    }
    
    func stopMelody(){
        stopGlowingPulse()
        data?.audio?.stopMelody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
