import UIKit

protocol SceneDelegate : class {
    func returnToStory()
    func nextPage()
    func goToAboutPage()
    func startStory()
    func backHome()
}

class ViewController: UIViewController, SceneDelegate {
    
    enum AppState {
        case home
        case story
        case fishing
        case arranging
        case performing
    }
    
    var currentState = AppState.home
    var currentPage = 0
    private var tempStoryLine = 0

    var homePage : HomePage!
    var aboutPage : AboutPage!
    var page : PageView!
    var catchingMelody : CatchingMelodies!
    var arrangingScene : ArrangingScene!
    var performingScene: PerformingScene!
    var pageTurner : PageTurner!
    var pageTurnerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHomePage()
        
        // create main view tap gesture.
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    func createHomePage(){
        homePage = HomePage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(homePage)
        homePage.fillSuperview()
        homePage.delegate = self
    }
    
    func createAboutPage(){
        aboutPage = AboutPage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(aboutPage)
        aboutPage.fillSuperview()
        aboutPage.delegate = self
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        if page?.superview != nil {
            
            if tempStoryLine < pages[currentPage].storyText.count-1 && (page?.canActivate)! && currentState == .story {
                page?.nextStoryLine()
                tempStoryLine += 1
            } else if tempStoryLine == pages[currentPage].storyText.count-1 && (page?.canActivate)! && currentState == .story {
                if !pageTurnerVisible {
                    print("it's being tapped")
                    pageTurnerVisible = true
                    addPageTurner()
                }
            }
        }
    }
    
    func addPageTurner(){
        
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
    }
    
    func nextPage() {
        
        // If the next page is a regular page
        if page != nil && currentPage < pages.count-1 && (page?.canActivate)! && currentState == .story {
            page.fadeAndRemove(time: 1.0) {
                self.currentPage+=1
                self.tempStoryLine = 0
                self.addPage()
                self.pageTurnerVisible = false
            }
        // If the current page is the fishing page.
        } else if currentState == .fishing {
            catchingMelody.fadeAndRemove(time: 1.0) {
                self.currentState = .story
                self.currentPage+=1
                self.tempStoryLine = 0
                self.addPage()
                self.pageTurnerVisible = false
            }
            // If the current page is the arranging page.
        } else if currentState == .arranging {
            arrangingScene.fadeAndRemove(time: 1.0) {
                self.currentState = .story
                self.currentPage+=1
                self.tempStoryLine = 0
                self.addPage()
                self.pageTurnerVisible = false
            }
        }
    }
    
    func startStory() {
        
        homePage.fadeAndRemove(time: 1.0) {
            self.addPage()
        }
    }
    
    func goToAboutPage() {
        print("going to about page")
        homePage.fadeAndRemove(time: 1.0) {
            self.createAboutPage()
        }
    }
    
    func returnToStory(){
        addPageTurner()
    }
    
    func backHome(){
        aboutPage.fadeAndRemove(time: 1.0) {
            self.createHomePage()
        }
    }
    
    func addPage(){
        
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
        }
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
