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
    
    init(frame: CGRect, melody: Melody) {
        super.init(frame: frame)

        self.number = melody.number
        self.type = melody.type
        self.data = melody
        setupNote()
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
        
        fadeTo(time: 1.0, opacity: 1.0)
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

    func addBlurredBorder(){
        maskLayer.frame = bounds
        maskLayer.shadowPath = CGPath(roundedRect: bounds.insetBy(dx: frame.height/20, dy: frame.height/20), cornerWidth: frame.height/10, cornerHeight: frame.height/10, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.black.cgColor
        layer.mask = maskLayer;
    }
        
    func startGlowingPulse(){
        let glow : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        glow.fromValue = 0.0
        glow.toValue = 0.4
        glow.duration = 0.7;
        glow.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        glow.repeatCount = .infinity;
        glow.autoreverses = true
        glowingOverlay.layer.add(glow, forKey: "throb")
    }
    
    func stopGlowingPulse(){
        
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

            // Hardcoded timer value based on 80 bpm, 8 beats or 16 beats for final
            var length : TimeInterval!
            let bpmToSec = 60/tempo
            
            type == .final ? (length = TimeInterval((bpmToSec)*16)-3) : (length = TimeInterval((bpmToSec)*8)-1)

            glowTimer = Timer.scheduledTimer(withTimeInterval: length, repeats: false, block:{_ in self.stopGlowingPulse()})
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
