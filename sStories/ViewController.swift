// gonna try merging.
// Merge two!!

import UIKit

protocol SceneDelegate : class {
    func returnToStory()
    func nextPage()
    func goToAboutPage()
    func startStory()
}

var collectedMelodies = [Melody]() // This is global.

class ViewController: UIViewController, SceneDelegate {

    

    enum AppScene {
        case home
        case story
        case fishing
        case arranging
        case performing
    }
    var currentState = AppScene.home
    
    var currentPage = 0
    private var tempStoryLine = 0
    
    var switchToCatchingMelodiesScene = 5
//    var switchToArrangingScene = 0
    
    var switchToArrangingScene = 9
//    var switchToCatchingMelodiesScene = 0
    
    var switchToPerformingScene = 11
    
    var page : PageView?
    var catchingMelody : CatchingMelodies?
    var arrangingScene : ArrangingScene?
    var performingScene: PerformingScene?
    
    var pageTurner : PageTurner?
    
    var homePage : HomePage!
    

    
    var pageTurnerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fillSackWithMelodies()
        
//        addPage()
        createHomePage()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)

    }
    
    func createHomePage(){
        homePage = HomePage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(homePage)
        homePage.fillSuperview()
        homePage.isUserInteractionEnabled = true
        homePage.delegate = self
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        if page?.superview != nil {
        if tempStoryLine < pages[currentPage].storyText.count-1 && (page?.canActivate)! && currentState == .story {
            page?.nextStoryLine()
            tempStoryLine+=1
        } else if tempStoryLine == pages[currentPage].storyText.count-1 && (page?.canActivate)! && currentState == .story {
            if !pageTurnerVisible {
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
        if page != nil && currentPage < pages.count-1 && (page?.canActivate)! && currentState == .story {
            page?.fadeOutAndRemove(completion: {
                self.currentPage+=1
                self.tempStoryLine = 0
                self.addPage()
                self.pageTurnerVisible = false
            })
        } else if currentState == .fishing {
            catchingMelody!.fadeOutAndRemove(completion: {
                self.currentState = .story
                self.currentPage+=1
                self.tempStoryLine = 0
                self.addPage()
                self.pageTurnerVisible = false
            })
        } else if currentState == .arranging {
            arrangingScene!.fadeOutAndRemove(completion: {
//                self.currentPage = 9 // COMMENT OUT AFTER TESTING
                self.currentState = .story
                self.currentPage+=1
                self.tempStoryLine = 0
                self.addPage()
                self.pageTurnerVisible = false
            })
        }
    }
    
    func startStory() {
        homePage.fadeOutAndRemove {
            self.addPage()
        }
        
    }
    
    func goToAboutPage() {
        print("going to about page")
    }
    
    func returnToStory(){
        addPageTurner()
        view.bringSubviewToFront(pageTurner!)
    }
    
    func addPage(){
        
        if currentPage == switchToCatchingMelodiesScene {
            catchingMelody = CatchingMelodies(frame: view.frame)
            view.addSubview(catchingMelody!)
//            let safe = view.safeAreaLayoutGuide
//            catchingMelody?.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor)
            catchingMelody?.delegate = self
            currentState = .fishing
            
        } else if currentPage == switchToArrangingScene {
            arrangingScene = ArrangingScene(frame: view.frame)
            view.addSubview(arrangingScene!)
//            let safe = view.safeAreaLayoutGuide
//            arrangingScene?.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor)
            arrangingScene?.delegate = self
            currentState = .arranging
        } else if currentPage == switchToPerformingScene {
            performingScene = PerformingScene(frame: view.frame)
            view.addSubview(performingScene!)
//            let safe = view.safeAreaLayoutGuide
//            performingScene?.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor)
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
