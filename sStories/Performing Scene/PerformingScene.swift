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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackgroundImage()
        
        
        
        alpha = 0.0
        fadeTo(opacity: 1.0, time: 1.5)
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
            timeout()
            playButton?.fadeAndRemove(time: 2.0)
        }
    }
    
    var pictureArraySlot : Int = 0
    
    func switchPicture(){
        if pictureArraySlot <= 8 {
            background?.fadeTo(opacity: 0.0, time: 1.6, {
            self.background?.image = resizedImage(name: "performingImage\(self.pictureArraySlot)")
                self.background?.fadeTo(opacity: 1.0, time: 1.6)
            self.pictureArraySlot += 1
        })
        }
        if pictureArraySlot == 8 {
            pictureArraySlot = 0
        }
    }
    
    func timeout(){
        timer = Timer.scheduledTimer(withTimeInterval: 60/tempo, repeats: false, block:{_ in
            
            self.timeoutCounter += 1
            if self.timeoutCounter < self.timerRepetitions {

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


