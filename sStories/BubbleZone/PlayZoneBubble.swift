import UIKit
import AudioKit

protocol BubbleUIDelegate : class {
    func scaleNoteUpAndDown()
}

class PlayZoneBubble: UIView {
    
    var noteImage = UIImage()
    var imageView : UIImageView!
    var maskLayer = CAGradientLayer()
    var number = Int()
    var inCorrectSlot = false
    var glowTimer = Timer()
    var isPlaying = false
    var glowingOverlay : UIView!
    var initialPosition : CGPoint!
    
    var pitches = [MIDINoteNumber]()
    var rhythms = [AKDuration]()
    var majScale : Array<Int>?
    var numberOfNotes : Int!
    
    var sawWave : AKOscillatorBank!
    
    var filter : AKLowPassFilter!
    
    
    
    
    init(frame: CGRect, isThumbnail: Bool = false) {
        super.init(frame: frame)
        numberOfNotes = Int.random(in: 1...4)
        majScale = [61,63,65,66,68,70,72,73,75,77,78,80]
        
        setupImage()
        
        if !isThumbnail {
            addBlurBorder(dx: frame.height/40, dy: frame.height/40, cornerWidth: frame.height/2, cornerHeight: frame.height/2)
        }
        
        generateRandomPitches()
        generateRandomRhythms()
        setupSawWave()
        
    }
    
    func setupSawWave(){
        filter = AKLowPassFilter(sawWave, cutoffFrequency: 3000)
        sawWave = AKOscillatorBank(waveform: AKTable(.positiveSawtooth))
        sawWave.attackDuration = 0.6
        sawWave.sustainLevel = 1.0
        sawWave.releaseDuration = 0.35
        sawWave.vibratoRate = 4
        sawWave.vibratoDepth = 0.2
        sawWave.rampDuration = 0.00009
        sawWave.connect(to: filter)
        filter.connect(to: Sound.shared.bubbleMixer)
    }
    
    func playWave(_ note: MIDINoteNumber){
        sawWave.play(noteNumber: note, velocity: 60)
    }
    
    func pitchBend(amount: Double){
        sawWave.pitchBend = amount
    }
    
    func stopWave(_ note: MIDINoteNumber){
        sawWave.stop(noteNumber: note)
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
        
        fadeTo(opacity: 1.0, time: 1.0)
        let randomNumber = CGFloat.random(in: 0.0...1.0)
        backgroundColor = UIColor(hue: randomNumber, saturation: randomNumber, brightness: 1.0, alpha: 1.0)
        
        setupGlowingOverlay()
        
    }
    
    func scaleNoteUpAndDown(){
        
        let randomColor = UIColor(hue: CGFloat.random(in: 0.0...1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)

        changeBackgroundColorGraduallyTo(randomColor, time: 0.2)
        Haptics.shared.vibrate(.light)
        
        
        imageView.scaleTo(scaleTo: 1.6, time: 0.3,{
            self.imageView.scaleTo(scaleTo: 1.0, time: 0.3)
        })
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
    
    
    
    func pulseToRhythm(){
        
        for i in 0...pitches.count-1 {
            if i != 0 {
                let current = Sound.shared.playZoneSequencer.currentPosition.minutes*60
                let nextBeat = Sound.shared.playZoneSequencer.nextQuantizedPosition(quantizationInBeats: 0.5).minutes*60
                
                let distance = nextBeat-current
                let time = (i * (60/tempo))/2
                
                Timer.scheduledTimer(withTimeInterval: time+distance, repeats: false) { _ in
                    self.scaleNoteUpAndDown()
                }
            }
        }
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
    
    func glowInandOut(){
        let glow : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        glow.fromValue = 0.0
        glow.toValue = 0.5
        glow.duration = 2.0;
        glow.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        glow.autoreverses = true
        glow.autoreverses = true
        glowingOverlay.layer.add(glow, forKey: "throb")
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
    
    func disconnectOsc(){
        sawWave.disconnectOutput()
        filter.disconnectOutput()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

