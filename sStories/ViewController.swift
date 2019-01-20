/*
 AppDelegate - check
 ViewController - check
 PageView - check
 StoryLine - check
 CatchMelodies - check
 ArrangeMelody
 Sound - check
 Haptics - check
 */

import UIKit

protocol SceneDelegate : class {
    func returnToStory()
    func nextPage()
}

var collectedMelodies = [Melody]() // This is global.

class ViewController: UIViewController, SceneDelegate {

    enum AppScene {
        case story
        case fishing
        case arranging
    }
    var currentState = AppScene.story
    
    var switchToCatchingMelodiesScene = 5
//    var switchToArrangingScene = 0
    
    var switchToArrangingScene = 9
//    var switchToCatchingMelodiesScene = 0
    
    var page : PageView?
    var catchingMelody : CatchingMelodies?
    var arrangingScene : ArrangingScene?
    
    var pageTurner : PageTurner?
    
    var currentPage = 0
    var tempStoryLine = 0
    
    var pageTurnerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillSackWithMelodies()
        
        addPage()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
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
                self.currentPage = 9 // COMMENT OUT AFTER TESTING
                self.currentState = .story
                self.currentPage+=1
                self.tempStoryLine = 0
                self.addPage()
                self.pageTurnerVisible = false
            })
        }
    }
    
    func returnToStory(){
        addPageTurner()
        view.bringSubviewToFront(pageTurner!)
    }
    
    func addPage(){
        
        if currentPage == switchToCatchingMelodiesScene {
            catchingMelody = CatchingMelodies(frame: view.frame)
            view.addSubview(catchingMelody!)
            let safe = view.safeAreaLayoutGuide
            catchingMelody?.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor)
            catchingMelody?.delegate = self
            currentState = .fishing
            
        } else if currentPage == switchToArrangingScene {
            arrangingScene = ArrangingScene(frame: view.frame)
            view.addSubview(arrangingScene!)
            let safe = view.safeAreaLayoutGuide
            arrangingScene?.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor)
            arrangingScene?.delegate = self
            currentState = .arranging
        } else {
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
