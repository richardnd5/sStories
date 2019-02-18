import UIKit

class PerformingScene: UIView {
    
    var sackContents = SackContents()
    var playButton : PlayButton?
    
    var background: PerformingBackground?
    weak var delegate : SceneDelegate?
    
    var timer = Timer()
    var timeoutCounter : Int = 0
    let timerRepetitions = 48
    var isPlaying = false
    
//    var animator: UIDynamicAnimator!
//    let gravityBehavior = UIGravityBehavior()
//    let collisionBehavior = UICollisionBehavior()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackgroundImage()
        
        alpha = 0.0
        fadeTo(time: 1.5, opacity: 1.0)
        createPlayButton()
    }
    
    func setupBackgroundImage(){
        
        let ourFrame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        background = PerformingBackground(frame: ourFrame)
        addSubview(background!)
        
        
        let safe = safeAreaLayoutGuide
        background?.translatesAutoresizingMaskIntoConstraints = false
        background?.topAnchor.constraint(equalTo: safe.topAnchor).isActive = true
        background?.leadingAnchor.constraint(equalTo: safe.leadingAnchor).isActive = true
        background?.trailingAnchor.constraint(equalTo: safe.trailingAnchor).isActive = true
        background?.bottomAnchor.constraint(equalTo: safe.bottomAnchor).isActive = true
    }
    
    func createPlayButton(){
        
        // Gross. Next time. Learn about dynamically changing auto layout...
        let width = frame.width/6
        let height = frame.height/6
        let x = frame.width/2-width/2
        let y = frame.height/1.2-height
        
        playButton = PlayButton(frame: CGRect(x: x, y: y, width: width, height: height))
        addSubview(playButton!)
        
        playButton?.anchor(top: nil, leading: nil, trailing: nil, bottom: safeAreaLayoutGuide.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: -frame.height/3.6, right: 0), size: CGSize(width: width, height: height))
        playButton?.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePlayTap))
        playButton?.addGestureRecognizer(tap)
        
    }

    @objc func handlePlayTap(_ sender: UITapGestureRecognizer){
        if !isPlaying {
            isPlaying = true
            Sound.sharedInstance.playSequencer()
            delegate?.createRandomBubblesAtRandomTimeInterval(1.0)
            timeout()
            playButton?.fadeAndRemove(time: 2.0)
        }
    }
    
    var pictureArraySlot : Int = 0
    
    func switchPicture(){
        if pictureArraySlot <= 3 {
        background?.fadeTo(time: 1.6, opacity: 0.0, {
            self.background?.image = resizedImage(name: "performingImage\(self.pictureArraySlot)")
            self.background?.fadeTo(time: 1.6, opacity: 1.0)
            self.pictureArraySlot += 1
        })
        }
        if pictureArraySlot == 3 {
            pictureArraySlot = 0
        }
    }
    
    func timeout(){
        timer = Timer.scheduledTimer(withTimeInterval: 60/tempo, repeats: false, block:{_ in
            
            self.timeoutCounter += 1
            if self.timeoutCounter < self.timerRepetitions {
//                if self.timeoutCounter % 4 == 0 {
//                    self.generateRandomMusicSymbols()
//                }

                if self.timeoutCounter % 8 == 0 {
                    self.switchPicture()
                }
                self.timeout()
            } else {
                self.timeoutCounter = 0
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                    self.delegate!.returnToStory()
                })
            }
            
        })
    }
    
//    func generateRandomMusicSymbols(){
//
//        let randNum = Int.random(in: 1...1)
//        for _ in 0...randNum {
//            let width = frame.width/20
//            let height = frame.width/20
//            let x = CGFloat.random(in: frame.width/4...frame.width-frame.width/4)
//            let y = CGFloat.random(in: frame.height/40...frame.height/2-frame.height/40)
//            let note = MiniPerformingNoteView(frame: CGRect(x: x, y: y, width: width, height: height))
//            addSubview(note)
//            gravityBehavior.addItem(note)
//            collisionBehavior.addItem(note)
//
//            let pushBehavior = UIPushBehavior(items: [note], mode: UIPushBehavior.Mode.instantaneous)
//
//            let randomDirection = CGFloat.pi / CGFloat.random(in: -0.2...0.2)
//            let randomMagnitude = CGFloat.random(in: 0...1)
//
//            pushBehavior.setAngle(randomDirection, magnitude: randomMagnitude)
//            animator.addBehavior(pushBehavior)
//
//            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//            note.addGestureRecognizer(tap)
//
//        }
//    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        let note = sender.view as! MiniPerformingNoteView
        note.shrinkRotateAndRemove()
        
        let randomClip = Int.random(in: 0...2)
        switch randomClip {
        case 0:
            playPitchedClip(.waterPlink)
        case 1:
            playPitchedClip(.fishingThrowbackDrop)
        case 2:
            playPitchedClip(.fishingThrowbackDrag)
        default:
            playPitchedClip(.waterPlink)
        }

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


