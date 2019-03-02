// Pop bubbles to advance the3 story instead of a button! (best if narrated)

// JUST A BACK BUTTON! Then pop up a UIView with all the scenes, just change the dummy slot ones to be the images of the active scene and you have thumbnails ready to go. Each has a picture.

import UIKit

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
}

class ViewController: UIViewController, SceneDelegate {
    
    enum AppState {
        case home
        case story
        case fishing
        case arranging
        case performing
    }
    
    private var currentState = AppState.home
    private var currentPage = 0
    private var tempStoryLine = 0
    private var pageTurnerVisible = false
    
    // All the views
    var homePage : HomePage!
    var aboutPage : AboutPage!
    var page : PageView!
    var catchingMelody : CatchingMelodies!
    var arrangingScene : ArrangingScene!
    var performingScene: PerformingScene!
    var pageTurner : PageTurner!
    
    var bookmarkPage: BookmarkPage!
    var bubbleScore: BubbleScoreView!

    var animator: UIDynamicAnimator!
    let gravityBehavior = UIGravityBehavior()
    let collisionBehavior = UICollisionBehavior()
    
    var bubblesArePlaying = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHomePage()
        createBubbleScore()
        setupAnimator()
        
    }
    
    func setupAnimator(){
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 0)
        animator.addBehavior(gravityBehavior)
        
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
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
            
            let pushBehavior = UIPushBehavior(items: [note], mode: UIPushBehavior.Mode.instantaneous)
            
            let randomDirection = CGFloat.pi / CGFloat.random(in: -0.2...0.2)
            let randomMagnitude = CGFloat.random(in: 0...0.3)
            
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
        view.addSubview(bubbleScore)
        bubbleScore.layer.zPosition = 900
        
        let safe = view.safeAreaLayoutGuide
        bubbleScore.translatesAutoresizingMaskIntoConstraints = false
        bubbleScore.topAnchor.constraint(equalTo: safe.topAnchor).isActive = true
        bubbleScore.leadingAnchor.constraint(equalTo: safe.leadingAnchor).isActive = true
        bubbleScore.heightAnchor.constraint(equalToConstant: view.frame.height/12).isActive = true
        bubbleScore.widthAnchor.constraint(equalToConstant: view.frame.width/12).isActive = true
        
    }
    
    func createBookmark(){
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        bookmarkPage = BookmarkPage(frame: frame)
        view.addSubview(bookmarkPage)
    }
    
    func createHomePage(){
        homePage = HomePage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(homePage)
        homePage.fillSuperview()
        homePage.delegate = self
        homePage.bubblePlayZone.delegate = self
        setupDelegates()
    }
    
    func createAboutPage(){
        aboutPage = AboutPage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(aboutPage)
        aboutPage.fillSuperview()
        aboutPage.delegate = self
        setupDelegates()
    }
    
    func createPageTurner(){
        // Not using autolayout.... tsk tsk
        let width = view.frame.width/12
        let height = view.frame.height
        var x = view.frame.width-width
        let y = CGFloat(0)
        
        if DeviceType.hasNotch {
            x -= 44
        }
        
        pageTurner = PageTurner(frame: CGRect(x: x, y: y, width: width, height: height), currentPage)
        view.addSubview(pageTurner!)
        pageTurner?.delegate = self
        view.bringSubviewToFront(pageTurner!)
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
    
    func nextPage() {
        stopRandomBubbles()
        // If the next page is a regular page
        if page != nil && currentPage < pages.count-1 && currentState == .story {

            page.fadeAndRemove(time: 1.0) {
                self.currentPage+=1
                self.tempStoryLine = 0
                self.createPage()
                self.pageTurnerVisible = false
            }
            // If the current page is the fishing page.
        } else if currentState == .fishing {
            catchingMelody.stopBackgroundSound()
            catchingMelody.fadeAndRemove(time: 1.0) {
                self.currentState = .story
                self.currentPage+=1
                self.tempStoryLine = 0
                self.createPage()
                self.pageTurnerVisible = false
            }
            // If the current page is the arranging page.
        } else if currentState == .arranging {
            arrangingScene.fadeAndRemove(time: 1.0) {
                self.currentState = .story
                self.currentPage+=1
                self.tempStoryLine = 0
                self.createPage()
                self.pageTurnerVisible = false
            }
        } else if currentState == .performing {
            performingScene.fadeAndRemove(time: 1.0) {
                self.currentState = .story
                self.currentPage+=1
                self.tempStoryLine = 0
                self.createPage()
                self.pageTurnerVisible = false
            }
        } else if page != nil && currentPage == pages.count-1 && currentState == .story {
            page.fadeAndRemove(time: 1.0) {
                self.currentPage = 0
                self.tempStoryLine = 0
                self.createHomePage()
                self.pageTurnerVisible = false
            }
            // If the current page is the fishing page.
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
                self.tempStoryLine = 0
                self.createPage()
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
        createPageTurner()
    }
    
    func returnToStoryFromArranging(){
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block:{_ in self.createPageTurner()})
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
            } else if tempStoryLine == pages[currentPage].storyText.count-1 && (page?.canActivate)! && currentState == .story {
                if !pageTurnerVisible {
                    pageTurnerVisible = true
                    createPageTurner()
                    page.expandText()
                    page.canActivate = false
                    page.backButton.fadeOut(1.0)
                    page.nextButton.fadeOut(1.0)
                }
            }
        }
    }
    
    func previousMoment(){
        if page?.superview != nil {
            if tempStoryLine > 0 && page.canActivate && currentState == .story {
                page.previousStoryLine()
                tempStoryLine -= 1
                page.expandText()
            } else if tempStoryLine == 0 && (page?.canActivate)! && currentState == .story {
                    previousPage()
                    page.canActivate = false
            }
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
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
