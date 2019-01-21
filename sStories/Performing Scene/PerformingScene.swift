import UIKit

class PerformingScene: UIView {
    
    var sackContents = SackContents()
    var playButton : PlayButton?
    
    var background: PerformingBackground?
    weak var delegate : SceneDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackgroundImage()
        //fade the view in
        alpha = 0.0
        changeOpacityOverTime(view: self, time: 1.5, opacity: 1.0, {})
        createPlayButton()
    }
    
    func setupBackgroundImage(){
        let ourFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        background = PerformingBackground(frame: ourFrame)
        addSubview(background!)
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

    @objc func handleMelodyPan(_ sender: UIPanGestureRecognizer){

    }

    @objc func handlePlayTap(_ sender: UITapGestureRecognizer){
        Sound.sharedInstance.playSequencer()
    }

    func fadeTo(view: UIView, time: Double,opacity: CGFloat, _ completion: @escaping () ->()){
        
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                view.alpha = opacity
        },
            completion: {
                _ in
                
                completion()
        })
    }
    
    func fadeOutAndRemove(completion: @escaping ( ) -> ( ) ){
        
        fadeTo(view: self, time: 1.0, opacity: 0.0, {
            self.removeFromSuperview()
            completion()
            
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

