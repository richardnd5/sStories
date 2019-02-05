import UIKit

protocol SceneDelegate : class {
    func returnToStory()
    func returnToStoryFromArranging()
    func nextPage()
    func goToAboutPage()
    func startStory()
    func goToHomePage()
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
    private var currentPage = 9
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHomePage()
        // create main view tap gesture.
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //        view.addGestureRecognizer(tap)
        
        
        
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
