/*
 Changing it to a keyboard at the bottom to turn the page.
 Snapping the text and image that you can drag back to the center.
 
 */

import UIKit
import StoreKit

protocol SceneDelegate : class {
    func returnToStory()
    func returnToStoryFromArranging()
    func nextPage()
    func nextMoment()
    func previousMoment()
    func goToAboutPage()
    func startStory()
    func goToHomePage()
    func addToScore()
    func createRandomBubblesAtRandomTimeInterval(time: TimeInterval)
    func stopRandomBubbles()
    func fadeOutTitleAndButtons()
    func fadeInTitleAndButtons()
    func finishedReadingCallback()
    func loadUpTempleton()
}

class TempletonViewController: UIViewController, SceneDelegate {
    
    enum AppState {
        case bookshelfHome
        case templetonFrontPage
        case story
        case fishing
        case arranging
        case performing
    }
    
    var list = [SKProduct]()
    var currentProduct = SKProduct()
    
    private var currentState = AppState.bookshelfHome
    private var currentPage = 0
    private var tempStoryLine = 0
    private var pageTurnerVisible = false
    static var mainStoryLinePosition = 0
    
    var storyReadThrough = false
    
    // All the views
    var homePage : HomePage!
    var aboutPage : AboutPage!
    var page : PageView!
    var catchingMelody : CatchingMelodies!
    var arrangingScene : ArrangingScene!
    var performingScene: PerformingScene!
    var pageTurner : PageTurner!
    var storyFinishedPopUpView : StoryFinishedPopUpView!
    var keyboardTurner : KeyboardTurner!
    var bubbleScore: BubbleScoreView!
    
    var animator: UIDynamicAnimator!
    let gravityBehavior = UIGravityBehavior()
    let collisionBehavior = UICollisionBehavior()
    var bubblesArePlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block:{_ in
            self.loadUpTempleton()
            self.setupAnimator()
        })
    }
    
    func loadUpTempleton(){
        currentState = .templetonFrontPage
        VoiceOverAudio.shared.delegate = self
        self.createHomePage()
        self.createBubbleScore()
    }
    
    func setupAnimator(){
        animator = UIDynamicAnimator(referenceView: self.view)
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 0)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        animator.addBehavior(gravityBehavior)
    }
    
    func generateRandomMusicSymbols(){
        
        let width = view.frame.width/20
        let height = view.frame.width/20
        let x = CGFloat.random(in: view.frame.width/4...view.frame.width-view.frame.width/4)
        let y = CGFloat.random(in: view.frame.height/40...view.frame.height/2-view.frame.height/40)
        let note = MiniPerformingNoteView(frame: CGRect(x: x, y: y, width: width, height: height))
        
        view.addSubview(note)
        gravityBehavior.addItem(note)
        collisionBehavior.addItem(note)
        
        let randomDirection = CGFloat.pi / CGFloat.random(in: -0.2...0.2)
        let randomMagnitude = CGFloat.random(in: 0...0.3)
        let pushBehavior = UIPushBehavior(items: [note], mode: UIPushBehavior.Mode.instantaneous)
        pushBehavior.setAngle(randomDirection, magnitude: randomMagnitude)
        animator.addBehavior(pushBehavior)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBubblePop))
        note.addGestureRecognizer(tap)
        
        view.bringSubviewToFront(note)
    }
    
    @objc func handleBubblePop(_ sender: UITapGestureRecognizer){
        let note = sender.view as! MiniPerformingNoteView
        popBubble(note)
    }
    
    var bubbleTimer = Timer()
    
    func createRandomBubblesAtRandomTimeInterval(time: TimeInterval = 1.0){
        bubblesArePlaying = true
        
        bubbleTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: true, block: { _ in
            let randomNumber = Int.random(in: 0...5)
            if randomNumber == 2 {
                self.generateRandomMusicSymbols()
            }
        })
    }
    
    func popBubble(_ note: MiniPerformingNoteView){
        bubbleScore.addToScore()
        Haptics.shared.vibrate(.light)
        
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
    
    func stopRandomBubbles(){
        bubbleTimer.invalidate()
        bubblesArePlaying = false
        
        view.subviews.forEach { view in
            if view is MiniPerformingNoteView {
                let note = view as! MiniPerformingNoteView
                popBubble(note)
            }
        }
    }
    
    func addToScore(){
        bubbleScore.addToScore()
    }
    
    func createBubbleScore(){
        let frame = CGRect(x: 0, y: 0, width: view.frame.width/10, height: view.frame.height/10)
        bubbleScore = BubbleScoreView(frame: frame)
        bubbleScore.layer.zPosition = 900
        view.addSubview(bubbleScore)
        
        let safe = view.safeAreaLayoutGuide
        bubbleScore.translatesAutoresizingMaskIntoConstraints = false
        bubbleScore.topAnchor.constraint(equalTo: safe.topAnchor).isActive = true
        bubbleScore.leadingAnchor.constraint(equalTo: safe.leadingAnchor).isActive = true
        bubbleScore.heightAnchor.constraint(equalToConstant: view.frame.height/12).isActive = true
        bubbleScore.widthAnchor.constraint(equalToConstant: view.frame.width/12).isActive = true
    }
    
    func createHomePage(){
        homePage = HomePage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(homePage)
        homePage.fillSuperview()
        homePage.delegate = self
        homePage.bubblePlayZone.delegate = self
        setupDelegates()
        
        homePage.homeButton.addTarget(self, action: #selector(showBookshelf), for: .touchUpInside)
        UINavigationController.attemptRotationToDeviceOrientation()
        
        if storyReadThrough {
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.createStoryFinishedPopUpView()
            }
        }
    }
    
    func createStoryFinishedPopUpView(){
            storyFinishedPopUpView = StoryFinishedPopUpView()
            view.addSubview(storyFinishedPopUpView)
            
            storyFinishedPopUpView.translatesAutoresizingMaskIntoConstraints = false
            storyFinishedPopUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            storyFinishedPopUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            storyFinishedPopUpView.widthAnchor.constraint(equalToConstant: view.frame.width/3).isActive = true
            storyFinishedPopUpView.widthAnchor.constraint(equalTo: storyFinishedPopUpView.heightAnchor, multiplier: 1.5).isActive = true

            storyFinishedPopUpView.okayButton.addTarget(self, action: #selector(handlePopUpOkayButtonPressed), for: .touchUpInside)
    }
    
    func removeStoryFinishedPopUpView(){
        if storyFinishedPopUpView.superview != nil {
            storyFinishedPopUpView.shrinkAndRemove(time: 0.5)
        }
    }
    
    func createAboutPage(){
        aboutPage = AboutPage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(aboutPage)
        aboutPage.fillSuperview()
        aboutPage.delegate = self
        setupDelegates()
    }
    
    func createKeyboardTurner(){
        let width = view.frame.width*0.9
        let height = view.frame.height/4
        let bottomPadding = view.frame.height/10
        let x : CGFloat = 0
        var y = view.frame.height-height-bottomPadding
        
        if DeviceType.hasNotch {
            y -= 30
        }
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        keyboardTurner = KeyboardTurner(frame: frame, currentPage)
        keyboardTurner.frame.origin.x = view.frame.width/2-width/2
        
        view.addSubview(keyboardTurner!)
        keyboardTurner?.delegate = self
        view.bringSubviewToFront(keyboardTurner!)
        playSoundClip(.showPageTurner)
    }
    
    func setupDelegates(){
        view.subviews.forEach { view in
            view.subviews.forEach{ v in
                if v is Button {
                    let button = v as! Button
                    button.delegate = self
                }
            }
        }
    }
    
    func incrementNextPage(){
        self.currentPage+=1
        self.tempStoryLine = 0
        self.createPage()
        self.pageTurnerVisible = false
    }
    
    func nextPage() {
        stopRandomBubbles()
        // If the next page is a regular page
        if page != nil && currentPage < pages.count-1 && currentState == .story {
            page.fadeAndRemove(time: 1.0) {
                self.incrementNextPage()
            }
            // If the current page is the fishing page.
        } else if currentState == .fishing {
            catchingMelody.stopBackgroundSound()
            catchingMelody.fadeAndRemove(time: 1.0) {
                self.currentState = .story
                self.incrementNextPage()
            }
            // If the current page is the arranging page.
        } else if currentState == .arranging {
            arrangingScene.fadeAndRemove(time: 1.0) {
                self.currentState = .story
                self.incrementNextPage()
            }
        } else if currentState == .performing {
            performingScene.fadeAndRemove(time: 1.0) {
                self.currentState = .story
                self.incrementNextPage()
            }
        } else if page != nil && currentPage == pages.count-1 && currentState == .story {
            page.fadeAndRemove(time: 1.0) {
                self.currentPage = 0
                self.tempStoryLine = 0
                self.storyReadThrough = true
                self.createHomePage()
                self.pageTurnerVisible = false
            }
        }
    }
    
    func previousPage() {
        stopRandomBubbles()
        // If the next page is a regular page
        if page != nil && currentPage == 0 && currentState == .story{
            page.fadeAndRemove(time: 1.0) {
                self.createHomePage()
            }
        }
        
        if page != nil && currentPage > 0 && currentState == .story {
            page.fadeAndRemove(time: 1.0) {
                self.currentPage-=1
                self.createPage()
                self.tempStoryLine = (self.page.storyText?.count)!-1
                self.pageTurnerVisible = false
            }
        }
        // remove melodies from melody array.
        if page != nil && currentPage == 6 {
            collectedMelodies.removeAll()
        }
    }
    
    func startStory() {
        homePage.fadeAndRemove(time: 1.0) {
            self.storyReadThrough = false
            self.stopRandomBubbles()
            self.createPage()
        }
    }
    
    func goToAboutPage() {
        homePage.fadeAndRemove(time: 1.0) {
            self.stopRandomBubbles()
            self.createAboutPage()
        }
    }
    
    func returnToStory(){
        createKeyboardTurner()
    }
    
    func returnToStoryFromArranging(){
        Timer.scheduledTimer(withTimeInterval: 4.45, repeats: false, block:{_ in self.returnToStory()})
    }
    
    func goToHomePage(){
        aboutPage.fadeAndRemove(time: 1.0) {
            self.stopRandomBubbles()
            self.createHomePage()
        }
    }
    
    func createPage(){
        if currentPage == switchToCatchingMelodiesScene {
            catchingMelody = CatchingMelodies(frame: view.frame)
            view.addSubview(catchingMelody!)
            view.sendSubviewToBack(catchingMelody)
            catchingMelody?.delegate = self
            currentState = .fishing
            
        } else if currentPage == switchToArrangingScene {
            arrangingScene = ArrangingScene(frame: view.frame)
            view.addSubview(arrangingScene!)
            view.sendSubviewToBack(arrangingScene)
            arrangingScene?.delegate = self
            currentState = .arranging
            
        } else if currentPage == switchToPerformingScene {
            performingScene = PerformingScene(frame: view.frame)
            view.addSubview(performingScene!)
            view.sendSubviewToBack(performingScene)
            performingScene?.delegate = self
            currentState = .performing
            
        } else {
            if bubblesArePlaying {
                stopRandomBubbles()
            }
            currentState = .story
            page = PageView(frame: view.frame, page: pages[currentPage])
            view.addSubview(page!)
            let safe = view.safeAreaLayoutGuide
            page?.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor)
            
            page.nextButton.delegate = self
            page.backButton.delegate = self
            
            view.sendSubviewToBack(page)
        }
    }
    
    func nextMoment(){
        if page?.superview != nil {
            if tempStoryLine < pages[currentPage].storyText.count-1 && (page?.canActivate)! && currentState == .story {
                page?.nextStoryLine()
                
                tempStoryLine += 1
                playSoundClip(.nextStoryLine)
                page.expandText()
                TempletonViewController.mainStoryLinePosition += 1
                
            } else if tempStoryLine == pages[currentPage].storyText.count-1 && (page?.canActivate)! && currentState == .story {
                TempletonViewController.mainStoryLinePosition += 1
                
                if currentPage == 0 || currentPage == 8 {
                    if !pageTurnerVisible {
                        pageTurnerVisible = true
                        createKeyboardTurner()
                        page.expandText()
                        page.canActivate = false
                        page.hideNavigationButtons()
                        page.storyTextView.fadeTo(opacity: 0.0, time: 1.0)
                        page.playSoundButton.fadeOut(1.0)
                    }
                } else {
                    nextPage()
                }
            }
            changeAudioOfStoryLineToMainStoryPosition()
        }
    }
    
    func previousMoment(){
        if page?.superview != nil {
            if tempStoryLine > 0 && page.canActivate && currentState == .story {
                page.previousStoryLine()
                TempletonViewController.mainStoryLinePosition -= 1
                tempStoryLine -= 1
                page.expandText()
            } else if tempStoryLine == 0 && (page?.canActivate)! && currentState == .story {
                previousPage()
                
                if TempletonViewController.mainStoryLinePosition > 0 {
                    TempletonViewController.mainStoryLinePosition -= 1
                } else {
                    TempletonViewController.mainStoryLinePosition = 0
                }
                page.canActivate = false
            }
            changeAudioOfStoryLineToMainStoryPosition()
        }
    }
    
    func fadeInTitleAndButtons() {
        if homePage != nil {
            homePage.fadeInTitleAndLabels()
        }
    }
    
    func fadeOutTitleAndButtons(){
        if homePage != nil {
            homePage.fadeOutTitleAndLabels()
        }
    }
    
    func finishedReadingCallback() {
        if page != nil {
            page.showNavigationButtons()
            page.playSoundButton.stopThrobWithAnimation()
            page.nextButton.throbWithWiggle(scaleTo: 1.2, time: 0.6)
        }
    }
    
    func changeAudioOfStoryLineToMainStoryPosition(){
        if TempletonViewController.mainStoryLinePosition >= storyline.count {
            TempletonViewController.mainStoryLinePosition = 0
        }
        VoiceOverAudio.shared.changeAudioFile(to: "readStory\(TempletonViewController.mainStoryLinePosition)")
    }
    
    @objc func showBookshelf(){
        Sound.shared.stopPondBackgroundSound()
        view.fadeTo(opacity: 0.0, time: 0.8, {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            let templetonController = BookshelfViewController()
            templetonController.modalPresentationStyle = .fullScreen
            self.present(templetonController, animated: false)
        })
    }
    
    @objc func handlePopUpOkayButtonPressed(_ sender: UIButton){
        removeStoryFinishedPopUpView()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .landscape
        }
    }
}
