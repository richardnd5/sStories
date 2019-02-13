import UIKit

protocol SceneDelegate : class {
    func returnToStory()
    func returnToStoryFromArranging()
    func nextPage()
    func goToAboutPage()
    func startStory()
    func goToHomePage()
    func addToScore()
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHomePage()
        createBubbleScore()
        setupAnimator()
        createRandomBubblesAtRandomTimeInterval()
        
    }
    
    func setupAnimator(){
        animator = UIDynamicAnimator(referenceView: self.view)
        
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 0)
        animator.addBehavior(gravityBehavior)
        
        
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
    }
    
    func generateRandomMusicSymbols(){
        
        let randNum = Int.random(in: 1...1)
        for _ in 0...randNum {
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
            let randomMagnitude = CGFloat.random(in: 0...1)
            
            pushBehavior.setAngle(randomDirection, magnitude: randomMagnitude)
            animator.addBehavior(pushBehavior)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleBubblePop))
            note.addGestureRecognizer(tap)
            
        }
    }
    
    @objc func handleBubblePop(_ sender: UITapGestureRecognizer){
        
        bubbleScore.addToScore()
        
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
    
    var bubbleTimer = Timer()
    
    func createRandomBubblesAtRandomTimeInterval(){
        bubbleTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            let randomNumber = Int.random(in: 0...10)
            if randomNumber == 2 {
                self.generateRandomMusicSymbols()
            }
        })
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
        
        pageTurner = PageTurner(frame: CGRect(x: x, y: y, width: width, height: height))
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
            catchingMelody.stopPondBackground()
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
    
    func startStory() {
        homePage.fadeAndRemove(time: 1.0) {
            self.createPage()
        }
    }
    
    func goToAboutPage() {
        homePage.fadeAndRemove(time: 1.0) {
            self.createAboutPage()
        }
    }
    
    func returnToStory(){
        createPageTurner()
    }
    
    func returnToStoryFromArranging(){
        Timer.scheduledTimer(withTimeInterval: 5.7, repeats: false, block:{_ in self.createPageTurner()})
    }
    
    func goToHomePage(){
        aboutPage.fadeAndRemove(time: 1.0) {
            self.createHomePage()
        }
    }
    
    func createPage(){
        
        if currentPage == switchToCatchingMelodiesScene {
            catchingMelody = CatchingMelodies(frame: view.frame)
            view.addSubview(catchingMelody!)
            catchingMelody?.delegate = self
            currentState = .fishing
            
        } else if currentPage == switchToArrangingScene {
            arrangingScene = ArrangingScene(frame: view.frame)
            view.addSubview(arrangingScene!)
            arrangingScene?.delegate = self
            currentState = .arranging
            
        } else if currentPage == switchToPerformingScene {
            performingScene = PerformingScene(frame: view.frame)
            view.addSubview(performingScene!)
            performingScene?.delegate = self
            currentState = .performing
            
        } else {
            currentState = .story
            page = PageView(frame: view.frame, page: pages[currentPage])
            view.addSubview(page!)
            let safe = view.safeAreaLayoutGuide
            page?.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor)
            
            let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
            press.minimumPressDuration = 0.0
            page.addGestureRecognizer(press)
        }
        if page != nil && currentPage == pages.count-1 && currentState == .story {
            Sound.sharedInstance.playSequencer()
        }
        
    }
    
    @objc func handlePress(_ sender: UITapGestureRecognizer){
        
        
        if sender.state == .began && page.canActivate {
            playSoundClip(.touchDown)
            page.shrinkText()
        }
        // if the page does exist... dun dun dun!!!
        if sender.state == .ended {
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
                    }
                }
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
